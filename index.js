import {NativeModules, Platform} from 'react-native';
const {RangersAppLogModule} = NativeModules;

class RangersAppLog {
  /**
   * 初始化
   * @param params
   * {
   *     appId: String,
   *     appName: String,
   *     channel: String,
   *     abEnable: String(true/false),
   *     showDebugLog: String(true/false),
   *     logNeedEncrypt: String(true/false)
   * }
   */
  static init = (params = {}) => {
    (params.appId ?? '') !== '' && RangersAppLogModule.init(params);
  };

  /**
   * 自定义事件
   * @param event 事件名称
   * @param params 事件参数
   */
  static onEvent = (event = '', params = {}) => {
    event !== '' && RangersAppLogModule.onEventV3(event, params);
  };

  /**
   * 设置公共属性
   * @param headerInfo
   */
  static setHeaderInfo = (headerInfo = {}) => {
    RangersAppLogModule.setHeaderInfo(headerInfo);
  };

  /**
   * 设置业务 id
   * user_unique_id
   * @param id 业务id
   */
  static setUserUniqueId = (id = '') => {
    id !== '' && RangersAppLogModule.setUserUniqueId(id);
  };

  /**
   * 获取实验参数（曝光的）
   * @returns {Promise<*>}
   */
  static getAbSdkVersion = async () => {
    return await RangersAppLogModule.getAbSdkVersion();
  };

  /**
   * 获取实验参数
   * @returns {Promise<*>}
   */
  static getAllAbSdkVersion = async () => {
    let res = '';
    if (Platform.OS === 'ios') {
      //ios 14320,14338
      res = await RangersAppLogModule.getAllAbSdkVersion();
    } else {
      //android null或者{"name":{"val":"1","vid":"20511"},"ttttt":{"val":"aa","vid":"20670"}}
      let resStr = await RangersAppLogModule.getAllAbSdkVersion();
      if ((resStr ?? '') !== '' && (resStr ?? '') !== 'null') {
        try {
          let resObj = JSON.parse(resStr);
          let vidArr = [];
          Object.keys(resObj).map(key => {
            if ((resObj?.[key]?.vid??'') !== '') {
              vidArr.push(resObj?.[key]?.vid ?? '');
            }
          });
          res = [...new Set(res)];
          res = vidArr.join(',');
        } catch (e){}
      }
    }
    return res;
  };

  /**
   * 获取 AB 测试的配置
   * 第二个参数 "0" 为实验兜底值，建议和对照组 value 一致，在网络延迟或实验停止时返回此值
   */
  static getABTestConfigValueForKey = async (key = '', defaultValue = '0') => {
    return await RangersAppLogModule.getABTestConfigValueForKey(
      key,
      defaultValue,
    );
  };

  /**
   * 获取 did
   * @returns {Promise<*>}
   */
  static getDeviceID = async () => {
    return await RangersAppLogModule.getDeviceID();
  };

  /**
   * 获取 UUID
   * @returns {Promise<*>}
   */
  static getUserUniqueID = async () => {
    return await RangersAppLogModule.getUserUniqueID();
  };

  /**
   * 获取SSID
   * @returns {Promise<*>}
   */
  static getSsid = async () => {
    return await RangersAppLogModule.getSsid();
  };
}

export default RangersAppLog;
