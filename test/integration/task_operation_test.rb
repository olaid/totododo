require 'test_helper'

class TaskOperationTest < ActionDispatch::IntegrationTest

  def setup
    @task = tasks(:task1)
  end

  test "task add finish delete" do

    get root_path

    #タスクがあることの確認
    assert_not Task.all.empty?

    #完タスク取得テスト
    get api_tasks_path, params:{is_done: 1}
    4.times do |n|
      assert_match "task#{n*2+1}", @response.body.to_s
    end

    #現タスク取得テスト
    get api_tasks_path, params:{is_done: 0}
    4.times do |n|
      assert_match "task#{n*2}", @response.body.to_s
    end

    #タスクの追加
    post api_tasks_path params:{task:{name: "aaa"}}
    assert_response :created

    #タスクを完タスクへ移す
    patch api_task_path(@task.id), params:{task:{is_done: true}}
    assert_response :ok

    #タスクを削除する
    post api_tasks_path params:{task:{name: ""}}
    assert_response :unprocessable_entity

    #タスクを現タスクに移す
    patch api_task_path(@task.id), params:{task:{is_done: false}}
    assert_response :ok
  end
end
