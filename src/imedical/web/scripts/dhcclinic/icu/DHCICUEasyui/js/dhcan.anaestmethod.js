$(document).ready(function() {
    var columns = [
        [
            { field: "Code", title: "代码", width: 120 },
            { field: "Description", title: "名称", width: 240 },
            { field: "Alias", title: "别名", width: 160 },
            { field: "AnaTypeDesc", title: "麻醉类型", width: 240 },
            { field: "ActiveDesc", title: "是否激活", width: 120 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        gridTitle: "麻醉方法",
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: ANCLS.Code.AnaMethod,
        queryType: ANCLS.BLL.CodeQueries,
        queryName: "FindAnaestMethod",
        dialog: $("#dataDialog"),
        addButton: $("#btnAdd"),
        editButton: $("#btnEdit"),
        delButton: $("#btnDel"),
        queryButton: $("#btnQuery"),
        submitCallBack: null,
        openCallBack: initDefaultValue,
        closeCallBack: null
    });
    dataForm.initDataForm();
    dataForm.datagrid.datagrid({
        onBeforeLoad: function(param) {
            param.Arg1 = $("#filterAnaType").val();
            param.Arg2 = '';
            param.ArgCnt = 2;
        }
    })

    $("#filterAnaType,#AnaType").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: dhcan.bll.dataQuery,
        //     QueryName: "FindAnaestType",
        //     ArgCnt: 0
        // }
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindAnaestType";
            param.ArgCnt = 0;
        }
    });

    $("#Description").val({
        onChange: function(newValue, oldValue) {
            if (newValue != oldValue) {
                var pinyinCode = markPinyinCode(newValue);
                $("#Alias").textbox("setValue", pinyinCode);
            }
        }
    })
});

function initDefaultValue(dataForm) {
    if (dataForm.hasRowSelected(false) === false) {
        $("#Active").combobox("setValue", "Y");
    }

}