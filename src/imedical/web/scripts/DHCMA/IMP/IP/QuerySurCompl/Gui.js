//页面Gui
function InitMED0101Win(){
	var obj = new Object();
    $.parser.parse(); 
	
	//初始查询条件
    obj.cboHospital=Common_ComboToSSHosp("cboHospital",SSHospCode,"IMP");
	//医院科室联动
	$HUI.combobox('#cboHospital',{
	    onSelect:function(rows){
		    var HospID=rows["CTHospID"];
		    Common_ComboToLoc("cboLocation","E","","I",HospID);
		   
	    }
    });
    obj.cboComplDic=$HUI.combobox("#cboComplDic",{
				url:$URL+'?ClassName=DHCMA.IMP.BTS.OperCompDicSrv&QueryName=QryOperCompDic&aIsActive=1&ResultSetType=Array',
				valueField:'BTID',
				textField:'BTDesc',
	})
	obj.cboComplLvL=$HUI.combobox("#cboComplLvL",{
				url:$URL+'?ClassName=DHCMA.IMP.BTS.OperCompLvlSrv&QueryName=QryOperCompLvl&aIsActive=1&ResultSetType=Array',
				valueField:'BTID',
				textField:'BTCode',
	})
	
	var date=Common_GetDate(new Date());
	$('#DateFrom').datebox('setValue',date);
	$('#DateTo').datebox('setValue',date);
	
	
	InitMED0101WinEvent(obj);	
	return obj;
}
