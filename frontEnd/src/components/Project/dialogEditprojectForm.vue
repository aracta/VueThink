<template>
      <el-dialog title="项目信息" :visible.sync="dialogFormVisible">
        <el-form :model="projectRow">
          <el-form-item label="项目名称" label-width="120px" required>
            <el-input v-model="projectRow.projectname" auto-complete="off"></el-input>
          </el-form-item>
          <el-form-item label="项目简介" label-width="120px" required>
            <el-input v-model="projectRow.description" auto-complete="off" type="textarea" autosize></el-input>
          </el-form-item>
          <el-form-item label="需求人" label-width="120px" required>
            <el-input v-model="projectRow.demander" auto-complete="off"></el-input>
          </el-form-item>
          <el-form-item label="完成时间" label-width="120px">
            <el-col :span="24">
              <el-form-item prop="date1">
                <el-date-picker type="datetime" placeholder="选择时间" v-model="projectRow.finishedtime"  :picker-options="pickerOption"></el-date-picker>
                <span>设置完成时间，即表示该项目已完成</span>
              </el-form-item>
            </el-col>
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
      }
    }
  },
  props: ['evisible', 'projectCurrentRow'],
  methods: {
    editProject () {
      // 如果设置了 finishedtime ，则 status 要设置为 1
      if (this.projectRow.finishedtime) {
        this.projectRow.status = 1
      }
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