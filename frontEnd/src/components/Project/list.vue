<template>
  <div class="w-100">
    <dialog-filter-form :websites="websites" :demanders="demanders" :developers="developers" @projectsFilter="projectsFilter" @showProjectForm="showProjectForm"></dialog-filter-form>
    <el-card class="mt-20">
      <el-table
        :data="pageTableData()"
        class="w-100">
        <el-table-column label="项目名称">
          <template slot-scope="scope">
            <el-popover trigger="hover" placement="top">
              <p><b>项目简介:</b><div v-for="ds in scope.row.description.split('\n')">{{ ds }}</div></p>
              <span slot="reference" class="name-wrapper">{{ scope.row.projectname }}</span>
            </el-popover>
          </template>
        </el-table-column>
        <el-table-column label="目标网站" width="150" align="center" prop="website" :filters="website_fitlers" :filter-method="filterWebsite">
          <template scope="scope">
            <div v-for="site in scope.row.website">{{ site }}</div>
          </template>
        </el-table-column>
        <el-table-column label="需求人" width="100" align="center" prop="demander" :filters="demander_fitlers" :filter-method="filterDemander" sortable>
        </el-table-column>
        <el-table-column label="开发者" width="100" align="center" prop="developer" :filters="developer_fitlers" :filter-method="filterDeveloper" sortable>
        </el-table-column>
        <el-table-column label="创建时间" align="center" width="110" icon="time" prop="createtime" sortable></el-table-column>
        <el-table-column label="截止时间" align="center" width="110" icon="time" prop="deadline" sortable>
          <template scope="scope">
            <el-tooltip v-if="isDelayed(scope.row)" effect="light" placement="top" class="c-red">
              <div slot="content">项目超时<span v-if="scope.row.finishedtime">完成，完成时间：{{ scope.row.finishedtime }}</span><span v-else>未完成</span></div>
              <span class="c-red">{{ scope.row.deadline }}<el-icon v-if="!scope.row.finishedtime" name="warning"></el-icon></span>
            </el-tooltip>
            <el-tooltip v-else-if="isNearDelayed(scope.row)" content="项目临近截止时间！" effect="light" placement="top" class="c-orange">
              <span class="c-orange"><el-icon name="warning"></el-icon>{{ scope.row.deadline }}</span>
            </el-tooltip>
            <span v-else>{{ scope.row.deadline }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="90" align="center" :filters="[{text:'未完成',value:0},{text:'已完成',value:1}]" :filter-method="filterStatus" sortable>
          <template slot-scope="scope">
            <el-tag size="medium" :type="scope.row.status==1?'success':'gray'">{{ status(scope.row.status) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="难度评分" prop="projectDfcltrcd.techsTotal" width="140" align="center" sortable>
          <template slot-scope="scope">
            <el-button
              size="mini"
              @click="handleDifficulty(scope.$index, scope.row)">难度评分 {{ scope.row.projectDfcltrcd.techsTotal }}
            </el-button>
          </template>
        </el-table-column>
        <el-table-column label="项目得分" prop="prjtotal" width="140" align="center" sortable>
          <template slot-scope="scope">
            <el-button
              v-if="scope.row.status && scope.row.projectDfcltrcd.techsTotal"
              size="mini"
              :title="scope.row.projectRcd.itemsTotal"
              @click="handleRcd(scope.$index, scope.row)">项目得分 {{ scope.row.prjtotal }}
            </el-button>
            <el-tooltip v-else content="难度评分且项目完成后，方可评分" effect="light" placement="top" class="c-light-gray">
                <el-icon name="information"></el-icon>
            </el-tooltip>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" width="160">
          <template slot-scope="scope">
            <el-button
              size="mini"
              @click="handleEdit(scope.$index, scope.row)">编辑
            </el-button>
            <el-button slot="reference" class="ml-10"
              size="mini"
              type="danger"
              @click="handleDelete(scope.$index, scope.row)">删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>
      <el-row align="middle" id="monthTotal">
        <el-col :span="24">本月绩效得分总计：{{ monthTotal }} 分</el-col>
      </el-row>
      <el-pagination
        class="mt-20"
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
        background
        :current-page="currentPage"
        :page-sizes="[15, 30, 50]"
        :page-size="pageSize"
        layout="total, sizes, prev, pager, next, jumper"
        :total="pageTotal">
      </el-pagination>
      <dialog-addproject-form :avisible="avisible" :demanders="demanders" @update-form="addProject" @cancel-form="cancelAddprojectForm" ></dialog-addProject-form>
      <dialog-editproject-form v-if="projectCurrentRow" :project-current-row="projectCurrentRow" :evisible="evisible" :demanders="demanders" @cancel-form="cancelEditprojectForm" @update-form="editProject"></dialog-editproject-form>
      <dialog-difficulty-form v-if="projectCurrentRow" :project-current-row="projectCurrentRow" :dvisible="dvisible" @cancel-form="cancelDifficultyForm" @update-form="updateDifficultyForm"></dialog-difficulty-form>
      <dialog-record-form v-if="projectCurrentRow" :project-detail="projectCurrentRow" :rvisible="rvisible" @cancel-form="cancelRcdForm" @update-form="updateRcdForm"></dialog-record-form>
    </el-card>
  </div>
</template>

<script>
import dialogFilterForm from './dialogFilterForm.vue'
import dialogAddprojectForm from './dialogAddprojectForm.vue'
import dialogEditprojectForm from './dialogEditprojectForm.vue'
import dialogDifficultyForm from './dialogDifficultyForm.vue'
import dialogRecordForm from './dialogRecordForm.vue'
import http from '../../assets/js/http'
import formMixin from '../../assets/js/form_com'

export default {
  name: 'projectsList',
  components: {
    dialogFilterForm, dialogEditprojectForm, dialogAddprojectForm, dialogDifficultyForm, dialogRecordForm
  },
  data () {
    return {
      originTableData: [],
      tableData: [],
      currentPage: 1,
      pageSize: 50,
      pageTotal: 0,
      projectCurrentRow: {},
      createMonth: new Date(),
      avisible: false, // addProject-form
      dvisible: false, // difficulty-form
      rvisible: false, // record-form
      evisible: false // editproject-form
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
      if (formInline.param_createmonth && (formInline.param_createmonth.getTime() !== this.createMonth.getTime())) {
        this.createMonth = formInline.param_createmonth
        // TODO: 这里存在一个异步下载延迟
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
            // 7ckf 初始化
            if (!row.projectDfcltrcd) {
              row.projectDfcltrcd = {
                'id': row.id,
                'techtypes': [],
                'prjtype': '',
                'scale': '',
                'urgency': '',
                'experience': '',
                'role': '',
                'techTotal': 0,
                'techsTotal': 0
              }
            }
            if (!row.projectRcd) {
              row.projectRcd = {
                'id': row.id,
                'atitude': '',
                'fnstime': '',
                'fnseffect': '',
                'adjust': '',
                'creative': '',
                'itemsTotal': ''
              }
            }
            if (row.website) {
              row.website = row.website.split(',')
            }
            // if (row.description) {
            //   row.description = row.description.split('\n')
            // }
            row.index = index
          })
        }
        this.originTableData = this.tableData = res.data
        this.projectCurrentRow = this.tableData[0] // 默认
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
.w-100{
  width: 100%!important
}
.mt-20{
  margin-top: 20px;
}
.ml-10{
  margin-left:10px
}
.c-red {
  color: red
}
.c-orange {
  color: orange
}
#monthTotal{
  text-align:right;padding:15px;padding-right:140px;border:1px solid #dfe6ec;border-top:0
}
</style>
