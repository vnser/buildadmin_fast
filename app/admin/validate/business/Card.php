<?php

namespace app\admin\validate\business;

use think\Validate;

class Card extends Validate
{
    protected $failException = true;

    /**
     * 验证规则
     */
    protected $rule = [
        'avatar|头像'  => 'require',
        'banner|Banner' => 'require',
    ];

    /**
     * 提示消息
     */
    protected $message = [

    ];

    /**
     * 验证场景
     */
    protected $scene = [
        'add'  => [],
        'edit' => [],
    ];

}
