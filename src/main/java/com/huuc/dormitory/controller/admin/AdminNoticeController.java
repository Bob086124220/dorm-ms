package com.huuc.dormitory.controller.admin;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.huuc.dormitory.common.aop.OperLog;
import com.huuc.dormitory.common.enums.OperTypeEnum;
import com.huuc.dormitory.common.exception.BusinessException;
import com.huuc.dormitory.common.result.Result;
import com.huuc.dormitory.common.utils.SessionUtil;
import com.huuc.dormitory.dto.NoticeDTO;
import com.huuc.dormitory.service.NoticeService;
import com.huuc.dormitory.vo.NoticeVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.util.UUID;

/**
 * 管理员端公告管理控制器
 */
@Controller
@RequestMapping("/admin/notice")
public class AdminNoticeController {

    @Autowired
    private NoticeService noticeService;

    /**
     * 分页查询公告
     */
    @GetMapping("/page")
    @ResponseBody
    public Result<PageInfo<NoticeVO>> getNoticePage(
            @RequestParam(required = false) String title,
            @RequestParam(required = false) Integer noticeType,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {

        PageHelper.startPage(pageNum, pageSize);
        PageInfo<NoticeVO> pageInfo = noticeService.pageNotices(title, noticeType, pageNum, pageSize);
        return Result.success(pageInfo);
    }

    /**
     * 新增公告（含可选轮播图片）
     */
    @PostMapping("/add")
    @ResponseBody
    @OperLog(module = "公告管理", type = OperTypeEnum.ADD, desc = "新增公告")
    public Result<Void> addNotice(
            @RequestParam("title") String title,
            @RequestParam("content") String content,
            @RequestParam("noticeType") Integer noticeType,
            @RequestParam("visibleScope") Integer visibleScope,
            @RequestParam(value = "buildingId", required = false) Long buildingId,
            @RequestParam(value = "isBanner", defaultValue = "0") Integer isBanner,
            @RequestParam(value = "bannerDays", defaultValue = "7") Integer bannerDays,
            @RequestParam(value = "bannerImage", required = false) MultipartFile bannerImage,
            HttpSession session) {

        NoticeDTO dto = new NoticeDTO();
        dto.setTitle(title);
        dto.setContent(content);
        dto.setNoticeType(noticeType);
        dto.setVisibleScope(visibleScope);
        dto.setBuildingId(buildingId);
        dto.setIsBanner(isBanner);
        dto.setBannerDays(bannerDays);

        // 处理轮播图片上传
        if (isBanner == 1 && bannerImage != null && !bannerImage.isEmpty()) {
            validateImageFile(bannerImage);
            String imagePath = saveBannerImage(bannerImage, session.getServletContext());
            dto.setBannerImagePath(imagePath);
        }

        Long publisherId = SessionUtil.getCurrentUserId(session);
        noticeService.addNotice(dto, publisherId);
        return Result.success();
    }

    /**
     * 编辑公告（含可选轮播图片）
     */
    @PostMapping("/update")
    @ResponseBody
    @OperLog(module = "公告管理", type = OperTypeEnum.UPDATE, desc = "编辑公告")
    public Result<Void> updateNotice(
            @RequestParam("noticeId") Long noticeId,
            @RequestParam("title") String title,
            @RequestParam("content") String content,
            @RequestParam("noticeType") Integer noticeType,
            @RequestParam("visibleScope") Integer visibleScope,
            @RequestParam(value = "buildingId", required = false) Long buildingId,
            @RequestParam(value = "isBanner", defaultValue = "0") Integer isBanner,
            @RequestParam(value = "bannerDays", defaultValue = "7") Integer bannerDays,
            @RequestParam(value = "bannerImage", required = false) MultipartFile bannerImage,
            HttpSession session) {

        NoticeDTO dto = new NoticeDTO();
        dto.setNoticeId(noticeId);
        dto.setTitle(title);
        dto.setContent(content);
        dto.setNoticeType(noticeType);
        dto.setVisibleScope(visibleScope);
        dto.setBuildingId(buildingId);
        dto.setIsBanner(isBanner);
        dto.setBannerDays(bannerDays);

        // 处理轮播图片上传
        if (isBanner == 1 && bannerImage != null && !bannerImage.isEmpty()) {
            validateImageFile(bannerImage);
            String imagePath = saveBannerImage(bannerImage, session.getServletContext());
            dto.setBannerImagePath(imagePath);
        }

        noticeService.updateNotice(dto);
        return Result.success();
    }

    /**
     * 发布/下架切换
     */
    @PostMapping("/toggleStatus/{noticeId}")
    @ResponseBody
    @OperLog(module = "公告管理", type = OperTypeEnum.UPDATE, desc = "切换公告状态")
    public Result<Void> toggleStatus(@PathVariable Long noticeId) {
        noticeService.toggleStatus(noticeId);
        return Result.success();
    }

    /**
     * 置顶/取消置顶切换
     */
    @PostMapping("/toggleTop/{noticeId}")
    @ResponseBody
    @OperLog(module = "公告管理", type = OperTypeEnum.UPDATE, desc = "切换公告置顶")
    public Result<Void> toggleTop(@PathVariable Long noticeId) {
        noticeService.toggleTop(noticeId);
        return Result.success();
    }

    /**
     * 下轮播
     */
    @PostMapping("/unbanner/{noticeId}")
    @ResponseBody
    @OperLog(module = "公告管理", type = OperTypeEnum.UPDATE, desc = "取消轮播")
    public Result<Void> unbanner(@PathVariable Long noticeId) {
        noticeService.unbanner(noticeId);
        return Result.success();
    }

    // ==================== 私有方法 ====================

    /**
     * 校验图片文件格式
     */
    private void validateImageFile(MultipartFile file) {
        String originalFilename = file.getOriginalFilename();
        if (originalFilename == null) {
            throw new BusinessException(BusinessException.CODE_BAD_REQUEST, "文件名为空");
        }
        String lowerName = originalFilename.toLowerCase();
        if (!lowerName.endsWith(".jpg") && !lowerName.endsWith(".jpeg") && !lowerName.endsWith(".png")) {
            throw new BusinessException(BusinessException.CODE_BAD_REQUEST, "轮播图片仅支持 JPG/PNG 格式");
        }
    }

    /**
     * 保存轮播图片到 static/upload/banner/，返回相对路径
     */
    private String saveBannerImage(MultipartFile file, ServletContext servletContext) {
        String uploadDir = "/static/upload/banner/";
        String realPath = servletContext.getRealPath(uploadDir);

        File dir = new File(realPath);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        String originalFilename = file.getOriginalFilename();
        String ext = originalFilename.substring(originalFilename.lastIndexOf("."));
        String filename = UUID.randomUUID().toString() + ext;

        try {
            File dest = new File(dir, filename);
            file.transferTo(dest);
        } catch (Exception e) {
            throw new BusinessException(BusinessException.CODE_ERROR, "图片保存失败");
        }

        return uploadDir + filename;
    }
}
