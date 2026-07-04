package com.huuc.dormitory.service.impl;

import com.huuc.dormitory.common.enums.UserStatusEnum;
import com.huuc.dormitory.common.exception.BusinessException;
import com.huuc.dormitory.common.utils.Md5Util;
import com.huuc.dormitory.dao.SysUserMapper;
import com.huuc.dormitory.dto.ImportResultDTO;
import com.huuc.dormitory.dto.LoginDTO;
import com.huuc.dormitory.dto.PasswordDTO;
import com.huuc.dormitory.dto.UserDTO;
import com.huuc.dormitory.entity.SysUser;
import com.huuc.dormitory.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.regex.Pattern;

/**
 * 用户服务实现类
 */
@Service
public class UserServiceImpl implements UserService {

    private static final Logger logger = LoggerFactory.getLogger(UserServiceImpl.class);

    /** 手机号正则：11位数字 */
    private static final Pattern PHONE_PATTERN = Pattern.compile("^\\d{11}$");

    @Autowired
    private SysUserMapper sysUserMapper;

    @Override
    public SysUser login(LoginDTO dto) {
        // 根据用户名查询用户
        SysUser user = sysUserMapper.selectByUsername(dto.getUsername());
        if (user == null) {
            throw new BusinessException(BusinessException.CODE_UNAUTHORIZED, "用户名或密码错误");
        }

        // 验证密码
        if (!Md5Util.verify(dto.getPassword(), user.getPassword())) {
            throw new BusinessException(BusinessException.CODE_UNAUTHORIZED, "用户名或密码错误");
        }

        // 验证账号状态
        if (UserStatusEnum.DISABLED.getCode().equals(user.getStatus())) {
            throw new BusinessException(BusinessException.CODE_UNAUTHORIZED, "账号已被禁用，请联系管理员");
        }

        // 清除密码后返回
        user.setPassword(null);
        return user;
    }

    @Override
    public SysUser getUserById(Long userId) {
        SysUser user = sysUserMapper.selectById(userId);
        if (user == null) {
            throw new BusinessException(BusinessException.CODE_NOT_FOUND, "用户不存在");
        }
        // 清除密码后返回
        user.setPassword(null);
        return user;
    }

    @Override
    @Transactional
    public void updatePassword(PasswordDTO dto, Long userId) {
        // 验证两次密码是否一致
        if (!dto.getNewPassword().equals(dto.getConfirmPassword())) {
            throw new BusinessException(BusinessException.CODE_BAD_REQUEST, "两次输入的密码不一致");
        }

        // 加密密码
        String encryptedPassword = Md5Util.encrypt(dto.getNewPassword());

        // 更新密码
        int rows = sysUserMapper.updatePassword(userId, encryptedPassword);
        if (rows == 0) {
            throw new BusinessException(BusinessException.CODE_ERROR, "修改密码失败");
        }
    }

    @Override
    @Transactional
    public void updatePhone(String phone, Long userId) {
        SysUser user = new SysUser();
        user.setUserId(userId);
        user.setPhone(phone);
        sysUserMapper.update(user);
    }

    /**
     * 新增用户
     * 自动生成默认密码（huuc+手机号）
     */
    @Override
    @Transactional
    public void addUser(UserDTO dto) {
        // 参数校验
        if (dto.getUsername() == null || dto.getUsername().trim().isEmpty()) {
            throw new BusinessException(BusinessException.CODE_BAD_REQUEST, "用户名不能为空");
        }

        // 验证用户名唯一性
        SysUser existUser = sysUserMapper.selectByUsername(dto.getUsername());
        if (existUser != null) {
            throw new BusinessException(BusinessException.CODE_CONFLICT, "用户名已存在");
        }

        // 构建用户对象
        SysUser user = new SysUser();
        user.setUsername(dto.getUsername());
        user.setRealName(dto.getRealName());
        user.setRoleType(dto.getRoleType());
        user.setGender(dto.getGender());
        user.setPhone(dto.getPhone());
        user.setGrade(dto.getGrade());
        user.setMajor(dto.getMajor());
        user.setClassName(dto.getClassName());
        user.setStatus(UserStatusEnum.NORMAL.getCode());

        // 生成默认密码：huuc+手机号
        String defaultPassword = generateDefaultPassword(dto.getPhone());
        user.setPassword(Md5Util.encrypt(defaultPassword));

        sysUserMapper.insert(user);
    }

