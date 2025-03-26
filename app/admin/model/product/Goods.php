<?php

namespace app\admin\model\product;

use app\admin\model\ApiScopeTrait;
use think\db\Query;
use think\Model;

/**
 * Goods
 */
class Goods extends Model
{
    use ApiScopeTrait;
    // 表名
    protected $name = 'product_goods';

    // 自动写入时间戳字段
    protected $autoWriteTimestamp = true;
    protected $updateTime = false;

    // 追加属性
    protected $append = [
        'productClassify',
    ];



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


    public function getProductClassifyAttr($value, $row): array
    {
        return [
            'title' => \app\admin\model\product\Classify::whereIn('id', $row['product_classify_ids'])->append(['categories_batch_name'])->select()->column('categories_batch_name'),
        ];
    }

    public function getProductClassifyIdsAttr($value): array
    {
        if ($value === '' || $value === null) return [];
        if (!is_array($value)) {
            return explode(',', $value);
        }
        return $value;
    }

    public function setProductClassifyIdsAttr($value): string
    {
        return is_array($value) ? implode(',', $value) : $value;
    }

    public function getImagesAttr($value): array
    {
        if ($value === '' || $value === null) return [];
        if (!is_array($value)) {
            return explode(',', $value);
        }
        return $value;
    }

    public function setImagesAttr($value): string
    {
        return is_array($value) ? implode(',', $value) : $value;
    }

    public function goodsAttr()
    {
        return $this->hasMany(GoodsAttr::class, 'product_goods_id', 'id');
    }

    public function scopeApiGoods(Query $query)
    {
//        $this->append = [];
        $query->hidden(['product_classify_ids']);
    }


    /**
     * 查询分类全部管理
     * @param $value
     * @param $data
     * @return array
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\DbException
     * @throws \think\db\exception\ModelNotFoundException
     */
    public function getClassifyBatchAttr($value, $data)
    {
        $classify = Classify::query()->append(['categories_batch_name'])->whereIn('id',$data['product_classify_ids'])->select()->column('categories_batch_name');
        return $classify;
    }

    /**
     * 添加处理
     * @param $attr
     * @param $delattr
     * @param $goodsId
     * @return void
     * @throws \think\db\exception\DbException
     */
    static protected function changeAttr($attr,$delattr = [],$goodsId=0):void
    {
        if ($attr){
            foreach ($attr as $item){
                $item['product_goods_id'] = $goodsId;
                GoodsAttr::query()->save($item);
            }
//            self::saveAll($attr);
        }
        if ($delattr){
            $ids = [];
            foreach ($delattr as $item){
//                print_r($item);
                if (isset($ids[$item['id']])){//防止重复删除
                    continue;
                }

                \app\admin\model\product\GoodsAttr::query()->where('id',$item['id'])->where('product_goods_id',$goodsId)->delete();
                $ids[$item['id']] = 1;
            }
        }
    }

    /**
     * 写入属性操作
     * @param $data
     * @return void
     * @throws \think\db\exception\DbException
     */
    static protected function onAfterWrite($data)
    {
//        var_dump($data->goods_attr);
        if (!empty($data->isattr)){
            self::changeAttr($data->goods_attr,$data->delattr,$data->id);
        }
    }

    /**
     * 删除产品
     * @param $data
     * @return void
     */
    static protected function onAfterDelete($data){
        $data->goodsAttr()->delete();
    }

}