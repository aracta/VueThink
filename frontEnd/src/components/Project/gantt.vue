<template>
    <div class="wl-gantt-demo">
      <wlGantt
        ref="wl-gantt-demo"
        lazy
        use-real-time
        :start-date="startDate()"
        :end-date="endDate()"
        date-type="monthAndDay"
        :checkSource="true"
        :data="tableData"
        :contextMenuOptions="contextMenuOptions"
        :ganttOnly="false"
        :edit="false"
      ></wlGantt>
    </div>
</template>

<script>
import http from '../../assets/js/http'
import formMixin from '../../assets/js/form_com'

export default {
  name: 'projectsList',
  data () {
    return {
      tableData: [], // 数据
      createMonth: new Date(),
      contextMenuOptions: [
        { label: '任务名称', prop: 'name' },
        { label: '开始时间', prop: 'startDate' },
        { label: '结束时间', prop: 'endDate' }
      ]
    }
  },
  created() {
    this.fetchData()
  },
  computed: {
    monthTotal: function() {
      let monthTotal = 0
      this.tableData.forEach((row, index) => {
        if (row.prjtotal > 0) {
          monthTotal += parseFloat(row.prjtotal)
        }
      })
      return this.toFixed(monthTotal)
    },
    websites: function() {
      let websites = {}
      for (let i = 0, len = this.originTableData.length; i < len; i++) {
        if (this.originTableData[i].website) {
          this.originTableData[i].website.forEach((wb, index) => {
            websites[wb] = wb
          })
        }
      }
      return websites
    },
    website_fitlers: function() {
      let website_fitlers = []
      for (let i in this.websites) {
        website_fitlers.push({ text: i, value: i })
      }
      return website_fitlers
    },
    demanders: function() {
      let demanders = {}
      for (let i = 0, len = this.originTableData.length; i < len; i++) {
        demanders[this.originTableData[i].demander] = this.originTableData[i].demander
      }
      return demanders
    },
    demander_fitlers: function() {
      let demander_fitlers = []
      for (let i in this.demanders) {
        demander_fitlers.push({ text: i, value: i })
      }
      return demander_fitlers
    },
    developers: function() {
      let developers = {}
      for (let i = 0, len = this.originTableData.length; i < len; i++) {
        developers[this.originTableData[i].developer] = this.originTableData[i].developer
      }
      return developers
    },
    developer_fitlers: function() {
      let developer_fitlers = []
      for (let i in this.developers) {
        developer_fitlers.push({ text: i, value: i })
      }
      return developer_fitlers
    }
  },
  methods: {
    startDate () {
      var d = new Date()
      d.setDate(1)
      return d.toLocaleDateString().replace(/\//g, '-')
    },
    endDate () {
      var d = new Date()
      d.setDate(1)
      d.setMonth(d.getMonth() + 1)
      var l_d = new Date(d - 24 * 3600 * 1000)
      return l_d.toLocaleDateString().replace(/\//g, '-')
    },
    filterWebsite (value, row) {
      return row.website.includes(value)
    },
    filterDemander (value, row) {
      return row.demander == value
    },
    filterDeveloper (value, row) {
      return row.developer == value
    },
    filterStatus (value, row) {
      return row.status == value
    },
    isDelayed (row) {
      // 是否延期/超时未完成 是，返回 true
      let deadline = new Date(row.deadline)
      let finishedtime = row.finishedtime ? new Date(row.finishedtime) : new Date()
      if (deadline < finishedtime) {
        return true
      } else {
        return false
      }
    },
    isNearDelayed (row) {
      if (row.finishedtime) {
        return false
      }
      // 是否临近超时（24小时） 是，返回 true
      let deadline = new Date(row.deadline)
      let now = new Date()
      let warn_time = 24 * 3600 * 1000
      if (now - deadline < warn_time) {
        return true
      } else {
        return false
      }
    },
    status (status) {
      switch (status) {
        case 1 :
          return '已完成'
        default:
          return '未完成'
      }
    },
    projectsFilter (formInline) {
      // 月份不一致时，需要通过 API 重新获取数据
      if (formInline.param_createmonth && formInline.param_createmonth.getMonth() !== this.createMonth.getMonth()) {
        this.createMonth = formInline.param_createmonth
        this.fetchData()
      }
      this.tableData = []
      this.pageTotal = 0
      this.currentPage = 1
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
        if (formInline.param_createmonth) {
          let param_createmonth = formInline.param_createmonth.getMonth()
          let row_createmonth = new Date(row.createtime).getMonth()
          if (param_createmonth !== row_createmonth) {
            return false
          }
        }
        // 状态
        if (formInline.param_status !== '' && row.status != formInline.param_status) {
          return false
        }
        this.tableData.push(row)
        this.pageTotal ++
      })
      this.$message({
        message: '项目查询成功！',
        type: 'success'
      })
    },
    fetchData() {
      // this.apiGet('/admin/projects/', { 'month': this.createMonth.getMonth() }).then(res => {
      this.apiPost('/admin/projects/month', this.createMonth).then(res => {
        if (res.code != 200) {
          this.$message.error(res.error)
          return
        }
        _g.closeGlobalLoading()
        this.pageTotal = res.data.length
        if (res.data.length) {
          res.data.forEach((row, index) => {
            row.name = row.projectname
            row.startDate = new Date(row.createtime).toLocaleDateString().replace(/\//g, '-')
            row.endDate = new Date(row.deadline).toLocaleDateString().replace(/\//g, '-')
            if (row.finishedtime) {
              row.realStartDate = row.startDate
              row.realEndDate = new Date(row.finishedtime).toLocaleDateString().replace(/\//g, '-')
            }
            row.index = index
          })
        }
        this.tableData = res.data
        console.log(res.data)
      })
    },
    pageTableData: function() {
      return this.tableData.slice((this.currentPage - 1) * this.pageSize, this.currentPage * this.pageSize)
    },
    handleDifficulty (index, row) {
      this.dvisible = true
      this.projectCurrentRow = row
    },
    updateDifficultyForm(projectDfcltrcd) {
      this.projectCurrentRow.projectDfcltrcd = { ...projectDfcltrcd }
      if (this.projectCurrentRow.projectRcd.itemsTotal) {
        this.projectCurrentRow.prjtotal = this.projectCurrentRow.projectRcd.itemsTotal * this.projectCurrentRow.projectDfcltrcd.techsTotal
        this.projectCurrentRow.prjtotal = this.toFixed(this.projectCurrentRow.prjtotal)
        // 更新项目总得分
        this.apiPut('/admin/projects/', this.projectCurrentRow.projectRcd.id, this.projectCurrentRow).then(res => {
          if (res.code != 200) {
            this.$message.error(res.code)
            return
          }
          this.cancelRcdForm()
        })
      }
      this.cancelDifficultyForm()
    },
    // 新增项目
    addProject(project) {
      project.projectDfcltrcd = {
        'id': project.id,
        'techtypes': [],
        'prjtype': '',
        'scale': '',
        'urgency': '',
        'experience': '',
        'role': '',
        'techTotal': 0,
        'techsTotal': 0
      }
      project.projectRcd = {
        'id': project.id,
        // 'prjtype': '',
        'atitude': '',
        'fnstime': '',
        'fnseffect': '',
        'adjust': '',
        'creative': '',
        'itemsTotal': ''
      }
      project.index = this.tableData.length
      this.tableData.push(project)
      this.cancelAddprojectForm()
    },
    editProject(projectRow) {
      // this.projectCurrentRow = { ...projectRow } // 无效
      this.tableData[projectRow.index] = { ...projectRow }
    },
    cancelAddprojectForm() {
      this.avisible = false
    },
    cancelDifficultyForm() {
      this.dvisible = false
    },
    handleRcd (index, row) {
      this.rvisible = true
      this.projectCurrentRow = row
    },
    updateRcdForm(projectRcd) {
      this.projectCurrentRow.projectRcd = { ...projectRcd }
      this.projectCurrentRow.prjtotal = this.projectCurrentRow.projectRcd.itemsTotal * this.projectCurrentRow.projectDfcltrcd.techsTotal
      this.projectCurrentRow.prjtotal = this.toFixed(this.projectCurrentRow.prjtotal)
      // 更新项目总得分
      this.apiPut('/admin/projects/', this.projectCurrentRow.projectRcd.id, this.projectCurrentRow).then(res => {
        if (res.code != 200) {
          this.$message.error(res.code)
          return
        }
        this.cancelRcdForm()
      })
      // 更新本月绩效得分
      this.monthTotal()
    },
    cancelRcdForm() {
      this.rvisible = false
    },
    // 新增项目窗口
    showProjectForm () {
      this.avisible = true
    },
    handleEdit (index, row) {
      this.projectCurrentRow = row
      this.evisible = true
    },
    cancelEditprojectForm () {
      this.evisible = false
    },
    handleDelete (index, row) {
      this.$confirm('此操作将永久删除该项目，是否继续？', '警告', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.apiDelete('/admin/projects/', row.id).then(res => {
          if (res.code != 200) {
            this.$message.error(res.error)
            return
          }
          this.tableData.splice(index + (this.currentPage - 1) * this.pageSize, 1)
          this.pageTotal = this.tableData.length
          this.$message({
            message: '删除"' + row.projectname + '"成功！',
            type: 'success'
          })
        })
      }).catch(() => {
        // console.log("操作取消")
      })
    },
    handleSizeChange (size) {
      this.pagesize = size
    },
    handleCurrentChange (currentPage) {
      this.currentPage = currentPage
    },
    toFixed (num) {
      return parseFloat(num).toFixed(2).replace(/0+$/, '').replace(/\.$/, '')
    }
  },
  mixins: [http, formMixin]
}
</script>

<style scoped>
.c-red {
  color: red
}
.c-orange {
  color: orange
}
.wl-gantt .wl-item-start:after {
  z-index: initial!important;
}
.wl-gantt .wl-item-end:after {
  z-index: initial!important;
}
.wl-gantt .wl-item-full:after, .wl-gantt .wl-item-full:before{
  z-index: initial!important;
}
</style>
