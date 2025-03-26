<template>
  <view class="layout" >
    <scroll-view  scroll-y class="scroll-y">
    <view class="productImg">
      <swiper class="swiper-box" indicator-dots circular>
        <swiper-item v-for="(item, index) in goodsInfo?.images" :key="i">
          <image @click="showImg(index)" style="height: 100%" :src="item" mode="widthFix" />
        </swiper-item>
      </swiper>
    </view>
    <view class="recycleDetail" v-if="goodsInfo?.goods_attr.length > 0">
      <view class="title">
        <view class="active"></view>
        <view>回收价格</view>
      </view>
      <view class="cont">
        <view class="item" v-for="item in goodsInfo?.goods_attr" :key="item.product_goods_id">
          <view>
            <view>{{item.name}}</view>
          </view>
          <view class="itemRight">
            <view>回收价：</view>
            <view class="price">￥{{item.payback_price}}{{item?.unit ? '/' : ''}}{{item?.unit}}</view>
          </view>
        </view>
      </view>
    </view>
    </scroll-view>
  </view>
</template>

<script setup>
import { onMounted,ref,watch } from "vue";
import {onLoad} from "@dcloudio/uni-app";
const goodsInfo = ref({})
const props = defineProps({
  isScroll: {
    type: Boolean,
    default: false,
  },
  goodsInfo: {
    type: Object,
    default: () => {
      return {}
    }
  }
})
//预览产品
const showImg = (index)=>{
  uni.previewImage({
    current: goodsInfo.value.images[index],
    urls: goodsInfo.value.images
  })
}
watch(
    () => props.goodsInfo,
    (newVal) => {
      console.log('goodsInfo changed', newVal);
      goodsInfo.value = newVal;
      if (goodsInfo.value.title) {
        uni.setNavigationBarTitle({
          title: goodsInfo.value.title
        });
      } else {
        console.warn('goodsInfo.title is undefined, cannot set navigation bar title.');
      }
    },
    { immediate: true }
);
onMounted(() => {
  if(props.isScroll){
  }else{
    console.log('非弹窗')
  }
});
</script>

<style lang="scss" scoped>
.layout{
  width: 750rpx;
  position: relative;
  text-align: center;
  z-index: 9999;
  .scroll-y{
    height: 1282rpx;
  }
  .recycleDetail{
    text-align: left;
    position: relative;
    padding: 0 26rpx;
    margin-top: 34rpx;
    .active{
      width: 6rpx;
      height: 42rpx;
      background: #FF4800;
      position: absolute;
      left: 0;
      top: 0;
    }
    .title{
      font-weight: 700;
      font-size: 28rpx;
      color: #2A2A2A;
      line-height: 20rpx;
      padding: 12rpx 0;
    }
    .cont{
      padding-bottom: 32rpx;
      .center{
        display: flex;
        justify-content: center !important;
      }
      .item{
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 32rpx 0;
        color: #3D3D3D;
        font-size: 28rpx;
        .itemRight{
          color: #9E9E9E;
          .price{
            color: #FF4800;
          }
        }
        .logo{
          width: 24rpx;
          height: 24rpx;
          background: #9E9E9E;
          border-radius: 50%;
          display: flex;
          align-items: center;
          justify-content: center;
          margin-left: 10rpx;
        }
        view{
          display: flex;
          align-items: center;

        }
      }
    }
  }
  .productImg{
    //width: 288rpx;
    //height: 484rpx;
    height: 900rpx;
  }
  .swiper-box {
    //width: 100%;
    //height: 900rpx;
    height: 100%;
  }
   .swiper-item{
    display: flex !important;
    align-items: center !important;
  }
  .tags{
    margin: 34rpx 0 48rpx;
    width: 140rpx;
    height: 50rpx;
    background: #FF4800;
    font-size: 24rpx;
    color: #fff;
    left: 0;
    top: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    .logo{
      width: 20rpx;
      height: 20rpx;
      border: 2rpx solid #fff;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-left: 4rpx;
    }
  }
}
</style>