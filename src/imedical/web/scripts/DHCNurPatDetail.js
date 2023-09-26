document.write("<script language='javascript' src='../scripts/nurse/DHCNUR/DHCNurPrintClickOnce.js'></script>");

var DHCCNursePrintComm = document.getElementById("DHCCNursePrintComm")
var PatName = document.getElementById("PatName");
var Sex = document.getElementById("Sex");
var AdmDate = document.getElementById("AdmDate");
var BedNo = document.getElementById("BedNo");
var Age = document.getElementById("Age");
var RegNo = document.getElementById("RegNo");
var SumPrice = document.getElementById("SumPrice");
var Deposit = document.getElementById("Deposit");
var Adm = document.getElementById("EpisodeId").value;
var Ctloc = document.getElementById("Ctloc");
var CardNo = document.getElementById("CardNo");
var SfTyp = document.getElementById("SfTyp");
var Doc = document.getElementById("Doc");
var lxman = document.getElementById("lxman");
var homtel = document.getElementById("homtel");
var MedCareNo = document.getElementById("MedCareNo");
var National = document.getElementById("National");
var Address = document.getElementById("Address");
var PatLevel = document.getElementById("PatLevel");
var EncryptLevel = document.getElementById("EncryptLevel");
var IDNumber = document.getElementById("IDNumber");
var mainNurseId1 = "";
var mainNurseId2 = "";
var docId = "";
var ctLocId = document.getElementById("ctLocId");
ctLocId.value = tkMakeServerCall("web.DHCMainNurse", "GetPatLocId", Adm);

function BodyLoadHandler() {
	var btclose = document.getElementById("BtClose");
	if (btclose) btclose.onclick = funclose;

	if (Adm == "")
		return;
	var NurPatInfo = document.getElementById("NurPatInfo").value;
	var res = cspRunServerMethod(NurPatInfo, Adm);
	var temp = res.split("^");
	//alert(temp)
	PatName.value = temp[0];
	Sex.value = temp[1];
	AdmDate.value = temp[5];
	BedNo.value = temp[3];
	Age.value = temp[2];
	RegNo.value = temp[4];
	SumPrice.value = temp[6];
	Deposit.value = temp[7];
	Ctloc.value = temp[10];
	CardNo.value = temp[12];
	SfTyp.value = temp[9];
	Doc.value = temp[11];
	lxman.value = temp[17];
	homtel.value = temp[14];
	MedCareNo.value = temp[15];
	National.value = temp[16];
	Address.value = temp[13];
	PatLevel.value = temp[20];
	EncryptLevel.value = temp[21];
	IDNumber.value=temp[22];

	//添加更新医生 护士功能
	var update = document.getElementById("update");
	update.onclick = update_Click;

	var RetWardNurse = tkMakeServerCall("web.DHCMainNurse", "GetWardNurse", Adm);
	if (RetWardNurse != "") {
		var WardNurse = RetWardNurse.split("^");
		var mainNurse1 = document.getElementById("NurseDesc");
		if (mainNurse1) {
			mainNurse1.value = WardNurse[2];
		}
		mainNurseId1 = WardNurse[3];
		var mainNurse2 = document.getElementById("NurseDesc2");
		if (mainNurse2) {
			mainNurse2.value = WardNurse[4];
		}
		mainNurseId2 = WardNurse[5];

	}
	var PrintWDobj = document.getElementById("PrintWD");
	if (PrintWDobj) {
		PrintWDobj.onclick = printWD;
		var flag = tkMakeServerCall("web.UDHCJFIPReg", "GetWDPrintFlag");
		if (flag != 2) {
			PrintWDobj.style.display = "none"
		}
	}
	//q $G(PatName)_"^"_$G(Sex)_"^"_$G(Age)_"^"_$G(BedCode)_"^"_$G(RegNo)_"^"_$G(AdmDate)_"^"_$G(total)_"^"_$G(depos)_"^"_$G(warrant)_"^"_$G(admreason)_"^"_$G(ctloc)_"^"_$G(docdes)_"^"_$G(CardNo)
	JudgeAccess()
}

function printWD() {
	//DHCCNursePrintComm.
	showNurseExcuteSheetPreview(Adm, "PrintWD", "O", "", session['WebIP'], "true", 1, "NurseOrder.xml");
}

function docLookUp(info) {
	var info = info.split("^")
	docId = info[0];
	Doc.value = info[1];

}

function mainNurseLookUp1(info) {
	var info = info.split("^")
	setMainNurse(info[1], "NurseDesc")
	mainNurseId1 = info[0];
}

function mainNurseLookUp2(info) {
	var info = info.split("^")
	setMainNurse(info[1], "NurseDesc2")
	mainNurseId2 = info[0];

}

function setMainNurse(desc, elementId) {
	var mainNurse = document.getElementById(elementId);
	if (mainNurse) {
		mainNurse.value = desc;
	}
}

function funclose() {
	window.close();

}

function update_Click() {

	var type = tkMakeServerCall("Nur.DoctorOrderSheet", "getCtcpType", session['LOGON.USERID'])
	if (type != "NURSE") {
		alert("医护人员不是NURSE,不能更新主管护士医生")
		return;
	}
	var mainNurse1 = document.getElementById("NurseDesc");
	if (mainNurse1 && (mainNurse1.value == "")) {
		mainNurseId1 = ""
	}
	var mainNurse2 = document.getElementById("NurseDesc2");
	if (mainNurse2 && (mainNurse2.value == "")) {
		mainNurseId2 = ""
	}
	var ret1 = tkMakeServerCall("web.DHCMainNurse", "UpdateMainNurse", Adm, mainNurseId1, mainNurseId2);
	var ret2 = 0
	if ((docId != "") && (Adm != "")) {
		var ret2 = tkMakeServerCall("web.DHCMainNurse", "UpdateDoc", Adm, docId, ctLocId.value, session['LOGON.USERID']);
	}

	if ((ret1 == 0) && (ret2 == 0)) {
		alert("更新成功");

	} else {
		alert("更新失败")
	}
	funclose();
	if (opener) {
		opener.location.reload();
	}


}

/// 20150324 
function JudgeAccess() {
	var AccessFlag = document.getElementById("AccessFlag").value;
	if (AccessFlag != "") {
		//alert("没有权限更新主管医生,主管护士!")
		var obj = document.getElementById("update");
		if (obj) {
			obj.style.display="none";
			obj.onclick = function() {
				return false;
			}
		}
		return;
	}
}



document.body.onload = BodyLoadHandler;