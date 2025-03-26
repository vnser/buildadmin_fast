<?php

namespace app\common\library;
use EasyWeChat\Factory;
use think\facade\Env;

class WxApp
{
    /**
     * 微信小程序SDK
     */
    static public function miniProgram(): \EasyWeChat\MiniProgram\Application
    {
//        print_r(Env::get('DATABASE.'));
/*        $app_id = env('wexin-mp.appid');
        $secret = env('wexin-mp.appsecret');*/

/*        $app_id = env('wexin-mp.appid');
        $secret = env('wexin-mp.appsecret');*/
        $app_id = get_sys_config('appid','mp-weixin');
        $secret = get_sys_config('appsecret','mp-weixin');
//        var_dump($app_id);
        $config = [
            'app_id' => $app_id,
            'secret' => $secret,
            // 下面为可选项
            // 指定 API 调用返回结果的类型：array(default)/collection/object/raw/自定义类名
            'response_type' => 'array',
            'log' => [
                'level' => 'debug',
                'file' => config('log.path').'/wechat.log',
            ],
        ];
        return Factory::miniProgram($config);
    }
}