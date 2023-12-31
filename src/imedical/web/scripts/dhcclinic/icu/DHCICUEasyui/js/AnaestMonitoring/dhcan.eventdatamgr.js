/**
 * 事件总览界面
 * @author yongyang 2018-04-16
 */
(function(global, factory) {
    if (!global.eventDataManager) factory(global.eventDataManager = {});
}(this, function(exports) {
    /**
     * 初始化事件总览实例
     * @param {object} opt 传入事件分类项目和界面显示的事件分类
     */
    function init(opt) {
        var view = new EventDataManager(opt);
        exports.instance = view;
        return view;
    }

    exports.init = init;

    /**
     * 事件总览对象
     */
    function EventDataManager(opt) {
        this.dom = null;
        this.options = $.extend({
            height: 380,
            width: 600
        }, opt);
        this.saveHandler = opt.saveHandler;
        this.editview = editview;
        this.addview = addview;
        this.dataview = dataview;
        this.init();
    }

    EventDataManager.prototype = {
        constructor: EventDataManager,
        /**
         * 初始化
         */
        init: function() {
            this._initDialog();
            this._initAddView();
        },
        /**
         * 初始化事件数据显示模态框
         */
        _initDialog: function() {
            var _this = this; //IE8 以上才支持闭包
            var buttons = $('<div></div>');
            var addButton = $('<a href="#" style="float:left;"></a>').linkbutton({
                text: '新增',
                iconCls: 'icon-add',
                onClick: function() {
                    _this.openAddView();
                }
            }).appendTo(buttons);
            var saveButton = $('<a href="#"></a>').linkbutton({
                text: '保存',
                iconCls: 'icon-save',
                onClick: function() {
                    _this.save();
                    _this.close();
                }
            }).appendTo(buttons);
            var closeButton = $('<a href="#"></a>').linkbutton({
                text: '关闭',
                iconCls: 'icon-cancel',
                onClick: function() {
                    _this.close();
                }
            }).appendTo(buttons);

            this.dom = $('<div></div>').appendTo('body');

            this._initDataView();
            this._initEditView();

            this.dom.dialog({
                left: 300,
                top: 150,
                height: this.options.height,
                width: this.options.width,
                title: '事件总览',
                modal: true,
                closed: true,
                buttons: buttons,
                onOpen: function() {

                },
                onBeforeClose: function() {
                    return _this.verifySavingStatus();
                },
                onClose: function() {
                    _this.clear();
                }
            });
        },
        _initDataView: function() {
            var _this = this;
            this.dataviewContainer = $('<div class="edm-dataview"></div>').appendTo(this.dom);
            this.dataviewContainer.height(this.options.height - 100).width(this.options.width - 20);
            $(this.dataviewContainer).delegate('.eventdata-i', 'click', function() {
                _this.editview.submit();
                $('.eventdata-i-selected').removeClass('eventdata-i-selected');
                $(this).addClass('eventdata-i-selected');
                var data = $(this).data('data');
                _this.editview.render(data, $(this));
                _this.openEditView();
            });
            $(this.dataviewContainer).delegate('.eventdata-i-btn-remove', 'click', function() {
                if (event.stopPropagation) event.stopPropagation();
                else event.cancelBubble = true;
                var element = $($(this).parent());
                var data = element.data('data');
                if (data) {
                    $.messager.confirm('删除数据', '确认删除事件数据：\n' + element.text(), function(confirmed) {
                        if (confirmed) {
                            _this.deleteData(data);
                        }
                    });
                }

                return false;
            });
        },
        /**
         * 初始化事件数据编辑框
         */
        _initEditView: function() {
            var _this = this;
            this.editviewContainer = $('<div class="edm-editview" style="display:none;"></div>').appendTo(this.dom);
            this.editviewContainer.height(this.options.height - 80).width(300);
            this.editview.init(this.editviewContainer, {
                categoryItems: this.options.categoryItems,
                callback: function(eventData) {
                    if (this.originalData === eventData) _this.dataview.refreshAppearance(eventData.target, eventData);
                    else {
                        _this.editData(this.originalData, eventData);
                    }
                }
            });
        },
        /**
         * 初始化新增事件数据弹出框
         */
        _initAddView: function() {
            var _this = this;
            this.addview.init({
                eventCategories: this.options.eventCategories,
                callback: function(data) {
                    if (data) {
                        _this.addData(data);
                        _this.refreshDataView();
                    }
                }
            });
        },
        open: function() {
            this.dom.dialog('open');
            this.saved = false;
        },
        close: function() {
            this.dom.dialog('close');
        },
        clear: function() {
            this.closeEditView();
        },
        /**
         * 显示编辑框
         */
        openEditView: function() {
            this.editviewContainer.show();
            this.dataviewContainer.width(this.options.width - 320);
            this.dataviewContainer.addClass('edm-dataview-narrow');
        },
        /**
         * 隐藏编辑框
         */
        closeEditView: function() {
            this.editview.clear();
            this.editviewContainer.hide();
            this.dataviewContainer.width(this.options.width - 2);
            this.dataviewContainer.removeClass('edm-dataview-narrow');
        },
        /**
         * 显示新增数据框
         */
        openAddView: function() {
            this.addview.open();
        },
        /**
         * 隐藏新增数据框
         */
        closeAddView: function() {
            this.taddview.close();
        },
        /**
         * 设置界面项目
         */
        setParaItem: function(paraItem) {
            this.paraItem = paraItem;
        },
        /**
         * 加载数据
         */
        loadData: function(eventDataArray) {
            this.data = eventDataArray;
            this.refreshDataView();
        },
        /**
         * 添加一条新数据
         */
        addData: function(eventData) {
            $.extend(eventData, {
                ParaItem: this.paraItem.RowId,
                edited: true
            });
            this.data.push(eventData);
        },
        /**
         * 编辑数据
         */
        editData: function(oldData, newData) {
            var originalData = oldData.originalData;
            if (originalData && isAnaDataEqual(newData, originalData)) {
                $.extend(originalData, {
                    EditFlag: 'N',
                    edited: false,
                    editing: false
                });
                var index = this.data.indexOf(oldData);
                this.data.splice(index, 1);
                this.dataview.refreshAppearance(oldData.target, originalData);
            } else {
                oldData.edited = true;
                $.extend(oldData, {
                    EditFlag: 'D',
                    visible: false
                });
                if (!oldData.RowId) {
                    var index = this.data.indexOf(oldData);
                    this.data.splice(index, 1);
                }

                $.extend(newData, {
                    ParaItem: this.paraItem.RowId,
                    originalData: originalData || oldData,
                    edited: true
                });
                this.data.push(newData);
                this.dataview.refreshAppearance(oldData.target, newData);
            }
        },
        /**
         * 删除数据
         */
        deleteData: function(data) {
            if (this.editview.originalData === data) {
                this.editview.clear();
            }
            if (data.RowId) {
                $.extend(data, {
                    EditFlag: 'D',
                    visible: false,
                    edited: true,
                });
                data.target.remove();
            } else {
                var index = this.data.indexOf(data);
                this.data.splice(index, 1);
                data.target.remove();
            }
        },
        /**
         * 刷新数据显示
         */
        refreshDataView: function() {
            this.dataview.clear();
            this.dataview.render(this.dataviewContainer, this.data);
        },
        /**
         * 核实数据保存状态
         */
        verifySavingStatus: function() {
            var _this = this;
            if (this.hasUnsavedData() && !this.saved) {
                $.extend($.messager.defaults, {
                    ok: '是',
                    cancel: '否'
                });
                $.messager.confirm('数据未保存', '有已修改的数据但还未保存，是否保存？', function(confirmed) {
                    if (confirmed) _this.save();
                    else _this.saveHandler();
                    _this.saved = true;
                    _this.close();
                });
                $.extend($.messager.defaults, {
                    ok: '确认',
                    cancel: '取消'
                });
                return false;
            }
            return true;
        },
        /**
         * 保存
         */
        save: function() {
            this.editview.submit();
            var preparedDatas = [];
            var savingDatas = this.getEditedDatas();
            prepareSavingDatas();
            this.saveHandler(preparedDatas);
            this.saved = true;

            function prepareSavingDatas() {
                var createUserID = session.UserID;
                var anaDataClassName = ANCLS.Model.AnaData;
                var eventDataClassName = ANCLS.Model.EventData;
                $.each(savingDatas, function(index, data) {
                    var guid = dhccl.guid();
                    preparedDatas.push($.extend(data, {
                        Guid: guid,
                        ClassName: anaDataClassName,
                        CreateUserID: createUserID,
                        target: ''
                    }));
                    if (data.EventDetailDatas && data.EventDetailDatas.length > 0) {
                        $.each(data.EventDetailDatas, function(index, eventDetailData) {
                            preparedDatas.push($.extend(eventDetailData, {
                                AnaDataGuid: guid,
                                ClassName: eventDataClassName
                            }))
                        });
                    }
                });
            }
        },
        /**
         * 是否有未保存的数据
         */
        hasUnsavedData: function() {
            var hasUnsavedData = false;
            $.each(this.data, function(index, row) {
                if (row.edited) {
                    hasUnsavedData = true;
                    return false;
                }
            });

            return hasUnsavedData;
        },
        /**
         * 获取已修改的数据
         */
        getEditedDatas: function() {
            var result = [];
            $.each(this.data, function(index, row) {
                if (row.edited) result.push(row);
            });
            return result;
        }
    }

    /**
     * 单个数据显示的加载，这里用对象的方式可能由于访问链较长而影响运行速度，可优化
     */
    var singledataview = {
        render: function(container, data) {
            container.data('data', data);
            data.target = container;
            container.empty();
            if (data.edited) container.addClass('eventdata-i-edited');
            else container.removeClass('eventdata-i-edited');
            if (data.editing) container.addClass('eventdata-i-editing');
            else container.removeClass('eventdata-i-editing');

            $('<a href="javascript:;" class="eventdata-i-btn-remove icon-close" title="删除此条数据"></a>').appendTo(container);
            $('<span class="eventdata-i-time"></span>')
                .text(data.StartTime)
                .attr('title', data.StartDT.format(constant.dateTimeFormat))
                .appendTo(container);
            $('<span class="eventdata-i-name"></span>')
                .text(data.DataItemDesc)
                .appendTo(container);
            $('<span class="eventdata-i-detail"></span>')
                .text(data.EventDetail)
                .attr('title', data.EventDetail)
                .appendTo(container);

            var tipArr = [];
            tipArr.push(data.StartDT.format(constant.dateTimeFormat));
            tipArr.push(data.DataItemDesc);
            tipArr.push(data.EventDetail);
            container.attr('title', tipArr.join('\n'));

            return container;
        }
    }

    /**
     * 整个数据显示区域的加载
     */
    var dataview = {
        /**
         * 单条数据渲染
         */
        singledataview: singledataview,
        /**
         * 渲染
         */
        render: function(container, data) {
            var singledataview = this.singledataview;
            this.container = container;
            data.sort(dhccl.compareInstance("StartDT"));

            $.each(data, function(index, row) {
                if (typeof row.visible != 'boolean' || row.visible) {
                    var rowHtml = $('<div class="eventdata-i"></div>');
                    container.append(singledataview.render(rowHtml, row));
                }
            });

            return container;
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
         * @param {Model.AnaData} eventData 
         */
        refreshAppearance: function(container, eventData) {
            this.singledataview.render(container, eventData);
        }
    }

    /**
     * 事件数据编辑
     */
    var editview = {
        /**
         * 初始化
         */
        init: function(container, opt) {
            this.categoryItems = opt.categoryItems;
            this.callback = opt.callback;
            var _this = this;
            this.form = $('<form class="edm-editview-form"></form>').form({}).appendTo(container);
            var eventNameRow = $('<div class="editview-f-r"><div class="label">事件名称：</div></div>').appendTo(this.form);
            this.EventName = $('<span class="editview-eventname editview-eventname-disabled"></span>').appendTo(eventNameRow);
            var timeRow = $('<div class="editview-f-r"><div class="label">时间：</div></div').appendTo(this.form);
            this.StartDT = $('<input type="text" style="width:180px;">').appendTo(timeRow);
            this.StartDT.datetimebox({
                width: 180,
                onChange: function() {

                }
            });
            var detailsRow = $('<div class="editview-f-r"></div>').appendTo(this.form);
            this.detailsContainer = $('<div class="edm-editview-f-details"></div>').appendTo(detailsRow);
            return this.form;
        },
        /**
         * 渲染
         */
        render: function(eventData, targetContainer) {
            this.rendered = true;
            this.originalData = eventData;
            this.targetContainer = targetContainer;
            this.EventName.text(eventData.DataItemDesc);
            this.StartDT.datetimebox('setValue', eventData.StartDT.format(constant.dateTimeFormat));
            this.onChange();
            var EventDetails = [];

            //根据事件项目加载明细项
            var details = this.getEventDetailItems(eventData);
            var detailsContainer = this.detailsContainer;
            detailsContainer.empty();

            $.each(details, function(index, e) {
                var editor = $('<input type="text">').width(e.item.EditorSize);
                if (e.data) editor.val(e.data.DataValue);
                editor.data('data', e.data);
                editor.data('detailItem', e.item);

                var row = $('<div class="edm-editview-f-d-r"></div>')
                    .append($('<div class="label"></div>').text(e.item.Description + '：'))
                    .append(editor)
                    .append($('<span class="unit"></span>').text(e.item.Unit))
                    .appendTo(detailsContainer);

                if (editor[e.item.Editor]) {
                    editor[e.item.Editor]({
                        value: e.data ? e.data.DataValue : '',
                        validator: function() {

                        },
                        onChange: function(newValue, oldValue) {

                        }
                    })
                }
                EventDetails.push(editor);
            });

            this.EventDetails = EventDetails;
        },
        /**
         * 值改变时调用
         */
        onChange: function() {
            if (this.originalData) {
                this.originalData.editing = true;
                this.callback.call(this, this.originalData);
            }

        },
        /**
         * 清空
         */
        clear: function() {
            if (this.originalData) {
                this.originalData.editing = false;
                this.form.form('clear');
                this.EventName.text('');
            }

        },
        /**
         * 提交
         */
        submit: function() {
            if (!this.rendered) return;
            var newData = this.toData();
            if (isAnaDataEqual(newData, this.originalData)) {
                this.originalData.editing = false;
                this.callback.call(this, this.originalData);
            } else {
                this.callback.call(this, newData);
            }
        },
        /**
         * 转换为数据形式
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
                        RecordData: '',
                        EventDetailItem: detailItem.RowId,
                        DataValue: value,
                        DataUnit: detailItem.Unit,
                        Description: detailItem.Description,
                        Unit: detailItem.Unit
                    });
                }
            });

            var startDT = this.StartDT.datetimebox('getValue');
            var startDate = startDT.split(' ')[0];
            var startTime = startDT.split(' ')[1];
            startDT = (new Date()).tryParse(startDT, constant.dateTimeFormat);

            return {
                RowId: "",
                SheetRecord: "",
                ParaItem: "",
                StartDate: startDate,
                StartTime: startTime,
                EndDate: startDate,
                EndTime: startTime,
                DataValue: "",
                EditFlag: "N",
                FromData: "",
                CreateUserID: "",
                CreateDT: "",
                StartDT: startDT,
                EndDT: startDT,
                CategoryItem: this.originalData.CategoryItem,
                DataItem: this.originalData.DataItem,
                UserDefinedItem: this.originalData.UserDefinedItem,
                DataItemDesc: this.originalData.DataItemDesc,
                ItemCategory: "E",
                EventDetailDatas: detailDatas,
                EventDetail: detailStrArr.join('\n'),
                edited: true
            }
        },
        /**
         * 获取数据对应事件明细项
         * @param {string||object} dataOrItemId 
         */
        getEventDetailItems: function(dataOrItemId) {
            var detailItems = [];

            if (typeof dataOrItemId === 'object') {
                var eventData = dataOrItemId;
                var eventDetailDatas = eventData.EventDetailDatas;
                var length = eventDetailDatas || [].length;

                var categoryItem = this.getCategoryItem(eventData.CategoryItem);
                if (categoryItem) $.each(categoryItem.eventDetailItems, function(index, detailItem) {
                    var detailData = null;
                    for (var i = 0; i < length; i++) {
                        if (eventDetailDatas[i].EventDetailItem === detailItem.RowId) {
                            detailData = eventDetailDatas[i];
                            break;
                        }
                    }
                    detailItems.push({
                        data: detailData,
                        item: detailItem
                    })
                });
            } else {
                var dataItemId = dataOrItemId;
                var categoryItem = this.getCategoryItem('', dataItemId);
                if (categoryItem) { detailItems = categoryItem.eventDetailItems }
            }

            return detailItems;
        },
        /**
         * 根据分类或数据项目获取分类
         * @param {string} categoryId 分类Id
         * @param {string} dataItemId 数据项目Id，可选
         */
        getCategoryItem: function(categoryId, dataItemId) {
            var foundItem = null;
            $.each(this.categoryItems, function(index, item) {
                if ((item.RowId === categoryId) || (item.DataItem === dataItemId)) {
                    foundItem = item;
                    return false;
                }
            });

            return foundItem;
        }
    };

    /**
     * 新增事件数据弹出框
     */
    var addview = {
        /**
         * 初始化，只需执行一次
         * @param {object} opt
         */
        init: function(opt) {
            this.eventCategories = opt.eventCategories;
            this.eventSelectionView = eventSelectionView;
            this.callback = opt.callback;
            var _this = this;
            var buttons = $('<div></div>');
            var addButton = $('<a href="#"></a>').linkbutton({
                text: '新增',
                iconCls: 'icon-add',
                onClick: function() {
                    _this.callback(_this.toData());
                    _this.close();
                }
            }).appendTo(buttons);
            var cancelButton = $('<a href="#"></a>').linkbutton({
                text: '取消',
                iconCls: 'icon-cancel',
                onClick: function() {
                    _this.callback(false);
                    _this.close();
                }
            }).appendTo(buttons);

            this.dom = $('<div></div>').appendTo('body');
            this.form = $('<form class="edm-addview-form"></form>').appendTo(this.dom);
            this.form.form({});

            this.dom.dialog({
                left: 400,
                top: 120,
                height: 420,
                width: 360,
                title: '新增事件数据',
                modal: true,
                closed: true,
                buttons: buttons,
                onOpen: function() {},
                onClose: function() {
                    _this.clear();
                }
            });

            $(this.form).delegate('input', 'focus', function() {
                if (!_this.eventSelectionView.closed) _this.eventSelectionView.close();
            });

            var eventNameRow = $('<div class="eventeditor-f-r"><div class="label">事件名称：</div></div>').appendTo(this.form);
            this.EventName = $('<div class="eventeditor-f-r-event" title="单击修改事件"></div>').appendTo(eventNameRow);
            this.EventItem = $('<input type="hidden" name="EventItem">').appendTo(eventNameRow);
            this.EventName.click(function() {
                _this.eventSelectionView.position($(this).offset());
                _this.eventSelectionView.open();
                $(this).addClass('eventeditor-f-r-event-selected');
            });

            var timeRow = $('<div class="eventeditor-f-r"><div class="label">时间：</div></div').appendTo(this.form);
            this.StartDT = $('<input type="text" style="width:160px;">').appendTo(timeRow);
            this.StartDT.datetimebox({
                width: 180
            });
            this.StartDT.datetimebox('setValue', new Date().format(constant.dateTimeFormat));
            var detailsRow = $('<div class="eventeditor-f-r"></div>').appendTo(this.form);
            this.detailsContainer = $('<div class="eventeditor-f-r-details"></div>').appendTo(detailsRow);

            this.eventSelectionView.init(function(categoryItem) {
                _this.render(categoryItem);
                _this.EventName.removeClass('eventeditor-f-r-event-selected');
            });
            this.eventSelectionView.render(this.eventCategories);
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
            } else if (userDefinedItem) {
                if (typeof userDefinedItem === 'string') {
                    userDefinedItem = this.getUserDefinedItemById(userDefinedItem);
                }
                this.userDefinedItem = userDefinedItem;
                this.EventName.text(userDefinedItem.Description);
                this.EventItem.val(userDefinedItem.RowId);
                this.renderDetails([]);
                this.incompleteRender = false;
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
        clear: function() {
            this.eventSelectionView.close();
            this.form.form('clear');
            this.EventName.text('');
            this.detailsContainer.empty();
        },
        open: function() {
            this.dom.dialog('open');
        },
        close: function() {
            this.dom.dialog('close');
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
                        RecordData: '',
                        EventDetailItem: detailItem.RowId,
                        DataValue: value,
                        DataUnit: detailItem.Unit,
                        Description: detailItem.Description,
                        Unit: detailItem.Unit
                    });
                }
            });

            var startDT = this.StartDT.datetimebox('getValue');
            var startDate = startDT.split(' ')[0];
            var startTime = startDT.split(' ')[1];
            startDT = (new Date()).tryParse(startDT, constant.dateTimeFormat);

            return {
                RowId: "",
                SheetRecord: "",
                ParaItem: "",
                StartDate: startDate,
                StartTime: startTime,
                EndDate: startDate,
                EndTime: startTime,
                DataValue: "",
                EditFlag: "N",
                FromData: "",
                CreateUserID: "",
                CreateDT: "",
                StartDT: startDT,
                EndDT: startDT,
                CategoryItem: this.categoryItem.RowId,
                DataItem: this.categoryItem.DataItem,
                DataItemDesc: this.categoryItem.ItemDesc,
                ItemCategory: "E",
                EventDetailDatas: detailDatas,
                EventDetail: detailStrArr.join('\n'),
                edited: true
            }
        }
    };

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

            var _this = this;
            var itemsContainer = this.itemContainer;
            itemsContainer.hide();
            itemsContainer.empty();
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
            this.dom.css({ left: position.left + 185, top: position.top - 15 });
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
        return isEqual(fields, newData, oldData) && isEventDataEqual(newData, oldData);
    }

    /**
     * 判断两个药品数据是否相等
     * @param {Model.EventData} newData 
     * @param {Model.EventData} oldData 
     */
    function isEventDataEqual(newData, oldData) {
        var fields = [
            'EventDetailItem', 'DataValue'
        ];
        if ((newData.EventDetailDatas || []).length != (oldData.EventDetailDatas || []).length) return false;
        var length = newData.EventDetailDatas.length;
        for (var i = 0; i < length; i++) {
            if (!isEqual(fields, newData.EventDetailDatas[i], oldData.EventDetailDatas[i]))
                return false;
        }
        return true;
    }

    return exports;
}));