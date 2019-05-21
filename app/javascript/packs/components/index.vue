<template>
  <div>
    <!-- 新規作成部分 -->
    <div class="row">
      <div class="col s10 m11">
        <input v-model="newTask" class="form-control" placeholder="Add your task!!">
      </div>
      <div class="col s2 m1">
        <div v-on:click="createTask" class="btn-floating waves-effect waves-light red">
          <i class="material-icons">add</i>
        </div>
      </div>
    </div>
    <!-- リスト表示部分 -->
    <div>
      <ul class="collection">
        <li v-for="task in tasks" v-if="!task.is_done" class="collection-item">
          <label>
            <input type="checkbox" v-on:change.stop.prevent="doneTask(task.id)" />
            <span>{{ task.name }}</span>
          </label>
        </li>
      </ul>
    </div>
    <!-- 完了済みタスク表示ボタン -->
    <div class="btn" v-on:click="displayFinishedTasks">Display finished tasks</div>
    <!-- 完了済みタスク一覧 -->
    <div id="finished-tasks" class="display_none">
      <ul class="collection">
        <li v-for="task in tasks" v-if="task.is_done" class="collection-item">
          <label>
            <input type="checkbox" v-on:change.stop.prevent="reTask(task.id)" checked="checked" />
            <span>{{ task.name }}</span>
          </label>
        </li>
      </ul>
    </div>
  </div>
</template>
<script>
  import axios from 'axios';

  export default {
    data: function () {
      return {
        tasks: [],
        newTask: ''
      }
    },
    mounted: function () {
      this.fetchTasks();
    },
    methods: {
      fetchTasks: function () {
        axios.get('/api/tasks').then((response) => {
          this.tasks = response.data.tasks;
        }, (error) => {
          console.log(error);
        });
      },
      displayFinishedTasks: function() {
        document.querySelector('#finished-tasks').classList.toggle('display_none');
      },
      createTask: function () {
        if (!this.newTask) return;
        
        axios.post('/api/tasks', { task: { name: this.newTask } }).then((response) => {
          this.tasks.unshift(response.data.task);
          this.newTask = '';
        }, (error) => {
          console.log(error);
        });
      },
      doneTask: function (task_id) {
        axios.put('/api/tasks/' + task_id, { task: { is_done: 1 } }).then((response) => {
          this.fetchTasks();
        }, (error) => {
          console.log(error);
        });
      },
      reTask: function (task_id) {
        axios.put('/api/tasks/' + task_id, { task: { is_done: 0 } }).then((response) => {
          this.fetchTasks();
        }, (error) => {
          console.log(error);
        });
      }
    }
  }
</script>