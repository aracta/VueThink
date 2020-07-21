<template>
    <el-card>
      <el-form :inline="true" :model="formInline" ref="formInline" :rules="rules">
        <el-form-item label="项目名称：" prop="param_name">
          <el-input v-model="formInline.param_name" placeholder="项目名称" icon="close" :on-icon-click="clearParamName"></el-input>
        </el-form-item>
        <el-form-item label="目标网站：" prop="param_website">
          <el-select v-model="formInline.param_website" placeholder="目标网站" style="width:140px">
            <el-option label="目标网站" value=""></el-option>
            <el-option v-for="website in websites" :label="website" :value="website"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="需求人：" prop="param_demander">
          <el-select v-model="formInline.param_demander" placeholder="需求人" style="width:100px">
            <el-option label="需求人" value=""></el-option>
            <el-option v-for="demander in demanders" :label="demander" :value="demander"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="开发者：" prop="param_develop">
          <el-select v-model="formInline.param_develop" placeholder="开发者" style="width:100px">
            <el-option label="开发者" value=""></el-option>
            <el-option v-for="developer in developers" :label="developer" :value="developer"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="创建时间：" prop="param_createmonth">
          <el-date-picker v-model="formInline.param_createmonth" type="month" placeholder="选择月" :picker-options="pickerOption" style="width:100px">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="状态：" prop="param_status">
          <el-select v-model="formInline.param_status" placeholder="项目状态" style="width:100px">
            <el-option label="项目状态" value=""></el-option>
            <el-option label="已完成" value="1"></el-option>
            <el-option label="未完成" value="0"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="projectsFilter()">查询</el-button>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="plus" @click="showProjectForm()">新增项目</el-button>
        </el-form-item>
      </el-form>
    </el-card>
</template>
<script>
export default {
  name: 'dialogFilterForm',
  data() {
    return {
      pickerOption: {
        disabledDate (time) {
          return time.getTime() > Date.now() - 8.64e7 // true 表示该 time 被设为禁用
        }
      },
      formInline: {
        param_name: '', // 项目名称
        param_website: '', // 目标网站
        param_demander: '', // 需求人
        param_develop: '', // 开发者
        param_createmonth: new Date(), // 创建时间
        param_status: '' // 项目状态
      },
      rules: {
        /*
        param_name: [
          { required: true, message: '请输入', trigger: 'blur' },
          { min: 3, max: 5, message: '长度在 3 到 5 个字符', trigger: 'blur' }
        ],
        param_demander: [
          { required: true, message: '请选择', trigger: 'change' }
        ]
        */
      }
    }
  },
  props: ['websites', 'demanders', 'developers'],
  methods: {
    clearParamName (ev) {
      this.formInline.param_name = ''
    },
    projectsFilter () {
      this.$emit('projectsFilter', this.formInline)
    },
    showProjectForm () {
      this.$emit('showProjectForm')
    }
  }
}
</script>