<?php

namespace app\admin\model;
use think\db\Query;

trait ApiScopeTrait
{
    public function scopeApiList(Query $query)
    {
        $query->where('status',1)->order('weigh', 'desc')->withoutField('status,weigh,create_time');
    }
}