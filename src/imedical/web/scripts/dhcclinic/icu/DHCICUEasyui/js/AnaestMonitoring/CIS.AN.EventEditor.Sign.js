//
/**
 * 事件数据编辑
 * 初始化的时候才创建并储存一个实例
 * @author yongyang 20180507
 */

(function(global, factory) {
    if (!global.EventEditor) factory(global.EventEditor = {});
}(this, function(exports) {

    /**
     * 初始化实例
     * @param {object} opt 生成选项
     */
    exports.init = function(opt) {
        exports.instance = new EventEditor(opt);
        return exports.instance
    }

    exports.instance = null;

    function EventEditor(opt) {
        this.options = $.extend({ width: 420, height: 460 }, opt || {});
        this.saveHandler = opt.saveHandler;
        this.retrieveUserDefinedItem = opt.retrieveUserDefinedItem;
        this.eventSelectionView = eventSelectionView;
        this.userDefinedItemCreateView = userDefinedItemCreateView;
        var firstEventCategory = this.options.eventCategories[0]; //这里只考虑了术中事件中包含多个子分类的情况
        this.dataCategoryId = firstEventCategory.MainCategory;
        this.init();
    }

    EventEditor.prototype = {
        init: function() {
            var _this = this;
            this.dom = $('<div></div>').appendTo('body');
            var buttons = $('<div></div>');
            var btn_continue = $('<a href="#"></a>').linkbutton({
                text: '继续添加',
                iconCls: 'icon-add',
                onClick: function() {
                    _this.save();
                    _this.clear();
                    _this.StartDT.datetimebox('setValue', _this.currentStartDT);
                }
            }).appendTo(buttons);
            var btn_save = $('<a href="#"></a>').linkbutton({
                text: '保存并关闭',
                iconCls: 'icon-save',
                onClick: function() {
                    _this.save();
                    _this.close();
                }
            }).appendTo(buttons);
            var btn_cancel = $('<a href="#"></a>').linkbutton({
                text: '关闭',
                iconCls: 'icon-cancel',
                onClick: function() {
                    _this.close();
                }
            }).appendTo(buttons);

            this.initForm();
            this.initPreferedDataView();

            this.dom.dialog({
                left: 300,
                top: 150,
                height: this.options.height,
                width: this.options.width,
                title: '事件数据编辑',
                modal: true,
                closed: true,
                buttons: buttons,
                onOpen: function() {

                },
                onClose: function() {
                    if (!eventSelectionView.closed) eventSelectionView.close();
                    _this.clear();
                }
            });

            this.userDefinedItemCreateView.init(this.options.createUserDefItemHandler, function(newItem) {
                _this.render(null, newItem);
                if (_this.retrieveUserDefinedItem) {
                    _this.retrieveUserDefinedItem({
                        dataCategoryId: _this.dataCategoryId
                    });
                }
            });
            this.userDefinedItemCreateView.setDataCategory(this.dataCategoryId);
        },
        initForm: function() {
            var _this = this;
            this.form = $('<form class="eventeditor-form"></form>').form({}).appendTo(this.dom);
            $(this.form).delegate('input', 'focus', function() {
                if (!eventSelectionView.closed) eventSelectionView.close();
            });
            $(this.form).delegate('textarea', 'focus', function() {
                if (!eventSelectionView.closed) eventSelectionView.close();
            });

            this.eventSelectionView.init(function(categoryItem, userDefinedItem) {
                _this.render(categoryItem, userDefinedItem);
                _this.EventName.removeClass('eventeditor-f-r-event-selected');
            });
            this.eventSelectionView.render(this.options.eventCategories);

            var eventNameRow = $('<div class="eventeditor-f-r"><div class="label">事件名称：</div></div>').appendTo(this.form);
            this.EventName = $('<div class="eventeditor-f-r-event" title="单击修改事件" style="width:139px;"></div>').appendTo(eventNameRow);
            this.EventItem = $('<input type="hidden" name="EventItem">').appendTo(eventNameRow);
            this.EventNameButton = $('<span class="drugeditor-editview-drugitem" style="width:24px;margin-left:3px;height:28px;"><span class="icon icon-template" style="margin-top:5px;margin-left:2px;"></span></span>').appendTo(eventNameRow);

            this.EventName.click(function() {
                _this.showEventSelectionView();
            });

            this.EventNameButton.click(function() {
                _this.showEventSelectionView();
            });

            var timeRow = $('<div class="eventeditor-f-r"><div class="label">时间：</div></div>').appendTo(this.form);
            this.StartDT = $('<input type="text" style="width:180px;">').appendTo(timeRow);
            this.StartDT.datetimebox({
                width: 180
            });
            this.StartDT.datetimebox('setValue', new Date().format(constant.dateTimeFormat));
            this.StartDT.datetimebox('initiateWheelListener');
            this.StartDT.datetimebox('initiateKeyUpListener');

            var row = $('<div class="eventeditor-f-r"></div>').appendTo(this.form);
            var label = $('<div class="label">护士：</div>').appendTo(row);
            this.SignNurse = $('<input type="text" name="SignNurse">').appendTo(row);
            this.SignNurse.combobox({
                width: 180,
                label: label,
                textField: 'Description',
                valueField: 'RowId'
            });

            var detailsRow = $('<div class="eventeditor-f-r"></div>').appendTo(this.form);
            this.detailsContainer = $('<div class="eventeditor-f-details"></div>').appendTo(detailsRow);
            this.setComboDataSource();
        },
        /**
         * 设置选择项数据源
         */
        setComboDataSource: function() {
            if (this.options.comboDataSource) {
                this.SignNurse.combobox('loadData', this.options.comboDataSource.Nurses || []);
            }
        },
        initPreferedDataView: function() {
            var _this = this;
            this.preferedDataView = $('<div style="position:absolute;top:40px;right:20px;z-index:10000;background-color:#eee;border-radius:5px;width:50px;min-height:360px;padding:5px;"></div>').appendTo(this.dom);
            $(this.preferedDataView).delegate('.prefered-data-i', 'click', function() {
                var preferedData = $(this).data('data');
                _this.selectPreferedData(preferedData);
            });
        },
        loadPreferedData: function(preferedDataDic) {
            var _this = this;
            this.preferedDataDic = preferedDataDic;
        },
        clearPreferedDataView: function() {
            this.preferedDataView.empty();
        },
        /**
         * 筛选快捷数据，选择了事件之后执行筛选
         * @param {string} categoryItem 
         */
        filterPreferedData: function(categoryItem) {
            this.clearPreferedDataView();
            if (categoryItem && this.preferedDataDic) {
                var preferedDataList = this.preferedDataDic[categoryItem] || [];
                var length = preferedDataList.length;
                var element;
                for (var i = 0; i < length; i++) {
                    element = $('<span class="prefered-data-i"></span>').appendTo(this.preferedDataView);
                    element.text(preferedDataList[i].ShortDesc || preferedDataList[i].Description)
                        .attr('title', preferedDataList[i].DetailInfo);
                    element.data('data', preferedDataList[i]);
                }
            }
        },
        /**
         * 选中某条快捷数据之后
         * @param {object} preferedData 
         */
        selectPreferedData: function(preferedData) {
            if (preferedData &&
                preferedData.EventDetailDatas &&
                preferedData.EventDetailDatas.length > 0) {
                var length = preferedData.EventDetailDatas.length;
                var datValueDic = {};
                for (var i = 0; i < length; i++) {
                    datValueDic[preferedData.EventDetailDatas[i].EventDetailItem] = preferedData.EventDetailDatas[i].DataValue;
                }
                var length = this.EventDetails.length;
                var editors = this.EventDetails;
                var item, editor, value;
                for (var i = 0; i < length; i++) {
                    editor = editors[i];
                    item = editor.data('detailItem');
                    value = '';
                    if (datValueDic[item.RowId]) value = datValueDic[item.RowId];
                    if (editor[item.Editor]) editor[item.Editor].call(editor, 'setValue', value);
                }
            }
        },
        /**
         * 渲染
         */
        render: function(categoryItem, userDefinedItem) {
            var details = [];
            this.categoryItem = null;
            this.userDefinedItem = null;
            this.incompleteRender = true;
            this.EventDetails = [];

            if (categoryItem) {
                if (typeof categoryItem === 'string') {
                    categoryItem = this.getCategoryItemById(categoryItem);
                }
                this.categoryItem = categoryItem;
                details = categoryItem.eventDetailItems;
                this.EventName.text(categoryItem.ItemDesc);
                this.EventItem.val(categoryItem.RowId);
                this.renderDetails(details);
                this.incompleteRender = false;
                this.filterPreferedData(categoryItem.RowId);
            } else if (userDefinedItem) {
                if (typeof userDefinedItem === 'string') {
                    userDefinedItem = this.getUserDefinedItemById(userDefinedItem);
                }
                this.userDefinedItem = userDefinedItem;
                this.EventName.text(userDefinedItem.Description);
                this.EventItem.val(userDefinedItem.RowId);
                this.renderDetails([]);
                this.incompleteRender = false;
                this.filterPreferedData('');
            }
        },
        renderDetails: function(details) {
            var EventDetails = [];

            var detailsContainer = this.detailsContainer;
            detailsContainer.empty();
            $.each(details, function(index, item) {
                var width = Number(item.EditorSize.split(',')[0] || 180);
                var height = Number(item.EditorSize.split(',')[1] || 30);
                var editor = $('<input type="text">').width(item.EditorSize);
                editor.data('detailItem', item);

                var row = $('<div class="eventeditor-f-d-r"></div>')
                    .append($('<div class="label"></div>').text(item.Description + '：'))
                    .append(editor)
                    .append($('<span class="unit"></span>').text(item.Unit))
                    .appendTo(detailsContainer);

                if (editor[item.Editor]) {
                    editor[item.Editor]({
                        width: width,
                        height: height,
                        novalidate: true,
                        validator: function() {

                        }
                    });
                }

                if (item.Editor === 'tagbox') {
                    editor[item.Editor]({
                        "hasDownArrow": true,
                        "multiple": true,
                        "selectOnNavigation": false,
                        "editable": false
                    });
                }

                if (item.Editor === 'combobox' || item.Editor === 'tagbox') {
                    var detailOptions = [];
                    var optionStr = item.ValueRange;
                    var optionArr = optionStr.split(';');
                    var length = optionArr.length;
                    for (var i = 0; i < length; i++) {
                        detailOptions.push({
                            text: optionArr[i],
                            value: optionArr[i]
                        });
                    }
                    editor[item.Editor]('loadData', detailOptions);
                }

                EventDetails.push(editor);
            });

            this.EventDetails = EventDetails;
        },
        showEventSelectionView: function() {
            //if (this.originalData) return; // 当有数据加载的时候不能更改已选择的事件名
            this.eventSelectionView.position(this.EventName.offset());
            this.eventSelectionView.open();
            this.EventName.addClass('eventeditor-f-r-event-selected');
        },
        setParaItem: function(paraItem) {
            this.paraItem = paraItem;
        },
        loadData: function(data) {
            if (data.RowId) {
                this.originalData = data;
                this.StartDT.datetimebox('setValue', data.StartDT.format(constant.dateTimeFormat));
                this.EventName.text(data.DataItemDesc);
                this.EventItem.val(data.CategoryItem);
				this.SignNurse.combobox('setValue',data.SignNurse)
                this.categoryItem = this.getCategoryItemByDataItem(data.DataItem);
                if (this.userDefinedItemLoaded) {
                    this.userDefinedItem = this.getUserDefinedItemById(data.UserDefinedItem);
                }
                this.render(this.categoryItem, this.userDefinedItem);
                var eventDetailDatas = data.EventDetailDatas;

                $.each(this.EventDetails, function(index, editor) {
                    var detailItem = editor.data('detailItem');
                    var detailValue = getEventDetailValue(detailItem, eventDetailDatas);
                    editor[detailItem.Editor]('setValue', detailValue);
                });
            } else {
                this.StartDT.datetimebox('setValue', data.StartDT.format(constant.dateTimeFormat));
            }

            function getEventDetailValue(detailItem, eventDetailDatas) {
                var value = '';
                $.each(eventDetailDatas, function(index, detailData) {
                    if (detailData.EventDetailItem === detailItem.RowId) {
                        value = detailData.DataValue;
                        return false;
                    }
                });
                return value;
            }
        },
        loadUserDefinedItem: function(data) {
            this.userDefinedItemList = data;
            this.eventSelectionView.renderUserDefinedItems(data);
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
        getCategoryItemByDataItem: function(dataItem) {
            var foundItem = null;
            var eventCats = this.options.eventCategories;
            $.each(eventCats, function(index, category) {
                var items = category.items;
                var length = items.length;
                for (var i = 0; i < length; i++) {
                    if (items[i].DataItem === dataItem) {
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
        open: function() {
            this.dom.dialog('open');
            if (this.retrieveUserDefinedItem && !this.userDefinedItemList) {
                this.retrieveUserDefinedItem({
                    dataCategoryId: this.dataCategoryId
                });
            }
        },
        close: function() {
            this.dom.dialog('close');
        },
        save: function() {
            var savingDatas = [];
            var preparedDatas = [];
            var newData = this.toData();
            var originalData = this.originalData;
            if (originalData) {
                if (isAnaDataEqual(newData, originalData)) return;
                $.extend(originalData, { EditFlag: 'D' });
                $.extend(newData, {
                    FromData: originalData.RowId
                });
                savingDatas.push({ RowId: originalData.RowId, EditFlag: 'D' });
            }
            $.extend(newData, {
                ParaItem: this.paraItem.RowId,
                DataItem: this.categoryItem ? this.categoryItem.DataItem : '',
                UserDefinedItem: this.userDefinedItem ? this.userDefinedItem.RowId : '',
                CreateUserID: session.UserID
            });
            savingDatas.push(newData);
            prepareSavingDatas();
            this.saveHandler(preparedDatas);

            function prepareSavingDatas() {
                var anaDataClassName = ANCLS.Model.AnaData;
                var eventDataClassName = ANCLS.Model.EventData;
                var guid = dhccl.guid();
                if (originalData) {
                    preparedDatas.push({
                        RowId: originalData.RowId,
                        EditFlag: 'D',
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
                    CategoryItem: newData.CategoryItem,
                    DataItem: newData.DataItem,
                    DataItemDesc: newData.DataItemDesc || "",
                    ItemCategory: newData.ItemCategory,
                    Continuous: newData.Continuous || 'N',
                    FromData: "",
                    CategoryItem: newData.CategoryItem,
                    DataItem: newData.DataItem,
                    DataItemDesc: newData.DataItemDesc,
                    ItemCategory: newData.ItemCategory
                }, {
                    Guid: guid,
                    ClassName: anaDataClassName
                }));
                if (newData.EventDetailDatas && newData.EventDetailDatas.length > 0) {
                    $.each(newData.EventDetailDatas, function(index, eventDetailData) {
                        preparedDatas.push($.extend(eventDetailData, {
                            AnaDataGuid: guid,
                            ClassName: eventDataClassName
                        }))
                    });
                }
            }
        },
        clear: function() {
            this.currentStartDT = this.StartDT.datetimebox('getValue');
            this.form.form('clear');
            this.detailsContainer.empty();
            this.EventName.text('');
            this.originalData = null;
            this.clearPreferedDataView();
        },
        /**
         * 提取其中填写的数据
         */
        toData: function() {
            var detailDatas = [];
            var detailItem = null;
            var detailStrArr = [];
            $.each(this.EventDetails, function(index, detail) {
                detailItem = $(detail).data('detailItem');
                var value = $(detail)[detailItem.Editor]('getValue');
                if (value) {
                    detailStrArr.push(detailItem.Description + ':' + value);
                    detailDatas.push({
                        AnaData: '',
                        EventDetailItem: detailItem.RowId,
                        DataValue: value,
                        DataUnit: detailItem.Unit,
                        Description: detailItem.Description,
                        Unit: detailItem.Unit
                    });
                }
            });

            var startDT = this.StartDT.datetimebox("getValue");
            var arr = startDT.split(' ');
            var startDate = startTime = '';
            if (arr.length > 1) {
                startDate = arr[0];
                startTime = arr[1];
            }
            var endDT = startDT,
                endDate = startDate,
                endTime = startTime;

            var signNurse = this.SignNurse.combobox('getValue');

            return {
                RowId: "",
                ParaItem: "",
                StartDate: startDate,
                StartTime: startTime,
                EndDate: endDate,
                EndTime: endTime,
                DataValue: "",
                EditFlag: "N",
                FromData: "",
                CreateUserID: "",
                CreateDT: "",
                StartDT: startDT,
                EndDT: endDT,
                SignNurse: signNurse,
                ItemCategory: "E",
                EventDetailDatas: detailDatas,
                EventDetail: detailStrArr.join('\n'),
                edited: true
            }
        }
    }

    /**
     * 事件选择框
     */
    var eventSelectionView = {
        init: function(callback) {
            var _this = this;
            this.userDefinedItemCreateView = userDefinedItemCreateView;
            this.FilterStr = '';
            this.callback = callback;
            this.dom = $('<div class="eventeditor-selectionview"></div>').appendTo('body');
            this.container = $('<div class="eventeditor-selectionview-container" style="width:280px;"></div>').appendTo(this.dom);
            $(this.dom).delegate('.event-button', 'click', function() {
                var categoryItem = $(this).data('categoryItem');
                var userDefinedItem = $(this).data('userdefinedItem');
                _this.callback(categoryItem, userDefinedItem);
                _this.close();
            });

            $(this.dom).delegate('.event-userdefined-i-edit', 'click', function() {
                event.preventDefault();
                event.stopPropagation();
                var userDefinedItem = $($(this).parent()).data('userdefinedItem');
                _this.openCreateView(userDefinedItem);
                return false;
            })

            this.header = $('<div class="eventeditor-selectionview-header"></div>').appendTo(this.container);
            var searchBox = $('<input type="text">').appendTo(this.header);
            searchBox.searchbox({
                width: 270,
                prompt: '输入汉字和简拼检索',
                onClickButton: function(index) {
                    var text = $(this).validatebox('getValue');
                    _this.filter(text);
                }
            });

            var inputRect = searchBox.siblings('.searchbox');
            $(inputRect).find('input').keyup(function() {
                _this.FilterStr = $(this).val().toUpperCase();
                _this.filter();
            });

            this.itemContainer = $('<div class="eventeditor-selectionview-items"></div>').appendTo(this.container);

            this.close();

            // this.dom.mouseleave(function() {
            //     _this.close();
            // });

            this.initiated = true;
        },
        render: function(eventCategories) {
            /* //按分类分组显示
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
        
                */

            // 按使用次数倒序显示
            var items = [];
            $.each(eventCategories, function(index, category) {
                items = items.concat(category.items || []);
            });
            this.categoryItems = items;
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
            for (var j = 0; j < length; j++) {
                item = sortedItems[j];
                element = $('<a href="#" class="event-button"></a>')
                    .text(item.Description || item.ItemDesc)
                    .attr('data-alias', item.Alias)
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

            // var element = $('<a href="javascript:;" class="event-userdefined-item-add"><span class="fas fa-plus"></span></a>').appendTo(itemsContainer);
            // element.bind('click', function() {
            //     _this.openCreateView();
            // });

            itemsContainer.show();
        },
        /**
         * 筛选
         */
        filter: function() {
            var filterStr = this.FilterStr;
            this.dom.find('.event-button').each(function(index, e) {
                var text = $(e).text();
                var alias = $(e).attr('data-alias');
                if (filterStr === '' ||
                    text.indexOf(filterStr) > -1 ||
                    alias.indexOf(filterStr) > -1 ||
                    text === '自由文本') {
                    $(e).show();
                } else {
                    $(e).hide();
                }
            });
        },
        openCreateView: function(userDefinedItem) {
            if (userDefinedItem) {
                this.userDefinedItemCreateView.render(userDefinedItem);
            }
            this.userDefinedItemCreateView.open();
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
        },
        position: function(position) {
            this.dom.css({ left: position.left, top: position.top + 35 });
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
                ItemCategory: 'E',
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
                    data = $.extend({}, this.originalData, data);
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
        var fields = ['StartDate', 'EndDate', 'StartTime', 'EndTime', 'CategoryItem'];
        return isEqual(fields, newData, oldData) && isEventDataEqual(newData.EventDetailDatas, oldData.EventDetailDatas);
    }

    /**
     * 判断两个药品数据是否相等
     * @param {Array<Model.EventData>} newDataArray 
     * @param {Array<Model.EventData>} oldDataArray 
     */
    function isEventDataEqual(newDataArray, oldDataArray) {
        var fields = [
            'EventDetailItem', 'DataValue'
        ];
        if ((newDataArray || []).length != (oldDataArray || []).length) return false;
        var length = newDataArray.length;
        for (var i = 0; i < length; i++) {
            if (!isEqual(fields, newDataArray[i], oldDataArray[i]))
                return false;
        }
        return true;
    }

    return exports;
}));