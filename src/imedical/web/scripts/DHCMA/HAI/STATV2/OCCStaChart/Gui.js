function InitOCCStaChartWin(){
	var obj = new Object();
	$.parser.parse();
	//医院
	obj.cboHospital = Common_ComboToSSHosp("cboHospital",$.LOGON.HOSPID);
	// 日期赋初始值
	obj.dtDateFrom = $('#dtDateFrom').datebox('setValue', Common_GetCalDate(-30));    // 日期初始赋值
	obj.dtDateTo = $('#dtDateTo').datebox('setValue', Common_GetDate(new Date()));
	obj.cboRepType = $HUI.combobox("#cboRepType", {
		editable: true,       
		defaultFilter:4,     
		valueField: 'ID',
		textField: 'BTDesc',
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.IRS.OccExpTypeSrv&QueryName=QryOccExpType&ResultSetType=array&aActive=1";
		   	$("#cboRepType").combobox('reload',url);
		}
	});
	obj.cboDicType = $HUI.combobox("#cboDicType", {
		editable: true,       
		defaultFilter:4,     
		valueField: 'Code',
		textField: 'Desc',
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.STA.OccRepStaSrv&QueryName=QryDicType&ResultSetType=array";
		   	$("#cboDicType").combobox('reload',url);
		}
	});
	InitOCCStaChartWinEvent(obj);
	obj.LoadEvent(arguments);
	
	return obj;
}
