<?php

namespace app\admin\model;

use think\Model;

/**
 * WechatUser
 */
class WechatUser extends Model
{
    // 表名
    protected $name = 'wechat_user';

    // 自动写入时间戳字段
    protected $autoWriteTimestamp = true;


    public function user(): \think\model\relation\BelongsTo
    {
        return $this->belongsTo(\app\admin\model\User::class, 'user_id', 'id')->bind(['nickname','avatar','mobile']);
    }

    public function shareUser()
    {
        return $this->hasOneThrough(User::class,self::class,'id','id','share_uid','user_id');
//        return $this->hasOne(self::class, 'id','share_uid');
    }

    public function getTimeAgoAttr($value, $data)
    {
        return timeAgo($data['create_time']);
    }

}