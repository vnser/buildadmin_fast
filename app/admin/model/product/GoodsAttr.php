<?php

namespace app\admin\model\product;

use app\admin\model\ApiScopeTrait;
use think\Model;

/**
 * GoodsAttr
 */
class GoodsAttr extends Model
{
    use ApiScopeTrait;
    // 表名
    protected $name = 'product_goods_attr';

    // 自动写入时间戳字段
    protected $autoWriteTimestamp = true;

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

    public function productGoods(): \think\model\relation\BelongsTo
    {
        return $this->belongsTo(\app\admin\model\product\Goods::class, 'product_goods_id', 'id');
    }
}