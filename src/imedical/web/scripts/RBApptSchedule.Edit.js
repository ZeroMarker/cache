// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.


document.body.onload = Init;

function Init(){
	obj=document.getElementById('ASActualStartTime');
	if (obj) obj.onblur=StartTimeBlurHndlr;

	obj=document.getElementById('ASActualEndTime');
	if (obj) obj.onblur=EndTimeBlurHndlr;

	obj=document.getElementById('update1');
	if (obj) obj.onclick=UpdateAll;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateAll;

	obj=document.getElementById('updateClose');
	if (obj) obj.onclick=UpdateCloseAll;
	if (tsc['updateClose']) websys_sckeys[tsc['updateClose']]=UpdateCloseAll;

	DoInitVal();

}

function StartTimeBlurHndlr(){
	ASActualStartTime_changehandler(e);
	StartTimeVal();
}

function StartTimeVal(){
	var actObj=document.getElementById("ASActualStartTime");
	var schObj=document.getElementById("STimeStr");
	var varObj=document.getElementById("ASReasonForDelayDR");
	if(actObj && schObj && varObj){
		if (TimeStringCompare(actObj.value, schObj.value)>0){
			labelMandatory(varObj.name);
		}
		else{
			labelNormal(varObj.name);
		}
	}
}


function EndTimeBlurHndlr(){
	ASActualEndTime_changehandler(e);
	EndTimeVal();
}

function EndTimeVal(){
	var actObj=document.getElementById("ASActualEndTime");
	var schObj=document.getElementById("ETimeStr");
	var varObj=document.getElementById("ASReasonForOvertimeDR");
	if(actObj && schObj && varObj){
		if (TimeStringCompare(actObj.value, schObj.value)>0){
			labelMandatory(varObj.name);
		}
		else{
			labelNormal(varObj.name);
		}
	}
}

function DoInitVal(){
	StartTimeVal();
	EndTimeVal();
}

function UpdateAll(){
	if (!DoUpdate()) return false;
	return update1_click();

}

function UpdateCloseAll(){
	if(!DoUpdate()) return false;
	return updateClose_click();

}

function DoUpdate(){
	var actObj=document.getElementById("ASActualStartTime");
	var schObj=document.getElementById("STimeStr");
	var varObj=document.getElementById("ASReasonForDelayDR");
	if(actObj && schObj && varObj){
		if ((TimeStringCompare(actObj.value, schObj.value)>0) && varObj.value==""){
			alert(t['ASReasonForDelayDR'] + " " + t['XMISSING']);
			return false;
		}
	}

	var actObj=document.getElementById("ASActualEndTime");
	var schObj=document.getElementById("ETimeStr");
	var varObj=document.getElementById("ASReasonForOvertimeDR");
	if(actObj && schObj && varObj){
		if ((TimeStringCompare(actObj.value, schObj.value)>0) && varObj.value==""){
			alert(t['ASReasonForOvertimeDR'] + " " + t['XMISSING']);
			return false;
		}
	}

	return true;
}




