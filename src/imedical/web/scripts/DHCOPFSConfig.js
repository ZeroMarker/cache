///DHCOPFSConfig.js

function BodyLoadHandler() {
	var obj = document.getElementById("Update");
	if (obj) {
		obj.onclick = Save_Click;
	}
	var obj = document.getElementById("AICAdd");
	if (obj) {
		obj.onclick = Add_Click;
	}
	var obj = document.getElementById("AICDel");
	if (obj) {
		obj.onclick = Delete_Click;
	}
	var obj = document.getElementById("DelUnAuditOrderCate");
	if (obj) {
		obj.onclick = DelUnAuditOrderCate_Click;
	}
	var obj = document.getElementById("AddUnAuditOrderCate");
	if (obj) {
		obj.onclick = AddUnAuditOrderCate_Click;
	}
	var obj = document.getElementById("ItemFlag");
	if (obj) {
		//obj.onclick = ItemFlag_OnClick;
	}
	//+2017-09-05 ZhYW
	var obj = document.getElementById("HandinEndTime");
	if (obj){
		obj.onblur = checkIsTime;
	}
	//DHCWeb_DisBtnA("ItemFlag");
	InitDoc();
	document.onkeydown = DHCWeb_EStopSpaceKey;

}

function InitDoc() {

	DHCWebD_ClearAllListA("UseFareType");
	var obj = document.getElementById("UseFareType");
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
	}

	var encmeth = DHCWebD_GetObjValue("ReadUseFareTypeEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "UseFareType");
	}

	DHCWebD_ClearAllListA("BILLVersion");
	var obj = document.getElementById("BILLVersion");
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
		obj.disabled = true;
	}
	
	var encmeth = DHCWebD_GetObjValue("ReadBILLVersionEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "BILLVersion");
	}
	
	/*
	DHCWebD_ClearAllListA("AppComFlag");
	var obj = document.getElementById("AppComFlag");
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
	}
	
	var encmeth = DHCWebD_GetObjValue("ReadAppComFlagEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "AppComFlag");
	}

	DHCWebD_ClearAllListA("AppOEFlag");
	var obj = document.getElementById("AppOEFlag");
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
	}
	var encmeth = DHCWebD_GetObjValue("ReadAppOEFlagEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "AppOEFlag");
	}

	DHCWebD_ClearAllListA("AppFlag");
	var obj = document.getElementById("AppFlag");
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
	}
	var encmeth = DHCWebD_GetObjValue("ReadAppFlagEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "AppFlag");
	}
	*/
	DHCWebD_ClearAllListA("OutSearchDateFlag");
	var obj = document.getElementById("OutSearchDateFlag");
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
	}
	
	var encmeth = DHCWebD_GetObjValue("ReadOutSearchDateFlagEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "OutSearchDateFlag");
	}

	DHCWebD_ClearAllListA("EmergencySearchDateFlag");
	var obj = document.getElementById("EmergencySearchDateFlag");
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
	}
	
	var encmeth = DHCWebD_GetObjValue("ReadEmergencySearchDateFlagEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "EmergencySearchDateFlag");
	}

	var encmeth = DHCWebD_GetObjValue("ReadOPFSEncrypt");
	if (encmeth != "") {
		var rtnvalue = (cspRunServerMethod(encmeth));
		//All  -1
		var myary = rtnvalue.split("^");
		DHCWebD_SetObjValueA("SiteCode", myary[2]);
		//
		DHCWebD_SetObjValueB("ItemFlag", parseInt(myary[17]));
		//OPFC_OrdSIFlag   OPFC_OrdSIFlag
		DHCWebD_SetObjValueB("ItemFlag", parseInt(myary[17]));
		var myAICStr = myary[18];
		var myary1 = myAICStr.split(String.fromCharCode(2));
		var mylen = myary1.length;

		DHCWebD_SetObjValueB("OutTimeRange", parseInt(myary[24]));
		DHCWebD_SetObjValueB("EmergencyTimeRange", parseInt(myary[26]));
		DHCWebD_SetObjValueB("YBConFlag", parseInt(myary[12]));
		DHCWebD_SetObjValueB("PRTYBConFlag", parseInt(myary[15]));
		DHCWebD_SetObjValueB("AuditSpaceTime", parseInt(myary[27]));
		//+2017-09-05 ZhYW
		DHCWebD_SetObjValueB("HandinEndTime", myary[34]);
		//
		DHCWebD_SetObjValueB("RcptUserFlag", parseInt(myary[40]));
		
		//add by xiongwang 2018-03-14
		DHCWebD_SetObjValueB("OPTransfer", parseInt(myary[45]));
		DHCWebD_SetObjValueB("IPTransfer", parseInt(myary[46]));
	}
	DHCWebD_ClearAllListA("NSelArcItmCat");

	var encmeth = DHCWebD_GetObjValue("ReadNotSetLEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "NSelArcItmCat");
	}

	DHCWebD_ClearAllListA("SelItemCat");

	var encmeth = DHCWebD_GetObjValue("ReadSelListEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "SelItemCat");
	}
	//增加免审核退费子类 add by wanghc
	DHCWebD_ClearAllListA("OrderCateList")
	var encmeth = DHCWebD_GetObjValue("UnAuditOrderCateEncr");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "OrderCateList");
	}
	DHCWebD_ClearAllListA("UnAuditOrderCateList");
	var encmeth = DHCWebD_GetObjValue("UnAuditOrderCateEncr");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "UnAuditOrderCateList");
	}
	
	var obj = document.getElementById("OESkinRtnFlag");
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
	}
	ReLoadListBoxData("OESkinRtnFlag", "ReadOESkinRtnFlagEncrypt");

	var obj = document.getElementById("OEORDLimitFootFlag");
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
	}
	ReLoadListBoxData("OEORDLimitFootFlag", "ReadOEORDLimitFootFlag");

	//ItemFlag_OnClick();

	DHCWebD_ClearAllListA("AuditingMode");
	var obj = document.getElementById("AuditingMode");
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
		//obj.onchange = AuditingMode_OnChange;
	}
	var encmeth = DHCWebD_GetObjValue("ReadAuditModeListBroker");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "AuditingMode");
	}
	var PrtGuideFlagObj = document.getElementById("PrtGuideFlag");
	if (PrtGuideFlagObj) {
		PrtGuideFlagObj.options[0] = new Option("", "N");
		PrtGuideFlagObj.options[1] = new Option("收费", "F");
		PrtGuideFlagObj.options[2] = new Option("医生站", "D");
		PrtGuideFlagObj.multiple = false;
		PrtGuideFlagObj.size = 1;
		PrtGuideFlagObj.onchange = PrtGuideFlag_OnChange;
	}
	var encmeth = DHCWebD_GetObjValue("ReadPrtGuideFlagListBroker");

	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "PrtGuideFlag");
	}
	
	//AuditingMode_OnChange();
	//SetAuditReadOnly();
}

