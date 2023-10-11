function InitInfTrendStatWin(){
	var obj = new Object();
	$.parser.parse();
	//医院
	Common_ComboToMSHosp("cboHospital",$.LOGON.HOSPID);
	$HUI.combobox("#cboHospital",{
		onSelect:function(rec){//给医院增加Select事件，更新科室列表
			var HospIDs=$('#cboHospital').combobox('getValues').join('|');
			var Alias   = "";
			var LocCate = "I";
			var LocType = Common_CheckboxValue('chkStatunit');
			//科室病区
			Common_ComboToMSLoc("cboSubLoc",HospIDs,"","I",LocType);
		}
	});
	
	//统计单位单选事件
	$HUI.radio("[name='chkStatunit']",{  
		onChecked:function(e,value){
			 setTimeout(function(){
				var aLocType = $(e.target).val();   //当前选中的值
				var aHospID  = $('#cboHospital').combobox('getValue');
				Common_ComboToMSLoc('cboSubLoc',aHospID,"","I",aLocType);
			},100)
			
		}
	});
	  var unitConfig = $m({
		ClassName: "DHCHAI.BT.Config",
		MethodName: "GetValByCode",
		aCode: "StatV2ScreenuUnit",
		aHospDr: $.LOGON.HOSPID
	},false);
	if (unitConfig) {
		if (unitConfig == 'E') {
			$HUI.radio("#chkStatunit-Loc").setValue(true);
		}else{
			$HUI.radio("#chkStatunit-Ward").setValue(true);
		}
	}
	$HUI.radio("#chkStatunit-Ward").setValue(true);
	// 日期赋初始值
	var YearList = $cm ({									//初始化年(最近十年)
		ClassName:"DHCHAI.STATV2.AbstractComm",
		QueryName:"QryYear"
	},false);
	$HUI.combobox("#cboYearFrom",{
		valueField:'ID',
		textField:'Desc',
		editable:false,
		data:YearList.rows
	});
	$HUI.combobox("#cboYearTo",{
		valueField:'ID',
		textField:'Desc',
		editable:false,
		data:YearList.rows
	});
	
	function MonthSetValue(aTypeID) {
		 var MonthList = $cm ({									//初始化月+季度+全年
			ClassName:"DHCHAI.STATV2.AbstractComm",
			QueryName:"QryMonth",
			aTypeID:aTypeID
		},false);
		
		$HUI.combobox("#cboMonthFrom",{
			valueField:'ID',
			textField:'Desc',
			editable:false,
			data:MonthList.rows
		});
		$HUI.combobox("#cboMonthTo",{
			valueField:'ID',
			textField:'Desc',
			editable:false,
			data:MonthList.rows
		});
		
		if (!aTypeID){
			$('#cboMonthFrom').combobox('setValue',NowMonth);
			$('#cboMonthTo').combobox('setValue',NowMonth);
		}
	}
	
	var NowDate=month_formatter(new Date());
	var NowYear=NowDate.split("-")[0];	//当前年
	var NowMonth=NowDate.split("-")[1]	//当前月
	var NowQuarter = Math.floor( ( NowMonth % 3 == 0 ? ( NowMonth / 3 ) : ( NowMonth / 3 + 1 ) ) );   //当前季度
	$('#cboYearFrom').combobox('select',NowYear);
	$('#cboYearTo').combobox('select',NowYear);
	MonthSetValue("1");
	$('#cboMonthFrom').combobox('setValue',NowMonth);
	$('#cboMonthTo').combobox('setValue',NowMonth);
	$HUI.combobox("#cboUnit",{
		data:[{Id:'1',text:'月',selected:true},{Id:'2',text:'季度'},{Id:'3',text:'年'}],
		valueField:'Id',
		textField:'text',
		onSelect:function(rec){
	        var Unit = rec.Id;   //当前选中的值
			MonthSetValue(Unit);
			if (Unit=="1"){ //月份
				$('#cboMonthFrom').combobox('enable');
				$('#cboMonthTo').combobox('enable');
				$('#cboMonthFrom').combobox('setValue',NowMonth);
				$('#cboMonthTo').combobox('setValue',NowMonth);
			}else if (Unit=="2"){  // 季度
				$('#cboMonthFrom').combobox('enable');
				$('#cboMonthTo').combobox('enable');
				$('#cboMonthFrom').combobox('setValue',"JD"+NowQuarter);
				$('#cboMonthTo').combobox('setValue',"JD"+NowQuarter);
			}else{ // 年
				$('#cboMonthFrom').combobox('disable');
				$('#cboMonthTo').combobox('disable');
				$('#cboMonthFrom').combobox('setValue',"QN");
				$('#cboMonthTo').combobox('setValue',"QN");
			}
        }
	});
	
	InitFloatWin(obj);
	InitInfTrendStatWinEvent(obj);
	obj.LoadEvent(arguments);
	
	return obj;
}
