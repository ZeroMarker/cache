//页面Gui
function InitAdmFluWin(){
	var obj = new Object();
    $.parser.parse(); 
	
	//初始查询条件
    obj.cboHospital = Common_ComboToSSHosp("cboHospital",SSHospCode,"EPD");
	
	var nowDate = new Date();
	nowDate.setMonth(nowDate.getMonth()-1);
	obj.DateFrom = $('#DateFrom').datebox('setValue', Common_GetDate(nowDate)); // 日期初始赋值
	obj.DateTo = $('#DateTo').datebox('setValue', Common_GetDate(new Date()));
	
	InitAdmFluWinEvent(obj);	
	return obj;
}