//
/**
 * 自动生成数据界面
 * @author yongyang 2018-11-6
 */
(function(global, factory) {
    if (!global.autoGenerateView) factory(global.autoGenerateView = {});
}(this, function(exports) {

    function init(opt) {
        var view = new AutoGenerateView(opt);
        exports.instance = view;
        return view;
    }

    exports.init = init;

    function AutoGenerateView(opt) {
        this.options = $.extend({ width: 320, height: 260 }, opt);
        this.saveHandler = opt.saveHandler;
        this.generateHandler = opt.generateHandler;
        this.init();
    }

    AutoGenerateView.prototype = {
        constructor: AutoGenerateView,
        init: function() {
            var _this = this;
            this.dom = $('<div></div>').appendTo('body');
            var buttons = $('<div></div>');
            var btn_save = $('<a href="#"></a>').linkbutton({
                text: '启动',
                iconCls: 'icon-w-run',
                onClick: function() {
                    _this.save();
                    _this.close();
                }
            }).appendTo(buttons);
            var btn_generate = $('<a href="#" title="根据设置的开始和结束时间生成给定数值的生命体征数据"></a>').linkbutton({
                text: '生成',
                iconCls: 'icon-green-chart',
                onClick: function() {
                    _this.generate();
                }
            }).appendTo(buttons);
            var btn_cancel = $('<a href="#"></a>').linkbutton({
                text: '关闭',
                iconCls: 'icon-w-cancel',
                onClick: function() {
                    _this.close();
                }
            }).appendTo(buttons);

            this.tipcontainer = $('<div class="editor-tips-container"></div>').appendTo(this.dom);
            this.tipcontainer.text('开启自动生成后，如果从监护仪上已采集到数据，所采集的数据值会替换为此处指定的数据值！');
            this.form = $('<form class="autogenerateview-form"></form>').appendTo(this.dom);

            this.dom.dialog({
                left: 300,
                top: 50,
                height: this.options.height,
                width: this.options.width,
                title: '自动生成设置',
                modal: false,
                closed: true,
                resizable: true,
                buttons: buttons,
                onOpen: function() {

                },
                onClose: function() {
                    _this.clear();
                }
            });

            this.initForm();
        },
        initForm: function() {
            this.form.form({});

            var row = $('<div class="editview-f-r"></div>').appendTo(this.form);
            var label = $('<div class="label" title="自动生成的数据的值">数值：</div>').appendTo(row);
            this.DefaultValue = $('<input type="text">').appendTo(row);
            this.DefaultValue.numberbox({
                required: true,
                width: 200,
                label: label
            });

            var timeRow = $('<div class="editview-f-r"></div>').appendTo(this.form);
            var label = $('<div class="label">开始时间：</div>').appendTo(timeRow);
            this.StartDT = $('<input type="text">').appendTo(timeRow);
            this.StartDT.datetimebox({
                width: 200,
                label: label
            });
            this.StartDT.datetimebox('initiateWheelListener');
            this.StartDT.datetimebox('initiateKeyUpListener');

            var timeRow = $('<div class="editview-f-r"></div>').appendTo(this.form);
            var label = $('<div class="label">结束时间：</div>').appendTo(timeRow);
            this.EndDT = $('<input type="text">').appendTo(timeRow);
            this.EndDT.datetimebox({
                width: 200,
                label: label
            });
            this.EndDT.datetimebox('initiateWheelListener');
            this.EndDT.datetimebox('initiateKeyUpListener');
        },
        setParaItem: function(paraItem) {
            if (paraItem) {
                this.paraItem = paraItem;
                this.paraItemRowId = paraItem.RowId;
                this.DefaultValue.numberbox('setValue', paraItem.DefaultValue);
                this.dom.dialog('setTitle', '自动生成设置：' + paraItem.Description);
            }
        },
        setDateTime: function(recordStartDT) {
            var datetime = recordStartDT.format("yyyy-MM-dd HH:mm:ss");
            this.StartDT.datetimebox('setValue', datetime);
            this.EndDT.datetimebox('setValue', datetime);
        },
        setOptions: function(opt) {
            $.extend(this.options, opt);
        },
        open: function() {
            this.dom.dialog('open');
        },
        close: function() {
            this.dom.dialog('close');
            if (this.onClose) this.onClose();
        },
        clear: function() {
            this.form.form('clear');
            this.paraItemRowId = '';
            this.paraItem = '';
        },
        generate: function() {
            var startDT = this.StartDT.datetimebox('getValue');
            var endDT = this.EndDT.datetimebox('getValue');
            var value = this.DefaultValue.numberbox('getValue');

            var errorMessage = '';
            if (!startDT) {
                errorMessage = '请填写开始时间后再点击生成数据';
                this.StartDT.datetimebox('focus');
            }
            if (!endDT) {
                errorMessage = '请填写结束时间后再点击生成数据';
                this.EndDT.datetimebox('focus');
            }
            if (!value) {
                errorMessage = '请填写数值后再点击生成数据';
                this.DefaultValue.numberbox('focus');
            }

            if (errorMessage) {
                $.messager.alert("提示", errorMessage, "warning");
                return;
            }

            if (this.generateHandler) {
                this.generateHandler.call(this, {
                    ParaItem: this.paraItemRowId,
                    DataItem: this.paraItem.DataItem,
                    StartDT: startDT,
                    EndDT: endDT,
                    Value: value
                });
            }

            this.close();
        },
        save: function() {
            var data = {
                ParaItem: this.paraItemRowId,
                DefaultValue: this.DefaultValue.numberbox('getValue'),
                AutoGenerate: 'Y'
            };
            this.paraItem.DefaultValue = data.DefaultValue;
            this.paraItem.AutoGenerate = data.AutoGenerate;
            if (this.saveHandler) {
                this.saveHandler.call(this, data);
            }
        }
    }
}));