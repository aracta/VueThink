<template>
	<el-dialog ref="dialog" custom-class="w-500 h-380" title="修改密码" :visible.sync="dialogVisible">
		<div class="ovf-auto">
			<el-form ref="form" :model="form" :rules="rules" label-width="100px">
				<el-form-item label="旧密码" prop="old_pwd">
					<el-input type="password" v-model.trim="form.old_pwd"></el-input>
				</el-form-item>
				<el-form-item label="新密码" prop="new_pwd">
					<el-input type="password" v-model.trim="form.new_pwd"></el-input>
				</el-form-item>
				<el-form-item label="新密码确认" prop="new_pwd_confirm">
					<el-input type="password" v-model.trim="form.new_pwd_confirm"></el-input>
				</el-form-item>
			</el-form>
		</div>
		<div class="p-t-20">
			<el-button type="primary" class="fl m-l-20" :disabled="disable" @click="submit()">提交</el-button>
		</div>
	</el-dialog>
</template>
<style>

</style>
<script>
  import http from '../../assets/js/http'

  export default {
    data() {
      var validatePass2 = (rule, value, callback) => {
        if (value !== this.form.new_pwd) {
          callback(new Error('两次输入的密码不一致'))
        } else {
          callback()
        }
      }
      return {
        dialogVisible: false,
        disable: false,
        form: {
          auth_key: '',
          old_pwd: '',
          new_pwd: '',
          new_pwd_confirm: ''
        },
        rules: {
          old_pwd: [
            { required: true, message: '请输入旧密码', trigger: 'blur' },
            { min: 6, max: 12, message: '长度在 6 到 12 个字符', trigger: 'blur' }
          ],
          new_pwd: [
            { required: true, message: '请输入新密码', trigger: 'blur' },
            { min: 6, max: 12, message: '长度在 6 到 12 个字符', trigger: 'blur' }
          ],
          new_pwd_confirm: [
            { required: true, message: '请输入新密码确认', trigger: 'blur' },
            { validator: validatePass2, trigger: 'blur' }
          ]
        }
      }
    },
    methods: {
      open() {
        this.$refs.dialog.open()
        this.dialogVisible = true
      },
      close() {
        this.$refs.dialog.close()
        this.dialogVisible = false
      },
      submit() {
        this.$refs.form.validate((pass) => {
          if (pass) {
            this.disable = !this.disable
            this.apiPost('admin/base/setInfo', this.form).then((res) => {
              this.handelResponse(res, (data) => {
                _g.toastMsg('success', '修改成功')
                Lockr.rm('authKey')
                Lockr.rm('authList')
                Lockr.rm('sessionId')
                setTimeout(() => {
                  router.replace('/')
                }, 1500)
              }, () => {
                this.disable = !this.disable
              })
            })
          }
        })
      }
    },
    created() {
      this.form.auth_key = Lockr.get('authKey')
    },
    mixins: [http]
  }
</script>