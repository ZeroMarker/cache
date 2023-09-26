//页面Gui
function InitMED0101Win(){
	var obj = new Object();
    $.parser.parse(); // 解析整个页面 
	obj.cboSSHosp = Common_ComboToSSHosp("cboHospital",SSHospCode,"DTH");  /*参数有问题*/
	
	var startDate=Common_GetDate(new Date(new Date().setDate(1)));
    var endDate=Common_GetDate(new Date());
    
	$('#StartDate').datebox('setValue',startDate);
	$('#EndDate').datebox('setValue',endDate);
	
	InitMED0101WinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


