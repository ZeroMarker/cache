$(document).ready(function() {
    var propertyForm = $("#propertyForm"),
        selectedRow = $("#dataBox").datagrid("getSelected"),
        dataItemID = selectedRow.RowId;
    // console.log(dataItemID);
    $("PropertyDataItem").val(dataItemID);

    $("#Legend").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        queryParams: {
            ClassName: dhcan.bll.dataQuery,
            QueryName: "FindLegends",
            Arg1: "",
            ArgCnt: 1
        }
    });

    propertyForm.form({
        url: dhccl.csp.dataService,
        onSubmit: function() {
            var isValid = $(this).form("validate");
            return isValid;
        },
        queryParams: {
            ClassName: "DHCAN.VitalSign"
        },
        success: function(data) {
            showOperMessage(data, "保存", function() {
                propertyForm.form("clear");
                $("#propertyDialog").dialog("close");
            });
        }
    });


    var vitalSignDatas = getDatas(ANCSP.DataQuery, {
        ClassName: dhcan.bll.dataQuery,
        QueryName: "FindVitalSign",
        Arg1: dataItemID,
        ArgCnt: 1
    }, "json");
    if (vitalSignDatas && vitalSignDatas.length > 0) {
        propertyForm.form("load", vitalSignDatas[0]);
    }
});