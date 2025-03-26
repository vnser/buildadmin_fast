<?php

namespace app\admin\controller;

use app\common\controller\Backend;

/**
 * 门店详情
 */
class Storeinfo extends Backend
{
    /**
     * Storeinfo模型对象
     * @var object
     * @phpstan-var \app\admin\model\Storeinfo
     */
    protected object $model;

    protected string|array $defaultSortField = 'weigh,desc';

    protected array|string $preExcludeFields = ['id', 'create_time'];

    protected string|array $quickSearchField = ['title'];

    public function initialize(): void
    {
        parent::initialize();
        $this->model = new \app\admin\model\Storeinfo();
    }


    /**
     * 若需重写查看、编辑、删除等方法，请复制 @see \app\admin\library\traits\Backend 中对应的方法至此进行重写
     */
}