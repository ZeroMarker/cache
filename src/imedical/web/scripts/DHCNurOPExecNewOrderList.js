//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
document.write("<script language='javascript' src='../scripts/nurse/DHCNUR/DHCNurPrintClickOnce.js'></script>");
var selectedcontainer = null;
var dragEnabled = 0;
var orig_x = "";
var orig_y = "";
var winP = window.parent;
var cnt = 0
var mymodalwin;
var winHIDDEN = window.open('', 'TRAK_hidden');
var displayOnly = ""
var isEmLoc = ""
var isTempLoc = ""
var currentWardID = ""; //add wuqk 2010-07-26 
var ClientTyp;

function TrakIt_onmousedown(evt) {

    //if ((displayOnly.value == "Y") && (isEmLoc.value == "1")) return; //Log 63302
    websys_cancel();
    if (websys_getButton(evt) != "L") return;
    eSrc = getSelectedRoom(websys_getSrcElement(evt));

    if (eSrc.id == "") return;

    if ((eSrc.getAttribute('requestId') != "") && (eSrc.getAttribute('requestId') != null)) // add by ljk 2016-04-23 备血医嘱块不要单击勾选医嘱
    {

        var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurOPBloodOrdIssueList" + "&oeoriId=" + eSrc.id;
        window.open(lnk, "DHCNurOPBloodOrdIssueList", 'left=300,top=100,toolbar=no,location=no,directories=no,resizable=yes,width=1000,height=350');
        return;
    }

    var elPar = websys_getParentElement(eSrc);
    var execflag = parent.frames["NurseTop"].document.getElementById("exeFlag").checked;
    var count = countArray[eSrc.id]
    if ((count == "undefined") || (count == null)) return;

    if (websys_getSrcElement(evt).id == "dhcnuropexectable") return;
    if (eSrc.getAttribute('selectEnabled') == 0) {
        if (eSrc.getAttribute('showemeralert') == 1) alert(t['SelectEmergency']);
        return;
    }
    var p = websys_getParentElement(eSrc);
    if (eSrc.getAttribute('selected') == 1) {
        serverOrderID[count] = "" //医嘱id
        eSrc.setAttribute('selected', 0);
        //elPar.style.backgroundColor = "#73a3cf";
        elPar.style.backgroundImage = "url()";
 		elPar.style.border = "1px solid black"
        SearchSubOrder();
    } else {
        serverOrderID[count] = eSrc.id //医嘱id
        eSrc.setAttribute('selected', 1);
        elPar.style.backgroundImage = "url(../images/check_nurorder.gif)";
		elPar.style.backgroundRepeat ="no-repeat"; 
		elPar.style.backgroundSize ="220px 110px";
		elPar.style.backgroundPosition = "center";
        //elPar.style.border = "2px solid red"
        selOrdId = eSrc.id;
        SearchSubOrder(selOrdId);
    }
    //alert(serverOrderID)
}

function SearchSubOrder(selOrdId) {
 	var ordId = ""
 	if (selOrdId) {
 		ordId = selOrdId
 	} else {
 		return;
 	}
 	if (selOrdId.indexOf("^") > -1) {
 		return;
 	}
 	var OrdList = parent.frames["NurseTop"];
 	var wardId = OrdList.document.getElementById("wardId").value;
 	var regNo = OrdList.document.getElementById("regNo").value;
 	//if (EpisodeID!="") regNo=regNo+"^"+EpisodeID;
 	var locId = OrdList.document.getElementById("locId").value;
 	var queryTypeCode = OrdList.document.getElementById("queryTypeCode").value;
 	var HospitalRowId = OrdList.document.getElementById("HospitalRowId").value;
 	var stdate = OrdList.document.getElementById("startDate").value;
 	var edate = OrdList.document.getElementById("endDate").value;
 	var wardDesc = OrdList.document.getElementById("PacWard").value;
 	var Dept = OrdList.document.getElementById("Dept").value;
 	var ExeCheck = OrdList.document.getElementById("exeFlag").checked;
 	var exeFlag;
 	var gap = "";
 	if (ExeCheck == false) {
 		exeFlag = 0;
 	} else {
 		exeFlag = 1;
 	}
 	if (Dept == "") {
 		locId = "";
 	}
 	if (queryTypeCode == "") return;
 	var userId = session['LOGON.USERID'];
 	var reportType = OrdList.document.getElementById("ReportList").value;
 	var admType = OrdList.document.getElementById("admType").value;
 	var DetailFlag = "on"
 	parent.frames['OrdAttach'].location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurOPExecAttach" + "&wardId=-1&regNo=" + regNo + "&userId=" + userId + "&startDate=" + stdate + "&endDate=" + edate + "&queryTypeCode=" + queryTypeCode + "&admType=" + admType + "&exeFlag=" + ExeCheck + "&ReportType=" + reportType + "&DetailFlag=" + DetailFlag + "&ordId=" + ordId;
 }


