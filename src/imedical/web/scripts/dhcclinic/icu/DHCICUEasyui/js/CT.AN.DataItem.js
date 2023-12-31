var selectedDataItemID = "";
$(document).ready(function() {
    $("#dataBox").datagrid({
        border:false,
        headerCls: 'panel-header-gray'
    });
    var columns = [
        [
            { field: "Code", title: "代码", width: 160 },
            { field: "Description", title: "名称", width: 200 },
            { field: "ItemCategoryDesc", title: "分类", width: 120 },
            { field: "DataTypeDesc", title: "数据类型", width: 100 },
            { field: "Options", title: "选择项", width: 200 },
            {
                field: "Operation",
                title: "详细信息",
                width: 120,
                formatter: function(value, row, index) {
                    var result = "",
                        title = "",
                        dialogTitle = "";
                    switch (row.ItemCategory) {
                        case "V":
                            title = "生命体征";
                            dialog = "vitalSignDialog";
                            dialogTitle = "生命体征-" + row.Description;
                            dataItemSelector = "#VitalSignDataItem";
                            result = "<a href='#' onclick='editProperties(\"" + row.RowId + "\",\"" + dialog + "\",\"" + dialogTitle + "\",\"" + dataItemSelector + "\")'>" + title + "</a>";
                            break;
                        case "D":
                            title = "药品项目";
                            dialog = "drugItemDialog"
                            dialogTitle = "药品项目-" + row.Description;
                            dataItemSelector = "#DrugItemDataItem";
                            result = "<a href='#' onclick='editProperties(\"" + row.RowId + "\",\"" + dialog + "\",\"" + dialogTitle + "\",\"" + dataItemSelector + "\")'>" + title + "</a>";
                            // title = "药品组";
                            // dialog = "drugGroupDialog"
                            // dialogTitle = "药品组-" + row.Description;
                            // dataItemSelector = "#druggroup-DataItem";
                            // result = result + "<a href='#' onclick='editProperties(\"" + row.RowId + "\",\"" + dialog + "\",\"" + dialogTitle + "\",\"" + dataItemSelector + "\")'>" + title + "</a>";
                            break;
                        case "E":
                            title = "事件明细";
                            dialog = "eventItemDialog"
                            dialogTitle = "事件-" + row.Description;
                            dataItemSelector = "#EventItemDataItem,#EventDetailDataItem";
                            result = "<a href='#' onclick='editProperties(\"" + row.RowId + "\",\"" + dialog + "\",\"" + dialogTitle + "\",\"" + dataItemSelector + "\")'>" + title + "</a>";
                            break;
                    }

                    return result;
                }
            }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        gridTitle: "",
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: ANCLS.Code.DataItem,
        queryType: ANCLS.BLL.CodeQueries,
        queryName: "FindDataItem",
        dialog: $("#dataDialog"),
        addButton: $("#btnAdd"),
        editButton: $("#btnEdit"),
        delButton: $("#btnDel"),
        queryButton: $("#btnQuery"),
        submitCallBack: null,
        openCallBack: null,
        closeCallBack: null
    });
    dataForm.initDataForm();

    dataForm.datagrid.datagrid({
        onBeforeLoad: function(param) {
            param.Arg1 = $("#filterDesc").val();
            param.Arg2 = $("#filterItemCategory").combobox("getValue");
            param.ArgCnt = 2;
        },
        view: groupview,
        groupField: "ItemCategoryDesc",
        groupFormatter: function(value, rows) {
            return value + " 共" + rows.length + "项";
        }
    });

    $("#vitalSignDialog").dialog({
        buttons: [{
            text: "保存",
            iconCls: "icon-w-save",
            handler: function() {
                var selectedRow = $("#dataBox").datagrid("getSelected");
                $("#PropertyDataItem").val(selectedRow.RowId);
                $("#vitalSignForm").submit();
            }
        }, {
            text: "取消",
            iconCls: "icon-w-close",
            handler: function() {
                $("#vitalSignDialog").dialog("close");
            }
        }],
        onClose: function() {
            $("#vitalSignForm").form("clear");
        },
        onBeforeOpen: function() {
            var vitalSignDatas = dhccl.getDatas(ANCSP.DataQuery, {
                ClassName: ANCLS.BLL.CodeQueries,
                QueryName: "FindVitalSign",
                Arg1: selectedDataItemID,
                ArgCnt: 1
            }, "json");
            if (vitalSignDatas && vitalSignDatas.length > 0) {
                $("#vitalSignForm").form("load", vitalSignDatas[0]);
            }
        }
    });

    $("#Legend,#eventitem-legend").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: ANCLS.BLL.CodeQueries,
        //     QueryName: "FindLegends",
        //     Arg1: "",
        //     ArgCnt: 1
        // }
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindLegends";
            param.Arg1 = "";
            param.ArgCnt = 1;
        }
    });

    $("#vitalSignForm").form({
        url: dhccl.csp.dataService,
        onSubmit: function(param) {
            param.ClassName = ANCLS.Code.VitalSign;
            var isValid = $(this).form("validate");
            return isValid;
        },
        queryParams: {
            ClassName: ANCLS.Code.VitalSign
        },
        success: function(data) {
            dhccl.showMessage(data, "保存", null, null, function() {
                $("#vitalSignForm").form("clear");
                $("#vitalSignDialog").dialog("close");
            });
        }
    });

    $("#drugItemDialog").dialog({
        buttons: [{
            text: "保存",
            iconCls: "icon-w-save",
            handler: function() {

                $("#drugItemForm").submit();
            }
        }, {
            text: "取消",
            iconCls: "icon-w-close",
            handler: function() {
                $("#drugItemDialog").dialog("close");
            }
        }],
        onClose: function() {
            $("#drugItemForm").form("clear");
        },
        onBeforeOpen: function() {
            var drugItemDatas = dhccl.getDatas(ANCSP.DataQuery, {
                ClassName: ANCLS.BLL.CodeQueries,
                QueryName: "FindDrugItem",
                Arg1: selectedDataItemID,
                ArgCnt: 1
            }, "json");
            if (drugItemDatas && drugItemDatas.length > 0) {
                $("#drugItemForm").form("load", drugItemDatas[0]);
                $("#ArcimID").combogrid("setText", drugItemDatas[0].ArcimDesc);
            }
        }
    });

    $("#drugItemForm").form({
        url: dhccl.csp.dataService,
        onSubmit: function(param) {
            param.ClassName = ANCLS.Code.DrugItem;
            var isValid = $(this).form("validate");
            if (dataForm.submitAction && isValid) {
                if (dataForm.curAction === "Add") {
                    param.RowId = "";
                }
                dataForm.submitAction(param);
                return false;
            }

            var formData = $(this).serializeJson();
            var formId = $(this).attr("id");
            $("#" + formId + " .formdata").each(function(index, item) {
                var formItemName = $(item).attr("name");
                if (!formItemName || formItemName === "undefined") {
                    formItemName = $(item).attr("comboname");
                }
                if (!formData[formItemName]) {
                    param[formItemName] = "";
                }
            });

            return isValid;

        },
        queryParams: {
            ClassName: ANCLS.Code.DrugItem
        },
        success: function(data) {
            dhccl.showMessage(data, "保存", null, null, function() {
                $("#drugItemForm").form("clear");
                $("#drugItemDialog").dialog("close");
            });
        }
    });

    var eventItemColumns = [
        [
            { field: "ShowDetailDesc", title: "显示明细", width: 120 },
            { field: "ShowItemDesc", title: "显示项目名称", width: 120 },
            { field: "ShowTextMark", title: "显示文本标记", width: 120 },
            { field: "MarkDirection", title: "文本标记方向", width: 120 },
            { field: "LegendDesc", title: "图例名称", width: 120 },
            { field: "LegendColor", title: "图例颜色", width: 120 }
        ]
    ];

    var eventItemDataForm = new DataForm({
        datagrid: $("#eventItemBox"),
        gridColumns: eventItemColumns,
        gridTitle: "事件项",
        gridTool: "#eventItemTool",
        form: $("#eventItemForm"),
        modelType: ANCLS.Code.EventItem,
        queryType: ANCLS.BLL.CodeQueries,
        queryName: "FindEventItem",
        dialog: null,
        addButton: null,
        editButton: null,
        delButton: null,
        saveButton: $("#btnSaveEventItem"),
        submitCallBack: null,
        openCallBack: null,
        closeCallBack: null
    });
    eventItemDataForm.initDataForm();

    eventItemDataForm.datagrid.datagrid({
        pagination: false,
        onBeforeLoad: function(param) {
            param.Arg1 = selectedDataItemID;
            param.ArgCnt = 1;
        },
        onLoadSuccess: function(data) {
            if (data && data.rows && data.rows.length > 0) {
                $("#eventItemForm").form("load", data.rows[0]);
            }
        }
    });

    $("#eventitem_relatedstartevent,#eventitem_relatedendevent").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindDataItem";
            param.Arg1 = "QueryFilter";
            param.Arg2 = "E";
            param.ArgCnt = 2;
        },
        mode: "remote"
    });

    $("#StartEvent,#EndEvent").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindDataItem";
            param.Arg1 = "QueryFilter";
            param.Arg2 = "E";
            param.ArgCnt = 2;
        }
    });

    var eventDetailColumns = [
        [
            { field: "Description", title: "标题", width: 120 },
            { field: "DataTypeDesc", title: "数据类型", width: 80 },
            { field: "Editor", title: "控件", width: 160 },
            { field: "EditorSize", title: "控件大小", width: 120 },
            { field: "Unit", title: "单位", width: 80 },
            { field: "ValueRange", title: "值范围", width: 200 }
        ]
    ];

    var eventDetailDataForm = new DataForm({
        datagrid: $("#eventDetailBox"),
        gridColumns: eventDetailColumns,
        gridTitle: "事件明细项",
        gridTool: "#eventDetailTool",
        form: $("#eventDetailForm"),
        modelType: ANCLS.Code.EventOptions,
        queryType: ANCLS.BLL.CodeQueries,
        queryName: "FindEventOptions",
        dialog: null,
        addButton: $("#btnAddEventDetail"),
        editButton: $("#btnEditEventDetail"),
        delButton: $("#btnDelEventDetail"),
        submitCallBack: setEventDataItemValue,
        openCallBack: null,
        closeCallBack: null
    });
    eventDetailDataForm.initDataForm();

    eventDetailDataForm.datagrid.datagrid({
        onBeforeLoad: function(param) {
            param.Arg1 = selectedDataItemID;
            param.ArgCnt = 1;
        }
    });

    $("#eventItemDialog").dialog({
        onClose: function() {
            $("#eventDetailForm").form("clear");
            $("#eventItemForm").form("clear");

        },
        onBeforeOpen: function() {
            $("#eventDetailForm").form("clear");
            $("#eventItemForm").form("clear");
            $("#EventDetailDataItem,#EventItemDataItem").val(selectedDataItemID);
            eventItemDataForm.datagrid.datagrid("reload");
            eventDetailDataForm.datagrid.datagrid("reload");
        }
    });

    var drugGroupColumns = [
        [
            { field: "FixedProportion", title: "固定比例", width: 120 }
        ]
    ];

    var drugGroupDataForm = new DataForm({
        datagrid: $("#drugGroupBox"),
        gridColumns: drugGroupColumns,
        gridTitle: "药物组",
        gridTool: "#drugGroupTool",
        form: $("#drugGroupForm"),
        modelType: ANCLS.Code.DrugGroup,
        queryType: ANCLS.BLL.CodeQueries,
        queryName: "FindDrugGroup",
        dialog: null,
        addButton: null,
        editButton: null,
        delButton: null,
        saveButton: $("#btnSaveDrugGroup"),
        submitCallBack: null,
        openCallBack: null,
        closeCallBack: null
    });
    drugGroupDataForm.initDataForm();

    drugGroupDataForm.datagrid.datagrid({
        pagination: false,
        onBeforeLoad: function(param) {
            param.Arg1 = selectedDataItemID;
            param.ArgCnt = 1;
        },
        onLoadSuccess: function(data) {
            if (data && data.rows && data.rows.length > 0) {
                $("#drugGroupForm").form("load", data.rows[0]);
            }
        }
    });

    var drugGroupItemColumns = [
        [
            { field: "ArcimDesc", title: "医嘱项", width: 120 },
            { field: "Dose", title: "默认剂量", width: 80 },
            { field: "DoseUnitDesc", title: "剂量单位", width: 160 },
            { field: "Speed", title: "默认速度", width: 120 },
            { field: "SpeedUnitDesc", title: "速度单位", width: 80 },
            { field: "RecvLocDesc", title: "接收科室", width: 200 },
            { field: "IsSolvent", title: "是否溶剂", width: 200 },
            { field: "ToxicAnesthetic", title: "是否毒麻药", width: 200 }
        ]
    ];

    var drugGroupItemDataForm = new DataForm({
        datagrid: $("#drugGroupItemBox"),
        gridColumns: drugGroupItemColumns,
        gridTitle: "药物组项目",
        gridTool: "#drugGroupItemTool",
        form: $("#drugGroupItemForm"),
        modelType: ANCLS.Code.DrugGroupItem,
        queryType: ANCLS.BLL.CodeQueries,
        queryName: "FindDrugGroupItems",
        dialog: null,
        addButton: $("#btnAddDrugGroupItem"),
        editButton: $("#btnEditDrugGroupItem"),
        delButton: $("#btnDelDrugGroupItem"),
        submitCallBack: null,
        openCallBack: null,
        closeCallBack: null
    });
    drugGroupItemDataForm.initDataForm();

    drugGroupItemDataForm.datagrid.datagrid({
        onBeforeLoad: function(param) {
            param.Arg1 = selectedDataItemID;
            param.ArgCnt = 1;
        }
    });

    $("#drugGroupDialog").dialog({
        onClose: function() {
            $("#drugGroupItemForm").form("clear");
            $("#drugGroupForm").form("clear");

        },
        onBeforeOpen: function() {
            $("#drugGroupItemForm").form("clear");
            $("#drugGroupForm").form("clear");
            $("#druggroup_DataItem,#druggroupitem_DataItem").val(selectedDataItemID);
            drugGroupDataForm.datagrid.datagrid("reload");
            drugGroupItemDataForm.datagrid.datagrid("reload");
        }
    });

    $("#DoseUnit,#druggroupitem_DoseUnit").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: dhccl.bll.admission,
        //     QueryName: "FindUom",
        //     Arg1: "QueryFilter",
        //     ArgCnt: 1
        // },
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindUom";
            param.Arg1 = "QueryFilter";
            param.Arg2 = "D";
            param.ArgCnt = 2;
        },
        mode: "remote"
    });

    $("#Instruction").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: dhccl.bll.admission,
        //     QueryName: "FindUom",
        //     Arg1: "QueryFilter",
        //     ArgCnt: 1
        // },
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindInstruction";
            param.ArgCnt = 0;
        },
        mode: "remote"
    });

    $("#Reason").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: ANCLS.BLL.CodeQueries,
        //     QueryName: "FindReason",
        //     Arg1: "A",
        //     ArgCnt: 1
        // }
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindReason";
            param.Arg1 = "A";
            param.ArgCnt = 1;
        }
    });

    $("#SpeedUnit,#druggroupitem_SpeedUnit").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: ANCLS.BLL.CodeQueries,
        //     QueryName: "FindUom",
        //     Arg1: "",
        //     Arg2: "S",
        //     ArgCnt: 2
        // }
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindUom";
            param.Arg1 = "";
            param.Arg2 = "S";
            param.ArgCnt = 2;
        }
    });

    $("#ConcentrationUnit").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: ANCLS.BLL.CodeQueries,
        //     QueryName: "FindUom",
        //     Arg1: "",
        //     Arg2: "C",
        //     ArgCnt: 2
        // }
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindUom";
            param.Arg1 = "";
            param.Arg2 = "C";
            param.ArgCnt = 2;
        }
    });

    $("#RecvLocID,#druggroupitem_RecvLocID").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: CLCLS.BLL.Admission,
        //     QueryName: "FindLocation",
        //     Arg1: "QueryFilter",
        //     Arg2: "INOPDEPT^EMOPDEPT^OUTOPDEPT^AN^OUTAN^EMAN",
        //     ArgCnt: 2
        // },
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindLocList";
            param.Arg1 = "";
            param.Arg2 = "INOPDEPT^EMOPDEPT^OUTOPDEPT^AN^OUTAN^EMAN";
            param.Arg3 = "";
            param.ArgCnt = 3;
        },
        mode: "remote"
    });

    $("#ArcimID,#druggroupitem_ArcimID").combogrid({
        panelWidth: 400,
        pagination: true,
        rownumbers: true,
        singleSelect: true,
        pageSize: 50,
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: CLCLS.BLL.Admission,
        //     QueryName: "FindMasterItem",
        //     Arg1: "QueryFilter",
        //     ArgCnt: 1
        // },
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindMasterItem";
            param.Arg1 = "QueryFilter";
            param.ArgCnt = 1;
        },
        idField: "RowId",
        textField: "Description",
        mode: "remote",
        columns: [
            [
                { field: 'Code', title: '代码', width: 100 },
                { field: 'Description', title: '名称', width: 350 }
            ]
        ]
    });
});

function setEventDataItemValue() {
    $("#EventItemDataItem,#EventDetailDataItem").val(selectedDataItemID);
}

function editProperties(dataItemID, dialog, title, dataItemSelector) {
    selectedDataItemID = dataItemID;
    var selector = "#" + dialog;
    $(selector).dialog("setTitle", title);
    $(dataItemSelector).val(dataItemID);
    $(selector).dialog("open");

}