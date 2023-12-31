$(document).ready(function() {
    var columns = [
        [
            { field: "Description", title: "名称", width: 160 },
            { field: "Alias", title: "简拼", width: 100 },
            { field: "Price", title: "单价", width: 120 },
            { field: "DefaultQty", title: "默认数量", width: 120 },
            { field: "Note", title: "备注", width: 120 },
            { field: "StartDT", title: "生效时间", width: 180 },
            { field: "EndDT", title: "停用时间", width: 180 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        gridTitle: "一次性自费项目维护",
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: ANCLS.Config.SelfPaidMaterial,
        queryType: ANCLS.BLL.ConfigQueries,
        queryName: "FindSelfPaidMaterial",
        queryParams: {
            Arg1: session.DeptID,
            Arg2: 'Y',
            ArgCnt: 2
        },
        dialog: $("#dataDialog"),
        addButton: $("#btnAdd"),
        editButton: $("#btnEdit"),
        delButton: null,
        queryButton: null,
        onSubmitCallBack: function(param) {
            var datetime = $('#StartDT').datetimebox('getValue');
            var datetimeArr = datetime.split(' ');
            param.StartDate = datetimeArr[0] || '';
            param.StartTime = datetimeArr[1] || '';

            var datetime = $('#EndDT').datetimebox('getValue');
            var datetimeArr = datetime.split(' ');
            param.EndDate = datetimeArr[0] || '';
            param.EndTime = datetimeArr[1] || '';
        },
        submitCallBack: null,
        openCallBack: initDefaultValue,
        closeCallBack: null
    });
    dataForm.initDataForm();
});

function initDefaultValue(dataForm) {
    $("#DeptID").val(session.DeptID);
}