function TrakIt_onmousemove(evt) {

    return false;
}



//NB: TN: in N6 on mouseover with a dragged item points to the dragged item instead of the intended object
function TrakIt_onmouseup(evt) {}

function clearSelectedPatient(eSrc) {
    //elPar.style.backgroundColor = "#73a3cf";
    var elPar = websys_getParentElement(eSrc);
    if (!elPar) return;
    var clsName = elPar.className.substring(0, 7)
    if (clsName == "waiting") elPar.className = "waitingPat";
    if (clsName == "bedNorm") elPar.className = "bedNorm";
    if (isTempLoc != "") {
        var objBody = document.getElementById(isTempLoc);
        if (objBody) objBody.className = objBody.className + " clsRowTempLoc";
    }
    eSrc.setAttribute('selected', 0);
    //winP.MainClearEpisodeDetails();
    selectedcontainer = null;
}

function getSelectedRoom(eSrc) {
    //alert(eSrc.id)
    if (eSrc.className == "room") return eSrc;
    var objRoom = websys_getParentElement(eSrc);
    if ((objRoom) && (objRoom.className == "clsRoomLink")) {
        return objRoom;
    }
    objRoom = eSrc;
    while (objRoom.getAttribute('selectEnabled') != 1) {
        if (websys_getParentElement(objRoom) == null) break;
        if (objRoom == document.body) break;
        if (websys_getParentElement(objRoom) == document.body) break;
        objRoom = websys_getParentElement(objRoom);
    }
    if (objRoom.getAttribute('selectEnabled')) {
        var arrDivsInBed = objRoom.getElementsByTagName("TABLE");
        if (arrDivsInBed.length > 0) objRoom = arrDivsInBed[0];
    }
    return objRoom;
}

function SnapBack(selectedcontainer, evt) {}

function OpenPACBedAdmWindow(eSrc) {}

function SelectBed(eSrc) {}

function GotoShortcutMenu(evt) {}

function ViewBedStatus(bedid) {
    //websys_createWindow("pacbedstatuschange.list.csp?PARREF="+bedid,"BEDSTAT");
}

