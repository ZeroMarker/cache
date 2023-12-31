/**
 * 间断给药编辑框（即单个AnaData对应多个DrugData）
 * 宁医总院需求，添加医生和护士选择
 * @author yongyang 20180524
 */

(function(global, factory) {
    if (!global.IntrmiDrugEditor) factory(global.IntrmiDrugEditor = {});
}(this, function(exports) {

    exports.init = function(opt) {
        var view = new IntrmiDrugEditor(opt);
        exports.instance = view;
        return view;
    }

    exports.instance = null;

    function IntrmiDrugEditor(opt) {
        this.options = $.extend(opt || {}, { width: 500, height: 330 });
        this.saveHandler = this.options.saveHandler;
        this.dataview = dataview;
        this.retrieveUserDefinedItem = opt.retrieveUserDefinedItem;
        this.userDefinedItemCreateView = userDefinedItemCreateView;
        this.categoryItemSelectionView = categoryItemSelectionView;
        this.drugItemSelectionView = drugItemSelectionView;
        this.editview = editview;
        var firstEventCategory = this.options.dataCategories[0]; //这里只考虑了术中事件中包含多个子分类的情况
        this.dataCategoryId = firstEventCategory.MainCategory;
        this.init();
    }

    IntrmiDrugEditor.prototype = {
        init: function() {
            var _this = this;
            this.dom = $('<div></div>').appendTo('body');
            this.formContainer = $('<div class="intrmidrugeditor-form-panel"></div>').appendTo(this.dom);
            this.categoryItemContainer = $('<div class="intrmidrugeditor-items-panel" style="width:240px;float:right;"></div>').appendTo(this.dom);

            this.initForm();
            this.initItemSelection();

            var buttons = $('<div></div>');
            var btn_save = $('<a href="#"></a>').linkbutton({
                text: '保存',
                iconCls: 'icon-save',
                onClick: function() {
                    _this.save();
                    _this.close();
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
                top: 150,
                height: this.options.height,
                width: this.options.width,
                title: '间断用药数据编辑',
                modal: true,
                closed: true,
                buttons: buttons,
                onOpen: function() {

                },
                onClose: function() {
                    _this.clear();
                }
            });

            this.editview.init(function(drugData) {
                if (this.originalData === drugData) _this.editDrugData(drugData);
                else _this.addDrugData(drugData);
            });

            this.setComboDataSource();

            this.userDefinedItemCreateView.init(this.options.createUserDefItemHandler, function(newItem) {
                _this.openEditView(newItem);
                if (_this.retrieveUserDefinedItem) {
                    _this.retrieveUserDefinedItem({
                        dataCategoryId: _this.dataCategoryId
                    });
                }
            });
            this.userDefinedItemCreateView.setDataCategory(this.dataCategoryId);
        },
        /**
         * 初始化表单
         */
        initForm: function() {
            var _this = this;
            this.form = $('<form></form>').appendTo(this.formContainer);
            this.form.form({});

            this.AnaDataRowId = $('<input type="hidden" name="RowId">').appendTo(this.form);
            this.ParaItemRowId = $('<input type="hidden" name="ParaItem">').appendTo(this.form);
            this.CategoryItemRowId = $('<input type="hidden" name="CategoryItem">').appendTo(this.form);

            var timeRow = $('<div class="intrmidrugeditor-f-r"></div>').appendTo(this.form);
            var label = $('<div class="label">时间：</div>').appendTo(timeRow);
            this.StartDT = $('<input type="text" name="StartDT">').appendTo(timeRow);
            this.StartDT.datetimebox({
                required: true,
                width: 180,
                label: label
            });
            this.StartDT.datetimebox('initiateWheelListener');
            this.StartDT.datetimebox('initiateKeyUpListener');

            var row = $('<div class="intrmidrugeditor-f-r"></div>').appendTo(this.form);
            var label = $('<div class="label">医生：</div>').appendTo(row);
            this.SignDoctor = $('<input type="text" name="SignDoctor">').appendTo(row);
            this.SignDoctor.combobox({
                width: 180,
                label: label,
                textField: 'Description',
                valueField: 'RowId'
            });

            var row = $('<div class="intrmidrugeditor-f-r"></div>').appendTo(this.form);
            var label = $('<div class="label">护士：</div>').appendTo(row);
            this.SignNurse = $('<input type="text" name="SignNurse">').appendTo(row);
            this.SignNurse.combobox({
                width: 180,
                label: label,
                textField: 'Description',
                valueField: 'RowId'
            });

            var row = $('<div class="intrmidrugeditor-f-r"><span class="label">用药：</span></div>').appendTo(this.form);
            var container = $('<div class="intrmidrugeditor-f-r-container"></div>').appendTo(row);
            this.DrugDataContainer = $('<div class="intrmidrugeditor-data-container"></div>').appendTo(container);
            $('<a href="javascript:;" class="drugdata-i-add" title="增加用药">+</a>')
                .click(function() {
                    _this.openEditView();
                })
                .appendTo(container);

            this.DrugDataContainer.delegate('.drugdata-i-btn-edit', 'click', function() {
                $('.drugdata-i-selected').removeClass('drugdata-i-selected');
                var element = $($(this).parent());
                var data = element.data('data');
                element.addClass('drugdata-i-selected');
                _this.dataview.refreshAppearance(data.target, data);
                _this.editview.render(data);
                _this.openEditView();
            });

            this.DrugDataContainer.delegate('.drugdata-i-btn-remove', 'click', function() {
                if (event.stopPropagation) event.stopPropagation();
                else event.cancelBubble = true;
                var element = $($(this).parent());
                var data = element.data('data');
                if (data) {
                    $.messager.confirm('删除数据', '确认删除用药数据：\n' + element.text(), function(confirmed) {
                        if (confirmed) {
                            _this.deleteDrugData(data);
                        }
                    });
                }

                return false;
            })
        },
        /**
         * 初始化项目选择区
         */
        initItemSelection: function() {
            var _this = this;
            this.categoryItemSelectionView.init(this.categoryItemContainer, function(categoryItem) {
                _this.openEditView(categoryItem);
            });
            this.categoryItemSelectionView.render(this.options.dataCategories);

            this.drugItemSelectionView.init();
            this.drugItemSelectionView.render(this.options.dataCategories);
        },
        /**
         * 设置选择项数据源
         */
        setComboDataSource: function() {
            if (this.options.comboDataSource) {
                this.editview.setComboDataSource(this.options.comboDataSource);
                this.SignDoctor.combobox('loadData', this.options.comboDataSource.Doctors || []);
                this.SignNurse.combobox('loadData', this.options.comboDataSource.Nurses || []);
            }
        },
        /**
         * 设置界面项目
         */
        setParaItem: function(paraItem) {
            this.paraItem = paraItem;
        },
        /**
         * 加载数据
         * @param {Model.AnaData} data
         */
        loadData: function(data) {
            this.drugDataList = [];
            this.StartDT.datetimebox('setValue', data.StartDT.format(constant.dateTimeFormat));
            if (data.RowId) {
                this.originalData = data;
                this.drugDataList = data.DrugDataList;
                this.SignDoctor.combobox('setValue', data.SignDoctor);
                this.SignNurse.combobox('setValue', data.SignNurse);
                this.refreshDataView();
            }
        },
        loadUserDefinedItem: function(data) {
            this.userDefinedItemList = data;
            this.categoryItemSelectionView.renderUserDefinedItems(data);
            this.drugItemSelectionView.renderUserDefinedItems(data);
            this.userDefinedItemLoaded = true;

            if (this.incompleteRender) {
                var data = this.originalData;
                this.categoryItem = this.getCategoryItemById(data.CategoryItem);
                this.userDefinedItem = this.getUserDefinedItemById(data.UserDefinedItem);
                this.render(this.categoryItem, this.userDefinedItem);
            }
        },
        getCategoryItemById: function(rowId) {
            var foundItem = null;
            var eventCats = this.options.eventCategories;
            $.each(eventCats, function(index, category) {
                var items = category.items;
                var length = items.length;
                for (var i = 0; i < length; i++) {
                    if (items[i].RowId === rowId) {
                        foundItem = items[i];
                        break;
                    }
                }

                return foundItem == null;
            });

            return foundItem;
        },
        getUserDefinedItemById: function(rowId) {
            var foundItem = null;
            var items = this.userDefinedItemList || [];
            var length = items.length;
            for (var i = 0; i < length; i++) {
                if (items[i].RowId === rowId) {
                    foundItem = items[i];
                    break;
                }
            }
            return foundItem;
        },
        /**
         * 打开药品编辑界面
         */
        openEditView: function(categoryItem) {
            this.editview.open();
            if (categoryItem) this.editview.setCategoryItem(categoryItem);
        },
        /**
         * 打开
         */
        open: function() {
            this.dom.dialog('open');
            if (this.retrieveUserDefinedItem && !this.userDefinedItemList) {
                this.retrieveUserDefinedItem({
                    dataCategoryId: this.dataCategoryId
                });
            }
        },
        /**
         * 关闭
         */
        close: function() {
            this.dom.dialog('close');
        },
        /**
         * 清空
         */
        clear: function() {
            this.form.form('clear');
            this.DrugDataContainer.empty();
            if (this.categoryItemSelectionView.searchBox) {
                this.categoryItemSelectionView.searchBox.searchbox('setValue', '');
                this.categoryItemSelectionView.filter('');
            }
        },
        /**
         * 修改DrugData
         */
        editDrugData: function(drugData) {
            this.dataview.refreshAppearance(drugData.target, drugData);
        },
        /**
         * 修改DrugData
         */
        addDrugData: function(drugData) {
            this.drugDataList.push(drugData);
            this.refreshDataView();
        },
        /**
         * 删除DrugData
         */
        deleteDrugData: function(drugData) {
            var index = this.drugDataList.indexOf(drugData);
            this.drugDataList.splice(index, 1);
            drugData.target.remove();
        },
        /**
         * 刷新数据显示
         */
        refreshDataView: function() {
            this.dataview.render(this.DrugDataContainer, this.drugDataList);
        },
        /**
         * 保存
         */
        save: function() {
            var savingDatas = [];
            var preparedDatas = [];
            var newData = this.toData();
            var originalData = this.originalData;
            if (originalData) {
                //if (isAnaDataEqual(newData, originalData)) return;
                $.extend(originalData, { EditFlag: 'D' });
                $.extend(newData, {
                    FromData: originalData.RowId,
                    ParaItem: originalData.ParaItem,
                    CategoryItem: originalData.CategoryItem,
                    DataItem: originalData.DataItem,
                    DataItemDesc: originalData.DataItemDesc,
                    ItemCategory: originalData.ItemCategory,
                    CreateUserID: session['UserID']
                });
                savingDatas.push({ RowId: originalData.RowId, EditFlag: 'D' });
            } else {
                $.extend(newData, {
                    FromData: '',
                    ParaItem: this.paraItem.RowId,
                    CategoryItem: this.paraItem.CategoryItem,
                    DataItem: this.paraItem.DataItem,
                    DataItemDesc: this.paraItem.DataItemDesc,
                    ItemCategory: this.paraItem.ItemCategory,
                    CreateUserID: session['UserID']
                })
            }
            savingDatas.push(newData);
            prepareSavingDatas();
            this.saveHandler(preparedDatas);

            function prepareSavingDatas() {
                var anaDataClassName = ANCLS.Model.AnaData;
                var drugDataClassName = ANCLS.Model.DrugData;
                var guid = dhccl.guid();
                if (originalData) {
                    preparedDatas.push({
                        RowId: originalData.RowId,
                        EditFlag: 'D',
                        Guid: guid,
                        ClassName: anaDataClassName
                    });
                }
                preparedDatas.push($.extend({
                    RowId: newData.RowId || "",
                    ClassName: ANCLS.Model.AnaData,
                    ParaItem: newData.ParaItem,
                    StartDate: newData.StartDate,
                    StartTime: newData.StartTime,
                    EndDate: newData.EndDate,
                    EndTime: newData.EndTime,
                    DataValue: newData.DataValue,
                    EditFlag: newData.EditFlag,
                    FromData: "",
                    CreateUserID: "",
                    CreateDT: "",
                    StartDT: newData.StartDT,
                    EndDT: newData.EndDT,
                    SignNurse: newData.SignNurse,
                    SignDoctor: newData.SignDoctor,
                    CategoryItem: newData.CategoryItem,
                    DataItem: newData.DataItem,
                    DataItemDesc: newData.DataItemDesc || "",
                    ItemCategory: newData.ItemCategory,
                    Continuous: "N",
                    FromData: "",
                    CategoryItem: newData.CategoryItem,
                    DataItem: newData.DataItem,
                    DataItemDesc: newData.DataItemDesc,
                    ItemCategory: newData.ItemCategory
                }, {
                    Guid: guid,
                    ClassName: anaDataClassName
                }));
                $.each(newData.DrugDataList, function(i, drugData) {
                    preparedDatas.push($.extend({}, drugData, {
                        AnaDataGuid: guid,
                        ClassName: drugDataClassName,
                        target: ''
                    }))
                });
            }
        },
        /**
         * 生成数据
         */
        toData: function() {
            var startDT = this.StartDT.datetimebox("getValue");
            var arr = startDT.split(' ');
            var startDate = startTime = '';
            if (arr.length > 1) {
                startDate = arr[0];
                startTime = arr[1];
            }
            startDT = (new Date()).tryParse(startDT, constant.dateTimeFormat);
            var signNurse = this.SignNurse.combobox('getValue');
            var signDoctor = this.SignDoctor.combobox('getValue');

            return {
                RowId: '',
                StartDate: startDate,
                StartTime: startTime,
                EndDate: startDate,
                EndTime: startTime,
                DataValue: '',
                EditFlag: 'N',
                FromData: '',
                StartDT: startDT,
                EndDT: startDT,
                SignNurse: signNurse,
                SignDoctor: signDoctor,
                DrugDataList: this.drugDataList
            }
        }
    }

    var singleDataView = {
        /**
         * 渲染单条用药数据显示
         * @param {HTMLElement} container 单条用药数据的容器
         * @param {Module<Data.DrugData>} data 单条用药数据
         */
        render: function(container, data) {
            container.data('data', data);
            data.target = container;
            container.empty();
            $('<a href="javascript:;" class="drugdata-i-btn-remove icon-close" title="删除此条数据"></a>').appendTo(container);
            $('<a href="javascript:;" class="drugdata-i-btn-edit icon-edit" title="修改此条数据"></a>').appendTo(container);
            $('<span class="drugdata-i-name"></span>')
                .text(data.Description)
                .appendTo(container);
            if (Number(data.DoseQty) > 0)
                $('<span class="drugdata-i-dose"></span>')
                .text(data.DoseQty + data.DoseUnitDesc)
                .appendTo(container);
            if (Number(data.Concentration) > 0)
                $('<span class="drugdata-i-concentration"></span>')
                .text(data.Concentration + data.ConcentrationUnitDesc)
                .appendTo(container);
            $('<span class="drugdata-i-instruction"></span>')
                .text(data.InstructionDesc)
                .appendTo(container);

            var tipArr = [];
            tipArr.push(data.Description);
            if (Number(data.DoseQty) > 0)
                tipArr.push('剂量：' + data.DoseQty + data.DoseUnitDesc);
            if (Number(data.Concentration) > 0)
                tipArr.push('浓度：' + data.Concentration + data.ConcentrationUnitDesc);
            tipArr.push('用法：' + data.InstructionDesc);
            tipArr.push('备注：' + data.Note);
            //tipArr.push('接收科室：' + data.RecvLocDesc);
            container.attr('title', tipArr.join('\n'));
        }
    }

    var dataview = {
        /**
         * 单条数据渲染
         */
        singleDataView: singleDataView,
        /**
         * 渲染用药数据显示
         * @param {HTMLElement} container 容器
         * @param {Array<Data.DrugData>} data 用药数据数组
         */
        render: function(container, data) {
            this.container = container;
            this.container.empty();
            var singlerender = this.singleDataView.render;
            $.each(data, function(index, row) {
                singlerender($('<div class="drugdata-i"></div>').appendTo(container), row);
            })
        },
        /**
         * 清空数据显示
         */
        clear: function() {
            if (this.container) this.container.empty();
        },
        /**
         * 刷新数据显示
         * @param {jQuery<HTMLElement>} container
         * @param {Model.AnaData} drugData 
         */
        refreshAppearance: function(container, drugData) {
            this.singleDataView.render(container, drugData);
        }
    }

    /**
     * 药品项目选择
     */
    var categoryItemSelectionView = {
        closed: false,
        init: function(dom, callback) {
            var _this = this;
            this.callback = callback;
            this.userDefinedItemCreateView = userDefinedItemCreateView;
            this.dom = dom;

            this.header = $('<div class="intrmidrugeditor-items-panel-header"></div>').appendTo(this.dom);
            this.searchBox = $('<input type="text">').appendTo(this.header);
            this.searchBox.searchbox({
                width: 180,
                prompt: '输入简拼或汉字搜索',
                iconCls: 'icon-search',
                iconAlign: 'right',
                onClickButton: function() {
                    var text = $(this).validatebox('getValue');
                    _this.filter(text);
                }
            });

            var inputRect = this.searchBox.siblings('.searchbox');
            $(inputRect).find('input').keyup(function() {
                var text = $(this).val().toUpperCase();
                _this.filter(text);
            });

            this.header.delegate('input', 'keyup', function(e) {
                if (e.keyCode == 13) {
                    var text = $(this).val();
                    _this.filter(text);
                }
            });

            this.itemContainer = $('<div class="intrmidrugeditor-items"></div>').appendTo(this.dom);

            this.dom.delegate('.categoryitem-button', 'click', function() {
                var callback = _this.callback;
                if (callback) callback($(this).data('data'));
            });

            this.dom.delegate('.drug-userdefined-i-edit', 'click', function() {
                event.preventDefault();
                event.stopPropagation();
                var userDefinedItem = $($(this).parent()).data('userdefinedItem');
                _this.openCreateView(userDefinedItem);
                return false;
            });

            return this;
        },
        /**
         * 渲染
         */
        render: function(dataCategories) {
            var items = [];
            var length = dataCategories.length;
            var items = [];
            for (var i = 0; i < length; i++) {
                items = items.concat(dataCategories[i].items || []);
            }
            this.categoryItems = items;

            return this;
        },
        renderUserDefinedItems: function(items) {
            var UserID = session.UserID;
            var _this = this;
            var itemsContainer = this.itemContainer;
            itemsContainer.hide();
            itemsContainer.empty();
            var items = items.concat(this.categoryItems);
            var sortedItems = getSortedItems(items);

            var length = sortedItems.length;
            var item = null,
                element = null;
            var sortedItems = getSortedItems(items);

            for (var j = 0; j < length; j++) {
                item = sortedItems[j];
                element = $('<a href="#" class="categoryitem-button"></a>')
                    .text(item.Description || item.ItemDesc)
                    .attr('data-alias', item.Alias)
                    .appendTo(itemsContainer);
                item.target = element;
                if (UserID == item.CreateUser && item.AroundOneDay == '1') {
                    element.append('<span class="drug-userdefined-i-icon drug-userdefined-i-edit icon-edit" title="修改自定义药品"></span>');
                    //element.append('<span class="event-userdefined-i-icon event-userdefined-i-stop icon-stop" title="停用自定义药品"></span>');
                }

                element.data('data', item);
                if (item.DataItem) {
                    element.data('categoryItem', item);
                } else {
                    element.data('userdefinedItem', item);
                }
            }

            this.items = sortedItems;

            var element = $('<a href="javascript:;" class="drug-userdefined-item-add"><span class="fas fa-plus"></span></a>').appendTo(itemsContainer);
            element.bind('click', function() {
                _this.openCreateView();
            });

            itemsContainer.show();
        },
        openCreateView: function(userDefinedItem) {
            if (userDefinedItem) {
                this.userDefinedItemCreateView.render(userDefinedItem);
            }
            this.userDefinedItemCreateView.open();
        },
        filter: function(filterStr) {
            this.dom.find('.categoryitem-button').each(function(index, e) {
                var text = $(e).text();
                var alias = $(e).attr('data-alias');
                if (filterStr === '' ||
                    text.indexOf(filterStr) > -1 ||
                    alias.indexOf(filterStr) > -1) {
                    $(e).show();
                } else {
                    $(e).hide();
                }
            });
        }
    }

    /**
     * 编辑框
     */
    var editview = {
        init: function(callback) {
            this.callback = callback;
            var _this = this;
            this.dom = $('<div></div>').appendTo('body');
            this.initForm();

            var buttons = $('<div></div>');
            var btn_confirm = $('<a href="#"></a>').linkbutton({
                text: '确认',
                iconCls: 'icon-save',
                onClick: function() {
                    _this.confirm();
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
                left: 360,
                top: 120,
                height: 330,
                width: 340,
                title: '增加用药',
                modal: true,
                closed: true,
                buttons: buttons,
                onOpen: function() {

                },
                onClose: function() {
                    _this.clear();
                    $('.drugdata-i-selected').removeClass('drugdata-i-selected');
                }
            });

            this.arcimSelectionView = arcimSelectionView;
            this.arcimSelectionView.init(function(arcimItem) {
                _this.setArcimItem(arcimItem);
            });

            this.drugItemSelectionView = drugItemSelectionView;
            this.drugItemSelectionView.setCallback(function(drugItem) {
                _this.setItem(drugItem);
            });

            this.DrugItem.click(function() {
                _this.drugItemSelectionView.position($(this).offset()).open();
            });

            this.DrugItemButton.click(function() {
                _this.drugItemSelectionView.position($(_this.DrugItem).offset()).open();
            });

            this.ArcimItem.click(function() {
                _this.arcimSelectionView.position($(this).offset()).open();
            });

            this.ArcimItemButton.click(function() {
                _this.arcimSelectionView.position($(_this.ArcimItem).offset()).open();
            });

            this.form.delegate('input', 'focus', function() {
                _this.arcimSelectionView.close();
            });
        },
        initForm: function() {
            this.form = $('<form class="intrmidrugeditor-editview-form"></form>').appendTo(this.dom);
            this.form.form({});

            this.DrugDataRowId = $('<input type="hidden" name="DrugDataRowId">').appendTo(this.form);

            var itemRow = $('<div class="editview-f-r" style="height:33px;"><div class="label">药品项：</div></div>').appendTo(this.form);
            this.DataItemID = $('<input type="hidden" name="DataItemID">').appendTo(itemRow);
            this.UserDefinedItemID = $('<input type="hidden" name="UserDefinedItemID">').appendTo(itemRow);
            this.DrugItem = $('<span class="intrmidrugeditor-editview-drugitem" style="width:164px;"></span>').appendTo(itemRow);
            this.DrugItemButton = $('<span class="drugeditor-editview-drugitem" style="width:24px;margin-left:3px;"><span class="icon icon-template" style="margin-top:7px;margin-left:2px;"></span></span>').appendTo(itemRow);

            var itemRow = $('<div class="editview-f-r" style="height:33px;"><div class="label">医嘱项：</div></div>').appendTo(this.form);
            this.ArcimItem = $('<div class="intrmidrugeditor-editview-drugitem" title="单击选择医嘱项" style="width:164px;"></div>').appendTo(itemRow);
            this.ArcimID = $('<input type="hidden" name="ArcimID">').appendTo(itemRow);
            this.ArcimItemButton = $('<span class="drugeditor-editview-drugitem" style="width:24px;margin-left:3px;"><span class="icon icon-template" style="margin-top:7px;margin-left:2px;"></span></span>').appendTo(itemRow);

            var doseRow = $('<div class="editview-f-r"></div>').appendTo(this.form);
            var label = $('<div class="label">剂量：</div>').appendTo(doseRow);
            this.DoseQty = $('<input class="textbox" type="text" name="DoseQty" style="width:93px;margin-right:5px;">').appendTo(doseRow);
            this.DoseUnit = $('<input type="text" name="DoseUnit">').appendTo(doseRow);
            this.DoseQty.validatebox({
                width: 100,
                label: label,
                novalidate: true
            });
            this.DoseUnit.combobox({
                width: 95,
                valueField: "RowId",
                textField: "Description",
                cls: 'editview-f-r-unit'
            });

            var concentrationRow = $('<div class="editview-f-r"></div>').appendTo(this.form);
            var label = $('<div class="label">浓度：</div>').appendTo(concentrationRow);
            this.Concentration = $('<input class="textbox" type="text" name="Concentration" style="width:93px;margin-right:5px;">').appendTo(concentrationRow);
            this.ConcentrationUnit = $('<input type="text" name="ConcentrationUnit">').appendTo(concentrationRow);
            this.Concentration.validatebox({
                width: 100,
                label: label,
                novalidate: true
            });
            this.ConcentrationUnit.combobox({
                width: 95,
                valueField: "RowId",
                textField: "Description",
                cls: 'editview-f-r-unit'
            });

            var instructionRow = $('<div class="editview-f-r"></div>').appendTo(this.form);
            var label = $('<div class="label">用药途径：</div>').appendTo(instructionRow);
            this.Instruction = $('<input type="text" name="Instruction">').appendTo(instructionRow);
            this.Instruction.combobox({
                width: 200,
                valueField: "RowId",
                textField: "Description",
                label: label
            });

            var reasonRow = $('<div class="editview-f-r" style="display:none;"></div>').appendTo(this.form);
            var label = $('<div class="label">原因：</div>').appendTo(reasonRow);
            this.Reason = $('<input type="text" name="Reason">').appendTo(reasonRow);
            this.Reason.combobox({
                width: 200,
                valueField: "RowId",
                textField: "Description",
                label: label
            });

            var row = $('<div class="editview-f-r"></div>').appendTo(this.form);
            var label = $('<div class="label">备注：</div>').appendTo(row);
            this.Note = $('<input type="text" class="textbox" name="Note" style="width:194px;">').appendTo(row);
            this.Note.validatebox({
                width: 200,
                novalidate: true
            });

            var receiveLocRow = $('<div class="editview-f-r" style="display:none;"></div>').appendTo(this.form);
            var label = $('<div class="label">接收科室：</div>').appendTo(receiveLocRow);
            this.RecvLoc = $('<input type="text" name="RecvLoc">').appendTo(receiveLocRow);
            this.RecvLoc.combobox({
                width: 200,
                valueField: "Id",
                textField: "Desc",
                label: label
            });
        },
        render: function(drugData) {
            if (drugData) {
                this.dom.dialog('setTitle', '编辑用药');
                this.originalData = drugData;
                this.ArcimID.val(drugData.ArcimID);
                this.ArcimItem.attr('title', drugData.ArcimDesc).text(drugData.ArcimDesc);
                this.RecvLoc.combobox("setValue", drugData.RecvLoc);
                this.RecvLoc.combobox("setText", drugData.RecvLocDesc);
                this.DoseQty.validatebox("setValue", drugData.DoseQty);
                this.DoseUnit.combobox("setValue", drugData.DoseUnit);
                this.Concentration.validatebox("setValue", drugData.Concentration);
                this.ConcentrationUnit.combobox("setValue", drugData.ConcentrationUnit);
                this.Instruction.combobox("setValue", drugData.Instruction);
                this.Reason.combobox("setText", drugData.Reason);
                this.Note.validatebox("setValue", drugData.Note);
                this.DrugDataRowId.val(drugData.RowId);
                this.DrugItem.text(drugData.Description);
            } else {
                this.dom.dialog('setTitle', '增加用药');
            }
        },
        open: function() {
            this.dom.dialog('open');
        },
        close: function() {
            this.dom.dialog('close');
        },
        clear: function() {
            this.form.form('clear');
            this.ArcimItem.attr('title', '').text('');
            this.originalData = null;
        },
        setComboDataSource: function(dataList) {
            this.DoseUnit.combobox('loadData', dataList.DoseUnits || []);
            this.ConcentrationUnit.combobox('loadData', dataList.ConcentrationUnits || []);
            this.Instruction.combobox('loadData', dataList.Instructions || []);
            this.Reason.combobox('loadData', dataList.Reasons || []);
        },
        setDefaultValues: function(params) {
            if (!this.originalData) {
                if (params.DoseQty) this.DoseQty.validatebox("setValue", params.DoseQty);
                if (params.DoseUnit) this.DoseUnit.combobox("setValue", params.DoseUnit);
                if (params.Concentration) this.Concentration.validatebox("setValue", params.Concentration);
                if (params.ConcentrationUnit) this.ConcentrationUnit.combobox("setValue", params.ConcentrationUnit);
                if (params.Instruction) this.Instruction.combobox("setValue", params.Instruction);
            }
        },
        confirm: function() {
            var drugData = this.toData();
            if (this.originalData) $.extend(this.originalData, drugData);
            this.callback(this.originalData || drugData);
            this.close();
        },
        setCategoryItem: function(categoryItem) {
            this.setItem(categoryItem);
        },
        setItem: function(item) {
            this.DrugItem.text(item.Description || item.ItemDesc);
            if (item.DataItem) this.DataItemID.val(item.DataItem);
            else this.UserDefinedItemID.val(item.RowId);

            var drugItem;
            if (item) drugItem = item.drugItem;
            if (drugItem) {
                this.setDefaultValues({
                    DoseQty: drugItem.DoseQty,
                    DoseUnit: drugItem.DoseUnit,
                    Speed: drugItem.Speed,
                    SpeedUnit: drugItem.SpeedUnit,
                    Concentration: drugItem.Concentration,
                    ConcentrationUnit: drugItem.ConcentrationUnit,
                    Instruction: drugItem.Instruction
                });
            }

            if (item) {
                this.ArcimItem.attr('title', '').text('');
                this.ArcimID.val('');
                this.arcimSelectionView.render(item);
                if (item.arcimItems && item.arcimItems.length > 0) this.setArcimItem(item.arcimItems[0]);
            }
        },
        setArcimItem: function(arcimItem) {
            this.ArcimItem.attr('title', arcimItem.ArcimDesc || arcimItem.Description).text(arcimItem.ArcimDesc || arcimItem.Description);
            this.ArcimID.val(arcimItem.ArcimID);
            if (!this.originalData && arcimItem.DoseQty) {
                this.DoseQty.validatebox("setValue", arcimItem.DoseQty);
            }
            if (!this.originalData && arcimItem.ANDoseUom) {
                this.DoseUnit.combobox("setValue", arcimItem.ANDoseUom);
            }
            //this.loadReceiveLocation();
        },
        loadReceiveLocation: function() {
            var _this = this;
            var recvLocs = dhccl.getDatas(ANCSP.DataQuery, {
                ClassName: CLCLS.BLL.Admission,
                QueryName: "FindRecvLoc",
                Arg1: record.context.schedule.EpisodeID, //?
                Arg2: session.DeptID, //?
                Arg3: this.ArcimID.val(), //?
                ArgCnt: 3
            }, "json", true, function(data) {
                if (data && data.length > 0) {
                    _this.RecvLoc.combobox("loadData", data);
                    _this.RecvLoc.combobox("setValue", data[0].Id);
                }
            });
        },
        /**
         * 转换为数据
         */
        toData: function() {
            return {
                RowId: '',
                AnaData: '',
                DataItem: this.DataItemID.val(),
                UserDefinedItem: this.UserDefinedItemID.val(),
                DoseQty: this.DoseQty.validatebox("getValue"),
                DoseUnit: this.DoseUnit.combobox("getValue"),
                Instruction: this.Instruction.combobox("getValue"),
                Concentration: this.Concentration.validatebox("getValue"),
                ConcentrationUnit: this.ConcentrationUnit.combobox("getValue"),
                Speed: '',
                SpeedUnit: '',
                BalanceQty: "",
                Reason: this.Reason.combobox("getText"),
                BalanceDisposal: "",
                RecvLoc: this.RecvLoc.combobox('getValue'),
                ArcimID: this.ArcimID.val(),
                OrderItemID: "",
                DoseUnitDesc: this.DoseUnit.combobox("getText"),
                SpeedUnitDesc: '',
                DensityUnitDesc: this.ConcentrationUnit.combobox("getText"),
                ConcentrationUnitDesc: this.ConcentrationUnit.combobox("getText"),
                InstructionDesc: this.Instruction.combobox("getText"),
                ArcimDesc: this.ArcimItem.text(),
                RecvLocDesc: this.RecvLoc.combobox('getText'),
                Description: this.DrugItem.text(),
                Note: this.Note.validatebox('getValue')
            }
        }
    }

    /**
     * 药品项选择
     */
    var drugItemSelectionView = {
        closed: false,
        init: function() {
            var _this = this;
            this.userDefinedItemCreateView = userDefinedItemCreateView;
            this.dom = $('<div class="intrmidrugeditor-selectionview"></div>').appendTo('body');
            this.container = $('<div class="intrmidrugeditor-selectionview-container"></div>').appendTo(this.dom);
            this.close();

            this.dom.mouseleave(function() {
                _this.close();
            });

            this.header = $('<div class="intrmidrugeditor-selectionview-header"></div>').appendTo(this.container);
            this.searchBox = $('<input type="text">').appendTo(this.header);
            this.searchBox.searchbox({
                width: 200,
                prompt: '输入简拼或汉字搜索',
                iconCls: 'icon-search',
                iconAlign: 'right',
                onClickButton: function() {
                    var text = $(this).validatebox('getText');
                    _this.filter(text);
                }
            });

            var inputRect = this.searchBox.siblings('.searchbox');
            $(inputRect).find('input').keyup(function() {
                var text = $(this).val().toUpperCase();
                _this.filter(text);
            });

            this.header.delegate('input', 'keyup', function(e) {
                if (e.keyCode == 13) {
                    var text = $(this).val();
                    _this.filter(text);
                }
            });

            this.itemContainer = $('<div class="intrmidrugeditor-selectionview-items"></div>').appendTo(this.container);

            this.dom.delegate('.categoryitem-button', 'click', function() {
                var callback = _this.callback;
                if (callback) callback($(this).data('data'));
            });

            this.dom.delegate('.drug-userdefined-i-edit', 'click', function() {
                event.preventDefault();
                event.stopPropagation();
                var userDefinedItem = $($(this).parent()).data('userdefinedItem');
                _this.openCreateView(userDefinedItem);
                return false;
            });

            return this;
        },
        setCallback: function(callback) {
            this.callback = callback;
        },
        /**
         * 渲染
         */
        render: function(dataCategories) {
            var items = [];
            var length = dataCategories.length;
            var items = [];
            for (var i = 0; i < length; i++) {
                items = items.concat(dataCategories[i].items || []);
            }
            this.categoryItems = items;

            return this;
        },
        renderUserDefinedItems: function(items) {
            var UserID = session.UserID;
            var _this = this;
            var itemsContainer = this.itemContainer;
            itemsContainer.hide();
            itemsContainer.empty();
            var items = items.concat(this.categoryItems);
            var sortedItems = getSortedItems(items);

            var length = sortedItems.length;
            var item = null,
                element = null;
            var sortedItems = getSortedItems(items);

            for (var j = 0; j < length; j++) {
                item = sortedItems[j];
                element = $('<a href="#" class="categoryitem-button"></a>')
                    .text(item.Description || item.ItemDesc)
                    .attr('data-alias', item.Alias)
                    .appendTo(itemsContainer);
                item.target = element;
                if (UserID == item.CreateUser && item.AroundOneDay == '1') {
                    element.append('<span class="drug-userdefined-i-icon drug-userdefined-i-edit icon-edit" title="修改自定义药品"></span>');
                    //element.append('<span class="event-userdefined-i-icon event-userdefined-i-stop icon-stop" title="停用自定义药品"></span>');
                }

                element.data('data', item);
                if (item.DataItem) {
                    element.data('categoryItem', item);
                } else {
                    element.data('userdefinedItem', item);
                }
            }

            this.items = sortedItems;

            var element = $('<a href="javascript:;" class="drug-userdefined-item-add"><span class="fas fa-plus"></span></a>').appendTo(itemsContainer);
            element.bind('click', function() {
                _this.openCreateView();
            });

            itemsContainer.show();
        },
        openCreateView: function(userDefinedItem) {
            if (userDefinedItem) {
                this.userDefinedItemCreateView.render(userDefinedItem);
            }
            this.userDefinedItemCreateView.open();
        },
        filter: function(filterString) {
            var _this = this;
            var length = this.items.length;
            var filterString = filterString;
            for (var i = 0; i < length; i++) {
                var item = this.items[i];
                var desc = item.Description || item.ItemDesc;
                desc = desc.toUpperCase();
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
        openCreateView: function(userDefinedItem) {
            if (userDefinedItem) {
                this.userDefinedItemCreateView.render(userDefinedItem);
            }
            this.userDefinedItemCreateView.open();
        },
        /**
         * 打开药品选择框
         */
        open: function() {
            this.dom.show();
            this.closed = false;
            return this;
        },
        /**
         * 关闭药品选择框
         */
        close: function() {
            this.dom.hide();
            this.closed = true;
            if (this.searchBox) {
                this.searchBox.searchbox('setValue', '');
                this.filter('');
            }
            return this;
        },
        position: function(position) {
            this.dom.css({ left: position.left, top: position.top + 35 });
            return this;
        }
    }

    /**
     * 医嘱项选择
     */
    var arcimSelectionView = {
        closed: false,
        init: function(callback) {
            var _this = this;
            this.callback = callback;
            this.dom = $('<div class="intrmidrugeditor-selectionview"></div>').appendTo('body');
            this.container = $('<div class="intrmidrugeditor-selectionview-container"></div>').appendTo(this.dom);
            this.close();

            this.dom.mouseleave(function() {
                _this.close();
            });

            this.header = $('<div class="intrmidrugeditor-selectionview-header"></div>').appendTo(this.container);
            this.searchBox = $('<input type="text">').appendTo(this.header);
            this.searchBox.searchbox({
                width: 200,
                prompt: '输入简拼或汉字搜索',
                iconCls: 'icon-search',
                iconAlign: 'right',
                onClickButton: function() {
                    var text = $(this).validatebox('getText');
                    _this.filter(text);
                }
            });

            var inputRect = this.searchBox.siblings('.searchbox');
            $(inputRect).find('input').keyup(function() {
                var text = $(this).val().toUpperCase();
                _this.filter(text);
            });

            this.header.delegate('input', 'keyup', function(e) {
                if (e.keyCode == 13) {
                    var text = $(this).val();
                    _this.filter(text);
                }
            });

            this.itemContainer = $('<div class="intrmidrugeditor-selectionview-items"></div>').appendTo(this.container);

            this.dom.delegate('.drug-button', 'click', function() {
                var callback = _this.callback;
                if (callback) callback($(this).data('data'));
            });

            return this;
        },
        render: function(categoryItem) {
            this.items = [];
            if (!categoryItem.DataItem) return;
            this.items = categoryItem.arcimItems || [];
            this.renderItems(this.items);
            return this;
        },
        renderItems: function(items) {
            var container = this.itemContainer;
            container.empty();
            $.each(items, function(index, arcimItem) {
                var element = null;
                element = $('<a href="#" class="drug-button"></a>').text(arcimItem.ArcimDesc || arcimItem.Description).appendTo(container);
                element.data('data', arcimItem);
            });
        },
        filter: function(filterString) {
            var _this = this;
            // if (filterString === '') {
            //     this.renderItems(this.items);
            // } else {
            //     dhccl.getDatas(ANCSP.DataQuery, {
            //         ClassName: CLCLS.BLL.Admission,
            //         QueryName: "FindMasterItem",
            //         Arg1: filterString,
            //         ArgCnt: 1
            //     }, 'json', true, function(data) {
            //         _this.renderItems(data);
            //     });
            // }
        },
        /**
         * 打开药品选择框
         */
        open: function() {
            this.dom.show();
            this.closed = false;
            return this;
        },
        /**
         * 关闭药品选择框
         */
        close: function() {
            this.dom.hide();
            this.closed = true;
            if (this.searchBox) {
                this.searchBox.searchbox('setValue', '');
                this.filter('');
            }
            return this;
        },
        position: function(position) {
            this.dom.css({ left: position.left, top: position.top + 35 });
            return this;
        }
    }


    /**
     * 创建自定义项目
     */
    var userDefinedItemCreateView = {
        init: function(saveHandler, callback) {
            var _this = this;
            this.saveHandler = saveHandler;
            this.callback = callback;
            this.dom = $('<div></div>').appendTo('body');

            this.form = $('<form class="userdefineditemview-add-form"></form>').appendTo(this.dom);
            this.form.form({});

            var row = $('<div class="editview-f-r"><label class="label">名称：</label></div>').appendTo(this.form);
            this.Description = $('<input type="text" name="Description" style="width:174px;">').appendTo(row);
            this.Description.validatebox({
                required: true,
                novalidate: true
            });

            var row = $('<div class="editview-f-r"><label class="label">简拼：</label></div>').appendTo(this.form);
            this.Alias = $('<input type="text" name="Alias" style="width:174px;">').appendTo(row);
            this.Alias.validatebox({
                required: true,
                novalidate: true
            });

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
                top: 150,
                height: 180,
                width: 300,
                title: '创建自定义项目',
                modal: true,
                closed: true,
                buttons: buttons,
                onOpen: function() {

                },
                onClose: function() {
                    _this.clear();
                }
            });

        },
        render: function(data) {
            this.originalData = data;
            this.dom.dialog('setTitle', '修改自定义项目')
            this.Description.validatebox('setValue', data.Description);
            this.Alias.validatebox('setValue', data.Alias);
        },
        setDataCategory: function(dataCategory) {
            if (typeof dataCategory === 'string') {
                this.DataCategoryId = dataCategory;
            } else {
                this.DataCategoryId = dataCategory.RowId;
            }
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
        clear: function() {
            this.dom.form('clear');
            this.originalData = null;
        },
        toData: function() {
            return {
                ItemCategory: 'D',
                DataCategory: this.DataCategoryId,
                Description: this.Description.validatebox('getValue'),
                Code: this.Alias.validatebox('getValue'),
                Alias: this.Alias.validatebox('getValue'),
                DataType: 'T',
                CreateUser: ''
            }
        },
        save: function() {
            var _this = this;
            if (this.form.form('validate')) {
                var data = this.toData();
                if (this.originalData)
                    data = $.extend({}, data, { RowId: this.originalData.RowId });
                if (this.saveHandler) {
                    this.saveHandler(data, function(result) {
                        if (result.indexOf('S') > -1) {
                            _this.close();
                            data.RowId = result.split('^')[1];
                            if (_this.callback) _this.callback(data);
                        } else {
                            $.messager.alert('保存自定义事件失败', result);
                        }
                    });
                }
            }
        }
    }

    /**
     * 将项目按使用次数排序
     */
    function getSortedItems(items) {
        var sortedList = [];
        sortedList = items.sort(compareCounter);

        return sortedList;
    }

    function compareCounter(item1, item2) {
        var counter1 = item1.Counter;
        var counter2 = item2.Counter;
        counter1 = counter1 || '0';
        counter2 = counter2 || '0';

        if (Number(counter1) > Number(counter2)) return -1;
        else return 1;
    }


    /**
     * 判断两个数据是否相等
     * @param {Array} fields 
     * @param {object} newData 
     * @param {object} oldData 
     */
    function isEqual(fields, newData, oldData) {
        var result = true;
        $.each(fields, function(index, field) {
            if (newData[field] != oldData[field]) {
                result = false;
                return false;
            }
        });

        return result;
    }

    /**
     * 判断两个麻醉数据是否相等
     * @param {Model.AnaData} newData 
     * @param {Model.AnaData} oldData 
     */
    function isAnaDataEqual(newData, oldData) {
        var fields = ['StartDate', 'EndDate', 'StartTime', 'EndTime', ];
        return isEqual(fields, newData, oldData) && isDrugDataListEqual(newData.DrugDataList, oldData.DrugDataList);
    }

    /**
     * 判断两个药品数据是否相等，包括顺序（顺序不一致也视为不同）
     * @param {Array<Model.DrugData>} newDataArray 
     * @param {Array<Model.DrugData>} oldDataArray 
     */
    function isDrugDataListEqual(newDataArray, oldDataArray) {
        if ((newDataArray || []).length != (oldDataArray || []).length) return false;
        var length = newDataArray.length;
        for (var i = 0; i < length; i++) {
            if (!isDrugDataEqual(newDataArray[i], oldDataArray[i]))
                return false;
        }

        return true;
    }

    /**
     * 判断两个药品数据是否相等
     * @param {Model.DrugData} newData 
     * @param {Model.DrugData} oldData 
     */
    function isDrugDataEqual(newData, oldData) {
        var fields = [
            'DoseQty', 'DoseUnit', 'Speed', 'SpeedUnit',
            'Concentration', 'ConcentrationUnit', 'RecvLoc',
            'ArcimID', 'Instruction', 'Reason'
        ];
        return isEqual(fields, newData, oldData);
    }

    return exports;
}));