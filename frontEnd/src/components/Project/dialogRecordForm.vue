<template>
      <el-dialog title="项目得分" :visible.sync="visible">
        <el-form :model="projectRcd" :rules="rules" ref="form">
          <el-form-item label="项目名称：" label-width="120px" required>
            <el-input v-model="projectDetail.projectname" auto-complete="off" :disabled="true"></el-input>
          </el-form-item>
          <el-form-item label="服务态度：" prop="atitude" label-width="120px">
            <el-radio-group v-model="projectRcd.atitude">
              <el-radio v-for="(value, key, index) in atitudes" :label="key" :title="value" name="atitudes"></el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="完成时间：" prop="fnstime" label-width="120px">
            <el-radio-group v-model="projectRcd.fnstime">
              <el-radio v-for="(value, key, index) in fnstimes" :label="key" :title="value"></el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="完成效果：" prop="fnseffect" label-width="120px">
            <el-radio-group v-model="projectRcd.fnseffect">
              <el-radio v-for="(value, key, index) in fnseffects" :label="key" :title="value"></el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="实际调整：" prop="adjust" label-width="120px">
            <el-radio-group v-model="projectRcd.adjust">
              <el-radio v-for="(value, key, index) in adjusts" :label="key" :title="value"></el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="改进贡献：" prop="creative" label-width="120px">
            <el-radio-group v-model="projectRcd.creative">
              <el-radio v-for="(value, key, index) in creatives" :label="key" :title="value"></el-radio>
            </el-radio-group>
          </el-form-item>
            <div content-position="right">项目得分总计：{{ itemsTotal }}</div>
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
  name: 'dialogRecordForm',
  data() {
    return {
      atitudes: {
        '消极沟通': 0.8,
        '无沟通': 1,
        '积极沟通': 1.2
      },
      fnstimes: {
        '延期': 0.5,
        '按期': 1,
        '提前': 1.5
      },
      fnseffects: {
        '达到预期': 1,
        '超出预期': 1.2
      },
      adjusts: {
        '难度降低': 0.8,
        '无变化': 1,
        '难度提高': 1.3
      },
      creatives: {
        '无': 1,
        '指出错误': 1.1,
        '局部改进建议': 1.2,
        '重大改进方案': 1.5
      },
      visible: false,
      projectRcd: {
        'id': 0,
        'atitude': '无沟通',
        'fnstime': '按期',
        'fnseffect': '达到预期',
        'adjust': '无变化',
        'creative': '无',
        'itemsTotal': 1
      },
      rules: {
        atitude: [
          { required: true, message: '请给服务态度打分', trigger: 'change' }
        ],
        fnstime: [
          { required: true, message: '请给完成时间打分', trigger: 'change' }
        ],
        fnseffect: [
          { required: true, message: '请给完成效果打分', trigger: 'change' }
        ],
        adjust: [
          { required: true, message: '请选择实际难度调整', trigger: 'change' }
        ],
        creative: [
          { required: true, message: '请给主动创新打分', trigger: 'change' }
        ]
      }
    }
  },
  props: ['rvisible', 'projectDetail'],
  computed: {
    itemsTotal: function () {
      let itemsTotal = 1
      if (this.projectRcd.atitude) {
        itemsTotal *= this.atitudes[this.projectRcd.atitude]
      }
      if (this.projectRcd.fnstime) {
        itemsTotal *= this.fnstimes[this.projectRcd.fnstime]
      }
      if (this.projectRcd.fnseffect) {
        itemsTotal *= this.fnseffects[this.projectRcd.fnseffect]
      }
      if (this.projectRcd.adjust) {
        itemsTotal *= this.adjusts[this.projectRcd.adjust]
      }
      if (this.projectRcd.creative) {
        itemsTotal *= this.creatives[this.projectRcd.creative]
      }
      itemsTotal = itemsTotal.toFixed(2)
      itemsTotal = itemsTotal.replace(/0+$/, '').replace(/\.$/, '')
      this.projectRcd.itemsTotal = itemsTotal
      return itemsTotal
    }
  },
  methods: {
    submitForm (formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.apiPut('/admin/project_rcd/', this.projectRcd.id, this.projectRcd).then(res => {
            if (res.code != 200) {
              this.$message.error(res.error)
            }
            this.$emit('update-form', this.projectRcd)
            this.resetForm(formName)
          })
        } else {
          console.log('error submit!!')
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
        this.projectRcd = { ...this.projectDetail.projectRcd } // 重置
        this.$emit('cancel-form')
      }
    },
    rvisible: function() {
      this.visible = this.rvisible
    },
    // 监控从父组件而来的变动，更新到本子组件
    projectDetail: {
      handler(newVal, oldVal) {
        this.projectRcd = { ...newVal.projectRcd }
      },
      deep: true
    }
  },
  mixins: [http]
}
</script>

<style scoped>
</style>
