<?php

namespace app\admin\model\global;

use think\Model;

/**
 * Config
 */
class Config extends Model
{
    // 表名
    protected $name = 'global_config';

    // 自动写入时间戳字段
    protected $autoWriteTimestamp = true;


    public function getBannerAttr($value): array
    {
        if ($value === '' || $value === null) return [];
        if (!is_array($value)) {
            return explode(',', $value);
        }
        return $value;
    }

    public function setBannerAttr($value): string
    {
        return is_array($value) ? implode(',', $value) : $value;
    }

    public function getConetntImgsAttr($value): array
    {
        if ($value === '' || $value === null) return [];
        if (!is_array($value)) {
            return explode(',', $value);
        }
        return $value;
    }

    public function setConetntImgsAttr($value): string
    {
        return is_array($value) ? implode(',', $value) : $value;
    }
}