function PrtGuideFlag_OnChange() {
	
}

function ReLoadListBoxData(ListName, ListEncrypt) {
	DHCWebD_ClearAllListA(ListName);
	var encmeth = DHCWebD_GetObjValue(ListEncrypt);
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", ListName);
	}
}

function ItemFlag_OnClick() {
	var myRecFlag = DHCWebD_GetObjValue("ItemFlag");
	if (myRecFlag) {
		var obj = document.getElementById("NSelArcItmCat");
		if (obj) {
			obj.disabled = false;
		}
		var obj = document.getElementById("SelItemCat");
		if (obj) {
			obj.disabled = false;
		}
		var obj = document.getElementById("AICAdd");
		if (obj) {
			obj.disabled = false;
			obj.onclick = Add_Click;
		}
		var obj = document.getElementById("AICDel");
		if (obj) {
			obj.disabled = false;
			obj.onclick = Delete_Click;
		}

	} else {
		DHCWeb_DisBtnA("NSelArcItmCat");
		DHCWeb_DisBtnA("SelItemCat");
		DHCWeb_DisBtnA("AICAdd");
		DHCWeb_DisBtnA("AICDel");
	}
}

function DelUnAuditOrderCate_Click() {
	DHCWeb_TransListData("UnAuditOrderCateList", "OrderCateList");
}

function AddUnAuditOrderCate_Click() {
	DHCWeb_TransListData("OrderCateList", "UnAuditOrderCateList");
}

function Add_Click() {
	DHCWeb_TransListData("NSelArcItmCat", "SelItemCat");
}

function Delete_Click() {
	DHCWeb_TransListData("SelItemCat", "NSelArcItmCat");
}

