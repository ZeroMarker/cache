/**
 * 编目手术信息
 * 
 * Copyright (c) 2018-2022 LIYI. All rights reserved.
 * 
 * CREATED BY LIYI 2022-02-17
 * 
 * 注解说明
 * TABLE: 
 */
// 页面全局变量对象
var globalObj = {
	m_OperSelectindex:'',	// 选择一条手术数据的索引
	m_OperDrag:'',			// 手术是否通过拖动调整顺序
	m_isSave:true,
	m_cbgChangeValueType:0 	// 区分启用编辑某行和正常选择下拉表格数据变化
}
// 页面入口
$(function(){
	$("#tbOper").focus();	// 获取焦点，使快捷键不需点界面就能使用
	
	var editors,editorType,editorICD,editorSttDate,editorSttTime,editorEndDate,editorEndTime,editorOperator,editorAssistant1,editorAssistant2,editorNarcosisType,editorNarcosisDoc,editorCutType,editorHealing,editorOperationRank,editorAisOper,editorMainOper,editorNarcosisLevel,editorOperSite,editorOperLoc,editorBackOper,editorNNISLevel,editorOperCat,editorDurationTime,editorIsEmergency,editorIsMiniInva,editorIsChooseDate;
	var editorNarcosisSttDate,editorNarcosisSttTime,editorNarcosisEndDate,editorNarcosisEndTime;
	InitgridOper();

	// 保存按钮
	$('#OperSave').click(function(){
		SaveOper(1);
	});

	// 删除按钮
	$('#OperCancel').click(function(){
		CancelOper();
	});

	// 上移按钮
	$('#OperUp').click(function(e){
		moveOper('up');
	});

	// 下移按钮
	$('#OperDown').click(function(){
		moveOper('down');
	});
	// 插入手术
	$('#OperInsert').bind('click', function() {
		CopyOper("Insert");
	});
	
	// 复制手术
	$('#OperCopy').bind('click', function() {
		CopyOper("Copy");
	});

	// 显示首页手术
	$('#showemroper').bind('click', function() {
	    if (ServerObj.IsMergeDiagOperPage==1){
			var strUrl = "./ma.ipmr.fp.frontpage.emroperation.csp?&VolumeID="+ServerObj.VoumeID+"&DefaultFPConfig="+ServerObj.DefaultFPConfig+"&2=2"
			websys_showModal({
				url:strUrl,
				title:'首页手术',
				iconCls:'icon-w-epr',  
				originWindow:window,
	   			width: 1300,
        		height: 500,
			});
		}else{
			$cm({
	    	ClassName:"MA.IPMR.FPS.CodeOperSrv",
			QueryName:"QryOper",
			aVolumeID:ServerObj.VoumeID,
			aFPConfig:ServerObj.DefaultFPConfig,
			aEmrFlag:1,
	    	page:1,
	    	rows:10000
	    },function(rs){
	    	var json = rs;
	    	showEmrOper(json.rows);
	    });
		}
	});
	// ICD检索
	$('#showicdSearchWin').bind('click', function() {
		var selectobj = $('#gridOper').datagrid('getSelected');
		var diagselectTypeID='';
		var diagselected=0
		if  (selectobj!=null) {
			diagselected=1;
			diagselectTypeID = selectobj.TypeID;
		}
		if (ServerObj.IsMergeDiagOperPage==1){
			var title=$g('手术检索')
			var strUrl = "./ma.ipmr.fp.frontpage.icdsearch.csp?&icdType=O"+"&selectTypeID="+diagselectTypeID+"&icdVerID="+ServerObj.ConfigOprVerID+"&2=2"
			websys_showModal({
				url:strUrl,
				title:title,
				iconCls:'icon-w-epr',  
				originWindow:window,
				width: 800,
        		height: 500
			});
		}else{
	   	 	showicdSearchWin(diagselected);
		}
	});
	$('#searchICD').searchbox({
		searcher:function (value,name) {
			var selectobj = $('#gridOper').datagrid('getSelected');
			var diagselectTypeID='';
			if  (selectobj!=null) {
				diagselectTypeID = selectobj.TypeID;
			}
			serchICDDx(value,diagselectTypeID);
        }
    });
});
/**
 * ICD检索窗口
 */
function showicdSearchWin(diagselected){
	$('#searchICD').searchbox('setValue','');
	var columns = [[
		{field:'OperTypeDesc',title:'手术类型',width:80,align:'left'},
		{field:'ICD10',title:'手术编码',width:120,align:'left'},
		{field:'Desc',title:'手术名称',width:160,align:'left'},
		{field:'OperLevelDesc',title:'手术级别',width:80,align:'left'},
		{field:'replace',title:'替换手术',width:50,align:'left',hidden:diagselected==1?false:true,
			formatter:function(value,rowData,rowIndex){
				return "<a style='white-space:normal;color:#229A06' onclick='replaceFromSearch(\"" + rowData.ID + "\""+",\"" +rowData.ICD10 + "\""+",\"" +rowData.Desc + "\""+",\"" +rowData.OperTypeID + "\""+",\"" +rowData.OperTypeDesc + "\""+",\"" +rowData.OperLevelID + "\""+",\"" +rowData.OperLevelDesc + "\");'>" + $g("替换") + "</a>"; 
			}  
      	}
    ]];
    var gridICD = $('#gridICD').datagrid({
		fit: true,
		iconCls : 'icon-write-order',
		singleSelect : true,
		pagination : false, 
		autoRowHeight : false,
		loadMsg : '数据加载中...',
		pageSize : 10000,
		fitColumns : true,
		checkOnSelect:true,		//true,击某一行时，选中/取消选中复选框
		selectOnCheck:true,		//true,点击复选框将会选中该行
	    columns : columns,
	    url:$URL,
	    queryParams:{
		    ClassName : "CT.IPMR.FPS.ICDDxSrv",
			QueryName : "QryICDDx",
			aVerID :'',
			aTypeID:'',
			aAlias : $('#searchICD').searchbox('getValue'),
			aIsActive:1,
			aICDDxID:''
		}
	});
	$('#icdSearchWin').dialog({
		title: "手术检索",
		iconCls: 'icon-w-list',
	    width: 800,
        height: 500,
	    minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
	    closed: false,
	    cache: false,
	    modal: true
	});
}
 /**
 * 检索icd替换选中的诊断编码
 * @param {id}替换的id
 * @return {void}
 */
function replaceFromSearch(id,icd10,icddesc,operTypeID,operTypeDesc,operLevelID,operLevelDesc) {
	var selectobj = $('#gridOper').datagrid('getSelected');
	selectobj.ICDID=id;
	selectobj.ICD10=icd10;
	selectobj.ICDDesc=icddesc;
	selectobj.TypeID=operTypeID;
	selectobj.TypeDesc=operTypeDesc;
	selectobj.OperLevelID=operLevelID;
	selectobj.OperLevelDesc=operLevelDesc;
	$('#gridOper').datagrid('updateRow',{
		index: selectobj.Index-1,	
		row: selectobj
	});
	if (ServerObj.IsMergeDiagOperPage!=1) $.messager.popover({msg: '替换成功...',type:'success'});
}
 /**
 * 检索icd
 * @param {aliasICD}检索条件
 * @return {void}
 */
function serchICDDx(aliasICD,diagselectTypeID) {
	if (aliasICD == "") {
		$.messager.popover({msg: '请输入别名...',type:'alert'});
		return false;
	}
	$("#gridICD").datagrid("reload", {
		ClassName : "CT.IPMR.FPS.ICDDxSrv",
		QueryName : "QryICDDx",
		aVerID :ServerObj.ConfigOprVerID,
		aTypeID:'',
		aAlias : aliasICD,
		aIsActive:1,
		aICDDxID:''
	});
	return ;
}

/**
 * 首页手术列表
 */
function showEmrOper(array){
	var columns = [[
		{field:'Index',title:'序号',width:50,align:'left'},
		{field:'TypeDesc',title:'手术类型',width:100,align:'left'},
		{field:'ICD10',title:'手术编码',width:120,align:'left'},		
		{field:'ICDDesc',title:'手术名称',width:200,align:'left'},			
		{field:'SttDate',title:'手术日期',width:100,align:'left'},	
		{field:'SttTime',title:'开始时间',width:100,align:'left',hidden:ServerObj.CodeShowOperSttTime=='1'?false:true},
		{field:'EndDate',title:'结束日期',width:100,align:'left',hidden:ServerObj.CodeShowOperEndDate=='1'?false:true},			
		{field:'EndTime',title:'结束时间',width:100,align:'left',hidden:ServerObj.CodeShowOperEndTime=='1'?false:true},
		{field:'DurationTime',title:'手术持续时间',width:100,align:'left',editor:'text',hidden:ServerObj.CodeShowOperDurationTime=='1'?false:true},
		{field:'OperSiteDesc',title:'手术部位',width:100,align:'left',hidden:ServerObj.CodeShowOperSite=='1'?false:true},
		{field:'Operator',title:'术者',width:90,align:'left'},
		{field:'OperLocDesc',title:'术者所在科室',width:120,align:'left',hidden:ServerObj.CodeShowOperLoc=='1'?false:true},
		{field:'Assistant1',title:'Ⅰ助',width:90,align:'left'},
		{field:'Assistant2',title:'Ⅱ助',width:90,align:'left'},
		{field:'NarcosisTypeDesc',title:'麻醉方式',width:120,align:'left'},
		{field:'NarcosisSttDate',title:'麻醉开始日期',width:100,align:'left',hidden:ServerObj.CodeShowNarcosisSttDate=='1'?false:true},	
		{field:'NarcosisSttTime',title:'麻醉开始时间',width:100,align:'left',hidden:ServerObj.CodeShowNarcosisSttTime=='1'?false:true},
		{field:'NarcosisEndDate',title:'麻醉结束日期',width:100,align:'left',hidden:ServerObj.CodeShowNarcosisEndDate=='1'?false:true},			
		{field:'NarcosisEndTime',title:'麻醉结束时间',width:100,align:'left',hidden:ServerObj.CodeShowNarcosisEndTime=='1'?false:true},
		{field:'NarcosisLevelDesc',title:'麻醉分级',width:80,align:'left',hidden:ServerObj.CodeShowNarcosisLevel=='1'?false:true},
		{field:'NarcosisDoc',title:'麻醉医师',width:90,align:'left'},
		{field:'CutTypeDesc',title:'切口类型',width:80,align:'left'},
		{field:'HealingDesc',title:'愈合情况',width:80,align:'left'},
		{field:'OperLevelDesc',title:'手术级别',width:80,align:'left'},
		{field:'BackOperDesc',title:'非计划重返',width:90,align:'left',hidden:ServerObj.CodeShowBackOper=='1'?false:true},
		{field:'NNISLevelDesc',title:'手术风险等级',width:100,align:'left',hidden:ServerObj.CodeShowNNISLevel=='1'?false:true},
		{field:'OperCatDesc',title:'手术类别',width:80,align:'left',hidden:ServerObj.CodeShowOperCat=='1'?false:true},
		{field:'IsEmergencyDesc',title:'是否急诊',width:80,align:'left',hidden:ServerObj.CodeShowIsEmergency=='1'?false:true},
		{field:'IsMiniInvaDesc',title:'是否微创',width:80,align:'left',hidden:ServerObj.CodeShowIsMiniInva=='1'?false:true},
		{field:'IsChooseDateDesc',title:'是否择期',width:80,align:'left',hidden:ServerObj.CodeShowIsChooseDate=='1'?false:true},
		{field:'AisOperID',title:'临床手术ID',width:80,align:'left',hidden:ServerObj.CodeShowAisOperID=='1'?false:true},
		{field:'MainOperDesc',title:'主手术',width:80,align:'left',hidden:ServerObj.CodeShowMainOper=='1'?false:true}
    ]];
    var gridEmrOper = $('#gridEmrOper').datagrid({
		fit: true,
		iconCls : 'icon-write-order',
		singleSelect : true,
		pagination : false, 
		autoRowHeight : false,
		loadMsg : '数据加载中...',
		pageSize : 10000,
		fitColumns : false,
		checkOnSelect:true,		//true,击某一行时，选中/取消选中复选框
		selectOnCheck:true,		//true,点击复选框将会选中该行
	    columns : columns,
	    data: array,
	    onDblClickRow: function(index,row) {
	    	var Index = $('#gridOper').datagrid('getData').total;
	    	row.Index=Index+1;
	    	$('#gridOper').datagrid('appendRow',row);
	    }
	});
	$('#emrOperWin').dialog({
		title: "首页手术",
		iconCls: 'icon-w-list',
	    width: 1300,
        height: 500,
	    minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
	    closed: false,
	    cache: false,
	    modal: true
	});
}

