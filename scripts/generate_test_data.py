#!python
"""
高校公寓管理系统 测试数据生成器

用法:
    python scripts/generate_test_data.py [输出文件路径]
    # 不指定路径时默认输出到 scripts/test_data.sql
    # 然后在MySQL中执行:
    # source clear.sql;
    # source scripts/test_data.sql;

依赖: 无（仅标准库）
生成内容: sys_user(除管理员外) / dorm_building / dorm_room / dorm_bed
          dorm_checkin_record / dorm_move_apply / dorm_repair
          dorm_late_return / dorm_visitor
不生成:  sys_oper_log / sys_notice
"""

import hashlib
import random
import sys
from datetime import datetime, timedelta

# ============================================================
# 配置参数（按需修改）
# ============================================================
STUDENT_COUNT = 150           # 学生人数
DORM_MANAGER_COUNT = 5        # 宿管人数
BUILDING_COUNT = 5            # 楼栋数
ROOMS_PER_BUILDING = 10       # 每栋楼房间数（必须是 FLOORS 的倍数）
FLOORS_PER_BUILDING = 5       # 每栋楼层数
BEDS_PER_ROOM_CHOICES = [4, 6, 8]  # 每房间床位数，随机从列表中选取
CHECKIN_RATIO = 0.85          # 床位入住比例
MOVE_APPLY_COUNT = 40         # 调宿申请数量
REPAIR_COUNT = 40             # 报修单数量
LATE_RETURN_COUNT = 40        # 晚归记录数
VISITOR_COUNT = 40            # 访客记录数
NOTICE_COUNT = 20             # 公告通知数

DATE_RANGE_START = '2026-01-01'  # 业务数据日期范围（起）
DATE_RANGE_END = '2026-07-4'    # 业务数据日期范围（止）
CHECKIN_BASE = '2026-01-01 10:00:00'  # 入住办理基准时间

DEFAULT_PASSWORD = '123456'
DEFAULT_PASSWORD_MD5 = hashlib.md5(DEFAULT_PASSWORD.encode()).hexdigest()

# ============================================================
# 数据池
# ============================================================
# 姓数据池
SURNAMES = [
    '赵','钱','孙','李','周','吴','郑','王','冯','陈','褚','卫','蒋','沈','韩','杨',
    '朱','秦','尤','许','何','吕','施','张','孔','曹','严','华','金','魏','陶','姜',
    '戚','谢','邹','喻','柏','水','窦','章','云','苏','潘','葛','奚','范','彭','郎',
    '鲁','韦','昌','马','苗','凤','花','方','俞','任','袁','柳','鲍','史','唐','费'
]
# 男性名
MALE_GIVEN = [
    '伟','强','磊','涛','勇','军','杰','文','明','辉','斌','浩','鹏','飞','超',
    '博','毅','峰','建','宇','鑫','旭','阳','亮','刚','宁','瑞','凯','健','帅',
    '志','恒','思','睿','卓','然','煜','辰','霖','翔','翰','松','柏','震','远'
]
# 女性名
FEMALE_GIVEN = [
    '芳','敏','静','丽','婷','雪','玲','萍','艳','娟','红','霞','秀','英','华',
    '慧','娜','莉','梅','琳','瑶','琪','媛','怡','蕾','涵','洁','悦','晶','澜',
    '诗','雅','韵','宛','晴','月','兰','竹','菊','荷','杏','桃','柳','燕','莺'
]

MAJORS = [
    '计算机科学与技术', '软件工程', '网络工程',
    '数据科学与大数据技术', '人工智能', '信息安全', '物联网工程'
]
GRADES = ['2022级', '2023级', '2024级', '2025级', '2026级']
AREAS = ['东区', '西区', '南区', '北区']

REPAIR_CONTENTS = {
    1: ['水龙头漏水无法关闭', '马桶堵塞溢水', '水管破裂渗水', '下水道堵塞排水慢',
        '热水器不加热', '水管异响', '洗手池排水管脱落'],
    2: ['书桌抽屉轨道损坏', '床板断裂需更换', '椅子腿松动不稳', '衣柜门合页脱落',
        '书架隔板变形', '床铺护栏晃动', '书桌面板刮花严重'],
    3: ['窗户把手脱落', '门锁卡死无法打开', '门框变形关门困难', '窗户关不严漏风',
        '纱窗破损进蚊虫', '防盗门合页异响', '窗帘杆脱落'],
    4: ['空调不制冷需加氟', '网络接口无信号', '墙面渗水起皮', '日光灯闪烁不亮',
        '吊扇转速过慢', '插座无电需检修', '天花板漏水']
}
LATE_REASONS = [
    '实验室项目加班', '图书馆复习备考', '同学聚会', '兼职下班晚归',
    '运动队训练', '社团活动筹备', '竞赛备赛', '校外实习返回',
    '学术会议', '火车晚点', '医院陪护', '家教晚归'
]
VISIT_REASONS = [
    '家长探访', '朋友来访', '讨论课程项目', '维修电脑',
    '送学习资料', '社团事务', '老乡聚会', '比赛队友来访'
]
VISITOR_SURNAMES = ['张','李','王','刘','陈','杨','赵','黄','周','吴','徐','孙','马','朱','胡','郭']
VISITOR_GIVEN = ['明','华','强','伟','芳','丽','敏','静','涛','勇','军','磊','文','雪','玲','云','辉','斌']
MOVE_REASONS = [
    '想换到靠窗床位', '与舍友作息不一致', '身体原因需要下铺',
    '想住阳面房间', '与同班同学就近', '现有床位靠近卫生间噪音大',
    '舍友打鼾影响休息', '楼层太高每天爬楼不便', '想住低楼层方便出入'
]
ROOM_REMARKS_POOL = [
    '靠近楼梯', '阳面采光好', '阴面夏天凉快', '顶楼安静',
    '一楼出入方便', '新装修', '安静角落', '靠近洗衣房',
    '靠近公共卫生间', None, None, None
]

