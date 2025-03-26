<template>
	<view class="container">
    <mm-product :goodsInfo="goodsInfo" ></mm-product>
  </view>
</template>

<script setup>
import { ref,reactive } from "vue";
import {onLoad, onShareAppMessage, onShareTimeline} from "@dcloudio/uni-app";
import MmProduct from "../../components/mm-product/mm-product.vue";
import {getGoods} from "../../api/apijs";

const goodsInfo = ref({})

onLoad(async (options) => {
  console.log(options.id)
  let res = await getGoods({goods_id: options.id})
  if(res.code === 1){
    goodsInfo.value = res.data
  }
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
  width: 100%;
  background: #F6F6F6;
  min-height: 100vh;
  padding-top: 16rpx;

}
</style>
