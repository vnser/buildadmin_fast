<?php

namespace app\admin\model;

use think\Model;

/**
 * Banner
 */
class SystemconfigBanner extends Model
{
    // 表名
    protected $name = 'sysconfig_banner';

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

//    public function getTypeAttr($value): array
//    {
//        if ($value === '' || $value === null) return [];
//        if (!is_array($value)) {
//            return explode(',', $value);
//        }
//        return $value;
//    }

//    public function setTypeAttr($value): string
//    {
//        return is_array($value) ? implode(',', $value) : $value;
//    }

    public function getArticleContentAttr($value): string
    {
        return !$value ? '' : htmlspecialchars_decode($value);
    }

    public function businessCard(): \think\model\relation\BelongsTo
    {
        return $this->belongsTo(\app\admin\model\business\Card::class, 'business_card_id', 'id');
    }
}