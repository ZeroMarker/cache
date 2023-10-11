function InitBactTrendWin(){
	var obj = new Object();
	Common_ComboToSSHosp('cboHospital',$.LOGON.HOSPID);
	Common_CreateMonth('DateFrom');
	Common_CreateMonth('DateTo');
	$HUI.combobox("#cboHospital",{
		 onSelect:function(rec){//给医院增加Select事件，更新科室列表
			HospIDs=rec.ID;
			Common_ComboToLoc("cboInfLocation",HospIDs,'','I|E','W');
		 }
	 })
	
	InitWinEvent(obj);
	obj.LoadEvent(arguments);
	
	return obj;
}
$(InitBactTrendWin)