function Save_Click() {
	var flag = checkIsTime();
	if (!flag) {
		return;
	}
	var mystr = BuildStr();
	var myExpStr = "";
	var encmeth = DHCWebD_GetObjValue("SaveParaEncrypt");
	if (encmeth != "") {
		var rtnvalue = (cspRunServerMethod(encmeth, mystr, myExpStr));
		alert(t["SaveOK"]);
	}
}

function BuildStr() {
	var myary = new Array();
	///OPFC_WebConDR                          Refer WebConSys               2      xx
	///OPFC_SiteCode                          OPFC_SiteCode                 3      xx
	///OPFC_ItemFlag                          OPFC_ItemFlag                 4      xx
	///OPFC_ReclocFlag                        OPFC_ReclocFlag               5      xx
	///OPFC_PresNoFlag                        OPFC_PresNoFlag               6      xx
	///OPFC_RecInvCount                       OPFC_RecInvCount              7      xx
	///OPFC_PrintCount                        OPFC_PrintCount               8      xx
	///OPFC_HerbalFlag                        OPFC_HerbalFlag               9      xx
	///OPFC_HerbalDesc                        OPFC_Node2                    10     xk
	///OPFC_HerbalNum                         OPFC_Node3                    11     xx
	///OPFC_Version                           OP version Info               12     xx
	///OPFC_YBConFlag                         OPFC_YBConFlag                13
	///OPFC_AdmFlag                           OPFC_AdmFlag                  14     x
	///OPFC_AppFlag                           OPFC_AppFlag                  15     x
	///OPFC_PRTYBConFlag                      OPFC_PRTYBConFlag             16     xx
	///OPFC_RoundDownNum                      OPFC_RoundDownNum             17

	///OPFC_OrdSIFlag                         OPFC_OrdSIFlag                18     xx

	myary[16] = DHCWebD_GetObjValue("ItemFlag");
	///OPFC_ARCICatStr                        OPFC_ARCICatStr               19     xx
	///opfc_prtguideflag	                                                44  20151118
	var myarcstr = "";
	var obj = document.getElementById("SelItemCat");
	if (obj) {
		var mylen = obj.options.length;
		for (var i = 0; i < mylen; i++) {
			if (myarcstr == "") {
				myarcstr = obj.options[i].value;
			} else {
				myarcstr = myarcstr + String.fromCharCode(2) + obj.options[i].value;
			}
		}
	}
	myary[17] = myarcstr;
	if (myary[16] == true) {
		myary[16] = 1;
	} else {
		myary[16] = 0;
	}
	myary[11] = DHCWebD_GetObjValue("YBConFlag");
	if (myary[11] == true) {
		myary[11] = 1;
	} else {
		myary[11] = 0;
	}
	myary[14] = DHCWebD_GetObjValue("PRTYBConFlag");
	if (myary[14] == true) {
		myary[14] = 1;
	} else {
		myary[14] = 0;
	}

	//OPFC_AppFlag                           OPFC_AppFlag                  15
	//myary[13] = DHCWeb_GetListBoxValue("AppFlag");
	myary[13] = DHCWeb_GetListBoxValue("AuditingMode");   //+2018-11-19 

	//OPFC_UseFareType                       OPFC_Use the Fare Type        20
	myary[18] = DHCWeb_GetListBoxValue("UseFareType");
	//OPFC_BILLVersion                       OPFC_BILL Version             21
	myary[19] = DHCWeb_GetListBoxValue("BILLVersion");
	//OPFC_AppComFlag                        OPFC_Approve Combination Fla  22
	myary[20] = "";   //DHCWeb_GetListBoxValue("AppComFlag");
	//OPFC_AppOEFlag                         OPFC_ Approve OE_OrdItem Sta  23
	myary[21] = "";   //DHCWeb_GetListBoxValue("AppOEFlag");
	//OPFC_OutSearchFlag                     OPFC_Out Patient Search flag  24
	myary[22] = DHCWeb_GetListBoxValue("OutSearchDateFlag");
	//OPFC_OutTimeRange                      OPFC_Out Patient Search Time  25
	myary[23] = DHCWebD_GetObjValue("OutTimeRange");
	//OPFC_EmergencySearchFlag               OPFC_Emergency Patient Searc  26
	myary[24] = DHCWeb_GetListBoxValue("EmergencySearchDateFlag");
	//OPFC_EmergencyTimeRange                Emergency Patient Search Tim  27
	myary[25] = DHCWebD_GetObjValue("EmergencyTimeRange");
	//OPFC_AuditSpaceTime                    OPFC_AuditSpaceTime           28
	myary[26] = DHCWebD_GetObjValue("AuditSpaceTime");
	//OPFC_OESkinRtnFlag                     OPFC_OEORD SkinRtnFlag        29
	myary[27] = DHCWeb_GetListBoxValue("OESkinRtnFlag");
	//OPFC_OEORDLimitFootFlag                OPFC_OEORDLimitFootFlag       30
	myary[28] = DHCWeb_GetListBoxValue("OEORDLimitFootFlag");
	//+2017-09-05 ZhYW 
	myary[29] = DHCWebD_GetObjValue("HandinEndTime");
	
	var myarcstr = "";
	var obj = document.getElementById("UnAuditOrderCateList");
	if (obj) {
		var mylen = obj.options.length;
		for (var i = 0; i < mylen; i++) {
			if (myarcstr == "") {
				myarcstr = obj.options[i].value;
			} else {
				myarcstr = myarcstr + String.fromCharCode(2) + obj.options[i].value;
			}
		}
	}
	myary[30] = myarcstr;
	/*
	myary[31] = DHCWebD_GetObjValue("RcptUserFlag");  //收费员补录医嘱需要停医嘱退费
	if (myary[31] == true) {
		myary[31] = 1;
	} else {
		myary[31] = 0;
	}
	*/
	myary[31] = "";
	
	myary[32] = DHCWeb_GetListBoxValue("PrtGuideFlag"); //导诊单标志
	//add by xiongwang 2018-03-14
	myary[33] = DHCWebD_GetObjValue("OPTransfer");
	if (myary[33] == true) {
		myary[33] = 1;
	} else {
		myary[33] = 0;
	}
	//add by xiongwang 2018-03-14
	myary[34] = DHCWebD_GetObjValue("IPTransfer");
	if (myary[34] == true) {
		myary[34] = 1;
	} else {
		myary[34] = 0;
	}
	var myInfo = myary.join("^");
	return myInfo;
}

