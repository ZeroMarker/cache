//DHCNurOPJZLG.JS
function BodyLoadHandler() {
	//var objtbl = document.getElementById('tDHCNurOPJZLG');
	

}


function SelectRowHandler() {
	var selrow = document.getElementById("selrow");
	var resList = new Array();
	selrow.value = DHCWeb_GetRowIdx(window);
	selrow.innerHTML = DHCWeb_GetRowIdx(window);
	var selrowNum = DHCWeb_GetRowIdx(window);
	var objtbl = document.getElementById('tDHCNurOPSySeat');
	var EpisodeID = document.getElementById("EpisodeIDz" + selrowNum).innerText; //selrow.value
	var frm = parent.parent.parent.document.forms['fEPRMENU'];
	frm.EpisodeID.value = EpisodeID;
	var SeatNo = document.getElementById("bedCodez" + selrowNum).innerText;//selrow.value
	var CardNo = "";//document.getElementById("patRegNoz" + selrowNum).innerText;//selrow.value
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