/**
 * NUMS: D001
 * CTOR: LIYI
 * DESC: 手术列表模块
 * DATE: 2019-11-28
 * NOTE: 编目手术模块相关方法
 * TABLE: 
 */
// 初始化手术列表
function InitgridOper(){
	var columns = [[
		{field:'Index',title:'序号',width:50,align:'left'},
		{field:'TypeDesc',title:'手术类型',width:100,align:'left',
			editor:{
				type: 'combogrid',
				options: ComboDic('OperType','',1)
			}
		},
		{field:'ClinicICD10',title:'临床编码',width:200,align:'left',hidden:ServerObj.CodeShowOperClinicDesc=='1'?false:true},
		{field:'ClinicICDDesc',title:'临床手术',width:200,align:'left',hidden:ServerObj.CodeShowOperClinicDesc=='1'?false:true},
		{field:'ICD10',title:'手术编码',width:120,align:'left',
			formatter:function(value,row,index)
			{
				var ICDDesc = row["ICDDesc"];
				if ((value)&&(ICDDesc=="")){return "<span style='color: #BB0000'>" + value + "</span>";	}
				return value;	
			}
		},		
		{field:'ICDDesc',title:'手术名称',width:200,align:'left',
			formatter:function(value,row,index)
			{
				var ICD10 	= row["ICD10"];
				var ICDDesc = row["ICDDesc"];
				var ICDVer 	= ServerObj.ConfigOprVerID
				var ret = $cm({
					ClassName:"CT.IPMR.FPS.ICDDxSrv",
					MethodName:"CheckICD",
					aICDVer:ICDVer,
					aICD10:ICD10,
					aICDDesc:ICDDesc
				},false)
				if (ret!='1'){
					return "<span style='color: #BB0000'>" + value + "</span>";	
				}
				return value;	
			},
			editor:{
				type: 'combogrid',
				options: ComboICD(ServerObj.ConfigOprVerID)
			}	
		},			
		{field:'SttDate',title:'手术日期',width:100,align:'left',
			styler: function(value,row,index){
				if (row.AppendOper == '1'){	// 附属手术,手术日期变色
					return 'background-color:#FFEDDF;';
				}
			},
			editor:{
				type:'datebox',
				options:datebox('SttDate')
			}
		},	
		{field:'SttTime',title:'开始时间',width:100,align:'left',hidden:ServerObj.CodeShowOperSttTime=='1'?false:true,
			editor:{
				type:'timespinner',
				options:{
					showSeconds:true
				}
			}
		},
		{field:'EndDate',title:'结束日期',width:100,align:'left',hidden:ServerObj.CodeShowOperEndDate=='1'?false:true,
			editor:{
				type:'datebox',
				options:datebox('EndDate')
			}
		},			
		{field:'EndTime',title:'结束时间',width:100,align:'left',hidden:ServerObj.CodeShowOperEndTime=='1'?false:true,
			editor:{
				type:'timespinner',
				options:{
					showSeconds:true
				}
			}
		},
		{field:'DurationTime',title:'手术持续时间',width:100,align:'left',editor:'text',hidden:ServerObj.CodeShowOperDurationTime=='1'?false:true},
		{field:'OperSiteDesc',title:'手术部位',width:100,align:'left',hidden:ServerObj.CodeShowOperSite=='1'?false:true,
			editor:{
				type: 'combogrid',
				options: ComboDic('OperSite','',1)
			}
		},
		{field:'Operator',title:'术者',width:90,align:'left',
			editor:{
				type: 'combogrid',
				options: ComboUser('OPRDOC','OperatorID','Operator')
			}
		},
		{field:'OperLocDesc',title:'术者所在科室',width:120,align:'left',hidden:ServerObj.CodeShowOperLoc=='1'?false:true,
			editor:{
				type: 'combogrid',
				options: ComboLoc('E','I',ServerObj.DischHosp)
			}
		},
		{field:'Assistant1',title:'Ⅰ助',width:90,align:'left',
			editor:{
				type: 'combogrid',
				options: ComboUser('OPRASS','Assistant1ID','Assistant1')
			}
		},
		{field:'Assistant2',title:'Ⅱ助',width:90,align:'left',
			editor:{
				type: 'combogrid',
				options: ComboUser('OPRASS','Assistant2ID','Assistant2')
			}
		},
		{field:'NarcosisTypeDesc',title:'麻醉方式',width:120,align:'left',
			editor:{
				type: 'combogrid',
				options: ComboDic('NarcosisType','',1)
			}
		},
		{field:'NarcosisSttDate',title:'麻醉开始日期',width:100,align:'left',hidden:ServerObj.CodeShowNarcosisSttDate=='1'?false:true,
			editor:{
				type:'datebox',
				options:datebox('NarcosisSttDate')
			}
		},	
		{field:'NarcosisSttTime',title:'麻醉开始时间',width:100,align:'left',hidden:ServerObj.CodeShowNarcosisSttTime=='1'?false:true,
			editor:{
				type:'timespinner',
				options:{
					showSeconds:true
				}
			}
		},
		{field:'NarcosisEndDate',title:'麻醉结束日期',width:100,align:'left',hidden:ServerObj.CodeShowNarcosisEndDate=='1'?false:true,
			editor:{
				type:'datebox',
				options:datebox('NarcosisEndDate')
			}
		},			
		{field:'NarcosisEndTime',title:'麻醉结束时间',width:100,align:'left',hidden:ServerObj.CodeShowNarcosisEndTime=='1'?false:true,
			editor:{
				type:'timespinner',
				options:{
					showSeconds:true
				}
			}
		},
		{field:'NarcosisLevelDesc',title:'麻醉分级',width:80,align:'left',hidden:ServerObj.CodeShowNarcosisLevel=='1'?false:true,
			editor:{
				type: 'combogrid',
				options: ComboDic('NarcosisLevel','',1)
			}
		},
		{field:'NarcosisDoc',title:'麻醉医师',width:90,align:'left',
			editor:{
				type: 'combogrid',
				options: ComboUser('NARDOC','NarcosisDocID','NarcosisDoc')
			}
		},
		{field:'CutTypeDesc',title:'切口类型',width:80,align:'left',
			editor:{
				type: 'combogrid',
				options: ComboDic('CutType','',1)
			}
		},
		{field:'HealingDesc',title:'愈合情况',width:80,align:'left',
			editor:{
				type: 'combogrid',
				options: ComboDic('Healing','',1)
			}
		},
		{field:'OperLevelDesc',title:'手术级别',width:80,align:'left',
			editor:{
				type: 'combogrid',
				options: ComboDic('OperationRank','',1)
			}
		},
		{field:'BackOperDesc',title:'非计划重返',width:90,align:'left',hidden:ServerObj.CodeShowBackOper=='1'?false:true,
			editor:{
				type: 'combogrid',
				options: ComboDic('IsBackOper','',1)
			}
		},
		{field:'NNISLevelDesc',title:'手术风险等级',width:100,align:'left',hidden:ServerObj.CodeShowNNISLevel=='1'?false:true,
			editor:{
				type: 'combogrid',
				options: ComboDic('NNISLevel','',1)
			}
		},
		{field:'OperCatDesc',title:'手术类别',width:80,align:'left',hidden:ServerObj.CodeShowOperCat=='1'?false:true,
			editor:{
				type: 'combogrid',
				options: ComboDic('OperCat','',1)
			}
		},
		{field:'IsEmergencyDesc',title:'是否急诊',width:80,align:'left',hidden:ServerObj.CodeShowIsEmergency=='1'?false:true,
			editor:{
				type: 'combogrid',
				options: ComboDic('YesOrNo','',1)
			}
		},
		{field:'IsMiniInvaDesc',title:'是否微创',width:80,align:'left',hidden:ServerObj.CodeShowIsMiniInva=='1'?false:true,
			editor:{
				type: 'combogrid',
				options: ComboDic('YesOrNo','',1)
			}
		},
		{field:'IsChooseDateDesc',title:'是否择期',width:80,align:'left',hidden:ServerObj.CodeShowIsChooseDate=='1'?false:true,
			editor:{
				type: 'combogrid',
				options: ComboDic('YesOrNo','',1)
			}
		},
		{field:'AisOperID',title:'临床手术ID',width:80,align:'left',hidden:ServerObj.CodeShowAisOperID=='1'?false:true,
			editor:{
				type: 'combogrid',
				options: ComboAppointMent()
			}
		},
		{field:'MainOperDesc',title:'主手术',width:80,align:'left',hidden:ServerObj.CodeShowMainOper=='1'?false:true,
			editor:{
				type: 'combogrid',
				options: ComboDic('MainOper','',1)
			}
		}
    ]];
    var gridOper = $('#gridOper').datagrid({
		fit: true,
		headerCls:'panel-header-gray',
		iconCls:'icon-write-order',
		pagination: false,
		singleSelect: true,
		autoRowHeight: false,
		//fitColumns:true,
	    url:$URL,
	    queryParams:{
		    ClassName:"MA.IPMR.FPS.CodeOperSrv",
			QueryName:"QryOper",
			aVolumeID:ServerObj.VoumeID,
			aFPConfig:ServerObj.DefaultFPConfig
	    },
	    columns :columns,
	    rowStyler:setRowBgColor,
		onLoadSuccess:function(data){
			enableDnd();
		},
		onDblClickRow: function(index,row) {
			var eIndex = $(this).datagrid('getEditingRowIndexs')[0];
			if (typeof(eIndex)!='undefined') return;
			globalObj.m_cbgChangeValueType = 1;
			$(this).datagrid('beginEdit', index);
			enableDnd();
		},
		onClickRow:function(rowIndex, rowData) {
			var eIndex = $(this).datagrid('getEditingRowIndexs')[0];
			if (typeof(eIndex)=='undefined') return;
			// 结束上次编辑行
			SaveOper(1);
		},
		onBeginEdit: function(index,row) {
			editors = $(this).datagrid('getEditors',index);
			for (var i=0;i<editors.length;i++) {
				if (editors[i].field=='TypeDesc') editorType = editors[i].target;
				if (editors[i].field=='ICDDesc') editorICD = editors[i].target;
				if (editors[i].field=='SttDate') editorSttDate = editors[i].target;
				if (editors[i].field=='SttTime') editorSttTime = editors[i].target;
				if (editors[i].field=='EndDate') editorEndDate = editors[i].target;
				if (editors[i].field=='EndTime') editorEndTime = editors[i].target;
				if (editors[i].field=='Operator') editorOperator = editors[i].target;
				if (editors[i].field=='Assistant1') editorAssistant1 = editors[i].target;
				if (editors[i].field=='Assistant2') editorAssistant2 = editors[i].target;
				if (editors[i].field=='NarcosisTypeDesc') editorNarcosisType = editors[i].target;
				if (editors[i].field=='NarcosisDoc') editorNarcosisDoc = editors[i].target;
				if (editors[i].field=='CutTypeDesc') editorCutType = editors[i].target;
				if (editors[i].field=='HealingDesc') editorHealing = editors[i].target;
				if (editors[i].field=='OperLevelDesc') editorOperationRank = editors[i].target;
				if (editors[i].field=='AisOperID') editorAisOper = editors[i].target;
				if (editors[i].field=='MainOperDesc') editorMainOper = editors[i].target;
				if (editors[i].field=='NarcosisLevelDesc') editorNarcosisLevel = editors[i].target;
				if (editors[i].field=='OperSiteDesc') editorOperSite = editors[i].target;
				if (editors[i].field=='OperLocDesc') editorOperLoc= editors[i].target;
				if (editors[i].field=='BackOperDesc') editorBackOper= editors[i].target;
				if (editors[i].field=='NNISLevelDesc') editorNNISLevel= editors[i].target;
				if (editors[i].field=='OperCatDesc') editorOperCat= editors[i].target;
				if (editors[i].field=='DurationTime') editorDurationTime= editors[i].target;
				if (editors[i].field=='IsEmergencyDesc') editorIsEmergency= editors[i].target;
				if (editors[i].field=='IsMiniInvaDesc') editorIsMiniInva= editors[i].target;
				if (editors[i].field=='IsChooseDateDesc') editorIsChooseDate= editors[i].target;
				if (editors[i].field=='NarcosisSttDate') editorNarcosisSttDate= editors[i].target;
				if (editors[i].field=='NarcosisSttTime') editorNarcosisSttTime= editors[i].target;
				if (editors[i].field=='NarcosisEndDate') editorNarcosisEndDate= editors[i].target;
				if (editors[i].field=='NarcosisEndTime') editorNarcosisEndTime= editors[i].target;
			}
			setTimeout(function () {
				editorICD.combogrid('grid').datagrid("load",$.extend({},editorICD.combogrid('options').queryParams,{aICDDxID:row.ICDID}));
				editorOperator.combogrid('grid').datagrid("load",$.extend({},editorOperator.combogrid('options').queryParams,{aUserID:row.OperatorID}));
				editorAssistant1.combogrid('grid').datagrid("load",$.extend({},editorAssistant1.combogrid('options').queryParams,{aUserID:row.Assistant1ID}));
				editorAssistant2.combogrid('grid').datagrid("load",$.extend({},editorAssistant2.combogrid('options').queryParams,{aUserID:row.Assistant2ID}));
				editorNarcosisDoc.combogrid('grid').datagrid("load",$.extend({},editorNarcosisDoc.combogrid('options').queryParams,{aUserID:row.NarcosisDocID}));
				editorOperLoc.combogrid('grid').datagrid("load",$.extend({},editorOperLoc.combogrid('options').queryParams,{aID:row.OperLocID}));
			}, 30);
			setDisable();
			editorSttTime.keydown(function(e){
				if (e.keyCode==13) {
					var value = editorSttTime.timespinner('getValue');
					if (value!=='') {
						enterToNext(editorSttTime)
					}
				}
			});
			editorEndTime.keydown(function(e){
				if (e.keyCode==13) {
					var value = editorEndTime.timespinner('getValue');
					if (value!=='') {
						enterToNext(editorEndTime)
					}
				}
			});
			editorDurationTime.keydown(function(e){
				if (e.keyCode==13) {
					var value = editorDurationTime.val();
					if (value!=='') {
						enterToNext(editorDurationTime)
					}
				}
			});
			editorNarcosisSttTime.keydown(function(e){
				if (e.keyCode==13) {
					var value = editorNarcosisSttTime.timespinner('getValue');
					if (value!=='') {
						enterToNext(editorNarcosisSttTime)
					}
				}
			});
			editorNarcosisEndTime.keydown(function(e){
				if (e.keyCode==13) {
					var value = editorNarcosisEndTime.timespinner('getValue');
					if (value!=='') {
						enterToNext(editorNarcosisEndTime)
					}
				}
			});
			editorICD.combogrid("textbox").focus();
			globalObj.m_cbgChangeValueType = 0;
		},
		onStopDrag:function(row){
			if (globalObj.m_OperDrag!=1) return;
			var data=$('#gridOper').datagrid('getData');
			for(var ind=0;ind<data.total;ind++)
			{
				var tmpdata = data.rows[ind];
				tmpdata.Index=ind+1;
				$('#gridOper').datagrid('updateRow',{
					index: ind,	
					row: tmpdata
				});	
			}
			globalObj.m_OperDrag=0;
		},
		onDrop:function(targetRow, sourceRow,point){
			globalObj.m_OperDrag=1;
		}	
	});
	return gridOper;
}

