<?php

namespace app\admin\validate;
use think\Validate;
/**
* 设置模型
*/
class AdminProject extends Validate{

	protected $rule = array(
		'projectname'   => 'require',
	);
	protected $message = array(
		'projectname.require'    => '项目名称必须填写',
	);
}