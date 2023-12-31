/**
 * @author yongyang
 * @description 手术排班视图 手术护士已排列表
 */
(function(global, factory) {
    factory((global.NurseSchedule = {}));
}(this, (function(exports) {

    var _id = 0;

    var _methods = {};

    /**
     * 初始化方法，外部调用：NurseList.init(...);
     * 暂时没有考虑传入的元素已经绑定此对象的情况
     * @param {HTMLElement} dom 
     * @param {object} opt 
     * @returns 
     */
    function init(dom, opt) {
        _id++;

        var cardboard = new NurseSchedule(dom, opt);

        return cardboard;
    }

    exports.init = init;

    var defaultOptions = {
        fit: true,
        width: 'auto',
        height: 430,
        singleSelection: true
    }

    /**
     * @description NurseSchedule构造函数
     * @author yongyang 2018-03-06
     * @module NurseSchedule
     * @constructor
     * @param {HTMLElement} dom 
     * @param {object} opt 
     */
    function NurseSchedule(dom, opt) {
        /**
         * @property {Array} 手术安排数据
         */
        this.bindedData = [];

        /**
         * @property {HTMLElement} cardboard对应的界面元素
         * @private
         */
        this.dom = dom;

        /**
         * @property {object} 配置信息
         * @private
         */
        this.options = $.extend({}, defaultOptions, opt);

        this.onQuery = null;

        this._init();
        this.setOptions(opt);
    };

    /**
     * 今日排班 分别显示 特殊班次、各手术间人员
     */
    NurseSchedule.prototype = {
        _init: function() {
            var _this = this;
            var options = this.options;

            this.dialog = $('<div></div>').appendTo('body');
            _this.dialog.dialog({
                modal: true,
                title: '科室排班',
                closed: true,
                width: 1280,
                height: 700,
                headerCls: 'panel-header-gray',
                iconCls: 'icon-w-paper',
                onClose: function() {
                    if (_this.options.callback) _this.options.callback.call(_this);
                }
            });

            var header = $('<div class="nurseschedule-header" style="padding:5px 0px;"></div>').appendTo(this.dom);
            var btn = $('<a href="#">科室排班</a>').appendTo(header);
            btn.linkbutton({
                iconCls: "icon-cal-pen",
                plain: true,
                onClick: function() {
                    var date = '';
                    if (_this.options.getCurrentDate) date = _this.options.getCurrentDate();
                    _this.dialog.dialog({
                        content: "<iframe scrolling='yes' frameborder='0' src='CIS.AN.DailyAttendance.csp?operdate=" + date + "' style='width:100%;height:100%'></iframe>"
                    })
                    _this.dialog.dialog("open");
                }
            });
            if (!options.editable) header.hide();

            this.dataContainer = $('<div class="nurseschedule-container"></div>').appendTo(this.dom);
            //this.dataContainer.height(options.height);
        },
        /**
         * 加载排班类型
         * 可多次调用，调用时会直接添加，所以不要重复调用
         * @param {*} data 
         * @param {boolean} prioritized 是否优先显示
         */
        loadSchedule: function(data, prioritized) {
            this.schedules = (this.schedules || []).concat(data);
            var groups = groupingData(data, 'GroupBy');
            var length = groups.length;
            var container = this.dataContainer;

            var element;
            if (prioritized) {
                for (var i = length - 1; i >= 0; i--) {
                    element = $('<div class="nurseschedule-group"></div>').prependTo(container);
                    groupView.render(element, groups[i]);
                }
            } else {
                for (var i = 0; i < length; i++) {
                    element = $('<div class="nurseschedule-group"></div>').appendTo(container);
                    groupView.render(element, groups[i]);
                }
            }
        },
        /**
         * 加载人员排班的数据
         * -> 按首字母分组
         */
        loadData: function(data) {
            this.bindedData = data;
            this.render();
        },
        /**
         * 设置参数
         * @param {*} options 
         */
        setOptions: function(options) {
            var _this = this;
            $.extend(this.options, options);
        },
        /**
         * 渲染
         */
        render: function() {
            var data = this.bindedData;
            var schedules = this.dataContainer.find('.nurseschedule-item');
            var scheduleDic = {};

            var length = schedules.length;
            var schedule, type, key;
            for (var i = 0; i < length; i++) {
                schedule = $(schedules[i]);
                type = schedule.attr('data-type');
                key = schedule.attr('data-key');
                if (!scheduleDic[type]) scheduleDic[type] = {};
                scheduleDic[type][key] = schedule;
            }

            var length = data.length;
            var row;
            for (var i = 0; i < length; i++) {
                row = data[i];
                if (scheduleDic[row.Type] && scheduleDic[row.Type][row.RowId]) {
                    schedule = scheduleDic[row.Type][row.RowId];
                    itemView.refresh(schedule, row.Value);
                }
            }
        },
        /**
         * 关闭对话框
         */
        closeDialog: function() {
            this.dialog.dialog('close');
        },
        clear: function() {
            this.dataContainer.empty();
        },
        refresh: function() {
            if (this.options.callback) this.options.callback.call(this);
        }
    };

    /**
     * 对数据进行分组
     */
    function groupingData(data, field) {
        var groupDic = [];
        var groups = [];
        var groupField = field;

        var length = data.length;
        var row, index;
        for (var i = 0; i < length; i++) {
            row = data[i];
            index = groupDic.indexOf(row[groupField]);
            if (index > -1) {
                groups[index].items.push(row);
            } else {
                groupDic.push(row[groupField]);
                groups.push({
                    key: row[groupField],
                    items: [row]
                })
            }
        }
        return groups;
    }

    /**
     * 排班类型分组视图
     */
    var groupView = {
        render: function(container, group) {
            container.data('data', group);
            group.target = container;

            $('<div class="nurseschedule-group-header"></div>')
                .append('<span class="header-text">' + group.key + '</span>')
                .appendTo(container);
            var itemsContainer = $('<div class="nurseschedule-group-items"></div>')
                .appendTo(container);
            var length = group.items.length;
            var element = null;
            for (var i = 0; i < length; i++) {
                element = $('<div class="nurseschedule-item"></div>').appendTo(itemsContainer);
                itemView.render(element, group.items[i]);
            }
        }
    }

    /**
     * 排班类型视图
     */
    var itemView = {
        render: function(container, item) {
            container.append('<span class="nurseschedule-item-label">' + item['Description'] + '</span>')
                .append('<span class="nurseschedule-item-value"></span>')
                .attr('data-key', item.RowId)
                .attr('data-type', item.Type)
                .data('data', item);
            item.target = container;
        },
        refresh: function(container, value) {
            container.find('.nurseschedule-item-value').text(value);
        }
    }
})));