package com.bms.config.shiro;

import com.bms.model.User;
import com.bms.service.UserService;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.SimpleAuthenticationInfo;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.subject.PrincipalCollection;
import org.apache.shiro.util.ByteSource;
import org.springframework.beans.factory.annotation.Autowired;

//实现AuthorizingRealm接口用户用户认证
public class    MyShiroRealm extends AuthorizingRealm {

    @Autowired
     private UserService userService;

    /**
     * 权限认证，为当前登录的Subject授予角色和权限
     *
     * 1. 如有需要控制权限的需求、  如下 调用doGetAuthorizationInfo 方法
     *
     *  1):shiro:hasPermission
     *  2):shiro:hasRole
     *  3):注解模式
     *
     * 2.	并且每次访问需授权资源时都会执行该方法中的逻辑，这表明本例中默认并未启用AuthorizationCache
     *
     * 3.	如果连续访问同一个URL（比如刷新），该方法不会被重复调用，
     *
     * Shiro有一个时间间隔（也就是cache时间，在ehcache-shiro.xml中配置），超过这个时间间隔再刷新页面，该方法会被执行
     */
    @Override
    protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principalCollection) {
        return null;
    }


    /**
     * 获取身份验证信息（验证账户密码）
     */
    @Override
    protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken authenticationToken) throws AuthenticationException {
        //加这一步的目的是在Post请求的时候会先进认证，然后在到请求
        if (authenticationToken.getPrincipal() == null) {
            return null;
        }
        //获取用户信息
        String account = authenticationToken.getPrincipal().toString();
        User user = userService.findByCount(account);
        try {
            if (user == null){
                return null;
            }else {
                //这里验证authenticationToken和simpleAuthenticationInfo的信息
                SimpleAuthenticationInfo simpleAuthenticationInfo = new SimpleAuthenticationInfo(user.getAccount(),
                        user.getPassword()
                        , getName());
                return simpleAuthenticationInfo;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }
}