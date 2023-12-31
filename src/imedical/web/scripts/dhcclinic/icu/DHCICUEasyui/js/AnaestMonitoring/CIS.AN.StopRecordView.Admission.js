/**
 * 结束监护弹出框
 * @author yongyang 20180509
 */

(function(global, factory) {
    if (!global.StopRecordView) factory(global.StopRecordView = {});
}(this, function(exports) {

    exports.init = function(opts) {
        var view = new StopRecordView(opts);
        exports.instance = view;
        return view;
    }

    function StopRecordView(opts) {
        this.saveHandler = opts.saveHandler;
        this.options = $.extend({ width: 380, height: 390 }, opts);
        this.requestPACUHandler = opts.requestPACUHandler;
        this.init();
    }

    StopRecordView.prototype = {
        init: function() {
            var _this = this;
            this.dom = $('<div></div>').appendTo('body');
            var buttons = $('<div></div>');
            _this.btn_save = $('<a href="#"></a>').linkbutton({
                text: '保存',
                iconCls: 'icon-save',
                onClick: function() {
                    _this.save();
                }
            }).appendTo(buttons);
            var btn_cancel = $('<a href="#"></a>').linkbutton({
                text: '取消',
                iconCls: 'icon-cancel',
                onClick: function() {
                    _this.close();
                }
            }).appendTo(buttons);

            this.initForm();

            this.dom.dialog({
                left: 300,
                top: 70,
                height: this.options.height,
                width: this.options.width,
                title: '结束监护',
                modal: true,
                closed: true,
                buttons: buttons,
                onOpen: function() {
                    _this.default();
                },
                onClose: function() {
                    _this.clear();
                }
            });
        },
        initForm: function() {
            var _this = this;
            this.form = $('<form class="stoprecordview-form"></form>').appendTo(this.dom);
            this.form.form({});

            var timeRow = $('<div class="editview-f-r"></div').appendTo(this.form);
            var label = $('<span style="margin-right:10px;" class="label">时间</span>').appendTo(timeRow);
            this.StopDT = $('<input type="text" name="StopDT">').appendTo(timeRow);
            this.StopDT.datetimebox({
                width: 180,
                label: label
            });
            this.StopDT.datetimebox('initiateWheelListener');
            this.StopDT.datetimebox('initiateKeyUpListener');

            var row = $('<div class="editview-f-r"></div').appendTo(this.form);
            var label = $('<span style="margin-right:10px;" class="label">转出去向</span>').appendTo(row);
            this.TheatreOutTransLoc = $('<input type="text" name="TransitNextLocation">').appendTo(row);
            this.TheatreOutTransLoc.combobox({
                width: 180,
                label: label,
                textField: 'text',
                valueField: 'value',
                limitToList: true,
                data: [
                    { text: 'PACU', value: 'PACU' },
                    { text: '原病区', value: 'Ward' },
                    { text: 'ICU', value: 'ICU' },
                    { text: '出院', value: 'Discharge' },
                    { text: '死亡', value: 'Death' }
                ],
                onSelect: function(row) {
                    if (row.value == 'PACU') {
						if (_this.IfRequsetPACU=="N"){
							_this.btn_save.linkbutton('enable');
						}
                        else if (!_this.pacuAdmission || !_this.pacuAdmission.RowId) {
                            var originalDefaults = $.extend({}, $.messager.defaults);
                            $.extend($.messager.defaults, {
                                ok: '打开PACU准入申请',
                                cancel: '取消'
                            });
                            $.messager.confirm('提示', '未提交PACU准入申请，是否进入申请界面', function(confirmed) {
                                if (confirmed) _this.requestPACU();
                            });
                            $.extend($.messager.defaults, originalDefaults);
                            _this.btn_save.linkbutton('disable');
                        } else if (_this.pacuAdmission.CanTransToPACU == "N") {
                            $.messager.alert('提示', _this.pacuAdmission.CurrentState);
                            _this.btn_save.linkbutton('disable');
                        } else {
                            _this.btn_save.linkbutton('enable');
                        }
                    } else {
                        _this.btn_save.linkbutton('enable');
                    }
                }
            });

            var row = $('<div class="editview-f-r"></div').appendTo(this.form);
            var label = $('<span style="margin-right:10px;" class="label">全麻效果评级 诱导</span>').appendTo(row);
            this.GeneralAnaesthesiaInductionEffect = $('<input type="text" name="TransitNextLocation">').appendTo(row);
            this.GeneralAnaesthesiaInductionEffect.combobox({
                width: 180,
                label: label,
                textField: 'text',
                valueField: 'value',
                data: [
                    { text: 'Ⅰ', value: 'Ⅰ' },
                    { text: 'Ⅱ', value: 'Ⅱ' },
                    { text: 'Ⅲ', value: 'Ⅲ' },
                    { text: 'Ⅳ', value: 'Ⅳ' }
                ]
            });

            var row = $('<div class="editview-f-r"></div').appendTo(this.form);
            var label = $('<span style="margin-right:10px;" class="label">维持</span>').appendTo(row);
            this.GeneralAnaesthesiaMaintainEffect = $('<input type="text" name="TransitNextLocation">').appendTo(row);
            this.GeneralAnaesthesiaMaintainEffect.combobox({
                width: 180,
                label: label,
                textField: 'text',
                valueField: 'value',
                data: [
                    { text: 'Ⅰ', value: 'Ⅰ' },
                    { text: 'Ⅱ', value: 'Ⅱ' },
                    { text: 'Ⅲ', value: 'Ⅲ' },
                    { text: 'Ⅳ', value: 'Ⅳ' }
                ]
            });

            var row = $('<div class="editview-f-r"></div').appendTo(this.form);
            var label = $('<span style="margin-right:10px;" class="label">结束</span>').appendTo(row);
            this.GeneralAnaesthesiaEndingEffect = $('<input type="text" name="TransitNextLocation">').appendTo(row);
            this.GeneralAnaesthesiaEndingEffect.combobox({
                width: 180,
                label: label,
                textField: 'text',
                valueField: 'value',
                data: [
                    { text: 'Ⅰ', value: 'Ⅰ' },
                    { text: 'Ⅱ', value: 'Ⅱ' },
                    { text: 'Ⅲ', value: 'Ⅲ' },
                    { text: 'Ⅳ', value: 'Ⅳ' }
                ]
            });

            var row = $('<div class="editview-f-r"></div').appendTo(this.form);
            var label = $('<span style="margin-right:10px;" class="label">椎管内麻醉效果评级</span>').appendTo(row);
            this.IntraspinalAnesthesiaEffect = $('<input type="text" name="TransitNextLocation">').appendTo(row);
            this.IntraspinalAnesthesiaEffect.combobox({
                width: 180,
                label: label,
                textField: 'text',
                valueField: 'value',
                data: [
                    { text: 'Ⅰ', value: 'Ⅰ' },
                    { text: 'Ⅱ', value: 'Ⅱ' },
                    { text: 'Ⅲ', value: 'Ⅲ' },
                    { text: 'Ⅳ', value: 'Ⅳ' }
                ]
            });

            var row = $('<div class="editview-f-r"></div').appendTo(this.form);
            var label = $('<span style="margin-right:10px;" class="label">神经阻滞效果评级</span>').appendTo(row);
            this.NerveBlockEffect = $('<input type="text" name="TransitNextLocation">').appendTo(row);
            this.NerveBlockEffect.combobox({
                width: 180,
                label: label,
                textField: 'text',
                valueField: 'value',
                data: [
                    { text: 'Ⅰ', value: 'Ⅰ' },
                    { text: 'Ⅱ', value: 'Ⅱ' },
                    { text: 'Ⅲ', value: 'Ⅲ' },
                    { text: 'Ⅳ', value: 'Ⅳ' }
                ]
            });

            var row = $('<div class="editview-f-r"></div').appendTo(this.form);
            var label = $('<span style="margin-right:10px;" class="label">并发症分级</span>').appendTo(row);
            this.Complication = $('<input type="text" name="TransitNextLocation">').appendTo(row);
            this.Complication.combobox({
                width: 180,
                label: label,
                textField: 'text',
                valueField: 'value',
                data: [
                    { text: 'Ⅰ', value: 'Ⅰ' },
                    { text: 'Ⅱ', value: 'Ⅱ' },
                    { text: 'Ⅲ', value: 'Ⅲ' },
                    { text: 'Ⅳ', value: 'Ⅳ' }
                    /*{ text: '喉痉挛', value: '喉痉挛' },
                    { text: '舌后坠', value: '舌后坠' },
                    { text: '过敏', value: '过敏' },
                    { text: '呼吸道误吸', value: '呼吸道误吸' },
                    { text: '恶心呕吐', value: '恶心呕吐' },
                    { text: '心跳骤停', value: '心跳骤停' },
                    { text: '苏醒延迟', value: '苏醒延迟' },
                    { text: '烦躁', value: '烦躁' },
                    { text: '局麻药中毒', value: '局麻药中毒' },
                    { text: '全脊麻', value: '全脊麻' }*/
                ]
            });
        },
        loadData: function(data) {
            if (!data) return;
            if (data.stopDT)
                this.StopDT.datetimebox('setValue', data.stopDT || '');
            if (data.theatreOutTransLoc)
                this.TheatreOutTransLoc.combobox('setValue', data.theatreOutTransLoc || '');
            if (data.generalAnaesthesiaInductionEffect)
                this.GeneralAnaesthesiaInductionEffect.combobox('setValue', data.generalAnaesthesiaInductionEffect || '');
            if (data.generalAnaesthesiaMaintainEffect)
                this.GeneralAnaesthesiaMaintainEffect.combobox('setValue', data.generalAnaesthesiaMaintainEffect || '');
            if (data.generalAnaesthesiaEndingEffect)
                this.GeneralAnaesthesiaEndingEffect.combobox('setValue', data.generalAnaesthesiaEndingEffect || '');
            if (data.intraspinalAnesthesiaEffect)
                this.IntraspinalAnesthesiaEffect.combobox('setValue', data.intraspinalAnesthesiaEffect || '');
            if (data.nerveBlockEffect)
                this.NerveBlockEffect.combobox('setValue', data.nerveBlockEffect || '');
            if (data.complication)
                this.Complication.combobox('setValue', data.complication || '');
        },
        loadPACUAdmission: function(pacuAdmission) {
            this.pacuAdmission = pacuAdmission;
        },
        requestPACU: function() {
            if (this.requestPACUHandler) this.requestPACUHandler.call(this);
        },
        default: function() {
            this.StopDT.datetimebox('setValue', new Date().format("yyyy-MM-dd HH:mm"));
        },
        open: function() {
            this.dom.dialog('open');
        },
        close: function() {
            this.dom.dialog('close');
        },
        clear: function() {
            this.form.form('clear');
        },
        save: function() {
            if (this.saveHandler) this.saveHandler({
                stopDT: this.StopDT.datetimebox('getValue'),
                theatreOutTransLoc: this.TheatreOutTransLoc.combobox('getValue'),
                generalAnaesthesiaInductionEffect: this.GeneralAnaesthesiaInductionEffect.combobox('getValue'),
                generalAnaesthesiaMaintainEffect: this.GeneralAnaesthesiaMaintainEffect.combobox('getValue'),
                generalAnaesthesiaEndingEffect: this.GeneralAnaesthesiaEndingEffect.combobox('getValue'),
                intraspinalAnesthesiaEffect: this.IntraspinalAnesthesiaEffect.combobox('getValue'),
                nerveBlockEffect: this.NerveBlockEffect.combobox('getValue'),
                complication: this.Complication.combobox('getValue')
            });
        },
		loadIfRequsetPACU: function(dataConfigurations) {
            this.IfRequsetPACU = dataConfigurations.DataValue;
        },
    }
}))