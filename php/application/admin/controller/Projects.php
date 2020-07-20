<?php
// +----------------------------------------------------------------------
// | Description: 项目
// +----------------------------------------------------------------------
// | Author: linchuangbin <linchuangbin@honraytech.com>
// +----------------------------------------------------------------------

namespace app\admin\controller;

class Projects extends ApiCommon
{

    public function index($year_month='')
    {
		// 前端month类型为时间字符串 '2020-07-20T08:00:11.313Z'
        $ProjectModel = model('Project');
        $param = $this->param;
        $data = $ProjectModel->getDataList($year_month);
        return resultArray(['data' => $data]);
    }

    public function read()
    {
        $ProjectModel = model('Project');
        $param = $this->param;
        $data = $ProjectModel->getDataById($param['id']);
        if (!$data) {
            return resultArray(['error' => $ProjectModel->getError()]);
        }
        return resultArray(['data' => $data]);
    }

    public function save()
    {
        $ProjectModel = model('Project');
        $param = $this->param;
        $data = $ProjectModel->createData($param);
        if (!$data) {
            return resultArray(['error' => $ProjectModel->getError()]);
        }
        return resultArray(['data' => $data]);
    }

    public function update()
    {
        $ProjectModel = model('Project');
        $param = $this->param;
        $data = $ProjectModel->updateDataById($param, $param['id']);
        if (!$data) {
            return resultArray(['error' => $ProjectModel->getError()]);
        }
        return resultArray(['data' => '编辑成功']);
    }

    public function delete()
    {
        $ProjectModel = model('Project');
        $param = $this->param;
        $data = $ProjectModel->delDataById($param['id'], true);
        if (!$data) {
            return resultArray(['error' => $ProjectModel->getError()]);
        }
		// 7ckf 附带的关联表也要删除
		model('ProjectDfcltrcd')->delDataById($param['id'], true);
		model('ProjectRcd')->delDataById($param['id'], true);
        return resultArray(['data' => '删除成功']);
    }

    public function deletes()
    {
        $ProjectModel = model('Project');
        $param = $this->param;
        $data = $ProjectModel->delDatas($param['ids'], true);
        if (!$data) {
            return resultArray(['error' => $ProjectModel->getError()]);
        }
        return resultArray(['data' => '删除成功']);
    }

    public function enables()
    {
        $ProjectModel = model('Project');
        $param = $this->param;
        $data = $ProjectModel->enableDatas($param['ids'], $param['status'], true);
        if (!$data) {
            return resultArray(['error' => $ProjectModel->getError()]);
        }
        return resultArray(['data' => '操作成功']);
    }
}
