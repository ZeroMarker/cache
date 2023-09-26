var tDHCOrderBillStopExecTableObj,tableLength=0;
function bodyOnloadHandler() {
	var obj = document.getElementById("RegNO");
	obj.onkeydown =regNoKeydownHandler;
	obj =  document.getElementById("StopOrderExec"); 
	if (obj){
		obj.onclick = StopOrderExecHandler;
	}
	obj = document.getElementById("IsAllSelected");
	if(obj){
		obj.onclick = AllSelectedClickHandler;		
	}
	tDHCOrderBillStopExecTableObj = document.getElementById("tDHCOrderBillStopExec");
	if(tDHCOrderBillStopExecTableObj){
		tableLength = tDHCOrderBillStopExecTableObj.rows.length-1
	}
	obj = document.getElementById("OrderDesc");
	obj.onkeydown = orderDescKeydownHandler;
	//
	obj = document.getElementById("IsAll");
	obj.onclick = Find_click;
	//
	obj = document.getElementById("IsExec");
	obj.onclick = Find_click;
	//
	obj = document.getElementById("LongExec");
	obj.onclick = Find_click;
	//
	obj = document.getElementById("ShortExec");
	obj.onclick = Find_click;
	//
	obj = document.getElementById("IsDoctorOrder");
	obj.onclick = Find_click;
	//
	obj  = document.getElementById("EpisodeID");
	if(obj){
		DisplayCurrentPatInfo(obj.value);
	}
	
}

function StopOrderExecHandler(){
	var selObj,execObj,stopExecIds="",rtn,rtnArr;
	if(tDHCOrderBillStopExecTableObj && (tableLength>0)){
		for (var i=1; i<=tableLength; i++){
			selObj = document.getElementById("TSelectedExecz"+i);
			if(selObj && selObj.checked){
				execObj = document.getElementById("TOrderExecIdz"+i);
				if(stopExecIds=="") {
					stopExecIds = execObj.innerText;
				}else{
					stopExecIds = stopExecIds+"^"+execObj.innerText;
				}
			}
		}
		if(stopExecIds!=""){
			rtn = executeServerRequest("StopExecEncy",stopExecIds,session['LOGON.USERID'],"");			
			if(rtn){
				rtnArr = rtn.split("^");
				if(rtnArr[0]==0){
					alert(t["stopExecSucc"]);
				}else{					
					alert(t["stopExecFail"]+". Error:"+rtnArr[0]+":"+t[rtnArr[0]]);				   
				}
			}
			Find_click();
		}
	}
}
function AllSelectedClickHandler(){
	var checkFlag = false;
	var selectedObj =  document.getElementById("IsAllSelected");
	if(selectedObj){
		checkFlag = selectedObj.checked;
	}
	var selObj;
	if(tDHCOrderBillStopExecTableObj && tableLength>0){
		for (var i=1; i<=tableLength; i++){
			selObj = document.getElementById("TSelectedExecz"+i);
			if(selObj && !selObj.disabled){
				selObj.checked = checkFlag;
			}
		}			
	}
}
function SelectExecClickHandler(t){
	var selectExecId = t.id;
	var zRowNum = selectExecId.slice(selectExecId.lastIndexOf("z"));
	var checkflag = document.getElementById("TSelectedExec"+zRowNum).checked;
	var TOrderExecIdObj = document.getElementById("TOrderExecId"+zRowNum);
	var execRowid = getValue(TOrderExecIdObj);
	var TOeoreOeoreDRObj="";
	if(tDHCOrderBillStopExecTableObj && tableLength>0){
		for (var i=1; i<=tableLength; i++){
			TOeoreOeoreDRObj = document.getElementById("TOeoreOeoreDRz"+i);
			if(execRowid == getValue(TOeoreOeoreDRObj)){
				document.getElementById("TSelectedExecz"+i).checked = checkflag;
			}
		}
	}
	
}
function DisplayCurrentPatInfo(EpisodeID){
	if(EpisodeID != ""){		
		var rtn = executeServerRequest("GetPatInfoEnry",EpisodeID)
		var patJson = parseJSON(rtn);
		if(patJson){
			document.getElementById("Name").value = patJson.name;
			document.getElementById("RegNO").value = patJson.ipno;
			document.getElementById("AdmNO").value = patJson.admno;
			formatRegNo();
		}
	}
}
function formatRegNo(){
	var patientNo = document.getElementById("RegNO").value;
	var ruleNo="", len = document.getElementById("RegNoLen").value,patLen;
	for(var i=0;i<len;i++){ruleNo += '0' ;}
	if(patientNo!=""){
		patLen = patientNo.length;
		if(len-patLen>=0){
			patientNo = ruleNo.slice(0,len-patLen)+patientNo;
		}else{
			patientNo = patientNo.slice(patLen-len);
		}
		document.getElementById("RegNO").value = patientNo;
	}
}
function regNoKeydownHandler()
{
	var keycode=websys_getKey();
	if (keycode==13){
		formatRegNo();
	}
}
function orderDescKeydownHandler(){	
	if (window.event.keyCode==13) {  
		window.event.keyCode=117;
	  	OrderDesc_lookuphandler();
	}
}
document.body.onload = bodyOnloadHandler;