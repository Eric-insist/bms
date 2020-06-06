package com.bms.config.shiro;


import com.bms.model.User;
import org.apache.shiro.crypto.SecureRandomNumberGenerator;
import org.apache.shiro.crypto.hash.SimpleHash;

public class ShiroPwd {
    public static User encodePwd(User user, String pwd) {
        String hashAlgorithmName = "MD5";//加密算法
        String salt1 = user.getAccount();
        String salt2 = new SecureRandomNumberGenerator().nextBytes().toHex();
        // 盐：为了即使相同的密码不同的盐加密后的结果也不同
        // 密码
        Object source = pwd;
        // 加密次数
        int hashIterations = 1024;
        SimpleHash result = new SimpleHash(hashAlgorithmName, source, salt2, hashIterations);
        user.setPassword(result.toString());
        user.setSalt(salt2);
        return user;
    }

}
