<?php

namespace app\admin\model;

use think\Model;

/**
 * BrandQuotation
 */
class BrandQuotation extends Model
{
    use ApiScopeTrait;
    // 表名
    protected $name = 'brand_quotation';

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

    public function getConImagesAttr($value): array
    {
        if ($value === '' || $value === null) return [];
        if (!is_array($value)) {
            return explode(',', $value);
        }
        return $value;
    }

    public function setConImagesAttr($value): string
    {
        return is_array($value) ? implode(',', $value) : $value;
    }

    /**
     * 获取是否在今日更新
     * @param $value
     * @param $data
     * @return int
     */
    public function getTodayUpdateAttr($value,$data)
    {
        // 获取当前时间戳的开始和结束
        $todayStart = strtotime('today');
        $todayEnd = strtotime('tomorrow') - 1;
        // 检查 update_time 是否在今日范围内
        return (int)($data['update_time'] >= $todayStart && $data['update_time'] <= $todayEnd);
    }
}