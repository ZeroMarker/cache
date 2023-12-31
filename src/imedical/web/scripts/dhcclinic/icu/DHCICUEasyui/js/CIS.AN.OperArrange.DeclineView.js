/**
 * @author yongyang
 * @description 手术排班视图 拒绝手术视图：拒绝手术原因对话框、拒绝手术列表
 */
(function(global, factory) {
    factory((global.DeclineView = {}));
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
    function init(opt) {
        _id++;
        var view = new DeclineView(opt);
        exports.instance = view;
        return view;
    }

    exports.init = init;

    var defaultOptions = {
        fit: true,
        width: 'auto',
        height: 430,
        singleSelection: true
    }

    /**
     * @description DeclineView构造函数
     * @author yongyang 2018-03-06
     * @module DeclineView
     * @constructor
     * @param {HTMLElement} dom 
     * @param {object} opt 
     */
    function DeclineView(opt) {
        /**
         * @property {Array} 拒绝手术列表数据
         */
        this.bindedData = [];

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
    DeclineView.prototype = {
        _init: function() {
            this.initListDialog();
            this.initReasonDialog();
            this.initEventHandler();
        },
        /**
         * 初始化列表对话框
         */
        initListDialog: function() {
            var _this = this;
            this.listDialog = $('<div class="hisui-datagrid" style="padding:10px;border-color:#ECECEC"></div>').appendTo('body');

            this.datagrid = $('<table style="border-color:#ECECEC"></table>').appendTo(this.listDialog);

            this.listDialog.dialog({
                modal: true,
                title: '已拒绝手术列表',
                closed: true,
                width: 680,
                height: 400,
                headerCls: 'panel-header-gray',
                iconCls: 'icon-w-paper',
                onOpen: function() {
                    _this.reload();
                },
                onClose: function() {}
            });

            var buttons = $('<div></div>');
            var revokeDeclineBtn = $('<a href="#"></a>').linkbutton({
                text: '撤销拒绝',
                plain: true,
                iconCls: 'icon-cancel',
                onClick: function() {
                    if (_this.options.onRevokeHandler) {
                        var selectedRows = _this.datagrid.datagrid("getSelections");
                        _this.options.onRevokeHandler.call(_this, selectedRows);
						_this.datagrid.datagrid("clearSelections");
                    }
                }
            }).appendTo(buttons);

            this.datagrid.datagrid({
                idField: "RowId",
                fit: true,
                rownumbers: true,
				headerCls:'panel-header-gray',
                sortName: "AppDeptAlias,SurgeonShortDesc,OperTime",
                sortOrder: "asc,asc,asc",
                remoteSort: false,
                multiSort: true,
                checkbox: true,
                checkOnSelect: true,
				bodyCls: 'panel-header-gray',
                selectOnCheck: true,
                // nowrap: false,
                toolbar: buttons,
                columns: [
                    [{
                            field: "CheckStatus",
                            title: "勾选",
                            checkbox: true
                        },
                        {
                            field: "OperTime",
                            title: "手术时间",
                            width: 80
                        },
                        {
                            field: "AppDeptDesc",
                            title: "申请科室",
                            width: 100
                        },
                        {
                            field: "AppDeptAlias",
                            title: "科室别名",
                            width: 100,
                            hidden: true
                        },
                        {
                            field: "Patient",
                            title: "患者",
                            width: 120
                        },
                        {
                            field: "WardBed",
                            title: "病区床位",
                            width: 120,
                            hidden: true
                        },

                        {
                            field: "OperDeptDesc",
                            title: "手术室",
                            width: 100,
                            hidden: true
                        },
                        {
                            field: "PlanOperDesc",
                            title: "手术名称",
                            width: 160
                        },
                        {
                            field: "SurgeonDesc",
                            title: "手术医生",
                            width: 80
                        },
                        {
                            field: "SurgeonShortDesc",
                            title: "医生别名",
                            width: 80,
                            hidden: true
                        },
                        {
                            field: "PrevDiagnosisDesc",
                            title: "术前诊断",
                            width: 100
                        },
                        {
                            field: "BodySiteDesc",
                            title: "手术部位",
                            width: 60
                        },
                        {
                            field: "AssistantDesc",
                            title: "手术助手",
                            width: 100,
                            hidden: true
                        },
                        {
                            field: "SurCareProv",
                            title: "手术医护",
                            width: 120
                        },
                        {
                            field: "SpecialConditions",
                            title: "特殊情况",
                            width: 120
                        },

                        {
                            field: "AnaCareProv",
                            title: "麻醉医护",
                            width: 120,
                            hidden: true
                        },
                        {
                            field: "AdmReason",
                            title: "费别",
                            width: 100
                        },
                        {
                            field: "MedcareNo",
                            title: "住院号",
                            width: 80
                        },
                        {
                            field: "EpisodeID",
                            title: "就诊ID",
                            width: 80
                        },
                        {
                            field: "RowId",
                            title: "手术ID",
                            width: 80
                        },
                        {
                            field: "SourceTypeDesc",
                            title: "类型",
                            width: 60,
                            hidden: true
                        },
                        {
                            field: "OperStatusDesc",
                            title: "手术状态",
                            width: 80,
                            hidden: true
                        }
                    ]
                ],
                rowStyler: function(index,row) {
                    //return "background-color:" + row.StatusColor + ";";
                },
                onLoadSuccess: function(data) {},
                onSelect: function(index, row) {},
                onUnSelect: function(index, row) {}
            });
        },
        /**
         * 初始化原因录入对话框
         */
        initReasonDialog: function() {
            var _this = this;
            var options = this.options;
            var buttons = $('<div id-"2323231" style="padding-top:0px"></div>');
            var saveBtn = $('<a href="#"></a>').linkbutton({
                text: '保存',
                iconCls: 'icon-w-save',
                onClick: function() {
                    _this.setCancelReason();
                    if (_this.validate()) {
                        var decliningOperList = _this.getDecliningOperList();
                        if (_this.options.onDeclineHandler) {
                            var re=_this.options.onDeclineHandler.call(this, decliningOperList);
                        }
						//判断拒绝手术的返回值
						if(re)
						{
							if (_this.options.onAfterDecline) {
								_this.options.onAfterDecline.call(this, decliningOperList);
							}
						}
                    } else {
                        $.messager.alert('拒绝手术', '待拒绝手术<b style="color:red;">未填写拒绝原因</b>，请填写后再保存！', 'warning');
                    }
                }
            }).appendTo(buttons);
            var closeBtn = $('<a href="#"></a>').linkbutton({
                text: '取消',
                iconCls: 'icon-w-cancel',
                onClick: function() {
                    _this.closeReasonDialog();
                }
            }).appendTo(buttons);

            this.reasonDialog = $('<div style="padding:0px;"></div>').appendTo('body');
            this.decliningListContainer = $('<div class="canceloper-declining-container" style="padding-left:5px;display:none"></div>').appendTo(this.reasonDialog);
            this.reasonForm = $('<form style="padding:0px;"></form>').appendTo(this.reasonDialog);
            this.decliningButtonContainer = $('<div style="text-align:center;"></div>').appendTo(this.reasonDialog);
            this.reasonDialog.dialog({
                modal: true,
                title: '拒绝手术原因',
                closed: true,
                width: 320,
                height: 370,
                buttons: buttons,
                headerCls: 'panel-header-gray',
                iconCls: 'icon-w-paper',
                onOpen: function() {

                },
                onClose: function() {
                    _this.decliningOperList = [];
                    _this.clear();
                }
            });

            this.initReasonForm();
            this.initDecliningButtons();
        },
        /**
         * 初始化原因录入表单
         */
        initReasonForm: function() {
            var _this = this;
            var form = this.reasonForm;

            $('<input type="hidden" name="RowId">').appendTo(form);

            var row = $('<div class="editview-f-r editview-pat-info" style="padding-top:10px"></div>').appendTo(form);

            var row = $('<div class="editview-f-r" style="margin-left:0px"></div>').appendTo(form);
            var label = $('<label class="label" for="canceloper_f_reason_s" style="margin-left:6px">原因选择</label>').appendTo(row);
            this.ReasonSelection = $('<input id="canceloper_f_reason_s" name="ReasonOptions">').appendTo(row);
            this.ReasonSelection.combobox({
                width: 220,
                valueField: 'RowId',
                textField: 'Description',
                url: ANCSP.DataQuery,
                onBeforeLoad: function(param) {
                    param.ClassName = ANCLS.BLL.CodeQueries;
                    param.QueryName = "FindReason";
                    param.Arg1 = "D";
                    param.ArgCnt = 1;
                },
                onChange: function(newValue, oldValue) {
                    var reasonDesc = _this.CancelReason.val(),
                        optionValue = $(this).combobox("getValue"),
                        optionData = $(this).combobox("getData");
                    if (!optionValue || optionValue == "") return;
                    if (!optionData || optionData.length <= 0) return;
                    var currentOption = "";
                    for (var i = 0; i < optionData.length; i++) {
                        var option = optionData[i];
                        if (option.RowId == optionValue) {
                            currentOption = option.Description;
                        }
                    }
                    if (currentOption == "") return;
                    if ($.trim(reasonDesc) != "") {
                        reasonDesc += "；";
                    }
                    reasonDesc += currentOption;
                    _this.CancelReason.val(reasonDesc);
                    $(this).combobox("clear", "");
                    $(this).combobox("setText", "");
                }
            });

            var row = $('<div class="editview-f-r" style="margin-bottom:0px;margin-left:0px"></div>').appendTo(form);
            var label = $('<label class="label" for="canceloper_f_reason_d" style="margin-left:6px">原因描述</label>').appendTo(row);
            this.CancelReason = $('<textarea id="canceloper_f_reason_d" name="CancelReason" style="width:214px;height:178px;padding-bottom:0px;border-radius:4px" required></textarea>').appendTo(row);

            form.form({});
        },
        /**
         * 初始化事件
         */
        initDecliningButtons: function() {
            var container = this.decliningButtonContainer;
            //var element = $('<span class="canceloper-declining-btn canceloper-declining-previous canceloper-declining-disabled">上一条</span>').appendTo(container);
            //var element = $('<span class="canceloper-declining-btn canceloper-declining-next">下一条</span>').appendTo(container);
        },
        /**
         * 初始化事件处理方法
         */
        initEventHandler: function() {
            var _this = this;
            this.decliningButtonContainer.delegate('.canceloper-declining-previous:not(.canceloper-declining-disabled)', 'click', function() {
                _this.setCancelReason();
                _this.previousDecliningItem();
            });
            this.decliningButtonContainer.delegate('.canceloper-declining-next:not(.canceloper-declining-disabled)', 'click', function() {
                _this.setCancelReason();
                _this.nextDecliningItem();
            });
            this.decliningListContainer.delegate('.canceloper-declining-i:not(.canceloper-declining-i-selected)', 'click', function() {
                _this.setCancelReason();
                _this.selectDecliningItem($(this).data('data'));
            });
        },
        /**
         * 加载待拒绝手术数据，处理拒绝过程
         */
        proceedDecline: function(data) {
            this.decliningOperList = data || [];
            this.renderDecliningList();
            this.selectDecliningItem(0);
        },
        renderDecliningList: function() {
            var data = this.decliningOperList;
            var container = this.decliningListContainer;
            container.empty();

            var element, operSchedule;
            for (var i = 0, length = data.length; i < length; i++) {
                operSchedule = data[i];
                element = $('<span class="canceloper-declining-i"></span>').appendTo(container);
                element.append('<span class="" style="display:inline-block;position:relative;padding-left:6px;font-weight:bold;font-size:14px;">' + operSchedule.PatName +
                    '<i class="' + (operSchedule.PatGender === '女' ? 'female fa fa-female' : 'male fa fa-male') + '" style="display:inline-block;position:absolute;top:3px;left:-5px;"></i></span>');

                element.data('data', operSchedule);
            }
        },
        /**
         * 选择一条待拒绝手术
         * @param {*} index 
         */
        selectDecliningItem: function(index) {
            var container = this.decliningListContainer;
            var element, operSchedule;
            if (typeof index == 'number') {
                element = $(container.find('.canceloper-declining-i')[index]);
                operSchedule = element.data('data');
            } else if (typeof index == 'object') {
                operSchedule = index;
                index = this.decliningOperList.indexOf(operSchedule);
                element = $(container.find('.canceloper-declining-i')[index]);
            }

            container.find('.canceloper-declining-i-selected').removeClass('canceloper-declining-i-selected');
            element.addClass('canceloper-declining-i-selected');
            this.renderOperSchedule(operSchedule);

            var btnContainer = this.decliningButtonContainer;
            if (index < 1) btnContainer.find('.canceloper-declining-previous').addClass('canceloper-declining-disabled');
            else btnContainer.find('.canceloper-declining-previous').removeClass('canceloper-declining-disabled');
            if (index > this.decliningOperList.length - 2) btnContainer.find('.canceloper-declining-next').addClass('canceloper-declining-disabled');
            else btnContainer.find('.canceloper-declining-next').removeClass('canceloper-declining-disabled');
        },
        /**
         * 上一条
         */
        previousDecliningItem: function() {
            var container = this.decliningListContainer;
            var element = container.find('.canceloper-declining-i-selected');
            var operSchedule = element.data('data');
            var index = this.decliningOperList.indexOf(operSchedule);
            this.selectDecliningItem(index - 1);
        },
        /**
         * 下一条
         */
        nextDecliningItem: function() {
            var container = this.decliningListContainer;
            var element = container.find('.canceloper-declining-i-selected');
            var operSchedule = element.data('data');
            var index = this.decliningOperList.indexOf(operSchedule);
            this.selectDecliningItem(index + 1);
        },
        /**
         * 设置当前手术的拒绝原因
         */
        setCancelReason: function() {
            var container = this.decliningListContainer;
            var element = container.find('.canceloper-declining-i-selected');
            var operSchedule = element.data('data');
            var cancelReason = this.CancelReason.val();

            operSchedule.CancelReason = cancelReason;
            if (cancelReason) element.addClass('canceloper-declining-i-prepared');
            else element.removeClass('canceloper-declining-i-prepared');
        },
        /**
         * 获取待拒绝手术数据
         */
        getDecliningOperList: function() {
            var decliningOperList = this.decliningOperList;
            var result = [];
            for (var i = 0, length = decliningOperList.length; i < length; i++) {
                if (decliningOperList[i].CancelReason) result.push(decliningOperList[i]);
            }
            return result;
        },
        /**
         * 保存前校验
         */
        validate: function() {
            var decliningOperList = this.decliningOperList;
            var result = true;
            for (var i = 0, length = decliningOperList.length; i < length; i++) {
                if (!decliningOperList[i].CancelReason) return false;
            }
            return result;
        },
        /**
         * 渲染待拒绝手术
         */
        renderOperSchedule: function(operSchedule) {
            if (operSchedule) {
                this.clear();
                var form = this.reasonForm;
                form.find('input[name="RowId"]').val(operSchedule.RowId);
                this.CancelReason.val(operSchedule.CancelReason);

                var content = form.children('.editview-pat-info');
                content.empty();
                $('<span style="padding-left:9px"></span>').text(operSchedule.PatDeptDesc).appendTo(content);
                $('<span style="font-weight:bold;"></span>').text(operSchedule.PatName).appendTo(content);
                $('<span></span>').text(operSchedule.PatGender).appendTo(content);
                $('<span></span>').text(operSchedule.PatAge).appendTo(content);
                $('<span></span>').text(operSchedule.RegNo).appendTo(content);

                this.renderTooltip(content, operSchedule);
            } else {
                return false;
            }
        },
        /**
         * 渲染tooltip
         * @param {*} container 
         * @param {*} operSchedule 
         */
        renderTooltip: function(container, operSchedule) {
            var contentArray = [];
            contentArray.push('<span style="font-size:9px;">' + operSchedule.PatDeptDesc);
            contentArray.push(operSchedule.WardBed);

            var SourceType = '';
            if (operSchedule.SourceType === 'E') {
                SourceType = '急诊手术';
            } else if (operSchedule.SourceType === 'B') {
                SourceType = '择期手术';
            } else if (operSchedule.DaySurgery === 'Y') {
                SourceType = '日间手术';
            }
            contentArray.push('<span style="margin-right:5px;padding:0 5px;font-size:9px;border:1px solid #fff;border-radius:10px;">' + decodeAdmType(operSchedule.AdmType) + '</span><b>' + operSchedule.PatName + '</b> (' + operSchedule.PatGender + ' ' + operSchedule.PatAge + ')' + '<span style="margin-left:5px;font-size:9px;border:1px solid #fff;">' + SourceType + '</span>');

            contentArray.push('登记号：' + operSchedule.RegNo + '<span style="margin-left:5px;font-size:9px;">住院号：' + operSchedule.MedcareNo + '</span>');
            contentArray.push('手术日期：' + operSchedule.OperDate);
            contentArray.push('手术时间：' + operSchedule.OperTime + '<span style="margin-left:5px;font-size:9px;">预计持续时间：' + (operSchedule.OperDuration ? operSchedule.OperDuration + 'h' : '') + '</span>');
            contentArray.push('手术名称：' + operSchedule.OperDesc);
            if (operSchedule.OperEnglishName) contentArray.push(operSchedule.OperEnglishName);
            contentArray.push('麻醉方法：' + operSchedule.AnaMethodDesc);

            contentArray.push('主刀医生1：' + operSchedule.SurgeonDesc + '<span style="margin-left:5px;font-size:9px;">专业：' + (operSchedule.Major || '') + '</span></span>');
            var match = /\d+/.exec(operSchedule.PatAge);
            var age = match ? Number(match[0]) : 30;
            if (age > 70) contentArray.push('<span style="font-size:9px;border:1px solid #fff;">年龄大于70岁</span>');
            if (age < 3) contentArray.push('<span style="font-size:9px;border:1px solid #fff;">年龄小于3岁</span>');

            var tagArray = [];
            if ((operSchedule.OperDuration && Number(operSchedule.OperDuration) > 4)) {
                tagArray.push('<span style="color:#A164F3;margin-right:5px;font-size:9px;">大于4小时</span>');
            }
            if (/IMC/.test(operSchedule.PatWardDesc)) {
                tagArray.push('<span style="color:#6798E9;margin-right:5px;font-size:9px;">IMC病区</span>');
            }
            if (operSchedule.MechanicalArm === 'Y') {
                tagArray.push('<span style="color:#EC808D;margin-right:5px;font-size:9px;">X-ray</span>');
            }
            if (operSchedule.IsoOperation === 'Y') {
                tagArray.push('<span style="color:#008080;margin-right:5px;font-size:9px;">隔离</span>');
            }
            if (operSchedule.InfectionOper) {
                tagArray.push('<span style="color:#D9001B;margin-right:5px;font-size:9px;">感染</span>');
            }
            if (operSchedule.MDROS === 'Y') {
                tagArray.push('<span style="color:#FC522C;margin-right:5px;font-size:9px;">多重耐药</span>');
            }
            if (operSchedule.Profrozen === 'Y') {
                tagArray.push('<span style="color:#81D3F8;margin-right:5px;font-size:9px;">冰冻</span>');
            }
            if (operSchedule.SpecialConditions) {
                tagArray.push('<span style="white-space:normal;color:#420080;text-align:left;margin-right:5px;font-size:9px;">' + (operSchedule.SpecialConditions || '检查前3小时内禁食禁饮，需要备血，尖头电刀，强生缝合器') + '</span>');
            }
            contentArray.push('<span style="display:inline-block;max-width:300px;">' + tagArray.join('') + '</span>');
            var title = contentArray.join('<br/>');
            container.tooltip({
                content: title
            });

            function decodeAdmType(admType) {
                switch (admType) {
                    case 'I':
                        return '住院病人';
                    case 'O':
                        return '门诊病人';
                    case 'E':
                        return '急诊病人';
                    default:
                        return admType;
                }
            }
        },
        /**
         * 加载已拒绝手术数据
         */
        loadData: function(data) {
            this.bindedData = data;
            this.render();
        },
        /**
         * 重新加载列表数据
         */
        reload: function() {
            if (this.options.onLoad) this.options.onLoad.call(this);
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
            this.datagrid.datagrid('loadData', this.bindedData);
        },
        /**
         * 关闭视图
         */
        close: function() {
            this.closeReasonDialog();
            this.closeListDialog();
        },
        /**
         * 打开对话框
         */
        openReasonDialog: function() {
            this.reasonDialog.dialog('open');
        },
        /**
         * 关闭对话框
         */
        closeReasonDialog: function() {
            this.reasonDialog.dialog('close');
        },
        /**
         * 打开对话框
         */
        openListDialog: function() {
            this.listDialog.dialog('open');
        },
        /**
         * 关闭对话框
         */
        closeListDialog: function() {
            this.listDialog.dialog('close');
        },
        /**
         * 清空表单数据
         */
        clear: function() {
            var form = this.reasonForm;
            form.form('clear');
            this.CancelReason.val('');
            var patInfoRow = form.children('.editview-pat-info');
            patInfoRow.tooltip({
                content: ''
            });
        },
        refresh: function() {
            if (this.options.callback) this.options.callback.call(this);
        }
    };
})));