// 设置编辑表格数据项的启用状态
function setDisable() {
	if (typeof(editors)=='undefined') return;
	for (var i=0;i<editors.length;i++) {
		if (editors[i].field=='SttTime') {
			if (ServerObj.CodeShowOperSttTime!=1) {
				editors[i].target.timespinner('setValue', '');
				editors[i].target.timespinner('disable');
			}
		}
		if (editors[i].field=='EndDate') {
			if (ServerObj.CodeShowOperEndDate!=1) {
				editors[i].target.datebox('setValue', '');
				editors[i].target.datebox('disable');
			}
		}
		if (editors[i].field=='EndTime') {
			if (ServerObj.CodeShowOperEndTime!=1) {
				editors[i].target.timespinner('setValue', '');
				editors[i].target.timespinner('disable');
			}
		}
		if (editors[i].field=='DurationTime') {
			if (ServerObj.CodeShowOperDurationTime!=1) {
				editors[i].target.val('')
				editors[i].target.attr('disabled','disabled')
			}
		}
		if (editors[i].field=='OperSiteDesc') {
			if (ServerObj.CodeShowOperSite!=1) {
				editors[i].target.combogrid('setValue', '');
				editors[i].target.combogrid('disable');
			}
		}
		if (editors[i].field=='OperLocDesc') {
			if (ServerObj.CodeShowOperLoc!=1) {
				editors[i].target.combogrid('setValue', '');
				editors[i].target.combogrid('disable');
			}
		}
		if (editors[i].field=='NarcosisLevelDesc') {
			if (ServerObj.CodeShowNarcosisLevel!=1) {
				editors[i].target.combogrid('setValue', '');
				editors[i].target.combogrid('disable');
			}
		}
		if (editors[i].field=='BackOperDesc') {
			if (ServerObj.CodeShowBackOper!=1) {
				editors[i].target.combogrid('setValue', '');
				editors[i].target.combogrid('disable');
			}
		}
		if (editors[i].field=='NNISLevelDesc') {
			if (ServerObj.CodeShowNNISLevel!=1) {
				editors[i].target.combogrid('setValue', '');
				editors[i].target.combogrid('disable');
			}
		}
		if (editors[i].field=='OperCatDesc') {
			if (ServerObj.CodeShowOperCat!=1) {
				editors[i].target.combogrid('setValue', '');
				editors[i].target.combogrid('disable');
			}
		}
		if (editors[i].field=='IsEmergencyDesc') {
			if (ServerObj.CodeShowIsEmergency!=1) {
				editors[i].target.combogrid('setValue', '');
				editors[i].target.combogrid('disable');
			}
		}
		if (editors[i].field=='IsMiniInvaDesc') {
			if (ServerObj.CodeShowIsMiniInva!=1) {
				editors[i].target.combogrid('setValue', '');
				editors[i].target.combogrid('disable');
			}
		}
		if (editors[i].field=='IsChooseDateDesc') {
			if (ServerObj.CodeShowIsChooseDate!=1) {
				editors[i].target.combogrid('setValue', '');
				editors[i].target.combogrid('disable');
			}
		}
		if (editors[i].field=='MainOperDesc') {
			if (ServerObj.CodeShowMainOper!=1) {
				editors[i].target.combogrid('setValue', '');
				editors[i].target.combogrid('disable');
			}
		}
		if (editors[i].field=='AisOperID') {
			if (ServerObj.CodeShowAisOperID!=1) {
				editors[i].target.combogrid('setValue', '');
				editors[i].target.combogrid('disable');
			}
		}
		if (editors[i].field=='NarcosisSttDate') {
			if (ServerObj.CodeShowNarcosisSttDate!=1) {
				editors[i].target.datebox('setValue', '');
				editors[i].target.datebox('disable');
			}
		}
		if (editors[i].field=='NarcosisSttTime') {
			if (ServerObj.CodeShowNarcosisSttTime!=1) {
				editors[i].target.timespinner('setValue', '');
				editors[i].target.timespinner('disable');
			}
		}
		if (editors[i].field=='NarcosisEndDate') {
			if (ServerObj.CodeShowNarcosisEndDate!=1) {
				editors[i].target.datebox('setValue', '');
				editors[i].target.datebox('disable');
			}
		}
		if (editors[i].field=='NarcosisEndTime') {
			if (ServerObj.CodeShowNarcosisEndTime!=1) {
				editors[i].target.timespinner('setValue', '');
				editors[i].target.timespinner('disable');
			}
		}
	}
}

// 行格式
function setRowBgColor(rowIndex, rowData) {
	if (rowData.EditFinish == '1'){
			return ''; //'background-color:#E1FFFF;';
	}else{
		return ''; //'background-color:#FFFFF0;';
	}
}

// 启用拖放
function enableDnd() {
	var eIndex = $('#gridOper').datagrid('getEditingRowIndexs')[0];
	if (typeof(eIndex)=='undefined') {
		$('#gridOper').datagrid('enableDnd');
	}else{
		$('#gridOper').datagrid('disableDnd');
	}
}
 /**
 * 提交编目时校验
 * @param {void}
 * @return {bollen}成功 true 失败 false
 */
function check() {
	var eIndex = $('#gridOper').datagrid('getEditingRowIndexs')[0];
	if (typeof(eIndex)=='undefined') {
		return true;
	}
	var ret = SaveOper(1);
	return ret;
}

 /**
 * 保存手术
 * @param {flag} 	1：保存按钮 0：单行回车后保存
 */
