<?php

namespace app\admin\model;

use think\Model;

/**
 * AdminRule 模型
 */
class AdminRule extends Model
{
    protected $name = '_admin_rule';
    protected $autoWriteTimestamp = true;

    public function setComponentAttr($value)
    {
        if ($value) $value = str_replace('\\', '/', $value);
        return $value;
    }

}