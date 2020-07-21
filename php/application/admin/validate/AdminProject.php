<?php

namespace app\admin\validate;
use think\Validate;
/**
* 设置模型
*/
class AdminProject extends Validate{

	protected $rule = array(
		'projectname'   => 'require',
		'developer'		=> 'checkUser', //7ckf 项目必须属于自己 user_id == 1 除外
	);
	protected $message = array(
		'projectname.require'	=> '项目名称必须填写',
		'developer.checkUser'	=> '项目开发者必须属于自己'
	);
	protected function checkUser($value, $rule){
		$userInfo = $GLOBALS['userInfo'];
		if ($userInfo['id'] != 1 && $value != $userInfo['realname']){
			return false;
		}
		return true;
	}
}