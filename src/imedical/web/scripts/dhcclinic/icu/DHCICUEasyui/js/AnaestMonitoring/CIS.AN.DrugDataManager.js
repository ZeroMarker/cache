/**
 * 药品数据总览界面-直接对应开启数据编辑框
 * @author yongyang 2018-04-12
 */
(function(global, factory) {
    if (!global.drugDataManager) factory(global.drugDataManager = {});
}(this, function(exports) {

    function init(opt) {
        var view = new DrugDataManager(opt);
        exports.instance = view;
        return view;
    }

    exports.init = init;

    function DrugDataManager(opt) {
        this.options = $.extend({ width: 450, height: 420 }, opt);
        this.saveHandler = opt.saveHandler;
        this.IntriDrugEditor = opt.IntriDrugEditor;
        this.DrugEditor = opt.DrugEditor;
        this.dataview = dataview;
        this.itemview = paraItemView;
        this.init();
    }

    DrugDataManager.prototype = {
        constructor: DrugDataManager,
        /**
         * 初始化
         */
        init: function() {
            this._initDialog();
            this._initItemView();
        },
        /**
         * 初始化对话框
         */
        _initDialog: function() {
            var _this = this;
            this.dom = $('<div></div>').appendTo('body');
            var buttons = $('<div></div>');
            var addBtn = $('<a href="#"></a>').linkbutton({
                text: '新增',
                iconCls: 'icon-add',
                onClick: function() {
                    _this.itemview.position($(this).offset());
                    _this.itemview.open();
                }
            }).appendTo(buttons);
            var closeBtn = $('<a href="#"></a>').linkbutton({
                text: '关闭',
                iconCls: 'icon-cancel',
                onClick: function() {
                    _this.close();
                }
            }).appendTo(buttons);

            this._initDataView();
            this._initItemView();

            this.dom.dialog({
                left: 300,
                top: 70,
                height: this.options.height,
                width: this.options.width,
                title: '用药数据总览',
                modal: true,
                closed: true,
                iconCls: 'icon-drug',
                buttons: buttons,
                onOpen: function() {

                },
                onBeforeClose: function() {},
                onClose: function() {
                    _this.clear();
                }
            });
        },
        /**
         * 初始化数据显示
         */
        _initDataView: function() {
            var _this = this;
            this.dataviewContainer = $('<div class="ddm-dataview"></div>').appendTo(this.dom);
            $(this.dataviewContainer).delegate('.ddm-drugdata-i', 'dblclick', function() {
                $('.ddm-drugdata-i-selected').removeClass('ddm-drugdata-i-selected');
                $(this).addClass('ddm-drugdata-i-selected');
                var data = $(this).data('data');
                data.editing = true;
                _this.openEditView(data);
            });

            $(this.dataviewContainer).delegate('.drugdata-i-btn-edit', 'click', function() {
                $('.ddm-drugdata-i-selected').removeClass('ddm-drugdata-i-selected');
                $(this).addClass('ddm-drugdata-i-selected');
                var data = $(this).parent().data('data');
                data.editing = true;
                _this.openEditView(data);
            });

            $(this.dataviewContainer).delegate('.drugdata-i-btn-remove', 'click', function(e) {
                if (e.stopPropagation) e.stopPropagation();
                else e.cancelBubble = true;
                var data = $(this).parent().data('data');
                if (data) {
                    var drugData, tipArr = [];
                    tipArr.push(data.StartDate + ' ' + data.StartTime);
                    for (var i = 0, length = data.DrugDataList.length; i < length; i++) {
                        drugData = data.DrugDataList[i];
                        tipArr.push(drugData.Description);
                        if (Number(drugData.DoseQty) > 0)
                            tipArr.push('剂量：' + drugData.DoseQty + drugData.DoseUnitDesc);
                        if (Number(data.DrugData.Speed) > 0)
                            tipArr.push('速度：' + drugData.Speed + drugData.SpeedUnitDesc);
                        if (Number(drugData.Concentration) > 0)
                            tipArr.push('浓度：' + drugData.Concentration + drugData.ConcentrationUnitDesc);
                        tipArr.push('用法：' + drugData.InstructionDesc || '');
                        tipArr.push('原因：' + drugData.Reason || '');
                    }

                    var drugInfo = tipArr.join('<br/>');

                    $.messager.confirm('提示', '是否确认删除此数据:<br/><b>' + drugInfo + '</b>', function(confirmed) {
                        if (confirmed) _this.deleteData(data);
                    });
                }

                return false;
            });
        },
        _initItemView: function() {
            var _this = this;
            this.itemview.init(function(paraItem) {
                _this.openAddView(paraItem);
            });
        },
        /**
         * 打开对话框
         */
        open: function() {
            this.dom.dialog('open');
            this.visible = true;
        },
        /**
         * 关闭对话框
         */
        close: function() {
            this.dom.dialog('close');
            this.visible = true;
        },
        /**
         * 清空
         */
        clear: function() {
            this.dataview.clear();
        },
        /**
         * 显示编辑框
         */
        openEditView: function(data) {
            var paraItem = this.getParaItems(data.ParaItem);
            var editor = this.getEditor(paraItem);

            if (editor) {
                editor.setParaItem(paraItem);
                editor.loadData(data);
                editor.open();
            }
        },
        /**
         * 显示新增数据框
         */
        openAddView: function(paraItem) {
            var editor = this.getEditor(paraItem);

            editor.setParaItem(paraItem);
			editor.loadData("" || {
                StartDT: new Date()
            });
            editor.open();
        },
        getEditor: function(paraItem) {
            var editor;
            if (paraItem) {
                if (paraItem.Code == 'OperationDrug') {
                    editor = window.IntrmiDrugEditor.instance;
                } else {
                    editor = window.DrugEditor.instance;
                }
            }

            return editor;
        },
        /**
         * 设置界面项目集合
         */
        setParaItems: function(paraItems) {
            this.itemview.render(paraItems);

            var paraItemDictionary = {};
            for (var i = 0, length = paraItems.length; i < length; i++) {
                paraItemDictionary[paraItems[i].RowId] = paraItems[i];
            }
            this.paraItemDictionary = paraItemDictionary;
        },
        getParaItems: function(rowId) {
            return this.paraItemDictionary[rowId];
        },
        setKeyTime: function(keyTimeList) {
            this.keyTimeList = keyTimeList;
        },
        /**
         * 加载数据
         */
        loadData: function(data) {
            this.data = data;
            this.refreshDataView();
        },
        /**
         * 删除数据
         */
        deleteData: function(data) {
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

            var anaDataClassName = ANCLS.Model.AnaData;
            var preparedDatas = [];
            var guid = dhccl.guid();
            preparedDatas.push({
                Guid: guid,
                ClassName: anaDataClassName,
                EditFlag: 'D',
                RowId: data.RowId,
            });

            if (this.saveHandler) this.saveHandler(preparedDatas);
        },
        /**
         * 刷新显示
         */
        refreshDataView: function() {
            this.dataview.clear();
            this.dataview.render(this.dataviewContainer, this.data, this.keyTimeList);
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
         * 保存
         */
        save: function() {
            this.editview.submit();
            var preparedDatas = [];
            var savingDatas = this.getEditedDatas();
            if (!savingDatas || savingDatas.length <= 0) return;
            prepareSavingDatas();
            this.saveHandler(preparedDatas);
            this.saved = true;

            function prepareSavingDatas() {
                var createUserID = session.UserID;
                var anaDataClassName = ANCLS.Model.AnaData;
                var drugDataClassName = ANCLS.Model.DrugData;
                $.each(savingDatas, function(index, data) {
                    var guid = dhccl.guid();
                    preparedDatas.push($.extend({}, data, {
                        Guid: guid,
                        ClassName: anaDataClassName,
                        CreateUserID: createUserID,
                        target: '',
                        DrugData: '',
                        DrugDataList: ''
                    }));
                    if (data.DrugData) {
                        preparedDatas.push($.extend({}, data.DrugData, {
                            AnaDataGuid: guid,
                            ClassName: drugDataClassName,
                            target: ''
                        }));
                    }
                });
            }
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

            tooltip();

            if (data.edited) container.addClass('ddm-drugdata-i-edited');
            else container.removeClass('ddm-drugdata-i-edited');
            if (data.editing) container.addClass('ddm-drugdata-i-editing');
            else container.removeClass('ddm-drugdata-i-editing');

            var header = $('<div class="data-tree-node-i-header"></div>').appendTo(container);
            var content = $('<div class="data-tree-node-i-content"></div>').appendTo(container);

            var startDT = data.StartDT.format(constant.dateTimeFormat);
            var endDT = data.EndDT.format(constant.dateTimeFormat);
            $('<a href="javascript:;" class="drugdata-i-btn-edit icon-edit" title="编辑此条数据"></a>').appendTo(container);
            $('<a href="javascript:;" class="drugdata-i-btn-remove icon-cancel" title="删除此条数据"></a>').appendTo(container);

            $('<span class="tree-node-line"></span>').appendTo(header);
            $('<span class="tree-node-spot"></span>').appendTo(header);

            var status = '';
            if (data.Continuous == 'Y') status = data.EndDate ? data.EndTime : '持续中...';

            $('<div class="data-tree-node-i-time"></div>')
                .text(data.StartTime)
                .attr('title', startDT)
                .appendTo(content);

            var rowList = $('<div class="ddm-drugdata-i-c-rowlist"></div>')
                .appendTo(content);

            if (status) $('<div class="ddm-drugdata-i-status"></div>')
                .text(status)
                .appendTo(content);

            var row;
            for (var i = 0, length = data.DrugDataList.length; i < length; i++) {
                row = addRow(data.DrugDataList[i]);
            }

            function addRow(drugData) {
                row = $('<div class="ddm-drugdata-i-c-row"></div>')
                    .data('data', drugData)
                    .appendTo(rowList);

                $('<span class="ddm-drugdata-i-name"></span>')
                    .text(drugData.Description)
                    .appendTo(row);

                if (Number(drugData.DoseQty) > 0)
                    $('<span class="ddm-drugdata-i-dose"></span>')
                    .text(drugData.DoseQty + drugData.DoseUnitDesc)
                    .appendTo(row);
                if (Number(drugData.Speed) > 0)
                    $('<span class="ddm-drugdata-i-speed"></span>')
                    .text(drugData.Speed + drugData.SpeedUnitDesc)
                    .appendTo(row);
                if (Number(drugData.Concentration) > 0)
                    $('<span class="ddm-drugdata-i-concentration"></span>')
                    .text(drugData.Concentration + drugData.ConcentrationUnitDesc)
                    .appendTo(row);

                $('<span class="ddm-drugdata-i-instruction"></span>')
                    .text(drugData.InstructionDesc)
                    .appendTo(row);
                $('<span class="ddm-drugdata-i-reason"></span>')
                    .text(drugData.ReasonDesc)
                    .appendTo(row);

                return row;
            }


            function tooltip() {
                var tipArr = [];
                var startDT = data.StartDT.format(constant.dateTimeFormat);
                var endDT = data.EndDT.format(constant.dateTimeFormat);
                var duration = startDT;
                if (data.Continuous == 'Y') duration = duration + '~' + (data.EndDate ? endDT : '');
                tipArr.push('<div style="text-align:center;">' + duration + '</div>');

                var drugData;
                for (var i = 0, length = data.DrugDataList.length; i < length; i++) {
                    drugData = data.DrugDataList[i];
                    tipArr.push('<div style="display:inline-block;margin-right:5px;">');
                    tipArr.push(drugData.Description);
                    tipArr.push('<br/>');
                    tipArr.push('<span style="font-size:11px;">');
                    if (Number(drugData.DoseQty) > 0)
                        tipArr.push('剂量：' + drugData.DoseQty + drugData.DoseUnitDesc + '<br/>');
                    if (Number(data.DrugData.Speed) > 0)
                        tipArr.push('速度：' + drugData.Speed + drugData.SpeedUnitDesc + '<br/>');
                    if (Number(drugData.Concentration) > 0)
                        tipArr.push('浓度：' + drugData.Concentration + drugData.ConcentrationUnitDesc + '<br/>');
                    tipArr.push('用法：' + drugData.InstructionDesc || '' + '<br/>');
                    tipArr.push('原因：' + drugData.Reason || '');
                    tipArr.push('</span>');
                    tipArr.push('</div>');
                }


                container.tooltip({
                    content: tipArr.join(''),
                    position: 'bottom'
                });
            }
        }
    }

    var keyTimeView = {
        render: function(container, data) {
            container.data('data', data);
            data.target = container;
            container.empty();

            var header = $('<div class="data-tree-node-i-header"></div>').appendTo(container);
            var content = $('<div class="data-tree-node-i-content"></div>').appendTo(container);

            var timeStr = data.time.format('HH:mm:ss');

            $('<span class="tree-node-line"></span>').appendTo(header);
            $('<span class="tree-node-spot"></span>').appendTo(header);

            $('<div class="data-tree-node-i-time"></div>')
                .text(timeStr)
                .attr('title', data.time.format(constant.dateTimeFormat))
                .appendTo(content);

            $('<span class="data-keytime-text"></span>')
                .text(data.text)
                .appendTo(content);
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
         * @param {Array<Data.AnaData>} data 用药数据数组
         */
        render: function(container, data, keyTimeList) {
            this.container = container;
            data.sort(dhccl.compareInstance("StartDT"));
            var singlerender = this.singleDataView.render;

            $.each(data, function(index, row) {
                if (typeof row.visible != 'boolean' || row.visible) {
                    singlerender($('<div class="data-tree-node-i ddm-drugdata-i"></div>').appendTo(container), row);
                }
            });

            var keyTime, matchedData, element, timespan;
            for (var key in keyTimeList) {
                keyTime = keyTimeList[key];
                matchedData = null;
                if (keyTime.time) {
                    for (var i = 0, length = data.length; i < length; i++) {
                        timespan = new TimeSpan(data[i].StartDT, keyTime.time);
                        if (Math.abs(timespan.totalSeconds) < 5 || timespan.totalSeconds > 30) {
                            matchedData = data[i];
                            break;
                        }
                    }
                    if (matchedData) {
                        element = $('<div class="data-tree-node-i"></div>');
                        matchedData.target.before(element);
                    } else {
                        element = $('<div class="data-tree-node-i"></div>').appendTo(container);
                    }

                    keyTimeView.render(element, keyTime);
                }
            }

            var nodes = container.find('.data-tree-node-i');
            $(nodes[0]).addClass('data-tree-node-i-first');
            $(nodes[nodes.length - 1]).addClass('data-tree-node-i-last');
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
            if (container) this.singleDataView.render(container, drugData);
        }
    }

    /**
     * 界面项目选择
     */
    var paraItemView = {
        closed: false,
        init: function(callback) {
            var _this = this;
            this.callback = callback;
            this.dom = $('<div class="ddm-selectionview"></div>').appendTo('body');
            this.container = $('<div class="ddm-selectionview-container"></div>').appendTo(this.dom);
            this.close();

            this.dom.mouseleave(function() {
                _this.close();
            });

            this.dom.delegate('.paraitem-button', 'click', function() {
                var callback = _this.callback;
                if (callback) callback($(this).data('data'));
            });
            return this;
        },
        render: function(paraItems) {
            var _this = this;
            var mainContainer = this.container;
            mainContainer.empty();
            var itemsContainer = $('<div class="ddm-selectionview-items"></div>').appendTo(mainContainer);

            var items = paraItems;
            var length = items.length;
            var item = null,
                element = null;
            for (var j = 0; j < length; j++) {
                item = items[j];
                element = $('<a href="#" class="paraitem-button"></a>').text(item.Description).appendTo(itemsContainer);
                element.data('data', item);
            }

            return this;
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
            return this;
        },
        /**
         * 设置位置
         */
        position: function(position) {
            this.dom.css({ left: position.left, top: position.top - 15 - this.dom.height() });
            return this;
        }
    }

    return exports;
}));