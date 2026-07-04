package com.huuc.dormitory.service;

import com.huuc.dormitory.dto.ImportResultDTO;
import com.huuc.dormitory.dto.LoginDTO;
import com.huuc.dormitory.dto.PasswordDTO;
import com.huuc.dormitory.dto.UserDTO;
import com.huuc.dormitory.entity.SysUser;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

/**
 * 用户服务接口
 */
public interface UserService {

    /**
     * 用户登录
     *
     * @param dto 登录参数（用户名、密码）
     * @return 用户信息（密码字段已清空）
     * @throws com.huuc.dormitory.common.exception.BusinessException 用户名或密码错误、账号已被禁用
     */
    SysUser login(LoginDTO dto);

    /**
     * 根据ID获取用户
     *
     * @param userId 用户ID
     * @return 用户信息（密码字段已清空）
     * @throws com.huuc.dormitory.common.exception.BusinessException 用户不存在
     */
    SysUser getUserById(Long userId);

    /**
     * 修改密码
     *
     * @param dto    密码参数（新密码、确认密码）
     * @param userId 当前用户ID
     * @throws com.huuc.dormitory.common.exception.BusinessException 两次密码不一致、修改失败
     */
    void updatePassword(PasswordDTO dto, Long userId);

    /**
     * 修改个人联系电话
     *
     * @param phone  新手机号
     * @param userId 当前用户ID
     */
    void updatePhone(String phone, Long userId);

    /**
     * 管理员新增用户
     *
     * @param dto 用户信息
     * @throws com.huuc.dormitory.common.exception.BusinessException 用户名已存在、用户名为空
     */
    void addUser(UserDTO dto);

    /**
     * 管理员编辑用户
     *
     * @param dto 用户信息（必须包含userId）
     * @throws com.huuc.dormitory.common.exception.BusinessException 用户不存在
     */
    void updateUser(UserDTO dto);

    /**
     * 管理员启用/禁用用户
     *
     * @param userId 目标用户ID
     * @throws com.huuc.dormitory.common.exception.BusinessException 用户不存在
     */
    void toggleUserStatus(Long userId);

    /**
     * 查询用户列表
     */
    List<SysUser> getUserList(SysUser query);

    /**
     * 根据角色类型查询用户列表
     */
    List<SysUser> getUsersByRoleType(Integer roleType);

    /**
     * 判断是否需要强制修改密码（密码等于默认密码）
     */
    boolean needChangePassword(SysUser user);

    /**
     * 批量导入用户（CSV文件）
     *
     * @param file CSV文件
     * @return 导入结果
     */
    ImportResultDTO importUsers(MultipartFile file);

    /**
     * 根据手机号获取用户
     *
     * @param phone 手机号
     * @return 用户信息（密码字段已清空）
     * @throws com.huuc.dormitory.common.exception.BusinessException 手机号未注册
     */
    SysUser getUserByPhone(String phone);

    /**
     * 通过手机号重置密码（忘记密码流程）
     *
     * @param phone       手机号
     * @param newPassword 新密码明文
     * @throws com.huuc.dormitory.common.exception.BusinessException 手机号未注册、操作失败
     */
    void resetPassword(String phone, String newPassword);
}