# 通知标题池（无占位符，纯文本标题）
NOTICE_TITLES = [
    '关于国庆节放假安排的通知',
    '关于水管抢修临时停水通知',
    '"文明宿舍"评比活动报名通知',
    '关于寒假离校宿舍检查的通知',
    '关于调整宿舍门禁时间的公告',
    '关于学生公寓网络升级的通知',
    '关于春季传染病防控的温馨提示',
    '毕业生离校退宿手续办理指南',
    '关于开展宿舍安全卫生大检查的通知',
    '关于停电检修的临时通知',
    '关于校园一卡通门禁系统升级的公告',
    '关于优秀宿管评选结果的公示',
    '关于新生入住手续办理的通知',
    '关于宿舍空调清洗维护的通知',
]

# 通知内容模板（Markdown 格式）
NOTICE_CONTENTS = {
    1: [  # 通知类
        '# 关于{year}年国庆节放假安排的通知\n\n各位同学：\n\n根据学校安排，国庆节放假时间为 **10月1日-10月7日**，共7天。\n\n放假期间请注意以下事项：\n\n1. 离校前请关闭宿舍水电、门窗\n2. 贵重物品妥善保管\n3. 留校同学请注意用电安全\n4. 假期期间宿舍门禁照常运行\n\n祝大家假期愉快！',
        '# 关于调整宿舍门禁时间的公告\n\n各位住宿同学：\n\n根据学校统一安排，自 **{month}月{day}日** 起，宿舍门禁时间调整为：\n\n- 周日-周四：**23:00** 关门\n- 周五-周六：**23:30** 关门\n\n请同学们合理安排时间，按时归宿。晚归需在宿管处登记。',
        '# 关于学生公寓网络升级的通知\n\n各位同学：\n\n信息化中心计划于 **本周末** 对学生公寓进行网络设备升级，届时可能出现短时断网。\n\n- 升级时间：周六 08:00-18:00\n- 影响范围：全校学生公寓\n- 升级内容：Wi-Fi 6 无线AP更换、核心交换机扩容\n\n升级完成后网络速度和稳定性将有明显提升。给您带来的不便，敬请谅解。',
    ],
    2: [  # 维修类
        '## 维修通知\n\n**{building_name}全体同学：**\n\n因主供水管道破裂，物业将于 **今天14:00-17:00** 进行紧急抢修，届时该楼栋将暂停供水。\n\n请提前做好储水准备，给您带来的不便敬请谅解。\n\n如有疑问请致电维修中心：**12345**。',
        '## 电梯维护公告\n\n**{building_name}全体同学：**\n\n接电梯维保单位通知，定于 **下周三 09:00-12:00** 对电梯进行定期检修。\n\n检修期间电梯暂停使用，请同学们使用楼梯出行。高层同学请提前安排好时间。\n\n检修完成后将第一时间恢复运行。',
    ],
    3: [  # 活动类
        '## "文明宿舍"评比活动\n\n**主办：** 学生工作处\n\n**报名时间：** {month}月1日-{month}月7日\n\n**评比内容：**\n- 宿舍卫生评比（占比 40%）\n- 宿舍文化装饰（占比 35%）\n- 安全知识问答（占比 25%）\n\n**奖励设置：**\n- 一等奖 3 名：奖金 500 元\n- 二等奖 6 名：奖金 300 元\n- 三等奖 10 名：奖金 100 元\n\n请有意参加的宿舍到各楼栋宿管处登记报名。',
        '## 消防安全演练活动通知\n\n**各位同学：**\n\n为提高学生消防安全意识和应急避险能力，学校定于 **下周五下午15:00** 在学生公寓区开展消防疏散演练。\n\n**注意事项：**\n- 听到警报后请迅速有序撤离\n- 按楼层引导员指引从安全通道下楼\n- 禁止乘坐电梯\n- 请提前关闭宿舍内电器设备\n\n本次演练预计持续 **30分钟**，请大家积极配合。',
    ],
    4: [  # 紧急类
        '## ⚠️ 紧急通知\n\n**全体住宿学生：**\n\n接上级通知，因极端天气预警，今晚将有 **暴雨+大风**，请各位同学：\n\n1. 关好门窗\n2. 收好阳台物品\n3. 不要在大树下逗留\n4. 减少不必要外出\n\n如发现宿舍有漏水、渗水等情况，请立即向宿管报告。\n\n**安全第一！**',
        '## 传染病防控紧急提醒\n\n**各位同学：**\n\n近期周边地区出现流感聚集性疫情，为保障全体同学健康，请注意：\n\n- 宿舍每天开窗通风不少于 3 次\n- 出现发热等症状及时就医\n- 佩戴口罩，勤洗手\n- 减少前往人群密集场所\n\n学校医务室 24 小时值班电话：**120**（内线）。',
    ],
}

BANNER_IMAGE_DEFAULT = '/static/images/carousel.png'

def pick(lst):
    return random.choice(lst)

def md5(s):
    return hashlib.md5(s.encode()).hexdigest()

def rand_date_between(start_str, end_str):
    """在日期范围内生成随机 datetime"""
    start = datetime.strptime(start_str, '%Y-%m-%d')
    end = datetime.strptime(end_str, '%Y-%m-%d')
    delta = (end - start).days
    d = start + timedelta(days=random.randint(0, max(delta, 0)))
    h = random.randint(8, 22)
    m = random.choice([0, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55])
    s = random.randint(0, 59)
    return d.replace(hour=h, minute=m, second=s)

