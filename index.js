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
   *     logNeedEncrypt: String(true/false),
   *     autoStart: String(true/false),
   *     host: String
   * }
   */
  static init = (params = {
    appId: '',
    appName: '',
    channel: '',
    abEnable: 'true',
    showDebugLog: 'false',
    logNeedEncrypt: 'true',
    autoStart: 'true',
    host: ''
  }) => {
    (params.appId ?? '') !== '' && RangersAppLogModule.init(params);
  };

  /**
   * 设置是否自启动，如果用户已经授权的情况下设为true，否则设为false
   * false的情况下必须在用户同意隐私弹窗后调用，否则不会存储和上报事件
   */
  static start = () => {
    RangersAppLogModule.start();
  }

  /**
   * 自定义事件
   * @param event 事件名称
   * @param params 事件参数
   */
  static onEvent = (event = '', params = {}) => {
    event !== '' && RangersAppLogModule.onEventV3(event, params);
  };

  /**
   * 设置事件公共属性
   * @param headerInfo
   */
  static setHeaderInfo = (headerInfo = {}) => {
    RangersAppLogModule.setHeaderInfo(headerInfo);
  };

  /**
   * 移除事件公共属性
   * @param customKey
   */
   static removeHeaderInfo = (customKey = '') => {
    customKey !=='' && RangersAppLogModule.removeHeaderInfo(customKey);
  };

  /**
   * 设置用户属性，存在则覆盖，不存在则创建
   * @param params
   */
   static profileSet = (params = {}) => {
    RangersAppLogModule.profileSet(params);
  };

  /**
   * 设置用户属性，存在则不设置，不存在则创建，适合首次相关的用户属性，比如首次访问时间等
   * @param params
   */
   static profileSetOnce = (params = {}) => {
    RangersAppLogModule.profileSetOnce(params);
  };

  /**
   * 设置数值类型的属性，可进行累加
   * @param params
   */
   static profileIncrement = (params = {}) => {
    RangersAppLogModule.profileIncrement(params);
  };

  /**
   * 向用户的某个 List 类型的属性添加属性，比如爱好
   * @param params
   */
   static profileAppend = (params = {}) => {
    RangersAppLogModule.profileAppend(params);
  };

  /**
   * 删除用户的属性
   * @param customKey
   */
   static profileUnset = (customKey = '') => {
    RangersAppLogModule.profileUnset(customKey);
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
   * 清除业务 id
   * user_unique_id
   */
  static clearUserUniqueId = () => {
    RangersAppLogModule.clearUserUniqueId();
  }

  /**
   * 获取实验参数（曝光的）
   * @returns {Promise<*>}
   */
  static getAbSdkVersion = async () => {
    return await RangersAppLogModule.getAbSdkVersion();
  };

  /**
   * 获取 AB 测试的配置（异步获取）
   * 第二个参数 "0" 为实验兜底值，建议和对照组 value 一致，在网络延迟或实验停止时返回此值
   */
  static getABTestConfigValueForKey = async (key = '', defaultValue = '0') => {
    return await RangersAppLogModule.getABTestConfigValueForKey(
      key,
      defaultValue,
    );
  };

  /**
   * 获取 AB 测试的配置（同步获取）
   * 第二个参数 "0" 为实验兜底值，建议和对照组 value 一致，在网络延迟或实验停止时返回此值
   */
  static getABTestConfigValueForKeySync = (key = '', defaultValue = '0') => {
    return RangersAppLogModule.getABTestConfigValueForKeySync(
        key,
        defaultValue,
    );
  };

  /**
   * 获取ABTest相关配置
   * 返回ABTest的所有的Configs值
   * 此接口不会触发曝光，可以随意读取。
   * 如果正常为了做实验，请勿使用此接口，请使用getABTestConfigValueForKey、getABTestConfigValueForKeySync接口
   */
  static getAllAbTestConfigs = async () => {
    let res = {};
    if (Platform.OS === 'ios') {
      res = await RangersAppLogModule.getAllAbTestConfigs();
    } else {
      let resStr = await RangersAppLogModule.getAllAbTestConfigs();
      if ((resStr ?? '') !== '' && (resStr ?? '') !== 'null') {
        try {
          res = JSON.parse(resStr);
        } catch (e){}
      }
    }
    return res;
  }

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