function BodyOnloadHandler() {

    var objExecuteOnly = document.getElementById("executeOnly");
    if (objExecuteOnly) objExecuteOnly.onclick = ExecuteOnly;
    var objExecCancel = document.getElementById("CancelEx");
    if (objExecCancel) objExecCancel.onclick = CancelClick;
    var objPatInfoCard = document.getElementById("PatInfoCard");
    if (objPatInfoCard) objPatInfoCard.onclick = PatInfoCardClick;
    if (exeFlag == "1") {
        if (objExecuteOnly) {
            objExecuteOnly.style.display = "none";
        }
    } else {
        objExecCancel.style.display = "none";
    }
    var objPrintTPQ = document.getElementById("PrintTPQ");

    //if (objPrintTPQ && searchFlag == "true") {
    if (objPrintTPQ) {
        objPrintTPQ.onclick = PrintTPQList;
        objPrintTPQ.focus();
    }
    if (queryTypeCode.indexOf("SYDO") < 0) {
        if (objPrintTPQ) objPrintTPQ.style.display = "none";
    }
    //var objTreatQueue = document.getElementById("btnTreatQueue");
    //if (objTreatQueue) objTreatQueue.onclick = TreatQueueFn;
    //LoadClientList();
    var arr = document.getElementsByTagName("table");
    var execflag = parent.frames["NurseTop"].document.getElementById("exeFlag").checked;
    for (var i = 0; i < arr.length; i++) {
	    if(arr[i].id==""){
		    continue;
	    }
        var ele = arr[i];
        var elPar = websys_getParentElement(ele);
        if (execflag) {
	        var count=countArray[ele.id]
	        serverOrderID[count]=ele.id
            ele.setAttribute('selected', 1);
            //elPar.style.border = "2px solid red"
			elPar.style.backgroundImage = "url(../images/check_nurorder.gif)";
			elPar.style.backgroundRepeat ="no-repeat"; 
			elPar.style.backgroundSize ="220px 110px";
			elPar.style.backgroundPosition = "center";			
            //elPar.style.backgroundColor = "#dfdfff";
        } else {
            // 	if(ele.getAttribute('selected')==1){
            // 		var count=countArray[ele.id]
            // 		serverOrderID[count]=ele.id  //医嘱id
            // 		//elPar.style.backgroundColor = "#eeea88";
            // 		elPar.style.backgroundImage="url(../images/check_nurorder.gif)";
            // 	}
        }
    }
}

function myShowModal(url, name, params) {
    alert("myShowModal")
}

function checkModal() {

}

function ExecuteAndPrint() {
    ExecuteClick(true)
}

function ExecuteOnly() {
    ExecuteClick(false)
}

function CancelClick() {
    var objCancelEx = document.getElementById("CancelEx");
    if (objCancelEx) {
        objCancelEx.disabled = true;
        objCancelEx.onclick = function() {
            return false;
        }
    }
    var objtbl = document.getElementById('tDHCNurOPExec');
    var change = false;
    for (var i = 0; i < serverOrderID.length; i++) {
        var oeoriId = serverOrderID[i];
        var tmpOrderDataList = serverOrderData[i].split("^");
        var execDateTime = tmpOrderDataList[0];
        if (oeoriId != "") {
            var dispose = tmpOrderDataList[1];
            if ((dispose != "Exec") && (dispose != "ExecDiscon") && (dispose != "Needless")) {} else {
                change = true;
                var userId = session['LOGON.USERID'];
                var ordstat = tmpOrderDataList[6];
                var unexemth = document.getElementById("UndoDisconOrder").value;

                if (ordstat == "停止") { //discharged order
                    if (cspRunServerMethod(unexemth, oeoriId, userId) == '0') {}
                } else //discharge executed order
                {
                    var oecprDesc = tmpOrderDataList[7];
                    var updateOrdGroup = document.getElementById("UpdateOrdGroup").value;
                    var DateTime = tmpOrderDataList[5];
                    var flag;
                    flag = 0;
                    change = false;
                    var resStr = cspRunServerMethod(updateOrdGroup, DateTime, oeoriId, userId, flag);
                    if (resStr == '0') {
                        change = true;
                    } else alert(resStr)
                }
            }
        }
    }
    if (change) {
        alert("操作成功!");
    }
    self.location.reload();
}

