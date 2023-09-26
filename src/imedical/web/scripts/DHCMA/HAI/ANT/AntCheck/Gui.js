//页面Gui
var objScreen = new Object();
function InitAntCheckWin(){
	var obj = objScreen;
	var LogonHospID = $.LOGON.HOSPID;
	
	//医院 科室
	obj.cboHospital=Common_ComboToSSHosp("cboHospital",LogonHospID);
	$HUI.combobox('#cboHospital',{
	    onSelect:function(rows){
		    var HospID=rows["ID"];
			obj.cboRepLoc=Common_ComboToLoc("cboLoc",HospID,"","","");//E|W
	    }
    });
	
	// 日期初始赋值
	obj.dtDateFrom	= $('#dtDateFrom').datebox('setValue', Common_GetDate(new Date()));
	obj.DateTo 		= $('#dtDateTo').datebox('setValue', Common_GetDate(new Date()));
	//抗菌用药
	obj.cboAntiMast = Common_ComboDicID("cboAntiMast","ANTAntibiotic");
	
	obj.gridAntCheck = $HUI.datagrid("#AntCheck",{
		fit: true,
		title:'科室抗菌用药患者审核列表',
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,	
		fitColumns: true,		
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns:[[
			{field:'ReportId',title:'报告号',width:50,align:'left'},
			{field:'PatNo',title:'登记号',width:120,align:'center'},
			{field:'PatName',title:'姓名',width:80,align:'left'},
			{field:'PAMrNo',title:'病案号',width:100,align:'left'},
			{field:'PatSex',title:'性别',width:50,align:'center'},
			{field:'PatAge',title:'年龄',width:80,align:'center'},
			{field:'AdmLocDesc',title:'就诊科室',width:100,align:'center'},
			{field:'AdmWardDesc',title:'就诊病区',width:180,align:'center'},
			{field:'AdmBed',title:'床位',width:80,align:'center'},
			{field:'AdmDate',title:'入院日期',width:100,align:'center'},
			{field:'DischDate',title:'出院日期',width:100,align:'center'},
			{field:'AntiDurg',title:'上报用药名称',width:100},
			{field:'StatusDesc',title:'报告状态',width:80},
			{field:'RepLocDesc',title:'报告科室',width:100},
			{field:'RepDate',title:'上报日期',width:150,align:'center'},
			{field:'RepUser',title:'上报人',width:80,align:'center'}
				
		]],
		//单击事件		
		onClickRow:function (rowIndex, rowData){
			if (rowIndex>-1){
				var aReportID=rowData.ReportId;
				var aEpisodeID=rowData.PatNo;
				var aOrdItemID=rowData.OrdItemID;
				obj.openHandler(aEpisodeID,aReportID,aOrdItemID);
			}
		}
	});
	obj.gridMajor = $HUI.datagrid("#Major",{
		fit: true,
		title:'',
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,	
		fitColumns: true,		
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns:[[
			{field:'HospitalDesc',title:'医院用户名',width:50,align:'left'},
			{field:'PAMrNo',title:'患者病案号',width:120,align:'center'},
			{field:'ARMonthTime',title:'用药次数',width:80,align:'left'},
			{field:'ARAge',title:'年龄',width:50,align:'center'},
			{field:'ARBabyMonth',title:'婴幼儿月龄',width:80,align:'center'},
			{field:'ARBabyDay',title:'婴儿出生天数',width:100,align:'center'},
			{field:'OrdLocDesc',title:'科室',width:180,align:'center'},
			{field:'SexDesc',title:'性别',width:80,align:'center'},
			{field:'Diagnos',title:'入院第一诊断',width:100,align:'center'},
			{field:'APACHEII',title:'APACHEⅡ',width:100,align:'center'},
			{field:'InfPosCode',title:'感染部位',width:100},
			{field:'IndicationCode',title:'适应症',width:80},
			{field:'SttDate',title:'用药日期',width:150,align:'center'},
			{field:'EndDate',title:'停药日期',width:80},
			{field:'UseDrugResCode',title:'用药效果',width:150,align:'center'},
			{field:'AntiDurgCode',title:'用药名称',width:80},
			{field:'IsEtiologyEvi',title:'病原学证据',width:150,align:'center'},
			{field:'UnReactionCode',title:'使用碳青霉烯/替加环素类抗菌药物后的不良反应',width:80},
			{field:'QuePowerCode',title:'处方权限',width:150,align:'center'},
			{field:'Freq',title:'用法(次/日)',width:80},
			{field:'DoseQty',title:'剂量(0~10g)',width:150,align:'center'},
			{field:'AdjustPlanCode',title:'调整方案',width:80},
			{field:'AdjustPlanTxt',title:'调整方案选择其他',width:150,align:'center'},
			{field:'IsInfection',title:'是否院感',width:80},
			{field:'RepDate',title:'数据录入时间',width:150,align:'center'},
			{field:'ARAdmDate',title:'入院日期',width:80}
		]],
	});
	obj.gridMinor = $HUI.datagrid("#Minor",{
		fit: true,
		title:'',
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,	
		fitColumns: true,		
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns:[[
			{field:'PAMrNo',title:'病案号',width:50,align:'left'},
			{field:'SttDate',title:'用药日期',width:120,align:'center'},
			{field:'EndDate',title:'停药日期',width:80,align:'left'},
			{field:'CollDate',title:'送检日期',width:50,align:'center'},
			{field:'AuthDate',title:'报告日期',width:80,align:'center'},
			{field:'SpecimenDesc',title:'标本类型',width:100,align:'center'},
			{field:'ResultCode',title:'结果',width:180,align:'center'},
			{field:'BacteriaDesc',title:'细菌名称',width:80,align:'center'},
			{field:'IsResistQ',title:'是否耐碳青霉烯',width:100,align:'center'},
			{field:'QAntiDesc',title:'药敏名称',width:100,align:'center'},
			{field:'QMethodDesc',title:'药敏方法',width:100},
			{field:'QNumber',title:'药敏数值',width:80},
			{field:'IsResistT',title:'是否耐替加环素',width:150,align:'center'},
			{field:'TAntiDesc',title:'药敏名称',width:80,align:'center'},
			{field:'TMethodDesc',title:'药敏方法',width:150,align:'center'},
			{field:'TNumber',title:'药敏数值',width:80,align:'center'}		
		]],
	});
	//状态
	$HUI.combobox("#cboQryStatus", {
		editable:true,
		defaultFilter:4,
		valueField: 'ID',
		textField: 'DicDesc',
		onShowPanel:function(){
			var url=$URL+"?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=array&aTypeCode=ANTStatus&aActive=1";
			$("#cboQryStatus").combobox('reload',url);	
		}
	});
	
	InitAntCheckWinEvent(obj);
	obj.LoadEvent(arguments);

	return obj;
}
