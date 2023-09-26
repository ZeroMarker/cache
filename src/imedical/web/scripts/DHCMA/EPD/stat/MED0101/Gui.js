//页面Gui
function InitMED0101Win(){
	var obj = new Object();
    $.parser.parse(); 
	
	//初始查询条件
    obj.cboHospital = Common_ComboToSSHosp("cboHospital",SSHospCode,"EPD");
	//医院科室联动
	$HUI.combobox('#cboHospital',{
	    onSelect:function(rows){
		    var HospID=rows["CTHospID"];
		    Common_ComboToLoc("cboLocation","E","","",HospID);
	    }
    });
    var myDate=new Date()
	$('#DateFrom').datetimebox('setValue',Common_GetDate(myDate)+" 00:00:00");
	$('#DateTo').datetimebox('setValue',Common_GetCurrDateTime(myDate));
	//诊断放大镜
	Common_LookupToICD("txtDiagnos");
	
	InitMED0101WinEvent(obj);	
	return obj;
}