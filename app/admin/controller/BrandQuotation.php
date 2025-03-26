<?php

namespace app\admin\controller;

use app\common\controller\Backend;

/**
 * 品牌报价
 */
class BrandQuotation extends Backend
{
    /**
     * BrandQuotation模型对象
     * @var object
     * @phpstan-var \app\admin\model\BrandQuotation
     */
    protected object $model;

    protected string|array $defaultSortField = 'weigh,desc';

    protected array|string $preExcludeFields = ['id', 'update_time', 'create_time'];

    protected string|array $quickSearchField = ['title'];

    public function initialize(): void
    {
        parent::initialize();
        $this->model = new \app\admin\model\BrandQuotation();
    }


    /**
     * 若需重写查看、编辑、删除等方法，请复制 @see \app\admin\library\traits\Backend 中对应的方法至此进行重写
     */
}