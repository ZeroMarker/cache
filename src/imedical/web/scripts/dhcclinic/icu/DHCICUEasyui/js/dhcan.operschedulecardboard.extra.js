/**
 * 手术安排卡片板块，显示和操作手术安排卡片
 * 采用自执行函数进行加载主要是为了避免污染外部代码
 * @author yongyang  20180306
 */
(function(global, factory) {
    factory((global.operScheduleCardboard = {}));
}(this, (function(exports) {

    var _id = 0;

    var _methods = {};

    /**
     * 初始化方法，外部调用：operScheduleCardboard.init(...);
     * 暂时没有考虑传入的元素已经绑定cardboard的情况
     * @param {HTMLElement} dom 
     * @param {object} opt 
     * @returns 
     */
    function init(dom, opt) {
        _id++;

        var cardboard = new OperScheduleCardboard(dom, opt);

        return cardboard;
    }

    exports.init = init;

    var defaultOptions = {
        fit: true,
        width: 'auto',
        height: 'auto',
        singleSelection: true,
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
     * @description Cardboard构造函数
     * @author yongyang 2018-03-06
     * @module OperScheduleCardboard
     * @constructor
     * @param {HTMLElement} dom 
     * @param {object} opt 
     */
    function OperScheduleCardboard(dom, opt) {
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
        this._toolkit = null;

        /**
         * @type {module: FilterForm}
         * @private
         */
        this.toolkitForm = null;

        /**
         * @type {HTMLElement}
         * @private 
         */
        this.cardsContainer = null;

        this.onQuery = null;

        this._init();
        this.setOptions(opt);
    }

    var cardboardProto = OperScheduleCardboard.prototype;

    /** 
     * 初始化
     * @private
     */
    cardboardProto._init = function() {
        var _this = this;
        this._toolkit = $('<div class="oper-cardboard-tool"></div>');
        var form = $('<form class="oper-cardboard-form"></form>');
        this.dom.append(this._toolkit.html(form));

        this.cardsContainer = $('<div class="oper-cardboard-container"></div>');
        this.mask = $('<div class="window-mask" style="display:none; z-index:9000;text-align:center;"></div>')
            .append('<i class="fas fa-refresh" style="line-height:320px;color:#fff;font-size:50px;"></i>').appendTo(this.cardsContainer);
        this.dom.append(this.cardsContainer);

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
    cardboardProto.setOptions = function(options) {
        var _this = this;
        $.extend(this.options, options);

        this.onQuery = this.options.onQuery;
        this.onMenuItemClick = this.options.menu.onClick;
        this.onMoveCard = this.options.onMoveCard;

        this.toolkitForm = new FilterForm(this._toolkit.children('form'), this, this.options.filterForm);

        this.cardsContainer.height(this.dom.height() - this._toolkit.height() - 10);

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
    cardboardProto.loadData = function(operScheduleArray) {
        this.bindedData = operScheduleArray;
        this.dataGroups = [];

        if (!$.isArray(this.bindedData)) return;

        this.cardsContainer.hide();
        this.cardsContainer.empty();
        this.render();
        this.cardsContainer.show();
    };

    /**
     * 渲染
     */
    cardboardProto.render = function() {
        this.groupingData();
        this.generateCards();
        this.toolkitForm.filterCards();
    }

    /**
     * 对数据进行分组
     */
    cardboardProto.groupingData = function() {
        var groupBy = this.options.groupBy;
        var groups = {};
        var dataGroups = [];
        var excepted = [];

        var length = this.bindedData.length;
        for (var i = 0; i < length; i++) {
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

        var sortBy = this.options.sortBy;
        for (var groupIndex in groups) {
            dataGroups.push({
                key: groupIndex,
                text: groups[groupIndex][0][groupBy.textField],
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

        this.dataGroups = dataGroups;
    };

    /**
     * 排序(简单模式，按数字排序)
     * @param {Array<object>} data
     * @param {string} field 
     */
    function sortData(data, field) {
        var sorts = {};
        var sorted = [];
        var length = data.length;
        /*
        for (var i = 0; i < length; i++) {
            var row = data[i];
            var num = Number(row[field]);
            sorts[num] = row;
        }

        for (var f in sorts) {
            sorted.push(sorts[f]);
        }
        */
        sorted = data.sort(compareInstance('OperSeq'));
        return sorted;
    }

    /**
     * 排序实例 
     */
    function compareInstance(field) {
        return function(row1, row2) {
            var value1 = row1[field];
            var value2 = row2[field];
            if (value1 == '' || value1 == 'All') {
                return 1;
            } else if (value2 == '' || value2 == 'All') {
                return -1;
            } else if (Number(value1) > Number(value2)) {
                return 1;
            } else {
                return -1;
            }

        }
    }

    /**
     * 生成卡片
     */
    cardboardProto.generateCards = function() {
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
        this.toolkitForm.reconstructData(this.bindedData);
    };

    /**
     * 添加卡片分组
     * @param {Module<OperCardGroup>} group 
     */
    cardboardProto.appendGroup = function(group) {
        this.cardsContainer.append(group.dom);
        this.groups.push(group);
    };

    /**
     * 添加数据
     */
    cardboardProto.appendData = function(operScheduleArray) {

    };
    /**
     * 清空所有数据
     */
    cardboardProto.clear = function() {

    };
    /** 
     * 显示单个卡片
     * @param {data.OperSchedule | string} operSchedule 手术安排:对象、ID
     */
    cardboardProto.showCard = function(operSchedule) {

    };
    /**
     * 显示全部卡片
     */
    cardboardProto.showAllCards = function() {

    };
    /**
     * 隐藏单个卡片
     * @param {data.OperSchedule | string} operSchedule 手术安排：对象、ID
     */
    cardboardProto.hideCard = function(operSchedule) {

    };
    /**
     * 隐藏全部卡片
     */
    cardboardProto.hideAllCards = function() {

    };
    /**
     * 隐藏单个卡片
     * @param {data.OperSchedule | string} operSchedule 手术安排：对象、ID
     */
    cardboardProto.disableCard = function(operSchedule) {

    };
    /**
     * 隐藏单个卡片
     * @param {data.OperSchedule | string} operSchedule 手术安排ID：对象、ID
     */
    cardboardProto.enableCard = function(operSchedule) {

    };
    /**
     * 筛选手术卡片
     * @param {Array<Data.OperSchedule>} filterFieldValues 筛选时需要的字段及可以显示手术卡片的字段对应值
     * @return {Array<OperCard>}
     */
    cardboardProto.filter = function(filterFieldValues) {
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
    cardboardProto.filterAndShow = function(filterFieldValues) {
        $.each(this.cards, function(index, card) {
            if (card.filter(filterFieldValues)) card.show();
            else card.hide();
        });
    };

    /**
     * 设置placeholder
     */
    cardboardProto.setPlaceholder = function(card) {
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
    cardboardProto.restorePosition = function() {
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
    cardboardProto.coordinatePlaceholder = function(y) {
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
    cardboardProto.removePlaceholder = function() {
        if (this.placeholder) this.placeholder.remove();
    };

    /**
     * 移动卡片，最终调用
     */
    cardboardProto.moveCards = function() {
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
    cardboardProto.selectCard = function(cardOrId) {
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
    cardboardProto.beforeSelectCard = function(card) {
        if (this.options.singleSelection) {
            this.clearCardSelection();
        }
    };

    /**
     * 清楚卡片选择
     */
    cardboardProto.clearCardSelection = function() {
        $.each(this.cards, function(i, card) {
            card.unselect();
        });
    };

    /**
     * 当选中卡片时调用
     * @param {Module<OperCard>} card 
     */
    cardboardProto.onSelectCard = function(card) {
        var callback = this.options.onSelectCard;
        if (callback) {
            callback.call(this, card);
        }
    };

    /**
     * 获取选中的卡片集合
     */
    cardboardProto.getSelectedCards = function() {
        var cards = [];
        $.each(this.cards, function(i, card) {
            if (card.selected) cards.push(card);
        });

        return cards;
    };

    /**
     * 标记所有选中的卡片
     */
    cardboardProto.markAllSelectedCards = function() {
        $.each(this.cards, function(i, card) {
            if (card.selected) card.mark();
        })
    };

    /**
     * 取消标记所有选中的卡片
     */
    cardboardProto.unmarkAllSelectedCards = function() {
        $.each(this.cards, function(i, card) {
            if (card.selected) card.unmark();
        })
    };

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

            if (_this.options.items)
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

            this.parent.filterAndShow(filterFieldValues);
        },
        /**
         * 重建选项数据
         */
        reconstructData: function(operScheduleArray) {
            $.each(this.items, function(i, item) {
                item.clearData();
                if ($.isArray(operScheduleArray))
                    $.each(operScheduleArray, function(j, operSchedule) {
                        item.appendData(operSchedule);
                    });
                item.reload();
            });
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
                    width: this.parent.width(),
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
            this.dom = $('<div class="oper-card-group"></div>');
            this.header = $('<div class="oper-card-group-header"></div>').appendTo(this.dom);
            this.body = $('<div class="oper-card-group-body"></div>').appendTo(this.dom);

            $('<span class="header-text"></span>').text(this.bindedData.text).appendTo(this.header);
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
                disabled: true,
                //handle: '.oper-card-header',
                edge: 5,
                revert: true,
                proxy: proxy,
                onBeforeDrag: function(e) {
                    _this.originalSize = _this.size();
                    _this.parent.restorePosition();
                    _this.parent.setPlaceholder(_this);
                    $(this).hide();
                    setTimeout(function() {
                        if (!_this.startedDragging) {
                            _this.parent.removePlaceholder();
                            _this.show();
                        }
                    }, 400);
                },
                onStartDrag: function(e) {
                    _this.startedDragging = true;
                },
                onStopDrag: function(e) {
                    var dom = $(this);
                    dom.css({ left: 0, top: 0 });
                    setTimeout(function() {
                        _this.parent.removePlaceholder();
                        _this.show();
                    }, 400);
                    _this.startedDragging = false;
                    $('.oper-card-dragging').remove();
                },
                onDrag: function(e) {
                    if (!_this.dom.data('draggable')['droppables']) {
                        $('.oper-card-dragging').offset({ top: e.pageY - 10, left: e.pageX - 20 });
                    }
                    /*if (!_this.dom.data('draggable')['droppables']) {
                        $('.oper-card-dragging').remove();
                        $.fn.draggable.isDragging = false;
                        setTimeout(function() {
                            _this.show();
                            _this.parent.removePlaceholder();
                            _this.startedDragging = false;
                        }, 200);
                        return false;
                    }*/
                    _this.parent.coordinatePlaceholder(e.pageY);
                },
                onEndDrag: function(e) {
                    _this.startedDragging = false;
                    $('.oper-card-dragging').remove();
                }
            });
            this._render();
        },
        /**
         * 渲染方法
         */
        _render: function() {
            var _this = this;

            if (this.fixed) this.dom.attr('title', '不能拖动更换台次');
            if (this.finished) this.dom.addClass('oper-card-finished');
            if (this.processing) this.dom.addClass('oper-card-processing');

            this.dom.attr('data-opsId', this.bindedData.RowId);

            this._menubutton = $('<span class="oper-card-menubutton">...</span>');
            this.dom.append(this._menubutton);
            this._menubutton.mouseenter(function() {
                event.stopPropagation();
                _this.options.menu.data('opercard', _this);
                _this.options.menu.menu('show', $(this).offset());
                _this.mark();
            });

            var idInput = $('<input type="hidden" name="RowId" value="' + this.bindedData.RowId + '">');
            this.dom.append(idInput);

            var header = $('<div class="oper-card-header"></div>');
            if (this.options.header || _methods.OperCard.header) {
                header.html((this.options.header || _methods.OperCard.header)(this.bindedData));
                this.dom.append(header);
                header.mouseenter(function() { _this.enableDrag(); });
                header.mouseleave(function() { _this.disableDrag(); });
            }
            this.header = header;

            var content = $('<div class="oper-card-content"></div>');
            content.html((this.options.content || _methods.OperCard.content)(this.bindedData));
            this.dom.append(content);

            var footer = $('<div class="oper-card-footer"></div>');
            var footerInnerHtml = (this.options.footer || _methods.OperCard.footer)(this.bindedData);
            if (footerInnerHtml) {
                footer.html(footerInnerHtml);
                this.dom.append(footer);
            }

            this.dom.click(function() { _this.select() });
            this.dom.mouseenter(function() { _this.onEnter(); });
            this.dom.mouseleave(function() { _this.onLeave(); });
            this.dom.data('opercard', this);
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
        /**
         * @param {object} param
         */
        filter: function(fieldValues) {
            var operSchedule = this.bindedData;
            var isMatched = true;
            $.each(fieldValues, function(field, param) {
                var matchingStr = operSchedule[field];
                var value = param.value;
                var extraFields = param.extraFields;
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
            if (!this.fixed) this.dom.draggable('enable');
        },
        disableDrag: function() {
            this.dom.draggable('disable');
        },
        /**
         * 切换选中和取消选中当前手术卡片
         */
        toggleSelection: function() {
            if (this.dom.hasClass('oper-card-selected')) this.unselect();
            else this.select();
        },
        /**
         * 移除自身
         */
        remove: function() {
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
            if (operSchedule.OperSeq) result = '第 ' + operSchedule.OperSeq + ' 台';
            else result = '未排台次';
            return result;
        },
        /**
         * 通过手术安排数据对象获取相应的中部显示内容
         */
        content: function(operSchedule) {
            var contentArray = [];
            contentArray.push('<span style="font-weight:bold;">' + operSchedule.Patient + '</span>');
            contentArray.push('<span>' + operSchedule.PatDeptDesc + '</span>');
            contentArray.push('<br/><span class="oper-card-info-surgeon">' + operSchedule.SurgeonDesc + '</span>');
            contentArray.push('<br/><span>' + operSchedule.OperInfo + '</span>');

            return contentArray.join('');
        },
        /**
         * 通过手术安排数据对象获取相应的底部显示内容
         */
        footer: function(operSchedule) {
            var footerArray = [];
            if (operSchedule.SourceType === 'E') {
                footerArray.push('<span style="color:#ff0000;">急</span>');
            }
            if (operSchedule.Infection.indexOf("阳性") >= 0) {
                footerArray.push('<span style="color:#ff0000;" title="' + operSchedule.InfectionLabData.replace(/#/g, "&#10;") + '">感</span>');
            }

            return footerArray.join('');
        }
    };

    /**
     * 卡片拖动的代理
     * @param {HTMLElement} source 
     */
    function proxy(source) {
        var p = $('<div style="z-index:20000;" class="oper-card oper-card-dragging"></div>');
        var opercard = $(source).data('opercard');
        p.css({ width: opercard.originalSize.width, height: opercard.originalSize.height });
        p.html($(source).clone().html()).appendTo('body');

        return p;
    }

})));