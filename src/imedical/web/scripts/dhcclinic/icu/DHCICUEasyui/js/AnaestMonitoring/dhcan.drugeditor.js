/**
 * 用药数据编辑
 * 初始化的时候才创建并储存一个实例
 * @author yongyang 20180503
 */

(function(global, factory) {
    if (!global.DrugEditor) factory(global.DrugEditor = {});
}(this, function(exports) {

    exports.init = function(opt) {
        exports.instance = new DrugEditor(opt);
        return exports.instance;
    }

    exports.open = function() {
        if (exports.instance) exports.instance.open();
        else {
            $.messager.alert('错误', '用药数据编辑界面未初始化', 'icon-error');
        }
    }

    exports.instance = null;

    /**
     * 用药数据编辑界面
     * @param {object} opt 
     */
    function DrugEditor(opt) {
        this.options = $.extend(opt, {
            width: 320,
            height: 500
        });
        this.saveHandler = opt.saveHandler;
        this.editform = editform;
        this.addingDrugView = addingDrugView;
        this.init();
    }

    DrugEditor.prototype = {
        init: function() {
            var _this = this;
            this.dom = $('<div></div>').appendTo('body');
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

            this.initForm();
            this.dom.dialog({
                left: 300,
                top: 50,
                height: this.options.height,
                width: this.options.width,
                title: '用药数据编辑',
                modal: true,
                closed: true,
                buttons: buttons,
                onOpen: function() {

                },
                onClose: function() {
                    _this.clear();
                }
            });
            this.initiated = true;
        },
        initForm: function() {
            this.addingDrugView.init();
            this.editform.init(this.dom);
            if (this.options.comboDataSource)
                this.setComboDataSource(this.options.comboDataSource);
        },
        /**
         * 设置界面项目
         */
        setParaItem: function(paraItem) {
            var drugItem;
            this.paraItem = paraItem;
            this.editform.setParaItem(paraItem);
            if (paraItem.categoryItemObj) drugItem = paraItem.categoryItemObj.drugItem;
            if (drugItem) {
                this.editform.setDefaultValues({
                    DoseQty: drugItem.DoseQty,
                    DoseUnit: drugItem.DoseUnit,
                    Speed: drugItem.Speed,
                    SpeedUnit: drugItem.SpeedUnit,
                    Concentration: drugItem.Concentration,
                    ConcentrationUnit: drugItem.ConcentrationUnit,
                    Instruction: drugItem.Instruction,
                    Duration: drugItem.Duration || paraItem.Duration,
					Reason:drugItem.Reason
                });
            }
            this.dom.dialog("setTitle", paraItem.Description);
        },
        /**
         * 设置选项数据
         */
        setComboDataSource: function(dataList) {
            this.editform.setComboDataSource(dataList);
        },
        /**
         * 加载数据
         * @param {object} data
         */
        loadData: function(data) {
            if (data && data.DrugData) this.originalData = data;
            this.editform.loadData(data);
        },
        setTimeLimit: function(timeLimit) {
            this.timeLimit = timeLimit;
        },
        /**
         * 清空表单项
         */
        clear: function() {
            this.editform.clear();
            this.editform.close();
            this.originalData = null;
        },
        /**
         * 打开编辑框
         */
        open: function() {
            this.dom.dialog('open');
            this.addingDrugView.setZIndex(this.dom.parent().css('z-index'));
        },
        /**
         * 关闭
         */
        close: function() {
            this.dom.dialog('close');
            this.editform.close();
        },
        /**
         * 保存
         */
        save: function() {
            var savingDatas = [];
            var preparedDatas = [];
            var newData = this.editform.toData();
            var originalData = this.originalData;
            if (originalData) {
                if (isAnaDataEqual(newData, originalData)) return;
                $.extend(originalData, { EditFlag: 'D' });
                $.extend(newData, {
                    FromData: originalData.RowId,
                    ParaItem: originalData.ParaItem
                });
                savingDatas.push({ RowId: originalData.RowId, EditFlag: 'D' });
            } else {
                $.extend(newData, {
                    FromData: '',
                    ParaItem: this.paraItem.RowId
                })
            }
            if (!this.validate(newData)) return;
            savingDatas.push(newData);
            prepareSavingDatas();
            if (this.saveHandler) this.saveHandler(preparedDatas);
            this.close();

            function prepareSavingDatas() {
                var anaDataClassName = ANCLS.Model.AnaData;
                var drugDataClassName = ANCLS.Model.DrugData;
                var userId = session.UserID;
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
                    CategoryItem: newData.CategoryItem,
                    DataItem: newData.DataItem,
                    DataItemDesc: newData.DataItemDesc || "",
                    ItemCategory: newData.ItemCategory,
                    Continuous: newData.Continuous,
                    FromData: "",
                    CategoryItem: newData.CategoryItem,
                    DataItem: newData.DataItem,
                    DataItemDesc: newData.DataItemDesc,
                    ItemCategory: newData.ItemCategory
                }, {
                    Guid: guid,
                    ClassName: anaDataClassName,
                    CreateUserID: userId
                }));
                $.each(newData.DrugDataList, function(i, drugData) {
                    preparedDatas.push($.extend({}, drugData, {
                        AnaDataGuid: guid,
                        RowId: '',
                        ClassName: drugDataClassName,
                        target: ''
                    }))
                });
            }
        },
        validate: function(data) {
            var _this = this;
            if (data.StartDT > data.EndDT) {
                $.messager.alert('错误', '结束时间不能小于开始时间', 'error', function() {
                    _this.editform.EndDT.datetimebox('focus');
                });
                return false;
            }

            if (this.timeLimit && this.timeLimit.start &&
                this.timeLimit.start instanceof Date &&
                data.StartDT < this.timeLimit.start) {
                $.messager.alert('错误', '数据开始时间不能小于页面开始时间<b style="color:red;">' + this.timeLimit.start.format('yyyy-MM-dd HH:mm:ss') + '</b>', 'error', function() {
                    _this.editform.StartDT.datetimebox('focus');
                });
                return false;
            }
            return true;
        }
    }

    var editform = {
        init: function(container) {
            var _this = this;
            this.canChangeCategoryItem = true;
            this.dataview = dataview;
            this.categoryItemSelectionView = categoryItemSelectionView;
            this.categoryItemSelectionView.init(function(categoryItem) {
                _this.setCategoryItem(categoryItem);
            });
            this.arcimSelectionView = arcimSelectionView;
            this.arcimSelectionView.init(function(arcimItem) {
                _this.setArcimItem(arcimItem);
            });

            this.dom = $('<form class="drugeditor-editview-form"></form>').appendTo(container);
            this.dom.form({});

            this.AnaDataRowId = $('<input type="hidden" name="RowId">').appendTo(this.dom);
            this.ParaItemRowId = $('<input type="hidden" name="ParaItem">').appendTo(this.dom);
            this.DrugDataRowId = $('<input type="hidden" name="DrugDataRowId">').appendTo(this.dom);

            var itemRow = $('<div class="drugeditor-editview-f-r"><div class="label">药品项：</div></div>').appendTo(this.dom);
            this.CategoryItem = $('<span class="drugeditor-editview-drugitem" style="width:164px;"></span>').appendTo(itemRow);
            this.CategoryItemRowId = $('<input type="hidden" name="CategoryItem">').appendTo(itemRow);
            this.DataItemRowId = $('<input type="hidden" name="DataItem">').appendTo(itemRow);
            this.UserDefinedItemRowId = $('<input type="hidden" name="UserDefinedItem">').appendTo(itemRow);
            this.CategoryItemButton = $('<span class="drugeditor-editview-drugitem" style="width:24px;margin-left:3px;"><span class="icon icon-template" style="margin-top:7px;margin-left:2px;"></span></span>').appendTo(itemRow);

            var itemRow = $('<div class="drugeditor-editview-f-r"><div class="label">医嘱项：</div></div>').appendTo(this.dom);
            this.ArcimItem = $('<span class="drugeditor-editview-drugitem" style="width:164px;"></span>').appendTo(itemRow);
            this.ArcimID = $('<input type="hidden" name="ArcimID">').appendTo(itemRow);
            this.ArcimItemButton = $('<span class="drugeditor-editview-drugitem" style="width:24px;margin-left:3px;"><span class="icon icon-template" style="margin-top:7px;margin-left:2px;"></span></span>').appendTo(itemRow);

            this.CategoryItemButton.click(function() {
                if (_this.canChangeCategoryItem) {
                    _this.categoryItemSelectionView.position($(_this.CategoryItem).offset());
                    _this.categoryItemSelectionView.open();
                    $(this).addClass('drugeditor-editview-drugitem-selected');
                }
            });

            this.CategoryItem.click(function() {
                if (_this.canChangeCategoryItem) {
                    _this.categoryItemSelectionView.position($(this).offset());
                    _this.categoryItemSelectionView.open();
                    $(this).addClass('drugeditor-editview-drugitem-selected');
                }
            });

            this.ArcimItemButton.click(function() {
                if (_this.arcimSelectionView) {
                    _this.arcimSelectionView.position($(_this.ArcimItem).offset());
                    _this.arcimSelectionView.open();
                    $(this).addClass('drugeditor-editview-drugitem-selected');
                }
            });

            this.ArcimItem.click(function() {
                if (_this.arcimSelectionView) {
                    _this.arcimSelectionView.position($(this).offset());
                    _this.arcimSelectionView.open();
                    $(this).addClass('drugeditor-editview-drugitem-selected');
                }
            });

            var itemRow = $('<div class="drugeditor-editview-f-r"></div>').appendTo(this.dom);
            var label = $('<label class="label" for="drugeditor_continuous">持续：</label>').appendTo(itemRow);
            this.Continuous = $('<input id="drugeditor_continuous" type="checkbox" name="Continuous">').appendTo(itemRow);
            this.Continuous.checkbox({
                onChecked: function(e, value) {
                    _this.EndDT.datetimebox('enable');
                    // _this.EndDT.datetimebox('setValue', '9999-12-31 00:00');
                    _this.EndDT.datetimebox('setValue', '');

                    _this.Speed.validatebox('enable');
                    _this.SpeedUnit.combobox('enable');
                },
                onUnchecked: function(e, value) {
                    _this.EndDT.datetimebox('disable');
                    _this.EndDT.datetimebox('setValue', _this.StartDT.datetimebox('getValue'));

                    _this.Speed.validatebox('disable');
                    _this.SpeedUnit.combobox('disable');
                }
            });

            //var itemRow = $('<div class="drugeditor-editview-f-r"></div>').appendTo(this.dom);
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

            var timeRow = $('<div class="drugeditor-editview-f-r"></div>').appendTo(this.dom);
            var label = $('<div class="label">开始时间：</div>').appendTo(timeRow);
            this.StartDT = $('<input type="text">').appendTo(timeRow);
            this.StartDT.datetimebox({
                required: true,
                width: 200,
                label: label,
                onChange: function(newValue, oldValue) {
                    if (!_this.Continuous.checkbox('getValue')) {
                        _this.EndDT.datetimebox('setValue', newValue);
                    }
                }
            });
            this.StartDT.datetimebox('initiateWheelListener');
            this.StartDT.datetimebox('initiateKeyUpListener');

            var timeRow = $('<div class="drugeditor-editview-f-r"></div>').appendTo(this.dom);
            var label = $('<div class="label">结束时间：</div>').appendTo(timeRow);
            this.EndDT = $('<input type="text">').appendTo(timeRow);
            this.EndDT.datetimebox({
                width: 200,
                disabled: true,
                label: label
            });
            this.EndDT.datetimebox('initiateWheelListener');
            this.EndDT.datetimebox('initiateKeyUpListener');

            var doseRow = $('<div class="drugeditor-editview-f-r"></div>').appendTo(this.dom);
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

            var speedRow = $('<div class="drugeditor-editview-f-r"></div>').appendTo(this.dom);
            var label = $('<div class="label">速度：</div>').appendTo(speedRow);
            this.Speed = $('<input class="textbox" type="text" disabled style="width:93px;margin-right:5px;">').appendTo(speedRow);
            this.SpeedUnit = $('<input type="text">').appendTo(speedRow);
            this.Speed.validatebox({
                width: 100,
                label: label,
                disabled: true,
                novalidate: true
            });
            this.SpeedUnit.combobox({
                width: 95,
                disabled: true,
                valueField: "RowId",
                textField: "Description",
                cls: 'drugeditor-editview-f-r-unit'
            });

            var concentrationRow = $('<div class="drugeditor-editview-f-r"></div>').appendTo(this.dom);
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

            var instructionRow = $('<div class="drugeditor-editview-f-r"></div>').appendTo(this.dom);
            var label = $('<div class="label">用药途径：</div>').appendTo(instructionRow);
            this.Instruction = $('<input type="text">').appendTo(instructionRow);
            this.Instruction.combobox({
                width: 200,
                valueField: "RowId",
                textField: "Description",
                label: label
            });

            var reasonRow = $('<div class="drugeditor-editview-f-r"></div>').appendTo(this.dom);
            var label = $('<div class="label">原因：</div>').appendTo(reasonRow);
            this.Reason = $('<input type="text">').appendTo(reasonRow);
            this.Reason.combobox({
                width: 200,
                valueField: "RowId",
                textField: "Description",
                label: label
            });

            var receiveLocRow = $('<div class="drugeditor-editview-f-r" style="display:none;"></div>').appendTo(this.dom);
            var label = $('<div class="label">接收科室：</div>').appendTo(receiveLocRow);
            this.RecvLoc = $('<input type="text">').appendTo(receiveLocRow);
            this.RecvLoc.combobox({
                width: 200,
                valueField: "Id",
                textField: "Desc",
                label: label
            });

            var row = $('<div class="drugeditor-editview-f-r"></div>').appendTo(this.dom);
            var label = $('<div class="label">输液部位：</div>').appendTo(row);
            this.InjectionSite = $('<input type="text">').appendTo(row);
            this.InjectionSite.combobox({
                width: 200,
                valueField: "RowId",
                textField: "Description",
                label: label
            });

            // 液体中加药
            this.addingDrugView = addingDrugView;
            this.addingDrugView.setCallback(function(drugData) {
                if (this.originalData === drugData) _this.editDrugData(drugData);
                else _this.addDrugData(drugData);
            });

            this.addingDrugRow = $('<div class="drugeditor-editview-f-r" style="display:none;"></div>').appendTo(this.dom);
            var label = $('<div class="label">输液加药：</div>').appendTo(this.addingDrugRow);
            var container = $('<div class="intrmidrugeditor-f-r-container"></div>').appendTo(this.addingDrugRow);
            this.DrugDataContainer = $('<div class="intrmidrugeditor-data-container" style="width:180px;"></div>').appendTo(container);
            $('<a href="javascript:;" class="drugdata-i-add" title="增加用药">+</a>')
                .click(function() {
                    _this.addingDrugView.position($(this).offset());
                    _this.addingDrugView.open();
                })
                .appendTo(container);

            this.DrugDataContainer.delegate('.drugdata-i-btn-edit', 'click', function() {
                $('.drugdata-i-selected').removeClass('drugdata-i-selected');
                var element = $($(this).parent());
                var data = element.data('data');
                element.addClass('drugdata-i-selected');
                _this.addingDrugView.render(data);
                _this.addingDrugView.position($(this).parent().offset());
                _this.addingDrugView.open();
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
        addDrugData: function(drugData) {
            this.drugDataList.push(drugData);
            this.refreshDataView();
        },
        editDrugData: function(drugData) {
            this.dataview.refreshAppearance(drugData.target, drugData);
        },
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
        loadData: function(data) {
            this.originalData = data;
            this.drugDataList = [];
            var startDT = data.StartDT.format(constant.dateTimeFormat);
            this.StartDT.datetimebox("setValue", startDT);
            if (!this.Continuous.checkbox('getValue')) {
                this.EndDT.datetimebox("setValue", startDT);
            }
            if (this.defaultValueSetting && this.defaultValueSetting.Duration && Number(this.defaultValueSetting.Duration) > 0) {
                this.EndDT.datetimebox("setValue",
                    data.StartDT.addMinutes(Number(this.defaultValueSetting.Duration))
                    .format(constant.dateTimeFormat));
            }
            if (data && data.DrugData) {
                this.drugDataList = [].concat(data.DrugDataList);
                this.drugDataList.splice(0, 1);
                this.refreshDataView();
                //需保证data.DrugData对应的是液体数据，DrugData现在为List中的第一个

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
                this.InjectionSite.combobox("setValue", data.DrugData.InjectionSite || '');
                this.AnaDataRowId.val(data.RowId);
                this.DrugDataRowId.val(data.DrugData.RowId);
                this.Continuous.checkbox('setValue', data.Continuous === 'Y' ? true : false);
                this.TCI.checkbox('setValue', data.DrugData.TCI === 'Y' ? true : false);
                this.CategoryItem.text(data.DrugData.Description);
                this.CategoryItemRowId.val(data.CategoryItem);
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
            this.InjectionSite.combobox('loadData', dataList.InjectionSites || []);
            this.addingDrugView.setComboDataSource(dataList);
        },
        setDefaultValues: function(params) {
            this.defaultValueSetting = params;
            if (params.DoseQty) this.DoseQty.validatebox("setValue", params.DoseQty);
            if (params.DoseUnit) this.DoseUnit.combobox("setValue", params.DoseUnit);
            if (params.Speed) this.Speed.validatebox("setValue", params.Speed);
            if (params.SpeedUnit) this.SpeedUnit.combobox("setValue", params.SpeedUnit);
            if (params.Concentration) this.Concentration.validatebox("setValue", params.Concentration);
            if (params.ConcentrationUnit) this.ConcentrationUnit.combobox("setValue", params.ConcentrationUnit);
            if (params.Instruction && !this.Instruction.combobox("getValue")) this.Instruction.combobox("setValue", params.Instruction);
            if (params.Duration && Number(params.Duration) > 0) {
                this.Continuous.checkbox('setValue', true);
            }
			if (params.Reason && !this.Reason.combobox("getValue")) this.Reason.combobox("setValue",params.Reason);
        },
        setCategoryItem: function(categoryItem) {
            this.CategoryItem.text(categoryItem.ItemDesc);
            this.CategoryItemRowId.val(categoryItem.RowId);
            this.DataItemRowId.val(categoryItem.DataItem);
            this.arcimSelectionView.render(categoryItem);
            if (categoryItem.arcimItems &&
                categoryItem.arcimItems.length > 0) {
                this.setArcimItem(categoryItem.arcimItems[0]);
            }
        },
        setArcimItem: function(arcimItem) {
            this.ArcimItem.attr('title', arcimItem.ArcimDesc || arcimItem.Description)
                .text(arcimItem.ArcimDesc || arcimItem.Description);
            this.ArcimID.val(arcimItem.ArcimID);
            if (!(this.originalData && this.originalData.DrugData) && arcimItem.DoseQty) {
                this.DoseQty.validatebox("setValue", arcimItem.DoseQty);
            }
            if (!(this.originalData && this.originalData.DrugData) && arcimItem.ANDoseUom) {
                this.DoseUnit.combobox("setValue", arcimItem.ANDoseUom);
            }
            //this.loadReceiveLocation();
        },
        loadReceiveLocation: function() {
            var _this = this;
            var recvLocs = dhccl.getDatas(ANCSP.DataQuery, {
                ClassName: dhccl.bll.admission,
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
        setParaItem: function(paraItem) {
            if (paraItem) {
                if (paraItem.categoryItemObj || paraItem.UserDefinedItem) {
                    this.CategoryItem.text(paraItem.Description);
                    this.CategoryItemRowId.val(paraItem.CategoryItem);
                    this.DataItemRowId.val(paraItem.DataItem);
                    this.UserDefinedItemRowId.val(paraItem.UserDefinedItem);
                    this.canChangeCategoryItem = false;
                    if (paraItem.ConcentrationUnit) this.ConcentrationUnit.combobox('setValue', paraItem.ConcentrationUnit);
                    if (paraItem.Unit) {
                        this.DoseUnit.combobox('setValue', paraItem.Unit);
                        if (this.DoseUnit.combobox('getText') != paraItem.UnitDesc) {
                            this.DoseUnit.combobox('setValue', '');
                        }
                        this.SpeedUnit.combobox('setValue', paraItem.Unit);
                        if (this.SpeedUnit.combobox('getText') != paraItem.UnitDesc) {
                            this.SpeedUnit.combobox('setValue', '');
                        }
                    }
                    if (paraItem.Concentration) this.Concentration.validatebox('setValue', paraItem.Concentration);
                    if (paraItem.Continuous === 'Y') {
                        this.Continuous.checkbox('setValue', true);
                    }
                    if (paraItem.Instruction) {
                        this.Instruction.combobox('setValue', paraItem.Instruction);
                    }
                    //this.arcimSelectionView.render(paraItem.categoryItemObj);
                    if (paraItem.dataCategoryObj &&
                        paraItem.dataCategoryObj.subCategories &&
                        paraItem.dataCategoryObj.subCategories.length > 0) {
                        this.addingDrugRow.show();
                        var categoryItems = [];
                        $.each(paraItem.dataCategoryObj.subCategories, function(i, cat) {
                            categoryItems = categoryItems.concat(cat.items);
                        });
                        this.addingDrugView.setComboDataSource({
                            CategoryItems: categoryItems
                        })
                    }
                    if (paraItem.categoryItemObj) this.arcimSelectionView.render(paraItem.categoryItemObj);
                    if (paraItem.categoryItemObj &&
                        paraItem.categoryItemObj.arcimItems &&
                        paraItem.categoryItemObj.arcimItems.length > 0) {
                        this.setArcimItem(paraItem.categoryItemObj.arcimItems[0]);
                    }
                } else {
                    this.canChangeCategoryItem = true;
                    this.categoryItemSelectionView.render(paraItem.dataCategoryObj);
                }
            }
        },
        close: function() {
            this.addingDrugView.close();
        },
        clear: function() {
            this.originalData = null;
            this.dom.form('clear');
            this.CategoryItem.text('');
            this.ArcimItem.attr('title', '').text('');
            this.Continuous.checkbox('setValue', false);
            $(this.Continuous.parent()).removeClass('checked');
            this.TCI.checkbox('setValue', false);
            $(this.TCI.parent()).removeClass('checked');
            this.EndDT.datetimebox('disable');
            this.addingDrugRow.hide();
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

            startDT = (new Date()).tryParse(startDT, constant.dateTimeFormat);
            endDT = (new Date()).tryParse(endDT, constant.dateTimeFormat);

            var drugData = {
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
                Reason: this.Reason.combobox("getText"),
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
                TCI: this.TCI.checkbox('getValue') ? 'Y' : 'N',
                Description: this.CategoryItem.text(),
                DataItem: this.DataItemRowId.val(),
                UserDefinedItem: this.UserDefinedItemRowId.val()
            };
            var anaData = {
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
                Continuous: this.Continuous.checkbox('getValue') ? 'Y' : 'N',
                CategoryItem: this.CategoryItemRowId.val(),
                DataItem: this.DataItemRowId.val(),
                DataItemDesc: this.CategoryItem.text(),
                ItemCategory: 'D',
                DrugData: drugData,
                DrugDataList: [drugData]
            };

            anaData.DrugDataList = anaData.DrugDataList.concat(this.drugDataList);

            return anaData;
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

            var tipArr = [];
            tipArr.push(data.Description);
            if (Number(data.DoseQty) > 0)
                tipArr.push('剂量：' + data.DoseQty + data.DoseUnitDesc);
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
     * 液体中加药
     */
    var addingDrugView = {
        closed: false,
        init: function() {
            var _this = this;
            this.dom = $('<div class="drugeditor-selectionview"></div>').appendTo('body');
            this.container = $('<div class="drugeditor-selectionview-container" style="width:280px;padding:5px;"></div>').appendTo(this.dom);

            this.form = $('<form class="editview-form"></form>').appendTo(this.container);
            this.form.form({});
            this.close();

            var row = $('<div class="editview-f-r"></div>').appendTo(this.form);
            var label = $('<div class="label">药品项：</div>').appendTo(row);
            this.DataItem = $('<input type="text" name="CategoryItem">').appendTo(row);
            this.DataItem.combobox({
                textField: 'ItemDesc',
                valueField: 'DataItem',
                width: 150,
                label: label,
                required: true
            });

            var row = $('<div class="editview-f-r"></div>').appendTo(this.form);
            var label = $('<div class="label">剂量：</div>').appendTo(row);
            this.DoseQty = $('<input class="textbox" type="text" name="DoseQty" style="width:63px;margin-right:5px;">').appendTo(row);
            this.DoseQty.validatebox({
                width: 70,
                label: label,
                novalidate: true
            });
            this.DoseUnit = $('<input type="text" name="DoseUnit">').appendTo(row);
            this.DoseUnit.combobox({
                textField: 'Description',
                valueField: 'RowId',
                width: 75,
                cls: 'drugeditor-editview-f-r-unit'
            });

            this.bottom = $('<div style="text-align:center;margin-top:10px;"></div>').appendTo(this.container);
            this.btn_ok = $('<a href="#" style="margin-right:10px;"></a>').linkbutton({
                text: '确定',
                iconCls: 'icon-ok',
                onClick: function() {
                    _this.save();
                }
            }).appendTo(this.bottom);
            this.btn_cancel = $('<a href="#"></a>').linkbutton({
                text: '取消',
                iconCls: 'icon-close',
                onClick: function() {
                    _this.close();
                }
            }).appendTo(this.bottom);

            return this;
        },
        setZIndex: function(zIndex) {
            this.dom.css('z-index', Number(zIndex) + 1);
            this.DataItem.data('combo').panel.css('z-index', Number(zIndex) + 2);
        },
        setCallback: function(callback) {
            this.callback = callback;
        },
        setComboDataSource: function(dataList) {
            if (dataList && dataList.DoseUnits) this.DoseUnit.combobox('loadData', dataList.DoseUnits);
            if (dataList && dataList.CategoryItems) this.DataItem.combobox('loadData', dataList.CategoryItems);
        },
        /**
         * 渲染
         */
        render: function(drugData) {
            this.originalData = drugData;

            this.DataItem.combobox('setValue', drugData.DataItem);
            this.DoseQty.validatebox('setValue', drugData.DoseQty);
            this.DoseUnit.combobox('setValue', drugData.DoseUnit);
            return this;
        },
        save: function() {
            var data = {
                DataItem: this.DataItem.combobox('getValue'),
                Description: this.DataItem.combobox('getText'),
                DoseQty: this.DoseQty.validatebox('getValue'),
                DoseUnit: this.DoseUnit.combobox('getValue'),
                DoseUnitDesc: this.DoseUnit.combobox('getText'),
            };
            if (this.originalData) {
                data = $.extend(this.originalData, data);
            }
            if (this.callback) this.callback(data);
            this.close();
        },
        /**
         * 打开项目属性编辑框
         */
        open: function() {
            this.dom.show();
            this.closed = false;
            return this;
        },
        /**
         * 关闭项目属性编辑框
         */
        close: function() {
            this.dom.hide();
            this.closed = true;
            this.clear();
            return this;
        },
        clear: function() {
            this.form.form('clear');
            this.originalData = null;
        },
        position: function(position) {
            this.dom.css({
                left: position.left + 180,
                top: position.top - 20
            });
            return this;
        }
    }

    /**
     * 药品项选择
     */
    var categoryItemSelectionView = {
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
                _this.filter();
            });

            this.header.delegate('input', 'keyup', function(e) {
                if (e.keyCode == 13) {
                    var text = $(this).val();
                    _this.filter(text);
                }
            });

            this.itemContainer = $('<div class="drugeditor-selectionview-items"></div>').appendTo(this.container);

            this.dom.delegate('.categoryitem-button', 'click', function() {
                var callback = _this.callback;
                if (callback) callback($(this).data('data'));
                _this.close();
            });

            return this;
        },
        setCallback: function(callback) {
            this.callback = callback;
        },
        /**
         * 渲染
         */
        render: function(dataCategory) {
            this.items = [];
            var items = [];
            var container = this.itemContainer;
            container.empty();
            $.each(dataCategory.items || [], function(index, categoryItem) {
                var element = null;
                element = $('<a href="#" class="categoryitem-button"></a>').text(categoryItem.ItemDesc).appendTo(container);
                element.data('data', categoryItem);
                categoryItem.target = element;
                items.push(categoryItem);
            });
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

            this.header = $('<div class="drugeditor-selectionview-header"></div>').appendTo(this.container);
            var searchBox = $('<input type="text">').appendTo(this.header);
            searchBox.searchbox({
                width: 190,
                prompt: '输入简拼或汉字检索',
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

            this.header.delegate('input', 'keyup', function(e) {
                if (e.keyCode == 13) {
                    var text = $(this).val();
                    _this.filter(text);
                }
            })

            this.itemContainer = $('<div class="drugeditor-selectionview-items"></div>').appendTo(this.container);

            this.dom.delegate('.drug-button', 'click', function() {
                var callback = _this.callback;
                if (callback) callback($(this).data('data'));
            });
        },
        render: function(categoryItem) {
            this.arcimItems = categoryItem.arcimItems || [];
            this.renderItems(this.arcimItems);
        },
        renderItems: function(arcimItems) {
            var container = this.itemContainer;
            container.empty();
            $.each(arcimItems, function(index, arcimItem) {
                var element = null;
                element = $('<a href="#" class="drug-button"></a>')
                    .text(arcimItem.ArcimDesc || arcimItem.Description)
                    .attr('title', arcimItem.ArcimDesc || arcimItem.Description)
                    .appendTo(container);
                element.data('data', arcimItem);
            });
        },
        filter: function(filterString) {
            var _this = this;
            // if (filterString === '') {
            //     this.renderItems(this.drugItems);
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
        position: function(position) {
            this.dom.css({ left: position.left, top: position.top + 35 });
        },
        /**
         * 打开药品选择框
         */
        open: function() {
            this.dom.show();
            this.closed = false;
        },
        /**
         * 关闭药品选择框
         */
        close: function() {
            this.dom.hide();
            this.closed = true;
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
        var fields = ['StartDate', 'EndDate', 'StartTime', 'EndTime', 'CategoryItem',
            'UserDefinedItem', 'Continuous'
        ];
        return isEqual(fields, newData, oldData) && isDrugDataEqual(newData, oldData);
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
            'ArcimID', 'DataItem'
        ];
        return isEqual(fields, newData.DrugData, oldData.DrugData);
    }

    return exports;
}));