<template>
	<view class="container">
    <mpHtml :content="content" />
	</view>
</template>

<script setup>
import { ref,reactive,onMounted } from "vue";
import mpHtml from 'mp-html/dist/uni-app/components/mp-html/mp-html.vue'
import {getBasic} from '@/api/apijs.js';
import {onLoad} from "@dcloudio/uni-app";
const content = ref();
onLoad(async (options) => {
  uni.setNavigationBarTitle({
    title: options.type == 0 ? '免责申明' : options.type == 1 ? '平台政策' : '关于平台'
  });
  let res = await getBasic()
  content.value =  options.type == 0 ? res.data.disclaimer : options.type == 1 ? res.data.platform_policy : res.data.about_platform
});
</script>

<style lang="scss" scoped>
.container{
  width: 100%;
  padding: 20rpx;
}
</style>
