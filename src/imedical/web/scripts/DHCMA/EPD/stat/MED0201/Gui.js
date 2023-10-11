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
		    Common_ComboToMultiLoc("cboLocation","E","","I",HospID);
	    }
    });
	var date=Common_GetDate(new Date());
	$('#DateFrom').datebox('setValue',date);
	$('#DateTo').datebox('setValue',date);
	
	//诊断放大镜
	Common_LookupToICD("txtDiagnos");
	
	InitMED0101WinEvent(obj);	
	return obj;
}