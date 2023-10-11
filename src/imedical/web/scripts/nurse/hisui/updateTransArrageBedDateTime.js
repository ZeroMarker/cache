var transAuditDate=ServerObj.transAuditDateTime.split(" ")[0];
var transAuditTime=ServerObj.transAuditDateTime.split(" ")[1];
var transDate=ServerObj.transToBedDateTime.split(" ")[0];
var transTime=ServerObj.transToBedDateTime.split(" ")[1];
$(function() {
	initHospDateTime();
	initEvent();
})
function initEvent(){
	$("#BSave").click(SaveClick);
	$("#BCancel").click(CancelClick);
}
function SaveClick(){
	var date=$("#transDate").datebox("getValue");
	var time=$("#transTime").timespinner("getValue")
	var rtn={
		date:date,
        time:time,
		result:true,
	}
	websys_showModal('options').CallBackFunc(rtn);
}
function CancelClick(){
	websys_showModal('options').CallBackFunc({result:false});
}
function initHospDateTime(){
	$("#transDate").datebox("setValue",transDate);
	if (transAuditDate == transDate){
		$("#transDate").datebox("disable");
	}else{
		$("#transDate").datebox({minDate:transAuditDate,maxDate:transDate});
	}
	$("#transTime").timespinner("setValue",transTime);
	changeDate();
}
function setTransTimeRange(minTime,maxTime){
	$("#transTime").timespinner({min:minTime,max:maxTime});
}
function changeDate(){
	var date=$("#transDate").datebox('getValue');
	if ((date !=transAuditDate)&&(date !=transDate)){
		setTransTimeRange(null,null);
	}else{
		if (transAuditDate == transDate){
			setTransTimeRange(transAuditTime,transTime);
		}else{
			if (date == transAuditDate){
				setTransTimeRange(transAuditTime,null);
			}else{
				setTransTimeRange(null,transTime);
			}
		}
	}
}