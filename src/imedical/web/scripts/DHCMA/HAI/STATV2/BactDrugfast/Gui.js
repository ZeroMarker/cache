function InitBactDrugfastWin(){
	var obj = new Object();
	$.parser.parse();
	obj.BacteriaDr="";
	obj.BacteriaDesc="";
	obj.TypeCode="";
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
	
	var HospList = $cm ({
		ClassName:"DHCHAI.BTS.HospitalSrv",
		QueryName:"QryHospListByLogon",
		aLogonHospID:$.LOGON.HOSPID
	},false);
	obj.HospData = HospList.rows;
	
	$HUI.combobox("#cboHospital",{
		valueField:'ID',
		textField:'HospDesc',
		editable:false,
		data:obj.HospData,
		onSelect:function(rec){
			var aLocType = Common_CheckboxValue('chkStatunit');
			Common_ComboToLoc('cboSubLoc',rec.ID,"","I",aLocType);
		},onLoadSuccess:function(data){
			// 院区默认选择
			$('#cboHospital').combobox('select',data[0].ID);
		}
	});
	//统计单位单选事件
	$HUI.radio("[name='chkStatunit']",{  
		onChecked:function(e,value){
			 setTimeout(function(){
				var aLocType = $(e.target).val();   //当前选中的值
				var aHospID  = $('#cboHospital').combobox('getValue');
				Common_ComboToLoc('cboSubLoc',aHospID,"","I",aLocType);
			},100)
			
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
	
	obj.cboBacteria = $HUI.lookup("#cboBacteria", {
		url:$URL,
		panelWidth:300,
		editable: true,
		mode:'remote',      //当设置为 'remote' 模式时，用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
		isValid:true,
		pagination:true,
		loadMsg:'正在查询',	
		isCombo:true,             //是否输入字符即触发事件，进行搜索
		minQueryLen:0,             //isCombo为true时，可以搜索要求的字符最小长度
		valueField: 'ID',
		textField: 'BacDesc',
		queryParams:{ClassName: 'DHCHAI.DPS.LabBactSrv',QueryName: 'QryLabBacteria',aAlias:"",aIsCommon:"1"},
		columns:[[  
			{field:'BacDesc',title:'细菌名称',width:280}  
		]],
		onBeforeLoad:function(param){
			var desc=param['q'];
			param = $.extend(param,{aAlias:desc}); //将参数q转换为类中的参数
			if (desc==""){
				obj.BacteriaDr   = "";
				obj.BacteriaDesc = "";	
			}
		},
		onSelect:function(index,rowData){ 
			obj.BacteriaDr   = rowData.ID;
			obj.BacteriaDesc = rowData.BacDesc;	
		}
	});
	obj.cboInfType = $HUI.combobox("#cboInfType", {
		url:$URL,
		editable: true,
		allowNull: true, 
		valueField: 'ID',
		textField: 'DicDesc',
		onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
			param.ClassName = 'DHCHAI.BTS.DictionarySrv';
			param.QueryName = 'QryDic';
			param.aTypeCode = 'IRInfType';
			param.aActive = 1;
			param.ResultSetType = 'array';
		},onSelect:function(rec){//给医院增加Select事件，更新科室列表
			obj.TypeCode=rec.DicCode;
		}
	});
	//默认耐药级别
	$HUI.combobox("#cboDrugLevel",{
		data:[{Id:'1',text:'多耐'},{Id:'2',text:'敏感'}],
		valueField:'Id',
		textField:'text'
	});
	//默认日期类型
	$HUI.combobox("#cboDateType",{
		data:[{Id:'1',text:'送检日期',selected:true},{Id:'2',text:'报告日期'}],
		valueField:'Id',
		textField:'text'
	});	
	InitFloatWin(obj);
	InitBactDrugfastWinEvent(obj);
	obj.LoadEvent(arguments);
	
	return obj;
}
