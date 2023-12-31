//
/**
 * 数据快捷方式界面
 * @author yongyang 2018-11-12
 */
(function(global, factory) {
    if (!global.shortcutView) factory(global.shortcutView = {});
}(this, function(exports) {

    function init(opt) {
        var view = new ShortcutView(opt);
        exports.instance = view;
        return view;
    }

    exports.init = init;

    function ShortcutView(opt) {
        this.options = $.extend({ width: 460, height: 300 }, opt);
        this.saveHandler = opt.saveHandler;
        this.removeHandler = opt.removeHandler;
        this.applyHandler = opt.applyHandler;
        this.getPageDataHandler = opt.getPageDataHandler;

        this.drugCategories = opt.drugCategories;
        this.eventCategories = opt.eventCategories;
        this.intrmiDrugCategories = opt.intrmiDrugCategories;

        this.drugDataCreator = drugDataCreator;
        this.eventDataCreator = eventDataCreator;
        this.intrmiDrugCreator = intrmiDrugCreator;
        this.drugCateItemSelectionView = drugCateItemSelectionView;
        this.currentPageDataView = currentPageDataView;
        this.autoSettingView = autoSettingView;

        this.views = [
            this.drugDataCreator,
            this.eventDataCreator,
            this.intrmiDrugCreator,
            this.drugCateItemSelectionView,
            this.currentPageDataView,
            this.autoSettingView
        ];

        this.init();
    }

    ShortcutView.prototype = {
        constructor: ShortcutView,
        init: function() {
            var _this = this;
            this.dom = $('<div></div>').appendTo('body');
            this.form = $('<form></form>').appendTo(this.dom);
            var buttons = $('<div></div>');
            var btn_apply = $('<a href="#"></a>').linkbutton({
                text: '应用已选中数据',
                iconCls: 'icon-paste',
                onClick: function() {
                    _this.applyAllCheckedData();
                }
            }).appendTo(buttons);
            var btn_currentpage = $('<a href="#"></a>').linkbutton({
                text: '页面数据',
                iconCls: 'icon-copy',
                onClick: function() {
                    _this.currentPageDataView.position($(this).offset());
                    _this.loadDataFromCurrentPage();
                }
            }).appendTo(buttons);
            var btn_close = $('<a href="#"></a>').linkbutton({
                text: '关闭',
                iconCls: 'icon-close',
                onClick: function() {
                    _this.close();
                }
            }).appendTo(buttons);

            this.dom.dialog({
                left: 300,
                top: 50,
                height: this.options.height,
                width: this.options.width,
                title: '用药和事件快捷方式',
                modal: false,
                closed: true,
                resizable: true,
                buttons: buttons,
                onOpen: function() {

                },
                onClose: function() {
                    _this.closeSelectionViews();
                    _this.saveCheckStatus();
                },
                onResize: function() {
                    _this.resetDataContainer();
                }
            });

            this.drugDataCreator.init({
                onOpen: function() {
                    _this.closeSelectionViews(this)
                },
                onSave: function(data) {
                    _this.save(data);
                }
            });
            this.drugDataCreator.setComboDataSource(this.options.comboDataSource);

            this.drugCateItemSelectionView.init({
                onOpen: function() {
                    //_this.closeSelectionViews(this)
                }
            });
            this.drugCateItemSelectionView.render(this.drugCategories);

            this.eventDataCreator.init({
                onOpen: function() {
                    _this.closeSelectionViews(this)
                },
                onSave: function(data) {
                    _this.save(data);
                }
            });
            this.eventDataCreator.render(this.eventCategories);

            this.currentPageDataView.init({
                onOpen: function() {
                    _this.closeSelectionViews(this)
                }
            });
            this.currentPageDataView.setOptions({
                onSave: function(data) {
                    _this.save(data);
                }
            });

            this.autoSettingView.init({
                onOpen: function() {
                    _this.closeSelectionViews(this)
                },
                onSave: function(data) {
                    _this.save(data);
                }
            });

            this.initForm();
            this.initHandler();
        },
        initForm: function() {
            this.form.form({});

            var timeRow = $('<div class="editview-f-r"></div>').appendTo(this.form);
            var label = $('<div class="label">时间：</div>').appendTo(timeRow);
            this.StartDT = $('<input type="text">').appendTo(timeRow);
            this.StartDT.datetimebox({
                required: true,
                width: 200,
                label: label
            });

            this.dataContainer = $('<div class="editview-f-container" style="overflow-x:hidden;overflow-y:auto;"></div>').appendTo(this.form);
            this.resetDataContainer();
        },
        resetDataContainer: function() {
            var height = this.dom.height();
            if (this.dataContainer) this.dataContainer.height(height - 97);
        },
        initHandler: function() {
            var _this = this;
            this.dom.delegate('.shortcutview-item', 'dblclick', function(e) {
                var data = $(this).data('data');
                _this.apply(data);
            });

            this.dom.delegate('.shortcutview-item-edit', 'click', function(e) {
                var event = e || window.event;
                event.preventDefault();
                event.stopPropagation();

                var data = $($(this).parent()).data('data');
                var pos = $(this).offset();
                _this.openCreateView(data.Type, data, pos);

                event.returnValue = false;
                return false;
            });

            this.dom.delegate('.shortcutview-item-auto', 'click', function(e) {
                var event = e || window.event;
                event.preventDefault();
                event.stopPropagation();

                var data = $($(this).parent()).data('data');
                var pos = $(this).offset();
                _this.openAutoSettingView(data, pos);

                event.returnValue = false;
                return false;
            });

            this.dom.delegate('.shortcutview-item-remove', 'click', function(e) {
                var event = e || window.event;
                event.preventDefault();
                event.stopPropagation();

                var data = $($(this).parent()).data('data');
                $.messager.confirm('删除确认', '您确定删除此条数据？', function(confirmed) {
                    if (confirmed) {
                        data.ClassName = ANCLS.Config.UserPreferedData;
                        _this.removeItem(data);
                    }
                });

                event.returnValue = false;
                return false;
            });
        },
        setOptions: function(opt) {
            $.extend(this.options, opt);
        },
        setDateTime: function(locDT) {
            this.StartDT.datetimebox('setValue', locDT.format(constant.dateTimeFormat));
        },
        /**
         * 应用此快捷数据到界面
         * @param {*} data 
         */
        apply: function(data) {
            if (this.applyHandler) this.applyHandler(data, this.StartDT.datetimebox('getValue'));
        },
        /**
         * 应用多项数据到界面
         */
        applyAllCheckedData: function() {
            var length = this.data.length;
            var applyingData = [];
            for (var i = 0; i < length; i++) {
                var row = this.data[i];
                if (row.Checked === 'Y') applyingData.push(row);
            }

            if (this.applyHandler) this.applyHandler(applyingData, this.StartDT.datetimebox('getValue'));
            this.close();
        },
        loadData: function(data) {
            this.data = data;
            this.groups = groupingData(data);
            this.render();
        },
        render: function() {
            var _this = this;
            var length = this.groups.length;
            var element = null;
            this.dataContainer.empty();
            this.dataContainer.hide();
            for (var i = 0; i < length; i++) {
                var group = this.groups[i];
                element = $('<div class="shortcutview-group"></div>').appendTo(this.dataContainer);
                groupView.render(element, this.groups[i]);
                if (group.key === 'I') continue;
                var element = $('<a href="javascript:;" class="shortcutview-item-add" data-key="' + group.key + '"><span class="fas fa-plus"></span></a>').appendTo(element);
                element.bind('click', function() {
                    var key = $(this).attr('data-key');
                    var pos = $(this).offset();
                    _this.openCreateView(key, null, pos);
                });
            }
            this.dataContainer.show();
        },
        openCreateView: function(key, data, pos) {
            switch (key) {
                case 'D':
                    this.drugDataCreator.open();
                    if (data) this.drugDataCreator.loadData(data);
                    break;
                case 'E':
                    this.eventDataCreator.position(pos);
                    this.eventDataCreator.open();
                    break;
                default:
                    break;
            }
        },
        openAutoSettingView: function(data, pos) {
            this.autoSettingView.position(pos);
            this.autoSettingView.open();
            this.autoSettingView.render(data);
        },
        isIntrmiDrugData: function(data) {
            if (!this.intrmiDrugCategoryIdList) {
                this.intrmiDrugCategoryIdList = [];
                var length = this.intrmiDrugCategories.length;
                for (var i = 0; i < length; i++) {
                    this.intrmiDrugCategoryIdList.push(this.intrmiDrugCategories[i].RowId);
                }
            }
            var categoryId = data.DataCategory;
            return this.intrmiDrugCategoryIdList.indexOf(categoryId) > -1;
        },
        loadUserDefinedItems: function(userDefinedItems) {

        },
        loadDataFromCurrentPage: function() {
            if (this.getPageDataHandler) {
                this.pageDatas = this.getPageDataHandler();
                this.regulatePageDatas(this.pageDatas);
            }
        },
        regulatePageDatas: function(data) {
            var regulatedData = [];
            var length = data.length;
            for (var i = 0; i < length; i++) {
                var row = data[i];
                var timeSpanMinutes = '';
                if (row.ItemCategory == 'V') continue;
                if (row.Continuous == 'Y') timeSpanMinutes = 0;
                if (row.EndDT < MAXDATE) timeSpanMinutes = new TimeSpan(row.EndDT, row.StartDT).totalMinutes;
                var type = row.ItemCategory;
                if (this.isIntrmiDrugData(row)) type = 'I';

                var regulatedRow = {
                    Continuous: row.Continuous,
                    TimeSpanMinutes: timeSpanMinutes,
                    DataValue: '',
                    Category: row.DataCategory,
                    CategoryItem: row.CategoryItem,
                    UserDefinedItem: row.UserDefinedItem,
                    DataItem: row.DataItem,
                    Description: row.Description || row.DataItemDesc,
                    Type: type
                }

                if (row.DrugData) {
                    regulatedRow.DrugData = $.extend({}, row.DrugData, {
                        RowId: ''
                    });

                    var drugDataList = [];
                    drugDataList.push(regulatedRow.DrugData);
                    var drugDataLength = row.DrugDataList.length;
                    for (var j = 1; j < drugDataLength; j++) {
                        drugDataList.push($.extend({}, row.DrugDataList[j], { RowId: '' }));
                    }

                    regulatedRow.DrugDataList = drugDataList;
                }

                if (row.EventDetailDatas && row.EventDetailDatas.length > 0) {
                    var eventDataList = [];
                    var eventDataLength = row.EventDetailDatas.length;
                    for (var j = 0; j < eventDataLength; j++) {
                        eventDataList.push($.extend({}, row.EventDetailDatas[j], { RowId: '' }));
                    }

                    regulatedRow.EventDetailDatas = eventDataList;
                }

                regulatedData.push(regulatedRow);
            }
            this.regultedGroups = groupingData(regulatedData);
            this.currentPageDataView.render(this.regultedGroups);
            this.currentPageDataView.open();
        },
        open: function() {
            this.dom.dialog('open');
        },
        close: function() {
            this.dom.dialog('close');
        },
        closeSelectionViews: function(view) {
            var length = this.views.length;
            for (var i = 0; i < length; i++) {
                if (view != this.views[i]) this.views[i].close();
            }
        },
        removeItem: function(data) {
            data.target.remove();
            if (this.removeHandler) this.removeHandler(data);
        },
        save: function(data) {
            var preparedDatas = [];
            prepareSavingDatas();
            if (this.saveHandler) this.saveHandler(preparedDatas);


            function prepareSavingDatas() {
                var dataClassName = ANCLS.Config.UserPreferedData;
                var drugClassName = ANCLS.Config.UserPreferedDrug;
                var eventClassName = ANCLS.Config.UserPreferedEventDetail;

                var guid = dhccl.guid();
                var userId = session.UserID;
                var moduleId = session.ModuleID;
                preparedDatas.push($.extend({
                    RowId: data.RowId || '',
                    Continuous: data.Continuous || '',
                    TimeSpanMinutes: data.TimeSpanMinutes || '',
                    DataValue: data.DataValue || '',
                    Category: data.Category || '',
                    CategoryItem: data.CategoryItem || '',
                    UserDefinedItem: data.UserDefinedItem || '',
                    DataItem: data.DataItem || '',
                    Description: data.Description || '',
                    Type: data.Type || '',
					AutoGenerate: data.AutoGenerate || '',
					GenerateTimeSpan: data.GenerateTimeSpan || ''
                }, {
                    Guid: guid,
                    ClassName: dataClassName,
                    DataModule: moduleId,
                    CreateUserID: userId,
                    Accessibility: 'Private'
                }));
				if (data.DrugData) {
                    preparedDatas.push($.extend(data.DrugData, {
                        DataGuid: guid,
                        ClassName: drugClassName
                    }));
                }
				//else if(data.Type=="E"){
					
				//}
                else if (data.EventDetailDatas) {
                    var length = data.EventDetailDatas.length;
                    for (var i = 0; i < length; i++) {
                        preparedDatas.push($.extend(data.EventDetailDatas[i], {
                            DataGuid: guid,
                            ClassName: eventClassName
                        }));
                    }
                } else  if (data.DrugDataList) {
                    var length = data.DrugDataList.length;
                    for (var i = 0; i < length; i++) {
                        preparedDatas.push($.extend(data.DrugDataList[i], {
                            DataGuid: guid,
                            ClassName: drugClassName
                        }));
                    }
                }
            }
        },
        saveCheckStatus: function() {
            var data = this.data;
            var preparedDatas = [];
            var dataClassName = ANCLS.Config.UserPreferedData;

            var length = data.length;
            for (var i = 0; i < length; i++) {
                var row = data[i];
                if (row.isChanged) {
                    preparedDatas.push($.extend({
                        RowId: row.RowId,
                        Checked: row.Checked
                    }, {
                        ClassName: dataClassName
                    }));
                }
            }

            if (this.saveHandler) this.saveHandler(preparedDatas);
        }
    }

    var id_prefix = 'shortcut_item_';
    var id_count = 1;
    /**
     * 单条数据渲染
     */
    var itemView = {
        render: function(dom, data) {
            dom.data('data', data);
            dom.empty();
            data.target = dom;

            var id = id_prefix + (id_count++);
            var check = $('<input id="' + id + '" type="' +
                    (data.RowId ? 'checkbox' : 'hidden') + '" ' +
                    (data.Checked === 'Y' ? 'checked' : 'unchecked') + '>')
                .appendTo(dom);

            var text = data.Description;
            if (data.Type == "D" && data.DrugData) {
                if (data.DrugData.Speed) text = text + data.DrugData.Speed + data.DrugData.SpeedUnitDesc;
                else if (data.DrugData.DoseQty) text = text + data.DrugData.DoseQty + data.DrugData.DoseUnitDesc;
                if (data.DrugData.Concentration) text = text + data.DrugData.Concentration + data.DrugData.ConcentrationUnitDesc;
                if (data.DrugData.TCI === 'Y') text = text + ' TCI';
            }
            if (data.Type == 'I') {
                var textArr = [];
                if (data.DrugDataList) {
                    var length = data.DrugDataList.length;
                    for (var i = 0; i < length; i++) {
                        var drugData = data.DrugDataList[i];
                        textArr.push((drugData.Description || drugData.ArcimDesc) + " " +
                            drugData.DoseQty + drugData.DoseUnitDesc +
                            (drugData.InstructionDesc ? (" " + drugData.InstructionDesc) : "") +
                            (drugData.Note ? (" " + drugData.Note) : ""));
                    }
                    text = textArr.join('<br/>');
                }
            }

            if (data.Continuous === 'Y') text = text + ' 持续';
            if (data.TimeSpanMinutes && Number(data.TimeSpanMinutes) > 0) text = text + data.TimeSpanMinutes + '分钟';

            dom.append('<label for="' + id + '">' + text + '</label>');
            check.checkbox({
                onChecked: function() {
                    var data = $($(this).parent()).data('data');
                    if (data.Checked != 'Y') data.isChanged = true;
                    data.Checked = 'Y';
                },
                onUnchecked: function() {
                    var data = $($(this).parent()).data('data');
                    if (data.Checked != 'N') data.isChanged = true;
                    data.Checked = 'N';
                }
            });

            if (data.RowId) {
                if (data.Type == 'D') dom.append('<span class="shortcutview-item-edit item-button icon icon-edit" title="修改此快捷数据"></span>');
                else dom.append('<span class="shortcutview-item-auto item-button icon icon-gear" title="自动添加此数据到界面"></span>');
                dom.append('<span class="shortcutview-item-remove item-button icon icon-cancel" title="删除此快捷数据"></span>');
            } else {
                dom.append('<span class="shortcutview-item-add item-button icon icon-add" title="添加到模板"></span>')
            }
        }
    }

    /**
     * 数据分组渲染
     */
    var groupView = {
        render: function(dom, group) {
            dom.data('data', group);
            dom.empty();
            group.target = dom;
            $('<div class="shortcutview-group-header"></div>')
                .append('<span class="header-text">' + group.desc + '</span>')
                .appendTo(dom);
            var itemsContainer = $('<div class="shortcutview-group-items"></div>').appendTo(dom);

            var items = group.items;
            var length = items.length;
            var item = null,
                element = null;
            for (var j = 0; j < length; j++) {
                item = items[j];
                element = $('<a href="#" class="shortcutview-item"></a>').appendTo(itemsContainer);
                itemView.render(element, item);
            }
        }
    }

    /**
     * 将数据分组
     * @param {*} data
     */
    function groupingData(data) {
        var types = ['D', 'E', 'I'];
        var groups = [{
            key: 'D',
            desc: '用药',
            items: []
        }, {
            key: 'E',
            desc: '事件',
            items: []
        }, {
            key: 'I',
            desc: '间断给药',
            items: []
        }];
        var length = data.length;
        var row = null,
            index = -1;
        for (var i = 0; i < length; i++) {
            row = data[i];
            index = types.indexOf(row.Type);
            if (index > -1) {
                groups[index].items.push(row);
                // } else {
                //     types.push(row.Type);
                //     groups.push({
                //         key: row.Type,
                //         desc: row.TypeDesc,
                //         items: [row]
                //     })
            }
        }

        return groups;
    }

    /**
     * 当前页数据显示
     */
    var currentPageDataView = {
        closed: false,
        init: function(opt) {
            this.options = opt;
            var _this = this;
            this.dom = $('<div class="shortcutview-currentpagedataview"></div>').appendTo('body');
            this.container = $('<div class="shortcutview-currentpagedataview-container"></div>').appendTo(this.dom);
            this.close();

            // this.dom.mouseleave(function() {
            //     _this.close();
            // });

            this.dom.delegate('.shortcutview-item-add', 'click', function() {
                var data = $($(this).parent()).data('data');
                if (_this.options.onSave) _this.options.onSave.call(_this, data);
                $(this).addClass('icon-ok');
                $(this).removeClass('icon-add');
            });

            var closeButton = $('<a href="javascript:;" class="selectionview-close" title="关闭" style="position:absolute;top:0px;right:0px;background-color:#eee;"><span class="icon icon-close"></span></a>')
                .click(function() {
                    _this.close();
                })
                .appendTo(this.dom);

            return this;
        },
        setOptions: function(opt) {
            $.extend(this.options, opt);
        },
        /**
         * 渲染
         */
        render: function(groups) {
            this.groups = groups;
            var container = this.container;
            container.empty();
            var length = groups.length;
            for (var i = 0; i < length; i++) {
                var group = this.groups[i];
                element = $('<div class="shortcutview-group"></div>').appendTo(this.container);
                groupView.render(element, this.groups[i]);
            }
            return this;
        },
        /**
         * 打开当前页数据选择框
         */
        open: function() {
            this.dom.show();
            this.closed = false;
            if (this.options.onOpen) this.options.onOpen.call(this);
            return this;
        },
        /**
         * 关闭当前页数据选择框
         */
        close: function() {
            this.dom.hide();
            this.closed = true;
            return this;
        },
        position: function(position) {
            this.dom.css({ left: position.left - 230, top: position.top - 215 });
            return this;
        }
    }

    /**
     * 自动生成设置
     */
    var autoSettingView = {
        closed: false,
        init: function(opt) {
            this.options = opt;
            var _this = this;
            this.dom = $('<div class="shortcutview-autosettingview"></div>').appendTo('body');
            this.container = $('<div class="shortcutview-autosettingview-container"></div>').appendTo(this.dom);
            this.close();


            this.form = $('<form class="autosettingview-form"></form>').appendTo(this.container);
            this.form.form({});

            var row = $('<div class="editview-f-r"><label for="autosettingview_AutoGenerate" class="label">开始监护自动生成：</label></div>').appendTo(this.form);
            this.AutoGenerate = $('<input id="autosettingview_AutoGenerate" type="checkbox" name="AutoGenerate">').appendTo(row);
            this.AutoGenerate.checkbox({});

            var row = $('<div class="editview-f-r"><label for="autosettingview_GenerateTimeSpan" class="label">间隔分钟数：</label></div>').appendTo(this.form);
            this.GenerateTimeSpan = $('<input id="autosettingview_GenerateTimeSpan" type="text" name="GenerateTimeSpan">').appendTo(row);
            this.GenerateTimeSpan.numberbox({
                width: 60
            });

            this.bottom = $('<div style="text-align:center;margin-top:5px;"></div>').appendTo(this.container);
            this.btn_ok = $('<a href="#"></a>').linkbutton({
                text: '确定',
                iconCls: 'icon-ok',
                onClick: function() {
                    _this.save();
                    _this.close();
                }
            }).appendTo(this.bottom);

            var closeButton = $('<a href="javascript:;" class="selectionview-close" title="关闭" style="position:absolute;top:0px;right:0px;background-color:#eee;"><span class="icon icon-close"></span></a>')
                .click(function() {
                    _this.close();
                })
                .appendTo(this.dom);

            return this;
        },
        /**
         * 渲染
         */
        render: function(data) {
            this.originalData = data;
            this.AutoGenerate.checkbox('setValue', (data.AutoGenerate === 'Y' ? true : false));
            this.GenerateTimeSpan.numberbox('setValue', data.GenerateTimeSpan);
        },
        /**
         * 保存
         */
        save: function() {
            this.originalData.AutoGenerate = this.AutoGenerate.prop('checked') ? 'Y' : 'N';
            this.originalData.GenerateTimeSpan = this.GenerateTimeSpan.numberbox('getValue');
            if (this.options.onSave) this.options.onSave.call(this, this.originalData);
        },
        /**
         * 打开自动生成数据选择框
         */
        open: function() {
            this.dom.show();
            this.closed = false;
            if (this.options.onOpen) this.options.onOpen.call(this);
            return this;
        },
        /**
         * 关闭自动生成数据选择框
         */
        close: function() {
            this.dom.hide();
            this.closed = true;
            this.originalData = null;
            return this;
        },
        position: function(position) {
            this.dom.css({ left: position.left + 30, top: position.top - 20 });
            return this;
        }
    }

    /**
     * 药品数据创建界面
     */
    var drugDataCreator = {
        init: function(opt) {
            var _this = this;
            this.options = opt;
            this.canChangeCategoryItem = true;
            this.dom = $('<div></div>').appendTo('body');
            this.form = $('<form class="drugeditor-editview-form"></form>').appendTo(this.dom);

            var buttons = $('<div></div>');
            var btn_save = $('<a href="#"></a>').linkbutton({
                text: '保存',
                iconCls: 'icon-save',
                onClick: function() {
                    _this.save();
                }
            }).appendTo(buttons);
            var btn_cancel = $('<a href="#"></a>').linkbutton({
                text: '取消',
                iconCls: 'icon-cancel',
                onClick: function() {
                    _this.close();
                }
            }).appendTo(buttons);

            this.dom.dialog({
                left: 300,
                top: 50,
                height: 450,
                width: 320,
                title: '快捷用药数据',
                modal: false,
                closed: true,
                buttons: buttons,
                resizable: false,
                onOpen: function() {
                    if (_this.options.onOpen)
                        _this.options.onOpen.call(_this);
                },
                onClose: function() {
                    _this.clear();
                }
            });
            this.initForm();

            this.drugCateItemSelectionView = drugCateItemSelectionView;
            this.drugCateItemSelectionView.setOptions({
                onClickItem: function(item) {
                    _this.setItem(item);
                }
            });
        },
        initForm: function() {
            var _this = this;
            this.form.form({});

            this.RowId = $('<input type="hidden" name="RowId">').appendTo(this.form);
            this.CategoryRowId = $('<input type="hidden" name="Category">').appendTo(this.form);

            var itemRow = $('<div class="drugeditor-editview-f-r"><div class="label">药品项：</div></div>').appendTo(this.form);
            this.CategoryItem = $('<span class="drugeditor-editview-drugitem" style="width:200px;"></span>').appendTo(itemRow);
            this.CategoryItemRowId = $('<input type="hidden" name="CategoryItem">').appendTo(itemRow);
            this.DataItemRowId = $('<input type="hidden" name="DataItem">').appendTo(itemRow);
            this.UserDefinedItemRowId = $('<input type="hidden" name="UserDefinedItem">').appendTo(itemRow);

            var itemRow = $('<div class="drugeditor-editview-f-r" style="display:none;"><div class="label">医嘱项：</div></div>').appendTo(this.form);
            this.DrugItem = $('<span class="drugeditor-editview-drugitem"></span>').appendTo(itemRow);
            this.DrugItemID = $('<input type="hidden" name="DrugItem">').appendTo(itemRow);
            this.ArcimID = $('<input type="hidden" name="ArcimID">').appendTo(itemRow);
            this.DrugItemDesc = $('<input type="hidden" name="DrugItemDesc">').appendTo(itemRow);

            this.CategoryItem.click(function() {
                if (_this.canChangeCategoryItem) {
                    _this.drugCateItemSelectionView.position($(this).offset());
                    _this.drugCateItemSelectionView.open();
                    $(this).addClass('drugeditor-editview-drugitem-selected');
                }
            });

            this.DrugItem.click(function() {
                arcimSelectionView.position($(this).offset());
                arcimSelectionView.open();
                $(this).addClass('drugeditor-editview-drugitem-selected');
            });

            var itemRow = $('<div class="drugeditor-editview-f-r"></div>').appendTo(this.form);
            var label = $('<label class="label" for="drugeditor_continuous">持续：</label>').appendTo(itemRow);
            this.Continuous = $('<input id="drugeditor_continuous" type="checkbox" name="Continuous">').appendTo(itemRow);
            this.Continuous.checkbox({
                onChecked: function(e, value) {
                    _this.TimeSpanMinutes.numberbox('enable');

                    _this.Speed.validatebox('enable');
                    _this.SpeedUnit.combobox('enable');
                },
                onUnchecked: function(e, value) {
                    _this.TimeSpanMinutes.numberbox('disable');
                    _this.TimeSpanMinutes.numberbox('setValue', 0);

                    _this.Speed.validatebox('disable');
                    _this.SpeedUnit.combobox('disable');
                }
            });

            var label = $('<label class="label" for="drugeditor_tci" style="float:none;display:inline-block;">靶控：</label>').appendTo(itemRow);
            this.TCI = $('<input id="drugeditor_tci" type="checkbox" name="TCI">').appendTo(itemRow);
            this.TCI.checkbox({
                onChecked: function(e, value) {
                    _this.Continuous.checkbox('setValue', true);
                },
                onUnchecked: function(e, value) {
                    _this.Continuous.checkbox('setValue', false);
                }
            });

            var timeRow = $('<div class="drugeditor-editview-f-r"></div>').appendTo(this.form);
            var label = $('<div class="label">持续分钟：</div>').appendTo(timeRow);
            this.TimeSpanMinutes = $('<input type="text">').appendTo(timeRow);
            this.TimeSpanMinutes.numberbox({
                width: 200,
                disabled: true,
                label: label
            });

            var doseRow = $('<div class="drugeditor-editview-f-r"></div>').appendTo(this.form);
            var label = $('<div class="label">剂量：</div>').appendTo(doseRow);
            this.DoseQty = $('<input class="textbox" type="text" style="width:93px;margin-right:5px;">').appendTo(doseRow);
            this.DoseUnit = $('<input type="text">').appendTo(doseRow);
            this.DoseQty.validatebox({
                width: 100,
                label: label,
                novalidate: true
            });
            this.DoseUnit.combobox({
                width: 95,
                valueField: "RowId",
                textField: "Description",
                cls: 'drugeditor-editview-f-r-unit'
            });

            var speedRow = $('<div class="drugeditor-editview-f-r"></div>').appendTo(this.form);
            var label = $('<div class="label">速度：</div>').appendTo(speedRow);
            this.Speed = $('<input class="textbox" type="text" disabled style="width:93px;margin-right:5px;">').appendTo(speedRow);
            this.SpeedUnit = $('<input type="text">').appendTo(speedRow);
            this.Speed.validatebox({
                width: 100,
                label: label,
                novalidate: true,
                disabled: true
            });
            this.SpeedUnit.combobox({
                width: 95,
                disabled: true,
                valueField: "RowId",
                textField: "Description",
                cls: 'drugeditor-editview-f-r-unit'
            });

            var concentrationRow = $('<div class="drugeditor-editview-f-r"></div>').appendTo(this.form);
            var label = $('<div class="label">浓度：</div>').appendTo(concentrationRow);
            this.Concentration = $('<input class="textbox" type="text" style="width:93px;margin-right:5px;">').appendTo(concentrationRow);
            this.ConcentrationUnit = $('<input type="text">').appendTo(concentrationRow);
            this.Concentration.validatebox({
                width: 100,
                label: label,
                novalidate: true
            });
            this.ConcentrationUnit.combobox({
                width: 95,
                valueField: "RowId",
                textField: "Description",
                cls: 'drugeditor-editview-f-r-unit'
            });

            var instructionRow = $('<div class="drugeditor-editview-f-r"></div>').appendTo(this.form);
            var label = $('<div class="label">用药途径：</div>').appendTo(instructionRow);
            this.Instruction = $('<input type="text">').appendTo(instructionRow);
            this.Instruction.combobox({
                width: 200,
                valueField: "RowId",
                textField: "Description",
                label: label
            });

            var reasonRow = $('<div class="drugeditor-editview-f-r"></div>').appendTo(this.form);
            var label = $('<div class="label">原因：</div>').appendTo(reasonRow);
            this.Reason = $('<input type="text">').appendTo(reasonRow);
            this.Reason.combobox({
                width: 200,
                valueField: "RowId",
                textField: "Description",
                label: label
            });

            var receiveLocRow = $('<div class="drugeditor-editview-f-r" style="display:none;"></div>').appendTo(this.form);
            var label = $('<div class="label">接收科室：</div>').appendTo(receiveLocRow);
            this.RecvLoc = $('<input type="text">').appendTo(receiveLocRow);
            this.RecvLoc.combobox({
                width: 200,
                valueField: "Id",
                textField: "Desc",
                label: label
            });
        },
        loadData: function(data) {
            if (data) {
                this.originalData = data;
                this.Speed.validatebox("setValue", data.DrugData.Speed);
                this.ArcimID.val(data.DrugData.ArcimID);
                this.DrugItem.text(data.DrugData.ArcimDesc);
                this.RecvLoc.combobox("setValue", data.DrugData.RecvLoc);
                this.RecvLoc.combobox("setText", data.DrugData.RecvLocDesc);
                this.DoseQty.validatebox("setValue", data.DrugData.DoseQty);
                this.DoseUnit.combobox("setValue", data.DrugData.DoseUnit);
                this.Speed.validatebox("setValue", data.DrugData.Speed);
                this.SpeedUnit.combobox("setValue", data.DrugData.SpeedUnit);
                this.Concentration.validatebox("setValue", data.DrugData.Concentration);
                this.ConcentrationUnit.combobox("setValue", data.DrugData.ConcentrationUnit);
                this.Instruction.combobox("setValue", data.DrugData.Instruction);
                this.Reason.combobox("setText", data.DrugData.Reason);
                this.Continuous.checkbox('setValue', data.Continuous === 'Y' ? true : false);
                this.TCI.checkbox('setValue', data.DrugData.TCI === 'Y' ? true : false);
                this.TimeSpanMinutes.numberbox('setValue', data.TimeSpanMinutes);
                this.CategoryRowId.val(data.Category);
                this.CategoryItem.text(data.DrugData.Description);
                this.CategoryItemRowId.val(data.CategoryItem);
                this.DataItemRowId.val(data.DrugData.DataItem);
            }
        },
        setComboDataSource: function(dataList) {
            this.DoseUnit.combobox('loadData', dataList.DoseUnits || []);
            this.SpeedUnit.combobox('loadData', dataList.SpeedUnits || []);
            this.ConcentrationUnit.combobox('loadData', dataList.ConcentrationUnits || []);
            this.Instruction.combobox('loadData', dataList.Instructions || []);
            this.Reason.combobox('loadData', dataList.Reasons || []);
        },
        setItem: function(item) {
            if (item.DataItem) {
                this.CategoryItem.text(item.ItemDesc);
                this.CategoryRowId.val(item.DataCategory);
                this.CategoryItemRowId.val(item.RowId);
                this.DataItemRowId.val(item.DataItem);
            } else {
                this.CategoryItem.text(item.Description);
                this.UserDefinedItemRowId.val(item.RowId);
            }
        },
        /**
         * 清空表单项
         */
        clear: function() {
            this.form.form('clear');
            this.originalData = null;
            this.CategoryItem.text('');
        },
        /**
         * 打开编辑框
         */
        open: function() {
            this.dom.dialog('open');
        },
        /**
         * 关闭
         */
        close: function() {
            this.dom.dialog('close');
        },
        toData: function() {
            return {
                Continuous: this.Continuous.checkbox('getValue') ? 'Y' : 'N',
                TimeSpanMinutes: this.TimeSpanMinutes.numberbox('getValue'),
                DataValue: '',
                Category: this.CategoryRowId.val(),
                CategoryItem: this.CategoryItemRowId.val(),
                UserDefinedItem: this.UserDefinedItemRowId.val(),
                DataItem: this.DataItemRowId.val(),
                Description: this.CategoryItem.text(),
                Type: 'D',
                DrugData: {
                    DoseQty: this.DoseQty.validatebox("getValue"),
                    DoseUnit: this.DoseUnit.combobox("getValue"),
                    Instruction: this.Instruction.combobox("getValue"),
                    Concentration: this.Concentration.validatebox("getValue"),
                    ConcentrationUnit: this.ConcentrationUnit.combobox("getValue"),
                    Speed: this.Speed.validatebox("getValue"),
                    SpeedUnit: this.SpeedUnit.combobox("getValue"),
                    BalanceQty: "",
                    Reason: this.Reason.combobox("getText"),
                    BalanceDisposal: "",
                    RecvLoc: this.RecvLoc.combobox('getValue'),
                    ArcimID: this.ArcimID.val(),
                    OrderItemID: "",
                    DoseUnitDesc: this.DoseUnit.combobox("getText"),
                    SpeedUnitDesc: this.SpeedUnit.combobox("getText"),
                    ConcentrationUnitDesc: this.ConcentrationUnit.combobox("getText"),
                    InstructionDesc: this.Instruction.combobox("getText"),
                    ArcimDesc: this.DrugItem.text(),
                    RecvLocDesc: this.RecvLoc.combobox('getText'),
                    Continuous: this.Continuous.checkbox('getValue') ? 'Y' : 'N',
                    Description: this.CategoryItem.text(),
                    DataItem: this.DataItemRowId.val(),
                    UserDefinedItem: this.UserDefinedItemRowId.val(),
                    TCI: this.TCI.checkbox('getValue') ? 'Y' : 'N'
                }
            }
        },
        /**
         * 保存
         */
        save: function() {
            var newData = this.toData();
            var originalData = this.originalData;
            if (originalData) {
                newData = $.extend(originalData, newData);
                newData.DrugData = $.extend(originalData.DrugData, newData.DrugData);
            }

            if (this.options.onSave) this.options.onSave.call(this, newData);
            this.close();
        },
        position: function(pos) {

        }
    }

    /**
     * 药品项选择
     */
    var drugCateItemSelectionView = {
        closed: false,
        init: function(opt) {
            this.setOptions(opt);
            var _this = this;
            this.dom = $('<div class="drugeditor-selectionview"></div>').appendTo('body');
            this.container = $('<div class="drugeditor-selectionview-container"></div>').appendTo(this.dom);
            this.close();

            this.dom.mouseleave(function() {
                _this.close();
            });

            this.header = $('<div class="drugeditor-selectionview-header"></div>').appendTo(this.container);
            var searchBox = $('<input type="text">').appendTo(this.header);
            searchBox.searchbox({
                width: 200,
                prompt: '输入简拼或汉字搜索',
                iconCls: 'icon-search',
                iconAlign: 'right',
                onClickButton: function() {
                    var text = $(this).validatebox('getText');
                    _this.filter();
                }
            });

            var inputRect = searchBox.siblings('.searchbox');
            $(inputRect).find('input').keyup(function() {
                _this.FilterStr = $(this).val().toUpperCase();
                _this.filter(_this.FilterStr);
            });

            this.header.delegate('input', 'keyup', function(e) {
                if (e.keyCode == 13) {
                    var text = $(this).val();
                    _this.filter(text);
                }
            });

            this.itemContainer = $('<div class="drugeditor-selectionview-items"></div>').appendTo(this.container);

            this.dom.delegate('.categoryitem-button', 'click', function() {
                var callback = _this.options.onClickItem;
                if (callback) callback.call(_this, $(this).data('data'));
            });

            return this;
        },
        /**
         * 渲染
         */
        render: function(dataCategories) {
            this.items = [];
            var items = [];
            var container = this.itemContainer;
            container.empty();
            var length = dataCategories.length;
            for (var i = 0; i < length; i++) {
                var dataCategory = dataCategories[i];
                var subCatLength = dataCategory.subCategories.length;
                for (var j = 0; j < subCatLength; j++) {
                    var subCategory = dataCategory.subCategories[j];
                    $.each(subCategory.items || [], function(index, categoryItem) {
                        var element = null;
                        element = $('<a href="#" class="categoryitem-button"></a>').text(categoryItem.ItemDesc).appendTo(container);
                        element.data('data', categoryItem);
                        categoryItem.target = element;
                        items.push(categoryItem);
                    });
                }
            }
            this.items = items;
            return this;
        },
        filter: function(filterString) {
            var _this = this;
            var length = this.items.length;
            var filterString = filterString;
            for (var i = 0; i < length; i++) {
                var item = this.items[i];
                var desc = item.ItemDesc.toUpperCase();
                var alias = item.Alias || '';
                if (!filterString ||
                    desc.indexOf(filterString) > -1 ||
                    alias.indexOf(filterString) > -1
                ) {
                    item.target.show();
                } else {
                    item.target.hide();
                }
            }
        },
        setOptions: function(opt) {
            if (!this.options) this.options = {};
            $.extend(this.options, opt);
        },
        /**
         * 打开药品选择框
         */
        open: function() {
            this.dom.show();
            this.closed = false;
            if (this.options.onOpen) this.options.onOpen.call(this);
            return this;
        },
        /**
         * 关闭药品选择框
         */
        close: function() {
            this.dom.hide();
            this.closed = true;
            return this;
        },
        position: function(position) {
            this.dom.css({ left: position.left + 205, top: position.top - 10 });
            return this;
        }
    }

    var eventDataCreator = {
        init: function(opt) {
            this.options = opt;
            var _this = this;
            this.dom = $('<div class="eventeditor-selectionview"></div>').appendTo('body');
            this.container = $('<div class="eventeditor-selectionview-container" style="padding-top:18px;"></div>').appendTo(this.dom);
            $(this.dom).delegate('.event-button', 'click', function() {
                var categoryItem = $(this).data('categoryItem');
                var userDefinedItem = $(this).data('userdefinedItem');
                var data = _this.generateData(categoryItem);
                if (_this.options.onSave) _this.options.onSave.call(_this, data);
                _this.close();
            });

            this.header = $('<div class="eventeditor-selectionview-header"></div>').appendTo(this.container);
            var searchBox = $('<input type="text">').appendTo(this.header);
            searchBox.searchbox({
                width: 250,
                prompt: '输入汉字检索',
                onClickButton: function(index) {
                    var text = $(this).validatebox('getValue');
                    _this.filter(text);
                }
            });

            var inputRect = searchBox.siblings('.searchbox');
            $(inputRect).find('input').keyup(function() {
                _this.FilterStr = $(this).val().toUpperCase();
                _this.filter(_this.FilterStr);
            });

            this.itemContainer = $('<div class="eventeditor-selectionview-items"></div>').appendTo(this.container);

            this.close();
            /*this.dom.mouseleave(function() {
                _this.close();
            });*/

            var closeButton = $('<a href="javascript:;" title="关闭" style="position:absolute;top:0px;right:0px;background-color:#eee;"><span class="icon icon-close"></span></a>')
                .click(function() {
                    _this.close();
                })
                .appendTo(this.container);

            this.initiated = true;
        },
        render: function(eventCategories) {
            //按分类分组显示
            var mainContainer = this.itemContainer;
            mainContainer.empty();
            mainContainer.hide();
            $.each(eventCategories, function(index, category) {
                var categoryContainer = $('<div class="eventeditor-selectionview-cat"></div>').appendTo(mainContainer);
                categoryContainer.data('category', category);
                $('<div class="eventeditor-selectionview-cat-header"></div>').text(category.Description).appendTo(categoryContainer);
                var itemsContainer = $('<div class="eventeditor-selectionview-cat-items"></div>').appendTo(categoryContainer);

                var items = category.items;
                var length = items.length;
                var item = null,
                    element = null;
                for (var j = 0; j < length; j++) {
                    item = items[j];
                    element = $('<a href="#" class="event-button"></a>').text(item.ItemDesc).appendTo(itemsContainer);
                    element.data('categoryItem', item);
                }
            });

            var categoryContainer = $('<div class="eventeditor-selectionview-cat"></div>').appendTo(mainContainer);
            $('<div class="eventeditor-selectionview-cat-header"></div>').text('自定义事件').appendTo(categoryContainer);
            this.userDefinedItemsContainer = $('<div class="eventeditor-selectionview-cat-items"></div>').appendTo(categoryContainer);
            this.renderUserDefinedItems([]);
            mainContainer.show();
        },
        renderUserDefinedItems: function(items) {
            var UserID = session.UserID;
            var _this = this;
            var itemsContainer = this.userDefinedItemsContainer;
            itemsContainer.hide();
            itemsContainer.empty();
            //var items = items.concat(this.categoryItems);
            //var sortedItems = getSortedItems(items);
            var sortedItems = items;

            var length = sortedItems.length;
            var item = null,
                element = null;
            for (var j = 0; j < length; j++) {
                item = sortedItems[j];
                element = $('<a href="#" class="event-button"></a>')
                    .text(item.Description || item.ItemDesc)
                    .appendTo(itemsContainer);
                if (UserID == item.CreateUser && item.AroundOneDay == '1') {
                    element.append('<span class="event-userdefined-i-icon event-userdefined-i-edit icon-edit" title="修改自定义事件"></span>');
                    //element.append('<span class="event-userdefined-i-icon event-userdefined-i-stop icon-stop" title="停用自定义事件"></span>');
                }
                if (item.DataItem) {
                    element.data('categoryItem', item);
                } else {
                    element.data('userdefinedItem', item);
                }
            }
            itemsContainer.show();
        },
        /**
         * 筛选
         */
        filter: function() {
            var filterStr = this.FilterStr;
            this.dom.find('.event-button').each(function(index, e) {
                var text = $(e).text();
                if (filterStr === '' || text.indexOf(filterStr) > -1) {
                    $(e).show();
                } else {
                    $(e).hide();
                }
            });
        },
        generateData: function(categoryItem) {
            return {
                Continuous: 'N',
                TimeSpanMinutes: 0,
                DataValue: '',
                Category: categoryItem.DataCategory,
                CategoryItem: categoryItem.RowId,
                UserDefinedItem: '',
                DataItem: categoryItem.DataItem,
                Description: categoryItem.ItemDesc,
                Type: 'E'
            }
        },
        /**
         * 关闭
         */
        close: function() {
            this.dom.hide();
            this.closed = true;
            this.FilterStr = '';
        },
        /**
         * 打开
         */
        open: function() {
            if (!this.initiated) this.init();
            this.dom.show();
            this.closed = false;
            if (this.options.onOpen) this.options.onOpen.call(this);
        },
        position: function(position) {
            this.dom.css({ left: position.left + 75, top: position.top - 15 });
        }
    }

    var intrmiDrugCreator = {
        init: function(opt) {
            this.options = opt;
        },
        open: function() {

        },
        close: function() {

        }
    }


}));