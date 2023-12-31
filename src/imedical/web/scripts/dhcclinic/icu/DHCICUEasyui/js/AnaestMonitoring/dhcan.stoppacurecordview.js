/**
 * PACU结束监护弹出框
 * @author yongyang 20190309
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
        this.options = $.extend({ width: 380, height: 180 }, opts);
        this.init();
    }

    StopRecordView.prototype = {
        init: function() {
            var _this = this;
            this.dom = $('<div></div>').appendTo('body');
            var buttons = $('<div></div>');
            var btn_save = $('<a href="#"></a>').linkbutton({
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
            this.form = $('<form class="stoprecordview-form"></form>').appendTo(this.dom);
            this.form.form({});

            var timeRow = $('<div class="editview-f-r"></div').appendTo(this.form);
            var label = $('<span class="label">时间：</span>').appendTo(timeRow);
            this.StopDT = $('<input type="text" name="StopDT">').appendTo(timeRow);
            this.StopDT.datetimebox({
                width: 180,
                label: label
            });
            this.StopDT.datetimebox('initiateWheelListener');
            this.StopDT.datetimebox('initiateKeyUpListener');

            var row = $('<div class="editview-f-r"></div').appendTo(this.form);
            var label = $('<span class="label">转出去向：</span>').appendTo(row);
            this.AreaOutTransLoc = $('<input type="text" name="TransitNextLocation">').appendTo(row);
            this.AreaOutTransLoc.combobox({
                width: 180,
                label: label,
                textField: 'text',
                valueField: 'value',
                limitToList: true,
                data: [
                    { text: '原病区', value: 'Ward' },
                    { text: 'ICU', value: 'ICU' },
                    { text: '离院', value: 'Discharge' },
                    { text: '死亡', value: 'Death' },
                    { text: '返回术间', value: 'BackOper' }
                ]
            });
        },
        loadData: function(data) {
            if (!data) return;
            if (data.stopDT)
                this.StopDT.datetimebox('setValue', data.stopDT || '');
            if (data.areaOutTransLoc)
                this.AreaOutTransLoc.combobox('setValue', data.areaOutTransLoc || '');
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
                areaOutTransLoc: this.AreaOutTransLoc.combobox('getValue') || ''
            });
        }
    }
}))