function SaveOper(flag){
	if (globalObj.m_isSave) {
		globalObj.m_isSave = false;
		setTimeout(function(){
			globalObj.m_isSave = true;
		},200);
	}else{
		return false;
	}
	var eIndex = $('#gridOper').datagrid('getEditingRowIndexs')[0];
	if (typeof(eIndex)=='undefined') {
		$.messager.popover({msg: '无正在编辑的数据...',type:'alert'});
		return false;
	}
	var select = $('#gridOper').datagrid('getSelected');
	if (select) {	// 序号
		var RowNumber = select.Index;	
	}else{
		var RowNumber = $('#gridOper').datagrid('getData').total+1;
	}
	RowNumber = parseInt(RowNumber)
	var eiditdata = $('#gridOper').datagrid('getData').rows[eIndex];
	var ClinicICDDesc = eiditdata.ClinicICDDesc;	
	var ClinicICD10 = eiditdata.ClinicICD10;

	// 手术类型
	var objType = editorType.combogrid('grid').datagrid('getSelected');
	var TypeID='',TypeDesc='',TypeCode='';
	if (objType!==null){
		TypeID = objType.ID;
		TypeDesc = objType.Desc;
		TypeCode = objType.Code;
	}else{
		TypeDesc = editorType.combogrid('getValue');
	}
	if (TypeID==''&&TypeDesc!='') {
		$.messager.popover({msg: '手术类型不标准...',type:'alert'});
		editorType.next().children(':first').focus();
		return false;
	}
	if ((TypeID=='')||(TypeDesc=='')){
		$.messager.popover({msg: '请录入手术类型...',type:'alert'});
		editorType.next().children(':first').focus();
		return false;
	}

	// 手术编码
	var objICD = editorICD.combogrid('grid').datagrid('getSelected');
	var ICDID = '',ICD10 = '',ICDDesc = '',ICDVerID = '';
	if (objICD!==null){
		ICDID = objICD.ID;
		ICD10 = objICD.ICD10;
		ICDDesc = objICD.Desc;
		ICDVerID  = objICD.VerID;
	}else{
		ICDDesc = editorICD.combogrid('getValue');
	}
	if (ICDID==''&&ICDDesc!='') {
		$.messager.popover({msg: '手术编码不标准...',type:'alert'});
		editorICD.next().children(':first').focus();
		return false;
	}
	if ((ICDID=='')||(ICD10=='')||(ICDDesc=='')){
		$.messager.popover({msg: '请录入手术编码...',type:'alert'});
		editorICD.next().children(':first').focus();
		return false;
	}

	// 手术开始日期
	var SttDate = editorSttDate.datebox('getValue');
	if (SttDate=='') {
		$.messager.popover({msg: '请录入手术日期...',type:'alert'});
		editorSttDate.next().children(":first").focus();
		return false;
	}

	// 手术开始时间
	var SttTime = '';
	if (ServerObj.CodeShowOperSttTime==1) {
		SttTime = editorSttTime.timespinner('getValue');
		if (SttTime=='') {
			$.messager.popover({msg: '请录入手术开始时间...',type:'alert'});
			editorSttTime.focus();
			return false;
		}
	}

	// 手术结束日期
	var EndDate = '';
	if (!editorEndDate.datebox('options').disabled) {
		EndDate = editorEndDate.datebox('getValue');
		if (EndDate=='') {
			$.messager.popover({msg: '请录入手术结束日期...',type:'alert'});
			editorEndDate.next().children(":first").focus();
			return false;
		}
	}

	// 手术结束时间
	var EndTime = '';
	if (ServerObj.CodeShowOperEndTime==1) {
		EndTime = editorEndTime.timespinner('getValue');
		if (EndTime=='') {
			$.messager.popover({msg: '请录入手术结束时间...',type:'alert'});
			editorEndTime.focus();
			return false;
		}
	}

	// 手术持续时间
	var DurationTime = '';
	if (editorDurationTime.attr('disabled')!=='disabled') {
		DurationTime = editorDurationTime.val();
		if (DurationTime=='') {
			$.messager.popover({msg: '请录入手术持续时间...',type:'alert'});
			editorDurationTime.focus();
			return false;
		}
	}

	// 手术部位
	var OperSiteID='',OperSiteDesc='';
	if (!editorOperSite.combogrid('options').disabled) {
		var record = editorOperSite.combogrid('grid').datagrid('getSelected');
		if (record!==null){
			OperSiteID = record.ID;
			OperSiteDesc = record.Desc;
		}else{
			OperSiteDesc = editorOperSite.combogrid('getValue');
		}
		if (OperSiteID==''&&OperSiteDesc!='') {
			$.messager.popover({msg: '手术部位不标准...',type:'alert'});
			editorOperSite.next().children(':first').focus();
			return false;
		}
		if ((OperSiteID=='')||(OperSiteDesc=='')){
			$.messager.popover({msg: '请录入手术部位...',type:'alert'});
			editorOperSite.next().children(':first').focus();
			return false;
		}
	}

	// 术者
	var objOperator = editorOperator.combogrid('grid').datagrid('getSelected');
	var OperatorID ='',Operator ='';
	if (objOperator!==null){
		OperatorID = objOperator.ID;
		Operator = objOperator.Desc;
	}else{
		Operator = editorOperator.combogrid('getValue');
	}
	if (OperatorID==''&&Operator!='') {
		$.messager.popover({msg: '术者不标准...',type:'alert'});
		editorOperator.next().children(':first').focus();
		return false;
	}
	if (OperatorID==''&&Operator=='') {
		$.messager.popover({msg: '请录入术者...',type:'alert'});
		editorOperator.next().children(':first').focus();
		return false;
	}

	// 术者所在科室
	var OperLocID='',OperLocDesc='',OperLocCode='';
	if (!editorOperLoc.combogrid('options').disabled) {
		var record = editorOperLoc.combogrid('grid').datagrid('getSelected');
		if (record!==null){
			OperLocID = record.ID;
			OperLocDesc = record.Desc;
			OperLocCode = record.Code;
		}else{
			OperLocDesc = editorOperLoc.combogrid('getValue');
		}
		if (OperLocID==''&&OperLocDesc!='') {
			$.messager.popover({msg: '术者所在科室不标准...',type:'alert'});
			editorOperLoc.next().children(':first').focus();
			return false;
		}
		if ((OperLocID=='')||(OperLocDesc=='')){
			$.messager.popover({msg: '请录入术者所在科室...',type:'alert'});
			editorOperLoc.next().children(':first').focus();
			return false;
		}
	}

	// 一助
	var objAssistant1 = editorAssistant1.combogrid('grid').datagrid('getSelected');
	var Assistant1ID ='',Assistant1 ='';
	if (objAssistant1!==null){
		Assistant1ID = objAssistant1.ID;
		Assistant1 = objAssistant1.Desc;
	}else{
		Assistant1 = editorAssistant1.combogrid('getValue');
	}
	if (Assistant1ID==''&&Assistant1!='') {
		$.messager.popover({msg: '一助不标准...',type:'alert'});
		editorAssistant1.next().children(':first').focus();
		return false;
	}

	// 二助
	var objAssistant2 = editorAssistant2.combogrid('grid').datagrid('getSelected');
	var Assistant2ID ='',Assistant2 ='';
	if (objAssistant2!==null){
		Assistant2ID = objAssistant2.ID;
		Assistant2 = objAssistant2.Desc;
	}else{
		Assistant2 = editorAssistant2.combogrid('getValue');
	}
	if (Assistant2ID==''&&Assistant2!='') {
		$.messager.popover({msg: '二助不标准...',type:'alert'});
		editorAssistant2.next().children(':first').focus();
		return false;
	}

	// 麻醉方式
	var objNarcosisType = editorNarcosisType.combogrid('grid').datagrid('getSelected');
	var NarcosisTypeID='',NarcosisTypeDesc='';
	if (objNarcosisType!==null){
		NarcosisTypeID = objNarcosisType.ID;
		NarcosisTypeDesc = objNarcosisType.Desc;
	}else{
		NarcosisTypeDesc = editorNarcosisType.combogrid('getValue');
	}
	if (NarcosisTypeID==''&&NarcosisTypeDesc!='') {
		$.messager.popover({msg: '麻醉方式不标准...',type:'alert'});
		editorNarcosisType.next().children(':first').focus();
		return false;
	}

	// 麻醉开始日期
	var NarcosisSttDate = '';
	if (!editorNarcosisSttDate.datebox('options').disabled) {
		NarcosisSttDate = editorNarcosisSttDate.datebox('getValue');
		/*if (NarcosisSttDate=='') {
			$.messager.popover({msg: '请录入麻醉开始日期...',type:'alert'});
			editorNarcosisSttDate.next().children(":first").focus();
			return false;
		}*/
	}

	// 麻醉开始时间
	var NarcosisSttTime = '';
	if (ServerObj.CodeShowNarcosisSttTime==1) {
		NarcosisSttTime = editorNarcosisSttTime.timespinner('getValue');
		/*if (NarcosisSttTime=='') {
			$.messager.popover({msg: '请录入麻醉开始时间...',type:'alert'});
			editorNarcosisSttTime.focus();
			return false;
		}*/
	}

	// 麻醉结束日期
	var NarcosisEndDate = '';
	if (!editorNarcosisEndDate.datebox('options').disabled) {
		NarcosisEndDate = editorNarcosisEndDate.datebox('getValue');
		/*if (NarcosisEndDate=='') {
			$.messager.popover({msg: '请录入麻醉结束日期...',type:'alert'});
			editorNarcosisEndDate.next().children(":first").focus();
			return false;
		}*/
	}

	// 麻醉结束时间
	var NarcosisEndTime = '';
	if (ServerObj.CodeShowNarcosisEndTime==1) {
		NarcosisEndTime = editorNarcosisEndTime.timespinner('getValue');
		/*if (NarcosisEndTime=='') {
			$.messager.popover({msg: '请录入麻醉结束时间...',type:'alert'});
			editorNarcosisEndTime.focus();
			return false;
		}*/
	}

	// 麻醉分级
	var NarcosisLevelID='',NarcosisLevelDesc='';
	if (!editorNarcosisLevel.combogrid('options').disabled) {
		var record = editorNarcosisLevel.combogrid('grid').datagrid('getSelected');
		if (record!==null){
			NarcosisLevelID = record.ID;
			NarcosisLevelDesc = record.Desc;
		}else{
			NarcosisLevelDesc = editorNarcosisLevel.combogrid('getValue');
		}
		if (NarcosisLevelID==''&&NarcosisLevelDesc!='') {
			$.messager.popover({msg: '麻醉分级不标准...',type:'alert'});
			editorNarcosisLevel.next().children(':first').focus();
			return false;
		}
	}

	// 麻醉医师
	var objNarcosisDoc = editorNarcosisDoc.combogrid('grid').datagrid('getSelected');
	var NarcosisDocID ='',NarcosisDoc ='';
	if (objNarcosisDoc!==null){
		NarcosisDocID = objNarcosisDoc.ID;
		NarcosisDoc = objNarcosisDoc.Desc;
	}else{
		NarcosisDoc = editorNarcosisDoc.combogrid('getValue');
	}
	if (NarcosisDocID==''&&NarcosisDoc!='') {
		$.messager.popover({msg: '麻醉医师不标准...',type:'alert'});
		editorNarcosisDoc.next().children(':first').focus();
		return false;
	}

	// 切口类型
	var objCutType = editorCutType.combogrid('grid').datagrid('getSelected');
	var CutTypeID='',CutTypeDesc='';
	if (objCutType!==null){
		CutTypeID = objCutType.ID;
		CutTypeDesc = objCutType.Desc;
	}else{
		CutTypeDesc = editorCutType.combogrid('getValue');
	}
	if (CutTypeID==''&&CutTypeDesc!='') {
		$.messager.popover({msg: '切口类型不标准...',type:'alert'});
		editorCutType.next().children(':first').focus();
		return false;
	}

	// 愈合情况
	var objHealing = editorHealing.combogrid('grid').datagrid('getSelected');
	var HealingID='',HealingDesc='';
	if (objHealing!==null){
		HealingID = objHealing.ID;
		HealingDesc = objHealing.Desc;
	}else{
		HealingDesc = editorHealing.combogrid('getValue');
	}
	if (HealingID==''&&HealingDesc!='') {
		$.messager.popover({msg: '愈合情况不标准...',type:'alert'});
		editorHealing.next().children(':first').focus();
		return false;
	}

	// 手术级别
	var OperLevelID='',OperLevelDesc='';
	var objOperLevel = editorOperationRank.combogrid('grid').datagrid('getSelected');
	if (objOperLevel!==null){
		OperLevelID = objOperLevel.ID;
		OperLevelDesc = objOperLevel.Desc;
	}else{
		OperLevelDesc = editorOperationRank.combogrid('getValue');
	}
	if (OperLevelID==''&&OperLevelDesc!='') {
		$.messager.popover({msg: '手术级别不标准...',type:'alert'});
		editorOperationRank.next().children(':first').focus();
		return false;
	}
	if ((OperLevelID=='')||(OperLevelDesc=='')){
		$.messager.popover({msg: '请录入手术级别...',type:'alert'});
		editorOperationRank.next().children(':first').focus();
		return false;
	}

	// 非计划重返
	var BackOperID='',BackOperDesc='';
	if (!editorBackOper.combogrid('options').disabled) {
		var record = editorBackOper.combogrid('grid').datagrid('getSelected');
		if (record!==null){
			BackOperID = record.ID;
			BackOperDesc = record.Desc;
		}else{
			BackOperDesc = editorBackOper.combogrid('getValue');
		}
		if (BackOperID==''&&BackOperDesc!='') {
			$.messager.popover({msg: '非计划重返不标准...',type:'alert'});
			editorBackOper.next().children(':first').focus();
			return false;
		}
	}

	// 手术风险等级
	var NNISLevelID='',NNISLevelDesc='';
	if (!editorNNISLevel.combogrid('options').disabled) {
		var record = editorNNISLevel.combogrid('grid').datagrid('getSelected');
		if (record!==null){
			NNISLevelID = record.ID;
			NNISLevelDesc = record.Desc;
		}else{
			NNISLevelDesc = editorNNISLevel.combogrid('getValue');
		}
		if (NNISLevelID==''&&NNISLevelDesc!='') {
			$.messager.popover({msg: '手术风险等级不标准...',type:'alert'});
			editorNNISLevel.next().children(':first').focus();
			return false;
		}
	}

	// 手术类别
	var OperCatID='',OperCatDesc='';
	if (!editorOperCat.combogrid('options').disabled) {
		var record = editorOperCat.combogrid('grid').datagrid('getSelected');
		if (record!==null){
			OperCatID = record.ID;
			OperCatDesc = record.Desc;
		}else{
			OperCatDesc = editorOperCat.combogrid('getValue');
		}
		if (OperCatID==''&&OperCatDesc!='') {
			$.messager.popover({msg: '手术类别不标准...',type:'alert'});
			editorOperCat.next().children(':first').focus();
			return false;
		}
	}

	// 是否急诊
	var IsEmergencyID='',IsEmergencyDesc='';
	if (!editorIsEmergency.combogrid('options').disabled) {
		var record = editorIsEmergency.combogrid('grid').datagrid('getSelected');
		if (record!==null){
			IsEmergencyID = record.ID;
			IsEmergencyDesc = record.Desc;
		}else{
			IsEmergencyDesc = editorIsEmergency.combogrid('getValue');
		}
		if (IsEmergencyID==''&&IsEmergencyDesc!='') {
			$.messager.popover({msg: '是否急诊不标准...',type:'alert'});
			editorIsEmergency.next().children(':first').focus();
			return false;
		}
	}

	// 是否微创
	var IsMiniInvaID='',IsMiniInvaDesc='';
	if (!editorIsMiniInva.combogrid('options').disabled) {
		var record = editorIsMiniInva.combogrid('grid').datagrid('getSelected');
		if (record!==null){
			IsMiniInvaID = record.ID;
			IsMiniInvaDesc = record.Desc;
		}else{
			IsMiniInvaDesc = editorIsMiniInva.combogrid('getValue');
		}
		if (IsMiniInvaID==''&&IsMiniInvaDesc!='') {
			$.messager.popover({msg: '是否微创不标准...',type:'alert'});
			editorIsMiniInva.next().children(':first').focus();
			return false;
		}
	}
	
	// 是否择期
	var IsChooseDateID='',IsChooseDateDesc='';
	if (!editorIsChooseDate.combogrid('options').disabled) {
		var record = editorIsChooseDate.combogrid('grid').datagrid('getSelected');
		if (record!==null){
			IsChooseDateID = record.ID;
			IsChooseDateDesc = record.Desc;
		}else{
			IsChooseDateDesc = editorIsChooseDate.combogrid('getValue');
		}
		if (IsChooseDateID==''&&IsChooseDateDesc!='') {
			$.messager.popover({msg: '是否择期不标准...',type:'alert'});
			editorIsChooseDate.next().children(':first').focus();
			return false;
		}
	}

	// 临床手术ID
	var AisOperID=''
	if (!editorAisOper.combogrid('options').disabled) {
		var record = editorAisOper.combogrid('grid').datagrid('getSelected');
		if (record!==null){
			AisOperID = record.RowId;
		}
		if (AisOperID==''){
			$.messager.popover({msg: '请录入临床手术IDD...',type:'alert'});
			editorAisOper.next().children(':first').focus();
			return false;
		}
	}

	// 主手术
	var MainOperID='',MainOperDesc='';
	if (!editorMainOper.combogrid('options').disabled) {
		var record = editorMainOper.combogrid('grid').datagrid('getSelected');
		if (record!==null){
			MainOperID = record.ID;
			MainOperDesc = record.Desc;
		}else{
			MainOperDesc = editorMainOper.combogrid('getValue');
		}
		if (MainOperID==''&&MainOperDesc!='') {
			$.messager.popover({msg: '主手术不标准...',type:'alert'});
			editorMainOper.next().children(':first').focus();
			return false;
		}
	}
	var AppendOper	= '';	// 附属手术
	if (flag=="ADD"){
		AppendOper	= 1;
	}else if (flag=="CLEAR"){
		AppendOper	= '';
	}else{
		if (select) {
			AppendOper	= select.AppendOper;
		}	
	}

	var row = $('#gridOper').datagrid('getRows')[eIndex]
	var data = {
		Index:row.Index,
		VolumeID:row.VolumeID,
		MasterID:row.MasterID,
		TypeID:TypeID,
		TypeCode:TypeCode,
		TypeDesc:TypeDesc,
		ICDVerID:ICDVerID,
		ICDID:ICDID,
		ICD10:ICD10,
		ICDDesc:ICDDesc,
		SttDate:SttDate,
		SttTime:SttTime,
		EndDate:EndDate,
		EndTime:EndTime,
		OperatorID:OperatorID,
		Operator:Operator,
		Assistant1ID:Assistant1ID,
		Assistant1:Assistant1,
		Assistant2ID:Assistant2ID,
		Assistant2:Assistant2,
		NarcosisTypeID:NarcosisTypeID,
		NarcosisTypeDesc:NarcosisTypeDesc,
		NarcosisDocID:NarcosisDocID,
		NarcosisDoc:NarcosisDoc,
		CutTypeID:CutTypeID,
		CutTypeDesc:CutTypeDesc,
		HealingID:HealingID,
		HealingDesc:HealingDesc,
		OperLevelID:OperLevelID,
		OperLevelDesc:OperLevelDesc,
		MainOperID:MainOperID,
		MainOperDesc:MainOperDesc,
		AisOperID:AisOperID,
		AppendOper:AppendOper,
		EditFinish:1,
		NarcosisLevelID:NarcosisLevelID,
		NarcosisLevelDesc:NarcosisLevelDesc,
		DurationTime:DurationTime,
		OperSiteID:OperSiteID,
		OperSiteDesc:OperSiteDesc,
		OperLocID:OperLocID,
		OperLocCode:OperLocCode,
		OperLocDesc:OperLocDesc,
		BackOperID:BackOperID,
		BackOperDesc:BackOperDesc,
		NNISLevelID:NNISLevelID,
		NNISLevelDesc:NNISLevelDesc,
		OperCatID:OperCatID,
		OperCatDesc:OperCatDesc,
		ClinicICDDesc:ClinicICDDesc,
		ClinicICD10:ClinicICD10,
		IsEmergencyID:IsEmergencyID,
		IsEmergencyDesc:IsEmergencyDesc,
		IsMiniInvaID:IsMiniInvaID,
		IsMiniInvaDesc:IsMiniInvaDesc,
		IsChooseDateID:IsChooseDateID,
		IsChooseDateDesc:IsChooseDateDesc,
		NarcosisSttDate:NarcosisSttDate,
		NarcosisSttTime:NarcosisSttTime,
		NarcosisEndDate:NarcosisEndDate,
		NarcosisEndTime:NarcosisEndTime
	}
	$('#gridOper').datagrid('endEdit', eIndex);
	$('#gridOper').datagrid('updateRow',{
		index: eIndex,	
		row: data
	});
	if (flag==0) {
		// 选中下一行
		if (eIndex<($('#gridOper').datagrid('getData').total-1)) {
			globalObj.m_cbgChangeValueType=1;
			$('#gridOper').datagrid('selectRow',eIndex+1);
			$('#gridOper').datagrid('beginEdit',eIndex+1);
		}else{
			$('#gridOper').datagrid('unselectAll');
		}
	}
	enableDnd();
	return true;
}

