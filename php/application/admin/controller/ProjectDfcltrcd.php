<?php
// +----------------------------------------------------------------------
// | Description: 项目难度评分
// +----------------------------------------------------------------------
// | Author: linchuangbin <linchuangbin@honraytech.com>
// +----------------------------------------------------------------------

namespace app\admin\controller;

class ProjectDfcltrcd extends ApiCommon
{

    public function index()
    {
        $Model = model('ProjectDfcltrcd');
        $param = $this->param;
        $data = $Model->getDataList();
        return resultArray(['data' => $data]);
    }

    public function read()
    {
        $Model = model('ProjectDfcltrcd');
        $param = $this->param;
        $data = $Model->getDataById($param['id']);
        if (!$data) {
            return resultArray(['error' => $Model->getError()]);
        }
        return resultArray(['data' => $data]);
    }

    public function save()
    {
        $Model = model('ProjectDfcltrcd');
        $param = $this->param;
        $data = $Model->createData($param);
        if (!$data) {
            return resultArray(['error' => $Model->getError()]);
        }
        return resultArray(['data' => '添加成功']);
    }

    public function update()
    {
        $Model = model('ProjectDfcltrcd');
        $param = $this->param;
		// 7ckf 支持新增
		if (empty($Model->find($param['id']))) {
			$data = $Model->createData($param);
		}else{
			$data = $Model->updateDataById($param, $param['id']);
		}
        if (!$data) {
            return resultArray(['error' => $Model->getError()]);
        }
        return resultArray(['data' => '编辑成功']);
    }

    public function delete()
    {
        $Model = model('ProjectDfcltrcd');
        $param = $this->param;
		// TODO: 附带的关联表也要删除
        $data = $Model->delDataById($param['id'], true);
        if (!$data) {
            return resultArray(['error' => $Model->getError()]);
        }
        return resultArray(['data' => '删除成功']);
    }

    public function deletes()
    {
        $Model = model('ProjectDfcltrcd');
        $param = $this->param;
        $data = $Model->delDatas($param['ids'], true);
        if (!$data) {
            return resultArray(['error' => $Model->getError()]);
        }
        return resultArray(['data' => '删除成功']);
    }

    public function enables()
    {
        $Model = model('ProjectDfcltrcd');
        $param = $this->param;
        $data = $Model->enableDatas($param['ids'], $param['status'], true);
        if (!$data) {
            return resultArray(['error' => $Model->getError()]);
        }
        return resultArray(['data' => '操作成功']);
    }
}
