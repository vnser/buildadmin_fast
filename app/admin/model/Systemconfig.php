<?php

namespace app\admin\model;

use think\Model;

/**
 * Systemconfig
 */
class Systemconfig extends Model
{
    // 表名
    protected $name = 'systemconfig';

    // 自动写入时间戳字段
    protected $autoWriteTimestamp = false;


    public function getBannerImgsAttr($value): array
    {
        if ($value === '' || $value === null) return [];
        if (!is_array($value)) {
            return explode(',', $value);
        }
        return $value;
    }

    public function setBannerImgsAttr($value): string
    {
        return is_array($value) ? implode(',', $value) : $value;
    }

    public function getContentImgsAttr($value): array
    {
        if ($value === '' || $value === null) return [];
        if (!is_array($value)) {
            return explode(',', $value);
        }
        return $value;
    }

    public function setContentImgsAttr($value): string
    {
        return is_array($value) ? implode(',', $value) : $value;
    }
}