// 删除手术
function CancelOper(){
	var select = $('#gridOper').datagrid('getSelected');
	if (select==null) {	
		$.messager.popover({msg: '请选择一条手术数据！',type: 'alert',timeout: 1000});
		return false;
	}else{
		var RowNumber = select.Index;	//手术的序号
		var rowindex = RowNumber-1
		$.messager.confirm('删除','确定删除第'+RowNumber+'条手术?',function(r){
		    if (r){
				$('#gridOper').datagrid('deleteRow',rowindex);
				var gridOperData = $('#gridOper').datagrid('getData'); 
				for (var i = 0 ;i<gridOperData.total; i ++ ) {
					var rowdata = gridOperData.rows[i];
					rowdata.Index =(i+1);
					$('#gridOper').datagrid('updateRow',{
						index: i,	
						row: rowdata
					});
					globalObj.m_OperSelectindex='';
				}
		    }
		});
	}
}

// 编目手术移动
function moveOper(type){
	var select = $('#gridOper').datagrid('getSelected');
	if (select==null) {	
		$.messager.popover({msg: '请选择一条手术数据！',type: 'alert',timeout: 1000});
		return false;
	}
	var RowNumber = select.Index;	//手术的序号
	var rowindex = parseInt(RowNumber)-1
	if (type=='up'){
		if (rowindex!=0) {
			moveUpOper(rowindex);
			$('#gridOper').datagrid('selectRow',rowindex-1)
		}
	}
	if (type=='down'){
		if (rowindex<($('#gridOper').datagrid('getData').total-1)){
			moveUpOper(rowindex+1);
			$('#gridOper').datagrid('selectRow',rowindex+1)
		}
	}
}

// 上移编目手术
function moveUpOper(index){
	if (index!=0){
		var toupdata = $('#gridOper').datagrid('getData').rows[index];
		var todowndata = $('#gridOper').datagrid('getData').rows[index-1];
		var tmpdata = {
			Index:parseInt(todowndata.Index)+1,
			VolumeID:todowndata.VolumeID,
			MasterID:todowndata.MasterID,
			TypeID:todowndata.TypeID,
			TypeCode:todowndata.TypeCode,
			TypeDesc:todowndata.TypeDesc,
			ICDVerID:todowndata.ICDVerID,
			ICDID:todowndata.ICDID,
			ICD10:todowndata.ICD10,
			ICDDesc:todowndata.ICDDesc,
			SttDate:todowndata.SttDate,
			SttTime:todowndata.SttTime,
			EndDate:todowndata.EndDate,
			EndTime:todowndata.EndTime,
			OperatorID:todowndata.OperatorID,
			Operator:todowndata.Operator,
			Assistant1ID:todowndata.Assistant1ID,
			Assistant1:todowndata.Assistant1,
			Assistant2ID:todowndata.Assistant2ID,
			Assistant2:todowndata.Assistant2,
			NarcosisTypeID:todowndata.NarcosisTypeID,
			NarcosisTypeDesc:todowndata.NarcosisTypeDesc,
			NarcosisDocID:todowndata.NarcosisDocID,
			NarcosisDoc:todowndata.NarcosisDoc,
			CutTypeID:todowndata.CutTypeID,
			CutTypeDesc:todowndata.CutTypeDesc,
			HealingID:todowndata.HealingID,
			HealingDesc:todowndata.HealingDesc,
			OperLevelID:todowndata.OperLevelID,
			OperLevelDesc:todowndata.OperLevelDesc,
			MainOperID:todowndata.MainOperID,
			MainOperDesc:todowndata.MainOperDesc,
			AisOperID:todowndata.AisOperID,
			AppendOper:'',		// 上下移,相关两条手术附属标志置 否
			EditFinish:(!todowndata.EditFinish)?0:1,		// 此条是否已点保存
			NarcosisLevelID:todowndata.NarcosisLevelID,
			NarcosisLevelDesc:todowndata.NarcosisLevelDesc,
			DurationTime:todowndata.DurationTime,
			OperSiteID:todowndata.OperSiteID,
			OperSiteDesc:todowndata.OperSiteDesc,
			OperLocID:todowndata.OperLocID,
			OperLocCode:todowndata.OperLocCode,
			OperLocDesc:todowndata.OperLocDesc,
			BackOperID:todowndata.BackOperID,
			BackOperDesc:todowndata.BackOperDesc,
			NNISLevelID:todowndata.NNISLevelID,
			NNISLevelDesc:todowndata.NNISLevelDesc,
			OperCatID:todowndata.OperCatID,
			OperCatDesc:todowndata.OperCatDesc,
			ClinicICDDesc:todowndata.ClinicICDDesc,
			ClinicICD10:todowndata.ClinicICD10,
			IsEmergencyID:todowndata.IsEmergencyID,
			IsEmergencyDesc:todowndata.IsEmergencyDesc,
			IsMiniInvaID:todowndata.IsMiniInvaID,
			IsMiniInvaDesc:todowndata.IsMiniInvaDesc,
			IsChooseDateID:todowndata.IsChooseDateID,
			IsChooseDateDesc:todowndata.IsChooseDateDesc,
			NarcosisSttDate:todowndata.NarcosisSttDate,
			NarcosisSttTime:todowndata.NarcosisSttTime,
			NarcosisEndDate:todowndata.NarcosisEndDate,
			NarcosisEndTime:todowndata.NarcosisEndTime
		}
		if (!toupdata.EditFinish){
			toupdata.EditFinish=0;
		}else{
			toupdata.EditFinish=1;
		}
		toupdata.Index = toupdata.Index-1;
		toupdata.AppendOper='';		// 上下移,相关两条手术附属标志置 否
		$('#gridOper').datagrid('updateRow',{
			index: index-1,	
			row: toupdata
		});
		$('#gridOper').datagrid('updateRow',{
			index: index,	
			row: tmpdata
		});
	}
}

