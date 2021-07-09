import {NativeModules} from 'react-native';
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
   * 获取实验参数
   * @returns {Promise<*>}
   */
  static getAbSdkVersion = async () => {
    return await RangersAppLogModule.getAbSdkVersion();
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
}

export default RangersAppLog;
