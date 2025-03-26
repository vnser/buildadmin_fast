<?php

namespace app\admin\controller\product;

use app\common\controller\Backend;
use ba\Tree;
use think\facade\Db;

/**
 * 报价分类
 */
class Classify extends Backend
{
    /**
     * Classify模型对象
     * @var object
     * @phpstan-var \app\admin\model\product\Classify
     */
    protected object $model;

    protected string|array $defaultSortField = 'weigh,desc';

    protected array|string $preExcludeFields = ['id', 'create_time'];

    protected string|array $quickSearchField = ['title'];


    protected array $withJoinTable = ['parent'];
    public function initialize(): void
    {
        parent::initialize();
        $this->model = new \app\admin\model\product\Classify();
    }

    /**
     * 添加
     */
    public function add(): void
    {
        if ($this->request->isPost()) {
            $data = $this->request->post();
            if (!$data) {
                $this->error(__('Parameter %s can not be empty', ['']));
            }

            $data = $this->excludeFields($data);
            if ($this->dataLimit && $this->dataLimitFieldAutoFill) {
                $data[$this->dataLimitField] = $this->auth->id;
            }

            $result = false;
            $this->model->startTrans();
            try {
                // 模型验证
                if ($this->modelValidate) {
                    $validate = str_replace("\\model\\", "\\validate\\", get_class($this->model));
                    if (class_exists($validate)) {
                        $validate = new $validate();
                        if ($this->modelSceneValidate) $validate->scene('add');
                        $validate->check($data);
                    }
                }
                if (isset($data['pid'])){
                    $parent = $this->model->where('id', $data['pid'])->find();
                    if ($parent->depth >= 3){
                        throw new \Exception(('最多只能添加三级分类'));
                    }
                }

                $result = $this->model->save($data);
                $this->model->commit();
            } catch (\Throwable $e) {
                $this->model->rollback();
                $this->error($e->getMessage());
            }
            if ($result !== false) {
                $this->success(__('Added successfully'));
            } else {
                $this->error(__('No rows were added'));
            }
        }

        $this->error(__('Parameter error'));
    }

    /**
     * 若需重写查看、编辑、删除等方法，请复制 @see \app\admin\library\traits\Backend 中对应的方法至此进行重写
     */
    /**
     * 查看
     * @throws Throwable
     */
    public function index(): void
    {
        if ($this->request->param('select')) {
            $this->select();
        }
        $isTree = $this->request->param('isTree', false);
//        var_dump($isTree);
        list($where, $alias, $limit, $order) = $this->queryBuilder();
        if ($this->request->param('goods_select')) {
//            $where[] = ['classify.depth', '=', Db::raw("(" . $this->model->fetchSql(true)->max('depth') . ")")];
            $where[] = ['classify.depth', '=', 3];
//            $where[] =
        }else if(!$isTree){
            $pid = $this->request->param('pid',0);
            $where[] = ['classify.pid', '=', $pid];
        }
//        print_r($where);
//        print_r($where);
        $start = microtime(true);

// 要测试的代码
//        usleep(100);

//        echo "执行时间: " . $duration . " 秒";
        $res = $this->model
//            ->append(['categories_batch_name'])
            ->field($this->indexField)
            ->withJoin($this->withJoinTable, $this->withJoinType)
            ->alias($alias)
            ->where($where)

            ->append(['categories_batch_name','hasChildren'])
            ->order($order)
            ->select()->toArray();
//        var_dump($res);
        $tree = Tree::instance();
//        $list = $isTree ? $tree->assembleTree($tree->getTreeArray($tree->assembleChild($res), 'title')):$res;
        $end = microtime(true);
        $duration = $end - $start;


        $this->success('', [
//            'list'   => $res->items(),
            'list'   => $res,
//            'total'  => $res->total(),
            'remark' => get_route_remark(),
            'desc'=>"执行时间: " . $duration . " 秒"
        ]);
    }


    /**
     * 删除
     * @param array $ids
     * @throws Throwable
     */
    public function del(array $ids = []): void
    {
        if (!$this->request->isDelete() || !$ids) {
            $this->error(__('Parameter error'));
        }

        $where             = [];
        $dataLimitAdminIds = $this->getDataLimitAdminIds();
        if ($dataLimitAdminIds) {
            $where[] = [$this->dataLimitField, 'in', $dataLimitAdminIds];
        }

        $pk      = $this->model->getPk();
        $where[] = [$pk, 'in', $ids];

        $count = 0;
        $data  = $this->model->where($where)->select();
        $this->model->startTrans();
        try {
            foreach ($data as $v) {
                $chi = $this->model::query()->where('pid', $v->id)->find();
                if ($chi){
                    $this->model->rollback();
                    throw new \Exception('请先删除子分类');
                }
                $count += $v->delete();
            }
            $this->model->commit();
        } catch (\Throwable $e) {
            $this->model->rollback();
            $this->error($e->getMessage());
        }
        if ($count) {
            $this->success(__('Deleted successfully'));
        } else {
            $this->error(__('No rows were deleted'));
        }
    }

    /**
     * 编辑
     * @throws Throwable
     */
    public function edit(): void
    {
        $pk  = $this->model->getPk();
        $id  = $this->request->param($pk);
        $row = $this->model->find($id);
        if (!$row) {
            $this->error(__('Record not found'));
        }

        $dataLimitAdminIds = $this->getDataLimitAdminIds();
        if ($dataLimitAdminIds && !in_array($row[$this->dataLimitField], $dataLimitAdminIds)) {
            $this->error(__('You have no permission'));
        }

        if ($this->request->isPost()) {
            $data = $this->request->post();
            if (!$data) {
                $this->error(__('Parameter %s can not be empty', ['']));
            }

            $data   = $this->excludeFields($data);
            $result = false;
            $this->model->startTrans();
            try {
                // 模型验证
                if ($this->modelValidate) {
                    $validate = str_replace("\\model\\", "\\validate\\", get_class($this->model));
                    if (class_exists($validate)) {
                        $validate = new $validate();
                        if ($this->modelSceneValidate) $validate->scene('edit');
                        $data[$pk] = $row[$pk];
                        $validate->check($data);
                    }
                }
                if(!empty($data['pid'])){
                    if ($id == $data['pid']){
                        throw new \Exception(('上级分类不能为自身'));
                    }
                }

                $result = $row->save($data);
                $this->model->commit();
            } catch (\Throwable $e) {
                $this->model->rollback();
                $this->error($e->getMessage());
            }
            if ($result !== false) {
                $this->success(__('Update successful'));
            } else {
                $this->error(__('No rows updated'));
            }
        }

        $this->success('', [
            'row' => $row
        ]);
    }
}