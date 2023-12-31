//
/**
 * 时间提醒
 * @author yongyang 2020-08-26
 */
(function(global, factory) {
    if (!global.TimeReminder) factory(global.TimeReminder = {});
}(this, function(exports) {

    function init(opt) {
        var view = new TimeReminder(opt);
        exports.instance = view;
        return view;
    }

    exports.init = init;

    function TimeReminder(opt) {
        this.options = $.extend({ width: 160, height: 182 }, opt);
        this.saveHandler = opt.saveHandler;
        this.init();
    }

    TimeReminder.prototype = {
        constructor: TimeReminder,
        init: function() {
            var _this = this;
            this.dom = $('<div></div>').appendTo('body');
            var buttons = $('<div></div>');
            /*var btn_save = $('<a href="#"></a>').linkbutton({
                text: '启动',
                iconCls: 'icon-save',
                onClick: function() {
                    _this.save();
                    _this.close();
                }
            }).appendTo(buttons);*/
            var btn_cancel = $('<a href="#"></a>').linkbutton({
                text: '关闭',
                iconCls: 'icon-cancel',
                onClick: function() {
                    _this.close();
                }
            }).appendTo(buttons);

            this.dataContainer = $('<div class="editor-container"></div>').appendTo(this.dom);

            this.dom.dialog({
                right: 200,
                top: 50,
                height: this.options.height,
                width: this.options.width,
                title: '计时器',
                modal: false,
                closed: true,
                resizable: true,
                iconCls: 'icon-w-clock',
                //buttons: buttons,
                onOpen: function() {
                    _this.addTimer();
                },
                onClose: function() {
                    _this.clear();
                    clearInterval(this.timer);
                }
            });
        },
        loadData: function(data) {
            this.data = data;
            this.render();
        },
        render: function() {
            this.clear();
            var data = this.data;
            var length = data.length;
            var element, row;
            for (var i = 0; i < length; i++) {
                row = data[i];
                element = $('<div class="timereminder-item"></div>').appendTo(this.dataContainer);
                itemView.render(element, row);
            }
        },
        addTimer: function() {
            var _this = this;
            this.timer = setInterval(function() {
                var data = _this.data;
                if (data) {
                    var length = data.length;
                    for (var i = 0; i < length; i++) {
                        row = data[i];
                        itemView.refreshTime(row.target, row);
                    }
                }
            }, 60000);
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
            this.dataContainer.empty();
        },
        save: function() {}
    }

    var itemView = {
        render: function(container, row) {
            container.data('data', row);
            row.target = container;

            $('<span class="timereminder-item-name"></span>')
                .attr('title', row.name).text(row.name).appendTo(container);

            if (row.startDT && row.endDT) {
                container.addClass('timereminder-item-fixed');
            }

            var startDT = new Date().tryParse(row.startDT);
            var endDT = new Date().tryParse(row.endDT);
            var timeSpan = new TimeSpan(endDT, startDT);
            var hours = Math.floor(timeSpan.totalMinutes / 60);
            var minutes = Math.floor(timeSpan.totalMinutes % 60);
            hours = hours > 9 ? hours : '0' + hours;
            minutes = minutes > 9 ? minutes : '0' + minutes;
            $('<span class="timereminder-item-time"></span>')
                .attr('title', row.startDT + '~' + row.endDT).text(hours + ':' + minutes).appendTo(container);
        },
        refreshTime: function(container, row) {
            if (!row.endDT) {
                var startDT = new Date().tryParse(row.startDT);
                var endDT = new Date().tryParse(row.endDT);
                var timeSpan = new TimeSpan(endDT, startDT);
                var hours = Math.floor(timeSpan.totalMinutes / 60);
                var minutes = Math.floor(timeSpan.totalMinutes % 60);
                hours = hours > 9 ? hours : '0' + hours;
                minutes = minutes > 9 ? minutes : '0' + minutes;

                container.find('.timereminder-item-time').text(hours + ':' + minutes);
            }
        }
    }
}));