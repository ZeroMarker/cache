/**
 * 成组用药数据编辑
 * 初始化的时候才创建并储存一个实例
 * @author yongyang 20180620
 */

(function(global, factory) {
    if (!global.DrugGroupEditor) factory(global.DrugGroupEditor = {});
}(this, function(exports) {

    exports.init = function(opt) {
        exports.instance = new DrugGroupEditor(opt);
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
    function DrugGroupEditor(opt) {
        this.options = $.extend(opt, {
            width: 360,
            height: 400
        });
        this.saveHandler = opt.saveHandler;
        this.editform = editform;
        this.init();
    }

    DrugGroupEditor.prototype = {
        init: function() {
            var _this = this;
            this.dom = $('<div></div>').appendTo('body');
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

            this.initForm();
            this.dom.dialog({
                left: 300,
                top: 150,
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
            this.editform.init(this.dom);
        },
        /**
         * 设置界面项目
         */
        setParaItem: function(paraItem) {
            this.paraItem = paraItem;
            this.editform.setParaItem(paraItem);
            this.dom.dialog("setTitle", "药品——" + paraItem.Description);
            if (this.options.comboDataSource)
                this.setComboDataSource(this.options.comboDataSource);
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
        /**
         * 清空表单项
         */
        clear: function() {
            this.editform.clear();
            this.originalData = null;
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
                    ParaItem: originalData.ParaItem,
                    CategoryItem: originalData.CategoryItem,
                    DataItem: originalData.DataItem,
                    DataItemDesc: originalData.DataItemDesc,
                    ItemCategory: originalData.ItemCategory
                });
                savingDatas.push(originalData);
            } else {
                $.extend(newData, {
                    FromData: '',
                    ParaItem: this.paraItem.RowId,
                    CategoryItem: this.paraItem.CategoryItem,
                    DataItem: this.paraItem.DataItem,
                    DataItemDesc: this.paraItem.DataItemDesc,
                    ItemCategory: this.paraItem.ItemCategory
                })
            }
            savingDatas.push(newData);
            prepareSavingDatas();
            this.saveHandler(preparedDatas);

            function prepareSavingDatas() {
                var anaDataClassName = ANCLS.Model.AnaData;
                var drugDataClassName = ANCLS.Model.DrugData;
                $.each(savingDatas, function(i, data) {
                    var guid = dhccl.guid();
                    preparedDatas.push($.extend(data, {
                        Guid: guid,
                        ClassName: anaDataClassName
                    }));
                    if (data.DrugDataList && data.DrugDataList.length > 0) {
                        $.each(data.DrugDataList, function(j, drugData) {
                            preparedDatas.push($.extend(drugData, {
                                AnaDataGuid: guid,
                                ClassName: drugDataClassName
                            }))
                        });
                    }
                });
            }
        }
    }

    var editform = {
        init: function(container) {
            var _this = this;
            this.drugItemSelectionView = drugItemSelectionView;
            this.drugItemSelectionView.init(function(drugItem) {
                _this.setDrugItem(drugItem);
            });

            this.dom = $('<form class="editview-form"></form>').appendTo(container);
            this.dom.form({});

            this.AnaDataRowId = $('<input type="hidden" name="RowId">').appendTo(this.dom);
            this.ParaItemRowId = $('<input type="hidden" name="ParaItem">').appendTo(this.dom);

            var timeRow = $('<div class="editview-f-r"></div>').appendTo(this.dom);
            var label = $('<span class="label">开始时间：</span>').appendTo(timeRow);
            this.StartDT = $('<input type="text">').appendTo(timeRow);
            this.StartDT.datetimebox({
                required: true,
                width: 260,
                label: label,
                onChange: function(newValue, oldValue) {}
            });

            var timeRow = $('<div class="editview-f-r"></div>').appendTo(this.dom);
            var label = $('<span class="label">结束时间：</span>').appendTo(timeRow);
            this.EndDT = $('<input type="text">').appendTo(timeRow);
            this.EndDT.datetimebox({
                width: 260,
                label: label
            });
            this.drugEditForms = [];
            this.groupContainer = $('<div class="editview-f-group"></div>').appendTo(this.dom);
        },
        loadData: function(data) {
            this.StartDT.datetimebox("setValue", data.StartDT.format(constant.dateTimeFormat));
            if (data && data.DrugData) {
                this.AnaDataRowId.val(data.RowId);
                if (Date.isValidDate(data.EndDT)) {
                    this.EndDT.datetimebox("setValue", data.EndDT.format(constant.dateTimeFormat));
                }

                var drugDataList = data.DrugDataList;
                var length = this.drugEditForms.length;
                var drugDataLength = drugDataList.length;
                for (var i = 0; i < length; i++) {
                    var drugForm = this.drugEditForms[i];
                    for (var j = 0; j < drugDataLength; j++) {
                        if (drugDataList[j].ArcimID === drugForm.drugGroupItem.ArcimID) {
                            drugForm.loadData(drugDataList[j]);
                            break;
                        }
                    }
                }
            }
        },
        setComboDataSource: function(dataList) {
            $.each(this.drugEditForms, function(index, drugForm) {
                drugForm.setComboDataSource(dataList);
            });
        },
        setParaItem: function(paraItem) {
            if (paraItem && paraItem.categoryItemObj && paraItem.categoryItemObj.drugGroup) {
                this.drugGroup = paraItem.categoryItemObj.drugGroup;
                this.drugEditForms = [];
                var length = this.drugGroup.items.length;
                for (var i = 0; i < length; i++) {
                    var itemEditForm = new DrugForm(this.groupContainer, this.drugGroup.items[i]);
                    this.drugEditForms.push(itemEditForm);
                }
            }
        },
        clear: function() {
            this.dom.form('clear');
            this.groupContainer.empty();
            this.drugEditForms = [];
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

            var drugDataList = [];

            $.each(this.drugEditForms, function(index, drugForm) {
                drugDataList.push(drugForm.toData());
            })

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
                DrugDataList: drugDataList
            }
        }
    }

    /**
     * 用药数据表单
     */
    function DrugForm(container, drugGroupItem) {
        this.container = container;
        this.drugGroupItem = drugGroupItem;
        this.init();
        this.setDrugItem({
            RowId: drugGroupItem.ArcimID,
            Description: drugGroupItem.ArcimDesc
        })
    }

    DrugForm.prototype = {
        init: function() {
            var _this = this;
            this.groupItemContainer = $('<div class="editview-f-group-i"></div>').appendTo(this.container);
            this.dom = $('<form class="editview-form"></form>').appendTo(this.groupItemContainer);
            this.dom.form({});

            this.DrugDataRowId = $('<input type="hidden" name="DrugDataRowId">').appendTo(this.dom);

            var itemRow = $('<div class="editview-f-group-i-header"></div>').appendTo(this.dom);
            var collapseBtn = $('<a href="javascript:;" class="editview-f-group-i-tool panel-tool-collapse"></a>').click(function() {
                _this.groupItemContainer.toggleClass("editview-f-group-i-collapsed");
                _this.refreshDrugInfo();
                $(this).toggleClass("panel-tool-collapse");
                $(this).toggleClass("panel-tool-expand");
            }).appendTo(itemRow);
            this.DrugItem = $('<span class="editview-drugitem"></span>').appendTo(itemRow);
            this.DrugInfo = $('<span class="editview-druginfo"></span>').appendTo(itemRow);
            this.DrugItemID = $('<input type="hidden" name="DrugItem">').appendTo(itemRow);
            this.ArcimID = $('<input type="hidden" name="ArcimID">').appendTo(itemRow);
            this.DrugItemDesc = $('<input type="hidden" name="DrugItemDesc">').appendTo(itemRow);

            var doseRow = $('<div class="editview-f-r"></div>').appendTo(this.dom);
            var label = $('<div class="label">剂量：</div>').appendTo(doseRow);
            this.DoseQty = $('<input type="text">').appendTo(doseRow);
            this.DoseUnit = $('<input type="text">').appendTo(doseRow);
            this.DoseQty.validatebox({
                width: 160,
                label: label,
                novalidate: true
            });
            this.DoseUnit.combobox({
                width: 95,
                valueField: "RowId",
                textField: "Description",
                cls: 'editview-f-r-unit'
            });

            var speedRow = $('<div class="editview-f-r"></div>').appendTo(this.dom);
            var label = $('<div class="label">速度：</div>').appendTo(speedRow);
            this.Speed = $('<input type="text">').appendTo(speedRow);
            this.SpeedUnit = $('<input type="text">').appendTo(speedRow);
            this.Speed.validatebox({
                width: 160,
                label: label,
                novalidate: true
            });
            this.SpeedUnit.combobox({
                width: 95,
                valueField: "RowId",
                textField: "Description",
                cls: 'editview-f-r-unit'
            });

            var concentrationRow = $('<div class="editview-f-r"></div>').appendTo(this.dom);
            var label = $('<div class="label">浓度：</div>').appendTo(concentrationRow);
            this.Concentration = $('<input type="text">').appendTo(concentrationRow);
            this.ConcentrationUnit = $('<input type="text">').appendTo(concentrationRow);
            this.Concentration.validatebox({
                width: 160,
                label: label,
                novalidate: true
            });
            this.ConcentrationUnit.combobox({
                width: 95,
                valueField: "RowId",
                textField: "Description",
                cls: 'editview-f-r-unit'
            });

            var instructionRow = $('<div class="editview-f-r"></div>').appendTo(this.dom);
            var label = $('<div class="label">用药途径：</div>').appendTo(instructionRow);
            this.Instruction = $('<input type="text">').appendTo(instructionRow);
            this.Instruction.combobox({
                width: 260,
                valueField: "RowId",
                textField: "Description",
                label: label
            });

            var reasonRow = $('<div class="editview-f-r"></div>').appendTo(this.dom);
            var label = $('<div class="label">原因：</div>').appendTo(reasonRow);
            this.Reason = $('<input type="text">').appendTo(reasonRow);
            this.Reason.combobox({
                width: 260,
                valueField: "RowId",
                textField: "Description",
                label: label
            });

            var receiveLocRow = $('<div class="editview-f-r"></div>').appendTo(this.dom);
            var label = $('<div class="label">接收科室：</div>').appendTo(receiveLocRow);
            this.RecvLoc = $('<input type="text">').appendTo(receiveLocRow);
            this.RecvLoc.combobox({
                width: 260,
                valueField: "Id",
                textField: "Desc",
                label: label
            });
        },
        loadData: function(drugData) {
            if (drugData) {
                this.originalData = drugData;
                this.Speed.validatebox("setValue", drugData.Speed);
                this.ArcimID.val(drugData.ArcimID);
                this.DrugItem.text(drugData.ArcimDesc);
                this.RecvLoc.combobox("setValue", drugData.RecvLoc);
                this.RecvLoc.combobox("setText", drugData.RecvLocDesc);
                this.DoseQty.validatebox("setValue", drugData.DoseQty);
                this.DoseUnit.combobox("setValue", drugData.DoseUnit);
                this.Speed.validatebox("setText", drugData.Speed);
                this.SpeedUnit.combobox("setValue", drugData.SpeedUnit);
                this.Concentration.validatebox("setValue", drugData.Concentration);
                this.ConcentrationUnit.combobox("setValue", drugData.ConcentrationUnit);
                this.Instruction.combobox("setValue", drugData.Instruction);
                this.Reason.combobox("setText", drugData.Reason);
                this.DrugDataRowId.val(drugData.RowId);
            }
        },
        setComboDataSource: function(dataList) {
            this.DoseUnit.combobox('loadData', dataList.DoseUnits || []);
            this.SpeedUnit.combobox('loadData', dataList.SpeedUnits || []);
            this.ConcentrationUnit.combobox('loadData', dataList.ConcentrationUnits || []);
            this.Instruction.combobox('loadData', dataList.Instructions || []);
            this.Reason.combobox('loadData', dataList.Reasons || []);
        },
        setDrugItem: function(drugItem) {
            this.DrugItem.text(drugItem.Description);
            this.DrugItemID.val(drugItem.RowId);
            this.ArcimID.val(drugItem.RowId);
            this.loadReceiveLocation();
        },
        refreshDrugInfo: function() {
            var DoseQty = this.DoseQty.validatebox("getValue"),
                DoseUnit = this.DoseUnit.combobox("getText"),
                Instruction = this.Instruction.combobox("getText"),
                Concentration = this.Concentration.validatebox("getText"),
                ConcentrationUnit = this.ConcentrationUnit.combobox("getText"),
                Speed = this.Speed.validatebox("getValue"),
                SpeedUnit = this.SpeedUnit.combobox("getText");
            var drugInfo = (DoseQty ? (DoseQty + DoseUnit) : '') +
                (Concentration ? (Concentration + ConcentrationUnit) : '') +
                (Speed ? (Speed + SpeedUnit) : '') +
                ' ' + Instruction;
            this.DrugInfo.text(drugInfo);
        },
        loadReceiveLocation: function() {
            var _this = this;
            dhccl.getDatas(ANCSP.DataQuery, {
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
        setParaItem: function(paraItem) {
            if (paraItem && paraItem.categoryItem)
                this.drugItemSelectionView.render(paraItem.categoryItem);
        },
        collapse: function() {

        },
        expand: function() {

        },
        clear: function() {
            this.dom.form('clear');
            this.DrugItem.text('');
        },
        toData: function() {
            return {
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
                Reason: "",
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
            }
        }
    }

    var drugItemSelectionView = {
        closed: false,
        init: function(callback) {
            var _this = this;
            this.callback = callback;
            this.dom = $('<div class="drugeditor-selectionview"></div>').appendTo('body');
            this.container = $('<div class="drugeditor-selectionview"></div>').appendTo(this.dom);
            this.close();

            this.dom.mouseleave(function() {
                _this.close();
            });

            this.header = $('<div class="drugeditor-selectionview-header"></div>').appendTo(this.container);
            var searchBox = $('<input type="text">').appendTo(this.header);
            searchBox.validatebox({
                width: 190,
                novalidate: true,
                prompt: '输入简拼或汉字检索',
                buttonIcon: 'icon-search',
                buttonAlign: 'right',
                onClickButton: function(index) {
                    var text = $(this).validatebox('getText');
                    _this.filter(text);
                }
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
            this.drugItems = [];
            if (!categoryItem.DataItem) return;
            this.drugItems = categoryItem.DataItem.DrugItems || [];
            this.renderItems(drugItems);
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
        position: function(position) {
            this.dom.css({ left: position.left + 180, top: position.top - 10 });
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
        var fields = ['StartDate', 'EndDate', 'StartTime', 'EndTime', ];
        return isEqual(fields, newData, oldData) && isDrugDataListEqual(newData.DrugDataList, oldData.DrugDataList);
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
        return isEqual(fields, newData.DrugData, oldData.DrugData);
    }

    /**
     * 判断两个药品数据是否相等
     * @param {Array<Model.DrugData>} newDataArray
     * @param {Array<Model.DrugData>} oldDataArray
     */
    function isDrugDataListEqual(newDataArray, oldDataArray) {
        if ((newDataArray || []).length != (oldDataArray || []).length) return false;
        var length = newDataArray.length;
        for (var i = 0; i < length; i++) {
            if (!isDrugDataEqual(fields, newDataArray[i], oldDataArray[i]))
                return false;
        }

        return true;
    }

    return exports;
}))