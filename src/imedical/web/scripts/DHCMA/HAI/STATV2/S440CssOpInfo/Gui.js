﻿function InitS440cssopinfoWin(){
	var obj = new Object();
	$.parser.parse();
	
	$HUI.radio("#chkStatunit-Ward").setValue(true);
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
	InitS440cssopinfoWinEvent(obj);
	obj.LoadEvent(arguments);
	
	return obj;
}

