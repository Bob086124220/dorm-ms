package com.huuc.dormitory.controller;

import com.huuc.dormitory.common.result.Result;
import com.huuc.dormitory.common.utils.SessionUtil;
import com.huuc.dormitory.entity.SysUser;
import com.huuc.dormitory.service.BedService;
import com.huuc.dormitory.service.BuildingService;
import com.huuc.dormitory.service.NoticeService;
import com.huuc.dormitory.service.RoomService;
import com.huuc.dormitory.vo.BedVO;
import com.huuc.dormitory.vo.BuildingVO;
import com.huuc.dormitory.vo.NoticeVO;
import com.huuc.dormitory.vo.RoomVO;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * 公共查询控制器（所有登录用户可用）
 */
@Controller
@RequestMapping("/common")
public class CommonController {

    @Autowired
    private BuildingService buildingService;

    @Autowired
    private RoomService roomService;

    @Autowired
    private BedService bedService;

    @Autowired
    private NoticeService noticeService;

    /**
     * 获取楼栋列表（只读）
     */
    @GetMapping("/building/list")
    @ResponseBody
    public Result<List<BuildingVO>> getBuildingList() {
        List<BuildingVO> list = buildingService.getAllBuildings();
        return Result.success(list);
    }

    /**
     * 获取楼栋下房间列表（只读）
     */
    @GetMapping("/room/building/{buildingId}")
    @ResponseBody
    public Result<List<RoomVO>> getRoomsByBuildingId(@PathVariable Long buildingId) {
        List<RoomVO> list = roomService.getRoomsByBuildingId(buildingId);
        return Result.success(list);
    }

    /**
     * 获取房间下空闲床位列表（只读）
     */
    @GetMapping("/bed/free/{roomId}")
    @ResponseBody
    public Result<List<BedVO>> getFreeBedsByRoomId(@PathVariable Long roomId) {
        List<BedVO> list = bedService.getFreeBedsByRoomId(roomId);
        return Result.success(list);
    }

    /**
     * 当前用户可见公告分页
     */
    @GetMapping("/notice/visible")
    @ResponseBody
    public Result<PageInfo<NoticeVO>> getVisibleNotices(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            HttpSession session) {

        SysUser user = SessionUtil.getCurrentUser(session);
        PageHelper.startPage(pageNum, pageSize);
        PageInfo<NoticeVO> pageInfo = noticeService.getVisibleNotices(
                user.getUserId(), user.getRoleType(), pageNum, pageSize);
        return Result.success(pageInfo);
    }

    /**
     * 当前用户可见轮播公告
     */
    @GetMapping("/notice/banners")
    @ResponseBody
    public Result<List<NoticeVO>> getBannerNotices(HttpSession session) {
        SysUser user = SessionUtil.getCurrentUser(session);
        List<NoticeVO> list = noticeService.getBannerNotices(user.getUserId(), user.getRoleType());
        return Result.success(list);
    }

    /**
     * 公告详情
     */
    @GetMapping("/notice/{noticeId}")
    @ResponseBody
    public Result<NoticeVO> getNoticeById(@PathVariable Long noticeId) {
        NoticeVO vo = noticeService.getNoticeById(noticeId);
        return Result.success(vo);
    }
}
