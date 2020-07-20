<template>
      <el-dialog title="难度评分" :visible.sync="visible">
        <el-form :model="projectDfcltrcd" :rules="rules" ref="form">
          <el-form-item label="项目名称：" label-width="120px" required>
            <el-input v-model="projectCurrentRow.projectname" auto-complete="off" :disabled="true"></el-input>
          </el-form-item>
          <el-form-item label="技术栈：" prop="techtypes" label-width="120px">
            <el-checkbox-group v-model="projectDfcltrcd.techtypes">
            <el-checkbox v-for="(value, key, index) in allTechtypes" :label="key" :title="value"></el-checkbox>
            </el-checkbox-group>
            <div>技术栈得分小计：{{ techTotal }}</div>
          </el-form-item>
          <el-form-item label="业务类型：" prop="prjtype" label-width="120px">
            <el-radio-group v-model="projectDfcltrcd.prjtype">
            <el-radio v-for="(value, key, index) in prjtypes" :label="key" :title="value" style="padding:10px 0"></el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="项目工期：" prop="urgency" label-width="120px">
            <el-radio-group v-model="projectDfcltrcd.urgency">
              <el-radio v-for="(value, key, index) in urgencies" :label="key" :title="value"></el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="项目经验：" prop="experience" label-width="120px">
            <el-radio-group v-model="projectDfcltrcd.experience">
              <el-radio v-for="(value, key, index) in experiences" :label="key" :title="value"></el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="开发者角色：" prop="role" label-width="120px">
            <el-radio-group v-model="projectDfcltrcd.role">
              <el-radio v-for="(value, key, index) in roles" :label="key" :title="value"></el-radio>
            </el-radio-group>
          </el-form-item>
            <div content-position="right">难度评分总计：{{ techsTotal }}</div>
        </el-form>
        <div slot="footer" class="dialog-footer">
          <el-button @click="cancelForm">取 消</el-button>
          <el-button type="primary" @click="submitForm('form')">确 定</el-button>
        </div>
      </el-dialog>
</template>

<script>
import http from '../../assets/js/http'
export default {
  name: 'dialogDifficultyForm',
  data() {
    return {
      allTechtypes: {
        'CSS/CSS3': 10,
        'JS/jQuery': 15,
        'Html/H5': 15,
        '微信开发': 20,
        '小程序': 25,
        'Vue': 30,
        'PHP': 15,
        'MySQL': 15,
        'Redis': 25,
        'Memcache': 15,
        'Apache/Nginx': 20,
        'Linux': 30,
        'CDN': 10,
        'FTP': 10
      },
      prjtypes: {
        'EDM/签名档等非官网业务': 50,
        '单页面改版/翻新': 80,
        '单页面全新制作': 100,
        '样式优化': 20,
        'SEO优化': 20,
        '数据处理': 50,
        '单功能点开发/优化/修改': 50,
        '多功能点开发/优化/修改': 100,
        '整站开发': 500
      },
      scales: {
        '单功能点': 1,
        '多功能点': 2,
        '整站': 3
      },
      urgencies: {
        '无期限': 0.5,
        '适度宽松': 0.9,
        '适度缩紧': 1.1,
        '紧急': 1.5
      },
      experiences: {
        '重复': 0.6,
        '参考': 1.2,
        '全新': 1.5
      },
      roles: {
        '辅助': 0.4,
        '协同': 0.5,
        '主导': 0.8,
        '包干': 1.2
      },
      visible: false,
      projectDfcltrcd: {
        'id': 0,
        'techtypes': [],
        'prjtype': '',
        'scale': '',
        'urgency': '',
        'experience': '',
        'role': '',
        'techTotal': 0,
        'techsTotal': 0
      },
      rules: {
        techtypes: [
          { type: 'array', required: true, message: '请至少选择一个技术栈', trigger: 'change' }
        ],
        prjtype: [
          { required: true, message: '请选择业务类型', trigger: 'change' }
        ],
        scale: [
          { required: true, message: '请选择项目大小', trigger: 'change' }
        ],
        urgency: [
          { required: true, message: '请选择项目工期', trigger: 'change' }
        ],
        experience: [
          { required: true, message: '请选择项目经验', trigger: 'change' }
        ],
        role: [
          { required: true, message: '请选择开发者角色', trigger: 'change' }
        ]
      }
    }
  },
  props: ['dvisible', 'projectCurrentRow'],
  computed: {
    techTotal: function () {
      let techTotal = 0
      for (let j = 0, len = this.projectDfcltrcd.techtypes.length; j < len; j++) {
        techTotal += this.allTechtypes[this.projectDfcltrcd.techtypes[j]]
      }
      this.projectDfcltrcd.techTotal = techTotal
      return techTotal
    },
    techsTotal: function () {
      let techsTotal = this.techTotal
      /*
      if(this.projectDfcltrcd.scale){
        techsTotal = this.techTotal * this.scales[this.projectDfcltrcd.scale]
      }
      */
      if (this.projectDfcltrcd.prjtype) {
        techsTotal += this.prjtypes[this.projectDfcltrcd.prjtype]
      }
      if (this.projectDfcltrcd.urgency) {
        techsTotal *= this.urgencies[this.projectDfcltrcd.urgency]
      }
      if (this.projectDfcltrcd.experience) {
        techsTotal *= this.experiences[this.projectDfcltrcd.experience]
      }
      if (this.projectDfcltrcd.role) {
        techsTotal *= this.roles[this.projectDfcltrcd.role]
      }
      techsTotal = techsTotal.toFixed(2)
      techsTotal = techsTotal.replace(/0+$/, '').replace(/\.$/, '')
      this.projectDfcltrcd.techsTotal = techsTotal
      return techsTotal
    }
  },
  methods: {
    submitForm (formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          // 数组转换
          let put_arr = { ...this.projectDfcltrcd }
          put_arr.techtypes = put_arr.techtypes.join(',')
          this.apiPut('/admin/project_dfcltrcd/', put_arr.id, put_arr).then(res => {
            if (res.code != 200) {
              this.$message.error(res.error)
              return
            }
            let dfcltRcd = { ...this.projectDfcltrcd }
            this.$emit('update-form', dfcltRcd)
            this.$refs['form'].resetFields()
          })
        } else {
          return false
        }
      })
    },
    resetForm (formName) {
      this.$refs[formName].resetFields()
    },
    cancelForm () {
      this.visible = false
    }
  },
  watch: {
    visible: function() {
      if (!this.visible) {
        this.projectDfcltrcd = { ...this.projectCurrentRow.projectDfcltrcd } // 重置
        this.$emit('cancel-form')
      }
    },
    dvisible: function() {
      this.visible = this.dvisible
    },
    projectCurrentRow: {
      handler(newVal, oldVal) {
        this.projectDfcltrcd = { ...newVal.projectDfcltrcd }
      },
      deep: true
    }
  },
  mixins: [http]
}
</script>

<style scoped>
</style>
