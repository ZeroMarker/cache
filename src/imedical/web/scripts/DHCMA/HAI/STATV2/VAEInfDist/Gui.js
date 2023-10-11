function InitVAEInfDistWin(){
	var obj = new Object();
	$.parser.parse();
	LogonHospID=$.LOGON.HOSPID;
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
	//医院列表
	var HospList = $cm ({
		ClassName:"DHCHAI.BTS.HospitalSrv",
		QueryName:"QryHospListByLogon",
		aLogonHospID:LogonHospID
	},false);
	obj.HospData = HospList.rows;
    $HUI.combobox("#cboHospital",{
		valueField:'ID',
		textField:'HospDesc',
		editable:false,
		data:obj.HospData,
		onSelect:function(rec){//给医院增加Select事件，更新科室列表
			HospIDs=rec.ID;
			var Alias   = "";
			var LocCate = "I";
			var LocType = Common_CheckboxValue('chkStatunit');
			obj.cboSubLoc  = $HUI.combobox("#cboSubLoc", {
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
					param.QueryName = 'QryLoc';
					param.aHospIDs = HospIDs;
					param.aAlias = Alias;
					param.aLocCate = LocCate;
					param.aLocType = LocType;
					param.aIsActive = 1;
					param.ResultSetType = 'array';
				}
			});
		},onLoadSuccess:function(data){
			// 院区默认选择
			$('#cboHospital').combobox('select',data[0].ID);
		}
	});
	
	InitFloatWin(obj);
	InitVAEInfDistWinEvent(obj);
	obj.LoadEvent(arguments);
	
	return obj;
}
