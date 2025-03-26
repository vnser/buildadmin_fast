<?php

namespace app\manman\controller;

use app\admin\model\WechatUser;
use app\common\controller\Api;
use app\common\facade\Token;
use app\common\library\WxApp;
use app\manman\service\Auth;
use EasyWeChat\Kernel\Exceptions\InvalidConfigException;
use think\db\exception\DataNotFoundException;
use think\db\exception\DbException;
use think\db\exception\ModelNotFoundException;

class Account extends Api
{
    /**
     * 登录接口
     * @return void
     * @throws InvalidConfigException
     * @throws DataNotFoundException
     * @throws DbException
     * @throws ModelNotFoundException
     */
    public function login()
    {
        $type = $this->request->post('type');
        $share_uid = $this->request->post('share_uid');
        $openid = '';
        switch ($type) {
            case "mp":
                $code = $this->request->post('code', '');
                $data = WxApp::miniProgram()->auth->session($code);
                $openid = $data['openid'] ?? '';
                if (!$openid) {
                    return $this->error('openid获取失败');
                }
                break;
            case "test":
                if (env('APP_DEBUG')) {
                    $openid = uniqid();
                    break;
                }
            default:
                $this->error("登录类型错误");
        }
        $user = WechatUser::where(['openid' => $openid])->find();
        if (!$user) {
            //会员
            $username = generateEnglishName();
            $userInfo = \app\admin\model\User::create([
                'username'=>$username,
                'nickname'=>$username,
            ]);
            $user = WechatUser::create(
                [
                    'user_id'=>$userInfo->id,
                    'openid'  => $openid,
                    'share_uid'=>$share_uid??0
                ]
            );
        }
        $auth = new Auth();
        //小程序登录逻辑
        $this->success('success', ['token' => $auth->setToken($user->id)]);
    }

    public function get_uid(): void
    {
        $token = $this->request->post('token');
        $this->success('ok', Token::get($token));
    }

}