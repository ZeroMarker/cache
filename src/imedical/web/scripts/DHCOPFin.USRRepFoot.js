////DHCOPFin.USRRepFoot.js

function BodyLoadHandler(){
	var obj=document.getElementById("SSUSRName");
	if (obj){
		obj.size=1;
		obj.multiple=false;		
		obj.onchange=SSUSRName_OnChange;
	}
	
	var obj=document.getElementById("Query");
	if (obj){
		obj.onclick=Query_Click;
	}
	//var obj=document.getElementById("FinFoot");
	///if (obj){
	///	obj.onclick=FinFoot_Click;
	///}
	DHCWeb_DisBtnA("FinFoot");
	var obj=document.getElementById("FinPrint");
	if (obj){
		obj.onclick=FinPrint_Click;
	}
	
	var obj=document.getElementById("Calculate");
	if (obj){
		obj.onclick=FootExpCalculate;
	}
	
	IntDoc();
	
	
}

function FootExpCalculate()	{
	var myTotSum="";
	var obj=document.getElementById("HandSum");
	if (obj){
		myTotSum=obj.value;
	}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPCashExpCal&OperFootSum="+myTotSum;
	var NewWin=open(lnk,"udhcOPCashExpCal","scrollbars=no,resizable=no,top=100,left=100,width=800,height=460");
}


function IntDoc(){
	DHCWebD_ClearAllListA("SSUSRName");
	var encmeth=DHCWebD_GetObjValue("ReadUserEncrypt");
	var myGRPRowID=DHCWebD_GetObjValue("GrpRowID");
	var myExpStr="";
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","SSUSRName", myGRPRowID, myExpStr);
	}
	
	SSUSRName_OnChange();
}

function Query_Click(){
	RefreshData();
	
}

function FinFoot_Click(){
	var myrtn=confirm(t["SaveTip"]);
	if (myrtn==false){
		return;
	}
	
	DHCWeb_DisBtnA("FinFoot");
	var myUDR=DHCWebD_GetObjValue("UserRowID");
	var myFootDR=session['LOGON.USERID'];
	var myStDate=DHCWebD_GetObjValue("StDate");
	var myStTime=DHCWebD_GetObjValue("StTime");
	var myEndDate=DHCWebD_GetObjValue("EndDate");
	var myEndTime=DHCWebD_GetObjValue("EndTime");
	
	var encmeth=DHCWebD_GetObjValue("SaveRepEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,myUDR,myFootDR,myStDate,myStTime,myEndDate, myEndTime);
	}
	if (rtn="0"){
		alert(t["FootOK"]);
	}else{
		alert(t["FootFail"]);
		var obj=document.getElementById("FinFoot");
		if (obj){
			obj.disabled=false;
			obj.onclick=FinFoot_Click;
		}
	}
}

function FinPrint_Click(){
	
}

function SSUSRName_OnChange()
{
	var obj=document.getElementById("SSUSRName");
	var myIdx=obj.selectedIndex;
	var mUserDR=obj.options[myIdx].value;
	var obj=document.getElementById("UserRowID");
	obj.value=mUserDR;
	
	RefreshData();
	
	///alert(obj.value);
}

function RefreshData()
{
	DHCWeb_DisBtnA("FinFoot");
	var myUser=DHCWebD_GetObjValue("UserRowID");
	var encmeth=DHCWebD_GetObjValue("ReadDateEncrypt");
	if (encmeth!=""){
		var mystr=cspRunServerMethod(encmeth,myUser);
		var myary=mystr.split("^");
		if (myary[0]!="0"){
			return;
		}
		DHCWebD_SetObjValueB("StDate",myary[1]);
		DHCWebD_SetObjValueB("StTime",myary[2]);
		DHCWebD_SetObjValueB("EndDate",myary[3]);
		DHCWebD_SetObjValueB("EndTime",myary[4]);
		if (myary[5]!="0"){
			var obj=document.getElementById("FinFoot");
			if (obj){
				obj.disabled=false;
				obj.onclick=FinFoot_Click;
			}
		}
		var href="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPFin.USRRepFootDetail&UserRowID="+myUser+"&StDate="+myary[1]+"&StTime="+myary[2]+"&EndDate="+myary[3]+"&EndTime="+myary[4];
		///alert(href);
		var myWin=parent.frames['DHCOPFin_USRRepFootDetail'];
		myWin.location.href=href;
	}
}

document.body.onload = BodyLoadHandler;
