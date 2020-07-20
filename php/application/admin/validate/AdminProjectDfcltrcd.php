<?php

namespace app\admin\validate;
use think\Validate;
/**
* 设置模型
*/
class AdminProjectDfcltrcd extends Validate{

	protected $rule = array(
		'techtypes'   => 'require',
		'prjtype'   => 'require',
		'urgency'   => 'require',
		'experience'   => 'require',
		'role'   => 'require',
	);
	protected $message = array(
		'techtypes.require'    => '技术栈必须填写',
		'prjtype.require'    => '业务类型必须填写',
		'urgency.require'    => '项目工期必须填写',
		'experience.require'    => '项目经验必须填写',
		'role.require'    => '开发者角色必须填写',
	);
}