function ExecuteClick(needPrint) {
    var DrugCell = ""; // + wxl 090301
    var objDrugCell = document.getElementById("DrugCell");
    if (objDrugCell) DrugCell = objDrugCell.value;
    if (((queryTypeCode == "SYDO") || (queryTypeCode == "ZSDO")) && (DrugCell == "")) {
        //alert(t['alert:shouldFillDrugCell']);
        //return;
    }
    // var obj = document.getElementById("OrdExecute");
    // if (obj) {
    // 	obj.disabled = true;
    // 	obj.onclick = function() {
    // 		return false;
    // 	}
    // }
    // var obj = document.getElementById("executeOnly");
    // if (obj) {
    // 	obj.disabled = true;
    // 	obj.onclick = function() {
    // 		return false;
    // 	}
    // }
    if (queryTypeCode == "Default") return;
    var userId = session['LOGON.USERID'];
    var ctlocId = session["LOGON.CTLOCID"];
    var objtbl = document.getElementById('tDHCNUROPEXEC');
    var updateOrdGroup = document.getElementById("UpdateOrdGroup").value;
    var oeoreParaStr, flag, oeoriIdStr = "",
        exeResult = false;
    var objPrintSeat = document.getElementById("printSeat");
    var objSeatNo = parent.frames["NurseTop"].document.getElementById("SeatNo");
    if (objSeatNo) var SeatNo = objSeatNo.value;
    else var SeatNo = "";
    oeoreParaStr = "";
    //alert(serverOrderID)
    var notFyStr = "";
    for (var i = 0; i < serverOrderID.length; i++) {
        var oeoriId = serverOrderID[i];
        var tmpOrderDataList = serverOrderData[i].split("^");
        var execDateTime = tmpOrderDataList[0];
        if ((oeoriId != "") && (execDateTime == "")) {
            disposeStatCode = tmpOrderDataList[1];
            if (disposeStatCode == "UnPaid") {
                alert("不能选择未交费医嘱!");
                self.location.reload();
                return;
            }

            var fyFlag = tkMakeServerCall("web.DHCOutPhCommon", "GetfyflagforNurse", oeoriId);
            if (fyFlag == "0") {
                notFyStr = "患者有未发药的医嘱,请到药房取药！";
                continue;
            }

            var arcimDesc = tmpOrderDataList[2];
            var tmpList = arcimDesc.split("____");
            if (tmpList.length < 2) {
                if ((queryTypeCode.indexOf("JYDO") > -1)) {
                    var obj = tmpOrderDataList[3];
                    if (obj != "") {
                        var placerNo = obj;
                    }
                }
                var basedose = "";
                var basedose = tmpOrderDataList[4];
                var sttDateTime = tmpOrderDataList[5];
                if ((sttDateTime == " ")) {
                    alert("要求执行为空！");
                    return false;
                } //ypz 060430
                oeoreParaStr = oeoreParaStr + "^" + basedose + "!" + oeoriId + "!!" + (i + 1);
                if (oeoriIdStr.length == 0) {
                    oeoriIdStr = oeoriId;
                } else {
                    oeoriIdStr = oeoriIdStr + "^" + oeoriId
                }
                flag = 1
                if ((queryTypeCode != "SYDO") || (!objPrintSeat)) {
                    var resStr, printed = false;
                    var userId = session['LOGON.USERID'];
                    var curExecStatDesc = "完成"; //stat.options[index].text;
                    if ((disposeStatCode != "Immediate") && (disposeStatCode != "LongNew") && (disposeStatCode != "Temp") && (disposeStatCode != "TempTest") && (disposeStatCode != "Discontinue") && (disposeStatCode != "Needless") && (disposeStatCode != "SkinTestNorm") && (disposeStatCode != "SkinTest")) {} else {
                        var ordstat = tmpOrderDataList[6];
                        if (ordstat == "停止") {} //
                        else {
                            var flag = 1; //SeatNo="";
                            var info = "";
                            //调用知识库
                            var ret = tkMakeServerCall("web.DHCLCNUREXCUTE", "CheckLibPha", oeoriId, userId, session['LOGON.CTLOCID'], session['LOGON.GROUPID']);
                            var alertInfoArray = ret.split("^")
                            if (alertInfoArray[0] != 0) {
                                var infoArray = alertInfoArray[1].split("!");
                                for (var k = 0; k < infoArray.length; k++) {
                                    var detailInfoArray = infoArray[k].split("@")
                                    if (k == 0) {
                                        info = detailInfoArray[0] + ":\r\n" + detailInfoArray[1]
                                    } else {
                                        info = info + "\r\n" + detailInfoArray[0] + ":\r\n" + detailInfoArray[1]
                                    }
                                }
                                //alert(info)

                            }
                            //resStr=cspRunServerMethod(updateOrdGroup,sttDateTime,oeoriId+"^"+SeatNo+"^"+ctlocId+"^^"+queryTypeCode,userId,flag);
                            resStr = cspRunServerMethod(updateOrdGroup, sttDateTime, oeoriId + "^" + SeatNo + "^" + ctlocId + "^^" + queryTypeCode + "^^^" + DrugCell, userId, flag); //+ wxl 090301
                            if (resStr == "0") {
                                exeResult = true;
                            } else {
                                alert(resStr);
                                exeResult = false;
                            }
                        }
                    }

                }
            }
        }
    }

    if (notFyStr != "") {
        alert(notFyStr);
    }

    if (oeoreParaStr == "") return;

    var objRegNo = parent.frames["NurseTop"].document.getElementById("regNo")
    var objPatMainInfo = parent.frames["NurseTop"].document.getElementById("patMainInfo")
    if ((queryTypeCode != "SYDO") || (!objPrintSeat)) {
        if (exeResult) {
            alert("操作成功");
            if (needPrint) {
                PrintClick();
                //self.location.reload()
                // setTimeout('parent.frames["NurseTop"].ClearScreen();',1000); //ypz 081216
            } // else self.location.reload();
            if (!getPatOrdByQueryCode()) // 如果除了全部医嘱单其他执行单中没有未执行的医嘱 则清屏
            {
                parent.frames["NurseTop"].ClearScreen();
            }
            self.location.reload();
        }
        self.location.reload();
        return;
    }
    oeoreParaStr = escape(oeoreParaStr);
    var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurOPExecAdmin" + "&execData=" + oeoreParaStr;
    //window.open(lnk,"Order_Exec","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,height=300,width=400,top=100,left=300");
    var ifSuccess = window.showModalDialog(lnk, window, "dialogWidth:400px;status:no;dialogHeight:300px");
    //alert(ifSuccess)
    if ((ifSuccess) && (needPrint)) PrintClick();

    if (needPrint) {
        if (objRegNo) objRegNo.value = "";
        if (objPatMainInfo) objPatMainInfo.value = "";
        parent.frames["NurseTop"].ClearScreen();
    }
    self.location.reload();
}

