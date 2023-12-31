/**
 * @description 手术列表手风琴分组展示
 * @author yongyang 2018-03-19
 */

(function(global, factory) {
    factory(global.operScheduleAccordion = {});
}(this, function(exports) {

    function init(dom, opt) {
        return new OperScheduleAccordion(dom, opt);
    }

    exports.init = init;

    var defaultOptions = {
        groupKeyField: "",
        groupKeyDescField: "",
        item: {
            sorter: function(pre, next) {
                if (Number(pre.OperSeq) > Number(next.OperSeq)) return false;
                return true;
            },
            operCard: {

            }
        }
    }

    function OperScheduleAccordion(dom, opt) {
        this._dom = $(dom);
        this.accordion = null;
        this.options = $.extend({}, defaultOptions, opt);
        this.data = [];
        this.groups = [];
        this.items = [];
        this._init();
    }

    OperScheduleAccordion.prototype = {
        /**
         * 构造函数
         */
        constructor: OperScheduleAccordion,
        /**
         * 初始化方法
         */
        _init: function() {
            this.accordion = $HUI.accordion(this._dom, {});
        },
        /**
         * 生成项目
         */
        _generateItems: function(groups) {
            var items = this.items;
            var accordion = this.accordion;
            var itemOpt = this.options.item;
            $.each(groups, function(index, group) {
                var item = new AccordionItem(group, itemOpt);
                items.push(item);
                accordion.add({
                    title: item.title,
                    content: item.content,
                    selected: index === 0
                });
            });
        },
        setOptions: function(opt) {
            if (opt.groupKeyField && !opt.groupKeyField === this.options.groupKeyField) {
                $.extend(this.options, opt);
                this.clear();
                this.loadData(data);
            }
        },
        loadData: function(data) {
            this.data = data;
            this.groups = groupData(data, this.options);
            this._generateItems(this.groups);
        },
        clear: function() {
            this.accordion.clear();
        }
    }

    function groupData(data, options) {
        var groupKeyField = options.groupKeyField;
        var groupKeyDescField = options.groupKeyDescField;
        var groups = [];
        var groupKeys = [];
        var group = {};

        $.each(data, function(index, row) {
            var groupKey = row[groupKeyField];
            var groupKeyDesc = row[groupKeyDescField];
            var groupKeyIndex = groupKeys.indexOf(groupKey);
            if (groupKeyIndex < 0) {
                groupKeys.push(groupKey);
                group = { key: { value: groupKey, desc: groupKeyDesc }, rows: [] };
                group.rows.push(row);
                groups.push(group);
            } else {
                group = groups[groupKeyIndex];
                group.rows.push(row);
            }
        });

        return groups;
    }


    function AccordionItem(group, opt) {
        this._group = group;
        this.options = opt;
        this.key = group.key;
        this.data = group.rows;
        this.title = "";
        this.content = "";
        this.cards = [];
        this.yAxises = [];
        this._sequence = [];
        this._init();
    }

    AccordionItem.prototype = {
        constructor: AccordionItem,

        _init: function() {
            this.title = this.key.desc + '<span class="oai-bodge"></span>';
            this.content = $('<div class="oper-accordion-item"></div>');
            this.sort();
            this.render();
        },
        sort: function() {
            var sorter = this.options.sorter;
            var operCardOpt = this.options.operCard;
            var cards = this.cards;
            var length = this.data.length;
            var sequence = this._sequence;

            for (var i = 0; i < length - 1; i++) {
                if (!sequence[i]) sequence[i] = 0;
                for (var j = i + 1; j < length; j++) {
                    if (!sequence[j]) sequence[j] = 0;
                    sorter(this.data[i], this.data[j]) ? sequence[j]++ : sequence[i]++;
                }
            }

            for (var i = 0; i < length; i++) {
                var row = this.data[i];
                var card = new OperCard(this, row, operCardOpt);
                cards[sequence[i]] = card;
            }
        },
        render: function() {
            var content = this.content;
            $.each(this.cards, function(index, card) {
                content.append(card.getDom());
            });
        },
        match: function(operSchedule) {
            var length = this.data.length;
            var sorter = this.options.sorter;
            var cards = [];
            var card = null;

            for (var i = 0; i < length; i++) {
                card = this.cards[this.sequence[i]];
                if (sorter(this.data[i], operSchedule)) {
                    this.sequence[length]++;
                } else {
                    this.sequence[i]++;
                }
                cards[this.sequence[i]] = card;
            }
            this.data.push(operSchedule);
            this.cards = cards;

            return this.sequence[length];
        },
        appendChild: function(index, card) {
            if (index > 0) {
                this.content.children('.oper-card:eq(' + (index - 1) + ')').after(card.getDom());
            } else {
                this.content.append(card.getDom());
            }
        },
        addCard: function(card) {
            var index = this.match(card.dataSource);
            this.cards[index] = card;
            this.appendChild(index, card);
        },
        addRow: function(operSchedule) {
            var card = new OperCard(this, operSchedule, this.options.operCard);
            this.addCard(card);
        },
        setDraggingCard: function(card) {
            this.draggingCard = card;
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
                }
            });
            this.placeholderIndex = this.cards.indexOf(card);
            this.placeholderPos = this.placeholderIndex;
            this.originalIndex = this.placeholderIndex;
            this.placeholder = placeholder;
            this.currentSequnce = [];
        },
        restorePosition: function() {
            this.yAxises = [];
            var yAxises = this.yAxises;
            $.each(this.cards, function(index, card) {
                var position = card.position();
                yAxises.push(position.top);
            });
        },
        coordinatePlaceholder: function(axis) {
            var nextPlaceholderPos = 0;
            var y = axis.y;
            $.each(this.yAxises, function(index, yAxis) {
                if (y > yAxis) {
                    nextPlaceholderPos = index;
                    return true;
                } else {
                    return false;
                }
            });

            if (nextPlaceholderPos != this.placeholderPos) {
                this.setCurrentSequnce(this.placeholderPos, nextPlaceholderPos);
                this.placeholderPos = nextPlaceholderPos;
            }

        },
        setCurrentSequnce: function(prePos, nextPos) {
            if (prePos === nextPos) return;

            var sequence = [];
            var length = this.cards.length;
            var direction = prePos > nextPos ? -1 : 1;
            var func = prePos > nextPos ? 'before' : 'after';
            this.placeholderIndex = this.currentSequnce[nextPos] || nextPos;

            sequence[prePos] = this.currentSequnce[nextPos] || nextPos;
            sequence[nextPos] = this.currentSequnce[prePos] || prePos;

            for (var i = 0; i < length; i++) {
                if (i === prePos || i === nextPos) continue;
                else if ((direction * i) > (direction * prePos) && (direction * i) < (direction * nextPos)) {
                    sequence[(i + direction)] = this.currentSequnce[i] || i;
                } else {
                    sequence[i] = this.currentSequnce[i] || i;
                }
            }

            $(this.cards[this.placeholderIndex].getDom())[func](this.placeholder);
        },
        removePlaceholder: function() {
            if (this.placeholder) this.placeholder.remove();
        },
        moveCards: function() {
            var cards = [];
            var length = this.cards.length;
            var sourceIndex = this.originalIndex;
            var targetIndex = this.placeholderIndex;
            var direction = targetIndex > sourceIndex ? -1 : 1;

            if (sourceIndex === targetIndex) return;

            cards[targetIndex] = this.cards[sourceIndex];
            cards[sourceIndex] = this.cards[targetIndex];

            for (var i = 0; i < length; i++) {
                if (i === sourceIndex || i === targetIndex) continue;
                else if ((direction * i) > (direction * sourceIndex) && (direction * i) < (direction * targetIndex)) {
                    cards[(i + direction)] = this.cards[i];
                } else {
                    cards[i] = this.cards[i];
                }
            }

            this.cards = cards;
        }
    }

    /**
     * 构造手术卡片
     * @module OperScheduleCardboard~OperCard
     * @param {module: Data.operSchedule} operSchedule 
     * @param {object} opt
     */
    function OperCard(parent, operSchedule, opt) {
        this.parent = parent;
        this.dataSource = operSchedule;
        this.selected = false;
        this.options = opt;
        this._dom = $('<div class="oper-card"></div>');
        this._menubutton = null;
        this.originalSize = { width: 0, height: 0 };
        this._init();
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
            var parent = this.parent;
            this._dom.draggable({
                revert: true,
                proxy: proxy,
                onBeforeDrag: function(e) {
                    parent.setDraggingCard($(this).data('opercard'));
                    parent.restorePosition();
                    _this.originalSize = _this.size();
                    $(this).hide();
                },
                onStopDrag: function(e) {
                    var dom = $(this);
                    dom.css({ left: 0, top: 0 });
                    setTimeout(function() {
                        parent.removePlaceholder();
                        dom.show();
                    }, 400);
                },
                onDrag: function(e) {
                    parent.coordinatePlaceholder({ x: e.pageX, y: e.pageY });
                },
                onEndDrag: function(e) {
                    parent.removePlaceholder();
                    $(this).show();
                }
            });
            this._render();
        },
        /**
         * 渲染方法
         */
        _render: function() {
            var _this = this;

            this._menubutton = $('<span class="oper-card-menubutton" style="display:none;">...</span>');
            this._dom.append(this._menubutton);

            var idInput = $('<input type="hidden" name="RowId" value="' + this.dataSource.RowId + '">');
            this._dom.append(idInput);

            this._menubutton.mouseenter(function() {
                event.stopPropagation();
                //_this.options.menu.menu('show', $(this).offset());
                if (!_this.selected) {
                    _this.select();
                }
            });

            var header = $('<div class="oper-card-header"></div>');
            var headerGenerator = (this.options.header || _methods.OperCard.header);
            if (headerGenerator) {
                header.html(headerGenerator(this.dataSource));
                this._dom.append(header);
            }

            var content = $('<div class="oper-card-content"></div>');
            content.html((this.options.content || _methods.OperCard.content)(this.dataSource));
            this._dom.append(content);

            var footer = $('<div class="oper-card-footer"></div>');
            var footerInnerHtml = (this.options.footer || _methods.OperCard.footer)(this.dataSource);
            if (footerInnerHtml) {
                footer.html(footerInnerHtml);
                this._dom.append(footer);
            }

            this._dom.data("opercard", this);
            this._dom.click(function() { _this.select() });
            this._dom.mouseenter(function() { _this.onEnter() });
            this._dom.mouseleave(function() { _this.onLeave() });
        },
        onEnter: function() {
            this._menubutton.show();
        },
        onLeave: function() {
            this._menubutton.hide();
        },
        /**
         * @param {object} fieldValues
         */
        filter: function(fieldValues) {
            var operSchedule = this.dataSource;
            var isMatched = true;
            $.each(fieldValues, function(field, values) {
                var matchingStr = operSchedule[field];
                if ($.isArray(values)) {
                    isMatched = isMatched && (values[0] === 'All' || ($.inArray(matchingStr, values) > -1));
                }
                if (!isMatched) return false;
            });

            return isMatched;
        },
        size: function() {
            return { width: $(this._dom).width(), height: $(this._dom).height() };
        },
        position: function() {
            return $(this._dom).offset();
        },
        /**
         * 隐藏当前手术卡片
         */
        hide: function() {
            this._dom.addClass('hidden');
            this.unselect();
            this._dom.hide();
        },
        /**
         * 显示当前手术卡片
         */
        show: function() {
            this._dom.removeClass('hidden');
            this.unselect();
            this._dom.show();
        },
        /**
         * 选中当前手术卡片
         */
        select: function() {
            $('.oper-card-selected').removeClass('oper-card-selected');
            this._dom.addClass('oper-card-selected');
            this.selected = true;
        },
        /**
         * 取消选中当前手术卡片
         */
        unselect: function() {
            this._dom.removeClass('oper-card-selected');
            this.selected = false;
        },
        enableDrag: function() {
            this._dom.draggable('enable');
        },
        disableDrag: function() {
            this._dom.draggable('disable');
        },
        /**
         * 切换选中和取消选中当前手术卡片
         */
        toggleSelection: function() {
            if (this._dom.hasClass('oper-card-selected')) this.unselect();
            else this.select();
        },
        /**
         * 移除自身
         */
        remove: function() {
            this._dom.remove();
        },
        getDom: function() {
            return this._dom;
        },
        mark: function() {
            this._dom.addClass('oper-card-hover');
        },
        unmark: function() {
            this._dom.removeClass('oper-card-hover');
        }
    }

    var _methods = {};
    // 手术卡片默认方法设置
    _methods.OperCard = {
        header: function(operSchedule) {
            return '第 ' + operSchedule.OperSeq + ' 台';
        },
        /**
         * 通过手术安排数据对象获取相应的中部显示内容
         */
        content: function(operSchedule) {
            var contentArray = [];
            contentArray.push('<span style="font-weight:bold;">' + operSchedule.Patient + '</span>');
            contentArray.push('<span>' + operSchedule.PatDeptDesc + '</span>');
            contentArray.push('<span>' + operSchedule.WardBed + '</span>');
            contentArray.push('<br/><span>' + operSchedule.OperInfo + '</span>');

            return contentArray.join('');
        },
        /**
         * 通过手术安排数据对象获取相应的底部显示内容
         */
        footer: function(operSchedule) {
            var footerArray = [];
            if (operSchedule.SourceType === 'E') {
                footerArray.push('<span class="oper-card-tag oper-card-tag-emergency">急</span>');
            }

            return footerArray.join('');
        }
    };

    function proxy(source) {
        var p = $('<div style="z-index:10000;" class="oper-card"></div>');
        var opercard = $(source).data('opercard');
        p.css({ width: opercard.originalSize.width, height: opercard.originalSize.height });
        p.html($(source).clone().html()).appendTo('body');

        return p;
    }
}));