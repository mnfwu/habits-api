class Api::V1::StepsController < Api::V1::BaseController
  before_action :find_step, only: %i[update show destroy]

  def index
    @steps = Step.all
  end

  def show; end

  def create
    @step = Step.new(step_params)
    if @step.save
      render json: @step
    else
      render_error
    end
  end

  def update
    if @step.update(step_params)
      @habit = Habit.find(@step.habit_id)
      @master_habit = MasterHabit.find(@habit.master_habit_id)
      update_habit(@habit)
      update_mh(@habit)
      update_user(@master_habit)
      render json: @step
    else
      render_error
    end
  end

  def destroy
    @step.destroy
  end

  def show_habit_steps
    @steps = Step.where("habit_id = #{params[:habit_id]}")
  end

  private

  def step_params
    params.require(:step).permit(:name, :step_type, :completed, :habit_id)
  end

  def find_step
    @step = Step.find(params[:id])
  end

  def render_error
    render json: { errors: @step.errors.full_messages },
      status: :unprocessable_entity
  end

### finds habit and runs logic if its completed, partially completed, or missed.
  def update_habit(h)
    h.steps_completed = h.steps.where("completed = true").length
    h.save!
  end

  def update_mh(h)
    master_habit = MasterHabit.find(h.master_habit_id)
    habits = Habit.where("master_habit_id = #{master_habit.id}").where("week = #{h.week}")
    habits.each do |habit| 
      check_habit(habit)
      habit.save!
    end
    completed_rate = (habits.where("completed = true").length / habits.length.to_f) * 100
    habits.each do |habit| 
      habit.weekly_percent_complete = completed_rate
      habit.save!
    end
    master_habit.percent_complete = completed_rate
    master_habit.save!
  end

  def check_habit(h)
    if h.steps_completed == h.total_steps
       h.completed = true
       h.partially_completed = false
       h.missed = false
    else
      h.completed = nil
      h.partially_completed = nil
      h.missed = nil
    end
    date = Date.today
    if date > h.due_date
      if h.steps_completed > 0 && h.steps_completed < h.total_steps
        h.partially_completed = true
        h.missed = false
        h.completed = false
      elsif h.steps_completed == 0
        h.missed = true
        h.partially_completed = false
        h.completed = false
      end
    end
    h.save!
  end

  def update_user(m)
    user = User.find(m.user_id)
    master_habits = MasterHabit.where("user_id = #{user.id}")
    total_completed = 0
    total_habits = 0
    week = Date.today.strftime('%-V')
    master_habits.each do |mh|
      total_completed += mh.habits.where("completed = true").where("week = #{week}").length
      total_habits += mh.habits.where("week = #{week}").length
    end
    user.weekly_average = ((total_completed / total_habits.to_f) * 100).round(1)
    user.save!
  end

end
