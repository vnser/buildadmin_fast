<template>
  <view class="homeLayout">
    <view class="topBox">
      <view class="banner">
        <up-swiper height="364rpx" radius="12" keyName="image"
                   :list="bannerImages"
                   circular @click="goBanner"
        >
<!--          <template #default="{ item }" >-->
<!--            <view @click="()=>{console.log(item);}">dsadadsa</view>-->
<!--            <image class="bannerImg" :src="item.image"  />-->
<!--          </template>-->
        </up-swiper>
      </view>
      <view class="topContent">
        <view class="listItem" v-for="(item,index) in list" @click="goDetail(index)"
              :style="{ backgroundImage: `url(${index == 0 ? basicData?.want_sell_img : index == 1 ? basicData?.quick_price_img : basicData?.invite_friend_img})` }"
        >
<!--          <view class="title">{{item.title}}</view>-->
<!--          <view class="content">{{item.content}}</view>-->
<!--          <view class="showBtn">查看详情</view>-->
<!--          <view class="title"></view>-->
<!--          <view class="content"></view>-->
<!--          <view class="showBtn"></view>-->
        </view>
      </view>
    </view>
    <view class="searchBox">
      <up-search placeholder="输入产品或型号查报价" bgColor="#FFFFFF" borderColor="#f2f2f2" placeholderColor="#111827" @focus="goSearch" :show-action="false" :inputStyle="{height: '76rpx'}" v-model="keyword"></up-search>
    </view>
    <view class="shopBox">
      <up-tabs :list="list1" lineWidth="28" keyName="title" lineColor="#FF4800" :activeStyle="{
            color: '#3D3D3D',
            fontWeight: 'bold',
			      fontSize:'28rpx'
           }"
               :inactiveStyle="{
            color: '#666666',
			      fontSize:'28rpx'
        }"  @click="click"></up-tabs>
      <view class="shopInfo">
        <view class="infoItem">
          <view class="information">
            <image src="../../common/images/phone.png" />
            <view>{{shopDetail.name}} {{shopDetail.phone}}</view>
          </view>
          <view class="operate" @click="phoneCall">拨打</view>
        </view>
        <view class="infoItem">
          <view class="information">
            <image src="../../common/images/weichat.png" />
            <view>{{shopDetail.wechat}}</view>
          </view>
          <view class="operate" @click="copyweiChat">复制</view>
        </view>
        <view class="infoItem">
          <view class="information">
            <view>
              <image src="../../common/images/navigation.png" />
            </view>
            <view>{{shopDetail.address}}</view>
          </view>
          <view class="operate" @click="openAddress">导航</view>
        </view>
      </view>
    </view>
    <view class="brandBox" v-for="itemA in brandList">
      <view class="brandTitle">{{itemA.title}}</view>
      <view class="brandCont">
        <view class="brandItem" v-for="item in itemA?.brand_quotation" @click="showImg(item)">
          <view class="brandInfo" :style="{ backgroundImage: `url(${item.icon})` }">
            <view class="status" v-if="item.today_update === 1">今日更新</view>
          </view>
          <view class="brandName">{{item.title}}</view>
        </view>
      </view>
    </view>
    <up-popup :show="show" mode="center" :round="10"  @close="close" @open="open">
      <view class="popBox">
        <image show-menu-by-longpress="true" :src="basicData?.service_wechat_qrcode" />
        <view class="saveTips">长按加好友，合作或卖货</view>
        <view>{{basicData?.service_name}} {{basicData?.service_phone}}</view>
        <view>地址：{{basicData?.service_address}}</view>
      </view>
    </up-popup>
  </view>
</template>

<script setup>
import {ref,reactive,onMounted } from "vue";
import {getBanner,getStoreInfo,getBrandQuotation,getBasic} from '@/api/apijs.js';
import {onShareAppMessage,onShareTimeline,onLoad} from "@dcloudio/uni-app";
const list1 = ref([]);
const show = ref(false);
const shopDetail = ref({});
const basicData = ref({});
const keyword = ref('');
const list = ref([
  {
    title: '我要卖货',
    content: '免估价 更便捷',
    img: '../../common/images/homeBg01.png'
  },
  {
    title: '快速查价',
    content: '先估价 再下单',
    img: '../../common/images/homeBg02.png'
  },
  {
    title: '邀请好友',
    content: '邀好友',
    img: '../../common/images/homeBg03.png'
  }
])
const goBanner = (index)=>{
  console.log(bannerImages.value[index])
  if(bannerImages.value[index].appid){
    uni.navigateToMiniProgram({
      appId: bannerImages.value[index].appid,
    })
  }


}

