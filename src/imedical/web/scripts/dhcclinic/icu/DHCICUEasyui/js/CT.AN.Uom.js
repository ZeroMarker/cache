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
        //gridTitle: "手术麻醉单位",
        gridTool: $("#dataTools"),
        form: $("#dataForm"),
        modelType: "CT.AN.Uom",
        queryType: ANCLS.BLL.CodeQueries,
        queryName: "FindUom",
        dialog: $("#dataDialog"),
        addButton: $("#btnAdd"),
        editButton: $("#btnEdit"),
        delButton: $("#btnDel"),
        queryButton: $("#btnQuery"),
        submitCallBack: null,
        openCallBack: function(){
            $("#load_mask").addClass("window-mask");
        },
        closeCallBack: function(){
            $("#load_mask").removeClass("window-mask");
        }
    });
    dataForm.initDataForm();

    dataForm.datagrid.datagrid({
        //headerCls: 'panel-header-gray',
        border:false,
        onBeforeLoad: function(param) {
            param.Arg1 = $("#filterDesc").val();
            param.Arg2 = $("#filterUnitType").combobox("getValue");
            param.ArgCnt = 2;
        }
    });

    $("#ExternalID").combobox({
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
                param.Arg1 = param.q?param.q:"";
            param.ArgCnt = 1;
        },
        mode: "remote"
    });
    $("#filterUnitType,#UnitType").combobox({
        valueField: "value",
        textField: "text",
        data:CommonArray.UnitTypes
    });

});