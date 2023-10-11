$(function() {
	initHospDateTime();
	initEvent();
})
function initEvent(){
	$("#BSave").click(SaveClick);
	$("#BCancel").click(CancelClick);
}
function SaveClick(){
	var date=$("#inHospDate").datebox("getValue");
	var time=$("#inHospTime").timespinner("getValue")
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
	var inHospDate=ServerObj.inHospDateTime.split(" ")[0];
	var inHospTime=ServerObj.inHospDateTime.split(" ")[1];
	$("#inHospDate").datebox("setValue",inHospDate);
	$("#inHospTime").timespinner("setValue",inHospTime).timespinner({max:inHospTime});
}