<?php

namespace app\manman\validate;

use think\Validate;

class User extends Validate
{
    protected $failException = true;

    protected $rule = [
        'username'    => 'require|regex:^[a-zA-Z][a-zA-Z0-9_]{2,15}$|unique:user',
        'email'       => 'email|unique:user',
        'mobile'      => 'mobile|unique:user',
        'password'    => 'require|regex:^(?!.*[&<>"\'\n\r]).{6,32}$',
        'captcha'     => 'require',
        'captchaId'   => 'require',
        'captchaInfo' => 'require',
        'nickname'  => 'require|max:25|chsDash',
        'avatar'  => 'require|url',
    ];

    /**
     * 验证场景
     */
    protected $scene = [
        'login'    => ['password', 'captchaId', 'captchaInfo'],
        'register' => ['email', 'username', 'password', 'mobile', 'captcha'],
        'manman_modify'=>['mobile','nickname','avatar']
    ];

    public function __construct()
    {
        $this->field   = [
            'username'    => __('username'),
            'email'       => __('email'),
            'mobile'      => __('mobile'),
            'password'    => __('password'),
            'captcha'     => __('captcha'),
            'captchaId'   => __('captchaId'),
            'captchaInfo' => __('captcha'),
            'avatar' => "头像",
            'nickname' => "昵称",
        ];
        $this->message = array_merge($this->message, [
            'username.regex' => __('Please input correct username'),
            'password.regex' => __('Please input correct password')
        ]);
        parent::__construct();
    }
}