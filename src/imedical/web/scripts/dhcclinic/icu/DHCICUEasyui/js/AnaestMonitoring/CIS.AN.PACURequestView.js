/**
 * PACU准入申请
 * @author yongyang 20200701
 */
(function(global, factory) {
    if (!global.PACURequestView) factory(global.PACURequestView = {});
}(this, function(exports) {

    exports.init = function(opt) {
        var view = new PACURequestView(opt);
        exports.instance = view;
        return view;
    }

    exports.instance = null;

    function PACURequestView(opt) {
        this.options = $.extend({ width: 540, height: 241 }, opt);
        this.saveHandler = opt.saveHandler;
        this.init();
    }

    PACURequestView.prototype = {
        init: function() {
            var _this = this;
            this.initiateStatus = {};
            this.dom = $('<div></div>').appendTo('body');
            var buttons = $('<div></div>');
            this.btn_save = $('<a href="#"></a>').linkbutton({
                text: '申请',
                iconCls: 'icon-w-save',
                onClick: function() {
                    _this.save();
                }
            }).appendTo(buttons);
            var btn_cancel = $('<a href="#"></a>').linkbutton({
                text: '关闭',
                iconCls: 'icon-w-cancel',
                onClick: function() {
                    _this.close();
                }
            }).appendTo(buttons);

            this.initPACUBedList();
            this.initForm();

            this.dom.dialog({
                left: 365,
                top: 198,
                height: this.options.height,
                width: this.options.width,
                title: 'PACU准入申请',
				iconCls: 'icon-w-msg',
                modal: true,
                closed: true,
                buttons: buttons,
                onOpen: function() {
                    _this.setTimer();
                },
                onClose: function() {
                    _this.clear();
                }
            });
        },
        initForm: function() {
            var _this = this;
            var container = $('<div></div>').appendTo(this.dom);
            this.form = $('<form class="editview-form"></form>').appendTo(container);
            this.form.form({});
            this.RowId = $('<input type="hidden" name="RowId">').appendTo(this.form);
            var row = $('<div class="editview-f-r editview-pat-info"></div>').appendTo(this.form);
            patinfo.render(row, this.options.schedule);

            var row = $('<div class="editview-f-rhisui" style="margin-bottom:0px"></div>').appendTo(this.form);
            var label = $('<div class="label" style="width:28px;">备注</div>').appendTo(row);
            this.Note = $('<input class="textbox">').appendTo(row);
            this.Note.validatebox({
                width: 180,
                label: label
            });
        },
        initPACUBedList: function() {
            var _this = this;
            var container = $('<div class="prv-bed-list"></div>').appendTo(this.dom);
            this.bedlist = container;

            this.loadPACUBeds(this.options.pacuBeds || []);
        },
        loadData: function(data) {
            var data = data;
            this.loadPACUBeds(data);
        },
        loadPACUBeds: function(data) {
            this.pacuBeds = data;
            var container = this.bedlist;
            container.empty();

            var length = data.length;
            var element;
            for (var i = 0; i < length; i++) {
                element = $('<div class="prv-bed prv-bed-empty"></div>').appendTo(container);
                bedview.render(element, data[i]);
            }

            this.bedlist.height(Math.ceil(length / 6) * 82);

            if (data.length > 0) {
                if (!this.initiateStatus.bed) {
                    this.refreshPACUBedStatus(this.currentBeds || []);
                }
                this.initiateStatus.bed = true;
            }
        },
        refreshPACUBedStatus: function(currentBeds) {
            this.currentBeds = currentBeds;
            var data = this.pacuBeds;
            if (!data) {
                this.initiateStatus.bed = false;
                return;
            }
            var dictionary = {};
            var length = data.length;
            for (var i = 0; i < length; i++) {
                dictionary[data[i].RowId] = data[i];
            }

            var data = currentBeds;
            var length = data.length;
            var element;
            for (var i = 0; i < length; i++) {
                element = (dictionary[data[i].RowId] || {}).target;
                if (element) bedview.refresh(element, data[i]);
            }
        },
        refreshPACUAdmission: function(data) {
            var status = '未申请';
            if (data.RowId) {
                this.btn_save.linkbutton('disable');
                this.btn_save.find('.l-btn-text').text('已申请');
                this.btn_save.attr('title', '申请人：' + data.RequestUser + '<br/>' +
                    '申请时间：' + data.RequestDT + '<br/>' +
                    '阅读人：' + (data.ReadUser || '') + '<br/>' +
                    '阅读时间：' + (data.ReadDT || '') + '<br/>' +
                    '处理意见：' + data.StatusComment
                );
                this.btn_save.tooltip({});
                this.Note.val(data.Note || '');
                this.Note.attr('disabled', true);
                status = data.StatusComment || '等待中:';
            }

            this.form.find('.editview-pat-info .waiting-status').text(status);
            this.form.find('.editview-pat-info .waiting-seq').text(data.WaitingSeq || '');
        },
        refresh: function() {
            if (this.options.refreshHandler) this.options.refreshHandler();
        },
        setTimer: function() {
            var _this = this;
            this.refreshTimer = setInterval(function() {
                _this.refresh();
            }, 300000);

            this.durationTimer = setInterval(function() {
                var elements = _this.bedlist.find('.prv-bed');
                if (elements.length > 0) {
                    var length = elements.length;
                    var element;
                    for (var i = 0; i < length; i++) {
                        element = $(elements[i]);
                        bedview.refreshTime(element);
                    }
                }
            }, 1000);
        },
        open: function() {
            this.dom.dialog('open');
        },
        close: function() {
            this.dom.dialog('close');
            this.originalData = null;
        },
        clear: function() {
            this.form.form('clear');
            this.originalData = null;

            clearInterval(this.durationTimer);
            this.durationTimer = null;
            clearInterval(this.bedStatusTimer);
            this.bedStatusTimer = null;
        },
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
            return {
                OperSchedule: this.options.schedule.RowId,
                RequestDept: session.DeptID,
                RequestGroup: session.GroupID,
                Note: this.Note.val()
            };
        }
    }

    var patinfo = {
        render: function(container, operSchedule) {
            container.empty();
            $('<div class="editview-pat-label">当前</div>').appendTo(container);
            $('<div class="editview-pat-msg"><span class="waiting-status">未申请</span><span class="waiting-seq"></span></div>').appendTo(container);
            $('<span></span>').text(operSchedule.PatDeptDesc).appendTo(container);
            $('<span style="font-weight:bold;"></span>').text(operSchedule.PatName).appendTo(container);
            $('<span></span>').text(operSchedule.PatGender).appendTo(container);
            $('<span></span>').text(operSchedule.PatAge).appendTo(container);
            $('<span></span>').text(operSchedule.RegNo).appendTo(container);

            var title = [operSchedule.PatDeptDesc,
                operSchedule.PatWardDesc + ' ' + operSchedule.PatBedCode,
                '<b>' + operSchedule.PatName + '</b> ' + operSchedule.PatGender + ' ' + operSchedule.PatAge,
                operSchedule.RegNo,
                operSchedule.PrevDiagnosisDesc || '',
                operSchedule.PlanOperDesc || '',
                operSchedule.SurgeonDesc || ''
            ].join('<br/>');
            container.attr('title', title);
            container.tooltip({});
        }
    }

    var bedview = {
        render: function(container, bed) {
            container.data('data', bed);
            container.attr('data-rowid', bed.RowId);
            bed.target = container;

            var header = $('<div class="prv-bed-header"></div>').appendTo(container);
            var content = $('<div class="prv-bed-content"></div>').appendTo(container);

            $('<span></span>').text(bed.Description).appendTo(header);
        },
        refresh: function(container, currentBedStatus) {
            if (currentBedStatus.Available) {
                container.addClass('prv-bed-empty');
                container.data('start', null);
                var content = container.find('.prv-bed-content');
                content.empty();
                content.append('空闲');
            } else {
                container.removeClass('prv-bed-empty');
                var content = container.find('.prv-bed-content');
                content.empty();

                $('<div class="prv-bed-patinfo"></div>').text(currentBedStatus.CurrentPat).appendTo(content);

                var startDT = new Date().tryParse(currentBedStatus.StartDT);
                var totalSeconds = Math.floor(new TimeSpan(new Date(), startDT).totalSeconds);
                var hours = Math.floor(totalSeconds / 3600);
                var seconds = totalSeconds % 3600;
                var minutes = Math.floor(seconds / 60);
                seconds = seconds % 60;
                var duration = (hours > 9 ? hours : '0' + hours) + ":" +
                    (minutes > 9 ? minutes : '0' + minutes) + ":" +
                    (seconds > 9 ? seconds : '0' + seconds);

                $('<div class="prv-bed-duration"></div>').text(duration).appendTo(content);
                container.data('start', startDT);
            }
        },
        refreshTime: function(container) {
            var startDT = container.data('start');
            if (startDT) {
                var totalSeconds = Math.floor(new TimeSpan(new Date(), startDT).totalSeconds);
                var hours = Math.floor(totalSeconds / 3600);
                var seconds = totalSeconds % 3600;
                var minutes = Math.floor(seconds / 60);
                seconds = seconds % 60;
                var duration = (hours > 9 ? hours : '0' + hours) + ":" +
                    (minutes > 9 ? minutes : '0' + minutes) + ":" +
                    (seconds > 9 ? seconds : '0' + seconds);

                container.find('.prv-bed-duration').text(duration);
            }
        }
    }
}))