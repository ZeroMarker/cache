//
/**
 * 异常提醒
 * @author yongyang 2020-05-09
 */
(function(global, factory) {
    if (!global.AbnormalView) factory(global.AbnormalView = {});
}(this, function(exports) {

    function init(opt) {
        var view = new AbnormalView(opt);
        exports.instance = view;
        return view;
    }

    exports.init = init;

    function AbnormalView(opt) {
        this.options = $.extend({ width: 200, height: 360 }, opt);
        this.saveHandler = opt.saveHandler;
        this.init();
    }

    AbnormalView.prototype = {
        constructor: AbnormalView,
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
                title: '异常生命体征',
                modal: false,
                closed: true,
                resizable: true,
                iconCls: 'icon-w-msg',
                buttons: buttons,
                onOpen: function() {

                },
                onClose: function() {
                    _this.clear();
                }
            });
        },
        loadData: function(data) {
            this.clear();
            var groups = groupingData(data);
            var element, group;
            var length = groups.length;
            for (var i = 0; i < length; i++) {
                group = groups[i];
                element = $('<div class="abnormalview-group"></div>').appendTo(this.dataContainer);
                groupView.render(element, group);
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
            this.dataContainer.empty();
        },
        save: function() {}
    }

    function groupingData(data) {
        var groupBy = { key: 'StartDateTime' };
        var groups = {};
        var dataGroups = [];

        var length = data.length;
        for (var i = 0; i < length; i++) {
            var row = data[i];
            var groupIndex = row[groupBy.key];
            if (!groups[groupIndex]) groups[groupIndex] = [];
            groups[groupIndex].push(row);
        }

        for (var groupIndex in groups) {
            dataGroups.push({
                key: groupIndex,
                rows: groups[groupIndex]
            });
        }

        return dataGroups;
    };

    var groupView = {
        render: function(container, group) {
            var time = group.key.slice(11, 19);
            var element = $('<div class="abnormalview-group-key"></div>')
                .attr('title', group.key).text(time).appendTo(container);

            var dataContainer = $('<div class="abnormalview-group-container"></div>').appendTo(container);
            var element, row;
            var length = group.rows.length;
            for (var i = 0; i < length; i++) {
                row = group.rows[i];
                element = $('<div class="abnormalview-group-data"></div>').appendTo(dataContainer);
                dataView.render(element, row);
            }
        }
    }

    var dataView = {
        render: function(container, data) {
            $('<span class="abnormalview-group-data-name"></span>').text(data.DataItemDesc).appendTo(container);
            $('<span class="abnormalview-group-data-value"></span>').text(data.DataValue).appendTo(container);
        }
    }
}));