<?php

namespace app\admin\model\product;

use app\admin\model\ApiScopeTrait;
use think\Db;
use think\Model;
use think\model\relation\HasMany;

/**
 * Classify
 */
class Classify extends Model
{
    use ApiScopeTrait;


    // 表名
    protected $name = 'product_classify';

    // 自动写入时间戳字段
    protected $autoWriteTimestamp = true;
    protected $updateTime = false;

    protected static function onAfterInsert($model): void
    {
        if ($model->weigh == 0) {
            $pk = $model->getPk();
            if (strlen($model[$pk]) >= 19) {
                $model->where($pk, $model[$pk])->update(['weigh' => $model->count()]);
            } else {
                $model->where($pk, $model[$pk])->update(['weigh' => $model[$pk]]);
            }
        }
    }

    static public function onBeforeWrite($model)
    {
        $pid = $model->pid;

        // 计算当前节点的深度
        if (!$pid) {
            $newDepth = 1; // 顶级节点深度为1
        } else {
            $parent = self::query()->where('id', $pid)->find();
            if ($parent) {
                $newDepth = $parent['depth'] + 1;
            } else {
                // 父级不存在，处理为顶级
//                \think\facade\Log::warning("父级ID {$pid} 不存在，模型ID {$model->id} 设置为顶级");
                $newDepth = 1;
            }
        }

        // 如果深度发生变化，递归更新子代深度
        if ($model->depth !== $newDepth) {
            $model->setAttr('depth', $newDepth);
            self::updateChildrenDepth($model->id, $newDepth);
        }
    }

    /**
     * 递归更新子代深度
     *
     * @param int $parentId 父节点ID
     * @param int $parentDepth 父节点深度
     */
    protected static function updateChildrenDepth($parentId, $parentDepth)
    {
        // 查找所有子代
        $children = self::query()->where('pid', $parentId)->select();
        foreach ($children as $child) {
            $newDepth = $parentDepth + 1;
//            var_dump($child->depth);
//            var_dump($newDepth);
            if ($child->depth !== $newDepth) {
//                $child->setAttr('depth', $newDepth);
//                $child->depth = $newDepth;
                \think\facade\Db::name('product_classify')->where('id', $child->id)->update(['depth' => $newDepth]);
                // 递归更新下一级
                self::updateChildrenDepth($child->id, $newDepth);
            }
        }
    }

//    static public function onBeforeInsert($model)
//    {
//        $pid = $model->pid;
//        if (!$pid){
//            $model->setAttr('depth', 1);
//        }else{
//            $parent = self::query()->where('id', $pid)->find();
//            $model->setAttr('depth', $parent['depth'] + 1);
//        }
////        $this->setAttr('depth');
//    }

    /**
     * 关联goods模型
     * @return HasMany
     */
    public function scopeGoods($query)
    {
        $query->alias('c')->leftJoin('product_goods g', 'find_in_set(c.id,g.product_classify_ids)');
    }

    /**
     * 查询分类商品数据
     * @param $pid
     * @return array
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\DbException
     * @throws \think\db\exception\ModelNotFoundException
     */
    public function goodsSelect($pid):array
    {
        $data = $this->scope(['goods'])
            ->where('pid', $pid)
            ->order('c.weigh', 'desc')
            ->where('c.status', 1)
            ->field('c.id,c.title,depth,g.title goods_title,g.id goods_id,g.price goods_price')
            ->select()->toArray();
        $list = [];

        $ids = array_column($data, 'id');

        foreach ($data as $k=>$v){
           $index =  array_search($v['id'],$ids);
           $list[$index]['id'] = $v['id'];
           $list[$index]['title'] = $v['title'];
           $list[$index]['depth'] = $v['depth'];
           if (!isset($list[$index]['goods'])){
               $list[$index]['goods'] = [];
           }
           if (!empty($v['goods_id'])){
               $list[$index]['goods'][] = [
                   'id' => $v['goods_id'],
                   'title' => $v['goods_title'],
                   'price' => $v['goods_price']
               ];
           }

        }
        return $list;
    }

    // 查询所有相关分类
    public function getCategoriesBatchAttr($value, $data) {
        $categories = [];
        $currentId = $data['id'];

        while ($currentId) {
            $current = $this->scope('apilist')->find($currentId);
            if ($current) {
                $categories[] = $current;
                $currentId = $current['pid'];
            } else {
                $currentId = null;
            }
        }

        // 反转路径，根节点在最前
        return array_reverse($categories);
    }

    public function getCategoriesBatchNameAttr($value, $data)
    {
        $name = [];
        foreach ($this->getCategoriesBatchAttr($value,$data) as $v){
            $name[] = $v['title'];
        }
        return join('->',$name);
    }

    /**
     * 获取上级分类
     */
    public function parent()
    {
        return $this->hasOne(self::class, 'id', 'pid');
    }

    public function getHasChildrenAttr($value,$data)
    {
        return (bool)$this->where('pid', $data['id'])->find();
//        return true;
    }


    public function getChildrenAttr($value, $data)
    {
        // 检查当前分类ID是否存在
        if (!isset($data['id'])) {
            return [];
        }

        $categoryId = $data['id'];

        // 调用递归方法获取所有子分类
        return $this->getChildrenRecursive($categoryId);
    }

    /**
     * 递归获取子分类
     *
     * @param int $parentId 父分类ID
     * @return array 子分类列表
     */
    private function getChildrenRecursive($parentId)
    {
        // 查询子分类
        $children = self::query()->where('pid', $parentId)->order('weigh','desc')->select()->toArray();

        // 如果有子分类，则继续递归
        foreach ($children as &$child) {
            $child['children'] = $this->getChildrenRecursive($child['id']);
        }

        return $children;
    }
}