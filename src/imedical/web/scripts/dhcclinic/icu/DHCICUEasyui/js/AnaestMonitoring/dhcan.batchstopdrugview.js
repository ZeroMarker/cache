//
/**
 * 批量停止连续用药
 * @author yongyang 2018-11-27
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
        this.options = $.extend({ width: 320, height: 180 }, opt);
        this.saveHandler = opt.saveHandler;
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
                iconCls: 'icon-save',
                onClick: function() {
                    _this.save();
                    _this.close();
                }
            }).appendTo(buttons);
            var btn_cancel = $('<a href="#"></a>').linkbutton({
                text: '关闭',
                iconCls: 'icon-cancel',
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
        },
        setParaItem: function(paraItem) {
            if (paraItem) {
                this.paraItem = paraItem;
                this.paraItemRowId = paraItem.RowId;
                this.DefaultValue.numberbox('setValue', paraItem.DefaultValue);
                this.dom.dialog('setTitle', '自动生成设置：' + paraItem.Description);
            }
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