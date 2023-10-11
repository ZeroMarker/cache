//页面Gui
function InitCCSWorkWin(){
	var obj = new Object();
   	//医院
	obj.cboHospital = Common_ComboToSSHosp("cboHospital",$.LOGON.HOSPID);
	//设置开始日期为当月1号
	var date=new Date()
	date.setDate(1);
	var DateFrom=Common_GetDate(date);
	var DateTo=Common_GetDate(new Date());
	Common_SetValue('DateFrom',DateFrom);
    Common_SetValue('DateTo',DateTo);
    
	InitCCSWorkWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
$(function () {
	InitCCSWorkWin();
});