const bannerImages = ref([])
const brandList = ref([])
const goSearch = () => {
  uni.navigateTo({
    url: '/pages/search/search'
  })
}

const showImg = (item)=>{
  console.log('2222')
  uni.previewImage({
    current: item.con_images[0],
    urls: item.con_images
  })
}
//拨打电话
const phoneCall = ()=>{
  uni.makePhoneCall({
    phoneNumber: shopDetail.value?.phone
  })
};
onLoad(async(e)=>{
  uni.setStorageSync('share_uid', e.share_uid);
});
onShareAppMessage((res)=>{
  console.log('222',uni.getStorageSync('id'))
  return{
    title: '慢慢电子回收网',
    imageUrl: bannerImages.value[0].image,
    path: `/pages/index/index?share_uid=${uni.getStorageSync('id') || ''}`,
  }
});
//分享到朋友圈
onShareTimeline(()=>{
  return{
    title: '慢慢电子回收网',
    path: `/pages/index/index`,
    query: `?share_uid=${uni.getStorageSync('id') || ''}`,
    imageUrl: bannerImages.value[0].image,
  }
})
//复制微信号
const copyweiChat = ()=>{
  uni.setClipboardData({
    data: shopDetail.value?.wechat,
    success: () => {
      uni.showToast({
        title: '微信号已复制',
        icon: 'none',
        duration: 2000
      });
    },
    fail: (err) => {
      uni.showToast({
        title: '复制失败',
        icon: 'none',
        duration: 2000
      });
    }
  })
}
//地址导航
const openAddress = ()=>{
  uni.openLocation({
    latitude: parseFloat(shopDetail.value.lat),
    longitude: parseFloat(shopDetail.value.lng),
    scale: 18,
    name:'[位置]',
    address:shopDetail.value.address,
    success: function () {
      // console.log('唤起地址成功');
    },
    fail: function (e) {
      // console.log('唤起地址失败',e);
    }
  })

};

//详情
const goDetail = async (index)=>{
  if(index === 0 ){
    show.value = true;

  }else if(index === 1){
    uni.navigateTo({
      url: '../checkPrice/checkPrice'
    })
  }else if(index === 2){
    uni.navigateTo({
      url: '../invite/invite'
    })
  }
}

// 定义方法
function click(item) {
  const foundItem = list1.value.find(listItem => listItem.id === item.id);
  if (foundItem) {
    shopDetail.value = foundItem;
    // console.log('shopDetail',shopDetail.value)
  }
}
// 卖货弹窗
function open() {
  // 打开逻辑，比如设置 show 为 true
  show.value = true;
  // console.log('open');
}

function close() {
  // 关闭逻辑，设置 show 为 false
  show.value = false;
  // console.log('close');
}
const getInit = async ()=>{
  let res3 = await getBasic()
  basicData.value = res3.data

  let res = await getBanner()
  if(res.code === 1){
    bannerImages.value = res.data.data
  }
  let res1 = await getStoreInfo()
  if(res.code === 1){
    list1.value = res1.data.data
    shopDetail.value = list1.value[0]
  }
  let res2 = await getBrandQuotation()
  if(res2.code === 1){
    brandList.value = res2.data
  }
};

onMounted(async(options) => {
  await getInit()
});
</script>

