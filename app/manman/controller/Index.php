<?php

namespace app\manman\controller;

use app\admin\model\Appconfig;
use app\admin\model\Banner;
use app\admin\model\BrandQuotation;
use app\admin\model\Storeinfo;
use app\admin\model\Systemconfig;
use app\admin\model\SystemconfigBanner;
use app\common\controller\Api;

class Index extends Base
{
    protected $isAuth = false;
    /**
     * 基础信息
     */
    public function basic(): void
    {
        $config = Appconfig::query()->withoutField('id')->find(1);
        $this->success('ok', $config);
    }

    /**
     * 首页banner
     */
    public function banner(): void
    {
//       $banner = new Banner();
       $this->success('ok',Banner::query()->withoutField('create_time,weigh')->scope('apilist')->paginate());
    }

    /**
     * 门店列表
     */
    public function store_info(): void
    {
        $list = Storeinfo::query()->scope('apilist')->field('id,title,name,phone,wechat,address,lat,lng')->paginate();
        $this->success('ok',$list);
    }

    /**
     * 废旧手机报价
     */
    public function brand_quotation():void
    {
        $this->success('ok',BrandQuotation::query()->scope('apilist')->append(['today_update'])->withoutField(['create_time','remark','status','remark','weigh'])->paginate());
    }


}