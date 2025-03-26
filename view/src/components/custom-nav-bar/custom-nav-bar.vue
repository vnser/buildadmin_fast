<template>
  <view class="layout">
    <view class="navbar" :style="{background:themeColor}">
      <view class="statusBar" :style="{height:getStatusBarHeight()+'px'}"></view>
      <view v-if="!isBack" class="titleBar" :style="{height:getTitleBarHeight()+'px',lineHeight:getTitleBarHeight()+'px'}">
        <view class="navBox">
          <view class="cardHolder" @click="gocardHolder">
            <image src="../../common/images/logo.png" mode="aspectFill"></image>
            名片夹
          </view>
          <view class="title">{{ name }}</view>
        </view>
      </view>
      <view v-if="isBack" class="titleBar" :style="{height:getTitleBarHeight()+'px',lineHeight:getTitleBarHeight()+'px'}">
        <view class="navBox">
          <view class="cardHolder" @click="goHome">
            <uni-icons color="#fff" type="left" size="26"></uni-icons>
          </view>
          <view class="title">{{ name }}</view>
        </view>
      </view>
    </view>

    <view class="fill" :style="{height:getNavBarHeight()+'px'}"></view>
  </view>
</template>

<script setup>
import {ref, onMounted, toRefs, watch} from 'vue';
import {onLoad, onReady} from "@dcloudio/uni-app";
import {getStatusBarHeight, getTitleBarHeight, getNavBarHeight} from "@/utils/system.js";
import {apiCard} from '@/api/apijs.js';

const gocardHolder = () => {
  uni.navigateTo({
    url: `/pages/cardHolder/index`
  });
};
const goHome = () => {
  uni.navigateTo({
    url: `/pages/index/index`
  });
};
const themeColor = ref('') ;
const storedThemeColor = uni.getStorageSync('themeColor');
const props = defineProps({
  name: {
    type: String,
    default: '',
  },
  isBack: {
    type: Boolean,
    default: true
  },
  bgColor: {
    type: String,
    default: '',
  },
  isBgReq: {
    type: Boolean,
    default: false
  },
})
onLoad(() => {
  // console.log('bgcolor:');
  // console.log(props.bgColor)
  if (props.isBgReq) {
    if (storedThemeColor) {
      themeColor.value = storedThemeColor;
    } else {
      apiCard().then((res) => {
        if (res.code == 1) {
          uni.setStorageSync('themeColor', res.data.bg_color)
          themeColor.value = res.data.bg_color;
        }
      })

    }
  }else{
    watch(() => props.bgColor, (newValue) => {
      themeColor.value = props.bgColor;
    },{deep:1})

  }
})
</script>

<style lang="scss" scoped>
.layout {
  .navbar {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    z-index: 10;
    // background-color: #2982E1;
    background-color: v-bind(themeColor);

    .statusBar {
    }

    .titleBar {
      padding: 0 30rpx;
      height: 100rpx;
      position: relative;
      text-align: center;

      .navBox {
        //height: 60rpx;
        //line-height: 60rpx;
        // background-color: #2982E1;
        // background-color: v-bind(themeColor);
        color: #fff;
        font-size: 28rpx;
        .title{
          font-size: 34rpx;
          font-weight: bold;
        }
        .cardHolder {
          font-size: 28rpx;
          position: absolute;
          display: flex;
          align-items: center;

          image {
            width: 28rpx;
            height: 28rpx;
            margin-right: 12rpx;
          }
        }
      }
    }
  }

  .fill {

  }
}
</style>