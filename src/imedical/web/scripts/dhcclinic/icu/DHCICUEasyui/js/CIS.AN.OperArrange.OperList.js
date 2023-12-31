/**
 * @author yongyang
 * @description 手术排班视图 手术列表
 */
(function(global, factory) {
    factory((global.OperScheduleList = {}));
}(this, (function(exports) {

    var _id = 0;

    var _methods = {};

    /**
     * 初始化方法，外部调用：OperScheduleList.init(...);
     * 暂时没有考虑传入的元素已经绑定的情况
     * @param {HTMLElement} dom 
     * @param {object} opt 
     * @returns 
     */
    function init(dom, opt) {
        _id++;

        var cardboard = new OperScheduleList(dom, opt);

        return cardboard;
    }

    exports.init = init;

    var defaultOptions = {
        fit: true,
        width: 'auto',
        height: 'auto',
        multipleSelection: false,
        groupBy: {},
        sortBy: {},
        filterForm: {
            items: [{

                },
                []
            ]
        },
        menu: {
            items: [{}]
        },
        operCard: {
            header: null,
            content: null,
            footer: null
        },

    }

    /**
     * @description 构造函数
     * @author yongyang 2018-03-06
     * @module OperScheduleList
     * @constructor
     * @param {HTMLElement} dom 
     * @param {object} opt 
     */
    function OperScheduleList(dom, opt) {
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
         * @property {Array.<OperCard>} 包含的手术卡片数组
         * @private
         */
        this.cards = [];

        /**
         * @type {HTMLElement}
         * @private
         */
        this._menu = null;

        /**
         * @type {HTMLElement}
         * @private
         */
        this.toolkitContainer = null;

        /**
         * @type {module: Toolkit}
         * @private
         */
        this.toolkit = null;

        /**
         * @type {HTMLElement}
         * @private 
         */
        this.cardsContainer = null;

        this.onQuery = null;

        this._init();
        this.setOptions(opt);
    }

    var proto = OperScheduleList.prototype;

    /** 
     * 初始化
     * @private
     */
    proto._init = function() {
        var _this = this;
        this.toolkitContainer = $('<div class="oper-cardboard-toolkit"></div>');
        this.dom.append(this.toolkitContainer);



        this.badgeContainer = $('<div style="padding:5px;font-size:11px;color:#999;">共<span class="oper-cardboard-badge-all" style="font-weight:bold;color:#000;margin:0 3px;"></span>台，筛选结果：<span class="oper-cardboard-badge-filtered" style="font-weight:bold;color:#6798E9;margin:0 3px;"></span>台</div>');
        this.dom.append(this.badgeContainer);

        this.cardsContainer = $('<div class="oper-cardboard-container"></div>');
        this.mask = $('<div class="window-mask" style="display:none; z-index:9000;text-align:center;"></div>')
            .append('<i class="fas fa-refresh" style="line-height:320px;color:#fff;font-size:50px;"></i>').appendTo(this.cardsContainer);
        this.dom.append(this.cardsContainer);

        this.cardsContainer.droppable({
            accept: '.oper-arranged',
            onDragEnter: function(e, source) {
                $(this).addClass('droppable-dragenter');
            },
            onDragLeave: function(e, source) {
                $(this).removeClass('droppable-dragenter');
            },
            onDrop: function(e, source) {
                var operSchedule = $(source).data('data');
                if (_this.options.onDrop) {
                    _this.options.onDrop.call(_this, operSchedule);
                }
                $(this).removeClass('droppable-dragenter');
                $(this).removeClass('droppable-focus');
            }
        });

        this._menu = $('<div></div>');
        $('body').append(this._menu);
        $(this._menu).mouseenter(function() {
            _this.markAllSelectedCards();
        });
        $(this._menu).mouseleave(function() {
            _this.unmarkAllSelectedCards();
        });
    }

    /**
     * 设置选项
     * @type {Function(object)}
     * @param {object} options
     */
    proto.setOptions = function(options) {
        var _this = this;
        $.extend(this.options, options);

        this.onQuery = this.options.onQuery;
        this.onMenuItemClick = this.options.menu.onClick;
        this.onMoveCard = this.options.onMoveCard;

        this.toolkit = new Toolkit(this.toolkitContainer, this, this.options);
        //this.cardsContainer.height(this.dom.height() - this.toolkitContainer.height() - 10); //采用响应式布局，不在JS中设置固定高度

        generateMenu(this._menu, this.options.menu);
        this._menu.menu({
            onClick: function(item) {
                var operCard = $(this).data('opercard');
                var opt = $(item.target).data('options');

                if (opt.onClick) {
                    opt.onClick.call(item, operCards);
                }
                if (_this.onMenuItemClick) {
                    _this.onMenuItemClick.call(_this, operCard, opt.bindedData);
                }
            },
            onShow: function() {
                var bindedOperCard = $(this).data('opercard');
                var statusCode = bindedOperCard.bindedData.OperStatusCode;
                var itemOptions = null;
                var _this = $(this);
                _this.children('div.menu-item').each(function(index, itemEl) {
                    itemOptions = $(itemEl).data('options');
                    if (itemOptions.activeStatuses && itemOptions.activeStatuses.indexOf(statusCode) == -1) {
                        _this.menu('disableItem', itemEl);
                    } else {
                        _this.menu('enableItem', itemEl);
                    }
                });
            },
            onHide: function() {
                var bindedOperCard = $(this).data('opercard');
                bindedOperCard.unmark();
            }
        });

        this.render();
    };


    /**
     * 生成菜单
     * @param {HTMLElement} parent 
     * @param {object} opt 
     */
    function generateMenu(parent, opt) {
        if ($.isArray(opt.items))
            $.each(opt.items, function(index, item) {
                parent.append(generateMenuItem(item));
            });
    }

    /**
     * 生成菜单项
     * @param {object} opt 
     */
    function generateMenuItem(opt) {
        var menuItem = $('<div></div>').html('<span>' + opt.text + '</span>');
        if (opt.id) {
            menuItem.attr('data-id', opt.id);
            menuItem.id = opt.id;
        }
        menuItem.data('options', opt);
        //console.log(menuItem.attr('data-id')+"/"+menuItem.html());
        if ($.isArray(opt.items)) {
            var subMenu = $('<div></div>');
            menuItem.append(subMenu);
            generateMenu(subMenu, opt);
        }
        return menuItem;
    }
    /**
     * 加载数据，会将以前的数据全部清除
     * @type {Function}
     */
    proto.loadData = function(operScheduleArray) {
        this.bindedData = operScheduleArray;
        this.dataGroups = [];

        if (!$.isArray(this.bindedData)) return;

        this.toolkit.reconstructData(this.bindedData);
        this.toolkit.clearFilter();
        this.render();
    };

    /**
     * 更新数量徽章
     */
    proto.refreshBadge = function(number) {
        this.badgeContainer.find('.oper-cardboard-badge-all').text((this.bindedData || []).length);
        this.badgeContainer.find('.oper-cardboard-badge-filtered').text(number || (this.bindedData || []).length);
    };

    /**
     * 增加一条数据，添加至以前的数据中
     * @type {Function}
     */
    proto.addData = function(operSchedule) {
        if (!$.isArray(this.bindedData)) this.bindedData = [];
        this.bindedData.push(operSchedule);
        this.dataGroups = [];

        this.toolkit.reconstructData(this.bindedData);
        this.toolkit.clearFilter();
        this.render();
    };

    /**
     * 初始化分组配置
     * @param {*} groupBy 
     */
    proto.initGrouping = function(groupBy) {
        this.groupBy = groupBy;
    }

    /**
     * 初始化排序配置
     * @param {*} sortBy 
     */
    proto.initSorting = function(sortBy) {
        this.sortBy = sortBy;
    }

    /**
     * 重置分组
     */
    proto.resetGrouping = function(groupBy) {
        this.groupBy = groupBy;
        this.render();
    }

    /**
     * 重置排序
     */
    proto.resetSorting = function(sortBy) {
        this.sortBy = sortBy;
        this.render(true);
    }

    /**
     * 渲染
     */
    proto.render = function(onlySort) {
        this.cardsContainer.hide();
        this.cardsContainer.empty();

        if (onlySort) this.sortingData()
        else this.groupingData();

        this.generateCards();
        this.toolkit.filterCards();

        this.cardsContainer.show();
    }

    /**
     * 对数据进行分组
     */
    proto.groupingData = function() {
        var groupBy = this.groupBy || {};
        var groups = {};
        var dataGroups = [];
        var excepted = [];

        if (groupBy.key) {
            for (var i = 0, length = this.bindedData.length; i < length; i++) {
                var row = this.bindedData[i];
                var groupIndexText = row[groupBy.textField];
                if (groupIndexText) {
                    var groupIndex = Number(row[groupBy.key]);
                    if (!groups[groupIndex]) groups[groupIndex] = [];
                    groups[groupIndex].push(row);
                } else {
                    excepted.push(row);
                }
            }
        } else {
            groups[0] = this.bindedData;
        }

        var sortBy = this.sortBy || {};
        for (var groupIndex in groups) {
            dataGroups.push({
                key: groupIndex,
                text: groupBy.textField ? groups[groupIndex][0][groupBy.textField] : groupBy.text,
                rows: sortData(groups[groupIndex], sortBy)
            });
        }

        if (excepted.length > 0) {
            dataGroups.push({
                key: '',
                text: groupBy.exceptedText,
                rows: excepted
            })
        }

        this.dataGroups = dataGroups.sort(stringCompareInstance('text', 'ASC'));
    };

    /**
     * 对数据进行排序
     */
    proto.sortingData = function() {
        var dataGroups = this.dataGroups;
        var sortBy = this.sortBy;
        var group;
        for (var i = 0, length = dataGroups.length; i < length; i++) {
            group = dataGroups[i];
            group.rows = sortData(group.rows, sortBy);
        }
    }

    /**
     * 排序(按文本简单组合排序)
     * @param {Array<object>} data
     * @param {object} sortBy 
     */
    function sortData(data, sortBy) {
        var sorts = {};
        var sorted = [];

        switch (sortBy.compareMethod) {
            case 'string':
                sorted = data.sort(stringCompareInstance(sortBy.field, sortBy.direction));
                break;
            case 'number':
                sorted = data.sort(numberCompareInstance(sortBy.field, sortBy.direction));
                break;
            default:
                sorted = simplySort(data, sortBy.field);
                break;
        }

        return sorted;
    }

    /**
     * 按文本简单组合排序
     */
    function simplySort(data, field) {
        var sorts = {};
        var sorted = [];
        var groupIndex = [];
        var groups = {};
        var length = data.length;

        for (var i = 0; i < length; i++) {
            var row = data[i];
            var key = groupIndex.indexOf(row[field]);
            if (key < 0) {
                groupIndex.push(row[field]);
                key = groupIndex.length - 1;
            }
            if (!groups[key]) groups[key] = [];
            groups[key].push(row);
        }

        for (var key in groups) {
            sorted = sorted.concat(groups[key]);
        }
        return sorted;
    }

    /**
     * 文本排序比较方法实例
     * @param {*} field 
     * @returns 
     */
    function stringCompareInstance(field, direction) {
        return function(row1, row2) {
            var value1 = row1[field];
            var value2 = row2[field];
            var factor = direction == 'DESC' ? -1 : 1;
            if (value1 == '' || !value1) {
                return 1 * factor;
            } else if (value2 == '' || !value1) {
                return -1 * factor;
            } else {
                return value1.localeCompare(value2) * factor;
            }
        }
    }

    /**
     * 数字排序比较方法实例 
     */
    function numberCompareInstance(field, direction) {
        return function(row1, row2) {
            var value1 = row1[field];
            var value2 = row2[field];
            var match = /\d+/.exec(value1);
            var value1 = match ? Number(match[0]) : 0;
            var match = /\d+/.exec(value2);
            var value2 = match ? Number(match[0]) : 0;
            var factor = direction == 'DESC' ? -1 : 1;
            if (value1 == '' || value1 == 'All') {
                return 1 * factor;
            } else if (value2 == '' || value2 == 'All') {
                return -1 * factor;
            } else if (Number(value1) > Number(value2)) {
                return 1 * factor;
            } else {
                return -1 * factor;
            }
        }
    }

    /**
     * 生成卡片
     */
    proto.generateCards = function() {
        var _this = this;
        this.groups = [];

        var cardOption = _this.options.operCard;
        $.extend(cardOption, {
            menu: _this._menu
        });

        var cards = [];
        var card, group;
        var length = this.dataGroups.length;

        for (var i = 0; i < length; i++) {
            var dataGroup = this.dataGroups[i];
            var rowLength = dataGroup.rows.length;
            group = new OperCardGroup(dataGroup);
            _this.appendGroup(group);

            for (var j = 0; j < rowLength; j++) {
                var row = dataGroup.rows[j];
                card = new OperCard(_this, group, row, cardOption);
                cards.push(card);
                group.appendCard(card);
            }
        }
        this.cards = cards;
    };

    /**
     * 添加卡片分组
     * @param {Module<OperCardGroup>} group 
     */
    proto.appendGroup = function(group) {
        this.cardsContainer.append(group.dom);
        this.groups.push(group);
    };

    /**
     * 添加数据
     */
    proto.appendData = function(operScheduleArray) {

    };
    /**
     * 清空所有数据
     */
    proto.clear = function() {

    };
    /** 
     * 显示单个卡片
     * @param {data.OperSchedule | string} operSchedule 手术安排:对象、ID
     */
    proto.showCard = function(operSchedule) {

    };
    /**
     * 显示全部卡片
     */
    proto.showAllCards = function() {

    };
    /**
     * 隐藏单个卡片
     * @param {data.OperSchedule | string} operSchedule 手术安排：对象、ID
     */
    proto.hideCard = function(operSchedule) {

    };
    /**
     * 隐藏全部卡片
     */
    proto.hideAllCards = function() {

    };
    /**
     * 隐藏单个卡片
     * @param {data.OperSchedule | string} operSchedule 手术安排：对象、ID
     */
    proto.disableCard = function(operSchedule) {

    };
    /**
     * 隐藏单个卡片
     * @param {data.OperSchedule | string} operSchedule 手术安排ID：对象、ID
     */
    proto.enableCard = function(operSchedule) {

    };
    /**
     * 获取所有选中的卡片
     */
    proto.getAllSelectedCards = function() {
        var result = [];
        $.each(this.cards, function(index, card) {
            if (card.visible && card.selected) result.push(card);
        });

        return result;
    };
    /**
     * 筛选手术卡片
     * @param {Array<Data.OperSchedule>} filterFieldValues 筛选时需要的字段及可以显示手术卡片的字段对应值
     * @return {Array<OperCard>}
     */
    proto.filter = function(filterFieldValues) {
        var result = [];
        $.each(this.cards, function(index, card) {
            if (card.filter(filterFieldValues)) result.push(card);
        });

        return result;
    };

    /**
     * 筛选并显示手术卡片
     * @param {object} filterFieldValues 
     */
    proto.filterAndShow = function(filterFieldValues) {
        var hasVisibleCard = false;
        var visibleNumber = 0;
        $.each(this.cards, function(index, card) {
            if (card.filter(filterFieldValues)) {
                hasVisibleCard = true;
                card.show();
                visibleNumber++;
            } else card.hide();
        });

        this.refreshBadge(visibleNumber + '');

        var length = this.groups.length;
        for (var i = 0; i < length; i++) {
            this.groups[i].refreshBadge();
        }
    };

    /**
     * 设置placeholder
     */
    proto.setPlaceholder = function(card) {
        $('.placeholder').remove();
        var placeholder = $('<div class="oper-card placeholder"></div>');
        placeholder.height(card.size().height);
        $(card.getDom()).before(placeholder);
        var _this = this;
        placeholder.droppable({
            accept: '.oper-card',
            onDragEnter: function(e, source) {

            },
            onDragLeave: function(e, source) {

            },
            onDrop: function(e, source) {
                _this.moveCards();
                $(this).before(source);
                $(source).show();
                _this.removePlaceholder();
            }
        });
        this.placeholderIndex = this.cards.indexOf(card);
        this.placeholderPos = this.placeholderIndex;
        this.originalIndex = this.placeholderIndex;
        this.placeholder = placeholder;
        this.currentSequnce = [];
    };
    /**
     * 保存位置信息
     */
    proto.restorePosition = function() {
        this.yAxises = [];
        var yAxises = this.yAxises;
        $.each(this.cards, function(index, card) {
            var position = card.position();
            yAxises.push(position.top);
        });
    };

    /**
     * 调整placeholder的位置
     * @param {*} y 
     */
    proto.coordinatePlaceholder = function(y) {
        var nextPos = 0;
        var length = this.yAxises.length;
        for (var i = 0; i < length; i++) {
            if (y > this.yAxises[i]) {
                nextPos = i;
                continue;
            } else break;
        }

        if (nextPos != this.placeholderPos && !this.cards[nextPos].fixed) {
            var func = this.originalIndex > nextPos ? 'before' : 'after';
            $(this.cards[nextPos].getDom())[func](this.placeholder);
            this.placeholderPos = nextPos;
        }

    };

    /**
     * 移除placeholder
     */
    proto.removePlaceholder = function() {
        if (this.placeholder) this.placeholder.remove();
    };

    /**
     * 移动卡片，最终调用
     */
    proto.moveCards = function() {
        var groupBy = this.options.groupBy;
        var cards = [];
        var changedCards = [];
        var length = this.cards.length;
        var sourceIndex = this.originalIndex;
        var targetIndex = this.placeholderPos;
        var direction = targetIndex > sourceIndex ? 1 : -1;

        if (sourceIndex === targetIndex) return;

        var sourceCard = this.cards[sourceIndex];
        var targetCard = this.cards[targetIndex];
        var sourceGroup = sourceCard.group;
        var targetGroup = targetCard.group;
        cards[targetIndex] = sourceCard;

        var IsOperRoomChanged = false;
        if (targetGroup != sourceGroup) {
            IsOperRoomChanged = true;
            var seq = targetCard.bindedData.OperSeq;
            seq = Number(seq) + (targetIndex > sourceIndex ? 1 : 0);
            sourceCard.bindedData.OperSeq = seq;
            sourceCard.group = targetGroup;
            sourceCard.bindedData[groupBy.key] = targetCard.bindedData[groupBy.key];
            sourceCard.bindedData[groupBy.textField] = targetCard.bindedData[groupBy.textField];
            sourceCard.refreshHeader();
        } else {
            sourceCard.bindedData.OperSeq = targetCard.bindedData.OperSeq;
            sourceCard.refreshHeader();
        }

        changedCards.push(sourceCard);

        for (var i = 0; i < length; i++) {
            var card = this.cards[i];
            if (i === sourceIndex) continue;
            else if ((direction * i) > (direction * sourceIndex) && (direction * i) <= (direction * targetIndex)) {
                cards[(i - direction)] = card;
                if (!IsOperRoomChanged ||
                    (IsOperRoomChanged &&
                        ((sourceIndex > targetIndex && card.group === targetGroup) ||
                            (targetIndex > sourceIndex && card.group === sourceGroup)))) {
                    var seq = card.bindedData.OperSeq;
                    seq = Number(seq) - direction;
                    card.bindedData.OperSeq = seq;
                    changedCards.push(card);
                    card.refreshHeader();
                }
            } else {
                cards[i] = card;
                if (IsOperRoomChanged &&
                    ((sourceIndex > targetIndex && card.group === sourceGroup) ||
                        (targetIndex > sourceIndex && card.group === targetGroup))) {
                    var seq = card.bindedData.OperSeq;
                    seq = Number(seq) + direction;
                    card.bindedData.OperSeq = seq;
                    changedCards.push(card);
                    card.refreshHeader();
                }
            }
        }

        this.cards = cards;

        if (this.onMoveCard) {
            this.onMoveCard.call(this, changedCards);
        }
    };

    /**
     * 选择卡片
     * @param {Module<OperCard> or string} cardOrId 
     */
    proto.selectCard = function(cardOrId) {
        if (typeof cardOrId === 'object') {
            var card = cardOrId;
            card.select();
        } else if (typeof cardOrId === 'string') {
            var length = this.cards.length;
            for (var i = 0; i < length; i++) {
                var card = this.cards[i]
                if (card.bindedData.RowId === cardOrId) {
                    card.select();
                    return;
                }
            }
        }
    };

    /**
     * 当选中卡片前调用
     * @param {Module<OperCard>} card 
     */
    proto.beforeSelectCard = function(card) {
        if (!this.options.multipleSelection) {
            this.clearCardSelection();
        }
    };

    /**
     * 清楚卡片选择
     */
    proto.clearCardSelection = function() {
        $.each(this.cards, function(i, card) {
            card.unselect();
        });
    };

    /**
     * 当选中卡片时调用
     * @param {Module<OperCard>} card 
     */
    proto.onSelectCard = function(card) {
        var callback = this.options.onSelectCard;
        if (callback) {
            callback.call(this, card);
        }
    };

    /**
     * 获取选中的卡片集合
     */
    proto.getSelectedCards = function() {
        var cards = [];
        $.each(this.cards, function(i, card) {
            if (card.selected) cards.push(card);
        });

        return cards;
    };

    /**
     * 标记所有选中的卡片
     */
    proto.markAllSelectedCards = function() {
        $.each(this.cards, function(i, card) {
            if (card.selected) card.mark();
        })
    };

    /**
     * 取消标记所有选中的卡片
     */
    proto.unmarkAllSelectedCards = function() {
        $.each(this.cards, function(i, card) {
            if (card.selected) card.unmark();
        })
    };

    /**
     * 移除手术
     * @param {*} operSchedule 
     */
    proto.removeData = function(operSchedule) {
        var matchedCard = null,
            index = -1;
        $.each(this.cards, function(i, card) {
            if (card.bindedData == operSchedule) {
                matchedCard = card;
                index = i;
                return false;
            }
        });
        if (matchedCard) {
            matchedCard.remove();
            matchedCard.group.removeCard(matchedCard);
            matchedCard.group.refreshBadge();
            this.cards.splice(index, 1);
            index = this.bindedData.indexOf(operSchedule);
            if (index > -1) this.bindedData.splice(index, 1);
            this.refreshBadge();
        }
    }

    /**
     * 初始化工具栏
     * @param {*} dom 
     * @param {*} parent 
     * @param {*} opt 
     */
    function Toolkit(dom, parent, opt) {
        this.options = opt;
        this.dom = dom;
        this.parent = parent;
        this.items = [];
        this.selectedGroupBy = null;
        this.selectedSortBy = null;
        this._init();
    }

    Toolkit.prototype = {
        constructor: Toolkit,
        _init: function() {
            var container = $('<div class="ocb-toolkit-header"></div>').appendTo(this.dom);
            this.groupByContainer = $('<div class="oper-cardboard-groupby"><div>').appendTo(container);
            $('<span class="ocb-toolkit-gsv-btn-open"></span>').appendTo(this.dom);
            this.sortByContainer = $('<div class="oper-cardboard-sortby"><div>').appendTo(container);
            $('<span class="ocb-toolkit-ssv-btn-open"></span>').appendTo(this.dom);

            var form = $('<form class="oper-cardboard-form"></form>').appendTo(this.dom);

            this.filterForm = new FilterForm(this.dom.children('form'), this.parent, this.options.filterForm);
            this._initHeader();
            this._initGroupBySelectionView();
            this._initSortBySelectionView();
            this._initEventHandler();
        },
        _initHeader: function() {
            var container = this.groupByContainer;
            var groupBy = this.options.groupBy || {};
            dictionary = groupBy.dictionary || [];
            var item = null;
            for (var i = 0, length = dictionary.length; i < length; i++) {
                item = dictionary[i];
                if (item.active) {
                    this.selectedGroupBy = item;
                    this.renderGroupBy();
                }
            }

            this.parent.initGrouping(this.selectedGroupBy);

            var container = this.sortByContainer;
            var sortBy = this.options.sortBy || {};
            dictionary = sortBy.dictionary || [];
            for (var i = 0, length = dictionary.length; i < length; i++) {
                item = dictionary[i];
                if (item.active) {
                    this.selectedSortBy = item;
                    this.renderSortBy();
                }
            }

            this.parent.initSorting(this.selectedSortBy);
        },
        _initGroupBySelectionView: function() {
            this.groupBySelectionView = $('<div class="ocb-toolkit-groupbyselection" style="display:none;"></div>').appendTo('body');

            var container = $('<div class="ocb-toolkit-s-container"></div>').appendTo(this.groupBySelectionView);

            var groupBy = this.options.groupBy || {};
            var header, content, dictionary, element, item;
            content = $('<div class="ocb-toolkit-s-content"></div>').appendTo(container);

            dictionary = groupBy.dictionary || [];
            for (var i = 0, length = dictionary.length; i < length; i++) {
                item = dictionary[i];
                element = $('<span class="ocb-toolkit-s-gb-i ocb-toolkit-s-i"></span>')
                    .text(item.text)
                    .attr('data-value', item.key)
                    .appendTo(content);
                if (item.active) element.addClass('ocb-toolkit-s-i-selected');
                element.data('data', item);
                item.target = element;
            }
        },
        _initSortBySelectionView: function() {
            this.sortBySelectionView = $('<div class="ocb-toolkit-sortbyselection" style="display:none;"></div>').appendTo('body');

            var sortBy = this.options.sortBy || {};
            var header, content, dictionary, element, item;
            var container = $('<div class="ocb-toolkit-s-container"></div>').appendTo(this.sortBySelectionView);
            content = $('<div class="ocb-toolkit-s-content"></div>').appendTo(container);

            dictionary = sortBy.dictionary || [];
            for (var i = 0, length = dictionary.length; i < length; i++) {
                item = dictionary[i];
                element = $('<span class="ocb-toolkit-s-sb-i ocb-toolkit-s-i"></span>')
                    .text(item.text)
                    .append('<span class="tag-direction"><span class="tag-asc" title="顺序"/><span class="tag-desc" title="逆序"/></span>')
                    .attr('data-value', item.field)
                    .appendTo(content);
                if (item.ability && !item.ability.asc) element.find('.tag-asc').addClass('tag-direction-disabled').attr('title', '禁止顺序');
                if (item.ability && !item.ability.desc) element.find('.tag-desc').addClass('tag-direction-disabled').attr('title', '禁止逆序');
                element.data('data', item);
                if (item.active) element.addClass('ocb-toolkit-s-i-selected');
                item.target = element;
            }
        },
        _initEventHandler: function() {
            var _this = this;
            this.dom.delegate('.ocb-toolkit-gsv-btn-open', 'click', function() {
                $(this).addClass('ocb-toolkit-gsv-btn-open-active');
                _this.showGroupBySelectionView();
            });
            this.dom.delegate('.ocb-toolkit-ssv-btn-open', 'click', function() {
                $(this).addClass('ocb-toolkit-ssv-btn-open-active');
                _this.showSortBySelectionView();
            });
            this.dom.delegate('.ocb-toolkit-sb-i .ocb-toolkit-direction', 'click', function() {
                $(this).removeClass('tag-direction-disabled');
                $(this).toggleClass('tag-asc');
                $(this).toggleClass('tag-desc');

                var sortBy = $(this).parent().data('data');
                if ($(this).hasClass('tag-asc')) {
                    sortBy.direction = 'ASC';
                    $(this).attr('data-value', 'ASC');
                    $(this).attr('title', '顺序');
                    if (sortBy.ability && !sortBy.ability.asc) {
                        $(this).addClass('tag-direction-disabled');
                        $(this).attr('title', '禁止顺序');
                        sortBy.direction = 'DESC';
                    }
                } else {
                    sortBy.direction = 'DESC';
                    $(this).attr('title', '逆序');
                    if (sortBy.ability && !sortBy.ability.asc) {
                        $(this).addClass('tag-direction-disabled');
                        $(this).attr('title', '禁止逆序');
                        sortBy.direction = 'ASC';
                    }
                }

                _this.onSortByChange();
            });

            this.groupByContainer.delegate('.ocb-toolkit-gb-i .tagbox-remove', 'click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                var item = $(this).parent().data('data');
                _this.removeGroupBy(item);
            });

            this.sortByContainer.delegate('.ocb-toolkit-sb-i .tagbox-remove', 'click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                var item = $(this).parent().data('data');
                _this.removeSortBy(item);
            });

            this.groupBySelectionView.on('mouseleave', function() {
                $(this).hide();
                _this.dom.find('.ocb-toolkit-gsv-btn-open').removeClass('ocb-toolkit-gsv-btn-open-active');
            });

            this.sortBySelectionView.on('mouseleave', function() {
                $(this).hide();
                _this.dom.find('.ocb-toolkit-ssv-btn-open').removeClass('ocb-toolkit-ssv-btn-open-active');
            });

            this.groupBySelectionView.delegate('.ocb-toolkit-s-gb-i', 'click', function() {
                _this.groupBySelectionView.find('.ocb-toolkit-s-i-selected').removeClass('ocb-toolkit-s-i-selected');
                $(this).addClass('ocb-toolkit-s-i-selected');
                var groupBy = $(this).data('data');
                if (_this.selectedGroupBy != groupBy) _this.setGroupBy(groupBy);
                _this.groupBySelectionView.hide();
                _this.dom.find('.ocb-toolkit-gsv-btn-open').removeClass('ocb-toolkit-gsv-btn-open-active');
            });

            this.sortBySelectionView.delegate('.ocb-toolkit-s-sb-i', 'click', function() {
                _this.sortBySelectionView.find('.ocb-toolkit-s-i-selected').removeClass('ocb-toolkit-s-i-selected');
                $(this).addClass('ocb-toolkit-s-i-selected');
                var sortBy = $(this).data('data');
                if (_this.selectedSortBy != sortBy) _this.setSortBy(sortBy);
                _this.sortBySelectionView.hide();
                _this.dom.find('.ocb-toolkit-ssv-btn-open').removeClass('ocb-toolkit-ssv-btn-open-active');
            });
        },
        showGroupBySelectionView: function() {
            this.groupBySelectionView.show();
        },
        showSortBySelectionView: function() {
            this.sortBySelectionView.show();
        },
        setGroupBy: function(item) {
            this.selectedGroupBy = item;
            this.renderGroupBy();
            this.onGroupByChange();
        },
        renderGroupBy: function() {
            var container = this.groupByContainer;
            container.empty();
            var item = this.selectedGroupBy;
            $('<span class="ocb-toolkit-gb-i ocb-toolkit-i"></span>')
                .text(item.text)
                .append('<a href="javascript:;" class="tagbox-remove" title="移除分组\'' + item.text + '\'"></a>')
                .attr('data-value', item.key)
                .data('data', item)
                .appendTo(container);
        },
        setSortBy: function(item) {
            this.selectedSortBy = item;
            this.renderSortBy();
            this.onSortByChange();
        },
        renderSortBy: function() {
            var container = this.sortByContainer;
            container.empty();
            var item = this.selectedSortBy;
            $('<span class="ocb-toolkit-sb-i ocb-toolkit-i"></span>')
                .text(item.text)
                .append('<span class="ocb-toolkit-direction tag-asc" title="顺序" data-value="ASC"></span>')
                .append('<a href="javascript:;" class="tagbox-remove" title="移除排序\'' + item.text + '\'"></a>')
                .attr('data-value', item.field)
                .data('data', item)
                .appendTo(container);
        },
        removeGroupBy: function(item) {
            var container = this.groupByContainer;
            container.empty();
            container.append('&nbsp;');
            this.selectedGroupBy = this.options.groupBy.default;
            this.onGroupByChange();
        },
        removeSortBy: function(item) {
            var container = this.sortByContainer;
            container.empty();
            container.append('&nbsp;');
            this.selectedSortBy = this.options.sortBy.default;
            this.onSortByChange();
        },
        onGroupByChange: function() {
            this.parent.resetGrouping(this.selectedGroupBy);
        },
        onSortByChange: function() {
            this.parent.resetSorting(this.selectedSortBy);
        },
        filterCards: function() {
            this.filterForm.filterCards();
        },
        reconstructData: function(data) {
            this.filterForm.reconstructData(data);
        },
        clearFilter: function() {
            this.filterForm.clearSelectedTags();
        }
    }

    /**
     * 初始化筛选条件表单
     * @module OperScheduleCardboard~FilterForm
     * @param {HTMLElement} dom 
     * @param {Module<OperScheduleCardboard>} parent 
     * @param {object} opt 
     */
    function FilterForm(dom, parent, opt) {
        this.options = opt;
        this.dom = dom;
        this.parent = parent;
        this.items = [];
        this._init();
    }

    FilterForm.prototype = {
        constructor: FilterForm,

        /**
         * 初始化，生成表单项
         */
        _init: function() {
            var formRow, formItem;
            var _this = this;

            if (_this.options.items) {
                $.each(_this.options.items, function(i, e) {
                    formRow = $('<div class="ocb-form-row"></div>');
                    _this.dom.append(formRow);

                    if ($.isArray(e)) {
                        $.each(e, function(j, ee) {
                            formItem = new FormItem(formRow, ee, function(newValue, oldValue) {
                                if (this.options.remote) _this.triggerQuery();
                                else _this.filterCards();
                            });
                            _this.items.push(formItem);
                        })
                    } else if (typeof e === 'object') {
                        formItem = new FormItem(formRow, e, function(newValue, oldValue) {
                            if (this.options.remote) _this.triggerQuery();
                            else _this.filterCards();
                        });
                        _this.items.push(formItem);
                    }
                });
            }

            this._initTagContainer();
            this._initTagSelectionView();
            this._initTagEventHandler();
        },
        /**
         * 初始化标签容器
         */
        _initTagContainer: function() {
            this.selectedTags = [];
            this.tagContainer = $('<div class="ocb-form-tagcontainer"></div>').appendTo(this.dom);
            $('<span class="ocb-form-ts-btn-open"></span>').appendTo(this.tagContainer);
            if (!this.options.tags) this.tagContainer.hide();
        },
        /**
         * 初始化标签选项对话框
         */
        _initTagSelectionView: function() {
            this.tagSelectionView = $('<div class="ocb-form-tagselection" style="display:none;"></div>').appendTo('body');

            var container = $('<div class="ocb-form-ts-container"></div>').appendTo(this.tagSelectionView);
            var tags = this.options.tags || [];
            var row, rowEl, rowHeader, rowContent, element, item;
            for (var i = 0, rowLength = tags.length; i < rowLength; i++) {
                row = tags[i];
                rowEl = $('<div class="ocb-form-ts-row"></div>').appendTo(container);
                rowEl.data('data', row);
                row.target = rowEl;

                if (row.autoConstruct) rowEl.addClass('ocb-form-ts-r-auto');

                rowHeader = $('<div class="ocb-form-ts-r-header"></div>').appendTo(rowEl);
                rowContent = $('<div class="ocb-form-ts-r-content"></div>').appendTo(rowEl);

                $('<span class="ocb-form-ts-r-title"></span>').text(row.title).appendTo(rowHeader);
                for (var j = 0, length = row.data.length; j < length; j++) {
                    item = row.data[j];
                    element = $('<span class="ocb-form-ts-i tag-i"></span>')
                        .text(item.text)
                        .attr('data-value', item.value)
                        .appendTo(rowContent);
                    element.data('data', item);
                    item.target = element;
                }
            }
        },
        _initTagEventHandler: function() {
            var _this = this;
            this.tagContainer.delegate('.ocb-form-ts-btn-open', 'click', function() {
                _this.showSelectionView();
            });

            this.tagContainer.delegate('.ocb-form-tc-i .tagbox-remove', 'click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                var tag = $(this).parent().data('data');
                _this.removeTag(tag);
            });

            this.tagContainer.delegate('.ocb-form-tc-i', 'dblclick', function() {
                var tag = $(this).data('data');
                _this.removeTag(tag);
            });

            this.tagSelectionView.on('mouseleave', function() {
                $(this).hide();
            });

            this.tagSelectionView.delegate('.ocb-form-ts-i', 'click', function() {
                $(this).toggleClass('ocb-form-ts-i-selected');
                var tag = $(this).data('data');
                if ($(this).hasClass('ocb-form-ts-i-selected')) {
                    _this.addTag(tag);
                } else {
                    _this.removeTag(tag);
                }
            });
        },
        addTag: function(tag) {
            var index = this.selectedTags.indexOf(tag);
            if (index < 0) {
                this.selectedTags.push(tag);
                $('<span class="ocb-form-tc-i tag-i"></span>')
                    .text(tag.text)
                    .append('<a href="javascript:;" class="tagbox-remove" title="移除标签\'' + tag.text + '\'"></a>')
                    .attr('data-value', tag.value)
                    .data('data', tag)
                    .appendTo(this.tagContainer);
                this.filterCards();
            }
        },
        removeTag: function(tag) {
            var index = this.selectedTags.indexOf(tag);
            if (index > -1) {
                this.selectedTags.splice(index, 1);
                $(this.tagContainer.find('.ocb-form-tc-i')[index]).remove();
                this.filterCards();
                tag.target.removeClass('ocb-form-ts-i-selected');
            }
        },
        showSelectionView: function() {
            this.tagSelectionView.show();
        },
        clearSelectedTags: function() {
            this.selectedTags = [];
            this.tagContainer.find('.ocb-form-tc-i').remove();
            this.tagSelectionView.find('.ocb-form-ts-i-selected').removeClass('ocb-form-ts-i-selected');
        },
        /**
         * 触发查询
         */
        triggerQuery: function() {
            if (this.parent.onQuery) {
                this.parent.onQuery();
            }
        },
        /**
         * 表单项目值被修改后,筛选卡片
         */
        filterCards: function() {
            var filterFieldValues = {};
            $.each(this.items, function(index, item) {
                var value = item.getValue();
                var field = item.valueField;
                if (item.isCheckbox) {
                    if (!filterFieldValues[field]) filterFieldValues[field] = {
                        field: field,
                        extraFields: item.extraFields,
                        exact: item.options.exact || false,
                        value: []
                    };
                    if (!(value == null)) filterFieldValues[field].value.push(value);
                } else {
                    filterFieldValues[field] = {
                        field: field,
                        extraFields: item.extraFields,
                        exact: item.options.exact || false,
                        value: value
                    }
                }
            });

            $.each(this.selectedTags, function(index, tag) {
                var value = tag.value;
                var field = tag.field;
                if (tag.exact) {
                    if (!filterFieldValues[field]) filterFieldValues[field] = {
                        field: field,
                        exact: tag.exact || false,
                        isNotNull: tag.isNotNull || false,
                        value: []
                    };
                    if (!(value == null)) filterFieldValues[field].value.push(value);
                } else {
                    if (!filterFieldValues[field]) filterFieldValues[field] = {
                        field: field,
                        exact: false,
                        isNotNull: tag.isNotNull || false,
                        value: value
                    };
                }
            });

            this.parent.filterAndShow(filterFieldValues);
        },
        /**
         * 重建选项数据
         */
        reconstructData: function(operScheduleArray) {
            this.reconstructFormItem(operScheduleArray);
            this.reconstructTagOpts(operScheduleArray);
        },
        /**
         * 重建FormItem的选项
         * @param {*} operScheduleArray 
         */
        reconstructFormItem: function(operScheduleArray) {
            $.each(this.items, function(i, item) {
                item.clearData();
                if ($.isArray(operScheduleArray))
                    $.each(operScheduleArray, function(j, operSchedule) {
                        item.appendData(operSchedule);
                    });
                item.reload();
            });
        },
        /**
         * 重建标签选项
         */
        reconstructTagOpts: function(operScheduleArray) {
            var _this = this;
            $.each(this.options.tags, function(i, tag) {
                if (tag.autoConstruct) {
                    _this.clearTagOpts(tag);
                    if ($.isArray(operScheduleArray))
                        $.each(operScheduleArray, function(j, operSchedule) {
                            if (tag.valueField) _this.addTagOpt(tag, operSchedule);
                        });
                }
            });
        },
        /**
         * 添加Tag标签
         */
        addTagOpt: function(tag, operSchedule) {
            var r = {
                field: tag.valueField,
                exact: true,
                value: operSchedule[tag.valueField],
                text: operSchedule[tag.textField] || '无'
            };
            var rowContent = tag.target.find('.ocb-form-ts-r-content');
            if (tag.data.indexOf(r.value) < 0) {
                tag.data.push(r.value);
                var element = $('<span class="ocb-form-ts-i tag-i"></span>')
                    .text(r.text)
                    .attr('data-value', r.value)
                    .appendTo(rowContent);
                r.target = element;
                element.data('data', r);
            }
        },
        /**
         * 清除Tag标签选项
         */
        clearTagOpts: function(tag) {
            tag.data = [];
            tag.target.find('.ocb-form-ts-r-content').empty();
        },
        appendOption: function(operSchedule) {
            $.each(this.items, function(i, item) {
                item.appendData(operSchedule);
                item.reload();
            });
        }
    }

    /**
     * 筛选表单的表单项
     * @module OperScheduleCardboard~FilterForm
     * @param {HTMLElement} parent
     * @param {object} opt
     * @param {Function} onChange
     */
    function FormItem(parent, opt, onChange) {
        this.valueField = opt.valueField;
        this.textField = opt.textField;
        this.extraFields = opt.extraFields || [];
        this.type = opt.type;
        this.data = [];
        this.checked = opt.checked;
        this.parent = parent;
        this._desc = opt.desc;
        this.options = opt;
        this._onChange = onChange;
        this.dom = null;
        this.isCheckbox = ['checkbox', 'radio'].indexOf(this.type) > -1;
        this._init();
    }

    FormItem.prototype = {
        constructor: FormItem,
        /**
         * @param {HTMLElement} parent
         * @param {object} opt: 
         * [properties] |  [type]   |   [description]
         *  id          |  string   |   the id of the element, default is null
         *  valueField  |  string   |   a field of OperSchedule, required
         *  textField   |  string   |   a field of OperSchedule, required
         *  value       |  string   |   value of the input
         *  label       |  string   |   label text
         *  desc        |  string   |   one part of the combined text of the first option
         *  type        |  string   |   type of the input, the name of a plugin in hisui or easyui
         *  checked     |  boolean  |   when type is checkbox or radio, if checked is true then check the input
         *  prompt      |  string   |   displayed in the input
         * @param {function} onChange
         */
        _init: function() {
            var _this = this;
            this.dom = $('<input id="' + (this.options.id || '') + '" name="' + this.valueField + '" value="' + this.options.value + '">');
            if (this.type === 'switchbox') {
                this.dom = $('<div></div>');
            }

            this.dom.attr('type', this.type === 'checkbox' ? 'checkbox' :
                (this.type === 'radio' ? 'radio' : 'text'));

            var container = $('<span class="ocb-form-item"></span>')
                .append(this.dom)
                .appendTo(this.parent);

            if (this.options.float) {
                container.css({
                    float: this.options.float
                })
            }

            if (this.type && $HUI[this.type]) {

                this.clearData();

                $HUI[this.type](this.dom, $.extend({}, this.options, {
                    width: this.options.width || this.parent.width(),
                    onChange: function(newValue, oldValue) {
                        if (_this.options.onChange) {
                            _this.options.onChange.call(_this, newValue, oldValue);
                        }
                        _this._onChange();
                    },
                    onCheckChange: function(e, value) {
                        _this.checked = value; //HISUI 在onChange事件的时候没有先设置好input的值
                        _this._onChange();
                    },
                    onSwitchChange: function(e, value) {
                        _this._onChange();
                    },
                    valueField: 'value',
                    textField: 'text',
                    data: this.data
                }));

                if (['searchbox'].indexOf(this.type) > -1) {
                    var inputRect = this.dom.siblings('.searchbox');
                    $(inputRect).find('input').keyup(function() {
                        _this._onChange();
                    });
                }

                if (['validatebox'].indexOf(this.type) > -1) {
                    this.dom.keyup(function() {
                        _this._onChange();
                    });
                }
            }
        },
        /**
         * 获取值
         * @returns {string}
         */
        getValue: function() {
            var elementValue = $HUI[this.type](this.dom).getValue();

            if (this.type === 'checkbox' || this.type === 'radio') {
                if (this.checked) return $(this.dom).val();
                else return null;
            }

            if (['searchbox'].indexOf(this.type) > -1) {
                elementValue = $HUI[this.type](this.dom).getText();
            }

            if (['switchbox'].indexOf(this.type) > -1) {
                elementValue = elementValue ? this.options.onValue : this.options.offValue;
            }

            return elementValue;
        },
        /**
         * 添加数据到选项中
         */
        appendData: function(operSchedule) {
            var r = {
                value: operSchedule[this.valueField],
                text: operSchedule[this.textField] || '无'
            };

            if (!this.contain(r)) {
                this.data.push(r);
            }
        },
        /**
         * 判断值是否在数据选项中
         * @returns {boolean}
         */
        contain: function(r) {
            var found = false;
            $.each(this.data, function(i, row) {
                if (row.value === r.value) {
                    found = true;
                    return false;
                }
            });

            return found;
        },
        /**
         * 清除数据
         */
        clearData: function() {
            this.data = [];
            if (!this.options.remote)
                this.defaultData();
        },
        /**
         * 默认数据
         */
        defaultData: function() {
            this.data.push({
                value: this.options.value,
                text: this.options.text || this.options.value
            });
            /*if ($HUI[this.type](this.dom)['setValue']) {
                $HUI[this.type](this.dom)['setValue'](this.data.value);
            };*/
        },
        /**
         * 重载
         */
        reload: function() {
            if (this.options.sortable) {
                this.data.sort(numericCompare("value"));
            }
            if ($HUI[this.type](this.dom)['loadData']) {
                $HUI[this.type](this.dom)['loadData'](this.data);
            }
        }
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
     * 构造手术卡片分组
     * @param {object} group 
     */
    function OperCardGroup(group) {
        this.bindedData = group;
        this.cards = [];
        this.visibleCards = [];
        this.dom = null;
        this.header = null;
        this.body = null;
        this._init();
        return this;
    }

    OperCardGroup.prototype = {
        constructor: OperCardGroup,
        _init: function() {
            var _this = this;
            this.dom = $('<div class="oper-card-group"></div>');
            this.header = $('<div class="oper-card-group-header" title="双击选中科室内所有手术"></div>').appendTo(this.dom);
            this.body = $('<div class="oper-card-group-body"></div>').appendTo(this.dom);

            $('<span class="header-text"></span>')
                .text(this.bindedData.text)
                .appendTo(this.header);

            this.badge = $('<span class="header-badge"></span>').appendTo(this.header);
            this.dom.delegate('.oper-card-group-header', 'dblclick', function() {
                _this.select();
                _this.selectAllCards();
            });

            this.header.tooltip({
                position: 'top',
                showDelay: 2000
            });
        },
        /**
         * 添加卡片
         */
        appendCard: function(card) {
            this.cards.push(card);
            this.body.append(card.dom);
            if (card.visible) this.showCard(card);
        },
        select: function() {
            this.dom.addClass('oper-card-group-selected');
        },
        unselect: function() {
            this.dom.removeClass('oper-card-group-selected');
        },
        selectAllCards: function() {
            var qty = 0;
            var length = this.cards.length;
            var card;
            for (var i = 0; i < length; i++) {
                card = this.cards[i];
                if (card && card.visible) card.select();
            }
        },
        hideCard: function(card) {
            var index = this.visibleCards.indexOf(card);
            if (index > -1) this.visibleCards.splice(index, 1);
            this.adjustVisible();
        },
        showCard: function(card) {
            var index = this.visibleCards.indexOf(card);
            if (index < 0) this.visibleCards.push(card);
            this.adjustVisible();
        },
        adjustVisible: function() {
            if (this.visibleCards.length > 0) {
                this.dom.show();
            } else {
                this.dom.hide();
            }
        },
        removeCard: function(card) {
            var index = this.cards.indexOf(card);
            if (index > -1) this.cards.splice(index, 1);
            var index = this.visibleCards.indexOf(card);
            if (index > -1) this.visibleCards.splice(index, 1);
            var operSchedule = card.bindedData;
            var index = this.bindedData.rows.indexOf(operSchedule);
            if (index > -1) this.bindedData.rows.splice(index, 1);
        },
        refreshBadge: function() {
            var qty = 0;
            var length = this.cards.length;
            var card;
            for (var i = 0; i < length; i++) {
                card = this.cards[i];
                if (card.visible) qty++;
            }
            this.badge.text(qty);
            if (qty <= 0) this.dom.hide();
            else this.dom.show();
        }
    }

    /**
     * 构造手术卡片
     * @module OperScheduleCardboard~OperCard
     * @param {module: OperScheduleCardboard} parent
     * @param {module: Data.operSchedule} operSchedule 
     * @param {object} opt
     */
    function OperCard(parent, group, operSchedule, opt) {
        this.parent = parent;
        this.group = group;
        this.bindedData = operSchedule;
        this.selected = false;
        this.onDragging = false;
        this.visible = true;
        this.fixed = ['RoomIn', 'RoomOut', 'PACUIn', 'Finished'].indexOf(operSchedule.OperStatusCode) > -1;
        this.finished = ['RoomOut', 'PACUIn', 'Finished'].indexOf(operSchedule.OperStatusCode) > -1;
        this.processing = ['RoomIn'].indexOf(operSchedule.OperStatusCode) > -1;
        this.options = opt;
        this.dom = $('<div class="oper-card"></div>');
        this._menubutton = null;
        this.originalSize = { width: 0, height: 0 };
        this._init();
        //this.parent.cardsContainer.append(this.dom);
    }

    OperCard.prototype = {
        /**
         * 构造函数
         */
        constructor: OperCard,
        /**
         * 初始化方法
         * @private
         */
        _init: function() {
            var _this = this;
            this.dom.draggable({
                edge: 5,
                disabled: true,
                revert: true,
                proxy: proxy,
                onBeforeDrag: function(e) {
                    $(this).tooltip('hide');
                    $('.cancel-oper-area').addClass('cancel-oper-focus');
                },
                onStartDrag: function(e) {
                    if ($(this).data('draggable') && $(this).data('draggable')['droppables']) {
                        $($(this).data('draggable')['droppables']).addClass('droppable-focus');
                    }
                },
                onStopDrag: function(e) {
                    if ($(this).data('draggable') && $(this).data('draggable')['droppables']) {
                        $($(this).data('draggable')['droppables']).removeClass('droppable-focus');
                    }
                    $('.cancel-oper-area').removeClass('cancel-oper-focus');
                },
                onDrag: function(e) {
                    if ($(this).data('draggable')) {
                        if (typeof $(this).data('draggable')['droppables'] == 'undefined') {
                            $(this).data('draggable')['droppables'] = [];
                        }
                    } else {
                        $(this).data('draggable') = { handle: $(this), options: $(this).data('draggableOptions') };
                    }
                },
                onEndDrag: function(e) {
                    if ($(this).data('draggable') && $(this).data('draggable')['droppables']) {
                        $($(this).data('draggable')['droppables']).removeClass('droppable-focus');
                    }
                    $('.cancel-oper-area').removeClass('cancel-oper-focus');
                    $(this).removeClass('oper-card-dragging');
                    if ($(this).data('draggable')) $(this).draggable('disable');
                }
            });
            this._render();
            this.dom.data('draggableOptions', this.dom.draggable('options'));
        },
        /**
         * 渲染方法
         */
        _render: function() {
            var _this = this;

            if (this.fixed) this.dom.addClass('oper-card-fixed');
            if (this.finished) this.dom.addClass('oper-card-finished');
            if (this.processing) this.dom.addClass('oper-card-processing');

            this.dom.attr('data-opsId', this.bindedData.RowId);

            var idInput = $('<input type="hidden" name="RowId" value="' + this.bindedData.RowId + '">');
            this.dom.append(idInput);

            // var header = $('<div class="oper-card-header"></div>');
            // if (this.options.header || _methods.OperCard.header) {
            //     header.html((this.options.header || _methods.OperCard.header)(this.bindedData));
            //     this.dom.append(header);
            //     header.mouseenter(function() { _this.enableDrag(); });
            //     header.mouseleave(function() { _this.disableDrag(); });
            // }
            // this.header = header;

            var content = $('<div class="oper-card-content"></div>');
            content.html((this.options.content || _methods.OperCard.content)(this.bindedData));
            this.dom.append(content);

            var footer = $('<div class="oper-card-footer"></div>');
            var footerInnerHtml = (this.options.footer || _methods.OperCard.footer)(this.bindedData);
            if (footerInnerHtml) {
                footer.html(footerInnerHtml);
                this.dom.append(footer);
                this.dom.addClass('oper-card-multiline');
            }

            $('<a href="javascript:;" class="oper-card-move dragging-starter"><i class="fa fa-arrows"></i></a>').appendTo(this.dom);

            this.dom.click(function() { _this.toggleSelect() });
            this.dom.dblclick(function() { _this.onDblClick() });
            this.dom.mouseenter(function() { _this.onEnter(); });
            this.dom.mouseleave(function() { _this.onLeave(); });
            this.dom.data('opercard', this);
            this.dom.data('data', this.bindedData);

            this.dom.delegate('.dragging-starter', 'mouseenter', function(e) {
                e.preventDefault();
                e.stopPropagation();
                _this.enableDrag();
            });

            var title = (this.options.tooltip || _methods.OperCard.tooltip)(this.bindedData);
            if (title) {
                this.dom.tooltip({
                    showDelay: 2000,
                    position: 'top',
                    content: title
                });
            }
        },
        /**
         * 刷新状态
         */
        refreshStatus: function() {
            this.fixed = ['RoomIn', 'RoomOut', 'PACUIn', 'Finished'].indexOf(this.bindedData.OperStatusCode) > -1;
            this.finished = ['RoomOut', 'PACUIn', 'Finished'].indexOf(this.bindedData.OperStatusCode) > -1;
            this.processing = ['RoomIn'].indexOf(this.bindedData.OperStatusCode) > -1;
            this.dom.removeClass('oper-card-finished');
            this.dom.removeClass('oper-card-processing');
            if (this.finished) this.dom.addClass('oper-card-finished');
            if (this.processing) this.dom.addClass('oper-card-processing');
        },
        onEnter: function() {
            //this._menubutton.show();
        },
        onLeave: function() {
            //this._menubutton.hide();
        },
        onDblClick: function() {
            if (this.options.onDblClick) {
                this.options.onDblClick.call(this, this.bindedData);
            }
        },
        /**
         * @param {object} param
         */
        filter: function(fieldValues) {
            var operSchedule = this.bindedData;
            var isMatched = true;
            $.each(fieldValues, function(field, param) {
                var matchingStr = operSchedule[field] || '';
                var value = param.value;
                var extraFields = param.extraFields || [];
                if ($.isArray(value)) {
                    isMatched = isMatched && (value[0] === 'All' || ($.inArray(matchingStr, value) > -1));
                } else if ($.type(value) === 'string') {
                    $.each(extraFields, function(i, e) {
                        matchingStr = matchingStr + String.fromCharCode(1) + operSchedule[e];
                    });
                    isMatched = isMatched && (value === 'All' || matchingStr.indexOf(value) > -1);
                    if (param.exact) isMatched = isMatched && (value === 'All' || matchingStr === value);
                }
                if (!isMatched) return false;
            });

            return isMatched;
        },
        size: function() {
            return { width: $(this.dom).width(), height: $(this.dom).height() };
        },
        position: function() {
            return $(this.dom).offset();
        },
        /**
         * 刷新头部
         */
        refreshHeader: function() {
            if (this.options.header || _methods.OperCard.header) {
                this.header.html((this.options.header || _methods.OperCard.header)(this.bindedData));
            }
        },
        /**
         * 隐藏当前手术卡片
         */
        hide: function() {
            this.dom.tooltip('hide');
            this.dom.addClass('hidden');
            this.dom.hide();
            this.visible = false;
            this.group.hideCard(this);
        },
        /**
         * 显示当前手术卡片
         */
        show: function() {
            this.dom.removeClass('hidden');
            this.dom.show();
            this.visible = true;
            this.group.showCard(this);
        },
        /**
         * 切换选中状态
         */
        toggleSelect: function() {
            if (this.dom.hasClass('oper-card-selected')) this.unselect();
            else this.select();
        },
        /**
         * 选中当前手术卡片
         */
        select: function() {
            var result = this.parent.beforeSelectCard(this);
            if (typeof result === 'boolean' && !result) return;
            this.dom.addClass('oper-card-selected');
            this.selected = true;
            this.parent.onSelectCard(this);
            this.group.select();
        },
        /**
         * 取消选中当前手术卡片
         */
        unselect: function() {
            this.dom.removeClass('oper-card-selected');
            this.selected = false;
            this.group.unselect();
        },
        enableDrag: function() {
            if (!this.fixed) {
                this.dom.draggable('enable');
                this.dom.addClass('oper-card-dragging');
            }
        },
        disableDrag: function() {
            this.dom.draggable('disable');
            this.dom.removeClass('oper-card-dragging');
        },
        /**
         * 切换选中和取消选中当前手术卡片
         */
        toggleSelection: function() {
            if (this.dom.hasClass('oper-card-selected')) this.unselect();
            else this.select();
        },
        /**
         * 复位
         */
        recoverPostion: function() {
            this.dom.css({ top: 0, left: 0 });
        },
        /**
         * 移除自身
         */
        remove: function() {
            this.dom.tooltip('hide');
            this.dom.tooltip('destroy');
            this.dom.remove();
        },
        getDom: function() {
            return this.dom;
        },
        mark: function() {
            this.dom.addClass('oper-card-hover');
        },
        unmark: function() {
            this.dom.removeClass('oper-card-hover');
        }
    }

    // 手术卡片默认方法设置
    _methods.OperCard = {
        header: function(operSchedule) {
            var result = '';
            return result;
        },
        /**
         * 通过手术安排数据对象获取相应的中部显示内容
         */
        content: function(operSchedule) {
            var contentArray = [];
            contentArray.push('<span class="oper-card-info-surgeon">' + operSchedule.SurgeonDesc + '</span>');
            if (operSchedule.SourceType === 'E') {
                contentArray.push('<span class="oper-card-info-type" style="background-color:#D9001B;">急诊</span>');
            } else if (operSchedule.SourceType === 'B') {
                contentArray.push('<span class="oper-card-info-type" style="background-color:#015478;">择期</span>');
            } else if (operSchedule.DaySurgery === 'Y') {
                contentArray.push('<span class="oper-card-info-type" style="background-color:#BFBF00;">日间</span>');
            }

            contentArray.push('<span class="oper-card-info-fragment" style="width:30px;"></span>');
            contentArray.push('<span class="oper-card-info-fragment" style="width:50px;">' + operSchedule.OperDeptDesc + '</span>');
            var match = /\d+\:\d+/.exec(operSchedule.OperTime);
            var time = match ? match[0] : '';
            time = time + (operSchedule.OperDuration ? '|' + operSchedule.OperDuration + 'h' : '');
            contentArray.push('<span class="oper-card-info-fragment" style="width:70px;font-size:10px;">' + time + '</span>');
            if (operSchedule.Major) contentArray.push('<span class="oper-card-info-fragment oper-card-info-icon" style="width:30px;font-size:9px;line-height:16px;">' + operSchedule.Major + '</span>');
            contentArray.push('<span class="oper-card-info-fragment oper-card-info-icon" style="width:15px;font-size:9px;line-height:16px;">' + decodeAdmType(operSchedule.AdmType) + '</span>');

            contentArray.push('<span class="oper-card-info-fragment" style="font-weight:bold;font-size:14px;width:100px;text-align:center;position:relative;padding-left:6px;">' + operSchedule.PatName +
                '<i class="oper-card-info-gender ' + (operSchedule.PatGender === '女' ? 'female fa fa-female' : 'male fa fa-male') + '"></i></span>');
            contentArray.push('<span class="oper-card-info-fragment" style="width:15px;">' + operSchedule.PatGender + '</span>');
            var match = /\d+/.exec(operSchedule.PatAge);
            var age = match ? Number(match[0]) : 30;
            contentArray.push('<span class="oper-card-info-fragment' +
                (age > 70 ? ' oper-card-info-warning" title="年龄大于70岁' : (age < 3 ? ' oper-card-info-warning" title="年龄小于3岁' : '')) + '" style="width:60px;">' +
                operSchedule.PatAge + '</span>');
            //contentArray.push('<span class="oper-card-info-fragment" style="width:80px;font-size:8px;">' + operSchedule.RegNo + '</span>');

            contentArray.push('<span class="oper-card-info-fragment" style="width:140px;text-align:left;">' + operSchedule.OperDesc + '</span>');
            contentArray.push('<span class="oper-card-info-fragment" style="width:60px;">' + operSchedule.AnaMethodDesc + '</span>');

            return contentArray.join('');

            function decodeAdmType(admType) {
                switch (admType) {
                    case 'I':
                        return '住';
                    case 'O':
                        return '门';
                    case 'E':
                        return '急';
                    default:
                        return admType;
                }
            }
        },
        /**
         * 通过手术安排数据对象获取相应的底部显示内容
         */
        footer: function(operSchedule) {
            var footerArray = [];
            if ((operSchedule.OperDuration && Number(operSchedule.OperDuration) > 4)) {
                footerArray.push('<span class="oper-card-info-fragment oper-card-info-tag" style="color:#A164F3;" title="手术预计时长大于4小时">大于4小时</span>');
            }
            if (/IMC/.test(operSchedule.PatWardDesc)) {
                footerArray.push('<span class="oper-card-info-fragment oper-card-info-tag" style="color:#6798E9;" title="病人所在科室为IMC病区">IMC病区</span>');
            }
            if (operSchedule.MechanicalArm === 'Y') {
                footerArray.push('<span class="oper-card-info-fragment oper-card-info-tag" style="color:#EC808D;" title="术中需要X射线造影">X-ray</span>');
            }
            if (operSchedule.IsoOperation === 'Y') {
                footerArray.push('<span class="oper-card-info-fragment oper-card-info-tag" style="color:#008080;" title="术中需要隔离">隔离</span>');
            }
            if (operSchedule.InfectionOper) {
                footerArray.push('<span class="oper-card-info-fragment oper-card-info-tag" style="color:#D9001B;" title="' + operSchedule.InfectionOperDesc + '">感染</span>');
            }
            if (operSchedule.MDROS === '+') {
                footerArray.push('<span class="oper-card-info-fragment oper-card-info-tag" style="color:#FC522C;" title="患者携带多重耐药菌">多重耐药</span>');
            }
            if (operSchedule.Profrozen === 'Y') {
                footerArray.push('<span class="oper-card-info-fragment oper-card-info-tag" style="color:#81D3F8;" title="术中需要提取冰冻标本">冰冻</span>');
            }
            if (operSchedule.SpecialConditions) {
                footerArray.push('<span class="oper-card-info-fragment oper-card-info-tag" style="white-space:normal;color:#420080;text-align:left;">' + (operSchedule.SpecialConditions) + '</span>');
            }
            return footerArray.join('');
        },
        /**
         * 获取tooltip显示的字符串
         */
        tooltip: function(operSchedule) {
            var contentArray = [];
            contentArray.push('<span style="font-size:11px;">' + operSchedule.PatDeptDesc);
            contentArray.push(operSchedule.WardBed);

            var SourceType = '';
            if (operSchedule.SourceType === 'E') {
                SourceType = '急诊手术';
            } else if (operSchedule.SourceType === 'B') {
                SourceType = '择期手术';
            } else if (operSchedule.DaySurgery === 'Y') {
                SourceType = '日间手术';
            }
            contentArray.push('<span style="margin-right:5px;padding:0 5px;font-size:9px;border:1px solid #fff;border-radius:10px;">' + decodeAdmType(operSchedule.AdmType) + '</span><b>' + operSchedule.PatName + '</b> (' + operSchedule.PatGender + ' ' + operSchedule.PatAge + ')' + '<span style="margin-left:5px;font-size:9px;border:1px solid #fff;">' + SourceType + '</span>');

            contentArray.push('登记号：' + operSchedule.RegNo + '<span style="margin-left:5px;font-size:11px;">住院号：' + operSchedule.MedcareNo + '</span>');
            contentArray.push('手术日期：' + operSchedule.OperDate);
            contentArray.push('手术时间：' + operSchedule.OperTime + '<span style="margin-left:5px;font-size:11px;">预计持续时间：' + (operSchedule.OperDuration ? operSchedule.OperDuration + 'h' : '') + '</span>');
            contentArray.push('手术名称：' + operSchedule.OperDesc);
            if (operSchedule.OperEnglishName) contentArray.push(operSchedule.OperEnglishName);
            contentArray.push('麻醉方法：' + operSchedule.AnaMethodDesc);

            contentArray.push('主刀医生：' + operSchedule.SurgeonDesc + '<span style="margin-left:5px;font-size:11px;">专业：' + (operSchedule.Major || '') + '</span></span>');
            contentArray.push('<span style="font-size:11px;">' + '手术要求：' + operSchedule.OperRequirement);
            var match = /\d+/.exec(operSchedule.PatAge);
            var age = match ? Number(match[0]) : 30;
            if (age > 70) contentArray.push('<span style="font-size:11px;border:1px solid #fff;">年龄大于70岁</span>');
            if (age < 3) contentArray.push('<span style="font-size:11px;border:1px solid #fff;">年龄小于3岁</span>');

            return contentArray.join('<br/>');

            function decodeAdmType(admType) {
                switch (admType) {
                    case 'I':
                        return '住院病人';
                    case 'O':
                        return '门诊病人';
                    case 'E':
                        return '急诊病人';
                    default:
                        return admType;
                }
            }
        }
    };

    /**
     * 卡片拖动的代理
     * @param {HTMLElement} source 
     */
    function proxy(source) {
        var group = $('<div></div>');
        var opercard = $(source).data('opercard');

        if (opercard.visible && opercard.selected) {
            var card, p;
            var selectedCards = opercard.parent.getAllSelectedCards();
            for (var i = 0, length = selectedCards.length; i < length; i++) {
                card = selectedCards[i];
                p = $('<div style="z-index:20000;" class="oper-card oper-card-dragging"></div>');
                p.css({ width: card.dom.width(), height: card.dom.height() });
                p.html($(card.dom).clone().html()).appendTo(group);
            }
        } else {
            var card = opercard;
            var p = $('<div style="z-index:20000;" class="oper-card oper-card-dragging"></div>');
            p.css({ width: card.dom.width(), height: card.dom.height() });
            p.html($(source).clone().html()).appendTo(group);
        }

        group.appendTo('body');
        return group;
    }

})));