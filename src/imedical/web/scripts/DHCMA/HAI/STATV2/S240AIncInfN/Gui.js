function InitS021DayInfWin(){
	var obj = new Object();
	$.parser.parse();
	
	//医院
	obj.cboHospital = Common_ComboToSSHosp("cboHospital",$.LOGON.HOSPID);
	// 日期赋初始值
	var YearList = $cm ({									//初始化年(最近十年)
		ClassName:"DHCHAI.STATV2.AbstractComm",
		QueryName:"QryYear"
	},false);
	$HUI.combobox("#cboYear",{
		valueField:'ID',
		textField:'Desc',
		editable:false,
		data:YearList.rows,
		onSelect:function(rec){
			Date_QuickSelect("cboYear","cboMonth","dtDateFrom","dtDateTo");	//更改开始-结束日期
		}
	});
	var MonthList = $cm ({									//初始化月+季度+全年
		ClassName:"DHCHAI.STATV2.AbstractComm",
		QueryName:"QryMonth"
	},false);
	$HUI.combobox("#cboMonth",{
		valueField:'ID',
		textField:'Desc',
		editable:false,
		data:MonthList.rows,
		onSelect:function(rec){
			Date_QuickSelect("cboYear","cboMonth","dtDateFrom","dtDateTo");	//更改开始-结束日期
		}
	});
	var NowDate=month_formatter(new Date());
	var NowYear=NowDate.split("-")[0];	//当前年
	var NowMonth=NowDate.split("-")[1]	//当前月
	$('#cboYear').combobox('select',NowYear);
	$('#cboMonth').combobox('select',NowMonth);
	//筛选条件
	obj.cboConditions = Common_ComboDicCode("aQryCon","StatScreenCondition");
	$('#aQryCon').combobox('setValue',1);
	$('#aQryCon').combobox('setText',"显示全部病区(科室)");
	$HUI.radio("#chkStatunit-Ward").setValue(true);
	var unitConfig = $m({
		ClassName: "DHCHAI.BT.Config",
		MethodName: "GetValByCode",
		aCode: "StatV2ScreenuUnit",
		aHospDr: $.LOGON.HOSPID
	},false);
	if (unitConfig) {
		if (unitConfig == 'E') {
			$HUI.radio("#chkStatunit-Loc").setValue(true);
		}
	}
		
	$HUI.combobox("#cboOperCat",{
		url:$URL+'?ClassName=DHCHAI.IRS.CRuleOperCatSrv&QueryName=QryCRuleOperCat&ResultSetType=Array&aIsActive=1',
		allowNull: true,       //再次点击取消选中
		valueField:'ID',
		textField:'OperCat'
	});


	
	InitFloatWin(obj);
	InitS021DayInfWinEvent(obj);
	obj.LoadEvent(arguments);
	
	return obj;
}
