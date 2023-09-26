/////UDHCAccCol.CardColQuery.js
/////

function BodyLoadHandler(){
	var obj=document.getElementById("Clear");
	if (obj){
		obj.onclick=Clear_OnClick;
	}
	var obj=document.getElementById("CardNo");
	if (obj){
		obj.onkeydown=DHCWeb_Nextfocus;
	}
	var obj=document.getElementById("UserCode");
	if (obj){
		obj.onkeydown=DHCWeb_Nextfocus;
	}
	var obj=document.getElementById("StDate");
	if (obj){
		obj.onkeydown=DHCWeb_Nextfocus;
	}
	var obj=document.getElementById("EndDate");
	if (obj){
		obj.onkeydown=DHCWeb_Nextfocus;
	}
	var obj=document.getElementById("PAPMINo");
	if (obj){
		obj.onkeydown=DHCWeb_Nextfocus;
	}
	var obj=document.getElementById("PatName");
	if (obj){
		obj.onkeydown=DHCWeb_Nextfocus;
	}
	var obj=document.getElementById("Sex");
	if (obj){
		obj.onkeydown=DHCWeb_Nextfocus;
	}
	var obj=document.getElementById("tUDHCAccCol_CardColQuery");
	if (obj){
		obj.ondblclick=tUDHCAccColCardColQuery_OnDBClick;
	}
	websys_setfocus("PAPMINo");
}

function Clear_OnClick(){
	var lnk="";
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCAccCol.CardColQuery";
	
}

function tUDHCAccColCardColQuery_OnDBClick() {
	//
	////tRefundOrder_Click();
	///CalCurRefund();
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var eSrcAry=eSrc.id.split("z");
	var rowObj=getRow(eSrc);
	if (rowObj.tagName=='TH') return;
	var row=rowObj.rowIndex;
	var obj=document.getElementById('TPAPMINoz'+row)
	var myPAPMNo=DHCWebD_GetCellValue(obj);
	///alert(myPAPMNo);
	///InitPatInfo(ReloadFlag,SelectPatRowId,SelectAdmRowId)
	
	///Add Function In Opener Object 
	var mywin=opener;
	if (mywin){
		
		var obj=mywin.document.getElementById("RegNo");
		if (obj){
			
			obj.value=myPAPMNo;
		}
		window.close();
		mywin.ReadAccInfo();
		
	}
	
}


function RefreshDoc(){
	
	
}

///document.onkeydown = DHCWeb_EStopSpaceKey;
document.body.onload = BodyLoadHandler;

