<?php

namespace app\manman\controller;
use app\admin\model\WechatUser;
use think\db\Query;
use think\exception\ValidateException;

class My extends Base
{
    /**
     * 获取登录信息
     * @return void
     */
    public function userinfo():void
    {
        $this->success('ok', $this->auth->user);
    }

    /**
     * 邀请好友
     */
    public function invite(): void
    {
        $list = WechatUser::query()->visible(['id','openid','nickname','time_ago','avatar'])->with('user')->where('share_uid',$this->auth->user->id)->append(['time_ago'])->paginate();
        $this->success('ok', $list);
    }

    /**
     * @return void
     */
    public function modify_user():void
    {
        $mobile = $this->request->post('mobile');
        $nickname = $this->request->post('nickname');
        $avatar = $this->request->post('avatar');
        try {
            validate(\app\manman\validate\User::class)
                ->scene('manman_modify')
                ->check($this->request->post());
            $this->auth->user->user->save([
                'mobile' => $mobile,
                'nickname' => $nickname,
                'avatar' => $avatar,
            ]);
        }catch (ValidateException $e){
            $this->error($e->getError());
        }
        $this->success('修改成功');
    }

}