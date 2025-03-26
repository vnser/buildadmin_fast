<template>
	<view class="container" :style="{'height': screenHeight + 'px', 'position': show ? 'fixed' : ''}">
    <view class="topBox">
      <view class="searchBox">
        <view class="tips">选择产品</view>
        <up-search placeholder="请输入关键词" @focus="goSearch" :show-action="false" :inputStyle="{height: '76rpx'}" v-model="keyword"></up-search>
      </view>
      <view>
        <up-tabs :list="classifyGoods" @click.stop="clickLevel" keyName="title" lineWidth="28" lineColor="#FF4800"
                 :activeStyle="{
            color: '#3D3D3D',
            fontWeight: 'bold',
			      fontSize:'28rpx'
           }"
                 :inactiveStyle="{
            color: '#666666',
			      fontSize:'28rpx'
        }"
        ></up-tabs>
      </view>
    </view>
    <view class="detailBox">
<!--      二级菜单-->
      <view class="navigationBox">
        <scroll-view scroll-y class="scroll-y-t">
          <view :class="item.active ? 'SecItemA':'SecItem'" v-for="item in SecNavigation" @click="handle(item)">
            <view class="active" v-if="item.active"></view>
            {{item.title}}
          </view>
        </scroll-view>
      </view>
<!--      三级菜单-->
      <view :class="isLoading ? 'productLoad' : 'productNoL'">
        <view class="loadingBox" v-if="isLoading">
          <up-loading-icon></up-loading-icon>
        </view>
        <view class="detailInfo" v-else>

          <view class="infoItem" v-for="item in productList" :key="item.id" v-if="productList.length > 0">
            <view class="title">{{item.title}}</view>
            <view class="content">
              <view class="product" v-if="item.goods.length > 0" v-for="itemC in item.goods" @click="goDetail(itemC)">
                <view class="productLeft">
                  <view class="tag"></view>
                  <view>{{itemC.title}}</view>
                </view>
                <view class="productRight">
                  <view class="price">￥{{itemC.price}}</view>
                  <view class="estimate">预计可卖</view>
                </view>
              </view>
              <view v-else class="noList">暂无数据~</view>
            </view>
          </view>
          <view class="noList" v-else>暂无数据~</view>
        </view>
      </view>
    </view>
    <up-popup :show="show" @close="close" @open="open" >
      <view class="popProduct">
        <view class="productTitle">{{goodsInfo.title}}</view>
        <mm-product :goodsInfo="goodsInfo" :isScroll="true"></mm-product>
      </view>
    </up-popup>
  </view>
</template>

<script setup>
import {ref,reactive,onMounted } from "vue";
import {onLoad, onShareAppMessage, onShareTimeline} from "@dcloudio/uni-app";
import MmProduct from "../../components/mm-product/mm-product.vue";
import {getClassifyGoods,getGoods} from "../../api/apijs";
const screenHeight = ref(getApp().globalData.screenHeight);
const classifyGoods = ref([]);
const isLoading = ref(false);
const goodsInfo = ref({})
const productList = ref([]);
onLoad(async (options) => {
  console.log(getApp().globalData.screenHeight)

});
const show = ref(false);

// 定义方法
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

const keyword = ref('');
const list1 = ref([
  { name: '二手手机' },
  { name: '电脑回收' },
  { name: '杂货铺' },
  { name: '二手平板' }
]);
const SecNavigation = ref([
]);
const handle = async (item) => {
  console.log('点击了二级菜单',item)
  productList.value = []
  for (let item in SecNavigation.value){
    SecNavigation.value[item].active = false;
  }
  item.active = true;
  isLoading.value = true;
  //获取具体得产品
  let res2 = await getClassifyGoods({pid: item.id})
  isLoading.value = false;
  // console.log('具体得三级产品',res2.data)
  productList.value = res2.data
}

