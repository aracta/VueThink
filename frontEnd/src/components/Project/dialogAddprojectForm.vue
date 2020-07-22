<template>
      <el-dialog title="创建项目" :visible.sync="visible">
        <el-form :model="form" :rules="rules" ref="form">
          <el-form-item label="项目名称" prop="projectname" label-width="120px" required>
            <el-input v-model="form.projectname" auto-complete="off"></el-input>
          </el-form-item>
          <el-form-item label="目标网站" prop="website" label-width="120px" required>
            <el-select v-model="form.website" multiple placeholder="请选择目标网站">
              <el-option v-for="item in websites" :key="item" :label="item" :value="item"></el-option>
            </el-select><span class="c-light-gray">(*一经创建不可再修改)</span>
          </el-form-item>
          <el-form-item label="项目简介" prop="description" label-width="120px" required>
            <el-input v-model="form.description" auto-complete="off" type="textarea"></el-input>
          </el-form-item>
          <el-form-item label="需求人" prop="demander" label-width="120px" required>
            <el-autocomplete v-model="form.demander" :fetch-suggestions="querySearch"></el-autocomplete>
          </el-form-item>
          <el-form-item label="开发者" prop="developer" label-width="120px" required>
            <el-input v-model="form.developer" auto-complete="off" readonly></el-input>
          </el-form-item>
          <el-form-item label="创建时间" prop="createtime" label-width="120px" required>
            <el-date-picker type="datetime" placeholder="选择时间" v-model="form.createtime"></el-date-picker><span class="c-light-gray">(*一经创建不可再修改)</span>
          </el-form-item>
          <el-form-item label="截止时间" prop="deadline" label-width="120px" required>
            <el-date-picker type="datetime" placeholder="选择时间" v-model="form.deadline"></el-date-picker><span class="c-light-gray">(*一经创建不可再修改)</span>
          </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
          <el-button @click="cancelForm()">取 消</el-button>
          <el-button type="primary" @click="submitForm('form')">确 定</el-button>
        </div>
      </el-dialog>
</template>

<script>
import http from '../../assets/js/http'
export default {
  name: 'dialogAddprojectForm',
  data() {
    return {
      visible: false,
      websites: ['biofavor.cn', 'chundebio.com', 'elabscience.cn', 'elabscience.com', 'procell.com.cn', 'sci-meds.com', 'unscience.cn', 'usciencecorp.com'],
      form_origin: {},
      form: {
        projectname: '',
        website: [],
        description: '',
        demander: '',
        developer: Lockr.get('userInfo').realname,
        createtime: new Date(),
        deadline: ''
      },
      rules: {
        projectname: [
          { required: true, message: '请填写项目名称', trigger: 'blur' }
        ],
        website: [
          { type: 'array', required: true, message: '请选择目标网站', trigger: 'change' }
        ],
        description: [
          { required: true, message: '请填写项目简介', trigger: 'blur' }
        ],
        demander: [
          { required: true, message: '请填写需求人', trigger: 'blur' }
        ],
        developer: [
          { required: true, message: '请填写开发者', trigger: 'blur' }
        ],
        createtime: [
          { type: 'date', required: true, message: '请填写创建时间', trigger: 'blur' }
        ],
        deadline: [
          { type: 'date', required: true, message: '请填写截止时间', trigger: 'blur' },
          { validator: (rule, value, callback) => {
            if (value <= this.form.createtime) {
              callback(new Error('截止时间不能晚于创建时间'))
            } else {
              callback()
            }
          }, trigger: 'change' }
        ]
      }
    }
  },
  props: ['avisible', 'demanders'],
  created: function () {
    this.form_origin = { ...this.form }
  },
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
    submitForm (formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          let project = { ...this.form }
          project.website = project.website.join(',')
          project.createtime = project.createtime.toJSON().split('T')[0].replace(/\//g, '-') + ' ' + project.createtime.toTimeString().split(' ')[0]
          project.deadline = project.deadline.toJSON().split('T')[0].replace(/\//g, '-') + ' ' + project.deadline.toTimeString().split(' ')[0]
          this.apiPost('/admin/projects/', project).then(res => {
            if (res.code != 200) {
              this.$message.error(res.error)
              return
            }
            project.id = res.data // 7ckf 返回ID
            project.website = project.website.split(',')
            this.$emit('update-form', project)
            this.form = { ...this.form_origin }
            this.$refs['form'].resetFields()
          })
        } else {
          return false
        }
      })
    },
    cancelForm () {
      this.visible = false
      this.$emit('cancel-form')
    }
  },
  watch: {
    visible: function() {
      if (!this.visible) {
        this.$emit('cancel-form')
      }
    },
    avisible: function() {
      this.visible = this.avisible
      // 重置 createtime
      if (this.visible) {
        this.form.createtime = new Date()
      }
    }
  },
  mixins: [http]
}
</script>

<style scoped>
</style>
