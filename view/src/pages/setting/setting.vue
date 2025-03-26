<template>
	<view class="container">
    <view class="userInfo">
      <view class="item">
        <view class="title">头像</view>
        <view class="detail">
          <button
              class=""
              open-type="chooseAvatar"
              @chooseavatar="onChooseavatar"
          >
            <image class="headImg" :src="userInfo.avatar" />
            <image class="rightImg" src="../../common/images/Icon.png" />
            <!--        <view class="detail" @click="">-->
            <!--          <image class="headImg" :src="userInfo.avatar" />-->
            <!--          <image class="rightImg" src="../../common/images/Icon.png" />-->
            <!--        </view>-->
          </button>
        </view>

      </view>
      <view class="item">
        <view class="title">昵称</view>
        <view class="detail">
<!--          <view>{{userInfo.nickname}}</view>-->
          <up-input class="rightText"
              v-model="userInfo.nickname"
              border="none" @blur="updata"
              type="nickname"
              fontSize="28rpx"
              color="#666666"
          ></up-input>
          <image class="rightImg" src="../../common/images/Icon.png" />
        </view>
      </view>
<!--      <view class="item">-->
<!--        <view class="title">手机号</view>-->
<!--        <view>-->
<!--          <view>{{userInfo.mobile}}</view>-->
<!--          <view></view>-->
<!--        </view>-->
<!--      </view>-->

    </view>
<!--    <view class="exit">-->
<!--      <view class="title">退出登录</view>-->
<!--      <view>-->
<!--        <image class="rightImg" src="../../common/images/Icon.png" />-->
<!--      </view>-->
<!--    </view>-->
	</view>
</template>

<script setup>
import {ref, reactive, onMounted, watch} from "vue";
import {getUserinfo,modifyUser,uploadImg} from "../../api/apijs";
import {onShareAppMessage, onShareTimeline} from "@dcloudio/uni-app";
const userInfo = ref({})
const getInit = async ()=>{
  let res = await getUserinfo()
  if(res.code === 1){
    userInfo.value = res.data

  }
};
const onChooseavatar = (e) => {
  new Promise((resolve, reject) => {
    uni.getImageInfo({
      src: e.detail.avatarUrl,
      success: (res) => {
        // console.log("图片尺寸", res)
        resolve(res);
      },
      fail: (err) => {
        console.error("获取图片信息失败了", err)
        reject(err);
      },
    });
  })
      .then((res) => {
        return Promise.resolve({
          tempFilePath: e.detail.avatarUrl,
        });
      })
      .then((res) => {
        userInfo.value.avatar = e.detail.avatarUrl;
        return uploadImg(res.tempFilePath).then( async (res1) => {
          let newList = JSON.parse(res1)
          let res2 = await modifyUser({avatar: newList.data.file.url,mobile: userInfo.value.mobile,nickname: userInfo.value.nickname})
          uni.showToast({
            title: res2.msg,
            icon: 'none',
          })
          getInit();
        });
      })
};
const updata = async (value)=>{
  console.log(value,'value')
  let res2 = await modifyUser({
    avatar: userInfo.value.avatar,
    mobile: userInfo.value.mobile,
    nickname: userInfo.value.nickname,
  });
  uni.showToast({
    title: res2.msg,
    icon: 'none',
  });
  getInit();
}
// 监听 userInfo.value.nickname 的变化
/*watch(
    () => userInfo.value.nickname,
    async (newVal, oldVal) => {
      if (newVal !== oldVal && oldVal !== undefined ) {
        let res2 = await modifyUser({
          avatar: userInfo.value.avatar,
          mobile: userInfo.value.mobile,
          nickname: newVal,
        });
        uni.showToast({
          title: res2.msg,
          icon: 'none',
        });
        getInit();
      }
    }
);*/
onMounted(async(options) => {
  await getInit()
});
onShareAppMessage((res)=>{
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
  ::v-deep .u-input__content__field-wrapper__field{
    text-align: right !important;
  }
  button::after {
    border: none;
  }
  button {
    background-color: #fff;
  }
  button {
    border-radius: 0;
    display: flex;
    align-items: center;
    padding: 0;
  }
  .userInfo{
    width: 720rpx;
    //height: 306rpx;
    background: #FFFFFF;
    border-radius: 16rpx 16rpx 16rpx 16rpx;
    margin: 0 auto;
    .item{
      display: flex;
      align-items: center;
      justify-content: space-between;
      height: 102rpx;
      line-height: 102rpx;
      padding: 0 30rpx 0 40rpx;
      font-size: 28rpx;
      color: #9C9C9C;
      .title{
        width: 140rpx;
        height: 46rpx;
        font-weight: 500;
        font-size: 28rpx;
        color: #3D3D3D;
        line-height: 50rpx;
      }
      .detail{
        display: flex;
        align-items: center;
      }
      .headImg{
        width: 68rpx;
        height: 68rpx;
        border-radius: 50%;
      }
      .rightImg{
        width: 14rpx;
        height: 24rpx;
        margin-left: 16rpx;
      }
    }
  }
  .exit{
    display: flex;
    align-items: center;
    justify-content: space-between;
    line-height: 102rpx;
    padding: 0 30rpx 0 40rpx;
    font-size: 28rpx;
    color: #9C9C9C;
    width: 720rpx;
    height: 102rpx;
    background: #FFFFFF;
    border-radius: 16rpx 16rpx 16rpx 16rpx;
    margin: 20rpx auto 0;
    .title{
      width: 140rpx;
      height: 46rpx;
      font-weight: 500;
      font-size: 28rpx;
      color: #3D3D3D;
      line-height: 50rpx;
    }
    .detail{
      display: flex;
      align-items: center;
    }
    .headImg{
      width: 68rpx;
      height: 68rpx;
      border-radius: 50%;
    }
    .rightImg{
      width: 14rpx;
      height: 24rpx;
      margin-left: 16rpx;
    }

  }
}
</style>