// 复制手术
function CopyOper(aFlag){
	var select = $('#gridOper').datagrid('getSelected');
	if ((aFlag=="Copy")&&(select==null)) {	
		$.messager.popover({msg: '请选择一条手术数据！',type: 'alert',timeout: 1000});
		return false;
	}
	var data	= $("#gridOper").datagrid("getData");
	var length	= data.total;
	
	var RowNumber = length    //插入时候，不选行，插入到最后一行的下行
	if (select!=null) RowNumber = select.Index;	//选行的话，选中行手术的序号
	RowNumber = parseInt(RowNumber)
	if (aFlag=="Copy"){
		var rowdata = {
			Index:RowNumber+1,
			VolumeID:'',
			MasterID:'',
			TypeID:'',
			TypeCode:'',
			TypeDesc:'',
			ICDVerID:'',
			ICDID:'',
			ICD10:'',
			ICDDesc:'',
			SttDate:(typeof(select.SttDate)=='undefined')?'':select.SttDate,
			SttTime:(typeof(select.SttTime)=='undefined')?'':select.SttTime,
			EndDate:(typeof(select.EndDate)=='undefined')?'':select.EndDate,
			EndTime:(typeof(select.EndTime)=='undefined')?'':select.EndTime,
			OperatorID:(typeof(select.OperatorID)=='undefined')?'':select.OperatorID,
			Operator:(typeof(select.Operator)=='undefined')?'':select.Operator,
			Assistant1ID:(typeof(select.Assistant1ID)=='undefined')?'':select.Assistant1ID,
			Assistant1:(typeof(select.Assistant1)=='undefined')?'':select.Assistant1,
			Assistant2ID:(typeof(select.Assistant2ID)=='undefined')?'':select.Assistant2ID,
			Assistant2:(typeof(select.Assistant2)=='undefined')?'':select.Assistant2,
			NarcosisTypeID:(typeof(select.NarcosisTypeID)=='undefined')?'':select.NarcosisTypeID,
			NarcosisTypeDesc:(typeof(select.NarcosisTypeDesc)=='undefined')?'':select.NarcosisTypeDesc,
			NarcosisDocID:(typeof(select.NarcosisDocID)=='undefined')?'':select.NarcosisDocID,
			NarcosisDoc:(typeof(select.NarcosisDoc)=='undefined')?'':select.NarcosisDoc,
			CutTypeID:(typeof(select.CutTypeID)=='undefined')?'':select.CutTypeID,
			CutTypeDesc:(typeof(select.CutTypeDesc)=='undefined')?'':select.CutTypeDesc,
			HealingID:(typeof(select.HealingID)=='undefined')?'':select.HealingID,
			HealingDesc:(typeof(select.HealingDesc)=='undefined')?'':select.HealingDesc,
			OperLevelID:(typeof(select.OperLevelID)=='undefined')?'':select.OperLevelID,
			OperLevelDesc:(typeof(select.OperLevelDesc)=='undefined')?'':select.OperLevelDesc,
			MainOperID:'',
			MainOperDesc:'',
			AppendOper:1,
			EditFinish:0,
			AisOperID:(typeof(select.AisOperID)=='undefined')?'':select.AisOperID,
			NarcosisLevelID:(typeof(select.NarcosisLevelID)=='undefined')?'':select.NarcosisLevelID,
			NarcosisLevelDesc:(typeof(select.NarcosisLevelDesc)=='undefined')?'':select.NarcosisLevelDesc,
			DurationTime:(typeof(select.DurationTime)=='undefined')?'':select.DurationTime,
			OperSiteID:(typeof(select.OperSiteID)=='undefined')?'':select.OperSiteID,
			OperSiteDesc:(typeof(select.OperSiteDesc)=='undefined')?'':select.OperSiteDesc,
			OperLocID:(typeof(select.OperLocID)=='undefined')?'':select.OperLocID,
			OperLocCode:(typeof(select.OperLocCode)=='undefined')?'':select.OperLocCode,
			OperLocDesc:(typeof(select.OperLocDesc)=='undefined')?'':select.OperLocDesc,
			BackOperID:(typeof(select.BackOperID)=='undefined')?'':select.BackOperID,
			BackOperDesc:(typeof(select.BackOperDesc)=='undefined')?'':select.BackOperDesc,
			NNISLevelID:(typeof(select.NNISLevelID)=='undefined')?'':select.NNISLevelID,
			NNISLevelDesc:(typeof(select.NNISLevelDesc)=='undefined')?'':select.NNISLevelDesc,
			OperCatID:(typeof(select.OperCatID)=='undefined')?'':select.OperCatID,
			OperCatDesc:(typeof(select.OperCatDesc)=='undefined')?'':select.OperCatDesc,
			ClinicICDDesc:(typeof(select.ClinicICDDesc)=='undefined')?'':select.ClinicICDDesc,
			ClinicICD10:(typeof(select.ClinicICD10)=='undefined')?'':select.ClinicICD10,
			IsEmergencyID:(typeof(select.IsEmergencyID)=='undefined')?'':select.IsEmergencyID,
			IsEmergencyDesc:(typeof(select.IsEmergencyDesc)=='undefined')?'':select.IsEmergencyDesc,
			IsMiniInvaID:(typeof(select.IsMiniInvaID)=='undefined')?'':select.IsMiniInvaID,
			IsMiniInvaDesc:(typeof(select.IsMiniInvaDesc)=='undefined')?'':select.IsMiniInvaDesc,
			IsChooseDateID:(typeof(select.IsChooseDateID)=='undefined')?'':select.IsChooseDateID,
			IsChooseDateDesc:(typeof(select.IsChooseDateDesc)=='undefined')?'':select.IsChooseDateDesc,
			NarcosisSttDate:(typeof(select.NarcosisSttDate)=='undefined')?'':select.NarcosisSttDate,
			NarcosisSttTime:(typeof(select.NarcosisSttTime)=='undefined')?'':select.NarcosisSttTime,
			NarcosisEndDate:(typeof(select.NarcosisEndDate)=='undefined')?'':select.NarcosisEndDate,
			NarcosisEndTime:(typeof(select.NarcosisEndTime)=='undefined')?'':select.NarcosisEndTime
		}
	}else{
		var rowdata = {
			Index:RowNumber+1,
			VolumeID:'',
			MasterID:'',
			TypeID:'',
			TypeCode:'',
			TypeDesc:'',
			ICDVerID:'',
			ICDID:'',
			ICD10:'',
			ICDDesc:'',
			//SttDate:(typeof(select.SttDate)=='undefined')?'':select.SttDate,
			SttDate:'',
			SttTime:'',
			EndDate:'',
			EndTime:'',
			OperatorID:'',
			Operator:'',
			Assistant1ID:'',
			Assistant1:'',
			Assistant2ID:'',
			Assistant2:'',
			NarcosisTypeID:'',
			NarcosisTypeDesc:'',
			NarcosisDocID:'',
			NarcosisDoc:'',
			CutTypeID:'',
			CutTypeDesc:'',
			HealingID:'',
			HealingDesc:'',
			OperLevelID:'',
			OperLevelDesc:'',
			MainOperID:'',
			MainOperDesc:'',
			AppendOper:1,
			EditFinish:0,
			AisOperID:'',
			NarcosisLevelID:'',
			NarcosisLevelDesc:'',
			DurationTime:'',
			OperSiteID:'',
			OperSiteDesc:'',
			OperLocID:'',
			OperLocCode:'',
			OperLocDesc:'',
			BackOperID:'',
			BackOperDesc:'',
			NNISLevelID:'',
			NNISLevelDesc:'',
			OperCatID:'',
			OperCatDesc:'',
			ClinicICDDesc:'',
			ClinicICD10:'',
			IsEmergencyID:'',
			IsEmergencyDesc:'',
			IsMiniInvaID:'',
			IsMiniInvaDesc:'',
			IsChooseDateID:'',
			IsChooseDateDesc:'',
			NarcosisSttDate:'',
			NarcosisSttTime:'',
			NarcosisEndDate:'',
			NarcosisEndTime:''
		}
	}
	var Index = RowNumber	// 插入行的索引
	$('#gridOper').datagrid('insertRow',{
		index: Index,
		row: rowdata
	});
	var gridOperData=$('#gridOper').datagrid('getData');
	for (var i = 0 ;i<gridOperData.total; i ++ ) {
		var rowdata = gridOperData.rows[i];
		rowdata.Index =(i+1);
		$('#gridOper').datagrid('updateRow',{
			index: i,	
			row: rowdata
		});
		globalObj.m_OperSelectindex='';
	}
	$('#gridOper').datagrid('selectRow',Index);
	$('#gridOper').datagrid('beginEdit',Index);
	enableDnd();
}

