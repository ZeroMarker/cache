function InitICUTotalInfPosWin(){
	var obj = new Object();
	$.parser.parse();
	
	//医院
	Common_ComboToMSHosp("cboHospital",$.LOGON.HOSPID);
	$HUI.combobox("#cboHospital",{
		onChange:function(newValue,oldValue){  //给医院增加onChange事件，更新科室列表	   
			var HospIDs=$('#cboHospital').combobox('getValues').join('|');
			//科室病区
			//Common_MSICULoc("cboLoc",HospIDs,Common_CheckboxValue('chkStatunit'));
		}
	});
	
	//加载NICU科室多选公共方法
	function Common_MSICULoc(){
		var ItemCode = arguments[0];
		var HospIDs = arguments[1];
		var LocType = arguments[2];
		//科室病区
		$HUI.combobox("#"+ItemCode, {
			url: $URL,
			editable: true,
			allowNull: true, 
			multiple:true,
			rowStyle:'checkbox',
			defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
			valueField: 'ID',
			textField: 'LocDesc2',
			onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
				param.ClassName = 'DHCHAI.STATV2.NICUPICCVAP';
				param.QueryName = 'QryNICULoc';
				param.aHospIDs = HospIDs;
				param.Alias ="";
				param.aLocCate = "I|E";
				param.aLocType = LocType;
				param.aIsActive =1;
				param.ResultSetType = 'array';
			}
		});
	}
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
	obj.cboConditions = Common_ComboDicCode("cboQryCon","StatScreenCondition");
	$('#cboQryCon').combobox('setValue',1);
	$('#cboQryCon').combobox('setText',"显示全部病区(科室)");
	
	$HUI.radio("[name='chkStatunit']",{
        onChecked:function(e,value){
	        var Statunit = $(e.target).val();   //当前选中的值
			var HospIDs =  $("#cboHospital").combobox('getValues').join('|');
			var LocType = Statunit;
	        setTimeout(function(){
		      	//科室病区
				//Common_MSICULoc("cboLoc",HospIDs,LocType);
			 }, 200);
        }
    });	
	$HUI.radio("#chkStatunit-Ward").setValue(true);
	var unitConfig = $m({
		ClassName: "DHCHAI.BT.Config",
		MethodName: "GetValByCode",
		aCode: "StatV2ScreenuUnit"
	},false);

	if (unitConfig) {
		if (unitConfig == 'E') {
			$HUI.radio("#chkStatunit-Loc").setValue(true);
		}
	}
	
	//Common_MSICULoc("cboLoc",$('#cboHospital').combobox('getValues').join('|'),Common_CheckboxValue('chkStatunit'));

	InitICUTotalInfWinEvent(obj);
	obj.LoadEvent(arguments);
	
	return obj;
}
