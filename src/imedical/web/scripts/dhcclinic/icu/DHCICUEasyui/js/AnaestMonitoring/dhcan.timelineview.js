/**
 * 时间线编辑界面
 * @author yongyang 20180613
 */

(function(global, factory) {
    if (!global.TimelineView) factory(global.TimelineView = {});
}(this, function(exports) {

    exports.init = function(opt) {
        var view = new TimelineView(opt);
        exports.instance = view;
        return view;
    }

    function TimelineView(opt) {
        this.options = $.extend({ width: 340, height: 300 }, opt);
        this.saveHandler = opt.saveHandler;
        this.init();
    }

    TimelineView.prototype = {
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
                title: '急救模式',
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

        },
        open: function() {
            this.dom.dialog('open');
        },
        close: function() {
            this.dom.dialog('close');
        },
        loadData: function(data) {

        },
        clear: function() {
            this.form.form('clear');
        },
        save: function() {

        }
    }

}))