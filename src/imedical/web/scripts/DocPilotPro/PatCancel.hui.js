$(function(){	
	//ҳ�����ݳ�ʼ��
	Init();
	//ҳ��Ԫ�س�ʼ��
	PageHandle();
	//�¼���ʼ��
	InitEvent();
});
function Init(){
	var PatNo=$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProPat",
		MethodName:"GetPatNoByID",
		dataType:"text",
		EpisodeID:ServerObj.EpisodeID,
		PatientID:ServerObj.PatientID
	},false);
    var rtnStr=$.cm({
		ClassName:"web.DHCDocOrderEntry",
		MethodName:"GetPatientByNo",
		dataType:"text",
		PapmiNo:PatNo
	},false);
	if (rtnStr!=""){
		var rtnStrTemp=rtnStr.split("^");
		var myStr="�ǼǺ�:"+rtnStrTemp[1]+",����:"+rtnStrTemp[2]+",�Ա�:"+rtnStrTemp[3]+",����:"+rtnStrTemp[4];
		$("#PatInfo").val(myStr);
	}
}
function SetPatInfo(){
	var obj=document.getElementById('PapmiNo');
	if (obj){
		var encmeth=DHCC_GetElementData("GetPatInfoMethod");
		if (encmeth!=""){
			var rtnStr=cspRunServerMethod(encmeth,obj.value);
			if (rtnStr!=""){
				var rtnStrTemp=rtnStr.split("^");
				var myStr="�ǼǺ�:"+rtnStrTemp[1]+",����:"+rtnStrTemp[2]+",�Ա�:"+rtnStrTemp[3]+",����:"+rtnStrTemp[4];
				DHCC_SetElementData("PatientID",rtnStrTemp[0]);
				DHCC_SetElementData("PatInfo",myStr);
			}
		}
	}
}
function PageHandle(){
	LoadCancelReason();
}
function LoadCancelReason(){
	var Data=$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProject",
		QueryName:"FindDefineData",
		dataType:"json",
		MDesc:"����ҩ��",
		DDesc:"ȡ��ԭ��"
	},false); 
	var cbox = $HUI.combobox("#CancelReason", {
			valueField: 'rowid',
			textField: 'Desc', 
			panelHeight:'163',
			editable:true,
			data: Data["rows"],
			onChange:function(newValue,OldValue){
				if (newValue==""){
					var cbox = $HUI.combobox("#CancelReason");
					cbox.setValue("");
				}
			}
	 });
}
function InitEvent(){
	$("#Cancel").click(CancelClick);
	$("#Exit").click(ExitClick);
	$("#Complete").click(CompleteClick);
}
function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (ServerObj.sysDateFormat=="3") return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	else if (ServerObj.sysDateFormat=="4") return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	else return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}
function myparser(s){
    if (!s) return new Date();
    if(ServerObj.sysDateFormat=="4"){
		var ss = s.split('/');
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
	}else{
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
	}
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
		return new Date(y,m-1,d);
	} else {
		return new Date();
	}
}
function CancelClick(){
	var CancelReason=$("#CancelReason").combobox("getText");
	//var CancelReason=CheckComboxSelData("CancelReason",CancelReason);
	if (CancelReason==""){
		$.messager.alert("��ʾ","�˳����˱�����дȡ��ԭ��!","info",function(){
			$('#CancelReason').next('span').find('input').focus();
		});
		return false;
	}
	var PPPCancelUserDr=session['LOGON.USERID'];
	var CancelVisitStatus="C";
	SaveDelDataToServer(ServerObj.PPRowId,ServerObj.PatientID,PPPCancelUserDr,CancelReason,CancelVisitStatus);
}
function ExitClick(){
	var CancelReason=$("#CancelReason").combobox("getText");
	//var CancelReason=CheckComboxSelData("CancelReason",CancelReason);
	if (CancelReason==""){
		$.messager.alert("��ʾ","�˳����˱�����д�˳�ԭ��!","info",function(){
			$('#CancelReason').next('span').find('input').focus();
		});
		return false;
	}
	var PPPCancelUserDr=session['LOGON.USERID'];
	var CancelVisitStatus="R";
	SaveDelDataToServer(ServerObj.PPRowId,ServerObj.PatientID,PPPCancelUserDr,CancelReason,CancelVisitStatus);
}
function CompleteClick(){
	var PPPCancelUserDr=session['LOGON.USERID'];
	var CancelReason="";
	var CancelVisitStatus="O";
	SaveDelDataToServer(ServerObj.PPRowId,ServerObj.PatientID,PPPCancelUserDr,CancelReason,CancelVisitStatus);
}
function SaveDelDataToServer(PPRowId,PatientID,PPPCancelUserDr,CancelReason,CancelVisitStatus){
	try{
		var rtn=$.cm({
			ClassName:"web.PilotProject.DHCDocPilotProPat",
			MethodName:"CancelMethod",
			dataType:"text",
			PPRowId:PPRowId,
			PatientID:PatientID,
			PPPCancelUserDr:PPPCancelUserDr,
			CancelReason:CancelReason,
			CancelVisitStatus:CancelVisitStatus,
			Auto:"",
			ExitDate:$("#ExitDate").datebox("getValue")
		},false); 
		var myArray=rtn.split("^");
		if (myArray[0]=='0')
		{
			if (CancelVisitStatus=="C") {
				$.messager.alert("��ʾ","����ȡ���ɹ�!","info",function(){
					SuccessAfter();
				});
			}else if (CancelVisitStatus=="R") {
				$.messager.alert("��ʾ","�����˳��ɹ�!","info",function(){
					SuccessAfter();
				});
			}else {
				$.messager.alert("��ʾ","����ɹ�!","info",function(){
					SuccessAfter();
				});
			}
		}else{
			$.messager.alert("��ʾ","����: "+myArray[1]);
		}
	}catch(E){
		$.messager.alert("��ʾ",E.message);
		return false;
	}
}
function SuccessAfter(){
	parent.PilotProPatListTabDataGridLoad();
	parent.destroyDialog("Project");
}
function CheckComboxSelData(id,selId){
	var Find=0;
	 var Data=$("#"+id).combobox('getData');
	 for(var i=0;i<Data.length;i++){
		  var CombValue=Data[i].rowid  
		  var CombDesc=Data[i].Desc
		  if(selId==CombValue){
			  selId=CombValue;
			  Find=1;
			  break;
	      }
	  }
	  if (Find=="1") return selId
	  return "";
}