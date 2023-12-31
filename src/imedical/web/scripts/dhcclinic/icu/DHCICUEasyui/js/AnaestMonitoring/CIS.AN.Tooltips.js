//
/**
 * 提示框
 * @author yongyang 2020-11-26
 */
(function(global, factory) {
    if (!global.Tooltips) factory(global.Tooltips = {});
}(this, function(exports) {

    function init(opt) {
        var view = new Tooltips(opt);
        exports.instance = view;
        return view;
    }

    exports.init = init;

    function Tooltips(opt) {
        this.options = $.extend({ width: 160, height: 182 }, opt);
        this.init();
    }

    Tooltips.prototype = {
        constructor: Tooltips,
        init: function() {
            var _this = this;
            this.dom = $('<div class="tooltips-dialog"></div>').appendTo('body');
            var header = $('<div class="tooltips-header"></div>').appendTo(this.dom);
            var btn_cancel = $('<a href="javascript:;" class="tagbox-remove" title="关闭"></a>').appendTo(header);
            btn_cancel.click(function() {
                _this.close();
            });
            this.dataContainer = $('<div class="tooltips-container"></div>').appendTo(this.dom);
        },
        setText: function(text) {
            this.dataContainer.empty();
            this.dataContainer.html(text);
        },
        setOptions: function(opt) {
            $.extend(this.options, opt);
        },
        position: function(position, scrollPos) {
            this.originalPosition = position;
            this.originalScrollPos = scrollPos;
            this.dom.css({ left: position.left, top: position.top });
            return this;
        },
        refreshPosition: function(scrollPos) {
            this.dom.css({
                left: this.originalPosition.left + scrollPos.left - this.originalScrollPos.left,
                top: this.originalPosition.top + scrollPos.top - this.originalScrollPos.top
            });
            this.originalScrollPos = scrollPos;
        },
        open: function() {
            this.dom.show();
        },
        close: function() {
            this.dom.hide();
        },
        visible: function() {
            return this.dom.is(':visible');
        },
        clear: function() {
            this.dataContainer.empty();
        }
    }
}));