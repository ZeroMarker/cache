/**
 * 快捷用药数据编辑,仅考虑新增，剂量-单位/速度-单位录入，其它取默认值
 * 初始化的时候才创建并储存一个实例
 * @author yongyang 20200908
 */

(function(global, factory) {
    if (!global.SimplifiedDrugEditor) factory(global.SimplifiedDrugEditor = {});
}(this, function(exports) {

    exports.init = function(opt) {
        exports.instance = new SimplifiedDrugEditor(opt);
        return exports.instance;
    }

    exports.open = function() {
        if (exports.instance) exports.instance.open();
        else {
            $.messager.alert('错误', '快捷用药数据编辑界面未初始化', 'icon-error');
        }
    }

    exports.instance = null;

    /**
     * 快捷用药数据编辑界面
     * @param {object} opt 
     */
    function SimplifiedDrugEditor(opt) {
        this.options = $.extend(opt, {
            width: 320,
            height: 500
        });
        this.saveHandler = opt.saveHandler;
        this.init();
    }

    SimplifiedDrugEditor.prototype = {
        init: function() {
            var _this = this;
            this.dom = $('<div style="position:absolute;top:0;left:0;"></div>').appendTo('body');
            this.toolkit = $('<div></div>').appendTo(this.dom);

            this.initForm();
            this.initiated = true;
        },
        initForm: function() {
            var form = $('<form></form>').appendTo(this.dom);
            this.editform = form;
            this.AnaDataRowId = $('<input type="hidden" name="RowId">').appendTo(form);
            this.ParaItemRowId = $('<input type="hidden" name="ParaItem">').appendTo(form);
            this.DrugDataRowId = $('<input type="hidden" name="DrugDataRowId">').appendTo(form);

            var row = $('<div class="sde-form-r"></div>').appendTo(form);
            this.TextQty = $('<input class="textbox" type="text" name="Qty" style="width:40px;border:none;">').appendTo(row);
            this.TextQty.validatebox({
                width: 40,
                novalidate: true
            });

            this.Unit = $('<input class="textbox" type="text" name="Unit" readonly style="width:50px;border-radius:5px;">').appendTo(row);
            this.Unit.validatebox({
                width: 100,
                novalidate: true,
                readonly: true
            });
        },
        /**
         * 选项区域，分为三块：用户偏好数据；单位；速度单位
         */
        initSelectionView: function() {
            var selectionContainer = $('<div style="overflow:hidden;"></div>').appendTo(this.dom);

            this.userPreferedDataView = $('<div style="float:left;padding:5px;width:120px;">').appendTo(selectionContainer);
            this.doseUomView = $('<div style="float:left;padding:5px;width:20px;border-left:1px solid #eee;">').appendTo(selectionContainer);
            this.speedUomView = $('<div style="float:left;padding:5px;width:50px;border-left:1px solid #eee;">').appendTo(selectionContainer);
        },
        /**
         * 渲染选项区域
         */
        renderSelectionView: function() {

        },
        /**
         * 设置界面项目
         */
        setParaItem: function(paraItem) {
            var drugItem;
            this.paraItem = paraItem;
            if (paraItem.categoryItemObj) drugItem = paraItem.categoryItemObj.drugItem;
            if (drugItem) {

            }
        },
        /**
         * 设置选项数据
         */
        setComboDataSource: function(dataList) {

        },
        /**
         * 加载数据
         * @param {object} data
         */
        loadData: function(data) {
            this.originalData = null;
            if (data && data.DrugData) {
                this.originalData = data;
            }
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
        open: function(position) {
            this.dom.dialog('open');
        },
        position: function(position) {
            this.dom.css({
                left: position.left,
                top: position.top
            });
            return this;
        },
        /**
         * 关闭
         */
        close: function() {
            this.dom.dialog('close');
            this.editform.close();
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
            return true;
        }
    }
    return exports;
}));