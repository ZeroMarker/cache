$(function () {
	InitImpSubRateWin();
});

function InitImpSubRateWin(){
	var obj = new Object();
    obj.Type=1;
	obj.IsShowReport=1;
	
	$("#KeyWords").keywords({
        singleSelect:true,
        items:[
            {text:'抗菌药物治疗前病原学送检率',id:0,selected:true},
            {text:'医院感染诊断相关病原学送检率',id:1},
            {text:'联合使用重点药物前病原学送检率',id:2}
        ]
	});
	obj.IsMarkCount =  $m ({									
		ClassName:"DHCHAI.BT.Config",
		MethodName:"GetValByCode",
		aCode:"LabIsCntMarkType"
	},false);

	//医院
	Common_ComboToMSHosp("cboHospital",$.LOGON.HOSPID);
	$HUI.combobox("#cboHospital",{
		onChange:function(newValue,oldValue){  //给医院增加onChange事件，更新科室列表
			var HospIDs=$('#cboHospital').combobox('getValues').join('|');
			var Alias   = "";
			var LocCate = "I";
			var LocType = Common_CheckboxValue('chkStatunit');
			//科室病区
			Common_ComboToMSLoc("cboLoc",HospIDs,"","I",LocType);
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
	
	ComboLabTestSet("cboLabTestSet1",1,1);
	ComboLabTestSet("cboLabTestSet2",2,1);
	ComboLabTestSet("cboLabTestSet3",3,1);
	ComboLabTestSet("cboLabTestSet4",4,1);
	
	//送检时间类型设置
	$HUI.combobox("#cboSubDateType",{
		data:[
			{value:'1',text:'采样时间',selected:true},
			{value:'2',text:'下检验医嘱时间'}
		],
		valueField:'value',
		textField:'text'
	})
	//用药时间类型设置
	$HUI.combobox("#useSubDateType",{
		data:[
			{value:'1',text:'医嘱开始时间',selected:true},
			{value:'2',text:'护士执行时间'}
			],
			valueField:'value',
			textField:'text'
	})
	//使用前送检时长设置
	$HUI.combobox("#cboSubHourType",{
		data:[
			{value:'0',text:'无限制',selected:true},
			{value:'1',text:'24H'},
			{value:'2',text:'48H'},
			{value:'3',text:'72H'},
			{value:'4',text:'7天'},
			{value:'5',text:'14天'}
		],
		valueField:'value',
		textField:'text'
	})
	
	//筛选条件
	obj.cboConditions = Common_ComboDicCode("cboQryCon","StatScreenCondition");
	$('#cboQryCon').combobox('setValue',1);
	$('#cboQryCon').combobox('setText',"显示全部病区(科室)");
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
	
	$HUI.radio("[name='chkStatunit']",{
        onChecked:function(e,value){
	        var Statunit = $(e.target).val();   //当前选中的值
			var HospIDs =  $("#cboHospital").combobox('getValues').join('|');
			var Alias   = "";
			var LocCate = "I";
			var LocType = Statunit;
	        setTimeout(function(){
				ShowStatDimens("cboShowType",LocType);
		      	//科室病区
				Common_ComboToMSLoc("cboLoc",HospIDs,"","I",LocType);
			 }, 200);
        }
    });

	//展示维度	
	ShowStatDimens("cboShowType",Common_CheckboxValue('chkStatunit'));
	$HUI.combobox("#cboShowType",{
		onSelect:function(row,index){
			if ((row.Code.indexOf(Common_CheckboxValue('chkStatunit'))<0)) {
				$('#cboLoc').combobox('clear');
				$('#cboLoc').combobox('disable');
			}else {
				$('#cboLoc').combobox('enable');
			}
		}
	});
	
	//初始化科室
	Common_ComboToMSLoc("cboLoc",$('#cboHospital').combobox('getValues').join('|'),"","I",Common_CheckboxValue('chkStatunit'));
	
	InitImpSubRateWinEvent(obj);
	obj.LoadEvent(arguments);
	
	return obj;
}


function ComboLabTestSet() {
	var ItemCode = arguments[0];
	var CatCode = arguments[1];
	var isSetValue = arguments[2];
	
	var LabTestSet =$cm({              //使用同步加载方法
		ClassName:"DHCHAI.DPS.LabTestSetSrv",
		QueryName:"QryLabTestSet",
		aCatCode:CatCode,
		aIsSubItem:1,
		aActive:1
	}, false);
	LabTestSetData=LabTestSet.rows;

	var cbox = $HUI.combobox("#"+ItemCode, {
		data:LabTestSetData,
		allowNull: true,       //再次点击取消选中
		editable: true,
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		valueField:'ID',
		textField:'TestSet',
		onLoadSuccess:function(){   //初始加载赋值
			if (isSetValue) {
				var data=$(this).combobox('getData');
				var len =data.length
				for (var r=0;r<len;r++) {
					$(this).combobox('select',data[r]['ID']);
				}				
			}			
		}
	});
	return;
}