    @Override
    @Transactional
    public void updateUser(UserDTO dto) {
        // 参数校验
        if (dto.getUserId() == null) {
            throw new BusinessException(BusinessException.CODE_BAD_REQUEST, "用户ID不能为空");
        }

        // 验证用户存在
        SysUser existUser = sysUserMapper.selectById(dto.getUserId());
        if (existUser == null) {
            throw new BusinessException(BusinessException.CODE_NOT_FOUND, "用户不存在");
        }

        // 构建更新对象
        SysUser user = new SysUser();
        user.setUserId(dto.getUserId());
        user.setRealName(dto.getRealName());
        user.setRoleType(dto.getRoleType());
        user.setGender(dto.getGender());
        user.setPhone(dto.getPhone());
        user.setGrade(dto.getGrade());
        user.setMajor(dto.getMajor());
        user.setClassName(dto.getClassName());
        if (dto.getStatus() != null) {
            user.setStatus(dto.getStatus());
        }

        sysUserMapper.update(user);
    }

    /**
     * 启用/禁用用户（状态切换）
     */
    @Override
    @Transactional
    public void toggleUserStatus(Long userId) {
        SysUser user = sysUserMapper.selectById(userId);
        if (user == null) {
            throw new BusinessException(BusinessException.CODE_NOT_FOUND, "用户不存在");
        }

        // 切换状态
        Integer newStatus = UserStatusEnum.NORMAL.getCode().equals(user.getStatus())
                ? UserStatusEnum.DISABLED.getCode()
                : UserStatusEnum.NORMAL.getCode();

        sysUserMapper.updateStatus(userId, newStatus);
    }

    @Override
    public List<SysUser> getUserList(SysUser query) {
        List<SysUser> users = sysUserMapper.selectList(query);
        // 清除密码
        users.forEach(u -> u.setPassword(null));
        return users;
    }

    @Override
    public List<SysUser> getUsersByRoleType(Integer roleType) {
        List<SysUser> users = sysUserMapper.selectByRoleType(roleType);
        // 清除密码
        users.forEach(u -> u.setPassword(null));
        return users;
    }

    @Override
    public boolean needChangePassword(SysUser user) {
        if (user == null) {
            return false;
        }
        // 查询完整用户信息（包含密码，不依赖传入 user 的 password 字段）
        SysUser fullUser = sysUserMapper.selectById(user.getUserId());
        if (fullUser == null) {
            return false;
        }
        // 生成默认密码：huuc+手机号
        String defaultPassword = generateDefaultPassword(fullUser.getPhone());
        // 比对密码是否等于默认密码
        return Md5Util.verify(defaultPassword, fullUser.getPassword());
    }