function AuditingMode_OnChange() {
	var myAuditFlag = DHCWeb_GetListBoxValue("AuditingMode");
	var myary = myAuditFlag.split("^");
	switch (myary[0]) {
	case "0":
		SetAuditDefault(1, 3, 0);
		var obj = document.getElementById("RcptUserFlag");
		if (obj) {
			obj.checked = false;
			obj.disabled = true;
		}
		break;
	case "1":
		SetAuditDefault(2, 3, 2);
		var obj = document.getElementById("RcptUserFlag");
		if (obj) {
			obj.disabled = false;
		}
		break;
	case "2":
		SetAuditDefault(3, 3, 2);
		var obj = document.getElementById("RcptUserFlag");
		if (obj) {
			obj.checked = false;
			obj.disabled = true;
		}
		break;
	case "3":
		SetAuditDefault(0, 2, 1);
		var obj = document.getElementById("RcptUserFlag");
		if (obj) {
			obj.checked = false;
			obj.disabled = true;
		}
		break;
	default:
		SetAuditDefault(1, 3, 0);
		break;
	}
}

function SetAuditDefault(myAppComFlag, myAppFlag, myAppOEFlag) {
	var obj = document.getElementById("AppComFlag");
	obj.options[myAppComFlag].selected = true;
	var obj = document.getElementById("AppFlag");
	obj.options[myAppFlag].selected = true;
	var obj = document.getElementById("AppOEFlag");
	obj.options[myAppOEFlag].selected = true;
}

function SetAuditReadOnly() {
	var obj = document.getElementById("AppComFlag");
	obj.disabled = true;
	var obj = document.getElementById("AppFlag");
	obj.disabled = true;
	var obj = document.getElementById("AppOEFlag");
	obj.disabled = true;
}

function BodyUnLoadHandler() {
	
}

/**
* Creator: ZhYW
* CreatDate: 2017-09-05
* Description: 校验时间
*/
function checkIsTime() {
	var obj = websys_$('HandinEndTime');
	var str = obj.value;
	if (str == "") {
		return true;
	}
	var reg = /^((20|21|22|23|[0-1]\d)\:[0-5][0-9])(\:[0-5][0-9])$/;
	var r = reg.test(str);
	if (!r) {
		websys_setfocus('HandinEndTime');
		obj.className = 'clsInvalid';
		return websys_cancel();
	}else {
		obj.className = 'clsvalid';
	}
	return true;
}

document.body.onload = BodyLoadHandler;
document.body.onunload = BodyUnLoadHandler;
