package com.huuc.dormitory.dao;

import com.huuc.dormitory.entity.SysUser;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 用户Mapper接口
 */
public interface SysUserMapper {

    /**
     * 根据用户名查询用户
     */
    SysUser selectByUsername(String username);

    /**
     * 根据ID查询用户
     */
    SysUser selectById(Long userId);

    /**
     * 插入用户
     */
    int insert(SysUser user);

    /**
     * 更新用户信息
     */
    int update(SysUser user);

    /**
     * 更新密码
     */
    int updatePassword(@Param("userId") Long userId, @Param("password") String password);

    /**
     * 更新账号状态
     */
    int updateStatus(@Param("userId") Long userId, @Param("status") Integer status);

    /**
     * 查询用户列表
     */
    List<SysUser> selectList(SysUser query);

    /**
     * 根据角色类型查询用户列表
     */
    List<SysUser> selectByRoleType(Integer roleType);

    /**
     * 根据手机号查询用户
     */
    SysUser selectByPhone(String phone);

    /**
     * 逻辑删除用户（is_deleted=1）
     */
    int deleteById(Long userId);
}
