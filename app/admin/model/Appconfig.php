<?php

namespace app\admin\model;

use think\Model;

/**
 * Appconfig
 */
class Appconfig extends Model
{
    // 表名
    protected $name = 'appconfig';

    // 自动写入时间戳字段
    protected $autoWriteTimestamp = true;
    protected $createTime = false;


    public function getDisclaimerAttr($value): string
    {
        return !$value ? '' : htmlspecialchars_decode($value);
    }

    public function getPlatformPolicyAttr($value): string
    {
        return !$value ? '' : htmlspecialchars_decode($value);
    }

    public function getAboutPlatformAttr($value): string
    {
        return !$value ? '' : htmlspecialchars_decode($value);
    }
}