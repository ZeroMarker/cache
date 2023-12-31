$(document).ready(function() {
    var columns = [
        [
            { field: "ShiftDate", title: "日期", width: 120 },
            { field: "PatDeptDesc", title: "科室", width: 140 },
            { field: "PatName", title: "患者姓名", width: 120 },
            { field: "PatGender", title: "性别", width: 80 },
            { field: "PatAge", title: "年龄", width: 80 },
            { field: "MedcareNo", title: "住院号", width: 100 },
            { field: "ABO", title: "血型", width: 80 },
            { field: "BloodType", title: "血制品", width: 100 },
            { field: "TransProvDesc", title: "输血科人员", width: 80 },
            { field: "FetchNurseDesc", title: "取血护士", width: 80 },
            { field: "FetchDT", title: "取血时间", width: 120 },
            { field: "CircualNurseDesc", title: "巡回护士", width: 100 },
            { field: "CirShiftDT", title: "交接时间", width: 120 },
            { field: "CheckProvDesc", title: "核对者", width: 80 },
            { field: "DiscardProvDesc", title: "弃血袋人员", width: 100 },
            { field: "DiscardDT", title: "弃血袋时间", width: 120 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#bloodShiftBox"),
        gridColumns: columns,
        gridTitle: "血制品交接记录",
        gridTool: "#bloodShiftTools",
        form: $("#dataForm"),
        modelType: ANCLS.Model.BloodTransShift,
        queryType: ANCLS.BLL.BloodTransfusion,
        queryName: "FindBloodTransShift",
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
        headerCls: "panel-header",
        onBeforeLoad:function(param){
            param.Arg1=$("#startDate").datebox("getValue");
            param.Arg2=$("#endDate").datebox("getValue");
            param.Arg3=$("#medicareNo").val();
            param.ArgCnt=3;
        }
    });

    initQueryConditions();
});

function initDefaultValue(dataForm) {

}

function initQueryConditions() {
    var today = (new Date()).format("yyyy-MM-dd");
    $("#startDate,#endDate").datebox("setValue", today);
}