<style lang="scss" scoped>
.homeLayout{
  width: 100%;
  .topBox{
    height: 690rpx;
    padding: 28rpx 24rpx 0;
    background-image: url("../../common/images/homeBg.png");
    background-position: bottom;
    background-size: cover;
    .banner{
      width: 100%;
      //padding: 16rpx 34rpx 18rpx;
      .bannerImg{
        width: 100%;
        height: 364rpx;
        z-index: 9999;
      }
      ::v-deep .u-swiper__wrapper__item{
        position: relative;
        .none{
          position: absolute;
          top: 0;
          left: 0;
          height: 100%;width: 100%;
          z-index: 9999;
        }
      }
    }
    .topContent{
      width: 100%;
      display: flex;
      justify-content: space-between;
      margin-top: 30rpx;
      .listItem{
        width: 220rpx;
        height: 136rpx;
        //background-image: url("../../common/images/homeBg01.png");
        padding: 12rpx 16rpx;
        background-size: cover;
        //.title{
        //  font-weight: 700;
        //  color: #3D3D3D;
        //  font-size: 28rpx;
        //  height: 28rpx;
        //  line-height: 28rpx;
        //}
        //.content{
        //  color: #B6B6B6;
        //  font-weight: 400;
        //  font-size: 20rpx;
        //  height: 20rpx;
        //  margin: 10rpx 0 20rpx;
        //}
        .showBtn{
          //width: 98rpx;
          //height: 34rpx;
          //line-height: 34rpx;
          //background: #FF4800;
          //border-radius: 146rpx;
          //font-size: 20rpx;
          //text-align: center;
          //color: #fff;
        }
      }
      .listItem:nth-child(2){
        //background-image: url("../../common/images/homeBg02.png");
      }
      .listItem:nth-child(3){
        //background-image: url("../../common/images/homeBg03.png");
      }
    }
  }
  .searchBox{
    padding: 0 25rpx;
    margin-top: -112rpx;
    ::v-deep .u-search__content__input--placeholder{
      color: #111827;
      font-size: 24rpx;
    }
  }
  .shopBox{
    .shopInfo{
      width: 700rpx;
      background: #FFFFFF;
      box-shadow: 0rpx 4rpx 10rpx 0rpx rgba(0,0,0,0.15);
      border-radius: 20rpx 20rpx 20rpx 20rpx;
      margin: 20rpx auto 0;
      .infoItem{
        display: flex;
        align-items: center;
        position: relative;
        padding: 26rpx 30rpx 24rpx 34rpx;
        color: #3D3D3D;
        font-size: 24rpx;
        .information{
          display: flex;
          align-items: center;
          width: 560rpx;
        }
        image{
          width: 30rpx;
          height: 30rpx;
          margin-right: 20rpx;

        }
        .operate{
          position: absolute;
          right: 30rpx;
          font-size: 24rpx;
          color: #FF4800;
        }
      }
    }

  }
  .brandBox{
    padding: 36rpx 24rpx;
    .brandTitle{
      color: #3D3D3D;
      font-size: 28rpx;
      line-height: 20rpx;
      font-weight: 700;
    }
    .brandCont{
      display: flex;
      flex-wrap: wrap;
      margin-top: 30rpx;
      .brandItem{
        flex-basis: 25%;
        box-sizing: border-box;
        text-align: center;
        margin-bottom: 32rpx;
        z-index: 1;
      }
      .brandInfo{
        width: 96rpx;
        height: 96rpx;
        margin: 0 auto;
        position: relative;
        background-size: cover;
        .status{
          position: absolute;
          bottom: 0;
          left: -4rpx;
          width: 104rpx;
          height: 34rpx;
          color: #fff;
          font-size: 20rpx;
          background: #FF4800;
          clip-path: polygon(0 0, 100% 0, 92% 100%, 8% 100%);
        }
      }
      .brandName{
        font-weight: 500;
        font-size: 24rpx;
        color: #3D3D3D;
        line-height: 34rpx;
        margin-top: 14rpx;
      }
    }
  }
  .popBox{
    width: 616rpx;
    text-align: center;
    font-weight: 500;
    font-size: 28rpx;
    color: #727272;
    line-height: 40rpx;
    padding: 0 40rpx 30rpx;
    .saveTips{
      color: #A4A4A4;
      font-size: 24rpx;
      margin: 48rpx 0 58rpx;
    }
    image{
      width: 340rpx;
      height: 323rpx;
      margin-top: 94rpx;
    }
  }
}
</style>
