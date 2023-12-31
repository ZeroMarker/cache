//
/**
 * 异常提醒
 * @author yongyang 2020-05-09
 */
(function(global, factory) {
    if (!global.AnaRegView) factory(global.AnaRegView = {});
}(this, function(exports) {

    function init(opt) {
        var view = new AnaRegView(opt);
        exports.instance = view;
        return view;
    }

    exports.init = init;

    function AnaRegView(opt) {
        this.options = $.extend({ width: 1200, height: 600 }, opt);
        this.saveHandler = opt.saveHandler;
        this.init();
    }

    AnaRegView.prototype = {
        constructor: AnaRegView,
        init: function() {
            var _this = this;
            this.dom = $('<div></div>').appendTo('body');
            var buttons = $('<div></div>');
            /*var btn_save = $('<a href="#"></a>').linkbutton({
                text: '启动',
                iconCls: 'icon-save',
                onClick: function() {
                    _this.save();
                    _this.close();
                }
            }).appendTo(buttons);*/
            var btn_cancel = $('<a href="#"></a>').linkbutton({
                text: '关闭',
                iconCls: 'icon-cancel',
                onClick: function() {
                    _this.close();
                }
            }).appendTo(buttons);

            var htmlArr = [
                "<div id='regview' class='hisui-layout' data-options='fit:true'>",
                "<div data-options='region:\"center\",border:false' style='padding:10px;'>",
                "<table id='anaRegBox'></table>",
                "<div id='anaRegTool'>",
                "<form id='anaRegForm'>",
                "<div class='form-row-group' style='padding-top:4px;padding-bottom:5px'>",
                "<div><div class='form-row'>",
                "<div class='form-title-normal' style='padding-right:10px'>模板</div>",
                "<div class='form-item-normal'>",
                "<select id='regTemplate' class='hisui-combobox'></select>",
                "</div>",
                "<div class='form-title-normal' style='padding-right:10px'>时间</div>",
                "<div class='form-item-normal'>",
                "<select id='regview_time' class='hisui-searchbox'></select>",
                "</div>",
                "<span class='form-btn'>",
                "<a href='#' class='hisui-linkbutton' style='display:none' id='btnSaveTemplate'>保存模板</a>",
                "</span>",
                "<span class='form-btn'>",
                "<a href='#' class='hisui-linkbutton' style='display:none' id='btnDelTemplate'>删除模板</a>",
                "</span>",
                "<span class='form-btn'>",
                "<a href='#' class='hisui-linkbutton' id='btnApplyTemplate'>应用模板</a>",
                "</span>",
                "</div></div>",
                "</div>",
                "<div class='form-row-group' style='padding:3px 0;'>",
                "<a href='#' class='hisui-linkbutton' id='btnBatchAddData'>保存数据</a>",
                "<a href='#' class='hisui-linkbutton' id='btnBatchDelData'>批量删除</a>",
                "</div>",
                "</form>",
                "</div>",
                "</div>",
                "<div data-options='region:\"east\",border:false' style='width:260px;padding:10px 10px 10px 0;'>",
                "<div id='operActionTabs' class='hisui-tabs tabs-gray'></div>",
                "</div>",
                "</div>"
            ];

            this.dataContainer = $(htmlArr.join("")).appendTo(this.dom);
            //$.parser.parse(this.dom);
            $("#regview").layout();
            this.dom.dialog({
                right: 200,
                top: 15,
                height: this.options.height,
                width: this.options.width,
                title: '术中登记',
                modal: true,
                closed: true,
                resizable: true,
                iconCls: 'icon-w-msg',
                //buttons: buttons,
                onOpen: function() {
                    //$("#anaRegBox").datagrid("reload");
                },
                onClose: function() {
                    if (_this.options.onClose) _this.options.onClose();
                    _this.clear();
                }
            });

            this.initAnaRegBox();
            this.initOperActions();
        },

        initAnaRegBox: function() {
            var _this = this;
            _this.reg = {};
            var uomOptions = {
                valueField: "RowId",
                textField: "Description",
                data: _this.options.uomList,
                onSelect: function(record) {
                    _this.reg.editData.DoseUnitDesc = record.Description;
                }
            };
            var instructionOptions = {
                valueField: "RowId",
                textField: "Description",
                data: _this.options.instructionList,
                onSelect: function(record) {
                    _this.reg.editData.InstructionDesc = record.Description;
                }
            }
            $("#anaRegBox").datagrid({
                title: "术中登记",
                fit: true,
                headerCls: "panel-header-gray",
                toolbar: "#anaRegTool",
                iconCls: "icon-paper",
                rownumber: true,
                checkOnSelect: true,
                selectOnCheck: true,
                url: ANCSP.DataQuery,
                onBeforeLoad: function(param) {
                    param.ClassName = ANCLS.BLL.AnaestRecord;
                    param.QueryName = "FindEventDrugDatas";
                    param.Arg1 = session.RecordSheetID;
                    param.ArgCnt = 1;
                },
                columns: [
                    [
                        { field: "CheckStatus", title: "选择", checkbox: true },
                        { field: "DataItemDesc", title: "项目", width: 120 },
                        // {field:"StartDT",title:"开始时间",width:170,editor:{type:"datetimebox",options:{showSeconds:false}}},
                        // {field:"EndDT",title:"结束时间",width:170,editor:{type:"datetimebox",options:{showSeconds:false}}},
                        {
                            field: "StartDate",
                            title: "开始日期",
                            width: 120,
                            editor: {
                                type: "datebox",
                                options: {
                                    onChange: function(newValue, oldValue) {
                                        var editingData = _this.reg.editData;
                                        if (editingData.Continuous == 'N') editingData.EndDate = newValue;
                                    }
                                }
                            }
                        },
                        {
                            field: "StartTime",
                            title: "开始时间",
                            width: 80,
                            editor: {
                                type: "timespinner",
                                options: {
                                    showSeconds: true,
                                    onChange: function(newValue, oldValue) {
                                        var editingData = _this.reg.editData;
                                        if (editingData.Continuous == 'N') editingData.EndTime = newValue;
                                    }
                                }
                            }
                        },
                        {
                            field: "EndDate",
                            title: "结束日期",
                            width: 120,
                            editor: {
                                type: "datebox",
                                options: {
                                    options: {
                                        onChange: function(newValue, oldValue) {
                                            var editingData = _this.reg.editData;
                                            if ((newValue == editingData.StartDate) && (editingData.StartTime == editingData.EndTime)) editingData.Continuous = 'N';
                                            else editingData.Continuous = 'Y';
                                        }
                                    }
                                }
                            },
                            formatter: function(value, row, index) {
                                if (row.StartDate === row.EndDate && row.StartTime === row.EndTime) {
                                    return "";
                                }
                                return row.EndDate;
                            }
                        },
                        {
                            field: "EndTime",
                            title: "结束时间",
                            width: 80,
                            editor: {
                                type: "timespinner",
                                options: {
                                    showSeconds: true,
                                    onChange: function(newValue, oldValue) {
                                        var editingData = _this.reg.editData;
                                        if ((editingData.StartDate == editingData.EndDate) && (newValue == editingData.StartTime)) editingData.Continuous = 'N';
                                        else editingData.Continuous = 'Y';
                                    }
                                }
                            },
                            formatter: function(value, row, index) {
                                if (row.StartDate === row.EndDate && row.StartTime === row.EndTime) {
                                    return "";
                                }
                                return row.EndTime;
                            }
                        },
                        { field: "DoseQty", title: "剂量", width: 60, editor: { type: "validatebox" } },
                        {
                            field: "DoseUnit",
                            title: "单位",
                            width: 70,
                            editor: { type: "combobox", options: uomOptions },
                            formatter: function(value, row, index) {
                                return row.DoseUnitDesc;
                            }
                        }, {
                            field: "Instruction",
                            title: "用法",
                            width: 100,
                            editor: { type: "combobox", options: instructionOptions },
                            formatter: function(value, row, index) {
                                return row.InstructionDesc;
                            }
                        },
                        { field: "DataValue", title: "备注", width: 100, editor: { type: "validatebox" } }
                    ]
                ],
                onBeforeEdit: function(rowIndex, rowData) {
                    // var ignoreField=["EndDate","EndTime"];
                    // if(rowData.ItemCategory==="E" && ignoreField.indexOf(_this.reg.field)>=0){
                    //     $("#anaRegBox").datagrid("cancelEdit",rowIndex);
                    //     return false;
                    // }
                    _this.reg.editIndex = rowIndex;
                    _this.reg.editData = rowData;
                    rowData.edited = true;
                },
                onClickCell: function(rowIndex, field, value) {
                    _this.reg.field = field;
                }
            });

            $("#anaRegBox").datagrid("enableCellEditing");

            $("#regTemplate").combobox({
                valueField: "RowId",
                textField: "Description",
                url: ANCSP.DataQuery,
                onBeforeLoad: function(param) {
                    param.ClassName = ANCLS.BLL.ConfigQueries;
                    param.QueryName = "FindModuleTemplate";
                    param.Arg1 = session.DeptID;
                    param.Arg2 = session.UserID;
                    param.Arg3 = session.ModuleID;
                    param.ArgCnt = 3;
                },

                onSelect: function(record) {
                    //$("#anaRegBox").datagrid("reload");
                }
            });

            this.StartDT = this.dom.find('#regview_time');
            this.StartDT.datetimebox({
                width: 180
            });
            this.StartDT.datetimebox('initiateWheelListener');
            this.StartDT.datetimebox('initiateKeyUpListener');

            $("#btnSaveTemplate").linkbutton({
                iconCls: "icon-w-save",
                onClick: function() {
                    var templateId = $("#regTemplate").combobox("getValue");
                    var templateText = $("#regTemplate").combobox("getText");
                    if (!templateId && !templateText) {
                        $.messager.alert("提示", "请输入模板名称再保存。", "warning");
                        return;
                    }

                    var dataRows = $("#anaRegBox").datagrid("getSelections");
                    if (!dataRows || dataRows.length <= 0) {
                        $.messager.alert("提示", "请勾选需要保存到模板的数据后再保存。", "warning");
                        return;
                    }

                    $.messager.confirm("提示", "是否保存模板【" + templateText + "】？", function(r) {
                        if (r) {
                            var tempDatas = [];
                            for (var i = 0; i < dataRows.length; i++) {
                                var dataRow = dataRows[i];
                                tempDatas = tempDatas.concat(_this.genTemplateData(dataRow) || []);
                            }
                            if (tempDatas.length && tempDatas.length > 0) {
                                var tempDataPara = dhccl.formatObjects(tempDatas);
                                var saveRes = dhccl.runServerMethodNormal(ANCLS.BLL.AnaData, "SaveAnaRegTemplate", session.RecordSheetID, templateId, templateText, tempDataPara, session.DeptID, session.UserID);
                                if (saveRes.indexOf("S^") === 0) {
                                    $.messager.popover({ msg: "保存模板成功。", timeout: 1500, type: "success" });
                                    $("#regTemplate").combobox("clear");
                                    $("#regTemplate").combobox("reload");

                                } else {
                                    $.messager.alert("提示", "保存模板失败，原因：" + saveRes, "warning");
                                }
                            }

                        }
                    });
                }
            });

            $("#btnDelTemplate").linkbutton({
                iconCls: "icon-w-cancel",
                onClick: function() {
                    var templateId = $("#regTemplate").combobox("getValue");
                    var templateText = $("#regTemplate").combobox("getText");
                    if (!templateId) {
                        $.messager.alert("提示", "请选择模板后再删除。", "warning");
                        return;
                    }

                    $.messager.confirm("提示", "是否删除模板【" + templateText + "】？", function(r) {
                        if (r) {
                            var saveRes = dhccl.removeData(ANCLS.Config.ModuleTemplate, templateId);
                            if (saveRes.indexOf("S^") === 0) {
                                $.messager.popover({ type: "success", msg: "删除模板成功。", timeout: 1500 });
                                $("#regTemplate").combobox("clear");
                                $("#regTemplate").combobox("reload");
                            } else {
                                $.messager.alert("提示", "删除模板失败，原因：" + saveRes, "error");
                            }
                        }
                    });
                }
            });

            $("#btnApplyTemplate").linkbutton({
                iconCls: "icon-w-edit",
                onClick: function() {
                    var templateId = $("#regTemplate").combobox("getValue");
                    var templateText = $("#regTemplate").combobox("getText");
                    if (!templateId) {
                        $.messager.alert("提示", "请选择模板后再应用。", "warning");
                        return;
                    }

                    $.messager.confirm("提示", "是否应用模板【" + templateText + "】？", function(r) {
                        if (r) {
                            var templateDatas = dhccl.getDatas(ANCSP.DataQuery, {
                                ClassName: ANCLS.BLL.ConfigQueries,
                                QueryName: "FindPreferedDataForTemplate",
                                Arg1: templateId,
                                Arg2: session.UserID,
                                ArgCnt: 2
                            }, "json");
                            if (templateDatas && templateDatas.length > 0) {
                                $("#anaRegBox").datagrid("loadData", []);

                                for (var i = 0; i < templateDatas.length; i++) {
                                    var templateData = templateDatas[i];
                                    var anaData = _this.genAnaDataForTemplate(templateData);
                                    $("#anaRegBox").datagrid("appendRow", anaData);
                                }
                            }
                        }
                    });
                }
            });

            $("#btnBatchDelData").linkbutton({
                iconCls: "icon-remove",
                plain: true,
                onClick: function() {
                    var checkedRows = $("#anaRegBox").datagrid("getSelections");
                    if (checkedRows && checkedRows.length > 0) {
                        $.messager.confirm("提示", "是否删除勾选的数据？", function(r) {
                            if (r) {
                                var delDatas = [];
                                var rowIndex = -1;
                                for (var i = 0; i < checkedRows.length; i++) {
                                    if (!checkedRows[i].RowId) {
                                        rowIndex = $("#anaRegBox").datagrid("getRowIndex", checkedRows[i]);
                                        $("#anaRegBox").datagrid("deleteRow", rowIndex);
                                        continue;
                                    }
                                    delDatas.push({ RowId: checkedRows[i].RowId, ClassName: ANCLS.Model.AnaData });
                                }
                                if (delDatas.length > 0) {
                                    var res = dhccl.removeDatas(dhccl.formatObjects(delDatas));
                                    if (res.indexOf("S^") === 0) {
                                        $.messager.popover({ type: "success", msg: "批量删除数据成功。", timeout: 1500 });
                                        var saveRes = dhccl.runServerMethodNormal(ANCLS.BLL.AnaData, "ClearEmptyParaItem", session.RecordSheetID);
                                        if (saveRes.indexOf("S^") < 0) {
                                            $.messager.alert("提示", "保存数据失败，原因：" + saveRes, "error");
                                        }
                                        $("#anaRegBox").datagrid("reload");
                                    } else {
                                        $.messager.alert("提示", "批量删除数据失败，原因：" + res, "error");
                                    }
                                }
                            }
                        });
                    } else {
                        $.messager.alert("提示", "请先勾选要删除的数据，再操作。", "warning");
                    }
                }
            });

            $("#btnBatchAddData").linkbutton({
                iconCls: "icon-save",
                plain: true,
                onClick: function() {
                    _this.save();
                }
            });
        },
        setDateTime: function(recordStartDT) {
            this.StartDT.datetimebox('setValue', recordStartDT);
        },
        reload: function() {
            $("#anaRegBox").datagrid('reload');
        },
        initOperActions: function() {
            var _this = this;
            var eventDrugItems = [];
            if (this.options.categoryItems && this.options.categoryItems.length > 0) {
                for (var i = 0; i < this.options.categoryItems.length; i++) {
                    var categoryItem = this.options.categoryItems[i];
                    if ((categoryItem.CategoryCode !== 'KeyEvent') &&
                        (categoryItem.ItemCategory === "D" || categoryItem.ItemCategory === "E")) {
                        if (categoryItem.ItemCategory === "D" && categoryItem.$dataCategory && categoryItem.$dataCategory.$mainCategory && categoryItem.$dataCategory.$mainCategory.$displayCategory) {
                            categoryItem.GroupDesc = categoryItem.$dataCategory.$mainCategory.$displayCategory.title;
                        } else if (categoryItem.ItemCategory === "E") {
                            categoryItem.GroupDesc = categoryItem.CategoryDesc;
                        }
                        eventDrugItems.push(categoryItem);
                    }
                }
            }

            var itemGroups = dhccl.group(eventDrugItems, "ItemCategoryDesc");
            // $("#operActionsBox").datagrid({
            //     title: "事件与药品",
            //     fit:true,
            //     iconCls:"icon-paper",
            //     headerCls:"panel-header-gray",
            //     data:eventDrugItems,
            //     columns:[[
            //         {field:"CheckStatus",title:"选择",checkbox:true},
            //         {field:"ItemDesc",title:"项目",width:120},
            //     ]],
            //     view: groupview,
            //     groupField: "ItemCategoryDesc",
            //     groupFormatter: function (value, rows) {

            //         return value;
            //     }
            // });

            $("#operActionTabs").tabs({
                fit: true
            });

            for (var i = 0; i < itemGroups.length; i++) {
                var itemGroup = itemGroups[i];
                var firstItem = itemGroup.data[0];
                var boxId = firstItem.ItemCategory + "Box";
                $("#operActionTabs").tabs("add", {
                    title: itemGroup.id,
                    content: "<table id='" + boxId + "'></table>"
                });

                $("#" + boxId).datagrid({
                    items: itemGroup.data,
                    linkedCategory: firstItem.ItemCategory,
                    border: false,
                    fit: true,
                    iconCls: "icon-paper",
                    headerCls: "panel-header-gray",
                    data: itemGroup.data,
                    toolbar: "<div style='padding:10px;'><span class='searchbox' style='width: 120px; height: 28px;'><input type='text' data-box='" + boxId + "' id='filter" + firstItem.ItemCategory + "' class='searchbox-text searchbox-prompt' style='width: 90px; height: 28px; line-height: 28px;'  placeholder='拼音码或描述'><span><span class='searchbox-button searchbox-button-hover'></span></span></span><a href='#' id='btnAdd" + firstItem.ItemCategory + "'>批量增加</a>",
                    columns: [
                        [
                            { field: "CheckStatus", title: "选择", checkbox: true },
                            { field: "ItemDesc", title: "项目", width: 90 },
                            { field: "CategoryDesc", title: "分类", width: 100 }
                        ]
                    ],
                    onDblClickRow: function(rowIndex, rowData) {
                            _this.appendRegRow(rowData);
                        }
                        // view: groupview,
                        // groupField: "ItemCategoryDesc",
                        // groupFormatter: function (value, rows) {

                    //     return value;
                    // }
                });

                $("#filter" + firstItem.ItemCategory).on("input", function(e) {
                    var boxId = $(this).attr("data-box");
                    var opts = $("#" + boxId).datagrid("options");
                    var filterDesc = ($(this).val()).toUpperCase();
                    if (opts.items && opts.items.length > 0) {
                        var newDataList = [];
                        for (var i = 0; i < opts.items.length; i++) {
                            var item = opts.items[i];
                            var alias = item.Alias ? item.Alias.toUpperCase() : "";
                            var itemDesc = item.ItemDesc ? item.ItemDesc.toUpperCase() : "";
                            if (alias.indexOf(filterDesc) >= 0 || itemDesc.indexOf(filterDesc) >= 0) {
                                newDataList.push(item);
                            }
                        }
                        $("#" + boxId).datagrid("loadData", newDataList);
                    }
                });

                $("#btnAdd" + firstItem.ItemCategory).linkbutton({
                    linkedBox: boxId,
                    iconCls: "icon-add",
                    plain: true,
                    onClick: function() {
                        var opts = $(this).linkbutton("options");
                        var checkedRows = $("#" + opts.linkedBox).datagrid("getChecked");
                        //var anaDatas=[];
                        var now = (new Date()).format("yyyy-MM-dd HH:mm");
                        for (var i = 0; i < checkedRows.length; i++) {
                            var rowData = checkedRows[i];
                            _this.appendRegRow(rowData);
                        }

                        $("#" + opts.linkedBox).datagrid("clearChecked");
                    }
                });
            }

            // $("#operActionTabs").tabs("add",{
            //     title:"事件明细"
            // });

            $("#operActionTabs").tabs("select", 0);
        },

        appendRegRow: function(rowData) {
            var now = (new Date());
            var startDate = now.format("yyyy-MM-dd"),
                endDate = startDate,
                startTime = now.format("HH:mm"),
                endTime = startTime;
            var dataCategoryId = rowData.DataCategory;
            if (rowData.ItemCategory === "E") {
                dataCategoryId = rowData.MainCategory;
            }
            var drugItem = rowData.drugItem;
            var defaultValue = {};
            if (drugItem) {
                defaultValue = {
                    DoseQty: drugItem.DoseQty || "",
                    DoseUnit: drugItem.DoseUnit || "",
                    DoseUnitDesc: drugItem.DoseUnitDesc || "",
                    Instruction: drugItem.Instruction || "",
                    InstructionDesc: drugItem.InstructionDesc || ""
                };
            }
            $("#anaRegBox").datagrid("appendRow", {
                CategoryItem: rowData.RowId,
                ItemCategory: rowData.ItemCategory,
                DataCategory: dataCategoryId,
                DataItem: rowData.DataItem,
                DataItemDesc: rowData.ItemDesc,
                StartDate: startDate,
                Continuous: 'N',
                EndDate: "",
                StartTime: startTime,
                EndTime: "",
                DataValue: "",
                DoseQty: defaultValue.DoseQty || "",
                DoseUnit: defaultValue.DoseUnit || "",
                DoseUnitDesc: defaultValue.DoseUnitDesc || "",
                Instruction: defaultValue.Instruction || "",
                InstructionDesc: defaultValue.InstructionDesc || "",
                edited: true
            });
        },
        open: function() {
            this.dom.dialog('open');
        },
        close: function() {
            this.dom.dialog('close');

        },
        clear: function() {},
        validate: function() {
            var result = true;
            var message = "";
            var dataRows = $("#anaRegBox").datagrid("getRows");
            for (var i = 0; i < dataRows.length; i++) {
                var dataRow = dataRows[i];
                if (dataRow.ItemCategory == "D" && (!dataRow.DoseQty || !dataRow.DoseUnit)) {
                    result = false;
                    message = "请填写用药剂量和单位后再保存！";
                    break;
                }
                if (dataRow.ItemCategory == "D" && !$.isNumeric(dataRow.DoseQty)) {
                    result = false;
                    message = "用药剂量格式错误，请修改为正确的格式后再保存！";
                    break;
                }
            }
            if (!result) $.messager.alert("提示", message, "error");

            return result;
        },
        save: function() {
            var _this = this;
            _this.endEdit("#anaRegBox");

            if (!this.validate()) return;

            var dataRows = $("#anaRegBox").datagrid("getRows");
            if (dataRows && dataRows.length > 0) {
                var anaDatas = [];
                for (var i = 0; i < dataRows.length; i++) {
                    var dataRow = dataRows[i];
                    if (dataRow.edited) anaDatas.push(_this.genAnaData(dataRow));
                }

                if (anaDatas.length > 0) {
                    var jsonDataStr = dhccl.formatObjects(anaDatas);
                    var recordSheetId = session.RecordSheetID;
                    var userId = session.UserID;
                    var saveRes = dhccl.runServerMethodNormal(ANCLS.BLL.AnaData, "SaveAnaRegData", recordSheetId, jsonDataStr, userId);
                    if (saveRes.indexOf("S^") === 0) {
                        $.messager.popover({ msg: "保存数据成功。", type: "success", timeout: 1500 });
                        $("#anaRegBox").datagrid("reload");
                    } else {
                        $.messager.alert("提示", "保存数据失败，原因：" + saveRes, "error");
                    }
                }
            }
        },

        genAnaData: function(dataRow) {
            var anaData = $.extend({}, dataRow);
            if (!anaData.ParaItem) {
                var paraItem = this.getParaItemByCatetoryItem(anaData.CategoryItem);
                if (anaData.ItemCategory === "E") {
                    paraItem = this.getParaItemByCatetoryItem('', anaData.DataCategory);
                }
                if (!paraItem) {
                    anaData.ParaItem = "";
                } else {
                    anaData.ParaItem = paraItem.RowId;
                }
            }

            if (!anaData.EndTime) {
                anaData.EndTime = anaData.StartTime;
            }
            if (!anaData.EndDate) {
                anaData.EndDate = anaData.StartDate;
                anaData.EndDT = anaData.EndDate + ' ' + anaData.EndTime;
            }

            var startDT = new Date().tryParse(anaData.StartDate + " " + anaData.StartTime),
                endDT = new Date().tryParse(anaData.EndDate + " " + anaData.EndTime);

            if (anaData.ItemCategory !== "D") {
                endDT = startDT;
            } else if (!endDT.isValidDate()) {
                endDT = startDT;
            }
            anaData.StartDate = startDT.format("yyyy-MM-dd");
            anaData.StartTime = startDT.format("HH:mm");
            anaData.EndDate = endDT.format("yyyy-MM-dd");
            anaData.EndTime = endDT.format("HH:mm");
            anaData.Source = "M";
            anaData.CreateUser = session.UserID;
            anaData.EditFlag = "N";
            anaData.ClassName = ANCLS.Model.AnaData;
            anaData.CreateUserID = session.UserID;
            if (anaData.ItemCategory === "D") {
                anaData.Continuous = (endDT.compareto(startDT) ? "Y" : "N");
            } else {
                anaData.Continuous = "N"
            }

            anaData.ClassName = ANCLS.Model.AnaData;

            return anaData;
        },

        genAnaDataForTemplate: function(dataRow) {
            var anaData = $.extend({}, dataRow, { RowId: "" });
            if (!anaData.ParaItem) {
                var paraItem = this.getParaItemByCatetoryItem(anaData.CategoryItem);
                if (anaData.ItemCategory === "E") {
                    paraItem = this.getParaItemByCatetoryItem('', anaData.Category);
                }
                if (!paraItem) {
                    anaData.ParaItem = "";
                } else {
                    anaData.ParaItem = paraItem.RowId;
                }
            }

            var standardTime = this.StartDT.datetimebox('getValue') || this.options.theatreInDT;
            var startDT = (new Date().tryParse(standardTime)).addMinutes(isNaN(anaData.GenerateTimeSpan) ? 0 : Number(anaData.GenerateTimeSpan));
            var endDT = startDT.addMinutes(isNaN(anaData.TimeSpanMinutes) ? 0 : Number(anaData.TimeSpanMinutes));
            if (anaData.ItemCategory !== "D") {
                endDT = startDT;
            }
            anaData.StartDate = startDT.format("yyyy-MM-dd");
            anaData.StartTime = startDT.format("HH:mm:ss");
            anaData.EndDate = endDT.format("yyyy-MM-dd");
            anaData.EndTime = endDT.format("HH:mm:ss");
            anaData.Source = "M";
            anaData.CreateUser = session.UserID;
            anaData.EditFlag = "N";
            anaData.ClassName = ANCLS.Model.AnaData;
            anaData.CreateUserID = session.UserID;
            anaData.edited = true;
            if (anaData.ItemCategory === "D") {
                anaData.Continuous = (endDT.compareto(startDT) ? "Y" : "N");
            } else {
                anaData.Continuous = "N"
            }

            anaData.ClassName = ANCLS.Model.AnaData;

            return anaData;
        },

        getParaItemByCatetoryItem: function(categoryItemId, dataCategoryId) {
            var paraItems = this.options.paraItems;
            var res = null;
            if (paraItems && paraItems.length > 0) {
                for (var i = 0; i < paraItems.length; i++) {
                    var paraItem = paraItems[i];
                    if (paraItem.CategoryItem && categoryItemId && paraItem.CategoryItem === categoryItemId) {
                        res = paraItem;
                    } else if (paraItem.DataCategory === dataCategoryId) {
                        res = paraItem
                    }
                }
            }

            return res;
        },

        genTemplateData: function(dataRow) {
            var tempDatas = [];
            var tempData = $.extend({}, dataRow);

            if (!tempData.EndTime) {
                tempData.EndTime = tempData.StartTime;
            }
            if (!tempData.EndDate) {
                tempData.EndDate = tempData.StartDate;
                tempData.EndDT = tempData.EndDate + ' ' + tempData.EndTime;
            }

            var startDT = new Date().tryParse(tempData.StartDT),
                endDT = new Date().tryParse(tempData.EndDT);
            tempData.Category = "";
            tempData.Description = tempData.DataItemDesc;
            if (tempData.ItemCategory === "D") {
                tempData.Continuous = (endDT.compareto(startDT) ? "Y" : "N");
            } else {
                tempData.Continuous = "N"
                endDT = startDT;
            }

            tempData.ClassName = ANCLS.Config.UserPreferedData;
            tempData.StartDate = startDT.format("yyyy-MM-dd");
            tempData.StartTime = startDT.format("HH:mm");
            tempData.EndDate = endDT.format("yyyy-MM-dd");
            tempData.EndTime = endDT.format("HH:mm");
            tempData.Type = tempData.ItemCategory;
            tempData.guid = dhccl.guid();

            tempDatas.push(tempData);
            if (tempData.DoseQty) {
                var drugData = {
                    ClassName: ANCLS.Config.UserPreferedDrug,
                    DoseQty: tempData.DoseQty,
                    DoseUnit: tempData.DoseUnit,
                    Instruction: tempData.Instruction,
                    dataGuid: tempData.guid
                };
                tempDatas.push(drugData);
            }

            return tempDatas;
        },

        endEdit: function(selector) {
            var rows = $(selector).datagrid("getRows");
            if (rows && rows.length > 0) {
                for (var i = 0; i < rows.length; i++) {
                    $(selector).datagrid("endEdit", i);
                }
            }
        }
    }
}));