// 组织编目手术数据
 function getOper(status){
 	var data = $('#gridOper').datagrid('getData')
 	var strResult = '';
	for (var ind = 0; ind < data.total; ind++){
		var strTemp = '';
		var record = data.rows[ind];
		if (status == 'R'){	//草稿数据
			strTemp = record.ICDID
			strTemp += '^' + record.ICDVerID
			strTemp += '^' + record.ICD10
			strTemp += '^' + record.ICDDesc
			strTemp += '^' + record.TypeID
			strTemp += '^' + record.TypeCode
			strTemp += '^' + record.TypeDesc
			strTemp += '^' + record.SttDate
			strTemp += '^' + record.SttTime
			strTemp += '^' + record.EndDate
			strTemp += '^' + record.EndTime
			strTemp += '^' + record.OperatorID
			strTemp += '^' + record.Operator
			strTemp += '^' + record.Assistant1ID
			strTemp += '^' + record.Assistant1
			strTemp += '^' + record.Assistant2ID
			strTemp += '^' + record.Assistant2
			strTemp += '^' + record.NarcosisTypeID
			strTemp += '^' + record.NarcosisTypeDesc
			strTemp += '^' + record.NarcosisDocID
			strTemp += '^' + record.NarcosisDoc
			strTemp += '^' + record.CutTypeID
			strTemp += '^' + record.CutTypeDesc
			strTemp += '^' + record.HealingID
			strTemp += '^' + record.HealingDesc
			strTemp += '^' + record.OperLevelID
			strTemp += '^' + record.OperLevelDesc
			strTemp += '^' + record.MainOperID
			strTemp += '^' + record.MainOperDesc
			strTemp += '^' + record.AppendOper	// 附加手术
			strTemp += '^' + record.AisOperID	// 临床手术ID
			strTemp += '^' + record.NarcosisLevelID
			strTemp += '^' + record.NarcosisLevelDesc
			strTemp += '^' + record.OperSiteID
			strTemp += '^' + record.OperSiteDesc
			strTemp += '^' + record.OperLocID
			strTemp += '^' + record.OperLocCode
			strTemp += '^' + record.OperLocDesc
			strTemp += '^' + record.BackOperID
			strTemp += '^' + record.BackOperDesc
			strTemp += '^' + record.NNISLevelID
			strTemp += '^' + record.NNISLevelDesc
			strTemp += '^' + record.OperCatID
			strTemp += '^' + record.OperCatDesc
			strTemp += '^' + record.DurationTime
			strTemp += '^' + record.ClinicICDDesc
			strTemp += '^' + record.IsEmergencyID
			strTemp += '^' + record.IsEmergencyDesc
			strTemp += '^' + record.IsMiniInvaID
			strTemp += '^' + record.IsMiniInvaDesc
			strTemp += '^' + record.IsChooseDateID
			strTemp += '^' + record.IsChooseDateDesc
			strTemp += '^' + record.NarcosisSttDate
			strTemp += '^' + record.NarcosisSttTime
			strTemp += '^' + record.NarcosisEndDate
			strTemp += '^' + record.NarcosisEndTime
			strTemp += '^' + record.ClinicICD10
		}
		if (strResult != '') strResult += CHR_1
		strResult += CHR_2 + record.Index
		strResult += CHR_2 + record.ICDID
		strResult += CHR_2 + record.TypeID
		strResult += CHR_2 + record.SttDate
		strResult += CHR_2 + record.SttTime
		strResult += CHR_2 + record.EndDate
		strResult += CHR_2 + record.EndTime
		strResult += CHR_2 + record.OperatorID
		strResult += CHR_2 + record.Operator
		strResult += CHR_2 + record.Assistant1ID
		strResult += CHR_2 + record.Assistant1
		strResult += CHR_2 + record.Assistant2ID
		strResult += CHR_2 + record.Assistant2
		strResult += CHR_2 + record.NarcosisTypeID
		strResult += CHR_2 + record.NarcosisDocID
		strResult += CHR_2 + record.NarcosisDoc
		strResult += CHR_2 + record.CutTypeID
		strResult += CHR_2 + record.HealingID
		strResult += CHR_2 + record.OperLevelID
		strResult += CHR_2 + record.MainOperID
		strResult += CHR_2 + strTemp
		strResult += CHR_2 + record.AppendOper
		strResult += CHR_2 + record.AisOperID
		strResult += CHR_2 + record.NarcosisLevelID
		strResult += CHR_2 + record.OperSiteID
		strResult += CHR_2 + record.OperLocID
		strResult += CHR_2 + record.BackOperID
		strResult += CHR_2 + record.NNISLevelID
		strResult += CHR_2 + record.OperCatID
		strResult += CHR_2 + record.DurationTime
		strResult += CHR_2 + record.ClinicICDDesc
		strResult += CHR_2 + record.IsEmergencyID
		strResult += CHR_2 + record.IsMiniInvaID
		strResult += CHR_2 + record.IsChooseDateID
		strResult += CHR_2 + record.NarcosisSttDate
		strResult += CHR_2 + record.NarcosisSttTime
		strResult += CHR_2 + record.NarcosisEndDate
		strResult += CHR_2 + record.NarcosisEndTime
		strResult += CHR_2 + record.ClinicICD10
	}
	return strResult;
 }

// 禁用浏览器默认的 ctr+s，ctrl+加号，ctrl+减号
$(document).bind('keydown keypress', 'ctrl+s', function(e){
	var KCode		= window.event.keyCode;
	var shiftKey	= window.event.shiftKey;
	var ctrlKey		= window.event.ctrlKey;
	if ((ctrlKey)&&(KCode==83)){
		e.preventDefault();
		return false;
	}
	// ctrl+加号
	if (((ctrlKey)&&(KCode==107))||((ctrlKey)&&(KCode==187))){
		e.preventDefault();
		return false;
	}
	// ctrl+减号
	if (((ctrlKey)&&(KCode==109))||((ctrlKey)&&(KCode==189))){
		e.preventDefault();
		return false;
	}
});

// 快捷方式
document.onkeyup=function(){	// onkeydown
	var KCode		= window.event.keyCode;
	var shiftKey	= window.event.shiftKey;
	var ctrlKey		= window.event.ctrlKey;
	if ((ctrlKey)&&(KCode==83)){
		SaveOper(1);	// 前台手术信息存入表格
		return;
	}
	if ((ctrlKey)&&(KCode==68)){
		CancelOper();
		return;
	}
	if (KCode==115){	  // F4 
		window.parent.window.SaveResult("C");
		return;
	}
	
	if (ServerObj.EnableAppendOper==1){	// 启用附属手术
		// ctrl+加号
		if (((ctrlKey)&&(KCode==107))||((ctrlKey)&&(KCode==187))){
			var selectedOper = $('#gridOper').datagrid('getSelected');
			if (selectedOper==null){
				$.messager.popover({msg: '请选中一条手术...',type:'error'});
				return false;
			}
			if (selectedOper.Index==1){
				$.messager.popover({msg: '第一条手术不能作为附加手术!',type:'error'});
				return false;
			}
			if (selectedOper.AppendOper==1){
				$.messager.popover({msg: '已是附属手术,不要重复设置!',type:'error'});
				return false;
			}

			var eIndex = $('#gridOper').datagrid('getEditingRowIndexs')[0];
			if (typeof(eIndex)=='undefined') {
				$('#gridOper').datagrid('updateRow',{
					index: parseInt(selectedOper.Index-1),
					row: {
						AppendOper: '1'
					}
				});
				return false;
			}else{
				SaveOper('ADD');
			}
		}
		// ctrl+减号
		if (((ctrlKey)&&(KCode==109))||((ctrlKey)&&(KCode==189))){
			var selectedOper = $('#gridOper').datagrid('getSelected');
			if (selectedOper==null){
				$.messager.popover({msg: '请选中一条手术...',type:'error'});
				return false;
			}
			
			if (selectedOper.AppendOper!='1'){
				$.messager.popover({msg: '已非附属手术,不要重复取消!',type:'error'});
				return false;
			}

			var eIndex = $('#gridOper').datagrid('getEditingRowIndexs')[0];
			if (typeof(eIndex)=='undefined') {
				$('#gridOper').datagrid('updateRow',{
					index: parseInt(selectedOper.Index-1),
					row: {
						AppendOper: ''
					}
				});
				return false;
			}else{
				SaveOper('CLEAR');
			}
		}
	}
}

/**
 * 从电子病历增加诊断行
 * @param {type} 手术类型代码：编目数据项代码前两位,如O01
 * @return {Boolean} True 正常, false 异常
 */
function addEmrData(type)
{
	try {
		$cm({
	    	ClassName:"MA.IPMR.FPS.CodeOperSrv",
	    	QueryName:"QryOper",
	    	aVolumeID:ServerObj.VoumeID,
			aFPConfig:ServerObj.DefaultFPConfig,
	    	aEmrFlag:1,
	    	aOperTypeCode:type.split('^')[0],
	    	aOperRowNum:type.split('^')[1],
	    	page:1,
	    	rows:10000
	    },function(rs){
	    	if (rs.total==0) return;
			var Index = $('#gridOper').datagrid('getData').total;
	    	rs.rows[0].Index=Index+1;
	    	$('#gridOper').datagrid('appendRow',rs.rows[0]);
	    });
	}catch(e){
		return false;
	}
	return true;
}

/**
 * 可编辑表格字典下拉框
 * @param {dicType} 	字典类型代码
 * @param {hospId} 		医院ID
 * @param {isActive} 	字典有效标志
 * @return {cmp}下拉组件
 */
function ComboDic(dicType,hospId,isActive) {
	var cbg = {
		url: $URL,
		idField:'Desc',
		textField: 'Desc',
		fitColumns:true,
		panelWidth:300,
		mode:'remote',
		panelHeight:250,
		enterNullValueClear:false,
		selectOnNavigation:false,
		queryParams:{
		    ClassName:'CT.IPMR.BTS.DictionarySrv',
			QueryName:'QryDictionary',
			aDicType:dicType,
			aIsActive:isActive,
			aHospID:hospId,
			aAlias:'',
			rows:1000
		},
		columns: [[
			{field:'Code',title:'代码',width:50},
		    {field:'Desc',title:'描述',width:200}
		]],
		onChange:function(newValue, oldValue){
			if (globalObj.m_cbgChangeValueType) return;
		},
		keyHandler: {
			up: function(e) {
				navcbg(this,'prev');
				e.preventDefault();
			},
			down: function(e) {
				navcbg(this,'next');
				e.preventDefault();
			},
			enter: function(e) {
				var record = $(this).combogrid("grid").datagrid("getSelected");
				if (record==null) {
					entercbg(this);
				}else{
					$(this).combogrid("hidePanel");
					enterToNext(this);
				}
				e.preventDefault();
			},
			query: function(q,e) {
				if (q=="") {
					$(this).combogrid("clear");
					$(this).combogrid("hidePanel");
				}
				qrycbg(this,q);
				var target = this;
				setTimeout(function(){
					navcbg(target,'next');
				},200);
			}
		}
	}
	return cbg;
}


/**
 * 可编辑表格ICD下拉框
 * @param {verId} ICD版本ID
 * @return {cmp}下拉组件
 */
