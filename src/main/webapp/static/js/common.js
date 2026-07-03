/**
 * 高校公寓管理系统 - 公共JS工具函数
 * 版本：v2.0
 * 说明：封装公共工具函数，提供统一的AJAX请求、错误处理、提示消息等功能
 */

(function($) {
    'use strict';

    /**
     * 获取项目路径
     * @returns {string} 项目路径
     */
    $.getContextPath = function() {
        return window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1));
    };

    /**
     * 构建完整URL
     * @param {string} path - 相对路径
     * @returns {string} 完整URL
     */
    $.buildUrl = function(path) {
        if (path.startsWith('http://') || path.startsWith('https://')) {
            return path;
        }
        return $.getContextPath() + (path.startsWith('/') ? path : '/' + path);
    };

    /**
     * 统一AJAX请求封装
     * @param {string} url - 请求路径
     * @param {string} method - 请求方法（GET/POST）
     * @param {object} data - 请求数据
     * @param {function} successCallback - 成功回调
     * @param {function} errorCallback - 错误回调（可选）
     */
    $.ajaxRequest = function(url, method, data, successCallback, errorCallback) {
        var ajaxOptions = {
            url: $.buildUrl(url),
            type: method,
            dataType: 'json',
            timeout: 30000,
            success: function(result) {
                if (result.code === 200) {
                    if (typeof successCallback === 'function') {
                        successCallback(result);
                    }
                } else if (result.code === 401) {
                    $.toast('warning', '未登录或登录已过期，请重新登录');
                    setTimeout(function() {
                        window.location.href = $.buildUrl('/login');
                    }, 1500);
                    if (typeof errorCallback === 'function') {
                        errorCallback(result);
                    }
                } else if (result.code === 403) {
                    $.toast('error', '无权限访问');
                    if (typeof errorCallback === 'function') {
                        errorCallback(result);
                    }
                } else {
                    if (typeof errorCallback === 'function') {
                        errorCallback(result);
                    } else {
                        $.toast('error', result.msg || '操作失败');
                    }
                }
            },
            error: function(xhr, status, error) {
                $.handleError(xhr, status, error);
                if (typeof errorCallback === 'function') {
                    errorCallback({ code: xhr.status, msg: error });
                }
            }
        };

        if (method.toUpperCase() === 'POST') {
            ajaxOptions.contentType = 'application/json';
            if (data && typeof data === 'object') {
                ajaxOptions.data = JSON.stringify(data);
            }
        } else {
            ajaxOptions.data = data;
        }

        $.ajax(ajaxOptions);
    };

    /**
     * 统一错误处理
     */
    $.handleError = function(xhr, status, error) {
        var message = '请求失败，请稍后重试';

        if (xhr.status === 0) {
            message = '网络连接失败，请检查网络';
        } else if (xhr.status === 401) {
            message = '未登录或登录已过期';
            setTimeout(function() {
                window.location.href = $.buildUrl('/login');
            }, 1500);
        } else if (xhr.status === 403) {
            message = '无权限访问';
        } else if (xhr.status === 404) {
            message = '请求的资源不存在';
        } else if (xhr.status === 408) {
            message = '请求超时，请稍后重试';
        } else if (xhr.status === 500) {
            message = '服务器内部错误，请稍后重试';
        } else if (status === 'timeout') {
            message = '请求超时，请稍后重试';
        } else if (status === 'parsererror') {
            message = '数据解析错误';
        }

        $.toast('error', message);
    };

    /**
     * 提示消息（Toast）
     * @param {string} type - 消息类型（success/warning/error/info）
     * @param {string} message - 消息内容
     * @param {number} duration - 显示时长（毫秒），默认3000
     */
    $.toast = function(type, message, duration) {
        duration = duration || 3000;
        $('.custom-toast').remove();

        var iconMap = {
            success: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" width="16" height="16"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>',
            warning: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" width="16" height="16"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>',
            error: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" width="16" height="16"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>',
            info: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" width="16" height="16"><circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/></svg>'
        };

        var bgMap = {
            success: 'rgb(46, 125, 111)',
            error: 'rgb(196, 69, 58)',
            warning: 'rgb(212, 132, 90)',
            info: 'rgb(122, 112, 103)'
        };
        var colorMap = {
            success: 'rgb(255, 255, 255)',
            error: 'rgb(255, 255, 255)',
            warning: 'rgb(45, 36, 28)',
            info: 'rgb(255, 255, 255)'
        };

        var toastHtml = '<div class="custom-toast" style="' +
            'background: ' + bgMap[type] + ';' +
            'color: ' + colorMap[type] + ';' +
            'border: 1px solid ' + colorMap[type] + '33;">' +
            (iconMap[type] || '') +
            '<span>' + message + '</span>' +
            '</div>';

        $('body').append(toastHtml);

        setTimeout(function() {
            $('.custom-toast').fadeOut(300, function() {
                $(this).remove();
            });
        }, duration);
    };

    /**
     * 确认对话框
     * @param {string} message - 提示消息
     * @param {function} onConfirm - 确认回调
     * @param {function} onCancel - 取消回调（可选）
     * @param {string} title - 标题（可选）
     */
    $.confirm = function(message, onConfirm, onCancel, title) {
        title = title || '确认操作';
        $('.custom-confirm').remove();

        var confirmHtml = '<div class="custom-confirm">' +
            '<div class="confirm-dialog">' +
            '<h4>' + title + '</h4>' +
            '<p>' + message + '</p>' +
            '<div class="confirm-actions">' +
            '<button class="btn btn-secondary btn-cancel">取消</button>' +
            '<button class="btn btn-primary btn-confirm">确认</button>' +
            '</div>' +
            '</div>' +
            '</div>';

        $('body').append(confirmHtml);

        $('.custom-confirm .btn-confirm').on('click', function() {
            $('.custom-confirm').remove();
            if (typeof onConfirm === 'function') { onConfirm(); }
        });

        $('.custom-confirm .btn-cancel').on('click', function() {
            $('.custom-confirm').remove();
            if (typeof onCancel === 'function') { onCancel(); }
        });

        $('.custom-confirm').on('click', function(e) {
            if ($(e.target).hasClass('custom-confirm')) {
                $('.custom-confirm').remove();
                if (typeof onCancel === 'function') { onCancel(); }
            }
        });
    };

    /**
     * 跳转页面
     */
    $.navigate = function(url) {
        window.location.href = $.buildUrl(url);
    };

    /**
     * 分页参数构建
     */
    $.buildPageParams = function(pageNum, pageSize) {
        return { pageNum: pageNum || 1, pageSize: pageSize || 10 };
    };

    /**
     * 表单序列化为JSON
     */
    $.fn.serializeJSON = function() {
        var obj = {};
        var arr = this.serializeArray();
        $.each(arr, function() {
            if (obj[this.name] !== undefined) {
                if (!obj[this.name].push) { obj[this.name] = [obj[this.name]]; }
                obj[this.name].push(this.value || '');
            } else {
                obj[this.name] = this.value || '';
            }
        });
        return obj;
    };

    /**
     * 日期格式化
     */
    $.formatDate = function(date, format) {
        format = format || 'yyyy-MM-dd HH:mm:ss';
        if (!date) return '';
        if (typeof date === 'string' || typeof date === 'number') { date = new Date(date); }
        if (!(date instanceof Date) || isNaN(date.getTime())) return '';

        var o = {
            'M+': date.getMonth() + 1, 'd+': date.getDate(),
            'H+': date.getHours(), 'h+': date.getHours() % 12 || 12,
            'm+': date.getMinutes(), 's+': date.getSeconds(),
            'q+': Math.floor((date.getMonth() + 3) / 3), 'S': date.getMilliseconds()
        };

        if (/(y+)/.test(format)) {
            format = format.replace(RegExp.$1, (date.getFullYear() + '').substr(4 - RegExp.$1.length));
        }
        for (var k in o) {
            if (new RegExp('(' + k + ')').test(format)) {
                format = format.replace(RegExp.$1, (RegExp.$1.length === 1) ? (o[k]) : (('00' + o[k]).substr(('' + o[k]).length)));
            }
        }
        return format;
    };

    /**
     * 渲染每页条数选择器（.cselect 组件）
     * @param {number} currentPageSize - 当前每页条数
     * @returns {string} HTML字符串
     */
    $.renderPageSizeCselect = function(currentPageSize) {
        var sizes = [10, 20, 50];
        var html = '<div class="page-size-select"><label>每页</label>';
        html += '<div class="cselect" style="min-width:70px;">';
        html += '<div class="cselect-trigger" tabindex="0" aria-haspopup="listbox" aria-expanded="false" style="padding:4px 8px;">';
        html += '<span class="cselect-val">' + currentPageSize + '</span>';
        html += '<svg class="cselect-arrow" viewBox="0 0 24 24" width="12" height="12" stroke="currentColor" stroke-width="1.6" fill="none" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"/></svg>';
        html += '</div><div class="cselect-panel" role="listbox">';
        sizes.forEach(function(s) {
            html += '<div class="cselect-option' + (s === currentPageSize ? ' selected' : '') + '" data-value="' + s + '">' + s + '</div>';
        });
        html += '</div></div><label>条</label></div>';
        return html;
    };

    /**
     * 渲染分页组件（新DOM结构）
     * @param {object} pageInfo - 分页信息对象
     * @param {string} containerId - 容器ID
     * @param {function} onPageChange - 页码变更回调
     */
    $.renderPagination = function(pageInfo, containerId, onPageChange, pageSize, onPageSizeChange) {
        var container = document.getElementById(containerId);
        if (!container || !pageInfo) return;

        var totalPages = pageInfo.pages || 1;
        var currentPage = pageInfo.pageNum || 1;
        var total = pageInfo.total || 0;
        var hasPageSize = (pageSize != null && typeof onPageSizeChange === 'function');

        // 信息文字
        var html = '<div class="pagination-container">';
        html += '<span class="pagination-info">共 <strong>' + total + '</strong> 条记录，第 <strong>' + currentPage + '</strong> / <strong>' + totalPages + '</strong> 页</span>';

        // 右侧区域：页面大小选择器 + 页码按钮
        html += '<div class="d-flex align-items-center gap-3">';
        if (hasPageSize) {
            html += $.renderPageSizeCselect(pageSize);
        }
        html += '<div class="pagination-pages">';

        // 首页
        html += '<button class="page-btn" ' + (currentPage === 1 ? 'disabled' : '') + ' data-page="1">&laquo;</button>';
        // 上一页
        html += '<button class="page-btn" ' + (currentPage === 1 ? 'disabled' : '') + ' data-page="' + (currentPage - 1) + '">&lsaquo;</button>';

        // 页码
        var startPage = Math.max(1, currentPage - 2);
        var endPage = Math.min(totalPages, currentPage + 2);
        if (startPage > 1) {
            html += '<button class="page-btn" data-page="1">1</button>';
            if (startPage > 2) html += '<span class="page-ellipsis">...</span>';
        }
        for (var i = startPage; i <= endPage; i++) {
            html += '<button class="page-btn' + (i === currentPage ? ' active' : '') + '" data-page="' + i + '">' + i + '</button>';
        }
        if (endPage < totalPages) {
            if (endPage < totalPages - 1) html += '<span class="page-ellipsis">...</span>';
            html += '<button class="page-btn" data-page="' + totalPages + '">' + totalPages + '</button>';
        }

        // 下一页
        html += '<button class="page-btn" ' + (currentPage === totalPages ? 'disabled' : '') + ' data-page="' + (currentPage + 1) + '">&rsaquo;</button>';
        // 末页
        html += '<button class="page-btn" ' + (currentPage === totalPages ? 'disabled' : '') + ' data-page="' + totalPages + '">&raquo;</button>';

        html += '</div></div></div>';
        container.innerHTML = html;

        // 绑定页码按钮事件
        $(container).find('.page-btn').on('click', function() {
            var page = parseInt($(this).data('page'));
            if (page && page !== currentPage && typeof onPageChange === 'function') {
                onPageChange(page);
            }
        });

        // 初始化页面大小选择器
        if (hasPageSize) {
            $.initCustomSelect();
            // 绑定页面大小变更事件
            $(container).find('.cselect-option').on('click', function() {
                var newSize = parseInt($(this).attr('data-value'));
                if (newSize && newSize !== pageSize) {
                    onPageSizeChange(newSize);
                }
            });
        }
    };

    /**
     * 初始化自定义下拉选择框
     * 在页面加载后调用，将所有 .cselect 元素初始化为自定义下拉框
     */
    $.initCustomSelect = function() {
        document.querySelectorAll('.cselect').forEach(function(cs) {
            if (cs.dataset.initialized) return;
            cs.dataset.initialized = 'true';

            var trigger = cs.querySelector('.cselect-trigger');
            var panel = cs.querySelector('.cselect-panel');
            var valEl = cs.querySelector('.cselect-val');
            if (!trigger || !panel) return;

            // 悬浮展开/收起
            var hoverTimer = null;
            cs.addEventListener('mouseenter', function() {
                clearTimeout(hoverTimer);
                hoverTimer = setTimeout(function() {
                    document.querySelectorAll('.cselect.open').forEach(function(o) {
                        if (o !== cs) o.classList.remove('open');
                    });
                    cs.classList.add('open');
                    trigger.setAttribute('aria-expanded', 'true');
                }, 120);
            });
            cs.addEventListener('mouseleave', function() {
                clearTimeout(hoverTimer);
                hoverTimer = setTimeout(function() {
                    cs.classList.remove('open');
                    trigger.setAttribute('aria-expanded', 'false');
                }, 200);
            });

            trigger.addEventListener('click', function(e) {
                e.stopPropagation();
                document.querySelectorAll('.cselect.open').forEach(function(o) {
                    if (o !== cs) o.classList.remove('open');
                });
                cs.classList.toggle('open');
                trigger.setAttribute('aria-expanded', cs.classList.contains('open'));
            });

            panel.querySelectorAll('.cselect-option').forEach(function(opt) {
                opt.addEventListener('click', function(e) {
                    e.stopPropagation();
                    clearTimeout(hoverTimer);
                    panel.querySelectorAll('.cselect-option').forEach(function(o) { o.classList.remove('selected'); });
                    opt.classList.add('selected');
                    if (valEl) {
                        valEl.textContent = opt.textContent;
                        valEl.classList.remove('cselect-placeholder');
                    }
                    cs.classList.remove('open');
                    cs.dataset.value = opt.dataset.value;
                    cs.classList.toggle('has-value', !!opt.dataset.value);

                    // 触发自定义事件
                    var event = new CustomEvent('cselect:change', {
                        detail: { value: opt.dataset.value, text: opt.textContent }
                    });
                    cs.dispatchEvent(event);
                });
            });

            // 键盘可访问性
            trigger.setAttribute('tabindex', '0');
            trigger.setAttribute('role', 'combobox');
            trigger.setAttribute('aria-expanded', 'false');

            trigger.addEventListener('keydown', function(e) {
                if (e.key === 'Enter' || e.key === ' ') {
                    e.preventDefault();
                    trigger.click();
                } else if (e.key === 'Escape') {
                    cs.classList.remove('open');
                    trigger.setAttribute('aria-expanded', 'false');
                }
            });
        });

        // 点击外部关闭所有下拉框
        document.addEventListener('click', function() {
            document.querySelectorAll('.cselect.open').forEach(function(o) {
                o.classList.remove('open');
                var trigger = o.querySelector('.cselect-trigger');
                if (trigger) trigger.setAttribute('aria-expanded', 'false');
            });
        });
    };

    /**
     * 动态更新自定义下拉框选项
     * @param {HTMLElement} cselectEl - .cselect 元素
     * @param {Array} options - 选项数组 [{value, text, selected}]
     */
    $.updateCselectOptions = function(cselectEl, options) {
        var panel = cselectEl.querySelector('.cselect-panel');
        var valEl = cselectEl.querySelector('.cselect-val');
        if (!panel) return;

        // 清空并重建选项
        panel.innerHTML = '';
        options.forEach(function(opt) {
            var div = document.createElement('div');
            div.className = 'cselect-option' + (opt.selected ? ' selected' : '');
            div.dataset.value = opt.value;
            div.textContent = opt.text;
            panel.appendChild(div);
        });

        // 重置显示文本
        if (valEl) {
            valEl.textContent = options[0] ? options[0].text : '请选择';
            valEl.classList.toggle('cselect-placeholder', !options[0] || !options[0].value);
        }
        cselectEl.dataset.value = options[0] ? options[0].value : '';
        cselectEl.classList.toggle('has-value', !!(options[0] && options[0].value));

        // 重新绑定事件（移除已初始化标记）
        delete cselectEl.dataset.initialized;
        $.initCustomSelect();
    };

    /**
     * 表格行 stagger 入场动画
     * @param {jQuery} $tbody - 表格 tbody 的 jQuery 对象
     * @param {number} rowLimit - 动画行数上限，默认 20（超过仅前 20 行做 stagger，其余直接显示）
     */
    $.staggerRows = function($tbody, rowLimit) {
        rowLimit = rowLimit || 20;
        $tbody.find('tr').each(function(i) {
            if (i >= rowLimit) return;
            var $row = $(this);
            $row.css({ opacity: 0, transform: 'translateY(6px)' });
            setTimeout(function() {
                $row.css({ transition: 'opacity 0.3s ease, transform 0.3s ease', opacity: 1, transform: 'translateY(0)' });
            }, i * 30);
        });
    };

    /**
     * 生成骨架屏行
     * @param {number} count - 骨架屏行数，默认 5
     * @param {number} colCount - 列数，需与实际表格 th 数量一致，默认 4
     * @returns {string} HTML 字符串
     */
    $.renderSkeletonRows = function(count, colCount) {
        count = count || 5;
        colCount = colCount || 4;
        var html = '';
        for (var i = 0; i < count; i++) {
            html += '<tr class="skeleton-row">';
            for (var j = 0; j < colCount; j++) {
                html += '<td><div class="skeleton-bar"></div></td>';
            }
            html += '</tr>';
        }
        return html;
    };

    /**
     * 渲染空状态
     * @param {string} type - 'no-data' | 'no-result'
     * @param {string} [actionUrl] - 引导操作链接
     * @param {string} [actionText] - 引导操作文案
     * @returns {string} HTML 字符串
     */
    $.renderEmptyState = function(type, actionUrl, actionText) {
        var title, desc;
        if (type === 'no-result') {
            title = '未找到匹配结果';
            desc = '当前筛选条件下没有找到匹配的记录，请调整筛选条件后重试';
        } else {
            title = '暂无数据';
            desc = '当前没有任何记录，可以点击下方按钮添加';
        }
        var html = '<tr><td colspan="99">' +
            '<div class="empty-state">' +
            '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">' +
            '<path d="M13 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V9z"/>' +
            '<polyline points="13 2 13 9 20 9"/></svg>' +
            '<div class="empty-state-title">' + title + '</div>' +
            '<div class="empty-state-desc">' + desc + '</div>';
        if (actionUrl && actionText) {
            html += '<a href="' + $.buildUrl(actionUrl) + '" class="btn btn-primary btn-sm">' + actionText + '</a>';
        }
        html += '</div></td></tr>';
        return html;
    };

    /**
     * 初始化页面公共功能
     */
    $(document).ready(function() {
        // 输入框有内容时添加 has-value 类（主题色边框）
        function syncHasValue(el) {
            var v = $(el).val();
            $(el).toggleClass('has-value', !!v && v.trim().length > 0);
        }
        $(document).on('input change blur keyup', 'input.form-control:not([readonly]), textarea.form-control:not([readonly])', function() {
            syncHasValue(this);
        });
        // 初始化已有值的输入框
        $('input.form-control:not([readonly]), textarea.form-control:not([readonly])').each(function() {
            syncHasValue(this);
        });

        // 移动端侧边栏切换
        $('.navbar-toggler').on('click', function() {
            $('.sidebar').toggleClass('show');
        });

        // 点击内容区域关闭侧边栏（移动端）
        $('.content-body').on('click', function() {
            if ($(window).width() <= 768) {
                $('.sidebar').removeClass('show');
            }
        });

        // 高亮当前页面菜单：精确路径段匹配，避免 /admin/index 匹配所有 /admin/* 页面
        var currentPath = window.location.pathname;
        $('.sidebar-menu .menu-link').each(function() {
            var href = $(this).attr('href');
            if (!href || href === 'javascript:void(0)' || href === '#') return;
            if (currentPath === href) {
                $(this).addClass('active');
            } else if (href.endsWith('/index')) {
                // /admin/index 只匹配 /admin/index 和 /admin/
                var dir = href.substring(0, href.lastIndexOf('/') + 1);
                if (currentPath === dir || currentPath === dir.substring(0, dir.length - 1)) {
                    $(this).addClass('active');
                }
            } else {
                // 同目录子页面匹配：/admin/user/editPage 匹配 /admin/user/list
                var linkDir = href.substring(0, href.lastIndexOf('/') + 1);
                var curDir = currentPath.substring(0, currentPath.lastIndexOf('/') + 1);
                if (linkDir === curDir) {
                    $(this).addClass('active');
                }
            }
        });

        // 退出登录
        $('.btn-logout').on('click', function(e) {
            e.preventDefault();
            $.confirm('确定要退出登录吗？', function() {
                $.ajaxRequest('/logout', 'POST', null, function() {
                    $.toast('success', '退出成功');
                    setTimeout(function() {
                        window.location.href = $.buildUrl('/login');
                    }, 1000);
                });
            });
        });

        // 全局AJAX错误处理
        $(document).ajaxError(function(event, xhr, settings) {
            if (xhr.status === 401 && settings.url.indexOf('/login') === -1) {
                $.toast('warning', '未登录或登录已过期，请重新登录');
                setTimeout(function() {
                    window.location.href = $.buildUrl('/login');
                }, 1500);
            }
        });

        // 初始化自定义下拉选择框
        if (typeof $.initCustomSelect === 'function') {
            $.initCustomSelect();
        }
    });

})(jQuery);
