/**
 * 选中数据明细对话框
 * @author yongyang 2021-11-04
 */
(function(global, factory) {
    if (!global.DataSelectedView) factory(global.DataSelectedView = {});
}(this, function(exports) {

    function init(opt) {
        var view = new DataSelectedView(opt);
        exports.instance = view;
        return view;
    }

    exports.init = init;

    function DataSelectedView(opt) {
        this.options = $.extend({ width: 300, height: 260 }, opt);
        this.saveHandler = opt.saveHandler;
        this.init();
    }

    DataSelectedView.prototype = {
        constructor: DataSelectedView,
        init: function() {
            var _this = this;
            this.dom = $('<div></div>').appendTo('body');

            this.itemContainer = $('<div class="dataselectedview-container"></div>').appendTo(this.dom);

            this.dom.dialog({
                left: 400,
                top: 150,
                height: this.options.height,
                width: this.options.width,
                title: '绘制项目选择',
                modal: true,
                closed: true,
                resizable: true,
                onOpen: function() {

                },
                onClose: function() {
                    _this.clear();
                    if (!_this.saved && _this.options.onCancel) {
                        _this.options.onCancel.call(this);
                    }
                }
            });

            this.itemContainer.delegate('.dataselectedview-item', 'click', function() {
                var data = $(this).data('data');
                _this.selectedItem = data;
                _this.save();
            });
        },
        render: function() {
            this.itemContainer.empty();
            var container = this.itemContainer;

            var data = this.data || [];
            var length = this.data.length;
            var item, element;
            for (var i = 0; i < length; i++) {
                item = data[i];
                element = $('<div class="dataselectedview-item"></div>').appendTo(container);
                $('<span class="dataselectedview-item-title"></span>').text(item.Description).appendTo(element);
                element.data('data', item);
            }
        },
        loadData: function(data) {
            this.data = data;
            this.render();
        },
        open: function() {
            this.saved = false;
            this.dom.dialog('open');
        },
        close: function() {
            this.dom.dialog('close');
        },
        clear: function() {
            this.itemContainer.empty();
        },
        save: function() {
            if (this.saveHandler) {
                this.saveHandler(this.selectedItem);
            }
            this.saved = true;
            this.close();
        }
    }
}));