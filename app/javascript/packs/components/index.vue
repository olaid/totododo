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
        <li v-for="task in nowTasks" :key="task.id" class="collection-item">
          <label>
            <input type="checkbox" v-on:click="doneTask(task)" />
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
        <li v-for="task in finishedTasks" :key="task.id" class="collection-item">
          <label>
            <input type="checkbox" v-on:click="doneTask(task)" checked="checked" />
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
        finishedTasks: [],
        nowTasks: [],
        newTask: ''
      }
    },
    mounted: function () {
      this.fetchTasks();
    },
    methods: {
      fetchTasks: function () {
        axios.get('/api/tasks?is_done=0').then((response) => {
          this.nowTasks = response.data.tasks;
        }, (error) => {
          console.log(error);
        });
        axios.get('/api/tasks?is_done=1').then((response) => {
          this.finishedTasks = response.data.tasks;
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
          this.nowTasks.unshift(response.data.task);
          this.newTask = '';
        }, (error) => {
          console.log(error);
        });
      },
      doneTask: function (task) {
        axios.put('/api/tasks/' + task.id, { task: { is_done: !task.is_done } }).then((response) => {
          this.fetchTasks();
        }, (error) => {
          console.log(error);
        });
      }
    }
  }
</script>