function InitOpr01InfWin(){
	var obj = new Object();
	$.parser.parse();
	
	//医院
	obj.cboHospital = Common_ComboToSSHosp("cboHospital",$.LOGON.HOSPID);
	// 日期赋初始值
	var date=new Date()
	date.setDate(1);
	var DateFrom=Common_GetDate(date);
	obj.dtDateFrom = $('#dtDateFrom').datebox('setValue',DateFrom);    // 日期初始赋值
	obj.dtDateTo = $('#dtDateTo').datebox('setValue', Common_GetDate(new Date()));
	
	//默认日期类型
    $HUI.combobox("#cboDateType",{
		data:[
			{value:'1',text:'手术日期'},
			{value:'2',text:'填报日期',selected:true},
			{value:'3',text:'回访日期'},
			{value:'4',text:'入院日期'},
			{value:'5',text:'出院日期'}
		],
		valueField:'value',
		textField:'text'
	})
	
	$HUI.combobox("#cboOperCat",{
		url:$URL+'?ClassName=DHCHAI.IRS.CRuleOperCatSrv&QueryName=QryCRuleOperCat&ResultSetType=Array&aIsActive=1',
		allowNull: true,       //再次点击取消选中
		valueField:'ID',
		textField:'OperCat'
	});

	InitOpr01InfWinEvent(obj);
	obj.LoadEvent(arguments);
	
	return obj;
}
