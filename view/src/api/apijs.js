import {request} from "@/utils/request.js"
import {API_BASE_URL} from "../config";
export function apiCard(){  //首页接口
	return request({url:"/card/index/init"})
}
//小程序登录
export function apiLogin(data={}){
	return request({
		url:"/manman/account/login",
		method: 'POST',
		data
	})
}
//小程序上传图片
// export function uploadImg(data={}){
// 	return request({
// 		url:"/manman/util/upload_img",
// 		method: 'POST',
// 		data
// 	})
// }

export function uploadImg(filePath) {
	return new Promise((resolve, reject) => {
		uni.uploadFile({
			url: API_BASE_URL+'/manman/util/upload_img',
			filePath: filePath,
			name: 'file',
			header: {
				'token': uni.getStorageSync('token'),
			},
			formData: {
				type: 'picture'
			},
			success: function(uploadRes) {
				resolve(uploadRes.data);
			},
			fail: function(err) {
				reject(err);
			}
		});
	});
}
//基础信息
export function getBasic(data={}){  //首页轮播图
	return request({
		url:"/manman/index/basic",
		method: 'GET',
		data
	})
}
export function getBanner(data={}){  //首页轮播图
	return request({
		url:"/manman/index/banner",
		method: 'GET',
		data
	})
}
//门店列表
export function getStoreInfo(data={}){
	return request({
		url:"/manman/index/store_info",
		method: 'GET',
		data
	})
}
//废旧手机报价
export function getBrandQuotation(data={}){
	return request({
		url:"/manman/index/brand_quotation",
		method: 'GET',
		data
	})
}
//获取分类+产品
export function getClassifyGoods(data={}){
	return request({
		url:"/manman/product/classify_goods",
		method: 'POST',
		data
	})
}
//产品详情
export function getGoods(data={}){
	return request({
		url:"/manman/product/goods",
		method: 'POST',
		data
	})
}
//产品搜索
export function getSearchGoods(data={}){
	return request({
		url:"/manman/product/search_goods",
		method: 'POST',
		data
	})
}
//会员信息
export function getUserinfo(data={}){
	return request({
		url:"/manman/my/userinfo",
		method: 'GET',
		data
	})
}
//邀请好友
export function invite(data={}){
	return request({
		url:"/manman/my/invite",
		method: 'GET',
		data
	})
}
//修改信息
export function modifyUser(data={}){
	return request({
		url:"/manman/my/modify_user",
		method: 'POST',
		data
	})
}





export function myCard(data={}){  //我的卡片
	return request({
		url:"/card/my_card/lists",
		method: 'POST',
		data
	})
}
export function deleteCard(data={}){  //删除卡片
	return request({
		url:"/card/my_card/remove",
		method: 'POST',
		data
	})
}
export function cardDetail(data={}){  //卡片详情
	return request({
		url:"/card/card_info",
		method: 'POST',
		data
	})
}
export function articleDetail(data={}){  //加载文章内容
	return request({
		url:"/card/index/get_article",
		method: 'POST',
		data
	})
}
//自定义分享名片



