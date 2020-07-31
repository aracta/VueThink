<template>
      <el-dialog title="项目信息" :visible.sync="dialogFormVisible">
        <el-form :model="projectRow" :rules="rules" ref="form">
          <el-form-item label="项目名称" prop="projectname" label-width="120px" required>
            <el-input v-model="projectRow.projectname" auto-complete="off"></el-input>
          </el-form-item>
          <el-form-item label="项目简介" prop="description" label-width="120px" required>
            <el-input v-model="projectRow.description" auto-complete="off" type="textarea" autosize></el-input>
          </el-form-item>
          <el-form-item label="需求人" prop="demander" label-width="120px" required>
            <el-autocomplete v-model="projectRow.demander" :fetch-suggestions="querySearch" @select="handleSelect"></el-autocomplete>
          </el-form-item>
          <el-form-item label="创建时间" label-width="120px">
            <el-input v-model="projectRow.createtime" auto-complete="off" readonly disabled></el-input>
          </el-form-item>
          <el-form-item label="截止时间" label-width="120px">
            <el-input v-model="projectRow.deadline" auto-complete="off" readonly disabled></el-input>
          </el-form-item>
          <el-form-item label="完成时间" prop="finishedtime" label-width="120px">
            <el-col :span="24">
              <el-form-item prop="finishedtime">
                <el-date-picker type="datetime" placeholder="选择时间" v-model="projectRow.finishedtime" @change="finishedtimeChange" :picker-options="pickerOption"></el-date-picker>
                <span class="c-light-gray">(设置完成时间，即表示该项目已完成)</span>
              </el-form-item>
            </el-col>
          </el-form-item>
          <el-form-item label="项目状态" prop="status" label-width="120px">
            <el-switch v-model="projectRow.status" active-text="已完成" inactive-text="未完成" :active-value="1" :inactive-value="0" :width="80" @change="statusChange"></el-switch>
                <span class="c-light-gray">(项目完成和难度评分后，方可项目评分)</span>
          </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
          <el-button @click="dialogFormVisible = false">取 消</el-button>
          <el-button type="primary" @click="editProject()">确 定</el-button>
        </div>
      </el-dialog>
</template>

<script>
import http from '../../assets/js/http'
export default {
  name: 'dialogEditprojectForm',
  data() {
    return {
      dialogFormVisible: false,
      projectRow: {},
      pickerOption: {
        disabledDate (time) {
          return time.getTime() > Date.now()
        }
      },
      rules: {
        projectname: [
          { required: true, message: '请填写项目名称', trigger: 'blur' }
        ],
        description: [
          { required: true, message: '请填写项目简介', trigger: 'blur' }
        ],
        demander: [
          { required: true, message: '请填写需求人', trigger: 'blur' }
        ],
        finishedtime: [
          { validator: (rule, value, callback) => {
            let createtime = new Date(this.projectRow.createtime)
            if (!value && this.projectRow.status) {
              callback(new Error('请填写完成时间'))
            }
            if ((new Date(value)) < createtime && this.projectRow.status) {
              callback(new Error('完成时间 不得早于 创建时间'))
            }
            callback()
          }, trigger: 'change' }
        ]
      }
    }
  },
  props: ['evisible', 'projectCurrentRow', 'demanders'],
  methods: {
    querySearch(queryString, callback) {
      let results = []
      for (let demander in this.demanders) {
        if (queryString) {
          if (demander.indexOf(queryString) === 0) {
            results.push({ value: demander })
          }
        } else {
          results.push({ value: demander })
        }
      }
      callback(results)
    },
    handleSelect (item) {
      console.log(item)
    },
    editProject () {
      this.$refs['form'].validate((valid) => {
        if (valid) {
          // this.isLoading = !this.isLoading
          this.apiPut('/admin/projects/', this.projectRow.id, this.projectRow).then(res => {
            /*
            this.handelResponse(res, (data) => {
              _g.toastMsg('success', '编辑成功')
              setTimeout(() => {
                this.goback()
              }, 1500)
            }, () => {
                this.isLoading = !this.isLoading
            })
            */
            if (res.code != 200) {
              this.$message.error(res.error)
              return
            }
            this.$message({
              message: '修改"' + this.projectRow.projectname + '"成功！',
              type: 'success'
            })
            this.dialogFormVisible = false
            this.$emit('update-form', this.projectRow)
          })
        } else {
          return false
        }
      })
    },
    finishedtimeChange () {
      let createtime = new Date(this.projectRow.createtime)
      let deadline = new Date(this.projectRow.deadline)
      if (this.projectRow.finishedtime > deadline) {
        this.$confirm('完成时间 已经晚于 截止时间，确定该项目是“延期完成”吗？', '警告', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        })
        /*
        .then(() => {
          // 如果设置了 finishedtime ，则 status 要设置为 1
          if (this.projectRow.finishedtime) {
            this.projectRow.status = 1
          } else {
            this.projectRow.status = 0
          }
        })
        */
        .catch(() => {
          this.projectRow.finishedtime = ''
          this.projectRow.status = 0
        })
      }
      // 如果设置了 finishedtime ，则 status 要设置为 1
      if (this.projectRow.finishedtime) {
        this.projectRow.status = 1
      } else {
        this.projectRow.status = 0
      }
    },
    statusChange () {
      if (this.projectRow.status && !this.projectRow.finishedtime) {
        this.projectRow.finishedtime = new Date()
      } else if (!this.projectRow.status && this.projectRow.finishedtime) {
        this.projectRow.finishedtime = ''
      }
    }
  },
  watch: {
    dialogFormVisible: function() {
      if (!this.dialogFormVisible) {
        this.$emit('cancel-form')
      }
    },
    evisible: function() {
      this.dialogFormVisible = this.evisible
    },
    projectCurrentRow: {
      handler(newVal, oldVal) {
        this.projectRow = { ...newVal }
      },
      deep: true
    }
  },
  mixins: [http]
}

</script>