    @Override
    public ImportResultDTO importUsers(MultipartFile file) {
        ImportResultDTO result = new ImportResultDTO();

        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(file.getInputStream(), StandardCharsets.UTF_8))) {

            String firstLine = reader.readLine();
            // 处理BOM头
            if (firstLine != null && firstLine.startsWith("\uFEFF")) {
                firstLine = firstLine.substring(1);
            }
            // 跳过表头，如果第一行是表头则继续读取，否则将其作为数据行处理
            // 这里假设第一行是表头，直接跳过

            String line;
            int rowNum = 1; // 行号（从1开始，第0行是表头）

            while ((line = reader.readLine()) != null) {
                rowNum++;
                line = line.trim();

                // 跳过空行
                if (line.isEmpty()) {
                    continue;
                }

                try {
                    // 解析并导入单行
                    importSingleUser(line, rowNum, result);
                } catch (Exception e) {
                    logger.warn("导入第{}行失败：{}", rowNum, e.getMessage());
                    result.addFail(rowNum, e.getMessage());
                }
            }
        } catch (Exception e) {
            logger.error("读取CSV文件失败：", e);
            throw new BusinessException(BusinessException.CODE_BAD_REQUEST, "文件读取失败：" + e.getMessage());
        }

        return result;
    }

    /**
     * 导入单个用户
     *
     * @param line   CSV行内容
     * @param rowNum 行号
     * @param result 导入结果
     */
    private void importSingleUser(String line, int rowNum, ImportResultDTO result) {
        // 按逗号分割
        String[] fields = line.split(",");

        // 校验字段数量（至少需要username, realName, roleType, phone）
        if (fields.length < 4) {
            throw new RuntimeException("字段数量不足，至少需要username, realName, roleType, phone");
        }

        // 解析字段并trim
        String username = fields[0].trim();
        String realName = fields[1].trim();
        String roleTypeStr = fields[2].trim();
        String genderStr = fields.length > 3 ? fields[3].trim() : "";
        String phone = fields.length > 4 ? fields[4].trim() : "";
        String grade = fields.length > 5 ? fields[5].trim() : "";
        String major = fields.length > 6 ? fields[6].trim() : "";
        String className = fields.length > 7 ? fields[7].trim() : "";

        // 校验username
        if (username.isEmpty()) {
            throw new RuntimeException("用户名为空");
        }
        SysUser existUser = sysUserMapper.selectByUsername(username);
        if (existUser != null) {
            throw new RuntimeException("用户名已存在");
        }

        // 校验realName
        if (realName.isEmpty()) {
            throw new RuntimeException("真实姓名为空");
        }

        // 校验roleType
        Integer roleType;
        try {
            roleType = Integer.parseInt(roleTypeStr);
        } catch (NumberFormatException e) {
            throw new RuntimeException("角色类型无效");
        }
        if (roleType != 1 && roleType != 2 && roleType != 3) {
            throw new RuntimeException("角色类型无效，必须为1/2/3");
        }

        // 校验gender
        Integer gender = null;
        if (!genderStr.isEmpty()) {
            try {
                gender = Integer.parseInt(genderStr);
            } catch (NumberFormatException e) {
                throw new RuntimeException("性别值无效");
            }
            if (gender != 1 && gender != 2) {
                throw new RuntimeException("性别值无效，必须为1/2");
            }
        }

        // 校验phone
        if (phone.isEmpty()) {
            throw new RuntimeException("手机号为空");
        }
        if (!PHONE_PATTERN.matcher(phone).matches()) {
            throw new RuntimeException("手机号格式错误");
        }

        // 校验学生专属字段
        if (roleType == 3) {
            if (grade.isEmpty()) {
                throw new RuntimeException("学生年级为空");
            }
            if (major.isEmpty()) {
                throw new RuntimeException("学生专业为空");
            }
            if (className.isEmpty()) {
                throw new RuntimeException("学生班级为空");
            }
        }

        // 构建用户对象
        SysUser user = new SysUser();
        user.setUsername(username);
        user.setRealName(realName);
        user.setRoleType(roleType);
        user.setGender(gender);
        user.setPhone(phone);
        user.setGrade(grade.isEmpty() ? null : grade);
        user.setMajor(major.isEmpty() ? null : major);
        user.setClassName(className.isEmpty() ? null : className);
        user.setStatus(UserStatusEnum.NORMAL.getCode());

        // 生成默认密码
        String defaultPassword = generateDefaultPassword(phone);
        user.setPassword(Md5Util.encrypt(defaultPassword));

        // 插入数据库
        sysUserMapper.insert(user);

        result.addSuccess();
    }

    /**
     * 生成默认密码：huuc+手机号
     *
     * @param phone 手机号
     * @return 默认密码明文
     */
    @Override
    public SysUser getUserByPhone(String phone) {
        SysUser user = sysUserMapper.selectByPhone(phone);
        if (user == null) {
            throw new BusinessException(BusinessException.CODE_NOT_FOUND, "该手机号未注册");
        }
        user.setPassword(null);
        return user;
    }

    @Override
    @Transactional
    public void resetPassword(String phone, String newPassword) {
        if (newPassword == null || newPassword.length() < 6 || newPassword.length() > 20) {
            throw new BusinessException(BusinessException.CODE_BAD_REQUEST, "密码长度6-20位");
        }
        SysUser user = sysUserMapper.selectByPhone(phone);
        if (user == null) {
            throw new BusinessException(BusinessException.CODE_NOT_FOUND, "该手机号未注册");
        }
        String encryptedPassword = Md5Util.encrypt(newPassword);
        int rows = sysUserMapper.updatePassword(user.getUserId(), encryptedPassword);
        if (rows == 0) {
            throw new BusinessException(BusinessException.CODE_ERROR, "重置密码失败");
        }
    }

    private String generateDefaultPassword(String phone) {
        if (phone == null) {
            phone = "";
        }
        return "huuc" + phone;
    }
}
