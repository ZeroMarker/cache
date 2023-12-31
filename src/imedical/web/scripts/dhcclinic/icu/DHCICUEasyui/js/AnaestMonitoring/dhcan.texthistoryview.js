//
/**
 * 采集数据即时显示
 * @author yongyang 2018-10-22
 */
(function(global, factory) {
    if (!global.textHistoryView) factory(global.textHistoryView = {});
}(this, function(exports) {

    function init(dom, opt) {
        var view = new TextHistoryView(dom, opt);
        exports.instance = view;
        return view;
    }

    exports.init = init;

    function TextHistoryView(dom, opt) {
        this.dom = dom;
        this.options = $.extend({ width: 240, height: 240 }, opt);
        this.callback = null;
        this.key = '';
        this.init();
    }

    TextHistoryView.prototype = {
        /**
         * 构造器
         */
        Constructor: TextHistoryView,
        /**
         * 初始化
         */
        init: function() {
            var _this = this;
            this.dom.width(this.options.width);
            this.dom.height(this.options.height);
            this.close();

            this.header = $('<div class="texthistory-view-header"></div>').appendTo(this.dom);
            this.searchbox = $('<input>')
                .appendTo(this.header)
                .searchbox({
                    width: 190,
                    prompt: '输入名称或简拼检索'
                });

            var inputRect = this.searchbox.siblings('.searchbox');
            $(inputRect).find('input').keyup(function() {
                var text = $(this).val().toUpperCase();
                _this.filter(text);
            });

            this.header.height(40);

            this.container = $('<div class="texthistory-view-container"></div>').appendTo(this.dom);
            this.container.height(this.options.height - 40);
            this.initClick();
        },
        initClick: function() {
            var _this = this;
            this.container.delegate('.texthistory-i', 'click', function() {
                var item = $(this).data('data');
                if (_this.callback) _this.callback(item);
            })
        },
        /**
         * 加载数据
         */
        loadData: function(data) {
            this.data = data;
            this.render();
        },
        /**
         * 渲染
         */
        render: function() {
            var container = this.container;
            container.empty();
            container.hide();

            var data = this.data;
            var length = data.length;
            var itemRender = singleItemView.render;
            for (var i = 0; i < length; i++) {
                var element = $('<a href="javascript:;" class="texthistory-i"></a>').appendTo(container);
                itemRender(element, data[i]);
            }

            container.show();
        },
        /**
         * 设置检索字段
         * @param {*} field 
         */
        setKeyField: function(field) {
            this.keyField = field;
            this.filter('');
        },
        /**
         * 设置回调函数
         */
        setCallback: function(callback) {
            this.callback = callback;
        },
        /**
         * 筛选
         */
        filter: function(filterStr) {
            var keyField = this.keyField;
            this.container.find('.texthistory-i').each(function(index, e) {
                var key = $(e).attr('data-key');
                var text = $(e).attr('data-uppertext');
                if ((!keyField || key == keyField) &&
                    text.indexOf(filterStr) > -1) {
                    $(e).show();
                } else {
                    $(e).hide();
                }
            })
        },
        open: function() {
            this.dom.show();
        },
        close: function() {
            this.dom.hide();
        },
        position: function(pos) {
            this.dom.css({
                left: pos.x,
                top: pos.y
            });
        }
    }

    var singleItemView = {
        render: function(container, item) {
            container.empty();
            container.data('data', item);
            item.target = container;
            container.attr('data-key', item.Field);
            container.attr('data-uppertext', item.UpperText);
            container.append('<span>' + item.Text + '<span>');
        }
    }
}));