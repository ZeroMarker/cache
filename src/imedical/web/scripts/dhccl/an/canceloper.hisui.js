
var opaId=dhccl.getUrlParam("opaId");
$(document).ready(function() {
	InitForm();
});
//alert(ClientIPAddress)
function InitForm() {
	var objCancelReason=$HUI.combobox("#CancelReason",{
		url:$URL+"?ClassName=web.DHCANOPCancelOper&QueryName=FindCancelReason&ResultSetType=array",
		valueField:'Id',
		textField:'Desc',
		editable:false,
		panelHeight:'auto',
		onBeforeLoad:function(param){
			//param.anmethod=param.q;
		},
		onLoadSuccess:function(data) {
			    }
		//,mode: "remote"	
	});
    $("#opwinsave").linkbutton({
        onClick: btnUpdate_click
    });
    $("#opwincancel").linkbutton({
        onClick: closeWindow
    });
	}
function btnUpdate_click()
{
	var userId=session['LOGON.USERID'];
	var IfInsertLog=$.m({
        ClassName:"web.DHCANOPCancelOper",
        MethodName:"IfInsertLog"
        },false);
    if(IfInsertLog=="Y")
    {
	var clclogId="",logRecordId="",preValue="",preAddNote="",postValue="",postAddNote=""
	clclogId="CancelOper";
	preAddNote="Pre手术状态";
	
	logRecordId=opaId;
	postValue="C";
	postAddNote="撤销成功";
	//var wshNetwork = new ActiveXObject("WScript.Network");  
	//var userd=wshNetwork.UserDomain;  
	//var userc=wshNetwork.ComputerName;  
	//var useru=wshNetwork.UserName;  
	
	//var ipconfig=userd+":"+userc+":"+useru;
	    var ret=$.m({
        ClassName:"web.DHCANOPCancelOper",
        MethodName:"InsertCLLog",
        clclogcode:clclogId,
        logRecordId:opaId,
        preValue:preValue,
        preAddNote:preAddNote,
        postValue:postValue,
        postAddNote:postAddNote,
        userId:userId,
        ipAdress:ClientIPAddress
    },false);
	if(ret>0){
	}
	else
	{
	}
     }
		var cancelId=$HUI.combobox("#CancelReason").getValue();
		var cancelret=$.m({
        ClassName:"web.DHCANOPCancelOper",
        MethodName:"UpdateCancelReason",
        opaId:opaId,
        suspId:cancelId,
        userId:userId
        },false);
        if(cancelret==0)
        {
	        $.messager.alert("提示", "撤销成功", 'info');
	        window.returnValue=1;	//20181207
	        window.close();
        }
        else
        {
	         $.messager.alert("提示", "撤销失败！"+cancelret, 'error');
	        window.returnValue=0;	//20181207
	        alert(cancelret)
	        return;
        }

}
//关闭窗口
function closeWindow(){
	window.returnValue=0;	//20181207
    window.close();
}
