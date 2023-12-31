/**
 * 生命体征数据批量删除
 * @author yongyang 2020-03-23
 */

(function(global, factory) {
    if (!global.vitalSignBatchView) factory(global.vitalSignBatchView = {});
}(this, function(exports) {

    function init(opt) {
        var view = new VitalSignBatchView(opt);
        exports.instance = view;
        return view;
    }

    exports.init = init;

    function VitalSignBatchView(opt) {
        this.dom = null;
        this.options = { width: 340, height: 210 };
        this.saveHandler = opt.saveHandler;
        $.extend(this.options, opt);
        this.init();
    }

    VitalSignBatchView.prototype = {
        constructor: VitalSignBatchView,
        /**
         * 初始化
         */
        init: function() {
            var _this = this;
            this.dom = $('<div></div>').appendTo('body');
            var buttons = $('<div></div>');
            var btn_save = $('<a href="#"></a>').linkbutton({
                iconCls: 'icon-save',
                text: '确认',
                onClick: function() {
                    _this.save();
                }
            }).appendTo(buttons);
            var btn_close = $('<a href="#"></a>').linkbutton({
                iconCls: 'icon-cancel',
                text: '取消',
                onClick: function() {
                    _this.close();
                }
            }).appendTo(buttons);

            this.initForm();

            this.dom.dialog({
                closed: true,
                title: '生命体征数据批量删除',
                height: this.options.height,
                width: this.options.width,
                top: 100,
                modal: true,
                buttons: buttons,
                onOpen: function() {
                    _this.isSaved = false;
                },
                onBeforeClose: function() {},
                onClose: function() {
                    _this.clear();
                }
            });

            this.container = $(this.dom.find('.panel-body'));
        },
        initForm: function() {
            this.form = $('<form></form>').appendTo(this.dom);
            this.form.form({});

            var itemRow = $('<div class="editview-f-r"><div class="label">数据项：</div></div>').appendTo(this.form);
            this.ParaItem = $('<span class="drugeditor-editview-drugitem" style="width:180px;"></span>').appendTo(itemRow);
            this.ParaItemRowId = $('<input type="hidden" name="ParaItem">').appendTo(itemRow);

            var timeRow = $('<div class="editview-f-r"></div').appendTo(this.form);
            var label = $('<span class="label">开始时间：</span>').appendTo(timeRow);
            this.StartDT = $('<input type="text" name="StartDT">').appendTo(timeRow);
            this.StartDT.datetimebox({
                width: 180,
                label: label
            });

            this.StartDT.datetimebox('initiateWheelListener');

            var timeRow = $('<div class="editview-f-r"></div').appendTo(this.form);
            var label = $('<span class="label">结束时间：</span>').appendTo(timeRow);
            this.EndDT = $('<input type="text" name="EndDT">').appendTo(timeRow);
            this.EndDT.datetimebox({
                width: 180,
                label: label
            });

            this.EndDT.datetimebox('initiateWheelListener');
        },
        default: function() {
            this.StartDT.datetimebox('setValue', new Date().format("yyyy-MM-dd HH:mm"));
            this.EndDT.datetimebox('setValue', new Date().format("yyyy-MM-dd HH:mm"));
        },
        open: function() {
            this.dom.dialog('open');
        },
        close: function() {
            this.dom.dialog('close');
        },
        loadData: function(data) {
            if (data) {
                this.ParaItem.text(data.paraItem);
                this.ParaItemRowId.val(data.paraItemRowId);
                this.StartDT.datetimebox('setValue', data.startDT);
                this.EndDT.datetimebox('setValue', data.endDT);
                this.dom.dialog('setTitle', data.title);
            } else {
                this.default();
            }
        },
        clear: function() {
            this.form.form('clear');
        },
        validate: function() {
            var _this = this;
            return true;
        },
        save: function() {
            if (!this.validate()) return;
            var _this = this;
            var data = {
                paraItem: this.ParaItemRowId.val(),
                startDT: this.StartDT.datetimebox("getValue"),
                endDT: this.EndDT.datetimebox("getValue")
            };

            $.messager.confirm('批量删除' + this.ParaItem.text() +
                '数据', '您确定删除<span style="color:red;">' + data.startDT + '</span>到<span style="color:red;">' +
                data.endDT + '</span>之间的' + this.ParaItem.text() + '数据？',
                function(confirmed) {
                    if (confirmed) {
                        if (_this.saveHandler)
                            _this.saveHandler(data);
                        _this.close();
                    }
                });
        }
    }
}))