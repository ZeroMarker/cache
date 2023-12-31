//20210802
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
            var avatar = $('<div class="oper-banner-avatar" style="left:0px;top:0px;"></div>');
            if (operSchedule.PatGender === '女') {
                avatar.append('<span class="icon-large avatar-female"></span>');
            } else if (operSchedule.PatGender === '男') {
                avatar.append('<span class="icon-large avatar-male"></span>');
            } else {
                avatar.append('<span class="icon-large avatar-unknown"></span>');
            }

            var tagContainer = $('<div class="oper-banner-tag-container"></div>');
            if (operSchedule.SourceType === 'E') {
                tagContainer.append('<span class="oper-banner-tag oper-banner-tag-emergency">急</span>');
            }
            //tagContainer.append('<span id="operlist-container"><a id="btnOperList" href="#" class="hisui-linkbutton" style="background: #21BA45;">手术列表</a></span>');

            var content = $('<div class="oper-banner-content" style="padding-left:35px;padding-top:5px"></div>');
            var contentArray = [];
            contentArray.push('<span class="oper-banner-patname">' + operSchedule.PatName + '</span>');
            contentArray.push('<span class="oper-banner-seperator"></span>');
            contentArray.push('<span class="oper-banner-info">' + operSchedule.PatGender + '</span>');
            contentArray.push('<span class="oper-banner-seperator"></span>');
            contentArray.push('<span class="oper-banner-info">' + operSchedule.PatAge + '</span>');
            contentArray.push('<span class="oper-banner-seperator"></span>');
            if (operSchedule.PatCardID && operSchedule.PatCardID !== "") {
                contentArray.push('<span class="oper-banner-info">' + operSchedule.PatCardID + '</span>');
                contentArray.push('<span class="oper-banner-seperator"></span>');
            }

            // contentArray.push('<span class="oper-banner-info patient-code-container"><span class="patient-code" name="RegNo">登记号</span><span>' + operSchedule.RegNo + '</span></span>');
            contentArray.push('<span class="oper-banner-info patient-code-container"><span name="RegNo">住院号 </span><span> ' + operSchedule.MedcareNo + '</span></span>');
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


            content.append(contentArray.join(''));

            this.dom.append(avatar);
            this.dom.append(content);
            this.dom.append(tagContainer);

            this.patientCodeContainer = this.dom.find('.patient-code-container');

            this.dom.delegate('.patient-code', 'mouseenter', function() {
                _this.patientCodeOptionView.position($(this).offset());
                _this.patientCodeOptionView.open();
            })
        },
        /**
         * 改变病人编码显示
         */
        changePaitenCode: function(patientCode) {
            this.patientCodeContainer.empty()
                .append('<span class="patient-code" name="' + patientCode.field + '">' + patientCode.desc + '</span>')
                .append('<span>' + (this.operSchedule[patientCode.field] || '') + '</span>');
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
            $('<div class="oper-banner-patientcodeview-i" value="CardNo">卡号</div>').appendTo(this.container);
            $('<div class="oper-banner-patientcodeview-i" value="EpisodeID">就诊号</div>').appendTo(this.container);

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
}));