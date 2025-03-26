<?php

namespace app\manman\controller;

use app\common\controller\Api;
use app\manman\service\Auth;

class Base extends Api
{

    public Auth $auth;

    protected $isAuth = true;

    protected function initialize(): void
    {
        parent::initialize();
        //登录验证
//        var_dump($this->request->header('token'));
        $token = $this->request->header('token');
//        var_dump($token);
        $this->auth = new Auth($token);
        if($this->isAuth){
            $this->auth->checkGet();
        }
    }
}