$(document).ready(function() {
    $("#dataBox").datagrid({
        headerCls: 'panel-header-gray'
    });
    var columns = [
        [
            { field: "Description", title: "名称", width: 240 },
            { field: "Alias", title: "别名", width: 120 },
            { field: "OperClassDesc", title: "手术分级", width: 120 },
            { field: "BladeTypeDesc", title: "切口类型", width: 120 },
            { field: "BodySiteDesc", title: "手术部位", width: 120 },
            { field: "OperPosDesc", title: "手术体位", width: 120 },
            { field: "ICD10", title: "ICD编码", width: 120 },
            { field: "ActiveDesc", title: "是否激活", width: 120 },
            { field: "OperTypeDesc", title: "手术类别", width: 120 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        gridTitle: "手术名称",
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: ANCLS.Code.Operation,
        queryType: ANCLS.BLL.CodeQueries,
        queryName: "FindOperation",
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
        onBeforeLoad: function(param) {
            param.Arg1 = $("#filterDesc").val();
            param.Arg2 = $("#filterOperClass").combobox("getValue");
            param.Arg3 = "";
            param.ArgCnt = 3
        }
    });

    $("#filterOperClass").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: dhcan.bll.dataQuery,
        //     QueryName: "FindOperClass",
        //     ArgCnt: 0
        // }
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindOperClass";
            param.ArgCnt = 0;
        }
    });

    $("#OperClass").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: dhcan.bll.dataQuery,
        //     QueryName: "FindOperClass",
        //     ArgCnt: 0
        // }
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindOperClass";
            param.ArgCnt = 0;
        }
    });

    $("#BladeType").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: dhcan.bll.dataQuery,
        //     QueryName: "FindBladeType",
        //     ArgCnt: 0
        // }
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindBladeType";
            param.ArgCnt = 0;
        }
    });

    $("#BodySite").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: dhcan.bll.dataQuery,
        //     QueryName: "FindBodySite",
        //     ArgCnt: 0
        // }
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindBodySite";
            param.ArgCnt = 0;
        }
    });

    $("#OperPosition").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: dhcan.bll.dataQuery,
        //     QueryName: "FindOperPosition",
        //     ArgCnt: 0
        // }
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindOperPosition";
            param.ArgCnt = 0;
        }
    });

    $("#Active").combobox({
        valueField:"value",
        textField:"text",
        data:CommonArray.WhetherOrNot
    });

    $("#btnImport").linkbutton({
        onClick: function() {
            var excelHelper = new ExcelHelper("D:\operation.xls", "Operation");
            var rowCount = excelHelper.getRowCount(),
                colCount = excelHelper.getColumnCount();
            if (rowCount < 2) {
                $.messager.alert("提示", "文件中没有数据", "warning");
                excelHelper.close();
                return;
            }
            var operList = [];
            for (var rowInd = 2; rowInd <= rowCount; rowInd++) {
                var operation = {
                    ClassName: "CT.AN.Operation",
                    Code: excelHelper.getCellValue(rowInd, 1),
                    Description: excelHelper.getCellValue(rowInd, 2),
                    Alias: excelHelper.getCellValue(rowInd, 3),
                    OperClassDesc: excelHelper.getCellValue(rowInd, 4),
                    BladeTypeDesc: excelHelper.getCellValue(rowInd, 5),
                    BodySiteDesc: excelHelper.getCellValue(rowInd, 6),
                    OperPosDesc: excelHelper.getCellValue(rowInd, 7),
                    ICDCode: excelHelper.getCellValue(rowInd, 8),
                    OperType: excelHelper.getCellValue(rowInd, 9),
                    Active: "Y"
                };
                operList.push(operation);
                if (operList.length == 300 || rowCount == rowInd) {
                    saveDatas(dhccl.csp.dataListService, {
                        jsonData: dhccl.formatObjects(operList),
                        ClassName: "CIS.AN.BL.Operation",
                        MethodName: "ImportOperation"
                    });
                    operList = null;
                    operList = [];
                }
            }

            excelHelper.close();
        }
    })
});