//页面Gui
function InitDisVitalWin(){
	var obj = new Object();
    $.parser.parse(); 
	
	//初始查询条件
    obj.cboHospital = Common_ComboToSSHosp("cboHospital",SSHospCode,"EPD");
	
    var myDate=new Date()
	$('#DateFrom').datebox('setValue',Common_GetDate(myDate));
	$('#DateTo').datebox('setValue',Common_GetDate(myDate));
	
	InitDisVitalWinEvent(obj);	
	return obj;
}