function TreatQueueFn(alertFlag) {
    var regNo = parent.frames["NurseTop"].document.getElementById("regNo").value;
    var TreatAdmDr = 0,
        insertTreatFlag = false;
    for (var i = 0; i < serverOrderID.length; i++) {
        var oeoriId = serverOrderID[i];
        var tmpOrderDataList = serverOrderData[i].split("^");
        var ExecStat = tmpOrderDataList[10];
        if (oeoriId != "") {
            if ((ExecStat == "已执行") || (ExecStat == "停止执行")) {
                //输液单没有未执行的不插入队列
            } else {
                if (TreatAdmDr < tmpOrderDataList[11]) {
                    TreatAdmDr = tmpOrderDataList[11]; //取就诊最近的一次
                }
            }
        }
    }
    if (TreatAdmDr == "") {
        if (alertFlag != false) {
            alert("请选择一条未执行的医嘱!");
        }
        return;
    }
    var objTreatSave = document.getElementById("TreatSave");
    if (objTreatSave) {
        var userId = session['LOGON.USERID'];
        var locId = session['LOGON.CTLOCID'];
		var seatFlag="";
		var serverIP ="";
		if(parent.parent.frames["TreatLeft"].document.getElementById("seatFlag")){
			seatFlag = parent.parent.frames["TreatLeft"].document.getElementById("seatFlag").value;
		}
		if(parent.parent.frames["TreatLeft"].document.getElementById("serverIP")){
			serverIP = parent.parent.frames["TreatLeft"].document.getElementById("serverIP").value;
		}
		if(seatFlag==""||serverIP=="") return;
		var ClientStr = tkMakeServerCall("web.DHCVISTreatQueue", "GetClientStr", serverIP);
		var start = new RegExp(/^\d+/);
		var ClientID = start.exec(ClientStr)
        var parr = "TreatLocDr|" + locId + "^TreatRecUser|" + userId + "^TreatQueState|Wait^TreatQuePrior|2^TreatQueDate|^TreatQueTime|" + "^TreatQueueCat|"+ClientID + "^TreatReportType|" + queryTypeCode + "^RegNo|" + regNo +"^SeatFlag|" + seatFlag + "^TreatServerIP|"+serverIP;
        var resStr = cspRunServerMethod(objTreatSave.value, "", parr);
        if (resStr != 0) {
            if (alertFlag != false) {
                alert(resStr);
            }
            return;
        } else {
            var regNo = parent.frames["NurseTop"].document.getElementById("regNo").value;

            //DHCCNursePrintComm.
			showOtherSingleSheet(regNo + "$" + TreatAdmDr + "$" + session['LOGON.CTLOCID'], "BedCard", session['WebIP'], "NurseOrderOP.xml");
            //PrintQueueNo(TreatAdmDr, locId, ClientId)
            if (parent.parent.frames["TreatLeft"]) {
                parent.parent.frames["TreatLeft"].RefreshFn();
            }
            var curAdm = tkMakeServerCall("Nur.Infusion.DHCIFWorkLoad", "getCurrAdm", regNo);
            if (queryTypeCode == "SYDO") {
                //插入工作量
                if (ClientTyp == "T1") {
                    //var ret = tkMakeServerCall("Nur.Infusion.DHCIFWorkLoad", "InsertWork", curAdm, 5, session['LOGON.USERID'], session['LOGON.CTLOCID'], 0, "O");
                } else {
                    //var ret = tkMakeServerCall("Nur.Infusion.DHCIFWorkLoad", "InsertWork", curAdm, 5, session['LOGON.USERID'], session['LOGON.CTLOCID'], 0, "E");
                }
            }
        }
    }
}

