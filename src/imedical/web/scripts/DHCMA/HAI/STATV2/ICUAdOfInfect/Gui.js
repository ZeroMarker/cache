function InitICUTotalInfPosWin(){
	var obj = new Object();
	$.parser.parse();
	
	//医院
	Common_ComboToMSHosp("cboHospital",$.LOGON.HOSPID);
	$HUI.combobox("#cboHospital",{
		onChange:function(newValue,oldValue){  //给医院增加onChange事件，更新科室列表	   
			var HospIDs=$('#cboHospital').combobox('getValues').join('|');
			//科室病区
			Common_MSICULoc("cboLoc",HospIDs,1);
		}
	});
	Common_MSICULoc("cboLoc",$('#cboHospital').combobox('getValues').join('|'),1);
	
	//加载ICU科室多选公共方法
	function Common_MSICULoc(){
		var ItemCode = arguments[0];
		var HospIDs = arguments[1];
		var TypeID   = arguments[2];
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
				param.ClassName = 'DHCHAI.BTS.LocationSrv';
				param.QueryName = 'QryICULoc';
				param.aHospIDs = HospIDs;
				param.aTypeID =TypeID;
				param.ResultSetType = 'array';
			}
		});
	}
	//日期框只显示月份
	var YearList = $cm ({									//初始化年(最近十年)
		ClassName:"DHCHAI.STATV2.AbstractComm",
		QueryName:"QryYear"
	},false);
	$HUI.combobox("#cboYear",{
		valueField:'ID',
		textField:'Desc',
		editable:false,
		data:YearList.rows
	});
	var MonthList = $cm ({									//初始化月+季度+全年
		ClassName:"DHCHAI.STATV2.AbstractComm",
		QueryName:"QryMonth"
	},false);
	$HUI.combobox("#cboMonth",{
		valueField:'ID',
		textField:'Desc',
		editable:false,
		data:MonthList.rows
	});
	var NowDate=month_formatter(new Date());
	var NowYear=NowDate.split("-")[0];	//当前年
	var NowMonth=NowDate.split("-")[1]	//当前月
	$('#cboYear').combobox('select',NowYear);
	$('#cboMonth').combobox('select',NowMonth);
	
	InitICUTotalInfWinEvent(obj);
	obj.LoadEvent(arguments);
	
	return obj;
}
