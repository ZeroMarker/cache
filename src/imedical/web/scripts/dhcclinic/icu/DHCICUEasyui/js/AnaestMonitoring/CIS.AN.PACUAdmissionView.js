/**
 * PACU准入管理
 * @author yongyang 20200701
 */
(function(global, factory) {
    if (!global.PACUAdmissionView) factory(global.PACUAdmissionView = {});
}(this, function(exports) {

    exports.init = function(opt) {
        var view = new PACUAdmissionView(opt);
        exports.instance = view;
        return view;
    }

    exports.instance = null;

    function PACUAdmissionView(opt) {
        this.options = $.extend({ width: 745, height: 420 }, opt);
        this.readHandler = opt.readHandler;
        this.searchHandler = opt.searchHandler;
        this.respondHandler = opt.respondHandler;
        this.confirmHandler = opt.confirmHandler;
        this.init();
    }

    PACUAdmissionView.prototype = {
        init: function() {
            var _this = this;
            this.initiateStatus = {};
            this.dom = $('<div></div>').appendTo('body');

            this.initForm();
            this.initMessageList();
            this.initMessageBox();

            this.dom.dialog({
                left: 347,
                top: 150,
                height: this.options.height,
                width: this.options.width,
                title: 'PACU准入管理',
                iconCls: 'icon-w-msg',
                modal: true,
                closed: true,
                onOpen: function() {

                },
                onClose: function() {
                    _this.clear();
                }
            });
        },
        initForm: function() {
            var _this = this;
            var container = $('<div style="padding:10px 5px;"></div>').appendTo(this.dom);
            this.form = $('<form class="pav-form"></form>').appendTo(container);

            var row = $('<div class="pav-f-r"></div>').appendTo(this.form);
            var label = $('<span class="label">发送日期</span>').appendTo(row);
            this.RequestDateFrom = $('<input type="text">').appendTo(row);
            this.RequestDateFrom.datebox({
                required: false,
                width: 160,
                label: label
            });
            var label = $('<span class="label">至</span>').appendTo(row);
            this.RequestDateTo = $('<input type="text">').appendTo(row);
            this.RequestDateTo.datebox({
                required: false,
                width: 160,
                label: label
            });

            var row = $('<div class="pav-f-r"></div>').appendTo(this.form);
            var label = $('<span class="label">状态</span>').appendTo(row);
            this.Status = $('<input type="text">').appendTo(row);
            this.Status.combobox({
                width: 80,
                label: label,
                value: 'Unconfirmed',
                data: [{ text: '未处理', value: 'Unconfirmed' }, { text: '已处理', value: 'Confirmed' }]
            });

            var buttons = $('<div class="pav-f-r"></div>').appendTo(this.form);
            this.btn_search = $('<a href="#"></a>').linkbutton({
                text: '查询',
                iconCls: 'icon-w-find',
                onClick: function() {
                    _this.search();
                }
            }).appendTo(buttons);
        },
        initMessageList: function() {
            var _this = this;
            var width = 360;
            var height = 300;
            var container = $('<div class="pav-msg-list"></div>').appendTo(this.dom);
            var datagrid = $('<table></table>').appendTo(container);

            $(datagrid).datagrid({
                width: width,
                height: height,
                singleSelect: true,
                rownumbers: true,
                border: false,
                columns: [
                    [{
                            field: "Status",
                            title: "状态",
                            width: 50,
                            hidden: false,
                            formatter: function(value, row, index) {
                                var html = '<span title="' + row.StatusDesc +
                                    '" class="' + row.IconCls + '"> '+ row.StatusDesc + '</span>';

                                return html;
                            }
                        },
                        { field: "Info", title: "内容", width: 100 },
                        { field: "RequestDate", title: "申请日期", width: 100 },
                        { field: "RequestTime", title: "申请时间", width: 80 },
                        { field: "RowId", title: "RowId", width: 60, hidden: true }
                    ]
                ],
                onLoadSuccess: function() {},
                onSelect: function(index, row) {
                    _this.readMessage(row);
                }
            });

            this.msgList = datagrid;
        },
        initMessageBox: function() {
            var width = 360;
            var height = 300;
            var container = $('<div class="pav-msg-box"></div>').appendTo(this.dom);

            var header = $('<div class="pav-msg-header"></div>').appendTo(container);
            var content = $('<div class="pav-msg-content"></div>').appendTo(container);

            this.msgBox = container;
        },
        loadData: function(data) {
            this.msgList.datagrid('loadData', data);
        },
        readMessage: function(row) {
            var _this = this;
            if (row.Status == 'Sent') {
                if (this.readHandler) this.readHandler.call(this, { rowId: row.RowId });
                row.Status = 'Read';
                row.IconCls = 'icon-read';
                row.StatusDesc = '已读未处理';
                row.Reader = session.UserName;
                row.ReadDT = new Date().format(constant.timeStampFormat);
            }
            var header = this.msgBox.find('.pav-msg-header');
            patinfo.render(header, row);

            var content = this.msgBox.find('.pav-msg-content');
            msginfo.render(content, row, function(row) {
                if (row.Status == 'Read') _this.respond(row);
                else if (row.Status == 'Responded') _this.confirm(row);
            });
        },
        respond: function(row) {
            if (row.Status == 'Read') {
                if (this.respondHandler) this.respondHandler.call(this, { rowId: row.RowId });
                row.Status = 'Responded';
                row.IconCls = 'icon-exec';
                row.StatusDesc = '已处理';
                row.RespondUser = session.UserName;
                row.RespondDT = new Date().format(constant.timeStampFormat);
            }

            var content = this.msgBox.find('.pav-msg-content');
            msginfo.refresh(content, row);
        },
        confirm: function(row) {
            if (row.Status == 'Responded') {
                if (this.confirmHandler) this.confirmHandler.call(this, { rowId: row.RowId });
                row.Status = 'Confirmed';
                row.IconCls = 'icon-exec';
                row.StatusDesc = '已处理';
                row.ConfirmUser = session.UserName;
                row.ConfirmDT = new Date().format(constant.timeStampFormat);
            }

            var content = this.msgBox.find('.pav-msg-content');
            msginfo.refresh(content, row);
        },
        search: function() {
            if (this.searchHandler) {
                this.searchHandler.call(this, {
                    startDate: this.RequestDateFrom.datebox('getValue') || '',
                    endDate: this.RequestDateTo.datebox('getValue') || '',
                    status: this.Status.combobox('getValue') || ''
                });
            }
        },
        open: function() {
            this.dom.dialog('open');
        },
        close: function() {
            this.dom.dialog('close');
        },
        clear: function() {},
        validate: function() {

        },
        save: function() {
            var newData = this.toData();
            var preparedData = newData;
            if (this.saveHandler) {
                this.saveHandler(preparedData);
                this.btn_save.linkbutton('disable');
                this.btn_save.find('.l-btn-text').text('已申请');
            }
        },
        validate: function(data) {
            var _this = this;

            return true;
        },
        toData: function() {
            return {};
        }
    }

    var patinfo = {
        render: function(container, operSchedule) {
            container.empty();

            var avatar = $('<div class="pav-msg-pat-avatar"></div>').appendTo(container);
            if (operSchedule.PatGender === '女') {
                avatar.addClass('avatar-female-big');
            } else if (operSchedule.PatGender === '男') {
                avatar.addClass('avatar-male-big');
            } else {
                avatar.addClass('avatar-unknown');
            }

            var patinfo = $('<div class="pav-msg-pat"></div>').appendTo(container);

            var row = $('<div class="pav-msg-pat-r"></div>').appendTo(patinfo);
            row.append('<span class="pav-msg-pat-patname">' + operSchedule.PatName + '</span>');
            row.append('<span class="pav-msg-pat-seperator"></span>');
            row.append('<span class="pav-msg-pat-info">' + operSchedule.PatGender + '</span>');
            row.append('<span class="pav-msg-pat-seperator"></span>');
            row.append('<span class="pav-msg-pat-info">' + operSchedule.PatAge + '</span>');
            row.append('<span class="pav-msg-pat-seperator"></span>');
            row.append('<span class="pav-msg-pat-info">' + operSchedule.RegNo + '</span>');

            var row = $('<div class="pav-msg-pat-r"></div>').appendTo(patinfo);
            row.append('<span class="pav-msg-pat-info">' + operSchedule.RoomDesc + '</span>');
            row.append('<span class="pav-msg-pat-seperator"></span>');
            row.append('<span class="pav-msg-pat-info">' + operSchedule.OperDesc + '</span>');
            row.append('<span class="pav-msg-pat-seperator"></span>');
            row.append('<span class="pav-msg-pat-info">' + operSchedule.AnaMethodDesc + '</span>');
        }
    };

    var msginfo = {
        render: function(container, msg, callback) {
            container.empty();

            var detail = $('<div class="pav-msg-c-detail"></div>').appendTo(container);
            detail.append('<span class="pav-msg-c-info">申请人：</span><span class="pav-msg-c-info pav-msg-c-content">' + msg.RequestUser + '</span>');
            detail.append('<span class="pav-msg-c-info">申请时间：</span><span class="pav-msg-c-info pav-msg-c-content">' + msg.RequestDT + '</span>');
            detail.append('<span class="pav-msg-c-info">阅读人：</span><span class="pav-msg-c-info pav-msg-c-content">' + (msg.Reader || '') + '</span>');
            detail.append('<span class="pav-msg-c-info">阅读时间：</span><span class="pav-msg-c-info pav-msg-c-content">' + (msg.ReadDT || '') + '</span>');
            detail.append('<span class="pav-msg-c-info">处理人：</span><span class="pav-msg-c-info pav-msg-c-content">' + (msg.RespondUser || '') + '</span>');
            detail.append('<span class="pav-msg-c-info">处理时间：</span><span class="pav-msg-c-info pav-msg-c-content">' + (msg.RespondDT || '') + '</span>');

            var procedure = $('<div class="pav-msg-c-procedure"></div>').appendTo(container);
            timelineView.render(procedure, msg);

            var note = $('<div class="pav-msg-c-note"></div>').text('备注：' + msg.Note).appendTo(container);

            var buttons = $('<div class="pav-msg-c-btn"></div>').appendTo(container);
            var btn_respond = $('<a href="#" data-role="Respond"></a>').linkbutton({
                text: '可即刻转入PACU',
                onClick: function() {
                    if (callback) callback.call(this, msg);
                }
            }).appendTo(buttons);

            if (msg.CanRespond == 'N') btn_respond.hide();

            var btn_confirm = $('<a href="#" data-role="Confirm"></a>').linkbutton({
                text: '确认',
                onClick: function() {
                    if (callback) callback.call(this, msg);
                }
            }).appendTo(buttons);

            if (msg.CanConfirm == 'N') btn_confirm.hide();
        },
        refresh: function(container, msg) {
            var buttons = container.find('.pav-msg-c-btn');
            if (msg.Status == 'Responded') {
                var btn_respond = buttons.find('a[data-role="Respond"]');
                if (btn_respond.length > 0) btn_respond.linkbutton('disable');
            }
            if (msg.Status == 'Confirmed') {
                var btn_confirm = buttons.find('a[data-role="Confirm"]');
                if (btn_confirm.length > 0) btn_confirm.linkbutton('disable');
            }
        }
    };

    /**
     * 关键时间线
     */
    var timelineView = {
        render: function(container, msg) {
            var data = [];

            var datetime = msg.TheatreInDT;
            var date = datetime.slice(0, 10);
            var time = datetime.slice(11, 16);
            data.push({ title: '入手术间', date: date, time: time });
            var datetime = msg.AnaStartDT;
            var date = datetime.slice(0, 10);
            var time = datetime.slice(11, 16);
            data.push({ title: '麻醉开始', date: date, time: time });
            var datetime = msg.OperStartDT;
            var date = datetime.slice(0, 10);
            var time = datetime.slice(11, 16);
            data.push({ title: '手术开始', date: date, time: time });
            var datetime = msg.OperFinishDT;
            var date = datetime.slice(0, 10);
            var time = datetime.slice(11, 16);
            data.push({ title: '手术结束', date: date, time: time });
            var datetime = msg.TheatreOutDT;
            var date = datetime.slice(0, 10);
            var time = datetime.slice(11, 16);
            data.push({ title: '出手术间', date: date, time: time });

            var length = data.length;
            container.empty();

            var element, row;
            for (var i = 0; i < length; i++) {
                row = data[i];
                element = $('<span class="pav-msg-c-timeline"></span>').appendTo(container);
                if (i == 0) element.addClass('pav-msg-c-timeline-first');
                if (i == length - 1) element.addClass('pav-msg-c-timeline-last');
                if (row.date && row.time) element.addClass('pav-msg-c-timeline-completed');
                timeline.render(element, data[i]);
            }
        }
    };

    var timeline = {
        render: function(container, timeline) {
            container.text(timeline.title);
            container.append('<br/>');
            $('<span class="pav-msg-c-timeline-value"></span>')
                .attr('title', timeline.date + ' ' + timeline.time)
                .text(timeline.time)
                .appendTo(container);
            container.append('<br/>');
            $('<span class="pav-msg-c-timeline-spot"></span>')
                .appendTo(container);
        }
    }
}))