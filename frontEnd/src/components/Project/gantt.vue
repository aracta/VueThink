<template>
  <div class="w-p100">
    <dialog-filter-form :websites="websites" :demanders="demanders" :developers="developers" :isgantt="true" @projectsFilter="projectsFilter"></dialog-filter-form>
    <div class="wl-gantt-demo mt-20">
      <wlGantt
        ref="wl-gantt-demo"
        lazy
        use-real-time
        :start-date="startDate"
        :end-date="endDate"
        date-type="monthAndDay"
        :showWeekDay="true"
        :checkSource="true"
        :data="tableData"
        :contextMenuOptions="contextMenuOptions"
        :show-start-date="false"
        :show-end-date="false"
        :ganttOnly="false"
        :edit="false"
      ></wlGantt>
    </div>
  </div>
</template>

<script>
import http from '../../assets/js/http'
import formMixin from '../../assets/js/form_com'
import dialogFilterForm from './dialogFilterForm.vue'
export default {
  name: 'gantt',
  components: {
    dialogFilterForm
  },
  data () {
    return {
      originTableData: [],
      tableData: [], // 数据
      createMonth: new Date(),
      contextMenuOptions: [
        { label: '任务名称', prop: 'name' },
        { label: '任务简介', prop: 'description' },
        { label: '网站', prop: 'website' },
        { label: '需求人', prop: 'demander' },
        { label: '开发者', prop: 'developer' }
      ]
    }
  },
  created() {
    this.fetchData()
  },
  computed: {
    websites: function() {
      let websites = {}
      for (let i = 0, len = this.tableData.length; i < len; i++) {
        if (this.tableData[i].website) {
          this.tableData[i].website.forEach((wb, index) => {
            websites[wb] = wb
          })
        }
      }
      return websites
    },
    demanders: function() {
      let demanders = {}
      for (let i = 0, len = this.tableData.length; i < len; i++) {
        demanders[this.tableData[i].demander] = this.tableData[i].demander
      }
      return demanders
    },
    developers: function() {
      let developers = {}
      for (let i = 0, len = this.tableData.length; i < len; i++) {
        developers[this.tableData[i].developer] = this.tableData[i].developer
      }
      return developers
    },
    startDate: function() {
      // 固定每月1日为起点，不支持从其他日开始
      // let d = this.createMonth // Date是一种引用复制
      let d = new Date(this.createMonth.getTime())
      d.setDate(1)
      return d.toLocaleDateString().replace(/\//g, '-')
    },
    endDate: function() {
      // let d = this.createMonth
      let d = new Date(this.createMonth.getTime())
      d.setDate(1)
      d.setMonth(d.getMonth() + 1)
      let e_d = new Date(d - 24 * 3600 * 1000)
      return e_d.toLocaleDateString().replace(/\//g, '-')
    }
  },
  methods: {
    projectsFilter (formInline) {
      // 月份不一致时，需要通过 API 重新获取数据
      if (formInline.param_createmonth && (formInline.param_createmonth.getTime() !== this.createMonth.getTime())) {
        this.createMonth = formInline.param_createmonth
        this.fetchData()
      }
      this.tableData = []
      // 筛选
      this.originTableData.forEach(row => {
        // 项目名称
        if (formInline.param_name.trim()) {
          let p_arr = formInline.param_name.trim().replace(/\s+/g, ' ').split(' ')
          let i = 0
          for (let p in p_arr) {
            if (row.projectname.indexOf(p_arr[p]) >= 0) {
              break
            } else {
              i++
            }
          }
          if (i == p_arr.length) {
            return false
          }
        }
        // 目标网站
        if (formInline.param_website && !row.website.includes(formInline.param_website)) {
          return false
        }
        // 需求人
        if (formInline.param_demander && row.demander != formInline.param_demander) {
          return false
        }
        // 开发者
        if (formInline.param_develop && row.developer != formInline.param_develop) {
          return false
        }
        // 创建时间 判断是否属于该月份
        /*
        if (formInline.param_createmonth) {
          let param_createmonth = formInline.param_createmonth.getMonth()
          let row_createmonth = new Date(row.createtime).getMonth()
          if (param_createmonth !== row_createmonth) {
            return false
          }
        }
        */
        // 状态
        if (formInline.param_status !== '' && row.status != formInline.param_status) {
          return false
        }
        this.tableData.push(row)
      })
      this.$message({
        message: '项目查询成功！',
        type: 'success'
      })
    },
    fetchData() {
      this.apiPost('/admin/projects/month', this.createMonth).then(res => {
        if (res.code != 200) {
          this.$message.error(res.error)
          return
        }
        _g.closeGlobalLoading()
        if (res.data.length) {
          res.data.forEach((row, index) => {
            row.name = row.projectname
            row.startDate = new Date(row.createtime).toLocaleDateString().replace(/\//g, '-')
            row.endDate = new Date(row.deadline).toLocaleDateString().replace(/\//g, '-')
            if (row.finishedtime) {
              row.realStartDate = row.startDate
              row.realEndDate = new Date(row.finishedtime).toLocaleDateString().replace(/\//g, '-')
            }
            if (row.website) {
              row.website = row.website.split(',')
            }
            row.index = index
          })
        }
        this.originTableData = this.tableData = res.data
      })
    }
  },
  mixins: [http, formMixin]
}
</script>

<style scope>
.w-p100{
  width: 100% !important;
}
.mt-20{
  margin-top: 20px;
}
.wl-gantt-demo .cell div:nth-child(2) {
  font-size: 80%;
}
</style>