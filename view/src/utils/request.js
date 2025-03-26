
// const BASE_URL = env[uni.getAccountInfoSync().miniProgram.envVersion]
import {API_BASE_URL} from '../config';


// const BASE_URL = 'https://mm-recycle-devs.com/index.php';
const BASE_URL = API_BASE_URL
import {apiLogin} from '@/api/apijs.js';
let isLoading = false;

const login = async () => {
    if (isLoading) return;
    isLoading = true;
    try {
        // console.log('222')
        const result = await uni.login({
            provider: 'weixin',
            onlyAuthorize: true
        });
        isLoading = false;
        if (result.errMsg === 'login:ok') {
            // console.log('result',result);
            const {code} = result;
            console.log('share_uid',uni.getStorageSync('share_uid'))
            // 调用登录接口
            const loginRes = await apiLogin({
                code: code,
                type: 'mp',
                share_uid: uni.getStorageSync('share_uid') || 1,
            });
            if (loginRes.code === 1) {
                uni.setStorageSync('token', loginRes.data.token);
                // uni.showToast({
                //   title: '登录成功',
                //   icon: 'none'
                // });
                console.log('接口获取到的token', uni.getStorageSync('token'));
                return loginRes.data.token;
            }
        } else {
            console.error('登录状态失败', result);
            throw new Error('登录状态失败')
        }
    } catch (error) {
        isLoading = false;
        console.error('uni.login 登录失败', error);
        throw error
    }

};

// 获取 token
function getToken() {
    return  uni.getStorageSync('token') || '';
}

export function request(config = {}) {
    let {
        url,
        data = {},
        method = "GET",
        header = {}
    } = config;

    // 添加默认的 Authorization 头
    header.token = getToken();
    url = BASE_URL + url;
    return new Promise((resolve, reject) => {
        // console.log('token', uni.getStorageSync('token'));

        // if (!uni.getStorageSync('token')) {
        //     await login();
        // }
        uni.request({
            url,
            data,
            method,
            header,
            success: res => {
                if (res.statusCode === 200) {
                    if (res.data.code === -2) {
                        console.log('认证失败');
                        //需要登录
                        login().then(() => {
                            request(config).then(resolve).catch(reject);
                        });
                        return;
                        /* login().then(() => {
                           // 重新发起请求
                           request(config).then(resolve).catch(reject);
                         }).catch(reject);*/
                    }
                    if (res.data.code === 1){//
                        //后端程序状态处理正常
                        resolve(res.data);
                    }else if (res.data.code === 0){
                        //后端接口错误状态，提示信息
                        uni.showToast({
                            title: res.data.msg,
                            icon: "none"
                        });
                        reject(res.data);
                    }
          /*      } else if (res.statusCode === 400) {
                    uni.showModal({
                        title: "错误提示",
                        content: res.errMsg,
                        showCancel: false,
                    });
                    reject(res.data);*/
                } else {
                    //HTTP状态码不正确 非200
                    uni.showToast({
                        title:"服务端异常，请稍后再试吧",
                        icon: "none"
                    });
                    reject(res.data);
                }
            },
            fail: err => {
                reject(err);
            }
        });
    });
}
