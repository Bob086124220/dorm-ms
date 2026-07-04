package com.huuc.dormitory.controller.dorm;

import com.github.pagehelper.PageInfo;
import com.huuc.dormitory.common.result.Result;
import com.huuc.dormitory.common.utils.SessionUtil;
import com.huuc.dormitory.service.BuildingService;
import com.huuc.dormitory.vo.BuildingVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * 宿管端楼栋控制器
 */
@Controller
@RequestMapping("/dorm/building")
public class DormBuildingController {

    @Autowired
    private BuildingService buildingService;

    /**
     * 楼栋列表页面
     * @return 列表页视图
     */
    @GetMapping("/listPage")
    public String listPage() {
        return "dorm/building/list";
    }

    /**
     * 获取本人负责楼栋列表
     */
    @GetMapping("/list")
    @ResponseBody
    public Result<List<BuildingVO>> getMyBuildings(HttpSession session) {
        Long managerId = SessionUtil.getCurrentUserId(session);
        List<BuildingVO> list = buildingService.getBuildingsByManagerId(managerId);
        return Result.success(list);
    }

    /**
     * 分页查询本人负责楼栋列表
     */
    @GetMapping("/page")
    @ResponseBody
    public Result<PageInfo<BuildingVO>> getMyBuildingsPage(
            HttpSession session,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {
        Long managerId = SessionUtil.getCurrentUserId(session);
        PageInfo<BuildingVO> page = buildingService.getBuildingsByManagerIdPage(managerId, pageNum, pageSize);
        return Result.success(page);
    }
}
