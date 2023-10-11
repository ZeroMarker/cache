function InitLocVirusSpecWin(){
	var obj = new Object();
	$.parser.parse(); 	
	LogonHospID=$.LOGON.HOSPID;
	obj.SpecDr = "";
	obj.SpecDesc   = "";
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
	//医院列表
	var HospList = $cm ({
		ClassName:"DHCHAI.BTS.HospitalSrv",
		QueryName:"QryHospListByLogon",
		aLogonHospID:LogonHospID
	},false);
	obj.HospData = HospList.rows;
    $HUI.radio("#chkStatunit-Ward").setValue(true);
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
	
	
	//病毒常规检验
	$HUI.combobox('#cboVirusTest',{		
		url:$URL+'?ClassName=DHCHAI.DPS.LabTestSetSrv&QueryName=QryTestSetVirus&ResultSetType=Array&aActive=1',
		valueField:'TSCode',
		textField:'TestSet',
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false   
    })
	
    $HUI.radio("#chkStatunit-Ward").setValue(true);
    obj.cboSpec = $HUI.lookup("#cboSpec", {
		url:$URL,
		panelWidth:420,
		editable: true,
		mode:'remote',      //当设置为 'remote' 模式时，用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
		isValid:true,
		pagination:true,
		loadMsg:'正在查询',	
		isCombo:true,             //是否输入字符即触发事件，进行搜索
		minQueryLen:0,             //isCombo为true时，可以搜索要求的字符最小长度
		valueField: 'ID',
		textField: 'SpecDesc',
		queryParams:{ClassName: 'DHCHAI.DPS.LabSpecSrv',QueryName: 'QryLabSpecimen',aAlias:"",aActive:"1"},
		columns:[[  
			{field:'SpecDesc',title:'标本',width:350}  
		]],
		onBeforeLoad:function(param){
			var desc=param['q'];
			param = $.extend(param,{aAlias:desc}); //将参数q转换为类中的参数
		},
		onSelect:function(index,rowData){ 
			obj.SpecDr = rowData.ID;
			obj.SpecDesc = rowData.SpecDesc;	
		}
	});
	
	$HUI.combobox("#cboStatNum",{
		data:[{Id:'1',text:'5',selected:true},{Id:'2',text:'10'},{Id:'3',text:'15'},{Id:'4',text:'20'}],
		valueField:'Id',
		textField:'text'
	});
	//默认日期类型
	$HUI.combobox("#cboDateType",{
		data:[{Id:'1',text:'送检日期',selected:true},{Id:'2',text:'报告日期'}],
		valueField:'Id',
		textField:'text'
	});	
	
	InitLocVirusSpecWinEvent(obj);
	obj.LoadEvent(arguments);
	
	return obj;
}
