$(function() {
    var columns = [
        [
            { field: "UnitDesc", title: "速度单位", width: 160 },
            { field: "DoseUnitDesc", title: "剂量单位", width: 160 },
            { field: "TimeUnitDesc", title: "时间单位", width: 160 },
            { field: "WeightUnitDesc", title: "体重相关速度单位", width: 200 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        //gridTitle: "手术麻醉速度单位",
        gridTool: $("#dataTools"),
        form: $("#dataForm"),
        modelType: "CT.AN.SpeedUom",
        queryType: ANCLS.BLL.CodeQueries,
        queryName: "FindSpeedUnits",
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
        //headerCls: 'panel-header-gray',
        border:false,
        onBeforeLoad: function(param) {
            param.Arg1 = $("#filterDesc").combobox("getText");
            param.ArgCnt = 1;
        }
    });

    $("#filterDesc,#Unit,#DoseUnit,#TimeUnit,#WeightUnit").combobox({
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
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindUom";
            param.Arg1 = "QueryFilter";
            param.Arg2 = "";
            param.ArgCnt = 2;
        },
        mode: "remote"
    });

})