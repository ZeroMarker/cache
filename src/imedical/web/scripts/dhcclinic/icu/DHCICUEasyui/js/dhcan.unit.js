$(document).ready(function() {
    var columns = [
        [
            { field: "Code", title: "代码", width: 160 },
            { field: "Description", title: "名称", width: 160 },
            { field: "UomDesc", title: "HIS单位", width: 160 },
            { field: "UnitTypeDesc", title: "单位类型", width: 160 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        gridTitle: "手术麻醉单位",
        gridTool: $("#dataTools"),
        form: $("#dataForm"),
        modelType: "DHCAN.Code.Uom",
        queryType: ANCLS.BLL.CodeQueries,
        queryName: "FindUom",
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
        headerCls: 'panel-header-gray',
        onBeforeLoad: function(param) {
            param.Arg1 = $("#UnitType").combobox("getValue");
            param.ArgCnt = 1;
        }
    });

    $("#UomID").combobox({
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
            param.ClassName = CLCLS.BLL.Admission,
                param.QueryName = "FindUom",
                param.Arg1 = "QueryFilter";
            param.ArgCnt = 1;
        },
        mode: "remote"
    });
    $("#filterDesc").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: dhcan.bll.dataQuery,
        //     QueryName: "FindUnits",
        //     Arg1: "QueryFilter",
        //     Arg2:"",
        //     ArgCnt: 2
        // },
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries,
                param.QueryName = "FindUom",
                param.Arg1 = "QueryFilter";
            param.Arg2 = "";
            param.ArgCnt = 2;
        },
        mode: "remote"
    });

});