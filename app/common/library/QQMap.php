<?php

namespace app\common\library;

use think\Env;

class QQMap
{
    /**
     * 腾讯地图接口,逆地址查询
     * @return void
     */
    static public function qeocoderByAddress($location)
    {
//        $key = env('qqmap.key');
        $key = get_sys_config('key','qqmap');
//        $location = $this->request->request('location');
        $geocoder = file_get_contents("https://apis.map.qq.com/ws/geocoder/v1/?address={$location}&key={$key}");
        $res = json_decode($geocoder,true);
        if ($res['status'] != 0){
            throw new \Exception($res['message']);
        }
        return $res;
    }

}