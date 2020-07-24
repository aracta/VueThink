<?php
// +----------------------------------------------------------------------
// | Description: 用户组
// +----------------------------------------------------------------------
// | Author: 7ckf 仿 group model
// +----------------------------------------------------------------------

namespace app\admin\model;

use app\admin\model\Common;

class Project extends Common 
{
    /**
     * 为了数据库的整洁，同时又不影响Model和Controller的名称
     * 我们约定每个模块的数据表都加上相同的前缀，比如微信模块用weixin作为数据表前缀
     */
	protected $name = 'admin_project';

	/**
	 * [createData 新建]
	 * @linchuangbin
	 * @DateTime  2017-02-10T21:19:06+0800
	 * @param     array                    $param [description]
	 * @return    [array]                         [description]
	 */
	public function createData($param)
	{
		
		// 验证
		$validate = validate($this->name);
		if (!$validate->check($param)) {
			$this->error = $validate->getError();
			return false;
		}
		try {
			$result = $this->data($param)->allowField(true)->save();
			// return $result;// 1
			return $this->getLastInsID();
		} catch(\Exception $e) {
			$this->error = '添加失败';
			return false;
		}
	}

	/**
	 * [getDataList 获取列表]
	 * @linchuangbin
	 * @DateTime  2017-02-10T21:07:18+0800
	 * @return    [array]                         
	 */
	public function getDataList($year_month='')
	{
		// 前端month类型为时间字符串 '2020-07-20T08:00:11.313Z'
		// 月份范围
		if ($year_month) {
			$year_month = date('Y-m', strtotime($year_month));
			list($year, $month) = explode('-', $year_month);
			$next_year = $year;
			$begin_time = $year_month;
			//如果是12月份，则
			if ($month == 12){
				$next_year ++;
				$next_month = '01';
				$end_time = $next_year . '-' . $next_month;
			} else {
				$next_month = $month + 1;
				$end_time = $year . '-' . $next_month;
			}
			// $exp = '`createtime` >= "' . $begin_time . '" AND ' . '`createtime` < "' . $end_time . '"'; // exp 不安全
			$begin_time = date('Y-m-d H:i:s', strtotime($year_month));
			$end_time = date('Y-m-d H:i:s', strtotime($end_time)-1); //下个月1日凌晨零点零分零秒的前一秒
			$where['createtime'] = ['between', [$begin_time, $end_time]];
		}
		// 如果是普通会员组，则只返回自己的项目
		$user = $GLOBALS['userInfo'];
		$user_data = model('User')->getDataById($user['id']);
		$groups = $user_data['groups'];
		foreach($groups as $group){
			if ($group['id'] == 15) {
				$is_developer_group = true;
				break;
			}
			if ($group['id'] == 17) {
				$is_demander_group = true;
			}
		}
		// if ($user['id'] != 1) {
		// 暂定“项目开发组”只能看自己开发的项目，“项目评分组”只能【查看属于自己需求的项目，或新增、删除项目，但不能难度评分】
		// 暂定同一个用户不能同时隶属于“项目开发组”和“项目评分组”这两个组
		if ($is_developer_group) {
			$where['developer'] = $user['realname'];
		} elseif ($is_demander_group) {
			$where['demander'] = $user['realname'];
		}
		$data = $this->where($where)->select();
		foreach($data as &$row){
			// return $this->dfcltrcd()->where(['project_id'=>$row['id']])->find();
			$row['projectDfcltrcd'] = $this->dfcltrcd()->where(['id'=>$row['id']])->find();
			$row['projectRcd'] = $this->rcd()->where(['id'=>$row['id']])->find();
			// $row['projectDfcltrcd'] = self::with('project_dfcltrcd')->find();//报错
			if(!empty($row['projectDfcltrcd']['techtypes'])){
				$row['projectDfcltrcd']['techtypes'] = explode(',', $row['projectDfcltrcd']['techtypes']);
			}
		}
		return $data;
	}
	
	// 7ckf 一对多关联
	public function dfcltrcd(){
		// return $this->hasMany('project_dfcltrcd'); 
		// return $this->hasOne('ProjectDfcltrcd'); 
		return $this->hasOne('project_dfcltrcd');
	}
	// 7ckf 一对一关联
	public function rcd(){
		return $this->hasOne('project_rcd'); // 有模型
	}
}