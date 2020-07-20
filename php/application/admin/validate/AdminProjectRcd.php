<?php

namespace app\admin\validate;
use think\Validate;
/**
* 设置模型
*/
class AdminProjectRcd extends Validate{

	protected $rule = array(
		'atitude'   => 'require',
		'fnstime'   => 'require',
		'fnseffect'   => 'require',
		'adjust'   => 'require',
		'creative'   => 'require',
	);
	protected $message = array(
		'atitude.require'    => '服务态度必须填写',
		'fnstime.require'    => '完成时间必须填写',
		'fnseffect.require'    => '完成效果必须填写',
		'adjust.require'    => '实际难度调整必须填写',
		'creative.require'    => '主动创新必须填写',
	);
}