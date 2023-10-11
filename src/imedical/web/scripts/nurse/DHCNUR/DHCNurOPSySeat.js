//DHCNurOPSySeat.JS
function BodyLoadHandler() {
	var objtbl = document.getElementById('tDHCNurOPSySeat');
	var i = 0;
	for (i = 1; i < objtbl.rows.length; i++) {
		var eSrc = objtbl.rows[i];
		var RowObj = getRow(eSrc);
		var IfExecOrd = document.getElementById("IfExecOrdz" + i);
		if ((IfExecOrd) && (IfExecOrd.innerText == "N")) {
			if (RowObj) RowObj.className = "Temp"; //"Discontinue"; Green
		}
	}
	var objIfSYCall = document.getElementById('ifSYCall');
	if (objIfSYCall) {
		var btnCall = document.getElementById('btnCall');
		if (btnCall) {
			btnCall.onclick = btnCallClick;
		}
		if ((objIfSYCall.value != 1) && (btnCall)) {
			btnCall.onclick = btnCallClick;
			var table = btnCall.parentNode;
			(function(node) {
				if (node.tagName != "TABLE") {
					arguments.callee(node.parentNode);
				} else {
					node.style.display = 'none';
				}
			})(table)
		}
	}

}

function RefreshFn() {
	window.location.href = window.location.href
}

function btnCallClick() {
	var selrow = document.getElementById("selrow");
	call(selrow.value);

}

function GetComputerIp() {
	var ip = tkMakeServerCall("web.DHCNurTreatQueue", "getComputerIp")
	return ip;
	// var ipAddr;
	// try
	// {
	//    var obj = new ActiveXObject("rcbdyctl.Setting");
	//    ipAddr=obj.GetIPAddress;
	//    obj = null;
	// }
	// catch(e)
	// {
	//    ipAddr="Exception";
	// }
	// return ipAddr;
}

function call(selrow) {
	var IPAddress = GetComputerIp()
	if ((IPAddress != "Exception") && (IPAddress != "")) {
		var IPFlag = tkMakeServerCall("web.DHCVISQueueManage", "GetActiveFlag", IPAddress);
	} else {
		var IPFlag = tkMakeServerCall("web.DHCVISQueueManage", "GetActiveFlag");
	}
	if (IPFlag != 0) {
		alert(IPFlag);
		return;
	}
	if (selrow < 1) return;
	try {
		var PatName = document.getElementById('PatNamez' + selrow).innerText;
		var QueNo = document.getElementById('QueueNoz' + selrow).innerText;
		if (QueNo == " ") {
			alert("该病人没有排队")
			return;
		}
	
		if ((QueNo != "") || (PatName != "")) {

			if ((IPAddress != "Exception") && (IPAddress != "")) {
				var RetStr = tkMakeServerCall("web.DHCVISQueueManage", "SendVoiceCallTreatQueue", QueNo, PatName, "", "", IPAddress)
			} else {
				var RetStr = tkMakeServerCall("web.DHCVISQueueManage", "SendVoiceCallTreatQueue", QueNo, PatName, "", "")
			}
			if (RetStr != "0") {
				alert(RetStr)
			}
		}
	} catch (e) {
		window.location.href = window.location.href
	}
}

function SelectRowHandler() {
	var selrow = document.getElementById("selrow");
	var resList = new Array();
	selrow.value = DHCWeb_GetRowIdx(window);
	var objtbl = document.getElementById('tDHCNurOPSySeat');
	var EpisodeID = document.getElementById("EpisodeIDz" + selrow.value).innerText;
	var frm = parent.parent.parent.document.forms['fEPRMENU'];
	frm.EpisodeID.value = EpisodeID;
	var SeatNo = document.getElementById("SeatNoz" + selrow.value).innerText;
	var CardNo = document.getElementById("CardNoz" + selrow.value).innerText;
	if (EpisodeID == "") return;
	var lnk;
	var flowFlag=parent.frames[1].frames[0].document.getElementById("flowFlag")
	if(flowFlag){
		flowFlag="&flowFlag="+flowFlag.value;
	}else{
		flowFlag=""
	}
	var admType=parent.frames[1].frames[0].document.getElementById("admType")
	if(admType){
		admType="&admType="+admType.value;
	}else{
		admType=""
	}
	lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurOPExecTitle&EpisodeID=" + EpisodeID + "&SeatNo=" + SeatNo + "&CardNo=" + CardNo;
	parent.frames[1].frames[0].location.href = lnk +admType+flowFlag;
	//parent.frames[1].location.reload();   
}

function DHCWeb_GetRowIdx(wobj) {
	try {
		var eSrc = wobj.event.srcElement;
		//alert(wobj.name);
		if (eSrc.tagName == "IMG") eSrc = wobj.event.srcElement.parentElement;
		var rowObj = getRow(eSrc);
		var selectrow = rowObj.rowIndex;
		return selectrow
	} catch (e) {
		alert(e.toString());
		return -1;
	}
}
document.body.onload = BodyLoadHandler;