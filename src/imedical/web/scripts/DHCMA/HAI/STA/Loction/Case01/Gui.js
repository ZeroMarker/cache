//ҳ��Gui
function InitCtlResultWin(){
	var obj = new Object();
	//$("#DateFrom").datebox("setValue","2020-12-12")
	Common_ComboToSSHosp("cboHospital",$.LOGON.HOSPID);
	Common_CreateMonth('DateFrom');
	Common_CreateMonth('DateTo');
	//ҽԺ�������
	$HUI.combobox('#cboHospital',{
		onSelect:function(data){
			var HospID = data.ID;
			Common_ComboToLoc("cboInfLocation",HospID,"","I|E","E");
		}
	});

	InitCtlResultWinEvent(obj);
	return obj;
}