// 定义方法
const clickLevel = async (item)=> {
  SecNavigation.value = []
  productList.value = []
  isLoading.value = true;
  //获取二级分类
  let res1 = await getClassifyGoods({pid: item.id})
  isLoading.value = false;
  console.log('获取成功')
  SecNavigation.value = res1.data
  for (let i = 0; i < SecNavigation.value.length; i++) {
    SecNavigation.value[i].active = false;
  }
  SecNavigation.value[0].active = true;

  //获取具体得产品
  let res2 = await getClassifyGoods({pid: SecNavigation.value[0].id})

  // console.log('具体得三级产品',res2.data)
  productList.value = res2.data
}
const goDetail = async (itemC) => {
  let res = await getGoods({goods_id: itemC.id})
  if(res.code === 1){
    goodsInfo.value = res.data
    console.log('父组件传给子组件的数据')
  }
  show.value = true;
}
const goSearch = () => {
  uni.navigateTo({
    url: '/pages/search/search'
  })
}
const getInit = async ()=>{
  let res = await getClassifyGoods({pid: 0})
  console.log(res)
  if(res.code === 1){
    classifyGoods.value = res.data
    console.log(classifyGoods.value[0].id)

    let res1 = await getClassifyGoods({pid: classifyGoods.value[0].id})
    SecNavigation.value = res1.data
    for (let i = 0; i < SecNavigation.value.length; i++) {
      SecNavigation.value[i].active = false;
    }
    SecNavigation.value[0].active = true;
    isLoading.value = true;
    //获取具体得产品
    let res2 = await getClassifyGoods({pid: SecNavigation.value[0].id})
    isLoading.value = false;
    console.log('具体得三级产品',res2.data)
    productList.value = res2.data
  }
};
onMounted(async(options) => {
  await getInit()
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
  //position: relative;
  display: flex;
  flex-direction: column;

  .popProduct{
    height: 1298rpx;
    .productTitle{
      color: #3D3D3D;
      //height: 46rpx;
      //line-height: 46rpx;
      font-size: 32rpx;
      text-align: center;
      font-weight: 700;
      padding: 10rpx 0;
    }
  }
  .topBox{
    padding: 16rpx 34rpx 24rpx;
    .searchBox{
      display: flex;
      align-items: center;
      font-weight: 500;
      font-size: 28rpx;
      color: #2A2A2A;
      line-height: 50rpx;
      text-align: center;
      .tips{
        margin-right: 18rpx;
      }
    }
  }
  .detailBox{
    flex: 1;
    position: absolute;
    top: 190rpx;
    width: 750rpx;
    display: flex;
    .productNoL{
      width: 100%;
    }
    .productLoad{
      width: 100%;
      display: flex;
      justify-content: center;
      align-items: center;
    }
    .navigationBox{
      width: 196rpx;
      font-size: 26rpx;
      .scroll-y-t{

      }
      .SecItem,.SecItemA{
        padding: 18rpx 22rpx 18rpx 22rpx;
        background: #F7F7F7;
        position: relative;
        .active{
          position: absolute;
          left: 0;
          width: 6rpx;
          height: 42rpx;
          background: #FF4800;
        }
      }
      .SecItemA{
        background: #fff;
      }
    }

    .detailInfo{
      padding: 0 24rpx;
      flex: 1;
      .infoItem{
        .title{
          font-weight: 700;
          font-size: 36rpx;
          color: #FF4800;
          line-height: 36rpx;
          padding-top: 24rpx;
        }
        .content{
          .product{
            height: 128rpx;
            border-bottom: 1rpx solid #D8D8D8;
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: #3D3D3D;
            font-size: 28rpx;
            .price{
              color: #FF4800;
              font-size: 24rpx;
            }
            .estimate{
              margin-top: 2rpx;
              color: #9E9E9E;
              font-size: 24rpx;
            }
            .productLeft{
              display: flex;
              align-items: center;
              .tag{
                width: 16rpx;
                height: 16rpx;
                border-radius: 50%;
                background: #D7D7D7;
                margin-right: 10rpx;
              }
            }
            .productRight{
              text-align: right;
            }
          }
        }
      }
      .noList{
        margin-top: 40rpx;
        font-size: 24rpx;
      }
    }
  }
}
</style>
