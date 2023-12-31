$(function() {
    var columns = [
        [
            { field: "SourceUnit", title: "源单位", width: 160, hidden: true },
            { field: "SourceUnitDesc", title: "源单位", width: 160 },
            { field: "EqualUnit", title: "等效单位", width: 160, hidden: true },
            { field: "EqualUnitDesc", title: "等效单位", width: 160 },
            { field: "EqualQty", title: "等效数量", width: 160 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        gridTitle: "手术麻醉等效单位",
        gridTool: $("#dataTools"),
        form: $("#dataForm"),
        modelType: "DHCAN.EqualUnit",
        queryType: dhcan.bll.dataQuery,
        queryName: "FindEqualUnits",
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
            param.Arg1 = $("#filterDesc").combobox("getValue");
            param.ArgCnt = 1;
        }
    });

    $("#filterDesc,#SourceUnit,#EqualUnit").combobox({
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
            param.ClassName = dhcan.bll.dataQuery;
            param.QueryName = "FindUnits";
            param.Arg1 = "QueryFilter";
            param.Arg2 = "";
            param.ArgCnt = 2;
        },
        mode: "remote"
    });

})