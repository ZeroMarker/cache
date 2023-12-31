$(document).ready(function() {
    var columns = [
        [
            { field: "UomDesc", title: "浓度单位", width: 160 },
            { field: "SoluteUomDesc", title: "溶质单位", width: 160 },
            { field: "SolventUomDesc", title: "溶剂单位", width: 160 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        //gridTitle: "手术麻醉浓度单位",
        gridTool: $("#dataTools"),
        form: $("#dataForm"),
        modelType: ANCLS.Code.ConcentrationUom,
        queryType: ANCLS.BLL.CodeQueries,
        queryName: "FindConcentrationUom",
        dialog: $("#dataDialog"),
        addButton: $("#btnAdd"),
        editButton: $("#btnEdit"),
        delButton: $("#btnDel"),
        queryButton: $("#btnQuery"),
        submitCallBack: null,
        openCallBack: function() {
            $("#load_mask").addClass("window-mask");
        },
        closeCallBack: function() {
            $("#load_mask").removeClass("window-mask");
        }
    });
    dataForm.initDataForm();

    dataForm.datagrid.datagrid({
        border: false,
        onBeforeLoad: function(param) {
            param.Arg1 = $("#filterDesc").combobox("getValue");
            param.ArgCnt = 1;
        }
    });

    $("#filterDesc,#Uom,#SoluteUom,#SolventUom").combobox({
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

});