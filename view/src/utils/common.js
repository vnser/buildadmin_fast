export function compareTime(timestamp) {
    const currentTime = Date.now();
    const diff = currentTime - timestamp;

    if (diff < 60000) {
        return '1分钟内';
    } else if (diff < 3600000) {
        return Math.floor(diff / 60000) + '分钟前';
    } else if (diff < 86400000) {
        return Math.floor(diff / 3600000) + '小时前';
    } else if (diff < 2592000000) {
        return Math.floor(diff / 86400000) + '天前';
    } else if (diff < 7776000000) {
        return Math.floor(diff / 2592000000) + '个月前';
    } else {
        return null;
    }
}

export function gotoHome(){
	uni.showModal({
		title:"提示",
		content:"页面有误将返回首页",
		showCancel:false,
		success: (res) => {
			if(res.confirm){
				uni.reLaunch({
					url:"/pages/index/index"
				})
			}
		}
	})
}