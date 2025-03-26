<template>
	<view class="container">
    <view class="topBox">
      <view class="userInfo">
        <view class="infoDetail">
          <image :src="userInfo.avatar" />
          <view>
            <view>{{userInfo.nickname}}</view>
            <view class="phone">{{userInfo.mobile}}</view>
          </view>
        </view>
        <image class="settingImg" @click="goSetting" src="../../common/images/setting.png" />
      </view>
      <view class="moreInfo">
        <view class="moreItem" @click="goDetail(0)">
          <view class="itemLeft">
            <image src="../../common/images/affirm.png" />
            免责申明
          </view>
          <view>
            <image class="rightImg" src="../../common/images/Icon.png" />
          </view>
        </view>
        <view class="moreItem" @click="goDetail(1)">
          <view class="itemLeft">
            <image src="../../common/images/policy.png" />
            平台政策
          </view>
          <view>
            <image class="rightImg" src="../../common/images/Icon.png" />
          </view>
        </view>
        <view class="moreItem" @click="goDetail(2)">
          <view class="itemLeft">
            <image src="../../common/images/about.png" />
            关于平台
          </view>
          <view>
            <image class="rightImg" src="../../common/images/Icon.png" />
          </view>
        </view>
      </view>
    </view>
	</view>
</template>

<script setup>
import { ref,reactive,onMounted } from "vue";
import {onShareAppMessage,onShareTimeline,onLoad} from "@dcloudio/uni-app";

import {
  onShow
} from "@dcloudio/uni-app";
import {getUserinfo} from "../../api/apijs";
const userInfo = ref({})
const goDetail = (type)=>{
  uni.navigateTo({
    url: `/pages/policy/policy?type=${type}`
  });
};
//去设置页
const goSetting = ()=>{
  uni.navigateTo({
    url: `/pages/setting/setting`
  });
}
const getInit = async ()=>{
  let res = await getUserinfo()
  console.log(res)
  uni.setStorageSync('id', res.data.id);
  if(res.code === 1){
    userInfo.value = res.data

  }
};
onMounted(async(options) => {
  await getInit()
});
onShow(() => {
  getInit();
});
onShareAppMessage((res)=>{
  console.log('222',uni.getStorageSync('id'))
  return{
    title: '调查问卷',
    path: `/pages/index/index?share_uid=${uni.getStorageSync('id') || ''}`,
  }
});
// //分享到朋友圈
// onShareTimeline(()=>{
//   return{
//     title: '调查问卷',
//     path: `/pages/index/index`,
//     query: `?share_uid=${uni.getStorageSync('id') || ''}`,
//   }
// })
</script>

<style lang="scss" scoped>
.container{
  width: 100%;
  .topBox{
    height: 600rpx;
    padding: 76rpx 24rpx 0;
    background-image: url("../../common/images/homeBg.png");
    background-position: bottom;
    background-size: cover;
    .userInfo{
      width: 100%;
      display: flex;
      align-items: center;
      .infoDetail{
        display: flex;
        align-items: center;
        font-weight: 700;
        font-size: 32rpx;
        color: #FFFFFF;
        line-height: 34rpx;
        position: relative;
        .phone{
          color: #F3F3F5;
          font-size: 28rpx;
          margin-top: 6rpx;
        }
      }
      .settingImg{
        width: 40rpx;
        height: 40rpx;
        position: absolute;
        right: 36rpx;
      }
      image{
        width: 120rpx;
        height: 120rpx;
        border-radius: 50%;
        margin-right: 30rpx;
      }
    }
    .moreInfo{
      margin-top: 16rpx;
      width: 700rpx;
      height: 357rpx;
      background: #FFFFFF;
      border-radius: 20rpx 20rpx 20rpx 20rpx;
      .moreItem{
        display: flex;
        justify-content: space-between;
        padding: 0 34rpx 0 28rpx;
        border-bottom: 1rpx solid #E1E1E1;
        height: 119rpx;
        line-height: 119rpx;

        .itemLeft{
          display: flex;
          align-items: center;
          font-weight: 500;
          font-size: 28rpx;
          color: #3D3D3D;
          text-align: left;
          image{
            width: 48rpx;
            height: 48rpx;
            margin-right: 18rpx;
          }
        }
        .rightImg{
          width: 14rpx;
          height: 24rpx;
        }
      }
      .moreItem:last-child{
        border: none;
      }
    }
  }

}
</style>
