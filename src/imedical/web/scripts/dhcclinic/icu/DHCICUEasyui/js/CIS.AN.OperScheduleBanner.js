/**
 * 手术安排横幅
 * @author yongyang 2018-03-23
 */

(function(global, factory) {
    factory(global.operScheduleBanner = {});
}(this, function(exports) {

    function init(dom, opt) {
        return new OperScheduleBanner(dom, opt);
    }

    exports.init = init;

    function OperScheduleBanner(dom, opt) {
        this.dom = $(dom);
        this.options = $.extend(this.options || {}, opt);
        this.patientCodeOptionView = patientCodeOptionView;
        this.timelineView = timelineView;
        this.init();
    }

    OperScheduleBanner.prototype = {
        constructor: OperScheduleBanner,
        /**
         * 初始化
         */
        init: function() {
            var _this = this;
            this.dom.addClass('oper-banner');
            this.patientCodeOptionView.init(function(patientCode) {
                _this.changePaitenCode(patientCode);
            });
            this.timelineView.init();
        },
        /**
         * 设置参数
         */
        setOptions: function(opt) {
            this.options = $.extend(this.options || {}, opt);
            if (this.operSchedule) this.render();
        },
        /**
         * 加载数据
         */
        loadData: function(data) {
            this.operSchedule = data;
            this.render();
        },
        /**
         * 渲染
         */
        render: function() {
            var _this = this;
            this.dom.empty();
            var operSchedule = this.operSchedule;
            var avatar = $('<div class="oper-banner-avatar"></div>');
            if (operSchedule.PatGender === '女') {
                avatar.append('<span class="icon-large avatar-female"></span>');
            } else if (operSchedule.PatGender === '男') {
                avatar.append('<span class="icon-large avatar-male"></span>');
            } else {
                avatar.append('<span class="icon-large avatar-unknown"></span>');
            }

            var tagContainer = $('<div class="oper-banner-tag-container"></div>');

            tagContainer.append('<span class="oper-banner-tag oper-banner-tag-timeline"><span class="oper-banner-tag-timeline-title"></span><br/><span class="oper-banner-tag-timeline-value" title=""></span></span>');

            /*if (operSchedule.SourceType === 'E') {
                tagContainer.append('<span class="oper-banner-tag oper-banner-tag-emergency">急</span>');
            }*/

            var content = $('<div class="oper-banner-content"></div>');
            var contentArray = [];
            contentArray.push('<span class="oper-banner-patname">' + operSchedule.PatName + '</span>');
            contentArray.push('<span class="oper-banner-seperator"></span>');
            contentArray.push('<span class="oper-banner-info">' + operSchedule.PatGender + '</span>');
            contentArray.push('<span class="oper-banner-seperator"></span>');
            contentArray.push('<span class="oper-banner-info">' + operSchedule.PatAge + '</span>');
            contentArray.push('<span class="oper-banner-seperator"></span>');
            // if (operSchedule.PatCardID && operSchedule.PatCardID !== "") {
            //     contentArray.push('<span class="oper-banner-info">' + operSchedule.PatCardID + '</span>');
            //     contentArray.push('<span class="oper-banner-seperator"></span>');
            // }

            contentArray.push('<span class="oper-banner-info patient-code-container"><span class="patient-code" name="RegNo">登记号</span><span>' + operSchedule.RegNo + '</span></span>');
            // contentArray.push('<span class="oper-banner-info patient-code-container"><span class="patient-code" name="MedcareNo">住院号</span><span> ' + operSchedule.MedcareNo + '</span></span>');
            // contentArray.push('<span class="oper-banner-info patient-code-container"><span class="patient-code" name="PatCardID">身份证</span><span> ' + operSchedule.PatCardID + '</span></span>');
            if (operSchedule.WardBed) {
                contentArray.push('<span class="oper-banner-seperator"></span>');
                contentArray.push('<span class="oper-banner-info">' + operSchedule.WardBed + '</span>');
            }
            if (operSchedule.PrevAnaMethodDesc) {
                contentArray.push('<span class="oper-banner-seperator"></span>');
                contentArray.push('<span class="oper-banner-info">' + operSchedule.PrevAnaMethodDesc + '</span>');
            }
            if (operSchedule.OperDesc) {
                contentArray.push('<span class="oper-banner-seperator"></span>');
                contentArray.push('<span class="oper-banner-info" style="overflow:hidden" title="' + operSchedule.OperDesc + '">' + operSchedule.OperDesc + '</span>');
            }
            contentArray.push('<span class="oper-banner-seperator"></span>');
            contentArray.push('<span class="oper-banner-info">' + operSchedule.AdmReason + '</span>');
            if (operSchedule.ABO && operSchedule.ABO !== "") {
                var title = operSchedule.ABO.replace(/#/g, "&#10;");
                contentArray.push('<span title="' + title + '" style="margin-left:10px;color:#FF0033;font-weight:bold;font-size:14px;">' + title + '</span>');
            }
            if (operSchedule.RH && operSchedule.RH !== "") {
                var title = operSchedule.RH.replace(/#/g, "&#10;");
                contentArray.push('<span title="' + title + '" style="margin-left:5px;color:#FF0033;font-weight:bold;font-size:14px;">' + title + '</span>');
            }
            if (operSchedule.Infection && operSchedule.Infection.indexOf("阳性") >= 0) {
                var title = operSchedule.InfectionLabData.replace(/#/g, "&#10;");
                contentArray.push('<span title="' + title + '" style="margin-left:10px;color:#FF0033;font-weight:bold;font-size:14px;">感</span>');
            }
            if (operSchedule.Antibiotic && parseInt(operSchedule.Antibiotic) > 0) {
                contentArray.push('<span title="抗生素" style="margin-left:10px;color:#FF0033;font-weight:bold;font-size:14px;">抗</span>');
            }
            if (operSchedule.LongOperation === "Y") {
                contentArray.push('<span title="手术时长超过3小时" style="margin-left:10px;color:#FF0033;font-weight:bold;font-size:14px;">长</span>');
            }
            if (operSchedule.PathResult && operSchedule.PathResult !== "") {
                contentArray.push('<span title="' + operSchedule.PathResult + '" style="margin-left:10px;color:#FF0033;font-weight:bold;font-size:14px;">病</span>');
            }
            if (operSchedule.SourceType === 'E') {
                contentArray.push('<span style="margin-left:10px;margin-top:-4px;" class="oper-banner-tag oper-banner-tag-emergency">急</span>');
            }

            content.append(contentArray.join(''));

            this.dom.append(avatar);
            this.dom.append(content);
            this.dom.append(tagContainer);

            this.patientCodeContainer = this.dom.find('.patient-code-container');

            this.dom.delegate('.patient-code', 'mouseenter', function() {
                _this.patientCodeOptionView.position($(this).offset());
                _this.patientCodeOptionView.open();
            });

            this.dom.delegate('.oper-banner-tag-timeline', 'mouseenter', function() {
                _this.timelineView.position($(this).offset());
                _this.timelineView.open();
            });

            this.initButtons();
            this.refreshData();
            this.initTasks();
        },
        initButtons: function() {
            var container = this.dom.find('.oper-banner-tag-container');
            var buttons = this.options.buttons || [];
            var length = buttons.length;
            var element, button;
            for (var i = 0; i < length; i++) {
                button = buttons[i];
                element = $('<a href="javascript:;"></a>').appendTo(container);
                element.attr('id', button.id);
                element.addClass(button.class || '');
                element.linkbutton(button);
                if (button.hidden) element.hide();
            }
        },
        showButton: function(buttonId) {
            var container = this.dom.find('.oper-banner-tag-container');
            var element = container.find('a[id="' + buttonId + '"]');
			var buttons = this.options.buttons || [];
			var length = buttons.length;
			var button;
            for (var i = 0; i < length; i++) {
                button = buttons[i];
				if(button.id==buttonId)
					button.hidden=false;
            }
            element.show();
        },
        /**
         * 改变病人编码显示
         */
        changePaitenCode: function(patientCode) {
            this.patientCodeContainer.empty()
                .append('<span class="patient-code" name="' + patientCode.field + '">' + patientCode.desc + '</span>')
                .append('<span>' + (this.operSchedule[patientCode.field] || '') + '</span>');
        },
        /**
         * 更新数据
         */
        refreshData: function() {
            var _this = this;
            _this.lastRefreshTime = new Date();
            if (this.options.refresh) {
                this.options.refresh.call(this, this.operSchedule, function(data) {
                    _this.timelineView.loadData(data);
                    var currentTimeline = _this.timelineView.getCurrentTimeline();
                    _this.refreshTimeline(currentTimeline);
                });
            }
        },
        /**
         * 更新时间线
         */
        refreshTimeline: function(timeline) {
            if (timeline) {
                var timelineTag = this.dom.find('.oper-banner-tag-timeline');
                timelineTag.show();
                timelineTag.find('.oper-banner-tag-timeline-title').text(timeline.title);
                timelineTag.find('.oper-banner-tag-timeline-value')
                    .attr('title', timeline.date + ' ' + timeline.time)
                    .text(timeline.time);
            } else {
                this.dom.find('.oper-banner-tag-timeline').hide();
            }
        },
        /**
         * 设置定时刷新任务
         */
        initTasks: function() {
            var _this = this;
            setInterval(function() {
                if (new TimeSpan(new Date(), _this.lastRefreshTime).totalMinutes > 5)
                    _this.refreshData(); //界面距离上次刷新数据超过5分钟则自动刷新
            }, 60000); //每隔1分钟自动刷新界面
        }
    }

    /**
     * 病人编码选项选择界面
     */
    var patientCodeOptionView = {
        init: function(callback) {
            var _this = this;
            this.callback = callback;
            this.dom = $('<div class="oper-banner-patientcodeview"></div>').appendTo('body');
            this.dom.delegate('.oper-banner-patientcodeview-i', 'click', function() {
                $(this).siblings().removeClass('patientcodeview-selected');
                $(this).addClass('patientcodeview-selected');
                _this.callback({
                    field: $(this).attr('value'),
                    desc: $(this).text()
                });
                _this.close();
            });

            this.container = $('<div class="oper-banner-patientcodeview-container"></div>').appendTo(this.dom);
            $('<div class="oper-banner-patientcodeview-i patientcodeview-selected" value="MedcareNo">住院号</div>').appendTo(this.container);
            $('<div class="oper-banner-patientcodeview-i " value="RegNo">登记号</div>').appendTo(this.container);
            $('<div class="oper-banner-patientcodeview-i " value="RowId">手术号</div>').appendTo(this.container);
            //$('<div class="oper-banner-patientcodeview-i" value="CardNo">卡号</div>').appendTo(this.container);
            $('<div class="oper-banner-patientcodeview-i" value="EpisodeID">就诊号</div>').appendTo(this.container);
            $('<div class="oper-banner-patientcodeview-i" value="PatCardID">身份证</div>').appendTo(this.container);

            this.close();
            this.dom.mouseleave(function() {
                _this.close();
            });
            this.initiated = true;
        },
        render: function(currentSelection) {

        },
        position: function(position) {
            this.dom.css({ left: position.left - 10, top: position.top + 25 });
        },
        open: function() {
            this.dom.show();
        },
        close: function() {
            this.dom.hide();
        }
    };

    /**
     * 关键时间线
     */
    var timelineView = {
        init: function(callback) {
            var _this = this;
            this.callback = callback;
            this.dom = $('<div class="oper-banner-timelineview"></div>').appendTo('body');

            this.container = $('<div class="oper-banner-timelineview-container"></div>').appendTo(this.dom);

            this.close();
            this.dom.mouseleave(function() {
                _this.close();
            });
            this.initiated = true;
        },
        loadData: function(data) {
            this.data = data;
            this.render();
        },
        render: function() {
            var data = this.data;
            var length = data.length;
            var container = this.container;
            container.empty();

            var element, row;
            for (var i = 0; i < length; i++) {
                row = data[i];
                element = $('<span class="oper-banner-timeline"></span>').appendTo(container);
                if (i == 0) element.addClass('oper-banner-timeline-first');
                if (i == length - 1) element.addClass('oper-banner-timeline-last');
                if (row.date && row.time) element.addClass('oper-banner-timeline-completed');
                timeline.render(element, data[i]);
            }
        },
        getCurrentTimeline: function() {
            var currentTimeline = null;
            var data = this.data;
            var length = data.length;

            var row;
            for (var i = length - 1; i >= 0; i--) {
                row = data[i];
                if (row.time) {
                    currentTimeline = row;
                    break;
                }
            }

            return currentTimeline;
        },
        reload: function() {

        },
        position: function(position) {
            this.dom.css({ left: position.left - 100, top: position.top + 25 });
        },
        open: function() {
            this.dom.show();
        },
        close: function() {
            this.dom.hide();
        }
    };

    var timeline = {
        render: function(container, timeline) {
            container.text(timeline.title);
            container.append('<br/>');
            $('<span class="oper-banner-timeline-value"></span>')
                .attr('title', timeline.date + ' ' + timeline.time)
                .text(timeline.time)
                .appendTo(container);
            container.append('<br/>');
            $('<span class="oper-banner-timeline-spot"></span>')
                .appendTo(container);
        }
    }
}));