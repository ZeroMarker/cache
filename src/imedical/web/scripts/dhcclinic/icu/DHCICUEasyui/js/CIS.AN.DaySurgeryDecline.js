
var opsId=dhccl.getQueryString("opsId");
function initPage(){
  initComboBox();
 
}

function initComboBox(){

  $("#DeclineReason").combobox({
    valueField: "RowId",
    textField: "Description", 
    url: ANCSP.DataQuery,
    onBeforeLoad: function(param) {
       // param.ClassName = CLCLS.BLL.CodeQueries;
       param.ClassName = "CIS.AN.BL.CodeQueries";
        param.QueryName = "FindDictDataByCode";
        param.Arg1 = "DayOperDecline";
        param.ArgCnt=1;
    },
    onSelect:function(record)
    {
        var lastInfo=$("#DeclineReasonNote").val();
        if(lastInfo!="")
        {$("#DeclineReasonNote").val(lastInfo+","+record.Description);}
        else{$("#DeclineReasonNote").val(record.Description);}
        $("#DeclineReason").combobox("setValue","");
    },
    mode: "remote"
  });

  
  
  $("#btnSave").linkbutton({
   //iconCls:"icon-save",
   onClick:function(){
    saveDeclineReason();
 } 
});
$("#btnCancel").linkbutton({
  //iconCls:"icon-save",
  onClick:function(){
    window.parent.closeDaySurgeryDiag();
} 
});

}



function saveDeclineReason(){
  
  var DeclineReasonNote=$("#DeclineReasonNote").val();
  var ret=dhccl.runServerMethodNormal("CIS.AN.BL.DaySurgeryDecline","SaveDaySurgeryDecline",opsId,DeclineReasonNote,session.UserID);
  //alert(ret)
  if(ret=="0")
  {
      window.parent.closeDaySurgeryDiag();
  }
}


$(document).ready(initPage);