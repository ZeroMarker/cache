$(document).ready(function() {
    var columns = [
        [
            // {
            //     field: "CheckStatus",checkbox: true
            // },
            { field: "Message", title: "消息内容", width: 200 },
            { field: "FromUserDesc", title: "发送者", width: 60 },
            { field: "ToUserDesc", title: "接收者", width: 60 },
            { field: "MessageType", title: "消息类型", width: 160 },
            { field: "StatusDesc", title: "状态", width: 60 },
            { field: "TransDT", title: "发送时间", width: 160 },
            { field: "ConfirmDT", title: "确认时间", width: 160 },
            { field: "ConfirmUserDesc", title: "确认者", width: 60 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#messageBox"),
        gridColumns: columns,
        gridTitle: "",
        gridTool: "#messageTools",
        form: $("#messageForm"),
        modelType: ANCLS.Model.TransferMessage,
        queryType: ANCLS.BLL.TransMessage,
        queryName: "FindTransMessagesForPat",
        queryParams:{
            Arg1:session.OPSID,
            ArgCnt:1
        },
        dialog: null,
        addButton: $("#btnSend"),
        editButton: null,
        delButton: null,
        queryButton: $("#btnSearch"),
        submitCallBack: null,
        onSubmitCallBack: UpdateFormValue,
        openCallBack: initDefaultValue,
        closeCallBack: null,
        datagridSelectCallBack:selectMessage,
        submitAction:saveMessage,
        delAction:null
    });
    dataForm.initDataForm();
    // dataForm.datagrid.datagrid({
    //     headerCls: "panel-header",
    //     border: false,
    //     onBeforeLoad: function(param) {
    //         param.Arg1 = session.RecordSheetID;
    //         param.ArgCnt = 1;
    //     },
    //     onLoadSuccess: function(data) {
    //         $(".barcode").each(function(index, el) {
    //             var specNo = $(this).attr("data-code");
    //             $(this).qrcode({size:64,text:specNo});
    //             // JsBarcode("#" + $(this).attr("id"), specNo, {
    //             //     height: 60,
    //             //     text: $(this).attr("data-desc"),
    //             //     fontSize: 12,
    //             //     format: "CODE128B"
    //             // });
    //         });
    //     },
    //     singleSelect:false
    // });

    $("#TransTo").combobox({
        valueField: "UserId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindCareProvByLoc";
            param.Arg1=param.q?param.q:"";
            param.Arg2=session.DeptID;
            param.ArgCnt = 2;
        },
        mode:"remote"
    });

    $("#MessageType").combobox({
        onSelect:function (record){
            var messageType=$(this).combobox("getText");
            var operSchedule=operDataManager.getOperAppData();
            var messageArr=[];
            switch(messageType){
                case "通知接病人":
                    messageArr.push("请前往"+operSchedule.WardBed+"，将"+operSchedule.Patient+"接到手术室，该患者拟实施"+operSchedule.PrevAnaMethodDesc+"。发布者："+session.UserName);
                    break;
                case "通知送病人":
                    messageArr.push(operSchedule.RoomDesc+operSchedule.Patient+"手术已完成，请将患者送回。发布者："+session.UserName);
                    break;
                case "通知送病理":
                    messageArr.push(operSchedule.RoomDesc+operSchedule.Patient+"的标本送病理。发布者："+session.UserName);
                    break;
                case "通知送冰冻":
                    messageArr.push(operSchedule.RoomDesc+operSchedule.Patient+"的标本送冰冻。发布者："+session.UserName);
                    break;
                case "通知家属到谈话间":
                    messageArr.push("请"+operSchedule.PatName+"的家属到谈话间。");
                    break;
                default:
                    break;
            }
            $("#Message").val(messageArr.join(""));
        }
    });
});

function saveMessage(param){
    param.RowId=$("#RowId").val();
    if(!param.RowId) param.RowId="";
    var ret=dhccl.saveDatas(ANCSP.DataListService,{
        ClassName:ANCLS.BLL.TransMessage,
        MethodName:"SaveMessageNew",
        jsonData:dhccl.formatObjects(param)
    },function(data){
        if(data.indexOf("S^")===0){
            $("#messageBox").datagrid("reload");
            $("#messageForm").form("clear");
        }else{
            $.messager.alert("提示","消息保存失败，原因："+data,"error");
        }
    })
}

function selectMessage(rowData){

}

// function delSpecimen(){
//     if (dhccl.hasRowSelected($("#specimenBox"), true)) {
//         var selectedRows = $("#specimenBox").datagrid("getSelections");
//         var idArr=[];
//         for(var i=0;i<selectedRows.length;i++){
//             idArr.push(selectedRows[i].RowId);
//         }
//         var idStr=idArr.join(",");
//         var ret=dhccl.runServerMethod(ANCLS.BLL.SpecimenManager,"DelSpecimen",idStr);
//         if(ret.success){
//             $("#specimenBox").datagrid("reload");
//         }else{
//             $.messager.alert("提示","标本删除失败，原因："+ret.result,"error");
//         }
//     }
// }

// function selectSpecimen(rowData){
//     $("#Specimen").combobox("setText",rowData.SpecDesc);
// }

function initDefaultValue(dataForm) {

}

function UpdateFormValue(param) {
    param.OperSchedule=session.OPSID;
    param.TransFrom=session.UserID;
    param.Status="S";
    param.RecvDept=session.DeptID;
    param.Message=$("#Message").val();
    param.MessageType=$("#MessageType").combobox("getValue");
    param.TransTo=$("#TransTo").combobox("getValue");
}
