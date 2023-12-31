/**
 * 药品数据总览界面
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
        this.options = $.extend({ width: 600, height: 420 }, opt);
        this.saveHandler = opt.saveHandler;
        this.dataview = dataview;
        this.editview = editview;
        this.addview = addview;
        this.init();
    }

    DrugDataManager.prototype = {
        constructor: DrugDataManager,
        /**
         * 初始化
         */
        init: function() {
            this._initDialog();
            this._initAddView();
        },
        /**
         * 初始化对话框
         */
        _initDialog: function() {
            var _this = this;
            this.dom = $('<div></div>').appendTo('body');
            var buttons = $('<div></div>');
            var addBtn = $('<a href="#" style="float:left;"></a>').linkbutton({
                text: '新增',
                iconCls: 'icon-add',
                onClick: function() {
                    _this.addview.open();
                }
            }).appendTo(buttons);
            var saveBtn = $('<a href="#"></a>').linkbutton({
                text: '保存',
                iconCls: 'icon-save',
                onClick: function() {
                    _this.save();
                    _this.close();
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
            this._initEditView();

            this.dom.dialog({
                left: 300,
                top: 70,
                height: this.options.height,
                width: this.options.width,
                title: '用药数据总览',
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
        /**
         * 初始化数据显示
         */
        _initDataView: function() {
            var _this = this;
            this.dataviewContainer = $('<div class="ddm-dataview"></div>').appendTo(this.dom);
            this.dataviewContainer.height(this.options.height - 80).width(this.options.width - 2);
            $(this.dataviewContainer).delegate('.drugdata-i', 'click', function() {
                _this.editview.submit();
                $('.drugdata-i-selected').removeClass('drugdata-i-selected');
                $(this).addClass('drugdata-i-selected');
                var data = $(this).data('data');
                data.editing = true;
                _this.dataview.refreshAppearance(data.target, data);
                _this.editview.render(data);
                _this.openEditView();
            });
            $(this.dataviewContainer).delegate('.drugdata-i-btn-remove', 'click', function() {
                if (event.stopPropagation) event.stopPropagation();
                else event.cancelBubble = true;
                var element = $($(this).parent());
                var data = element.data('data');
                if (data) {
                    $.messager.confirm('删除数据', '确认删除用药数据：\n' + element.text(), function(confirmed) {
                        if (confirmed) {
                            _this.deleteData(data);
                        }
                    });
                }

                return false;
            });
        },
        /**
         * 初始化编辑框
         */
        _initEditView: function() {
            var _this = this;
            this.editviewContainer = $('<div class="ddm-editview" style="display:none;"></div>').appendTo(this.dom);
            this.editviewContainer.height(this.options.height - 80).width(300);
            this.editview.init(this.editviewContainer, {
                callback: function(drugData) {
                    if (this.originalData === drugData) _this.dataview.refreshAppearance(drugData.target, drugData);
                    else {
                        _this.editData(this.originalData, drugData);
                    }
                }
            });
            this.editview.setComboDataSource(this.options.comboDataSource);
        },
        /**
         * 初始化新建数据框
         */
        _initAddView: function() {
            var _this = this;
            this.addview.init(function(data) {
                if (data) {
                    _this.addData(data);
                    _this.refreshDataView();
                }
            });
            this.addview.setComboDataSource(this.options.comboDataSource);
        },
        /**
         * 打开对话框
         */
        open: function() {
            this.dom.dialog('open');
            this.saved = false;
        },
        /**
         * 关闭对话框
         */
        close: function() {
            this.dom.dialog('close');
        },
        /**
         * 清空
         */
        clear: function() {
            this.closeEditView();
        },
        /**
         * 显示编辑框
         */
        openEditView: function() {
            this.editviewContainer.show();
            this.dataviewContainer.width(this.options.width - 320);
            this.dataviewContainer.addClass('ddm-dataview-narrow');
        },
        /**
         * 隐藏编辑框
         */
        closeEditView: function() {
            this.editview.clear();
            this.editviewContainer.hide();
            this.dataviewContainer.width(this.options.width - 2);
            this.dataviewContainer.removeClass('ddm-dataview-narrow');
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
            this.addview.close();
        },
        /**
         * 设置界面项目集合
         */
        setParaItems: function(paraItems) {
            this.addview.render(this.options.dataCategories, paraItems);
        },
        /**
         * 加载数据
         */
        loadData: function(drugRecordDataArray) {
            this.data = drugRecordDataArray;
            this.refreshDataView();
        },
        /**
         * 添加数据
         */
        addData: function(anaData) {
            $.extend(anaData, {
                edited: true
            });
            this.data.push(anaData);
            this.refreshDataView();
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
                $.extend(oldData, {
                    EditFlag: 'D',
                    visible: false,
                    edited: true,
                });
                if (!oldData.RowId) {
                    var index = this.data.indexOf(oldData);
                    this.data.splice(index, 1);
                }

                $.extend(newData, {
                    originalData: originalData || oldData,
                    FromData: (originalData || oldData).RowId || '',
                    edited: true,
                    editing: false
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
         * 刷新显示
         */
        refreshDataView: function() {
            this.dataview.clear();
            this.dataview.render(this.dataviewContainer, this.data);
        },
        /**
         * 核实保存状态
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
            if (data.edited) container.addClass('drugdata-i-edited');
            else container.removeClass('drugdata-i-edited');
            if (data.editing) container.addClass('drugdata-i-editing');
            else container.removeClass('drugdata-i-editing');
            var startDT = data.StartDT.format(constant.dateTimeFormat);
            var endDT = data.EndDT.format(constant.dateTimeFormat);
            $('<a href="javascript:;" class="drugdata-i-btn-remove icon-close" title="删除此条数据"></a>').appendTo(container);
            $('<span class="drugdata-i-time"></span>')
                .text(data.StartTime)
                .attr('title', startDT)
                .appendTo(container);
            $('<span class="drugdata-i-name"></span>')
                .text(data.DrugData.Description)
                .appendTo(container);
            if (Number(data.DrugData.DoseQty) > 0)
                $('<span class="drugdata-i-dose"></span>')
                .text(data.DrugData.DoseQty + data.DrugData.DoseUnitDesc)
                .appendTo(container);
            if (Number(data.DrugData.Speed) > 0)
                $('<span class="drugdata-i-speed"></span>')
                .text(data.DrugData.Speed + data.DrugData.SpeedUnitDesc)
                .appendTo(container);
            if (Number(data.DrugData.Concentration) > 0)
                $('<span class="drugdata-i-concentration"></span>')
                .text(data.DrugData.Concentration + data.DrugData.ConcentrationUnitDesc)
                .appendTo(container);
            $('<span class="drugdata-i-instruction"></span>')
                .text(data.DrugData.InstructionDesc)
                .appendTo(container);
            $('<span class="drugdata-i-reason"></span>')
                .text(data.DrugData.ReasonDesc)
                .appendTo(container);

            var tipArr = [];
            tipArr.push(startDT + (startDT === endDT ? '' : (' ~ ' + endDT)));
            tipArr.push(data.DrugData.Description);
            if (Number(data.DrugData.DoseQty) > 0)
                tipArr.push('剂量：' + data.DrugData.DoseQty + data.DrugData.DoseUnitDesc);
            if (Number(data.DrugData.Speed) > 0)
                tipArr.push('速度：' + data.DrugData.Speed + data.DrugData.SpeedUnitDesc);
            if (Number(data.DrugData.Concentration) > 0)
                tipArr.push('浓度：' + data.DrugData.Concentration + data.DrugData.ConcentrationUnitDesc);
            tipArr.push('用法：' + data.DrugData.InstructionDesc || '');
            tipArr.push('原因：' + data.DrugData.Reason || '');
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
         * @param {Array<Data.AnaData>} data 用药数据数组
         */
        render: function(container, data) {
            this.container = container;
            data.sort(dhccl.compareInstance("StartDT"));
            var singlerender = this.singleDataView.render;
            $.each(data, function(index, row) {
                if (typeof row.visible != 'boolean' || row.visible) {
                    singlerender($('<div class="drugdata-i"></div>').appendTo(container), row);
                }
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
            if (container) this.singleDataView.render(container, drugData);
        }
    }

    var editview = {
        rendered: false,
        /**
         * 初始化用药数据编辑显示块
         */
        init: function(container, opt) {
            var _this = this;
            this.callback = opt.callback;
            this.editform = editform;
            this.editform.render(this, container, function(newValue, oldValue) {
                //_this.onChange();
            });
        },
        /**
         * 加载单条数据
         * @param {object<Data.AnaData>} data
         */
        render: function(data) {
            this.rendered = true;
            this.StartDT.datetimebox("setValue", data.StartDT.format(constant.dateTimeFormat));
            if (data && data.DrugData) {
                this.originalData = data;
                this.Speed.validatebox("setValue", data.DrugData.Speed);
                this.ArcimID.val(data.DrugData.ArcimID);
                this.ArcimItem.text(data.DrugData.ArcimDesc);
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
                this.InjectionSite.combobox("setValue", data.DrugData.InjectionSite);
                this.AnaDataRowId.val(data.RowId);
                this.DrugDataRowId.val(data.DrugData.RowId);
                this.ParaItemRowId.val(data.ParaItem);
                this.CategoryItemRowId.val(data.CategoryItem);
                this.DataItemRowId.val(data.DataItem);
                this.ParaItem.text(data.DrugData.Description);
                this.Continuous.checkbox('setValue', data.Continuous === 'Y' ? true : false);
                this.DataItemRowId.val(data.DrugData.DataItem);
                if (Date.isValidDate(data.EndDT)) {
                    this.EndDT.datetimebox("setValue", data.EndDT.format(constant.dateTimeFormat));
                }
            }
        },
        setComboDataSource: function(dataList) {
            this.DoseUnit.combobox('loadData', dataList.DoseUnits || []);
            this.SpeedUnit.combobox('loadData', dataList.SpeedUnits || []);
            this.ConcentrationUnit.combobox('loadData', dataList.ConcentrationUnits || []);
            this.Instruction.combobox('loadData', dataList.Instructions || []);
            this.Reason.combobox('loadData', dataList.Reasons || []);
        },
        clear: function() {
            if (this.originalData) this.originalData.editing = false;
            this.rendered = false;
            this.form.form('clear');
            this.ParaItem.text('');
            this.ArcimItem.text('');
        },
        setDrugItem: function(drugItem) {
            this.ArcimItem.text(drugItem.Description);
            this.DrugItemID.val(drugItem.RowId);
            this.ArcimID.val(drugItem.RowId);
            this.loadReceiveLocation();
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
                    //_this.RecvLoc.combobox("setValue", data[0].Id);
                }
            });
        },
        onChange: function() {
            if (this.originalData) {
                this.originalData.editing = true;
                this.callback.call(this, this.originalData);
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
         * 转换为数据
         */
        toData: function() {
            var startDT = this.StartDT.datetimebox("getValue");
            var arr = startDT.split(' ');
            var startDate = startTime = '';
            if (arr.length > 1) {
                startDate = arr[0];
                startTime = arr[1];
            }
            var endDT = this.EndDT.datetimebox("getValue");
            var arr = endDT.split(' ');
            var endDate = endTime = '';
            if (arr.length > 1) {
                endDate = arr[0];
                endTime = arr[1];
            }
            if (endDT === '') {
                endDT = startDT;
                endDate = startDate;
                endTime = startTime;
            }

            startDT = (new Date()).tryParse(startDT, constant.dateTimeFormat);
            endDT = (new Date()).tryParse(endDT, constant.dateTimeFormat);

            return {
                RowId: '',
                StartDate: startDate,
                StartTime: startTime,
                EndDate: endDate,
                EndTime: endTime,
                DataValue: '',
                EditFlag: 'N',
                FromData: '',
                StartDT: startDT,
                EndDT: endDT,
                FromData: '',
                ParaItem: this.ParaItemRowId.val(),
                CategoryItem: this.CategoryItemRowId.val(),
                DataItem: this.DataItemRowId.val(),
                DataItemDesc: this.ParaItem.text(),
                ItemCategory: 'D',
                Continuous: this.Continuous.checkbox('getValue') ? 'Y' : 'N',
                DrugData: {
                    RowId: '',
                    AnaData: '',
                    DoseQty: this.DoseQty.validatebox("getValue"),
                    DoseUnit: this.DoseUnit.combobox("getValue"),
                    Instruction: this.Instruction.combobox("getValue"),
                    Concentration: this.Concentration.validatebox("getValue"),
                    ConcentrationUnit: this.ConcentrationUnit.combobox("getValue"),
                    Speed: this.Speed.validatebox("getValue"),
                    SpeedUnit: this.SpeedUnit.combobox("getValue"),
                    BalanceQty: "",
                    Reason: this.Reason.combobox("getValue"),
                    InjectionSite: this.InjectionSite.combobox("getValue"),
                    BalanceDisposal: "",
                    RecvLoc: this.RecvLoc.combobox('getValue'),
                    ArcimID: this.ArcimID.val(),
                    OrderItemID: "",
                    DoseUnitDesc: this.DoseUnit.combobox("getText"),
                    SpeedUnitDesc: this.SpeedUnit.combobox("getText"),
                    ConcentrationUnitDesc: this.ConcentrationUnit.combobox("getText"),
                    InstructionDesc: this.Instruction.combobox("getText"),
                    ArcimDesc: this.ArcimItem.text(),
                    RecvLocDesc: this.RecvLoc.combobox('getText'),
                    Continuous: this.Continuous.checkbox('getValue') ? 'Y' : 'N',
                    Description: this.ParaItem.text(),
                    DataItem: this.DataItemRowId.val()
                }
            }
        }
    }

    var editform = {
        render: function(target, container, onChange) {
            this.form_count = this.form_count || 0;
            this.form_count++;

            target.form = $('<form class="ddm-editview-form"></form>').appendTo(container);
            target.form.form({});

            target.AnaDataRowId = $('<input type="hidden" name="RowId">').appendTo(target.form);
            target.DrugDataRowId = $('<input type="hidden" name="DrugDataRowId">').appendTo(target.form);

            var itemRow = $('<div class="ddm-editview-f-r"><div class="label">药品名称：</div></div>').appendTo(target.form);
            target.ParaItem = $('<div class="ddm-editview-paraitem" title="单击选择药品名称" style="width:164px;"></div>').appendTo(itemRow);
            target.ParaItemRowId = $('<input type="hidden" name="ParaItem">').appendTo(itemRow);
            target.CategoryItemRowId = $('<input type="hidden" name="CategoryItem">').appendTo(itemRow);
            target.DataItemRowId = $('<input type="hidden" name="DataItem">').appendTo(itemRow);
            target.ParaItemButton = $('<span class="drugeditor-editview-drugitem" style="width:24px;margin-left:3px;"><span class="icon icon-template" style="margin-top:7px;margin-left:2px;"></span></span>').appendTo(itemRow);

            var itemRow = $('<div class="ddm-editview-f-r"><div class="label">医嘱项：</div></div>').appendTo(target.form);
            target.ArcimItem = $('<div class="ddm-editview-drugitem" title="单击选择医嘱项" style="width:164px;"></div>').appendTo(itemRow);
            target.ArcimID = $('<input type="hidden" name="ArcimID">').appendTo(itemRow);
            target.ArcimItemButton = $('<span class="drugeditor-editview-drugitem" style="width:24px;margin-left:3px;"><span class="icon icon-template" style="margin-top:7px;margin-left:2px;"></span></span>').appendTo(itemRow);

            var itemRow = $('<div class="ddm-editview-f-r"></div>').appendTo(target.form);
            var label = $('<label class="label" for="ddm_editview_continuous_' + this.form_count + '">持续：</label>').appendTo(itemRow);
            target.Continuous = $('<input id="ddm_editview_continuous_' + this.form_count + '" type="checkbox" name="Continuous">').appendTo(itemRow);
            target.Continuous.checkbox({
                onChecked: function(e, value) {
                    target.EndDT.datetimebox('enable');
                    target.EndDT.datetimebox('setValue', '9999-12-31 00:00');

                    target.Speed.validatebox('enable');
                    target.SpeedUnit.combobox('enable');
                },
                onUnchecked: function(e, value) {
                    target.EndDT.datetimebox('disable');
                    target.EndDT.datetimebox('setValue', target.StartDT.datetimebox('getValue'));

                    target.Speed.validatebox('disable');
                    target.SpeedUnit.combobox('disable');
                }
            });
            var label = $('<label class="label" for="ddm_editview_tci_' + this.form_count + '" style="float:none;display:inline-block;">靶控：</label>').appendTo(itemRow);
            this.TCI = $('<input id="ddm_editview_tci_' + this.form_count + '" type="checkbox" name="TCI">').appendTo(itemRow);
            this.TCI.checkbox({
                onChecked: function(e, value) {
                    _this.Continuous.checkbox('setValue', true);
                },
                onUnchecked: function(e, value) {
                    _this.Continuous.checkbox('setValue', false);
                }
            });

            var timeRow = $('<div class="ddm-editview-f-r"></div>').appendTo(target.form);
            var label = $('<div class="label">开始时间：</div>').appendTo(timeRow);
            target.StartDT = $('<input type="text" name="StartDT">').appendTo(timeRow);
            target.StartDT.datetimebox({
                required: true,
                width: 200,
                label: label,
                onChange: onChange
            });

            var timeRow = $('<div class="ddm-editview-f-r"></div>').appendTo(target.form);
            var label = $('<div class="label">结束时间：</div>').appendTo(timeRow);
            target.EndDT = $('<input type="text" name="EndDT">').appendTo(timeRow);
            target.EndDT.datetimebox({
                width: 200,
                label: label,
                disabled: true,
                onChange: onChange
            });

            var doseRow = $('<div class="ddm-editview-f-r"></div>').appendTo(target.form);
            var label = $('<div class="label">剂量：</div>').appendTo(doseRow);
            target.DoseQty = $('<input type="text" name="DoseQty" style="width:93px;margin-right:5px;">').appendTo(doseRow);
            target.DoseUnit = $('<input type="text" name="DoseUnit">').appendTo(doseRow);
            target.DoseQty.validatebox({
                width: 100,
                label: label,
                novalidate: true,
                onChange: onChange
            });
            target.DoseUnit.combobox({
                width: 95,
                valueField: "RowId",
                textField: "Description",
                cls: 'ddm-editview-f-r-unit',
                onChange: onChange
            });

            var speedRow = $('<div class="ddm-editview-f-r"></div>').appendTo(target.form);
            var label = $('<div class="label">速度：</div>').appendTo(speedRow);
            target.Speed = $('<input type="text" name="Speed" disabled style="width:93px;margin-right:5px;">').appendTo(speedRow);
            target.SpeedUnit = $('<input type="text" name="SpeedUnit">').appendTo(speedRow);
            target.Speed.validatebox({
                width: 100,
                label: label,
                novalidate: true,
                onChange: onChange
            });
            target.SpeedUnit.combobox({
                width: 95,
                disabled: true,
                valueField: "RowId",
                textField: "Description",
                cls: 'ddm-editview-f-r-unit',
                onChange: onChange
            });

            var concentrationRow = $('<div class="ddm-editview-f-r"></div>').appendTo(target.form);
            var label = $('<div class="label">浓度：</div>').appendTo(concentrationRow);
            target.Concentration = $('<input type="text" name="Concentration" style="width:93px;margin-right:5px;">').appendTo(concentrationRow);
            target.ConcentrationUnit = $('<input type="text" name="ConcentrationUnit">').appendTo(concentrationRow);
            target.Concentration.validatebox({
                width: 100,
                label: label,
                novalidate: true
            });
            target.ConcentrationUnit.combobox({
                width: 95,
                valueField: "RowId",
                textField: "Description",
                cls: 'ddm-editview-f-r-unit',
                onChange: onChange
            });

            var instructionRow = $('<div class="ddm-editview-f-r"></div>').appendTo(target.form);
            var label = $('<div class="label">用药途径：</div>').appendTo(instructionRow);
            target.Instruction = $('<input type="text" name="Instruction">').appendTo(instructionRow);
            target.Instruction.combobox({
                width: 200,
                valueField: "RowId",
                textField: "Description",
                label: label,
                onChange: onChange
            });

            var reasonRow = $('<div class="ddm-editview-f-r"></div>').appendTo(target.form);
            var label = $('<div class="label">原因：</div>').appendTo(reasonRow);
            target.Reason = $('<input type="text" name="Reason">').appendTo(reasonRow);
            target.Reason.combobox({
                width: 200,
                valueField: "RowId",
                textField: "Description",
                label: label,
                onChange: onChange
            });

            var receiveLocRow = $('<div class="ddm-editview-f-r" style="display:none;"></div>').appendTo(target.form);
            var label = $('<div class="label">接收科室：</div>').appendTo(receiveLocRow);
            target.RecvLoc = $('<input type="text" name="RecvLoc">').appendTo(receiveLocRow);
            target.RecvLoc.combobox({
                width: 200,
                valueField: "Id",
                textField: "Desc",
                label: label,
                onChange: onChange
            });

            var row = $('<div class="ddm-editview-f-r"></div>').appendTo(target.form);
            var label = $('<div class="label">输液部位：</div>').appendTo(row);
            target.InjectionSite = $('<input type="text">').appendTo(row);
            target.InjectionSite.combobox({
                width: 200,
                valueField: "value",
                textField: "text",
                label: label,
                data: [{ value: '左上肢', text: '左上肢' },
                    { value: '右上肢', text: '右上肢' },
                    { value: '右颈内', text: '右颈内' },
                    { value: '左颈内', text: '左颈内' },
                    { value: '右颈外', text: '右颈外' },
                    { value: '左颈外', text: '左颈外' },
                    { value: '右股静脉', text: '右股静脉' },
                    { value: '左股静脉', text: '左股静脉' },
                    { value: '右下肢', text: '右下肢' },
                    { value: '左下肢', text: '左下肢' },
                    { value: '右锁骨下', text: '右锁骨下' }
                ]
            });
        }
    }

    var addview = {
        /**
         * 初始化新增用药数据的模态框
         * @param {function} callback
         */
        init: function(callback) {
            var _this = this;
            this.editform = editform;
            this.callback = callback;
            this.arcimSelectionView = arcimSelectionView;
            this.paraItemSelectionView = paraItemSelectionView;
            this.paraItemSelectionView.init(function(paraItem) {
                _this.setParaItem(paraItem);
            });
            this.arcimSelectionView.init(function(drugItem) {
                _this.setDrugItem(drugItem);
            });

            this.dom = $('<div></div>').appendTo('body');

            this.editform.render(this, this.dom, function() {
                _this.onChange();
            });

            var buttons = $('<div></div>');
            var addBtn = $('<a href="#"></a>').linkbutton({
                text: '新增',
                iconCls: 'icon-add',
                onClick: function() {
                    if (_this.validate()) {
                        _this.callback(_this.toData());
                        _this.close();
                    }
                }
            }).appendTo(buttons);
            var cancelBtn = $('<a href="#"></a>').linkbutton({
                text: '取消',
                iconCls: 'icon-cancel',
                onClick: function() {
                    _this.callback(false);
                    _this.close();
                }
            }).appendTo(buttons);

            this.dom.dialog({
                left: 400,
                top: 120,
                height: 500,
                width: 340,
                title: '新增用药数据',
                modal: true,
                closed: true,
                buttons: buttons,
                onOpen: function() {},
                onClose: function() {
                    _this.clear();
                }
            });

            this.ParaItem.click(function() {
                _this.arcimSelectionView.close();
                _this.paraItemSelectionView.position($(this).offset()).open();
                $(this).addClass('drugeditor-editview-drugitem-selected');
            });

            this.ParaItemButton.click(function() {
                _this.arcimSelectionView.close();
                _this.paraItemSelectionView.position($(_this.ParaItem).offset()).open();
                $(_this.ParaItem).addClass('drugeditor-editview-drugitem-selected');
            });

            this.ArcimItem.click(function() {
                _this.paraItemSelectionView.close();
                _this.arcimSelectionView.position($(this).offset()).open();
                $(this).addClass('drugeditor-editview-drugitem-selected');
            });

            this.ArcimItemButton.click(function() {
                _this.paraItemSelectionView.close();
                _this.arcimSelectionView.position($(_this.ArcimItem).offset()).open();
                $(_this.ArcimItem).addClass('drugeditor-editview-drugitem-selected');
            });

            this.form.delegate('input', 'focus', function() {
                _this.arcimSelectionView.close();
                _this.paraItemSelectionView.close();
            });
        },
        open: function() {
            this.dom.dialog('open');
            this.StartDT.datetimebox('setValue', new Date().format(constant.dateTimeFormat));
        },
        close: function() {
            this.dom.dialog('close');
        },
        clear: function() {
            this.arcimSelectionView.close();
            this.paraItemSelectionView.close();
            this.form.form('clear');
            this.ParaItem.text('');
            this.ArcimItem.text('');
        },
        setComboDataSource: function(dataList) {
            this.DoseUnit.combobox('loadData', dataList.DoseUnits || []);
            this.SpeedUnit.combobox('loadData', dataList.SpeedUnits || []);
            this.ConcentrationUnit.combobox('loadData', dataList.ConcentrationUnits || []);
            this.Instruction.combobox('loadData', dataList.Instructions || []);
            this.Reason.combobox('loadData', dataList.Reasons || []);
        },
        validate: function() {
            return this.form.form('validate');
        },
        onChange: function() {

        },
        render: function(dataCategories, paraItems) {
            this.paraItemSelectionView.render(dataCategories, paraItems);
        },
        setParaItem: function(paraItem) {
            if (paraItem && paraItem.CategoryItem) {
                this.paraItem = paraItem;
                this.ParaItem.text(paraItem.Description);
                this.ParaItemRowId.val(paraItem.RowId);
                this.arcimSelectionView.render(paraItem.CategoryItem);
                this.DataItemRowId.val(paraItem.DataItem);
            }
        },
        setDrugItem: function(drugItem) {
            this.ArcimItem.text(drugItem.Description);
            this.DrugItemID.val(drugItem.RowId);
            this.ArcimID.val(drugItem.RowId);
            this.loadReceiveLocation();
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
        toData: function() {
            var startDT = this.StartDT.datetimebox("getValue");
            var arr = startDT.split(' ');
            var startDate = startTime = '';
            if (arr.length > 1) {
                startDate = arr[0];
                startTime = arr[1];
            }
            var endDT = this.EndDT.datetimebox("getValue");
            var arr = endDT.split(' ');
            var endDate = endTime = '';
            if (arr.length > 1) {
                endDate = arr[0];
                endTime = arr[1];
            }
            if (endDT === '') {
                endDT = startDT;
                endDate = startDate;
                endTime = startTime;
            }

            startDT = (new Date()).tryParse(startDT, constant.dateTimeFormat);
            endDT = (new Date()).tryParse(endDT, constant.dateTimeFormat);

            return {
                RowId: '',
                StartDate: startDate,
                StartTime: startTime,
                EndDate: endDate,
                EndTime: endTime,
                DataValue: '',
                EditFlag: 'N',
                FromData: '',
                StartDT: startDT,
                EndDT: endDT,
                ParaItem: this.paraItem.RowId,
                CategoryItem: this.paraItem.CategoryItem,
                DataItem: this.paraItem.DataItem,
                DataItemDesc: this.paraItem.Description,
                ItemCategory: this.paraItem.ItemCategory,
                DrugData: {
                    RowId: '',
                    AnaData: '',
                    DoseQty: this.DoseQty.validatebox("getValue"),
                    DoseUnit: this.DoseUnit.combobox("getValue"),
                    Instruction: this.Instruction.combobox("getValue"),
                    Concentration: this.Concentration.validatebox("getValue"),
                    ConcentrationUnit: this.ConcentrationUnit.combobox("getValue"),
                    Speed: this.Speed.validatebox("getValue"),
                    SpeedUnit: this.SpeedUnit.combobox("getValue"),
                    BalanceQty: "",
                    Reason: this.Reason.combobox('getValue'),
                    InjectionSite: this.InjectionSite.combobox('getValue'),
                    BalanceDisposal: "",
                    RecvLoc: this.RecvLoc.combobox('getValue'),
                    ArcimID: this.ArcimID.val(),
                    OrderItemID: "",
                    DoseUnitDesc: this.DoseUnit.combobox("getText"),
                    SpeedUnitDesc: this.SpeedUnit.combobox("getText"),
                    ConcentrationUnitDesc: this.ConcentrationUnit.combobox("getText"),
                    InstructionDesc: this.Instruction.combobox("getText"),
                    ArcimDesc: this.ArcimItem.text(),
                    RecvLocDesc: this.RecvLoc.combobox('getText'),
                    Continuous: this.Continuous.checkbox('getValue') ? 'Y' : 'N',
                    Description: this.ParaItem.text(),
                    DataItem: this.DataItemRowId.val()
                }
            }
        }
    }

    /**
     * 界面项目选择
     */
    var paraItemSelectionView = {
        closed: false,
        init: function(callback) {
            var _this = this;
            this.callback = callback;
            this.dom = $('<div class="drugeditor-selectionview"></div>').appendTo('body');
            this.container = $('<div class="drugeditor-selectionview-container"></div>').appendTo(this.dom);
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
        render: function(dataCategories, paraItems) {
            var _this = this;
            var mainContainer = this.container;
            mainContainer.empty();
            $.each(dataCategories, function(index, category) {
                var categoryContainer = $('<div class="ddm-selectionview-cat"></div>').appendTo(mainContainer);
                categoryContainer.data('category', category);
                $('<div class="ddm-selectionview-cat-header"></div>').text(category.Description).appendTo(categoryContainer);
                var itemsContainer = $('<div class="ddm-selectionview-cat-items"></div>').appendTo(categoryContainer);

                var items = paraItems;
                var length = items.length;
                var item = null,
                    element = null;
                for (var j = 0; j < length; j++) {
                    item = items[j];
                    if (item.MainDataCategory == category.RowId) {
                        element = $('<a href="#" class="paraitem-button"></a>').text(item.Description).appendTo(itemsContainer);
                        element.data('data', item);
                        element.linkbutton({
                            onClick: function() {
                                var callback = _this.callback;
                                if (callback) callback($(this).data('data'));
                            }
                        });
                    }
                }
            });

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
            this.dom.css({ left: position.left, top: position.top + 35 });
            return this;
        }
    }

    var arcimSelectionView = {
        closed: false,
        init: function(callback) {
            var _this = this;
            this.callback = callback;
            this.dom = $('<div class="drugeditor-selectionview"></div>').appendTo('body');
            this.container = $('<div class="drugeditor-selectionview-container"></div>').appendTo(this.dom);
            this.close();

            this.dom.mouseleave(function() {
                _this.close();
            });

            this.header = $('<div class="ddm-selectionview-header"></div>').appendTo(this.container);
            var searchBox = $('<input type="text">').appendTo(this.header);
            searchBox.validatebox({
                width: 190,
                novalidate: true,
                prompt: '输入简拼或汉字搜索',
                iconCls: 'icon-search',
                iconAlign: 'right',
                onClickButton: function() {
                    var text = $(this).validatebox('getText');
                    _this.filter();
                }
            });

            this.header.delegate('input', 'keyup', function(e) {
                if (e.keyCode == 13) {
                    var text = $(this).val();
                    _this.filter(text);
                }
            })

            this.itemContainer = $('<div class="ddm-selectionview-items"></div>').appendTo(this.container);

            this.dom.delegate('.drug-button', 'click', function() {
                var callback = _this.callback;
                if (callback) callback($(this).data('data'));
            });

            return this;
        },
        render: function(categoryItem) {
            this.drugItems = [];
            if (!categoryItem.DataItem) return;
            this.drugItems = categoryItem.DataItem.DrugItems || [];
            this.renderItems(drugItems);
            return this;
        },
        renderItems: function(drugItems) {
            var container = this.itemContainer;
            container.empty();
            $.each(drugItems, function(index, drugItem) {
                var element = null;
                element = $('<a href="#" class="drug-button"></a>').text(drugItem.ArcimDesc || drugItem.Description).appendTo(container);
                element.data('data', drugItem);
            });
        },
        filter: function(filterString) {
            var _this = this;
            if (filterString === '') {
                this.renderItems(this.drugItems);
            } else {
                dhccl.getDatas(ANCSP.DataQuery, {
                    ClassName: CLCLS.BLL.Admission,
                    QueryName: "FindMasterItem",
                    Arg1: filterString,
                    ArgCnt: 1
                }, 'json', true, function(data) {
                    _this.renderItems(data);
                });
            }
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
        position: function(position) {
            this.dom.css({ left: position.left, top: position.top + 35 });
            return this;
        }
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
        return isEqual(fields, newData, oldData) && isDrugDataEqual(newData.DrugData, oldData.DrugData);
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
            'ArcimID'
        ];
        return isEqual(fields, newData, oldData);
    }

    return exports;
}));