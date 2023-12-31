$(document).ready(function() {
    var propertyForm = $("#propertyForm"),
        selectedRow = $("#dataBox").datagrid("getSelected"),
        dataItemID = selectedRow.RowId;
    $("PropertyDataItem").val(dataItemID);

    $("#ArcimID").combogrid({
        panelWidth: 500,
        pagination: true,
        rownumbers: true,
        singleSelect: true,
        pageSize: 50,
        url: ANCSP.DataQuery,
        queryParams: {
            ClassName: dhccl.bll.admission,
            QueryName: "FindMasterItem",
            Arg1: "QueryFilter",
            ArgCnt: 1
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

    $("#DoseUnit").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        queryParams: {
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindUom",
            Arg1: "",
            Arg2: "D",
            ArgCnt: 2
        },
        mode: "remote"
    });

    $("#Reason").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        queryParams: {
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindReason",
            Arg1: "A",
            ArgCnt: 1
        }
    });

    $("#SpeedUnit").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        queryParams: {
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindUom",
            Arg1: "",
            Arg2: "S",
            ArgCnt: 2
        }
    });

    $("#ConcentrationUnit").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        queryParams: {
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindUom",
            Arg1: "",
            Arg2: "C",
            ArgCnt: 2
        }
    });

    $("#RecvLocID").combobox({
        valueField: "RowId",
        textField: "Code",
        url: ANCSP.DataQuery,
        queryParams: {
            ClassName: dhccl.bll.admission,
            QueryName: "FindLocation",
            Arg1: "QueryFilter",
            Arg2: "INOPDEPT^EMOPDEPT^OUTOPDEPT^AN^OUTAN^EMAN",
            ArgCnt: 2
        },
        mode: "remote"
    });

    propertyForm.form({
        url: dhccl.csp.dataService,
        onSubmit: function() {
            var isValid = $(this).form("validate");
            return isValid;
        },
        queryParams: {
            ClassName: "DHCAN.Code.DrugItem"
        },
        success: function(data) {
            dhccl.showMessage(data, "保存", null, null, function() {
                propertyForm.form("clear");
            });
        }
    });

    var drugItemDatas = getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.CodeQueries,
        QueryName: "FindDrugItem",
        Arg1: dataItemID,
        ArgCnt: 1
    }, "json");
    if (drugItemDatas && drugItemDatas.length > 0) {
        console.log(drugItemDatas[0]);
        propertyForm.form("load", drugItemDatas[0]);
        //$("#DoseUomID").combobox("setText", drugItemDatas[0].DoseUomDesc);
    }
});