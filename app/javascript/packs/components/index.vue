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
      <draggable v-model="nowTasks" elements="ul" class="collection" @end="dragEnd">
        <li v-for="task in nowTasks" :key="task.id" :id="task.id" class="collection-item">
          <label>
            <input type="checkbox" v-on:click="doneTask(task)" />
            <span>{{ task.name }}</span>
          </label>
        </li>
      </draggable>
    </div>
    <!-- 完了済みタスク表示ボタン -->
    <div class="btn" v-on:click="displayFinishedTasks">Display finished tasks</div>
    <!-- 完了済みタスク一覧 -->
    <div id="finished-tasks" class="display_none ">
      <draggable elements="ul" class="collection draggable" v-model="finishedTasks">
        <li v-for="task in finishedTasks" :key="task.id" :id="task.id" class="collection-item">
          <label>
            <input type="checkbox" v-on:click="doneTask(task)" checked="checked" />
            <span>{{ task.name }}</span>
          </label>
        </li>
      </draggable>
    </div>
  </div>
</template>
<script>
  import axios from 'axios';
  import draggable from 'vuedraggable';

  export default {
    components: {
      draggable,
    },
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
      },
      dragEnd: function (e) {
        //console.log(e)
        //alert(e.item.id)
        ////旧前置のタスクに次のタスクを紐付け
        //console.log(this.nowTasks[e.oldIndex-1].id)
        //console.log(this.nowTasks[e.newIndex].next_task )
        //if( this.nowTasks[e.oldIndex-1] && this.nowTasks[e.oldIndex+1] ) {
        //  axios.put('/api/tasks/' + this.nowTasks[e.oldIndex-1].id , { task: { next_task: this.nowTasks[e.newIndex].next_task } }).then((response) => {
        //    this.fetchTasks();
        //  }, (error) => {
        //    console.log(error);
        //  });
        //}
        ////今タスクに次のタスクを紐付け
        ////nowTasks最後は完了タスクのはじめの値が入っている
        //console.log(this.nowTasks[e.newIndex].id )
        //console.log(this.nowTasks[e.newIndex-1].next_task )
        //if( this.nowTasks[e.newIndex] ){
        //  axios.put('/api/tasks/' + this.nowTasks[e.newIndex].id , { task: { next_task: this.nowTasks[e.newIndex-1].next_task } }).then((response) => {
        //    this.fetchTasks();
        //  }, (error) => {
        //    console.log(error);
        //  });
        //}
        ////現前置タスクに次タスクを紐付け
        //console.log(this.nowTasks[e.newIndex-1].id)
        //console.log(this.nowTasks[e.newIndex].id )
        //if( this.nowTasks[e.newIndex-1] ){
        //  axios.put('/api/tasks/' + this.nowTasks[e.newIndex-1].id , { task: { next_task: this.nowTasks[e.newIndex].id } }).then((response) => {
        //    this.fetchTasks();
        //  }, (error) => {
        //    console.log(error);
        //  });
        //}
        var new_bef
        if( e.newIndex-1>=0 ){
          new_bef = this.nowTasks[e.newIndex-1].id
        }
        else{
          new_bef = -1
        }
        axios.put('/api/tasks/' + this.nowTasks[e.newIndex].id , { task: { new_bef_task: new_bef } }).then((response) => {
          this.fetchTasks();
        }, (error) => {
          console.log(error);
        });  
      }
    }
  }
</script>