def fmt_dt(dt):
    """格式化 datetime 为 SQL 字符串"""
    if dt is None:
        return 'NULL'
    return "'{}'".format(dt.strftime('%Y-%m-%d %H:%M:%S'))

def fmt_s(s):
    """格式化字符串为 SQL 字面量"""
    if s is None:
        return 'NULL'
    escaped = s.replace("\\", "\\\\").replace("'", "\\'")
    return "'{}'".format(escaped)

def fmt_val(v):
    """格式化任意值为 SQL 字面量"""
    if v is None:
        return 'NULL'
    if isinstance(v, datetime):
        return fmt_dt(v)
    if isinstance(v, str):
        return fmt_s(v)
    return str(v)

# ============================================================
# 数据生成器
# ============================================================

class Generator:
    def __init__(self):
        self.reset()

    def reset(self):
        # ID 计数器
        self._uid = 2           # user_id（1 预留给管理员）
        self._bid = 1           # building_id
        self._rid = 1           # room_id
        self._bedid = 1         # bed_id
        self._cid = 1           # checkin_id
        self._mid = 1           # move_apply_id
        self._rpid = 1          # repair_id
        self._lid = 1           # late_return_id
        self._vid = 1           # visitor_id
        self._nid = 1           # notice_id

        # 唯一性跟踪
        self._phones = set()
        self._usernames = set()

        # 数据容器
        self.users = []
        self.buildings = []
        self.rooms = []
        self.beds = []          # {bed_id, bed_no, room_id, bed_status}
        self.checkins = []      # {checkin_id, student_id, bed_id, checkin_time, checkout_time, checkin_status, operator_id}
        self.move_applies = []  # raw list before bed swaps
        self.repairs = []
        self.late_returns = []
        self.visitors = []
        self.notices = []

    # ---------- 唯一性辅助 ----------

    def gen_phone(self):
        """生成唯一手机号"""
        base = 13900000000 + self._uid * 7 + random.randint(1, 100)
        while base in self._phones:
            base += 1
        self._phones.add(base)
        return str(base)

    def gen_username(self, prefix, seq):
        """生成唯一用户名"""
        u = '{}{:04d}'.format(prefix, seq)
        while u in self._usernames:
            seq += 1
            u = '{}{:04d}'.format(prefix, seq)
        self._usernames.add(u)
        return u

    # ---------- 1. 生成管理员 ----------

    def gen_admin(self):
        self.users.append({
            'user_id': 1,
            'username': 'admin',
            'password': DEFAULT_PASSWORD_MD5,
            'real_name': '系统管理员',
            'role_type': 1,
            'gender': 1,
            'phone': self.gen_phone(),
            'grade': None,
            'major': None,
            'class_name': None,
            'status': 1,
        })
        self._uid = 2

    # ---------- 2. 生成宿管 ----------

    def gen_dorm_managers(self):
        for i in range(DORM_MANAGER_COUNT):
            gender = random.choice([1, 2])
            surname = pick(SURNAMES)
            given = pick(MALE_GIVEN if gender == 1 else FEMALE_GIVEN)
            self.users.append({
                'user_id': self._uid,
                'username': self.gen_username('suguan', i + 1),
                'password': DEFAULT_PASSWORD_MD5,
                'real_name': surname + given,
                'role_type': 2,
                'gender': gender,
                'phone': self.gen_phone(),
                'grade': None,
                'major': None,
                'class_name': None,
                'status': 1,
            })
            self._uid += 1

    # ---------- 3. 生成学生 ----------

    def gen_students(self):
        student_id_start = 20220001
        # 收集中文姓名确保不重复
        used_names = set()
        for u in self.users:
            used_names.add(u['real_name'])

        # 按年级均匀分配
        grades_cycle = GRADES * (STUDENT_COUNT // len(GRADES) + 1)

        for i in range(STUDENT_COUNT):
            gender = random.choice([1, 2])
            surname = pick(SURNAMES)
            given = pick(MALE_GIVEN if gender == 1 else FEMALE_GIVEN)
            name = surname + given
            # 确保姓名不重复（最多尝试100次）
            tries = 0
            while name in used_names and tries < 100:
                given = pick(MALE_GIVEN if gender == 1 else FEMALE_GIVEN)
                name = surname + given
                tries += 1
            used_names.add(name)

            grade = grades_cycle[i % len(grades_cycle)]
            major = pick(MAJORS)
            # 班级：专业缩写+年级末两位+班号
            major_abbr = major[:2]
            grade_short = grade[:4][2:]
            class_no = (i // 30) % 3 + 1  # 每30人轮换班级
            class_name = '{}{}{:02d}'.format(major_abbr, grade_short, class_no)

            self.users.append({
                'user_id': self._uid,
                'username': self.gen_username('stu', student_id_start + i),
                'password': DEFAULT_PASSWORD_MD5,
                'real_name': name,
                'role_type': 3,
                'gender': gender,
                'phone': self.gen_phone(),
                'grade': grade,
                'major': major,
                'class_name': class_name,
                'status': 1,
            })
            self._uid += 1

    # ---------- 4. 生成楼栋 ----------

    def gen_buildings(self):
        manager_ids = [u['user_id'] for u in self.users if u['role_type'] == 2]
        for i in range(BUILDING_COUNT):
            self.buildings.append({
                'building_id': self._bid,
                'building_no': 'B{}'.format(i + 1),
                'building_name': '{}号公寓'.format(i + 1),
                'floor_count': FLOORS_PER_BUILDING,
                'area': AREAS[i % len(AREAS)],
                'manager_id': manager_ids[i % len(manager_ids)],
                'remark': pick([None, None, '{}宿舍楼'.format(AREAS[i % len(AREAS)]),
                                '主要管理区域', None]),
            })
            self._bid += 1

    # ---------- 5. 生成房间 ----------

    def gen_rooms(self):
        rooms_per_floor = ROOMS_PER_BUILDING // FLOORS_PER_BUILDING
        assert ROOMS_PER_BUILDING % FLOORS_PER_BUILDING == 0, \
            'ROOMS_PER_BUILDING({}) 必须能被 FLOORS_PER_BUILDING({}) 整除'.format(
                ROOMS_PER_BUILDING, FLOORS_PER_BUILDING)

        for bld in self.buildings:
            for floor in range(1, FLOORS_PER_BUILDING + 1):
                for seq in range(1, rooms_per_floor + 1):
                    room_no = '{}{:02d}'.format(floor, seq)
                    bed_total = pick(BEDS_PER_ROOM_CHOICES)
                    room_type = {4: 1, 6: 2, 8: 3}[bed_total]
                    self.rooms.append({
                        'room_id': self._rid,
                        'room_no': room_no,
                        'building_id': bld['building_id'],
                        'floor_num': floor,
                        'bed_total': bed_total,
                        'room_type': room_type,
                        'remark': pick(ROOM_REMARKS_POOL),
                    })
                    self._rid += 1

    # ---------- 6. 生成床位 ----------

    def gen_beds(self):
        for room in self.rooms:
            for i in range(1, room['bed_total'] + 1):
                self.beds.append({
                    'bed_id': self._bedid,
                    'bed_no': str(i),
                    'room_id': room['room_id'],
                    'bed_status': 0,  # 初始全部空闲
                    'remark': None,
                })
                self._bedid += 1

    # ---------- 7. 生成入住记录 ----------

    def gen_checkins(self):
        students = [u for u in self.users if u['role_type'] == 3]
        free_beds = [b for b in self.beds]
        random.shuffle(free_beds)
        random.shuffle(students)

        # 按入住比例决定入住人数
        total_beds = len(self.beds)
        occupied_count = min(len(students), int(total_beds * CHECKIN_RATIO))
        occupied_count = max(occupied_count, len(students))  # 保证所有学生都能入住

        if occupied_count > len(free_beds):
            print('错误：入住人数({}) 超过空闲床位数({})'.format(occupied_count, len(free_beds)), file=sys.stderr)
            sys.exit(1)

        # 管理员和宿管 ID 作为办理人
        admin_id = 1
        dm_ids = [u['user_id'] for u in self.users if u['role_type'] == 2]

        base_dt = datetime.strptime(CHECKIN_BASE, '%Y-%m-%d %H:%M:%S')

        for i, student in enumerate(students[:occupied_count]):
            bed = free_beds[i]
            # 入住时间：集中在开学前3天
            checkin_time = base_dt + timedelta(
                days=random.randint(0, 3),
                hours=random.randint(0, 6),
                minutes=random.choice([0, 15, 30, 45])
            )
            operator_id = random.choice(dm_ids) if dm_ids else admin_id

            self.checkins.append({
                'checkin_id': self._cid,
                'student_id': student['user_id'],
                'bed_id': bed['bed_id'],
                'checkin_time': checkin_time,
                'checkout_time': None,
                'checkin_status': 1,
                'operator_id': operator_id,
                'remark': None if random.random() > 0.2 else '正常入住',
            })

            # 更新床位状态
            bed['bed_status'] = 1
            self._cid += 1

    # ---------- 辅助：获取入住学生信息 ----------

    def checked_in_students(self):
        """返回 [(student_id, bed_id, checkin_id, room_id, building_id), ...]"""
        room_of_bed = {b['bed_id']: b['room_id'] for b in self.beds}
        bld_of_room = {r['room_id']: r['building_id'] for r in self.rooms}
        result = []
        for c in self.checkins:
            if c['checkin_status'] == 1:
                rid = room_of_bed.get(c['bed_id'])
                bld_id = bld_of_room.get(rid) if rid else None
                result.append({
                    'student_id': c['student_id'],
                    'bed_id': c['bed_id'],
                    'checkin_id': c['checkin_id'],
                    'room_id': rid,
                    'building_id': bld_id,
                })
        return result

    def free_bed_ids(self):
        return [b['bed_id'] for b in self.beds if b['bed_status'] == 0]

    # ---------- 8. 生成调宿申请 ----------

    def gen_move_applies(self):
        checked_in = self.checked_in_students()
        free_bed_ids = self.free_bed_ids()
        dm_ids = [u['user_id'] for u in self.users if u['role_type'] == 2]
        admin_id = 1

        if MOVE_APPLY_COUNT > len(checked_in):
            print('错误：调宿申请数({}) 超过已入住学生数({})'.format(
                MOVE_APPLY_COUNT, len(checked_in)), file=sys.stderr)
            sys.exit(1)

        # 分配状态：0=待审批, 1=已通过, 2=已驳回
        statuses = []
        approved_count = MOVE_APPLY_COUNT // 3      # ~1/3 通过
        rejected_count = MOVE_APPLY_COUNT // 4      # ~1/4 驳回
        pending_count = MOVE_APPLY_COUNT - approved_count - rejected_count
        statuses = [1] * approved_count + [2] * rejected_count + [0] * pending_count
        random.shuffle(statuses)

        # 如果用到的 target_bed 超过空闲数，拒绝
        if approved_count > len(free_bed_ids):
            print('错误：已通过调宿数({}) 超过空闲床位数({})'.format(
                approved_count, len(free_bed_ids)), file=sys.stderr)
            sys.exit(1)

        applicants = random.sample(checked_in, MOVE_APPLY_COUNT)

        for i, (app, status) in enumerate(zip(applicants, statuses)):
            apply_time = rand_date_between(DATE_RANGE_START, DATE_RANGE_END)

            if status == 1:
                target_bed_id = free_bed_ids.pop(0)
            else:
                # 驳回/待审批也指定一个目标床位（可能已被占用或不存在，实际审批时由业务校验）
                available = [b['bed_id'] for b in self.beds
                             if b['bed_id'] != app['bed_id']]
                target_bed_id = pick(available) if available else app['bed_id']

            auditor_id = pick(dm_ids) if dm_ids else admin_id
            audit_time = apply_time + timedelta(days=random.randint(1, 5),
                                                hours=random.randint(0, 8)) if status != 0 else None
            audit_opinion = None
            if status == 1:
                audit_opinion = pick(['同意调换，已安排', '批准调宿', '已安排新床位', None])
            elif status == 2:
                audit_opinion = pick(['证明材料不足', '目标床位不可用', '暂不批准', '需补充申请材料'])

            self.move_applies.append({
                'apply_id': self._mid,
                'student_id': app['student_id'],
                'original_bed_id': app['bed_id'],
                'target_bed_id': target_bed_id,
                'apply_reason': pick(MOVE_REASONS),
                'apply_time': apply_time,
                'audit_status': status,
                'auditor_id': auditor_id if status != 0 else None,
                'audit_time': audit_time,
                'audit_opinion': audit_opinion,
                'remark': None,
            })
            self._mid += 1

        self._apply_move_swaps()

    def _apply_move_swaps(self):
        """应用已通过的调宿：更新入住记录和床位状态"""
        admin_id = 1
        for ma in self.move_applies:
            if ma['audit_status'] != 1:
                continue

            # 原入住记录改为已退宿
            for c in self.checkins:
                if c['student_id'] == ma['student_id'] and c['checkin_status'] == 1:
                    c['checkin_status'] = 2
                    c['checkout_time'] = ma['audit_time']
                    break

            # 创建新入住记录
            self.checkins.append({
                'checkin_id': self._cid,
                'student_id': ma['student_id'],
                'bed_id': ma['target_bed_id'],
                'checkin_time': ma['audit_time'],
                'checkout_time': None,
                'checkin_status': 1,
                'operator_id': ma['auditor_id'] or admin_id,
                'remark': '调宿迁入',
            })
            self._cid += 1

            # 更新床位状态
            for b in self.beds:
                if b['bed_id'] == ma['original_bed_id']:
                    b['bed_status'] = 0
                elif b['bed_id'] == ma['target_bed_id']:
                    b['bed_status'] = 1

    # ---------- 9. 生成报修 ----------

    def gen_repairs(self):
        checked_in = self.checked_in_students()
        dm_ids = [u['user_id'] for u in self.users if u['role_type'] == 2]
        admin_id = 1

        if REPAIR_COUNT > len(checked_in):
            print('错误：报修数({}) 超过已入住学生数({})'.format(
                REPAIR_COUNT, len(checked_in)), file=sys.stderr)
            sys.exit(1)

        applicants = random.sample(checked_in, REPAIR_COUNT)
        # 状态分布：~30% 待处理, ~30% 处理中, ~40% 已完成
        statuses = [0] * 3 + [1] * 3 + [2] * 4
        random.shuffle(statuses)

        for i, (app, status) in enumerate(zip(applicants, statuses[:REPAIR_COUNT])):
            rtype = random.choice([1, 2, 3, 4])
            content = pick(REPAIR_CONTENTS[rtype])
            submit_time = rand_date_between(DATE_RANGE_START, DATE_RANGE_END)
            phone = next((u['phone'] for u in self.users if u['user_id'] == app['student_id']), '13800000000')

            handler_id = None
            handle_result = None
            finish_time = None
            if status == 1:  # 处理中
                handler_id = pick(dm_ids) if dm_ids else admin_id
            elif status == 2:  # 已完成
                handler_id = pick(dm_ids) if dm_ids else admin_id
                finish_time = submit_time + timedelta(days=random.randint(1, 10),
                                                       hours=random.randint(0, 8))
                handle_result = pick(['已维修完成', '更换配件已修好', '已联系售后修复',
                                      '已处理，恢复正常使用', '维修完毕'])

            self.repairs.append({
                'repair_id': self._rpid,
                'student_id': app['student_id'],
                'room_id': app['room_id'],
                'repair_type': rtype,
                'repair_content': content,
                'contact_phone': phone,
                'submit_time': submit_time,
                'repair_status': status,
                'handler_id': handler_id,
                'handle_result': handle_result,
                'finish_time': finish_time,
                'remark': None if random.random() > 0.3 else pick(['紧急', '优先处理', None, None]),
            })
            self._rpid += 1

    # ---------- 10. 生成晚归 ----------

    def gen_late_returns(self):
        checked_in = self.checked_in_students()
        dm_ids = [u['user_id'] for u in self.users if u['role_type'] == 2]
        admin_id = 1

        if LATE_RETURN_COUNT > len(checked_in):
            print('错误：晚归记录数({}) 超过已入住学生数({})'.format(
                LATE_RETURN_COUNT, len(checked_in)), file=sys.stderr)
            sys.exit(1)

        applicants = random.sample(checked_in, LATE_RETURN_COUNT)
        for app in applicants:
            late_time = rand_date_between(DATE_RANGE_START, DATE_RANGE_END)
            late_time = late_time.replace(hour=random.randint(23, 23),
                                           minute=random.randint(10, 59))
            registrar_id = pick(dm_ids) if dm_ids else admin_id
            record_time = late_time + timedelta(minutes=random.randint(5, 20))

            self.late_returns.append({
                'record_id': self._lid,
                'student_id': app['student_id'],
                'building_id': app['building_id'],
                'late_time': late_time,
                'late_reason': pick(LATE_REASONS + [None, None]),
                'registrar_id': registrar_id,
                'record_time': record_time,
                'remark': None if random.random() > 0.2 else '已联系辅导员',
            })
            self._lid += 1

    # ---------- 11. 生成访客 ----------

    def gen_visitors(self):
        checked_in = self.checked_in_students()
        dm_ids = [u['user_id'] for u in self.users if u['role_type'] == 2]
        admin_id = 1

        if VISITOR_COUNT > len(checked_in):
            print('错误：访客记录数({}) 超过已入住学生数({})'.format(
                VISITOR_COUNT, len(checked_in)), file=sys.stderr)
            sys.exit(1)

        applicants = random.sample(checked_in, VISITOR_COUNT)
        for app in applicants:
            visit_time = rand_date_between(DATE_RANGE_START, DATE_RANGE_END)
            registrar_id = pick(dm_ids) if dm_ids else admin_id

            # ~60% 的访客已离开
            has_left = random.random() < 0.6
            leave_time = None
            if has_left:
                leave_hours = random.randint(1, 6)
                leave_time = visit_time + timedelta(hours=leave_hours,
                                                     minutes=random.randint(0, 30))

            # 生成假身份证号
            id_card = '110101{}{:02d}{:02d}{:04d}'.format(
                random.randint(1970, 2005),
                random.randint(1, 12),
                random.randint(1, 28),
                random.randint(1, 9999)
            )

            self.visitors.append({
                'visitor_id': self._vid,
                'visitor_name': pick(VISITOR_SURNAMES) + pick(VISITOR_GIVEN),
                'id_card': id_card,
                'student_id': app['student_id'],
                'building_id': app['building_id'],
                'visit_time': visit_time,
                'leave_time': leave_time,
                'visit_reason': pick(VISIT_REASONS),
                'registrar_id': registrar_id,
                'remark': None if random.random() > 0.3 else
                          pick(['已登记', '携带笔记本电脑', None, '短时探访']),
            })
            self._vid += 1

    # ---------- 12. 生成公告通知 ----------

    def gen_notices(self):
        building_ids = [b['building_id'] for b in self.buildings] if self.buildings else [1]
        publisher_id = 1  # 管理员

        # 预生成内容中需要填充的变量
        now = datetime.strptime(DATE_RANGE_END, '%Y-%m-%d')

        for i in range(NOTICE_COUNT):
            # 类型：均匀分布 1-通知 2-维修 3-活动 4-紧急
            notice_type = (i % 4) + 1

            # 可见范围：大部分全校可见，少量按楼栋
            visible_scope = 1 if i % 3 != 0 else 2
            bld_id = pick(building_ids) if visible_scope == 2 else None

            # 状态：大部分已发布，少量下架
            status = 0 if i >= NOTICE_COUNT - 2 else 1

            # 置顶：仅已发布且随机约1/4
            is_top = 1 if status == 1 and i % 4 == 0 else 0

            # 轮播：仅已发布且非置顶的约1/4
            is_banner = 1 if status == 1 and not is_top and i % 4 == 1 else 0

            # 发布时间：在日期范围内，下架公告更早发布
            publish_time = rand_date_between(DATE_RANGE_START, DATE_RANGE_END)
            if status == 0:
                publish_time = publish_time - timedelta(days=random.randint(45, 180))

            # 标题：从池中随机选取
            title = pick(NOTICE_TITLES)

            # 内容：从对应类型的模板中选取
            content_templates = NOTICE_CONTENTS.get(notice_type, NOTICE_CONTENTS[1])
            content = pick(content_templates)
            # 填充模板变量
            bld_name = next((b['building_name'] for b in self.buildings if b['building_id'] == bld_id), '某公寓') if bld_id else '各公寓'
            content = content.format(
                year=now.year,
                month=now.month,
                day=now.day,
                building_name=bld_name,
            )

            # 轮播图片
            banner_image = pick([BANNER_IMAGE_DEFAULT, None]) if is_banner else None
            banner_expire = None  # 长期有效

            self.notices.append({
                'notice_id': self._nid,
                'title': title,
                'content': content,
                'notice_type': notice_type,
                'visible_scope': visible_scope,
                'building_id': bld_id,
                'status': status,
                'is_top': is_top,
                'is_banner': is_banner,
                'banner_image': banner_image,
                'banner_expire': banner_expire,
                'publisher_id': publisher_id,
                'publish_time': publish_time,
            })
            self._nid += 1

    # ---------- 生成全部 ----------

    def generate_all(self):
        self.reset()
        self.gen_admin()
        self.gen_dorm_managers()
        self.gen_students()
        self.gen_buildings()
        self.gen_rooms()
        self.gen_beds()
        self.gen_checkins()
        self.gen_move_applies()
        self.gen_repairs()
        self.gen_late_returns()
        self.gen_visitors()
        self.gen_notices()

    # ---------- SQL 输出 ----------

    def emit(self, filepath=None):
        """输出SQL到文件或stdout。filepath为None时输出到stdout。"""
        if filepath:
            import contextlib
            with open(filepath, 'w', encoding='utf-8') as f, \
                 contextlib.redirect_stdout(f):
                self._emit_all()
        else:
            self._emit_all()

    def _emit_all(self):
        self._emit_header()
        self._emit_users()
        self._emit_buildings()
        self._emit_rooms()
        self._emit_beds()
        self._emit_checkins()
        self._emit_bed_updates()
        self._emit_move_applies()
        self._emit_repairs()
        self._emit_late_returns()
        self._emit_visitors()
        self._emit_notices()
        self._emit_footer()

    def _emit_header(self):
        print("-- ============================================================")
        print("-- 高校公寓管理系统 测试数据（自动生成）")
        print("-- 生成时间:", datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
        print("-- 配置: STUDENT={}, MANAGER={}, BUILDING={}, ROOM/BLD={},".format(
            STUDENT_COUNT, DORM_MANAGER_COUNT, BUILDING_COUNT, ROOMS_PER_BUILDING))
        print("--        CHECKIN_RATIO={}, MOVE={}, REPAIR={}, LATE={}, VISITOR={}, NOTICE={}".format(
            CHECKIN_RATIO, MOVE_APPLY_COUNT, REPAIR_COUNT, LATE_RETURN_COUNT, VISITOR_COUNT, NOTICE_COUNT))
        print("-- 日期范围:", DATE_RANGE_START, "~", DATE_RANGE_END)
        print("-- 密码:", DEFAULT_PASSWORD, "(MD5)")
        print("-- ============================================================")
        print()
        print("USE dormitory_management;")
        print("SET NAMES utf8mb4;")
        print("SET FOREIGN_KEY_CHECKS = 0;")
        print()

    def _emit_users(self):
        print("-- ----------------------------")
        print("-- 1. 系统用户表 sys_user ({}人)".format(len(self.users)))
        print("-- ----------------------------")
        print("INSERT INTO sys_user (user_id, username, password, real_name, role_type, gender, phone, grade, major, class_name, status) VALUES")
        rows = []
        for u in self.users:
            row = "    ({}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {})".format(
                u['user_id'],
                fmt_s(u['username']),
                fmt_s(u['password']),
                fmt_s(u['real_name']),
                u['role_type'],
                fmt_val(u['gender']),
                fmt_s(u['phone']),
                fmt_val(u['grade']),
                fmt_val(u['major']),
                fmt_val(u['class_name']),
                u['status'],
            )
            rows.append(row)
        print(",\n".join(rows) + ";")
        print()

    def _emit_buildings(self):
        print("-- ----------------------------")
        print("-- 2. 楼栋表 dorm_building ({}栋)".format(len(self.buildings)))
        print("-- ----------------------------")
        print("INSERT INTO dorm_building (building_id, building_no, building_name, floor_count, area, manager_id, remark) VALUES")
        rows = []
        for b in self.buildings:
            row = "    ({}, {}, {}, {}, {}, {}, {})".format(
                b['building_id'],
                fmt_s(b['building_no']),
                fmt_s(b['building_name']),
                b['floor_count'],
                fmt_val(b['area']),
                fmt_val(b['manager_id']),
                fmt_val(b['remark']),
            )
            rows.append(row)
        print(",\n".join(rows) + ";")
        print()

    def _emit_rooms(self):
        print("-- ----------------------------")
        print("-- 3. 房间表 dorm_room ({}间)".format(len(self.rooms)))
        print("-- ----------------------------")
        print("INSERT INTO dorm_room (room_id, room_no, building_id, floor_num, bed_total, room_type, remark) VALUES")
        rows = []
        for r in self.rooms:
            row = "    ({}, {}, {}, {}, {}, {}, {})".format(
                r['room_id'],
                fmt_s(r['room_no']),
                r['building_id'],
                r['floor_num'],
                r['bed_total'],
                r['room_type'],
                fmt_val(r['remark']),
            )
            rows.append(row)
        print(",\n".join(rows) + ";")
        print()

    def _emit_beds(self):
        print("-- ----------------------------")
        print("-- 4. 床位表 dorm_bed ({}张)".format(len(self.beds)))
        print("-- ----------------------------")
        print("INSERT INTO dorm_bed (bed_id, bed_no, room_id, bed_status, remark) VALUES")
        rows = []
        for b in self.beds:
            row = "    ({}, {}, {}, {}, {})".format(
                b['bed_id'],
                fmt_s(b['bed_no']),
                b['room_id'],
                b['bed_status'],
                fmt_val(b['remark']),
            )
            rows.append(row)
        print(",\n".join(rows) + ";")
        print()

    def _emit_checkins(self):
        print("-- ----------------------------")
        print("-- 5. 入住记录表 dorm_checkin_record ({}条)".format(len(self.checkins)))
        print("-- ----------------------------")
        print("INSERT INTO dorm_checkin_record (checkin_id, student_id, bed_id, checkin_time, checkout_time, checkin_status, operator_id, remark) VALUES")
        rows = []
        for c in self.checkins:
            row = "    ({}, {}, {}, {}, {}, {}, {}, {})".format(
                c['checkin_id'],
                c['student_id'],
                c['bed_id'],
                fmt_dt(c['checkin_time']),
                fmt_dt(c['checkout_time']),
                c['checkin_status'],
                c['operator_id'],
                fmt_val(c.get('remark')),
            )
            rows.append(row)
        print(",\n".join(rows) + ";")
        print()

    def _emit_bed_updates(self):
        """已入住床位 UPDATE 语句"""
        occupied = [b for b in self.beds if b['bed_status'] == 1]
        if not occupied:
            return
        ids = [str(b['bed_id']) for b in occupied]
        print("-- 根据入住记录更新床位状态为'已入住'")
        print("UPDATE dorm_bed SET bed_status = 1 WHERE bed_id IN ({});".format(
            ','.join(ids)))
        print()

    def _emit_move_applies(self):
        print("-- ----------------------------")
        print("-- 6. 调宿申请表 dorm_move_apply ({}条)".format(len(self.move_applies)))
        print("-- ----------------------------")
        print("INSERT INTO dorm_move_apply (apply_id, student_id, original_bed_id, target_bed_id, apply_reason, apply_time, audit_status, auditor_id, audit_time, audit_opinion, remark) VALUES")
        rows = []
        for m in self.move_applies:
            row = "    ({}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {})".format(
                m['apply_id'],
                m['student_id'],
                m['original_bed_id'],
                m['target_bed_id'],
                fmt_s(m['apply_reason']),
                fmt_dt(m['apply_time']),
                m['audit_status'],
                fmt_val(m['auditor_id']),
                fmt_dt(m['audit_time']),
                fmt_val(m['audit_opinion']),
                fmt_val(m['remark']),
            )
            rows.append(row)
        print(",\n".join(rows) + ";")
        print()

    def _emit_repairs(self):
        print("-- ----------------------------")
        print("-- 7. 报修表 dorm_repair ({}条)".format(len(self.repairs)))
        print("-- ----------------------------")
        print("INSERT INTO dorm_repair (repair_id, student_id, room_id, repair_type, repair_content, contact_phone, submit_time, repair_status, handler_id, handle_result, finish_time, remark) VALUES")
        rows = []
        for r in self.repairs:
            row = "    ({}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {})".format(
                r['repair_id'],
                r['student_id'],
                r['room_id'],
                r['repair_type'],
                fmt_s(r['repair_content']),
                fmt_s(r['contact_phone']),
                fmt_dt(r['submit_time']),
                r['repair_status'],
                fmt_val(r['handler_id']),
                fmt_val(r['handle_result']),
                fmt_dt(r['finish_time']),
                fmt_val(r['remark']),
            )
            rows.append(row)
        print(",\n".join(rows) + ";")
        print()

    def _emit_late_returns(self):
        print("-- ----------------------------")
        print("-- 8. 晚归记录表 dorm_late_return ({}条)".format(len(self.late_returns)))
        print("-- ----------------------------")
        print("INSERT INTO dorm_late_return (record_id, student_id, building_id, late_time, late_reason, registrar_id, record_time, remark) VALUES")
        rows = []
        for lr in self.late_returns:
            row = "    ({}, {}, {}, {}, {}, {}, {}, {})".format(
                lr['record_id'],
                lr['student_id'],
                lr['building_id'],
                fmt_dt(lr['late_time']),
                fmt_val(lr['late_reason']),
                lr['registrar_id'],
                fmt_dt(lr['record_time']),
                fmt_val(lr['remark']),
            )
            rows.append(row)
        print(",\n".join(rows) + ";")
        print()

    def _emit_visitors(self):
        print("-- ----------------------------")
        print("-- 9. 访客记录表 dorm_visitor ({}条)".format(len(self.visitors)))
        print("-- ----------------------------")
        print("INSERT INTO dorm_visitor (visitor_id, visitor_name, id_card, student_id, building_id, visit_time, leave_time, visit_reason, registrar_id, remark) VALUES")
        rows = []
        for v in self.visitors:
            row = "    ({}, {}, {}, {}, {}, {}, {}, {}, {}, {})".format(
                v['visitor_id'],
                fmt_s(v['visitor_name']),
                fmt_s(v['id_card']),
                v['student_id'],
                v['building_id'],
                fmt_dt(v['visit_time']),
                fmt_dt(v['leave_time']),
                fmt_val(v['visit_reason']),
                v['registrar_id'],
                fmt_val(v['remark']),
            )
            rows.append(row)
        print(",\n".join(rows) + ";")
        print()

    def _emit_notices(self):
        print("-- ----------------------------")
        print("-- 10. 公告通知表 sys_notice ({}条)".format(len(self.notices)))
        print("-- ----------------------------")
        print("INSERT INTO sys_notice (notice_id, title, content, notice_type, visible_scope, building_id, status, is_top, is_banner, banner_image, banner_expire, publisher_id, publish_time) VALUES")
        rows = []
        for n in self.notices:
            row = "    ({}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {})".format(
                n['notice_id'],
                fmt_s(n['title']),
                fmt_s(n['content']),
                n['notice_type'],
                n['visible_scope'],
                fmt_val(n['building_id']),
                n['status'],
                n['is_top'],
                n['is_banner'],
                fmt_val(n['banner_image']),
                fmt_dt(n['banner_expire']),
                n['publisher_id'],
                fmt_dt(n['publish_time']),
            )
            rows.append(row)
        print(",\n".join(rows) + ";")
        print()

    def _emit_footer(self):
        print("SET FOREIGN_KEY_CHECKS = 1;")
        print("-- ======================= 脚本结束 =======================")


# ============================================================
# 入口
# ============================================================

if __name__ == '__main__':
    import os
    # 固定随机种子，每次生成一致数据（需要变动时修改种子）
    random.seed(2026)

    # 输出路径：命令行参数 > 默认 scripts/test_data.sql
    out = sys.argv[1] if len(sys.argv) > 1 else os.path.join(
        os.path.dirname(os.path.abspath(__file__)), 'test_data.sql')

    g = Generator()
    g.generate_all()
    g.emit(out)
    print('已生成:', out, file=sys.stderr)
