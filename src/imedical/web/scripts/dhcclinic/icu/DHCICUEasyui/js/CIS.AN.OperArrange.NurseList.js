/**
 * @author yongyang
 * @description 手术排班视图 手术护士列表
 */

(function(global, factory) {
    factory((global.NurseList = {}));
}(this, (function(exports) {

    var _id = 0;

    var _methods = {};

    /**
     * 初始化方法，外部调用：NurseList.init(...);
     * 暂时没有考虑传入的元素已经绑定此对象的情况
     * @param {HTMLElement} dom 
     * @param {object} opt 
     * @returns 
     */
    function init(dom, opt) {
        _id++;

        var cardboard = new NurseList(dom, opt);

        return cardboard;
    }

    exports.init = init;

    var defaultOptions = {
        fit: true,
        width: 'auto',
        height: 'auto',
        multipleSelection: false
    }

    /**
     * @description NurseList构造函数
     * @author yongyang 2018-03-06
     * @module NurseList
     * @constructor
     * @param {HTMLElement} dom 
     * @param {object} opt 
     */
    function NurseList(dom, opt) {
        /**
         * @property {Array} 手术安排数据
         */
        this.bindedData = [];

        /**
         * @property {HTMLElement} cardboard对应的界面元素
         * @private
         */
        this.dom = dom;

        /**
         * @property {object} 配置信息
         * @private
         */
        this.options = defaultOptions;

        /**
         * 分组显示渲染器
         */
        this.groupView = careproviderGroupView;

        this.onQuery = null;

        this._init();
        this.setOptions(opt);
    };

    /**
     * 全部人员 按 首字母 分组显示
     */
    NurseList.prototype = {
        _init: function() {
            var _this = this;
            var header = $('<div class="header" style="padding:5px 0px;"></div>').appendTo(this.dom);
            var input = $('<input type="text">').appendTo(header);
            input.searchbox({
                prompt: '输入拼音首字母或汉字检索',
                width: header.width() - 5
            });

            $(input).siblings().find('input.searchbox-text').keyup(function(e) {
                e.preventDefault();
                e.stopPropagation();
                var text = $(this).val();
                _this.filter(text);
            });

            $(input).siblings().find('.searchbox-button').click(function() {
                var text = $(this).parent().parent().find('input.searchbox-text').val();
                _this.filter(text);
            });

            this.tagContainer = $('<div style="margin-top:5px;margin-left:5px;"></div>').appendTo(header);

            this.dataContainer = $('<div class="careprovider-container"></div>').appendTo(this.dom);

            this.tagContainer.delegate('.careprovider-tag', 'click', function() {
                $(this).toggleClass('careprovider-tag-selected');
                var text = _this.tagContainer.parent().find('input.searchbox-text:visible').val();
                if (text == '输入拼音首字母或汉字检索') text = '';
                _this.filter(text);
            });
        },
        /**
         * 加载人员
         * -> 按首字母分组
         */
        loadData: function(data) {
            /// 加载人员
            /// -> 按首字母分组
            this.bindedData = data;
            this.groups = groupingData(data, 'FirstChar');
            this.groups.sort(alphabetCompare('key'));
            this.tags = tagData(data, 'UserTags');
            this.render();
            this.renderTags();
        },
        /**
         * 设置参数
         * @param {*} options 
         */
        setOptions: function(options) {
            var _this = this;
            $.extend(this.options, options);
        },
        /**
         * 渲染标签
         */
        renderTags: function() {
            var container = this.tagContainer;
            container.empty();

            var tags = this.tags;
            var element;
            for (var i = 0, length = tags.length; i < length; i++) {
                element = $('<a href="javascript:;" class="careprovider-tag careprovider-tag-selected"></a>').text(tags[i].key).appendTo(container);
                element.data('data', tags[i]);
            }
        },
        /**
         * 渲染
         */
        render: function() {
            var _this = this;
            var groups = this.groups;
            var container = this.dataContainer;
            var length = groups.length;
            var groupEl = null;
            container.hide();
            var length = groups.length;
            var groupEl;
            var groupView = this.groupView;
            for (var i = 0; i < length; i++) {
                groupEl = $('<div class="careprovider-group"></div>').appendTo(container);
                groupView.render(groupEl, groups[i]);
            }
            container.show();

            //设置拖拽人员卡片
            this.dom.find('.careprovider-item').draggable({
                edge: 5,
                revert: true,
                proxy: proxy,
                cursor: 'pointer',
                onBeforeDrag: function(e) {},
                onStartDrag: function(e) {
                    if ($(this).data('draggable') && $(this).data('draggable')['droppables']) {
                        $($(this).data('draggable')['droppables']).addClass('droppable-focus');
                    }
                },
                onStopDrag: function(e) {
                    if ($(this).data('draggable') && $(this).data('draggable')['droppables']) {
                        $($(this).data('draggable')['droppables']).removeClass('droppable-focus');
                    }
                },
                onEndDrag: function(e) {
                    if ($(this).data('draggable') && $(this).data('draggable')['droppables']) {
                        $($(this).data('draggable')['droppables']).removeClass('droppable-focus');
                    }
                    var item = $(this);
                    setTimeout(function() {
                        item.css({ top: 0, left: 0 });
                    }, 400);
                }
            });

            this.dom.find('.careprovider-item').dblclick(function() {
                if (_this.options.onDblClick) {
                    _this.options.onDblClick.call(this, $(this).data('data'));
                }
            })
        },
        /**
         * 刷新View
         */
        refreshView: function() {
            var groups = this.groups || [];

            var length = groups.length;
            var group, itemLength, item;
            for (var i = 0; i < length; i++) {
                group = groups[i];
                itemLength = group.items.length;
                for (var j = 0; j < itemLength; j++) {
                    item = group.items[j];
                    if (item.operSchedules && item.operSchedules.length > 0) {
                        item.target.addClass('careprovider-item-occupied');
                        item.target.attr('data-opercount', item.operSchedules.length);
                        item.target.attr('title', '已安排手术 ' + item.operSchedules.length + ' 台');
                    } else {
                        item.target.removeClass('careprovider-item-occupied');
                        item.target.attr('title', '');
                        item.target.attr('data-opercount', 0);
                    }
                }
            }
        },
        /**
         * 筛选
         */
        filter: function(text) {
            var groups = this.groups || [];
            var filterFields = ['Description', 'ShortDesc'];
            var upperText = text.toUpperCase();
            var tagVisibleRows = this.getTagVisibleRows();

            var length = groups.length;
            var group, itemLength, item, ifMatch,
                ifGroupMatch, fieldLength, field;
            for (var i = 0; i < length; i++) {
                group = groups[i];
                itemLength = group.items.length;
                ifGroupMatch = false;
                for (var j = 0; j < itemLength; j++) {
                    item = group.items[j];
                    ifMatch = false;
                    fieldLength = filterFields.length;
                    for (var k = 0; k < fieldLength; k++) {
                        field = filterFields[k];
                        if (item[field].indexOf(text) > -1 || item[field].indexOf(upperText) > -1) {
                            ifMatch = true;
                            break;
                        }
                    }
                    if (ifMatch) {
                        if (tagVisibleRows.indexOf(item) < 0) ifMatch = false;
                    }

                    if (ifMatch) {
                        item.target.show();
                    } else {
                        item.target.hide();
                    }
                    ifGroupMatch = ifGroupMatch || ifMatch;
                }

                if (ifGroupMatch) {
                    group.target.show();
                } else {
                    group.target.hide();
                }
            }
        },
        /**
         * 获取选中的标签
         */
        getSelectedTags: function() {
            var tags = [];
            $.each(this.tagContainer.find('.careprovider-tag-selected'), function(i, e) {
                var tag = $(e).data('data');
                if (tag) tags.push(tag);
            });
            return tags;
        },
        /**
         * 获取根据标签筛选后可见性为true的数据
         */
        getTagVisibleRows: function() {
            var rows = [];
            var tags = this.getSelectedTags();
            for (var i = 0, length = tags.length; i < length; i++) {
                rows = rows.concat(tags[i].items);
            }

            return rows;
        }
    };

    /**
     * 对数据进行分组
     */
    function groupingData(data, field) {
        var groupDic = [];
        var groups = [];
        var groupField = field;

        var length = data.length;
        var row, index;
        for (var i = 0; i < length; i++) {
            row = data[i];
            index = groupDic.indexOf(row[groupField]);
            if (index > -1) {
                groups[index].items.push(row);
            } else {
                groupDic.push(row[groupField]);
                groups.push({
                    key: row[groupField],
                    items: [row]
                })
            }
        }
        return groups;
    }

    /**
     * 对数据进行标签处理
     */
    function tagData(data, field) {
        var tagDic = [];
        var tags = [];
        var tagField = field;

        var length = data.length;
        var row, index, tagArray, tag, tagLength;
        for (var i = 0; i < length; i++) {
            row = data[i];
            tagArray = (row[tagField] || '').split(',');
            data[i].tags = tagArray;
            for (var j = 0, tagLength = tagArray.length; j < tagLength; j++) {
                tag = tagArray[j];
                if (tag) {
                    index = tagDic.indexOf(tag);
                    if (index > -1) {
                        tags[index].items.push(row);
                    } else {
                        tagDic.push(tag);
                        tags.push({
                            key: tag,
                            items: [row]
                        })
                    }
                }
            }
        }
        return tags;
    }

    function alphabetCompare(propertyName) {
        return function(object1, object2) {
            var value1 = object1[propertyName][0] || '';
            var value2 = object2[propertyName][0] || '';

            return value1 > value2 ? 1 : -1;
        };
    }

    function numericCompare(propertyName) {
        return function(object1, object2) {
            var value1 = object1[propertyName];
            var value2 = object2[propertyName];

            if (value1 == '' || value1 == 'All') {
                return -1;
            } else if (value2 == '' || value2 == 'All') {
                return 1;
            } else if (Number(value1) > Number(value2)) {
                return 1;
            } else {
                return -1;
            }
        };
    }

    /**
     * 护士分组视图
     */
    var careproviderGroupView = {
        render: function(container, group) {
            container.data('data', group);
            group.target = container;

            $('<div class="careprovider-group-header"></div>')
                .append('<span class="header-text">' + group.key + '</span>')
                .appendTo(container);
            var itemsContainer = $('<div class="careprovider-group-items"></div>')
                .appendTo(container);
            var length = group.items.length;
            var element = null;
            for (var i = 0; i < length; i++) {
                element = $('<div class="careprovider-item"></div>')
                    .text(group.items[i]['Description'])
                    .attr('data-value', group.items[i].RowId)
                    .data('data', group.items[i])
                    .appendTo(itemsContainer);
                group.items[i].target = element;
            }
        }
    }

    /**
     * 卡片拖动的代理
     * @param {HTMLElement} source 
     */
    function proxy(source) {
        var p = $('<div style="z-index:20000;" class="careprovider-item careprovider-item-dragging"></div>');
        p.html($(source).clone().html()).appendTo('body');

        return p;
    }
})));