function ComboICD(verId){
	var cbg = {
		url: $URL,
		idField:'Desc',
		textField: 'ICD10',
		method: 'get',
		mode:'remote',
		fitColumns:true,
		panelWidth:600,
		panelHeight:ServerObj.IsMergeDiagOperPage==1?200:350,
		editable: true,
		sortName:'Count',
		sortOrder:'asc',
		pageSize: 50,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		enterNullValueClear:false,
		selectOnNavigation:false,
	    delay:'500',
		columns:[[
			{field:'ICD10',title:'手术编码',width:100},
			{field:'Desc',title:'名称',width:200},
		    {field:'OperTypeDesc',title:'手术类型'},
		    {field:'OperLevelDesc',title:'手术级别'},
			{field:'Count',title:'序号',hidden:'true'}
		]],
		queryParams:{
			ClassName:'CT.IPMR.FPS.ICDDxSrv',
			QueryName:'QryICDDx',
			aVerID:verId,
			aTypeID:'',
			aAlias:'' ,
			aIsActive:1,
			aICDDxID:'',
			rows:10000
		},
		onSelect:function(rowIndex, rowData){
			$('.datagrid-row-editing td[field="ICD10"] div').html(rowData.ICD10+rowData.InPairCode);
			// 处理手术类型
			editorType.combogrid('setValue', '');
			var queryParams=editorType.combogrid('options').queryParams;
			$cm({
				ClassName:queryParams.ClassName,
				QueryName:queryParams.QueryName,
				aDicType:queryParams.aDicType,
				aIsActive:queryParams.aIsActive,
				aHospID:queryParams.aHospID,
				aAlias:'',
				rows:100 
			},function(rs){
				editorType.combogrid('grid').datagrid('loadData',rs);
				for (i=0;i<rs.total ;i++ )
				{
					var record = rs.rows[i];
					var ID = record.ID;
					if (ID==rowData.OperTypeID) {
						editorType.combogrid('grid').datagrid('selectRow',i);
						editorType.combogrid('setText',record.Desc);
					}
				}
			});
			// 处理手术级别
			editorOperationRank.combogrid('setValue', '');
			var queryParams=editorOperationRank.combogrid('options').queryParams;
			$cm({
				ClassName:queryParams.ClassName,
				QueryName:queryParams.QueryName,
				aDicType:queryParams.aDicType,
				aIsActive:queryParams.aIsActive,
				aHospID:queryParams.aHospID,
				aAlias:'',
				rows:100 
			},function(rs){
				editorOperationRank.combogrid('grid').datagrid('loadData',rs);
				for (i=0;i<rs.total ;i++ )
				{
					var record = rs.rows[i];
					var ID = record.ID;
					if (ID==rowData.OperLevelID) {
						editorOperationRank.combogrid('grid').datagrid('selectRow',i);
						editorOperationRank.combogrid('setText',record.Desc);
					}
				}
			});
		},
		onChange:function(newValue, oldValue){
			if (globalObj.m_cbgChangeValueType) return;
			var record = $(this).combogrid("grid").datagrid("getSelected");
			var TypeID = '',TypeDesc='',OperLevelID='',OperLevelDesc='';
			if (record!==null) {
				$('.datagrid-row-editing td[field="ICD10"] div').html(record.ICD10+record.InPairCode);	// 改变手术表格编码列
			}
		},
		keyHandler: {
			up: function(e) {
				navcbg(this,'prev');
				e.preventDefault();
			},
			down: function(e) {
				navcbg(this,'next');
				e.preventDefault();
			},
			enter: function(e) {
				var record = $(this).combogrid("grid").datagrid("getSelected");
				if (record==null) {
					entercbg(this);
					/*setTimeout(function(){
						editorICD.combogrid("grid").datagrid("selectRow",0);
						editorICD.combogrid("grid").datagrid("highlightRow",0);
					},200);*/
				}else{
					$(this).combogrid("hidePanel");
					enterToNext(this);
				}
			},
			query: function(q,e) {
				if (q=="") {
					$(this).combogrid("clear");
					$(this).combogrid("hidePanel");
					return;
				}else{
					/*
					if (q.length==1) {
						$(this).combogrid("grid").datagrid("loadData",{"total": 0, "rows": []});
						$(this).combogrid("setValue", q);
						return;
					}*/
				}
				// 当前编辑行手术类型ID
				var objType = editorType.combogrid('grid').datagrid('getSelected');
				var TypeID='';
				if (objType!==null){
					TypeID = objType.ID;
				}
				//Qrycbglink(this,q,TypeID);
				Qrycbglink(this,q,'');
				var target = this;
				setTimeout(function(){
					navcbg(target,'next');
				},200);
			}
		}
	}
	return cbg;
}
/**
 * 可编辑表格用户下拉框定义
 * @param {TypeCode} 用户类型
 * @param {idRow}    id列代码
 * @param {descRow}  描述列代码
 * @return {cmp}下拉组件
 */
function ComboUser(TypeCode,idRow,descRow){
	var cbg = {
		url: $URL,
		idField:'Desc',
		textField: 'Desc',
		method:'Post',
		mode:'remote',
		fitColumns:true,
		panelWidth:550,
		panelHeight:ServerObj.IsMergeDiagOperPage==1?200:350,
		editable: true,
		defaultFilter:4, 
		enterNullValueClear:false,
		selectOnNavigation:false,
		delay:200,
		columns:[[
		    {field:'Code',title:'工号',width:120},
		    {field:'Desc',title:'姓名',width:120},
		    {field:'CPTDesc',title:'医护人员类型',width:120}
		]],
		queryParams:{
			ClassName:'MA.IPMR.BTS.SSUserSrv',
			QueryName:'QueryUser',
			aAlias:'',
			aTypeCode:TypeCode,
			aUserID:'' ,
			aIsActive:1,
			rows:50
		},
		keyHandler: {
			up: function(e) {
				navcbg(this,'prev');
				e.preventDefault();
			},
			down: function(e) {
				navcbg(this,'next');
				e.preventDefault();
			},
			enter: function(e) {
				var record = $(this).combogrid("grid").datagrid("getSelected");
				if (record==null) {
					entercbg(this);
				}else{
					$(this).combogrid("hidePanel");
					enterToNext(this);
				}
			},
			query: function(q,e) {
				if (q=="") {
					$(this).combogrid("clear");
					$(this).combogrid("hidePanel");
					return;
				}
				qrycbg(this,q);
				var target = this;
				setTimeout(function(){
					navcbg(target,'next');
				},200);
			}
		}
	}
	return cbg;
}

/**
 * 科室下拉框
 * @param {LocType}科室类型 
 * @param {AdmType}就诊类型
 * @param {HospId}医院ID
 * @return {cmp}下拉组件
 */
function ComboLoc(LocType,AdmType,HospId){

	var cbox = {
		url: $URL,
		panelWidth:500,
		panelHeight:400,
		idField: 'Desc',
		textField: 'Desc',
		method:'Post',
		mode:'remote',
		fitColumns:true,
		panelWidth:550,
		panelHeight:ServerObj.IsMergeDiagOperPage==1?200:350,
		editable: true,
		defaultFilter:4, 
		enterNullValueClear:false,
		selectOnNavigation:false,
		columns:[[
			{field:'Code',title:'代码',width:120},
			{field:'Desc',title:'描述',width:120}
		]],
		queryParams:{
			ClassName:'MA.IPMR.BTS.LocationSrv',
			QueryName:'QryLoc',
			aHospId:HospId,
			aLocType:LocType,
			aAdmType:AdmType ,
			aLocGroup:'',
			aKeyword:'',
			aLocID:'',
			aID:'',
			rows:50
		},
		keyHandler: {
			enter: function (e) {
				var record = $(this).combogrid("grid").datagrid("getSelected");
				if (record==null) {
					entercbg(this);
				}else{
					$(this).combogrid("hidePanel");
					enterToNext(this);
				}
			},
			up: function (e) {
				navcbg(this,'prev');
				e.preventDefault();
			},
			down: function (e) {
				navcbg(this,'next');
				e.preventDefault();
			},
			query: function (q) {
				if (q=="") {
					$(this).combogrid("clear");
					$(this).combogrid("hidePanel");
					return;
				}
				var state = $.data(this,"combogrid");
				var opts = state.options;
				var grid = state.grid;
				state.remainText = true;
				if(opts.multiple&&!q){
					_1ag(this,[],true);
				}
				else{
					_1ag(this,[q],true);
				}
				grid.datagrid("clearSelections");
				grid.datagrid("load",$.extend({},opts.queryParams,{aKeyword:q}));
				var target = this;
				setTimeout(function(){
					navcbg(target,'next');
				},200);
			}
		}
	}
	return  cbox;
}

/**
 * 临床手术下拉框
 * @param {void} 
 * @return {cmp}下拉组件
 */
function ComboAppointMent(){
	var cbox = {
		url: $URL,
		panelWidth:800,
		panelHeight:300,
		editable: true,
		idField: 'RowId',
		textField: 'RowId',
		fitColumns:true,
		enterNullValueClear:false,
		selectOnNavigation:false,
		columns:[[
			{field:'RowId',title:'手术ID',width:100},
			{field:'OperationDesc',title:'手术名称',width:180},
			{field:'OperClassDesc',title:'手术级别',width:80},
			{field:'BladeTypeDesc',title:'切口类型',width:100},
			{field:'BodySiteDesc',title:'手术部位',width:120},
			{field:'SurgeonDesc',title:'手术医生',width:120},
			{field:'SurgeonDeptDesc',title:'手术科室',width:120}
		]],
		queryParams:{
		  	ClassName:'MA.IPMR.IOSrv.Receiver.AisOper',
			QueryName:'QryOper',
			aEpisodeID:ServerObj.EpisodeID,
			rows:50
		},
		keyHandler: {
			up: function(e) {
				navcbg(this,'prev');
				e.preventDefault();
			},
			down: function(e) {
				navcbg(this,'next');
				e.preventDefault();
			},
			enter: function(e) {
				var record = $(this).combogrid("grid").datagrid("getSelected");
				if (record==null) {
					entercbg(this);
				}else{
					$(this).combogrid("hidePanel");
					enterToNext(this);
				}
			},
			query: function (q) {
			}
		}
	}
	return  cbox;
}

/**
 * 日期框
 * @param {filed} 编辑表格列代码
 * @return {cmp}下拉组件
 */
function datebox(filed){
	var cbox = {
		keyHandler: {
			up: function(e) {
				var panel = $.data(this,"combo").panel;
				if (!panel.is(':visible')) return;
				var value = $(this).datebox('getValue');
				var now = new Date(value);
				now.setDate(now.getDate() - 7);
				var nowstr = now.getFullYear()+'-'+(now.getMonth()+1)+'-'+now.getDate()
				$(this).datebox('setValue', nowstr);
				e.preventDefault();
			},
			down: function(e) {
				var panel = $.data(this,"combo").panel;
				if (!panel.is(':visible')) return;
				var value = $(this).datebox('getValue');
				var now = new Date(value);
				now.setDate(now.getDate() + 7);
				var nowstr = now.getFullYear()+'-'+(now.getMonth()+1)+'-'+now.getDate()
				$(this).datebox('setValue', nowstr);
				e.preventDefault();
			},
			left: function(e) {
				var panel = $.data(this,"combo").panel;
				if (!panel.is(':visible')) return;
				var value = $(this).datebox('getValue');
				var now = new Date(value);
				now.setDate(now.getDate() - 1);
				var nowstr = now.getFullYear()+'-'+(now.getMonth()+1)+'-'+now.getDate()
				$(this).datebox('setValue', nowstr);
				e.preventDefault();
			},
			right: function(e) {
				var panel = $.data(this,"combo").panel;
				if (!panel.is(':visible')) return;
				var value = $(this).datebox('getValue');
				var now = new Date(value);
				now.setDate(now.getDate() + 1);
				var nowstr = now.getFullYear()+'-'+(now.getMonth()+1)+'-'+now.getDate()
				$(this).datebox('setValue', nowstr);
				e.preventDefault();
			},
			enter: function(e) {
				var value = $(this).datebox('getValue');
				if (value!=='') {
					$(this).datebox('hidePanel');
					enterToNext(this)
				}else{
					$(this).datebox('showPanel');
				}
			},
			query: function (q) {
			}
		}
	}
	return  cbox;
}


/**
 * 表格内回车到下一个表单
 * @param {target} 	当前表单
 * @return
 */
function enterToNext(target) {
	var inputEles = $("td[field!=''] td > input[type='text'][disabled!='disabled'],td[field!=''] .spinner > input[type='text'][disabled!='disabled']");
	for(var i=0;i<inputEles.length;i++){
		if ($(inputEles[i]).is($(target))) { //判断两个jQuery对象是否相等
			//校验数据，回车到下一个录入框
			if(i == inputEles.length-1){	//	最后一个表单
				SaveOper(0);
			}else{
				// 判断下一个表单类型
				if ($(inputEles[i+1]).hasClass('combogrid-f')) {
					$(inputEles[i+1]).next().children(":first").focus();
				}else if ($(inputEles[i+1]).hasClass('datebox-f')||$(inputEles[i+1]).hasClass('datetimebox-f')) {
					$(inputEles[i+1]).next().children(":first").focus();
				}else{
					$(inputEles[i+1]).focus();
				}
			}
		} 
	}
}

/**
 * 获取页签中手术列表的数量
 * @param {void}
 * @return {opercount} 手术条数
 */
 function getOperCount() {
	return $('#gridOper').datagrid('getData').total;
}

function addOperFromEmr(row) {
	var Index = $('#gridOper').datagrid('getData').total;
	row.Index=Index+1;
	$('#gridOper').datagrid('appendRow',row);
}