/*function LoadClientList() {
    ClientTyp = ""
    var IPAddress = GetComputerIp()
    if ((IPAddress != "Exception") && (IPAddress != "")) {
        ClientTyp = tkMakeServerCall("web.DHCVISQueueManage", "GetClientQueueType", IPAddress)
    } else {
        return;
    }
    if (ClientTyp == "") {
        var objBtnTreatQueue = document.getElementById("btnTreatQueue");
        if (objBtnTreatQueue) objBtnTreatQueue.style.display = "none";
    }
    //alert(ClientTyp);
}*/
/*
function LoadClientList() {
 	var ClientStr = ""
 	var IPAddress = GetComputerName()
 	ClientTyp = "";
 	if ((IPAddress != "Exception") && (IPAddress != "")) {
 		var ClientStr = tkMakeServerCall("web.DHCVISTreatQueue", "GetClientStr", IPAddress)
 		ClientTyp = tkMakeServerCall("web.DHCVISQueueManage", "GetClientQueueType", IPAddress)
 	} else {
 		var ClientStr = tkMakeServerCall("web.DHCVISTreatQueue", "GetClientStr");
 	}

 	if (ClientStr != "") {
 		combo_ClientList = dhtmlXComboFromStr("ClientList", ClientStr);
 		combo_ClientList.enableFilteringMode(true);
 		combo_ClientList.selectHandle = combo_ClientListKeydownhandler;
 		combo_ClientList.keyenterHandle = combo_ClientListKeyenterhandler;
 		combo_ClientList.attachEvent("onKeyPressed", combo_ClientListKeyenterhandler)
 		combo_ClientList.selectOption(0, false, true)
 		combo_ClientList.setComboText(combo_ClientList.optionsArr[0].text)
 		var ClientId = combo_ClientList.getActualValue();
 		DHCC_SetElementData('ClientId', ClientId);
 		var Obj = document.getElementById("btnTreatQueue");
 		if (Obj) Obj.style.display = "block";
 	} else {
 		var Obj = document.getElementById("ClientList");
 		if (Obj) Obj.style.display = "none";
 		var Obj = document.getElementById("cClientList");
 		if (Obj) Obj.style.display = "none";
 		var Obj = document.getElementById("btnTreatQueue");
 		if (Obj) Obj.style.display = "none";
 	}
 }
*/

