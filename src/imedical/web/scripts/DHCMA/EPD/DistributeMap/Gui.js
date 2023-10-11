function InitDMapChartWin(){
	var obj = new Object();
	$.parser.parse();
	//医院 
	obj.cboSSHosp = Common_ComboToSSHosp("cboHospital",SSHospCode,"EPD");  
	var StatusCodes = $m({                  
		ClassName:"DHCMed.EPDService.DistributeMap",
		MethodName:"GetIDByDesc",
		aDesc:"已审,订正,被订",
		aCode:"EpidemicReportStatus"
	},false);
	StatusCodes = StatusCodes.split(",");
	
	
	// 日期赋初始值
	$('#dtDateFrom').datebox('setValue', Common_GetDate(new Date()));
	$('#dtDateTo').datebox('setValue', Common_GetDate(new Date()));
	
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

 	obj.cboRepType = ComboMultiDicID('cboRepStatus','EpidemicReportStatus',StatusCodes)
	
	


function ComboMultiDicID(){
	var ItemCode = arguments[0];
	var DicType = arguments[1];
	
	var values= arguments[2];   //是否初始赋值
	var Texts = "已审,订正,被订";
	
	var cbox = $HUI.combobox("#"+ItemCode, {
		url:$URL+"?ClassName=DHCMed.SSService.DictionarySrv&QueryName=QryDictionary&ResultSetType=array&aType="+DicType,
		valueField:'Code',
		textField:'Description',
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
		onLoadSuccess: function (data) {
            //多选下拉框加载成功后设置默认选中值
            $('#' + ItemCode).combobox("setValues", values);
            $('#' + ItemCode).combobox("setText", Texts);
          	for (var i = 0; i < values.length; i++) {
                var value = values[i];
                $('#' + ItemCode).combobox('select', value.toString());
            }
        }
	});
	
}
	InitDMapChartWinEvent(obj);
	obj.LoadEvent(arguments);
	
	return obj;
}
