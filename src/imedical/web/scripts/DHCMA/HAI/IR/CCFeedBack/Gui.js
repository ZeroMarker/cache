//页面Gui
function InitCCFeedbackWin(){
	var obj = new Object();

	// 日期赋初始值
	obj.dtDateFrom = $('#dtDateFrom').datebox('setValue', Common_GetDate(new Date()));    // 日期初始赋值
	obj.dtDateTo = $('#dtDateTo').datebox('setValue', Common_GetDate(new Date()));
	

	    //医院
    $HUI.combobox("#cboHospital",{
		url:$URL+'?ClassName=DHCHAI.BTS.HospitalSrv&QueryName=QryHospListByLogon&ResultSetType=Array&aLogonHospID='+$.LOGON.HOSPID,
		valueField:'ID',
		textField:'HospDesc',
		editable:false,
		onSelect:function(rec){
			Common_ComboToLoc('cboLocation',rec.ID,"","I","E");
		},
		onLoadSuccess:function(data){
			// 院区默认选择
			$('#cboHospital').combobox('select',data[0].ID);
		}
	});
	$('#cboLocation').combobox({}); //联动表格需先初始化	

	InitCCFeedbackWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}