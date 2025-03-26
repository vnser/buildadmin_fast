<script>
	export default {
		// onLaunch: function() {
		// 	console.log('App Launch')
		// },
    globalData: {},
    onLaunch: function() {
      console.log('App Launch');
      uni.getSystemInfo({ //设置屏幕高度
        success: res => {
          //减去tabbar的高度，默认为50px
          this.globalData.screenHeight = res.screenHeight - 50;
        }
      })
    },

    onShow: function() {
			console.log('App Show')
		},
		onHide: function() {
			console.log('App Hide')
		}
	}
</script>

<style lang="scss">
@import "@/uni_modules/uview-plus/index.scss";
@import "common/style/common-style.scss";
</style>
