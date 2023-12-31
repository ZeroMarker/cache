$(document).ready(function() {
    $("#dataBox").datagrid({
        headerCls: 'panel-header-gray'
    });
    var columns = [
        [
            { field: "CPTypeDesc", title: "医生职称", width: 200 },
            { field: "OperClassDesc", title: "手术分级", width: 200 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        gridTitle: "职称关联手术分级",
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: "DHCAN.CPTypeOperClass",
        queryType: dhcan.bll.dataQuery,
        queryName: "FindCPTypeOperClass",
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

    $("#CPTypeID").combobox({
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: dhccl.bll.admission,
        //     QueryName: "FindCPType",
        //     ArgCnt: 0
        // },
        onBeforeLoad: function(param) {
            param.ClassName = dhccl.bll.admission;
            param.QueryName = "FindCPType";
            param.ArgCnt = 0;
        },
        valueField: "RowId",
        textField: "Description",
    });

    $("#OperClass").combobox({
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: dhcan.bll.dataQuery,
        //     QueryName: "FindOperClass",
        //     ArgCnt: 0
        // },
        onBeforeLoad: function(param) {
            param.ClassName = dhcan.bll.dataQuery;
            param.QueryName = "FindOperClass";
            param.ArgCnt = 0;
        },
        valueField: "RowId",
        textField: "Description",
    });
});