function combo_ClientListKeydownhandler() {
    var obj = combo_ClientList;
    var ClientId = obj.getActualValue();
    var ClientDesc = obj.getSelectedText();
    DHCC_SetElementData('ClientId', ClientId);
}

function combo_ClientListKeyenterhandler(e) {
    try {
        keycode = websys_getKey(e);
    } catch (e) {
        keycode = websys_getKey();
    }
    if (keycode == 13) {
        combo_ClientListKeydownhandler();
    }
}

function DHCC_GetElementData(ElementName) {
    var obj = document.getElementById(ElementName);
    if (obj) {
        if (obj.tagName == 'LABEL') {
            return obj.innerText;
        } else {
            if (obj.type == 'checkbox') return obj.checked;
            return obj.value;
        }
    }
    return "";
}

function DHCC_SetElementData(ElementName, value) {
    var obj = document.getElementById(ElementName);
    if (obj) {
        obj.value = value;
    }
    return "";
}

function GetComputerIp() {
    var ip = tkMakeServerCall("web.DHCNurTreatQueue", "getComputerIp")
    return ip;
    // var ipAddr;
    // try {
    // 	var obj = new ActiveXObject("rcbdyctl.Setting");
    // 	ipAddr = obj.GetIPAddress;
    // 	obj = null;
    // } catch (e) {
    // 	ipAddr = "Exception";
    // }
    // return ipAddr;
}

function GetComputerName() {
    var computerName;
    try {
        var WshNetwork = new ActiveXObject("WScript.Network");
        computerName = WshNetwork.ComputerName;
        WshNetwork = null;
    } catch (e) {
        computerName = "Exception";
    }
    return computerName;
}

// 根据安全组查询该安全组下所配置的执行单中哪个单子有未执行的医嘱
// 如果有 返回1,否则 返回 0
function getPatOrdByQueryCode() {

    var ordList = parent.frames["NurseTop"];
    var wardId = ordList.document.getElementById("wardId").value;
    var regNo = ordList.document.getElementById("regNo").value;
    var locId = ordList.document.getElementById("locId").value;
    var queryTypeCode = ordList.document.getElementById("queryTypeCode").value;
    var HospitalRowId = ordList.document.getElementById("HospitalRowId").value;
    var stdate = ordList.document.getElementById("startDate").value;
    var edate = ordList.document.getElementById("endDate").value;
    //var startTime=ordList.document.getElementById("startTime").value;
    //var endTime=ordList.document.getElementById("endTime").value;
    var wardDesc = ordList.document.getElementById("PacWard").value;
    var Dept = ordList.document.getElementById("Dept").value;
    var ExeCheck = ordList.document.getElementById("exeFlag").checked;
    var admType = ordList.document.getElementById("admType").value;
    var exeFlag;
    var gap = "";
    if (ExeCheck == false) {
        exeFlag = 0;
    } else {
        exeFlag = 1;
    }
    if (Dept == "") {
        locId = "";
    }
    if (queryTypeCode == "") return 0;
    var userId = session['LOGON.USERID'];
    var ssgrp = session['LOGON.GROUPID'];

    // 根据安全组查询该安全组下所配置的执行单中哪个单子有未执行的医嘱
    var retStr = tkMakeServerCall("web.DHCNurCom", "GetPatOrdBtn", ssgrp, wardId, regNo, userId, stdate, edate, queryTypeCode, gap, locId, admType, exeFlag, HospitalRowId);
    //var retStr=tkMakeServerCall("web.DHCNurCom","GetPatOrdBtn",ssgrp,wardId,regNo,userId,stdate,edate,queryTypeCode,gap,locId,admType,exeFlag,HospitalRowId,startTime,endTime);
    // 如果返回空 则说明所有执行单都没有未执行的医嘱
    if (retStr == "") return 0;
    if (retStr != "") {
        var typeArr = retStr.split("^")
    }

    // retStr 后面多个空的上尖号
    if ((typeArr.length == 2) && (retStr.indexOf("Default") != -1)) return 0; // 只有全部医嘱有未执行的医嘱
    else return 1; // 有大于一个执行单或是一个不是全部医嘱的执行单有未执行医嘱	

}
