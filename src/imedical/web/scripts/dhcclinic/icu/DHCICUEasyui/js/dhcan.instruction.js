$(function() {
    var columns = [
        [
            { field: "Code", title: "代码", width: 100 },
            { field: "Description", title: "描述", width: 100 },
            { field: "EnglishDesc", title: "英文描述", width: 100 },
            { field: "Abbreviation", title: "缩写", width: 100 },
            { field: "ExternalID", title: "HIS用药途径", width: 100 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        gridTitle: "用药途径",
        gridTool: $("#dataTools"),
        form: $("#dataForm"),
        modelType: "DHCAN.Code.Instruction",
        queryType: ANCLS.BLL.CodeQueries,
        queryName: "FindInstruction",
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
})