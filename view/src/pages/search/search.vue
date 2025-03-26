<template>
	<view class="container">
    <up-search placeholder="请输入关键词" :focus="true" :show-action="false" @change="handleChange" :inputStyle="{height: '76rpx'}" v-model="keyword"></up-search>
    <view class="tipSearch" >
      <view class="tipsItem" v-if="flattenedClassifyList.length > 0" v-for="(item, index) in flattenedClassifyList" :key="index" @click="goDetail(item.id)">
        <view>{{ item.title }}</view>
        <view class="redSize">{{ item.classifyPath }}</view>
      </view>
      <view class="noList" v-if="flattenedClassifyList.length === 0 && keyword !== '' ">暂无数据~</view>

    </view>
	</view>
</template>

<script setup>
import { ref,reactive,computed } from "vue";
import {getSearchGoods} from '@/api/apijs.js';
import {onShareAppMessage, onShareTimeline} from "@dcloudio/uni-app";
// 响应式数据
const keyword = ref('');
const classifyList = ref([])
const goDetail = (id) => {
  uni.navigateTo({
    url: `/pages/product/product?id=${id}`
  })
}
const flattenedClassifyList = computed(() => {
  return classifyList.value.flatMap(item => {
    if (item.classify_batch.length === 0) {
      return [{ id: item.id,title: item.title, classifyPath: '' }];
    } else {
      return item.classify_batch.map(classifyPath => ({
        id: item.id,
        title: item.title,
        classifyPath: classifyPath,

      }));
    }
  });
});

const handleChange = async (val) => {
  if (val){
    let res = await getSearchGoods({name: val})
    if(res.code === 1){
      classifyList.value = res.data
    }
  }else{
    classifyList.value = []
  }


}
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
  padding: 16rpx 34rpx;
  .tipSearch{
    .tipsItem{
      display: flex;
      align-items: center;
      font-size: 24rpx;
      color: #000000;
      line-height: 34rpx;
      padding: 24rpx 0;
      .redSize{
        font-size: 20rpx;
        color: #F2340F;
        line-height: 34rpx;
        margin-left: 20rpx;
      }
    }
    .noList{
      font-size: 24rpx;
      margin-top: 20rpx;
    }
  }
}
</style>
