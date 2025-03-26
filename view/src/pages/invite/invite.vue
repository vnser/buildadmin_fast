<template>
	<view class="container" :style="`background-image:url('${CDN_BASE_URL}/static/frontend/invite.png')`">
    <up-navbar
        title="邀请好友"
        @rightClick="rightClick"
        :autoBack="true"
    >
    </up-navbar>
    <view class="inviteBtn" @click="onShareAppMessage">
      <button open-type="share">立即邀请 获得奖励</button>
    </view>
    <view class="inviteList">
      <view class="title">邀请记录</view>
      <view class="inviteCont">
        <scroll-view :scroll-top="scrollTop" scroll-y="true" @scrolltolower="lower" class="scroll-Y">
          <view class="item" v-for="item in inviteList" v-if="inviteList.length > 0">
            <view class="info">
              <image :src="item.avatar" mode="widthFix"></image>
              <view>{{item.nickname}}</view>
            </view>
            <view class="time">{{item.time_ago}}</view>
          </view>
          <view class="noListTips" v-else>
            暂无数据~
          </view>
        </scroll-view>
      </view>
    </view>
	</view>
</template>

<script setup>
import {ref,reactive,onMounted } from "vue";
import {CDN_BASE_URL} from "../../config";
import {invite} from '@/api/apijs.js';
import {onShareAppMessage, onShareTimeline} from "@dcloudio/uni-app";
let page = ref(1);
let loadStatus = ref('');
const inviteList = ref([]);
//返回上一级
const rightClick = () => {
  uni.navigateBack()
};
const getInit = async (page)=>{
  loadStatus.value = 'loading';
  let res = await invite({page: page})
  if(res.code === 1){
    inviteList.value = [...inviteList.value, ...res.data.data];
    if(res.data.data.length < res.data.per_page){
      loadStatus.value = 'nomore';
    }else{
      loadStatus.value = 'more';
    }
  }

};
//触底事件
const lower = (e)=>{
  if(loadStatus.value === 'more'){
    page.value++;
    getInit(page.value)
  }
}
onMounted(async(options) => {
  await getInit(page.value)
});
onShareAppMessage((res)=>{
  console.log('222',uni.getStorageSync('id'))
  return{
    title: '慢慢电子回收网',
    path: `/pages/index/index?share_uid=${uni.getStorageSync('id') || ''}`,
  }
});
//分享到朋友圈
onShareTimeline(()=>{
  return{
    title: '慢慢电子回收网',
    path: `/pages/index/index`,
    query: `?share_uid=${uni.getStorageSync('id') || ''}`,
  }
})
</script>

<style lang="scss" scoped>
.container{
  width: 750rpx;
  height: 1624rpx;
  //background-image: url("../../common/images/invite.png");
  padding-top: 888rpx;
  background-size: cover;
  .scroll-Y {
    height: 300rpx;
  }

  .scroll-view-item {
    height: 300rpx;
    line-height: 300rpx;
    text-align: center;
    font-size: 36rpx;
  }
  .scroll-view-item_H {
    display: inline-block;
    width: 100%;
    height: 300rpx;
    line-height: 300rpx;
    text-align: center;
    font-size: 36rpx;
  }
  ::v-deep .u-navbar__content{
    background: rgba(255,255,255,0) !important;
  }
  button::after {
    border: none;
  }
  button {
    background-color: #fff;
  }
  .inviteBtn button{
    width: 666rpx;
    height: 92rpx;
    line-height: 92rpx;
    background: #FFC65B;
    box-shadow: 0rpx 12rpx 0rpx 0rpx #F58400, inset 0rpx 0rpx 10rpx 10rpx #FDD97A;
    border-radius: 222rpx 222rpx 222rpx 222rpx;
    text-align: center;
    font-weight: 700;
    font-size: 36rpx;
    color: #620905;
    margin: 0 auto;
  }
  .inviteList{
    margin: 64rpx auto 0;
    width: 704rpx;
    height: 368rpx;
    background: #FFFFFF;
    border-radius: 26rpx 26rpx 26rpx 26rpx;
    position: relative;
    .title{
      width: 230rpx;
      height: 56rpx;
      background: linear-gradient( 180deg, #FAA870 0%, #FF724E 100%);
      border-radius: 0rpx 0rpx 16rpx 16rpx;
      position: absolute;
      font-weight: 700;
      font-size: 28rpx;
      color: #FFFFFF;
      line-height: 50rpx;
      text-align: center;
      left: 236rpx;
      top: -12rpx;
    }
    .inviteCont{
      padding: 62rpx 36rpx 34rpx;
      font-weight: 500;
      font-size: 22rpx;
      color: #3D3D3D;
      line-height: 32rpx;
      .item{
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20rpx;
        .info{
          display: flex;
          align-items: center;
        }
        .time{
          color: #ACACAC;

        }
        image{
          width: 50rpx;
          height: 50rpx;
          margin-right: 20rpx;
        }
      }
      .noListTips{
        text-align: center;
      }
    }
  }
}
</style>
