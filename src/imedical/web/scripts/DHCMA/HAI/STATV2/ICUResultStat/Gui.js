$(function () {
	var obj = new Object();

	//医院
	Common_ComboToMSHosp("cboHospital",$.LOGON.HOSPID);
	$HUI.combobox("#cboHospital",{
		onChange:function(newValue,oldValue){  //给医院增加onChange事件，更新科室列表
			var HospIDs=$('#cboHospital').combobox('getValues').join('|');
			//科室病区
			Common_ComboToMSICULoc("cboLoc",HospIDs,"",1);
		}
	});

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
	obj.cboConditions = Common_ComboDicCode("cboQryCon","StatScreenCondition",1);
	$('#cboQryCon').combobox('setValue',1);
	
	//初始化科室
	Common_ComboToMSICULoc("cboLoc",$('#cboHospital').combobox('getValues').join('|'),"",1);

	InitICUStatWinEvent(obj);
	obj.LoadEvent(arguments);
	
	return obj;
})
//加载多选ICU科室/病区方法
function Common_ComboToMSICULoc(){
	var ItemCode = arguments[0];
	var HospIDs = arguments[1];
	var LocID   = arguments[2];
	var Type    = arguments[3];

	var cbox = $HUI.combobox("#"+ItemCode, {
		url: $URL,
		editable: true,
		multiple:true,
		rowStyle:'checkbox',
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		valueField: 'ID',
		textField: 'LocDesc2',
		onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
			param.ClassName = 'DHCHAI.BTS.LocationSrv';
			param.QueryName = 'QryICULoc';
			param.aHospIDs = HospIDs;
			param.aLocID = LocID;
			param.aTypeID = Type;
			param.ResultSetType = 'array';
		}
	});
	return ;
}
