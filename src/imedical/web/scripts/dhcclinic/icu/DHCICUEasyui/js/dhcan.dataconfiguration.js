$(document).ready(function() {

    $("#OperAppOrderItem").combobox({
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
        valueField: "RowId",
        textField: "Description",
        mode: "remote"
    });

    $(".operdept").combobox({
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: CLCLS.BLL.Admission,
        //     QueryName: "FindLocation",
        //     Arg1: "QueryFilter",
        //     Arg2: "OP^EMOP^OUTOP",
        //     ArgCnt: 2
        // },
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindLocation";
            param.Arg1 = "QueryFilter";
            param.Arg2 = "OP^EMOP^OUTOP";
            param.ArgCnt = 2;
        },
        valueField: "RowId",
        textField: "Description",
        mode: "remote"
    });

    $("#NeedArrangeOperStatus").combobox({
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: ANCLS.BLL.ConfigQueries,
        //     QueryName: "FindOperStatus",
        //     Arg1: "",
        //     ArgCnt: 1
        // },
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindOperStatus";
            param.Arg1 = "";
            param.ArgCnt = 1;
        },
        valueField: "RowId",
        textField: "Description",
    });

    $("#btnEditDeptSeq").linkbutton({
        onClick:function(){
            $("#deptSeqDialog").dialog("open");
        }
    });

    $("#deptSeqBox").datagrid({
        fit: true,
        singleSelect: true,
        columns: [
            [
                { field: "DeptRowId", title: "科室ID", width: 60,hidden:true },
                { field: "DeptDesc", title: "科室", width: 160 }
            ]
        ],
        toolbar: "#deptSeqTools",
        rownumbers: true
    });

    $("#btnSave").linkbutton({
        onClick: function() {
            var formData = $("#dataForm").serializeJson();
            if (formData) {
                var configurations = [];
                for (var property in formData) {
                    var selector = "#" + property,
                        rowId = $(selector).attr("data-rowid"),
                        value = formData[property];
                    if (!rowId || rowId == "") {
                        if (!value || value == "") {
                            continue;
                        }
                    }
                    configurations.push({
                        ClassName: ANCLS.Config.DataConfig,
                        RowId: rowId,
                        DataKey: property,
                        DataValue: formData[property]
                    });
                }

                if (configurations && configurations.length > 0) {
                    var jsonData = dhccl.formatObjects(configurations);
                    $.ajax({
                        url: ANCSP.DataListService,
                        type: "post",
                        async: false,
                        data: {
                            jsonData: jsonData,
                        },
                        success: function(data) {
                            dhccl.showMessage(data, "保存", null, null, function() {
                                loadFormData();
                            });
                        }
                    });
                }
            }
        }
    });

    loadFormData();
});

function loadFormData() {
    $.ajax({
        url: ANCSP.DataQuery,
        type: "post",
        async: false,
        data: {
            ClassName: ANCLS.BLL.ConfigQueries,
            QueryName: "FindDataConfigurations",
            Arg1: "",
            ArgCnt: 1
        },
        dataType: "json",
        success: function(data) {
            var configurations = [];
            if (data) {
                if (data.length && data.length > 0) {
                    configurations = data;
                } else {
                    configurations.push(data);
                }

            }
            if (configurations && configurations.length > 0) {
                $("#dataForm").form("clear");
                $.each(configurations, function(index, dataItem) {
                    var selector = "#" + dataItem.DataKey;
                    if ($(selector).length > 0) {
                        if ($(selector).hasClass("hisui-combobox")) {
                            $(selector).combobox("setValue", dataItem.DataValue);
                        } else if ($(selector).hasClass("easyui-textbox")) {
                            // $(selector).textbox("setValue", dataItem.DataValue);
                            $(selector).val(dataItem.DataValue);
                        } else if ($(selector).hasClass("hisui-validatebox")) {
                            // $(selector).textbox("setValue", dataItem.DataValue);
                            $(selector).val(dataItem.DataValue);
                        }else if ($(selector).hasClass("hisui-datebox")) {
                            $(selector).datebox("setValue", dataItem.DataValue);
                        } else if ($(selector).hasClass("hisui-timespinner")) {
                            $(selector).timespinner("setValue", dataItem.DataValue);
                        } else if ($(selector).hasClass("hisui-checkbox")) {
                            if ($(selector).val() == dataItem.DataValue) {
                                $(selector).prop("checked", true);
                            } else {
                                $(selector).prop("checked", false);
                            }
                        }
                        $(selector).attr("data-rowid", dataItem.RowId);
                    }
                });
            }
        }
    });
}