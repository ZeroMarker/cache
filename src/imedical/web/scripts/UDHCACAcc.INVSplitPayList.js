////UDHCACAcc.INVSplitPayList.js

function BodyLoadHandler()
{
	///alert("dd");
	IntDoc();
	
}

function IntDoc()
{
	var mytabobj=document.getElementById("tUDHCACAcc_INVSplitPayList");
	var myRows=DHCWeb_GetTBRows("tUDHCACAcc_INVSplitPayList");
	if (myRows>0){
		for (var i=1;i<=myRows;i++){
			var mytobj=document.getElementById("TINVSFlagz"+i);
			if (mytobj){
				mytobj.onkeypress=DHCWeb_SetLimitNum;
				DHCWebD_SetListValueA(mytobj,"1");
			}
		}
	}
	
	///var mystr=BuildSpiltPRTStr();
	///alert(mystr);
}

function BuildSpiltPRTStr(){
	var myary=new Array();
	
	var mystr="";
	var myrtn=CheckPRTRID();
	if (!myrtn){
		alert(t["SetINVAry"]);
		return mystr;
	}
	
	var myRows=DHCWeb_GetTBRows("tUDHCACAcc_INVSplitPayList");
	for (var i=1;i<=myRows;i++){
		var mytobj=document.getElementById("TINVSFlagz"+i);
		var myvalue=DHCWebD_GetCellValueA(mytobj);
		var mytobj=document.getElementById("PrtRowIDz"+i);
		var myPRTRowID=DHCWebD_GetCellValueA(mytobj);
		if ((myary.length-1)<myvalue){
			myary[myvalue]="";
			myary[myvalue]=myPRTRowID;
		}else{
			myary[myvalue]+="^"+myPRTRowID;
		}
		
	}
	
	mytmpstr=myary.join(String.fromCharCode(2));
	var mytmpary=new Array();
	
	myary=mytmpstr.split(String.fromCharCode(2));
	var mylen=myary.length;
	for (var i=0;i<mylen;i++){
		var mytmpstr=myary[i];
		if (mytmpstr!=""){
			mytmpary[mytmpary.length]=mytmpstr;
		}
	}
	
	mystr=mytmpary.join(String.fromCharCode(2));
	
	return mystr;
}

function CheckPRTRID(){
	var myrtn=true;
	var myRows=DHCWeb_GetTBRows("tUDHCACAcc_INVSplitPayList");
	for (var i=1;i<=myRows;i++){
		var mytobj=document.getElementById("TINVSFlagz"+i);
		var myvalue=DHCWebD_GetCellValueA(mytobj);
		
		if (myvalue==""){
			myrtn=false;
			break;
		}
	}
	return myrtn;
}

document.body.onload=BodyLoadHandler;
