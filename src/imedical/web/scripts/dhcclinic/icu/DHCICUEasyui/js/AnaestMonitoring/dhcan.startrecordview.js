/**
 * 开始监护弹出框
 * @author yongyang 20180613
 */

(function(global, factory) {
    if (!global.StartRecordView) factory(global.StartRecordView = {});
}(this, function(exports) {

    exports.init = function(opt) {
        var view = new StartRecordView(opt);
        exports.instance = view;
        return view;
    }

    function StartRecordView(opt) {
        this.options = $.extend({ width: 340, height: 150 }, opt);
        this.saveHandler = opt.saveHandler;
        this.init();
    }

    StartRecordView.prototype = {
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
                top: 150,
                height: this.options.height,
                width: this.options.width,
                title: '开始监护',
                modal: true,
                closed: true,
                buttons: buttons,
                onOpen: function() {},
                onClose: function() {
                    _this.clear();
                }
            });
        },
        initForm: function() {
            this.form = $('<form></form>').appendTo(this.dom);
            this.form.form({});

            var timeRow = $('<div class="editview-f-r"></div').appendTo(this.form);
            var label = $('<span class="label">开始时间：</span>').appendTo(timeRow);
            this.StartDT = $('<input type="text" name="StartDT">').appendTo(timeRow);
            this.StartDT.datetimebox({
                width: 180,
                label: label
            });

            this.StartDT.datetimebox('initiateWheelListener');
            this.StartDT.datetimebox('initiateKeyUpListener');
        },
        default: function() {
            this.StartDT.datetimebox('setValue', new Date().format("yyyy-MM-dd HH:mm"));
        },
        open: function() {
            this.dom.dialog('open');
        },
        close: function() {
            this.dom.dialog('close');
        },
        loadData: function(data) {
            if (data) {
                this.StartDT.datetimebox('setValue', data.startDT);
                this.dom.dialog('setTitle', data.title);
                this.isStarting = data.isStarting;
            } else {
                this.default();
            }
        },
        clear: function() {
            this.form.form('clear');
        },
        validate: function() {
            var _this = this;
            var startDateTime = this.StartDT.datetimebox("getValue");
            var startDate = startDateTime.substr(0, 10);
            var today = new Date().format(constant.dateFormat);
            if (startDate !== today) {
                $.messager.confirm('开始监护时间可能有误', '您输入的开始监护时间不是当天，您确定从<span style="color:red;">' + startDateTime + '</span>开始监护吗？', function(confirmed) {
                    if (confirmed) {
                        if (_this.saveHandler)
                            _this.saveHandler({
                                startDT: startDateTime,
                                isStarting: _this.isStarting
                            });
                    } else {
                        _this.StartDT.datetimebox('focus');
                    }
                });
                return false;
            }
            return true;
        },
        save: function() {
            if (!this.validate()) return;
            if (this.saveHandler)
                this.saveHandler({
                    startDT: this.StartDT.datetimebox("getValue"),
                    isStarting: this.isStarting
                });
        }
    }

}))