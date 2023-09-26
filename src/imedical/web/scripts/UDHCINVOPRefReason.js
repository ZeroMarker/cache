////UDHCINVOPRefReason.js

function BodyLoadHandler() {
	var obj=document.getElementById("Add");
	if (obj){
		obj.onclick=Add_OnClick;
	}
	var obj=document.getElementById("Edit");
	if (obj){
		obj.onclick=Edit_OnClick;
	}
	DHCWeb_DisBtnA("Edit");
	var obj=document.getElementById("tUDHCINVOPRefReason");
	if (obj){
		obj.ondblclick=UDHCINVOPRefReason_OnDBClick;
	}
	
}

function UDHCINVOPRefReason_OnDBClick(){
	var tabOPList=document.getElementById('tUDHCINVOPRefReason');
	var selectrow=DHCWeb_GetRowIdx(window);
	if (selectrow<0){
		return;
	}
	var obj=document.getElementById("TCodez"+selectrow);
	var myTCode=DHCWebD_GetCellValue(obj);

	var obj=document.getElementById("TDescz"+selectrow);
	var myTDesc=DHCWebD_GetCellValue(obj);

	var obj=document.getElementById("TRowIDz"+selectrow);
	var myTRowID=DHCWebD_GetCellValue(obj);
	
	DHCWebD_SetObjValueB("Code",myTCode);
	DHCWebD_SetObjValueB("Desc",myTDesc);
	DHCWebD_SetObjValueB("RowID",myTRowID);
	DHCWeb_DisBtnA("Add");
	var obj=document.getElementById("Edit");
	if (obj){
		DHCWeb_AvailabilityBtnA(obj,Edit_OnClick)
		//obj.disabled=false;
		//obj.onclick=Edit_OnClick;
	}
	
}

function Add_OnClick(){
	var mystr=BuildStr();
	///alert(mystr);
	if (mystr==""){
		return;
	}
	
	var encmeth=DHCWebD_GetObjValue("AddEncrypt");
	if (encmeth!=""){
		var myrtn=cspRunServerMethod(encmeth,mystr)
		var myary=myrtn.split("^");
		if (myary[0]=="0"){
			alert(t["SaveOK"]);
			ReLoadH();
		}else{
			alert(t["SaveErr"]);
		}
	}
	
}

function ReLoadH(){
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCINVOPRefReason";
	location.href=lnk;
	
}

function Edit_OnClick(){
	var mystr=BuildStrEdit();
	if (mystr==""){
		return;
	}
	
	var encmeth=DHCWebD_GetObjValue("EditEcrypt");
	if (encmeth!=""){
		var myRowID=DHCWebD_GetObjValue("RowID");
		if (myRowID==""){
			return;
		}
		var myrtn=cspRunServerMethod(encmeth,myRowID, mystr)
		var myary=myrtn.split("^");
		if (myary[0]=="0"){
			alert(t["SaveOK"]);
			ReLoadH();
		}else if(myary[0]=="1"){
			alert("代码已存在,保存失败！");
			return;
			
		}else if(myary[0]=="2"){
			alert("描述已存在,保存失败！");
			return;
			
		}else{
			alert(t["SaveErr"]);
		}
		
	}
	
}

function BuildStr(){
	var mystr="";
	var myary=new Array();
	
	myary[0]=DHCWebD_GetObjValue("RowID");
	myary[1]=DHCWebD_GetObjValue("Code");
	myary[2]=DHCWebD_GetObjValue("Desc");
	var rtn=tkMakeServerCall("web.UDHCINVOPRefReason","GetReaNum",myary[1],myary[2])
	if (rtn==1)
	{
		alert("代码已经存在,不允许添加")
		return mystr
	}
	if (rtn==2)
	{
		alert("描述已经存在,不允许添加")
		return mystr
	}
	if (myary[2]!=""){
		mystr=myary.join("^");
	}
	
	return mystr;
	
}
function BuildStrEdit(){
	var mystr="";
	var myary=new Array();
	
	myary[0]=DHCWebD_GetObjValue("RowID");
	myary[1]=DHCWebD_GetObjValue("Code");
	myary[2]=DHCWebD_GetObjValue("Desc");
	if (myary[2]!=""){
		mystr=myary.join("^");
	}
	return mystr;
	
}
document.body.onload = BodyLoadHandler;
