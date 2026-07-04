package com.huuc.dormitory.common.sms;

/**
 * 短信服务接口
 * 演示模式通过控制台输出验证码，生产环境可替换为阿里云/腾讯云实现
 */
public interface SmsService {

    /**
     * 发送短信验证码
     *
     * @param phone 手机号
     * @param code  验证码
     * @return true=发送成功
     */
    boolean sendVerificationCode(String phone, String code);
}
