//ҳ��Gui
function InitMED0102Win(){
	var obj = new Object();
    $.parser.parse(); 
	
	//��ʼ��ѯ����
    obj.cboHospital = Common_ComboToSSHosp("cboHospital",SSHospCode,"EPD");
	//ҽԺ��������
	$HUI.combobox('#cboHospital',{
	    onSelect:function(rows){
		    var HospID=rows["CTHospID"];
		    Common_ComboToLoc("cboLocation","E","","",HospID);
	    }
    });
	var date=Common_GetDate(new Date());
	$('#DateFrom').datebox('setValue',date);
	$('#DateTo').datebox('setValue',date);	
	
	InitMED0102WinEvent(obj);	
	return obj;
}