function InitS800cssposinfWin(){
	var obj = new Object();
	$.parser.parse();
	
	//调查编号
	$HUI.combobox("#cboSurNum", {
		editable:true,
		defaultFilter:4,
		valueField: 'ID',
		textField: 'SESurvNumber',
		onShowPanel:function(){
			var url=$URL+"?ClassName=DHCHAI.IRS.INFCSSSrv&QueryName=QueryByCode&aHospIDs="+$.LOGON.HOSPID+"&ResultSetType=array";
			$("#cboSurNum").combobox('reload',url);	
		}
	});
	InitS800cssposinfWinEvent(obj);
	obj.LoadEvent(arguments);
	
	return obj;
}
