

/**
 * 正式、测试版地址
 * @type {string}
 */
const _API_BASE_URL = 'https://mm-recycle.jishu.sgtimes.cn/index.php';

/**
 * CDN图片资源地址
 * @type {string}
 */
const _CDN_BASE_URL = 'https://mm-recycle.jishu.sgtimes.cn/';

/**
 * 本地开发接口地址(@开发)
 * @type {string}
 */
// const _API_DEV_BASE_URL = 'https://mm-recycle-devs.com/index.php';
const _API_DEV_BASE_URL = 'https://mm-recycle.jishu.sgtimes.cn/index.php';

/**
 * CDN图片资源地址（@开发）
 * @type {string}
 */
// const _CDN_DEV_BASE_URL = 'https://mm-recycle-devs.com';
const _CDN_DEV_BASE_URL = 'https://mm-recycle.jishu.sgtimes.cn/';


/** 核心代码**********/

const _envVersion = uni.getAccountInfoSync().miniProgram.envVersion
const _api_base_env = {
    // develop: 'https://zbmp.jishu.sgtimes.cn/index.php',
    develop: _API_DEV_BASE_URL,
    trial: _API_DEV_BASE_URL,
    release: _API_BASE_URL,
}
const _cdn_base_env = {
    // develop: 'https://zbmp.jishu.sgtimes.cn/index.php',
    develop: _CDN_DEV_BASE_URL,
    trial: _CDN_BASE_URL,
    release: _CDN_BASE_URL,
}
export const CDN_BASE_URL = _cdn_base_env[_envVersion] || _cdn_base_env.release;
export const API_BASE_URL = _api_base_env[_envVersion] || _api_base_env.release;