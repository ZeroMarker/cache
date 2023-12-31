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

    var _cards = [];

    var _selectedCardsCount = 0;

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
        this.dataSource = [];

        /**
         * @property {HTMLElement} cardboard对应的界面元素
         * @private
         */
        this._dom = dom;

        /**
         * @property {object} 配置信息
         * @private
         */
        this._options = defaultOptions;

        /**
         * @property {Array.<OperCard>} 包含的手术卡片数组
         * @private
         */
        this._cards = [];

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
        this._toolkitForm = null;

        /**
         * @type {HTMLElement}
         * @private 
         */
        this._cardsContainer = null;

        this._init();
        this.setOptions(opt);
    }

    var cardboardProto = OperScheduleCardboard.prototype;

    /** 
     * 初始化
     * @private
     */
    cardboardProto._init = function() {
        this._toolkit = $('<div class="oper-cardboard-tool"></div>');
        var form = $('<form class="oper-cardboard-form"></form>');
        this._dom.append(this._toolkit.html(form));

        this._cardsContainer = $('<div class="oper-cardboard-container"></div>');
        this._dom.append(this._cardsContainer);

        this._menu = $('<div></div>');
        $('body').append(this._menu);
        $(this._menu).mouseenter(function() {
            markAllSelectedCards();
        });
        $(this._menu).mouseleave(function() {
            unmarkAllSelectedCards();
        });
    }

    /**
     * 设置选项
     * @type {Function(object)}
     * @param {object} options
     */
    cardboardProto.setOptions = function(options) {
        $.extend(this._options, options);

        this._toolkitForm = new FilterForm(this._toolkit.children('form'), this, this._options.filterForm);

        this._cardsContainer.height(this._dom.height() - this._toolkit.height() - 10);

        generateMenu(this._menu, this._options.menu);
        this._menu.menu({
            onClick: function(item) {
                var operCards = getSelectedCards();
                var opt = $(item.target).data('options');

                if (opt.onClick) {
                    opt.onClick.call(item, operCards);
                }
            }
        });

        this.generateCards();
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
        if(opt.id){
            menuItem.attr('data-id',opt.id);
            menuItem.id=opt.id;
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
        this.dataSource = operScheduleArray;

        this.generateCards();
    };

    cardboardProto.generateCards = function() {
        var _this = this;
        var card;

        this._cardsContainer.empty();

        $.extend(_this._options.operCard, {
            menu: _this._menu
        });

        _this._cards = [];
        _cards = [];
        if ($.isArray(this.dataSource)) {
            $.each(this.dataSource, function(index, row) {
                card = new OperCard(_this._cardsContainer, row, _this._options.operCard);
                _this._cards.push(card);
                _cards.push(card);
            });

            this._toolkitForm.reconstructData(this.dataSource);
        }
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
        $.each(this._cards, function(index, card) {
            if (card.filter(filterFieldValues)) result.push(card);
        });

        return result;
    };
    /**
     * 筛选并显示手术卡片
     * @param {object} filterFieldValues 
     */
    cardboardProto.filterAndShow = function(filterFieldValues) {
        $.each(this._cards, function(index, card) {
            if (card.filter(filterFieldValues)) card.show();
            else card.hide();
        });
    };

    /**
     * 初始化筛选条件表单
     * @module OperScheduleCardboard~FilterForm
     * @param {HTMLElement} dom 
     * @param {module:OperScheduleCardboard} parent 
     * @param {object} opt 
     */
    function FilterForm(dom, parent, opt) {
        this._options = opt;
        this._dom = dom;
        this._parent = parent;
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

            if (_this._options.items)
                $.each(_this._options.items, function(i, e) {
                    formRow = $('<div class="ocb-form-row"></div>');
                    _this._dom.append(formRow);

                    if ($.isArray(e)) {
                        $.each(e, function(j, ee) {
                            formItem = new FormItem(formRow, ee, function(newValue, oldValue) {
                                _this.onChange();
                            });
                            _this.items.push(formItem);
                        })
                    } else if (typeof e === 'object') {
                        formItem = new FormItem(formRow, e, function(newValue, oldValue) {
                            _this.onChange();
                        });
                        _this.items.push(formItem);
                    }
                });

        },
        /**
         * 表单项目值被修改后调用
         */
        onChange: function() {
            var filterFieldValues = {};
            $.each(this.items, function(index, item) {
                addFieldValue(item.valueField, item.getValue());
            });

            this._parent.filterAndShow(filterFieldValues);

            function addFieldValue(field, value) {
                if (!filterFieldValues[field]) filterFieldValues[field] = [];
                if (!(value == null)) filterFieldValues[field].push(value);
            }
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
        this.type = opt.type;
        this.data = [];
        this.checked = opt.checked;
        this._parent = parent;
        this._desc = opt.desc;
        this._options = opt;
        this._onChange = onChange;
        this._dom = null;
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
            this._dom = $('<input id="' + (this._options.id || '') + '" name="' + this.valueField + '" value="' + this._options.value + '">');

            this._dom.attr('type', this.type === 'checkbox' ? 'checkbox' :
                (this.type === 'radio' ? 'radio' : 'text'));

            this._parent.append($('<span class="ocb-form-item"></span>').html(this._dom));

            if (this.type && $HUI[this.type]) {

                this.clearData();

                $HUI[this._options.type](this._dom, {
                    id: this._options.id,
                    width: this._parent.width(),
                    value: this._options.value,
                    prompt: this._options.prompt,
                    checked: this._options.checked,
                    label: this._options.label,
                    onChange: this._onChange,
                    onCheckChange: function(e, value) {
                        _this.checked = value; //HISUI 在onChange事件的时候没有先设置好input的值
                        _this._onChange();
                    },
                    valueField: 'value',
                    textField: 'text',
                    data: this.data
                });
            }
        },
        /**
         * 获取值
         */
        getValue: function() {
            var elementValue = $HUI[this.type](this._dom).getValue();

            if (this.type === 'checkbox' || this.type === 'radio') {
                if (this.checked) return $(this._dom).val();
                else return null;
            }

            return elementValue;
        },
        /**
         * 添加数据到选项中
         */
        appendData: function(operSchedule) {
            var r = {
                value: operSchedule[this.valueField],
                text: operSchedule[this.textField]
            };

            if (!this.contain(r)) {
                this.data.push(r);
            }
        },
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
         * 
         */
        clearData: function() {
            this.data = [];
            this.defaultData();
        },
        defaultData: function() {
            this.data.push({
                value: 'All',
                text: '全部' + this._options.desc
            });
        },
        reload: function() {
            if ($HUI[this.type](this._dom)['loadData']) {
                $HUI[this.type](this._dom)['loadData'](this.data);
            }
        }
    }

    /**
     * 构造手术卡片
     * @module OperScheduleCardboard~OperCard
     * @param {module: Data.operSchedule} operSchedule 
     * @param {object} opt
     */
    function OperCard(container, operSchedule, opt) {
        this.dataSource = operSchedule;
        this.selected = false;
        this._container = $(container);
        this._options = opt;
        this._dom = $('<div class="oper-card"></div>');
        this._menubutton = null;
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
            this._dom.draggable({
                revert: true,
                proxy: proxy,
                onBeforeDrag: function(e) {
                    if (!_this.selected) {
                        clearCardSelection();
                    }
                },
                onStopDrag: function(e) {
                    _this._dom.css({ left: 0, top: 0 });
                }
            });
            this._render();
        },
        /**
         * 渲染方法
         */
        _render: function() {
            var _this = this;
			this._dom.attr('data-opsId',this.dataSource.RowId);
            this._container.append(this._dom);

            this._menubutton = $('<span class="oper-card-menubutton">...</span>');
            this._dom.append(this._menubutton);
            this._menubutton.mouseenter(function() {
                event.stopPropagation();
                _this._options.menu.menu('show', $(this).offset());
                if (!_this.selected) {
                    clearCardSelection();
                    _this.select();
                }
            });

            var idInput = $('<input type="hidden" name="RowId" value="' + this.dataSource.RowId + '">');
            this._dom.append(idInput);

            var header = $('<div class="oper-card-header"></div>');
            if (this._options.header) {
                header.html(this._options.header(this.dataSource));
                this._dom.append(header);
            }

            var content = $('<div class="oper-card-content"></div>');
            content.html((this._options.content || _methods.OperCard.content)(this.dataSource));
            this._dom.append(content);

            var footer = $('<div class="oper-card-footer"></div>');
            var footerInnerHtml = (this._options.footer || _methods.OperCard.footer)(this.dataSource);
            if (footerInnerHtml) {
                footer.html(footerInnerHtml);
                this._dom.append(footer);
            }

            this._container.append(this._dom);

            this._dom.click(function() { _this.select() });
            this._dom.mouseenter(function() { _this.onEnter() });
            this._dom.mouseleave(function() { _this.onLeave() });
            this._dom.data('opercard', this);
        },
        onEnter: function() {
            //this._menubutton.show();
        },
        onLeave: function() {
            //this._menubutton.hide();
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
            if (!this.selected) _selectedCardsCount++;
            this._dom.addClass('oper-card-selected');
            this.selected = true;
        },
        /**
         * 取消选中当前手术卡片
         */
        unselect: function() {
            if (this.selected) _selectedCardsCount--;
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

    // 手术卡片默认方法设置
    _methods.OperCard = {
        /**
         * 通过手术安排数据对象获取相应的中部显示内容
         */
        content: function(operSchedule) {
            var contentArray = [];
            contentArray.push('<span style="font-weight:bold;">' + operSchedule.Patient + '</span>');
            contentArray.push('<span>' + operSchedule.PatDeptDesc + '</span>');
            contentArray.push('<span>' + operSchedule.SurgeonDesc + '</span>');
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
            if (operSchedule.Infection.indexOf("阳性")>=0) {
                footerArray.push('<span style="color:#ff0000;" title="'+operSchedule.InfectionLabData.replace(/#/g,"&#10;")+'">感</span>');
            }

            return footerArray.join('');
        }
    };

    /**
     * 卡片拖动的代理
     * @param {HTMLElement} source 
     */
    function proxy(source) {
        var container = $('<div style="z-index:10000;" class="oper-card-list"></div>');
        container.appendTo('body');

        if (_selectedCardsCount > 0) {
            $.each(_cards, function(i, card) {
                if (card.selected) {
                    cloneCardToContainer(card.getDom());
                }
            });
        } else {
            cloneCardToContainer(source);
        }

        function cloneCardToContainer(source) {
            var p = $('<div style="z-index:10000;" class="oper-card"></div>');
            p.css({ 'width': $(source).width(), height: $(source).height() });
            p.html($(source).clone().html()).appendTo(container);
        }
        return container;
    }

    function clearCardSelection() {
        $.each(_cards, function(i, card) {
            card.unselect();
        });
    }

    function getSelectedCards() {
        var cards = [];
        $.each(_cards, function(i, card) {
            if (card.selected) cards.push(card);
        });

        return cards;
    }

    function markAllSelectedCards() {
        $.each(_cards, function(i, card) {
            if (card.selected) card.mark();
        })
    }

    function unmarkAllSelectedCards() {
        $.each(_cards, function(i, card) {
            if (card.selected) card.unmark();
        })
    }

    var ctrl = false;
    $(document).delegate('body', 'keydown', function(event) {
        if (event.keyCode == 17) {
            ctrl = true;
            $.each(_cards, function(i, card) {
                card.disableDrag();
            });
        }
    });

    $(document).delegate('body', 'keyup', function(event) {
        if (event.keyCode == 17) {
            ctrl = false;
            $.each(_cards, function(i, card) {
                card.enableDrag();
            });
        }
    });

})));