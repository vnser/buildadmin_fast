<?php

namespace app\manman\service;

use app\admin\model\WechatUser;
use app\common\facade\Token;
use ba\Random;
use think\db\Query;
use think\exception\HttpResponseException;

class Auth
{
    // 用户认证类
    // 用户认证令牌
    public string $token;
    // 用户ID，默认为0表示未认证
    public int $userId = 0;
    // 微信用户信息，可能为空
    public ?WechatUser $user;
    // 令牌类型，默认为'manman_user'
    protected string $tokenType = 'manman_user';

    /**
     * 构造函数，初始化用户认证实例
     *
     * @param string $token 用户认证令牌，默认为空字符串
     */
    public function __construct(?string $token = '')
    {
        $this->token = $token??'';
    }

    /**
     * 检查并获取用户信息，用于身份验证
     *
     * 该方法通过令牌获取用户信息，并检查令牌是否过期，然后设置用户ID和微信用户信息
     * 如果用户信息为空，则抛出身份认证失败的异常
     *
     * @throws HttpResponseException 如果身份认证失败，则抛出异常
     */
    public function checkGet(): void
    {
        // 通过令牌获取用户信息
        $u = Token::get($this->token);
//        var_dump($u);
        // 检查令牌是否过期
        Token::tokenExpirationCheck($u);
        // 设置用户ID
        $this->userId = $u['user_id'] ?? 0;
//        var_dump($this->userId);
        // 获取微信用户信息
        $this->user = WechatUser::query()->withoutField('create_time,update_time')->with(['user'])->find($this->userId);
        // 如果用户信息为空，则抛出身份认证失败的异常
        if (empty($this->user)) {
            throw new HttpResponseException(json(['code' => -2, 'msg' => "身份认证失败"]));
        }
    }

    /**
     * 设置新的认证令牌
     *
     * 该方法生成一个新的UUID作为令牌，并将其与登录用户ID关联，然后返回新生成的令牌
     *
     * @param int $loginUid 登录用户的ID
     * @return string 新生成的令牌
     */
    public function setToken(int $loginUid): string
    {
        // 生成新的UUID作为令牌
        $newToken = Random::uuid();
        // 将新的令牌与登录用户ID关联
        Token::set($newToken, $this->tokenType, $loginUid);
        // 返回新生成的令牌
        return $newToken;
    }

}