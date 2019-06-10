class Api::TasksController < ApplicationController

  # GET /tasks
  def index

    @tasks = Task.find_by_sql(['
      with
        recursive p(
          id,name,is_done,next_task,created_at,updated_at,level
        ) 
      as
        (
          select
            id, 
            name,
            is_done,
            next_task,
            created_at,
            updated_at, 
            1 
          from
            tasks i 
          where
            next_task = -1
          union all select
            s.id, 
            s.name,
            s.is_done,
            s.next_task,
            s.created_at,
            s.updated_at, 
            p.level + 1
          from
            tasks s, p 
          where
            p.id = s.next_task
        )
      select * from p where is_done=? order by level desc
      ', params[:is_done]])
  end

  # POST /tasks
  def create
    @min_id = Task.find_by_sql(['
      select
        id 
      from 
        tasks
      where
        id not in (
          select
            next_task
          from
            tasks
          where
            next_task is not null
        ) '])
    @task = Task.new(name: task_params[:name],next_task: @min_id[0].id)

    if @task.save
      render :show, status: :created
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/1
  def update
    @task = Task.find(params[:id])
    #優先度更新
    if !!task_params[:new_bef_task]
      new_beftask = Task.find_by(id: task_params[:new_bef_task])
      old_beftask = Task.find_by(next_task: params[:id])

      #上書きされる前に取得
      task_next = @task.next_task
      !!new_beftask ?  new_next = new_beftask.next_task : new_next = Task.find_by_sql(['
        select
          id 
        from 
          tasks
        where
          id not in (
            select
              next_task
            from
              tasks
            where
              next_task is not null
          )
      '])[0].id

      #一意性を保つために変更
      old_beftask.update(next_task: -2) if !!old_beftask

      #更新
      new_beftask.update(next_task: @task.id) if !!new_beftask
      @task.update(next_task: new_next)
      old_beftask.update(next_task: task_next) if !!old_beftask

      render :show, status: :ok

    #完了フラグ更新
    elsif @task.update(task_params)
      render :show, status: :ok
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.fetch(:task, {}).permit(
          :name, :is_done, :new_bef_task
      )
    end
end
