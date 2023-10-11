function InitDMapChartWin(){
	var obj = new Object();
	$.parser.parse();
	//医院 
	obj.cboSSHosp = Common_ComboToSSHosp("cboHospital",SSHospCode,"DTH");  
	// 日期赋初始值
	$('#dtDateFrom').datebox('setValue', Common_GetDate(new Date()));
	$('#dtDateTo').datebox('setValue', Common_GetDate(new Date()));
	
	$('#cboDateType').combobox({      
			valueField:'Code',    
			textField:'Desc',
			data : [ {
				Code:'1', 
				Desc:'报告日期',
				"selected":true   
			},{
				Code:'2', 
				Desc:'死亡日期'
			}]
		});
	var StatusIDs = $m({                  
		ClassName:"DHCMed.DTHService.DisaseStat",
		MethodName:"GetIDByDesc",
		aDesc:"编码,审核",
		aCode:"DTHRunningState"
	},false);
	StatusIDArr = StatusIDs.split(",");

 	obj.cboRepType = ComboMultiDicID('cboRepStatus','DTHRunningState',StatusIDArr);

	// 加载多选下拉字典
	function ComboMultiDicID(){
		var ItemCode = arguments[0];
		var DicType = arguments[1];
		var values= arguments[2];   //是否初始赋值
		
		var cbox = $HUI.combobox("#"+ItemCode, {
			url:$URL+"?ClassName=DHCMed.SSService.DictionarySrv&QueryName=QryDictionary&ResultSetType=array&aType="+DicType,
			valueField:'myid',
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
