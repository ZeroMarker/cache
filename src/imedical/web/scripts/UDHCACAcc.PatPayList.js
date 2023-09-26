////UDHCACAcc.PatPayList.js
var myGHflag = ""
var selNum = 0

function BodyLoadHandler() {
	//RefreshDoc();
	setTimeout("RefreshDoc()", 200);
}

function BulidPLStr() {
	// add hujunbin 14.12.5 添加医保结算标志
	selNum = 0;
	myGHflag = DHCWebD_GetObjValue("GHFlag");
	var myRLStr = "";
	var myRows = DHCWeb_GetTBRows("tUDHCACAcc_PatPayList");
	for (var i = 1; i < myRows + 1; i++) {
		var obj = document.getElementById("SelFlagz" + i);
		var mySelFlag = DHCWebD_GetCellValue(obj);
		if (mySelFlag) {
			//selNum = selNum + 1;
			var obj = document.getElementById("PLRowIDz" + i);
			var myRLRowID = DHCWebD_GetCellValue(obj);
			myRLStr += myRLRowID + "^";
			
			/*wangjian 注释 不从前台控制 如果有自助机标志 后台赋值OPFC_OneToManyFlag=1
			if(myGHflag == "1" && selNum == 1){
				alert("自助医保收费只能一条一条打!");
			}
			if (myGHflag == "1" && selNum > 1) {
				document.getElementById("SelFlagz" + i).checked = false;
				
			} else {
				myRLStr += myRLRowID + "^";
				
			}
			*/
		}
	}
	return myRLStr;
}

function SetSelFlagDis() {
	var myRLStr = "";
	var myRows = DHCWeb_GetTBRows("tUDHCACAcc_PatPayList");
	for (var i = 1; i < myRows + 1; i++) {
		var obj = document.getElementById("SelFlagz" + i);
		obj.disabled = true;
	}
}

function SelectRowHandler() {
	RefreshDoc();
}

function RefreshDoc() {
	
	var myRows = DHCWeb_GetTBRows("tUDHCACAcc_PatPayList");
	if(myRows<1){
		var prtobj = parent.frames['UDHCACAcc_PatPayINVPrt'];
		prtobj.window.location.reload();
		return;
	}
	var myRLStr = BulidPLStr();
	var myPLListStr = DHCWebD_GetObjValue("PLListStr");
	
	if (myRLStr == myPLListStr) {
		return;
	}
	var obj = document.getElementById("PLListStr");
	if (obj) {
		obj.value = myRLStr;
	}
	var myFrameFlag = DHCWebD_GetObjValue("FrameFlag");
	var myAccRowID = DHCWebD_GetObjValue("AccRowID");
	switch (myFrameFlag) {
		case "ColPrt":
			PatPayINVPrtForPrt(myAccRowID, myRLStr);
			break;
		case "Foot":
			SetSelFlagDis();
			break;
		default:
			SetSelFlagDis();
			break;
	}

}

function PatPayINVPrtForPrt(AccRowID, PLRowIDSTr) {
	var myUnYBFlag = 0;
	var obj = document.getElementById("UnYBPatType");
	if (obj) {
		myUnYBFlag = obj.value;
	}
	//alert(AccRowID+"%"+PLRowIDSTr);
	var PAPMIRowID=document.getElementById("PAPMIRowID").value;
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCACAcc.PatPayINVPrt&AccRowID=" + AccRowID + "&PLRowIDStr=" + PLRowIDSTr;
	lnk += "&UnYBPatType=" + myUnYBFlag;
	lnk+="&PAPMIRowID="+PAPMIRowID;
	
	var Prtobj = parent.frames['UDHCACAcc_PatPayINVPrt'];
	///Prtobj.location.href=lnk;
	

	var obj = Prtobj.document.getElementById("AccRowID");
	if (obj) {
		obj.value = AccRowID;
	}
	var obj = Prtobj.document.getElementById("APLRowIDStr");
	if (obj) {
		obj.value = PLRowIDSTr;
	}
	//add hujunbin 14.12.5 添加医保结算标志
	var obj = Prtobj.document.getElementById("GHFlag");
	if (obj) {
		obj.value = myGHflag;
	}
	var mywin = Prtobj.window;
	mywin.IntDocument();
	mywin.ParseINVInfo();

}

function SelectAll(myCheck) {
	///var myRLStr="";
	var myRows = DHCWeb_GetTBRows("tUDHCACAcc_PatPayList");
	for (var i = 1; i < myRows + 1; i++) {
		var obj = document.getElementById("SelFlagz" + i);
		///var mySelFlag=DHCWebD_GetCellValue(obj);
		DHCWebD_SetListValueA(obj, myCheck);
	}
	SelectRowHandler();

}


document.body.onload = BodyLoadHandler;