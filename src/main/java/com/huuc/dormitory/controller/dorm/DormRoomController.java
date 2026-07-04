package com.huuc.dormitory.controller.dorm;

import com.github.pagehelper.PageInfo;
import com.huuc.dormitory.common.result.Result;
import com.huuc.dormitory.service.RoomService;
import com.huuc.dormitory.vo.RoomVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * 宿管端房间控制器
 */
@Controller
@RequestMapping("/dorm/room")
public class DormRoomController {

    @Autowired
    private RoomService roomService;

    /**
     * 房间列表页面
     * @return 列表页视图
     */
    @GetMapping("/listPage")
    public String listPage() {
        return "dorm/room/list";
    }

    /**
     * 获取楼栋下房间列表
     */
    @GetMapping("/building/{buildingId}")
    @ResponseBody
    public Result<List<RoomVO>> getRoomsByBuildingId(@PathVariable Long buildingId) {
        List<RoomVO> list = roomService.getRoomsByBuildingId(buildingId);
        return Result.success(list);
    }

    /**
     * 分页查询楼栋下房间列表
     */
    @GetMapping("/page")
    @ResponseBody
    public Result<PageInfo<RoomVO>> getRoomsByBuildingIdPage(
            @RequestParam Long buildingId,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {
        PageInfo<RoomVO> page = roomService.getRoomsByBuildingIdPage(buildingId, pageNum, pageSize);
        return Result.success(page);
    }
}
