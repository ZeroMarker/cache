

//����	DHCPESelectPreInfo.js
//����	ѡȡ��ԤԼ��Ա
//���	DHCPESelectPreInfo
//����	2019.08.10
//������  xy
document.body.onload=LoadHandler;
var SelRow="";
function LoadHandler()
{
	
	var obj=GetObj("BFind");
	if(obj) obj.onclick=BFind_click;
	
	var obj=GetObj("BUpdate");
	if(obj) obj.onclick=BUpdate_click;
	
	var obj=document.getElementById("RegNo");
	if (obj) {obj.onkeydown=RegNo_keydown; }
	 
}


function RegNo_keydown(e){
	
	var Key=websys_getKey(e);
	if ((13==Key)) {
		BFind_click();
	}
}
function BUpdate_click()
{
	if (SelRow==""){
		$.messager.alert("��ʾ","����ѡ�������������","info"); 
		return false;
	}
	
	var PreIADM=SelRow.TPIADM
	
	var TeamID=GetValue("TeamID","");
	if (TeamID==""){
		$.messager.alert("��ʾ","��ѡ��ϲ����ķ���","info"); 
		return false;
	}
	var RegNo=SelRow.TRegNo
	
	var flag=tkMakeServerCall("web.DHCPE.SelectPreInfo","GetRegNoByTeamID",TeamID,RegNo);
	if(flag==1){
		 $.messager.alert("��ʾ","�������Ѿ����ڸ���Ա,�����ظ����","info");
		 return false;
	 }
	
	var ret=tkMakeServerCall("web.DHCPE.SelectPreInfo","InsertPreToTeam",TeamID,PreIADM);
	
	var Arr=ret.split("^");
	if (Arr[0]==0){
		$.messager.alert("��ʾ","�ϲ��ɹ�","success");
		//window.location.reload();
			var HospID=session['LOGON.HOSPID'];
			 var ComponentID=tkMakeServerCall("websys.Component","GetIdFromCodeOrDescription","DHCPESelectPreInfo")
			$("#tDHCPESelectPreInfo").datagrid('load',{ComponentID:ComponentID,RegNo:$("#RegNo").val(),Name:$("#Name").val(),TeamID:"",HospID:HospID});

	
		window.parent.$("#TeamPersonGrid").datagrid('load',{ClassName:"web.DHCPE.PreIADM",QueryName:"SearchGTeamIADM",GTeam:TeamID,RegNo:"",Name:"",DepartName:"",OperType:"",Status:""}); 
		var GroupID=TeamID.split("||")[0];
		window.parent.$("#TeamGrid").datagrid('load',{ClassName:"web.DHCPE.PreGTeam",QueryName:"SearchGTeam",ParRef:GroupID}); 

	}else{
		 $.messager.alert("��ʾ",Arr[1],"info");
	}
	

}
function BFind_click()
{
	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength");
	var RegNo=GetValue("RegNo","");
	if (RegNo.length<RegNoLength&&RegNo.length>0) { 
		RegNo=RegNoMask(RegNo);
		$("#RegNo").val(RegNo);
		}
	
	var Name=GetValue("Name","");
	var TeamID=GetValue("TeamID","");
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPESelectPreInfo&RegNo="+RegNo+"&Name="+Name+"&TeamID="+TeamID;
	//window.location.href=lnk;
	var HospID=session['LOGON.HOSPID'];
	//alert(HospID)
	var ComponentID=tkMakeServerCall("websys.Component","GetIdFromCodeOrDescription","DHCPESelectPreInfo") 
	$("#tDHCPESelectPreInfo").datagrid('load',{ComponentID:ComponentID,RegNo:RegNo,Name:$("#Name").val(),TeamID:TeamID,HospID:HospID});
	
}
function GetObj(Name)
{
	var obj=document.getElementById(Name);
	return obj;	
}

function GetValue(Name,Type)
{
	var Value="";
	var obj=GetObj(Name);
	if (obj){
		if (Type=="2"){
			Value=obj.innerText;
		}else{
			Value=obj.value;
		}
	}
	return Value;
}

function SelectRowHandler(index,rowdata)	
{	
	
	SelRow=rowdata
}




