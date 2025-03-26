<?php

namespace app\manman\controller;
use app\admin\model\product\Classify;
use app\admin\model\product\Goods;
use think\db\Query;
use think\facade\Db;

class Product extends Base
{
    protected $isAuth = false;
    /**
     * 查询分类关联查询商品
     * @return void
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\DbException
     * @throws \think\db\exception\ModelNotFoundException
     */
    public function classify_goods():void
    {
        $pid = $this->request->post('pid');

        $classify = (new Classify())->goodsSelect($pid);
        $this->success('ok',$classify);
    }

    /**
     * 商品数据
     */
    public function goods():void
    {
        $goods_id = (int)$this->request->post('goods_id');
        $goods = (new Goods([]))->scope('apilist,apigoods')->with(['goods_attr'=>function (Query $db) {
            $db->order('id','asc')->hidden(['update_time']);
        }])->find($goods_id)->toArray();
        unset($goods['productClassify']);
        $this->success('ok',$goods);
    }

    /**
     * 搜索产品
     */
    public function search_goods():void
    {
        $name = $this->request->post('name');
        $goods = Goods::query()->scope('apilist')->append(['classify_batch'])->field('title,product_classify_ids,id')->whereLike('title',"%{$name}%")->whereOr('core_param','like',"%{$name}%")->hidden(['product_classify_ids'])->select();
        $this->success('ok',$goods);
    }
}