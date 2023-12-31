$(document).ready(function() {
    var columns = [
        [
            { field: "Code", title: "代码", width: 160 },
            { field: "Description", title: "名称", width: 160 },
            { field: "LegendDesc", title: "图标", width: 160 },
            { field: "Color", title: "颜色", width: 160 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        //gridTitle: "手术麻醉单位",
        gridTool: $("#dataTools"),
        form: $("#dataForm"),
        modelType: "CT.AN.InjectionSite",
        queryType: ANCLS.BLL.CodeQueries,
        queryName: "FindInjectionSite",
        dialog: $("#dataDialog"),
        addButton: $("#btnAdd"),
        editButton: $("#btnEdit"),
        delButton: $("#btnDel"),
        queryButton: $("#btnQuery"),
        submitCallBack: null,
        openCallBack: function() {
            //$("#load_mask").addClass("window-mask");
        },
        closeCallBack: function() {
            //$("#load_mask").removeClass("window-mask");
        }
    });
    dataForm.initDataForm();

    dataForm.datagrid.datagrid({
        //headerCls: 'panel-header-gray',
        border: false,
        onBeforeLoad: function(param) {
            param.Arg1 = $("#filterDesc").val();
            param.ArgCnt = 1;
        }
    });

    $("#Legend").combobox({
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
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindLegends";
            param.Arg1 = "";
            param.ArgCnt = 1;
        }
    });
});