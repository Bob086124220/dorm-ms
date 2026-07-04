package com.huuc.dormitory.common.sms;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 短信服务控制台实现（演示/开发模式）
 * 将验证码输出到日志控制台
 */
public class ConsoleSmsServiceImpl implements SmsService {

    private static final Logger log = LoggerFactory.getLogger(ConsoleSmsServiceImpl.class);

    @Override
    public boolean sendVerificationCode(String phone, String code) {
        log.info("【验证码】手机号 {} → {}", phone, code);
        return true;
    }
}
