$(function() {
    var columns = [
        [
            { field: "UnitDesc", title: "浓度单位", width: 160 },
            { field: "SoluteQty", title: "溶质数量", width: 160 },
            { field: "SoluteUnitDesc", title: "溶质单位", width: 160 },
            { field: "SolventQty", title: "溶剂数量", width: 160 },
            { field: "SolventUnitDesc", title: "溶剂单位", width: 160 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        gridTitle: "手术麻醉浓度单位",
        gridTool: $("#dataTools"),
        form: $("#dataForm"),
        modelType: "DHCAN.DensityUnit",
        queryType: dhcan.bll.dataQuery,
        queryName: "FindDensityUnits",
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

    $("#filterDesc,#Unit,#SoluteUnit,#SolventUnit").combobox({
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