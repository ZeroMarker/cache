/**
 * 编目诊断信息
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
	m_DiagSelectindex:'',	// 选择一条诊断数据的索引
	m_attDiag:{},			// 附属诊断
	m_DiagIndex:'',			// 当前编辑的附属诊断所属诊断序号
	m_attDiagOpen:'',		// 诊断附属界面是否打开
	m_DiagDrag:'',			// 诊断是否通过拖动调整顺序
	m_isSave:true,
	m_cbgChangeValueType:0 	// 区分启用编辑某行和正常选择下拉表格数据变化
}

// 页面入口
$(function(){
	$HUI.combogrid("#cboAttICD", {
		url: $URL,
		panelWidth:550,
		panelHeight:350,
		idField: 'ID',
		textField: 'Desc',
		mode:'remote',
		enterNullValueClear:false,
		fitColumns:true,
		delay:500,
		sortName:'Count',
		sortOrder:'asc',
		columns:[[
			{field:'ICD10',title:'ICD编码',width:70,
				formatter:function(value,row,index){
					var ICD10 = row["ICD10"];
					var InPairCode = row["InPairCode"];
					var ICD = ICD10+InPairCode;
					return ICD;	
				}
			},
			{field:'Desc',title:'名称',width:200},
			{field:'Count',title:'序号',hidden:'true'}
		]],
		queryParams:{
		    ClassName:'CT.IPMR.FPS.ICDDxSrv',
			QueryName:'QryICDDx',
			aVerID:ServerObj.ConfigICDVerID,
			aTypeID:ServerObj.AttDiagTypeID,
			aAlias:'' ,
			aIsActive:1,
			aICDDxID:'',
			rows:50
		},
		onLoadSuccess:function(data){
			if ($(this).combogrid('grid').datagrid('getRows').length == 0) {
				return;
			}else {
				$(this).combogrid('grid').datagrid('selectRow',0);
			}
		},
		keyHandler: {
			enter: function (e) {
				var record = $(this).combogrid("grid").datagrid("getSelected");
				if (record==null) {
					entercbg(this);
				}else{
					$(this).combogrid("hidePanel");
					Common_Focus('cboAttAdmitCond');
				}
			},
			up: function(e) {
				navcbg(this,'prev');
				e.preventDefault();
			},
			down: function(e) {
				navcbg(this,'next');
				e.preventDefault();
			},
			query: function (q) {
				Qrycbglink(this,q,ServerObj.AttDiagTypeID);
			}
		}
	});
	$HUI.combogrid("#cboAttAdmitCond", {
		url: $URL,
		panelWidth:300,
		panelHeight:250,
		idField:'ID',
		textField: 'Desc',
		mode:'remote',
		enterNullValueClear:false,
		fitColumns:true,
		delay:200,
		columns:[[
		    {field:'Code',title:'代码',width:50},
		    {field:'Desc',title:'名称',width:200}
		   ]],
		queryParams:{
		    ClassName:'CT.IPMR.BTS.DictionarySrv',
			QueryName:'QryDictionary',
			aDicType:'DiseaseResult',
			aIsActive:1,
			aHospID:'',
			aAlias:'',
			rows:1000
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
			enter: function () {
				var record = $(this).combogrid("grid").datagrid("getSelected");
				if (record==null) {
				}else{
					$(this).combogrid("hidePanel");
					addAttDiag();
				}
			},
			query: function (q) {
				qrycbg(this,q);
			}
		}
	});
	var editors,editorType,editorICD,editorInjuryICD,editorTumICD,editorTumDiffer,editorTumStages,editorAdmitCond,editorDischCond;
	// 初始化诊断
	InitgridDiag();

	// 初始化附属诊断
	InitAttDiag();
	
	// 保存按钮
	$('#DiagSave').click(function(){
		SaveDiag(1);
	});

	// 删除按钮
	$('#DiagCancel').click(function(){
		CancelDiag();
	});

	// 诊断上移
	$('#DiagUp').click(function(e){
		moveDiag('up');
	});

	// 诊断下移
	$('#DiagDown').click(function(){
		moveDiag('down');
	});

	// 删除-附属诊断
	$('#delAttDiag').bind('click', function() {
		delAttDiag();
	});

	// 插入诊断
	$('#DiagInsert').bind('click', function() {
		CopyDiag("Insert");
	});
	
	// 复制诊断
	$('#DiagCopy').bind('click', function() {
		CopyDiag("Copy");
	});

	// 显示首页诊断
	$('#showemrdiag').bind('click', function() {
		if (ServerObj.IsMergeDiagOperPage==1){
			var strUrl = "./ma.ipmr.fp.frontpage.emrdiagnos.csp?&VolumeID="+ServerObj.VoumeID+"&DefaultFPConfig="+ServerObj.DefaultFPConfig+"&2=2"
			websys_showModal({
				url:strUrl,
				title:'首页诊断',
				iconCls:'icon-w-epr',  
				originWindow:window,
				width: 800,
       			height: 500
			});
		}else{
		$cm({
	    	ClassName:"MA.IPMR.FPS.CodeDiagSrv",
			QueryName:"QryDiag",
			aVolumeID:ServerObj.VoumeID,
			aFPConfig:ServerObj.DefaultFPConfig,
			aEmrFlag:1,
	    	page:1,
	    	rows:10000
	    },function(rs){
	    	var json = rs;
	    	showEmrDiag(json.rows);
	    });
		}
	});

	// ICD检索
	$('#showicdSearchWin').bind('click', function() {
		var selectobj = $('#gridDiag').datagrid('getSelected');
		var diagselectTypeID='';
		var diagselectTypeCode='';
		var diagselected=0
		if  (selectobj!=null) {
			diagselected=1;
			diagselectTypeID = selectobj.TypeID;
			diagselectTypeCode = selectobj.TypeCode;
		}
		if ((diagselectTypeCode==10)||(diagselectTypeCode==11)||(diagselectTypeCode==12)||(diagselectTypeCode==13)||(diagselectTypeCode==14)) {	// 中医诊断
			var ICDVer 	= ServerObj.ConfigICDVer2ID
		}else{
			var ICDVer 	= ServerObj.ConfigICDVerID
		}

		if (ServerObj.IsMergeDiagOperPage==1){
			var title=$g('诊断检索')
			var strUrl = "./ma.ipmr.fp.frontpage.icdsearch.csp?&icdType=D"+"&selectTypeID="+diagselectTypeID+"&icdVerID="+ICDVer+"&2=2"
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
			var selectobj = $('#gridDiag').datagrid('getSelected');
			var diagselectTypeID='';
			var diagselectTypeCode='';
			if  (selectobj!=null) {
				diagselectTypeID = selectobj.TypeID;
				diagselectTypeCode = selectobj.TypeCode;
			}
			if ((diagselectTypeCode==10)||(diagselectTypeCode==11)||(diagselectTypeCode==12)||(diagselectTypeCode==13)||(diagselectTypeCode==14)) {	// 中医诊断
				var ICDVer 	= ServerObj.ConfigICDVer2ID
			}else{
				var ICDVer 	= ServerObj.ConfigICDVerID
			}
			serchICDDx(value,diagselectTypeID,ICDVer);
        }
    });
})

/**
 * ICD检索窗口
 */
function showicdSearchWin(diagselected){
	$('#searchICD').searchbox('setValue','');
	var columns = [[
		{field:'ICD10',title:'诊断编码',width:120,align:'left'},
		{field:'Desc',title:'诊断名称',width:160,align:'left'},
		{field:'replace',title:'替换诊断',width:50,align:'left',hidden:diagselected==1?false:true,
			formatter:function(value,rowData,rowIndex){
				return "<a style='white-space:normal;color:#229A06' onclick='replaceFromSearch(\"" + rowData.ID + "\""+",\"" +rowData.ICD10 + "\""+",\"" +rowData.Desc + "\");'>" + $g("替换") + "</a>"; 
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
		title: "诊断检索",
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
function replaceFromSearch(id,icd10,icddesc) {
	var selectobj = $('#gridDiag').datagrid('getSelected');
	selectobj.ICDID=id;
	selectobj.ICD10=icd10;
	selectobj.ICDDesc=icddesc;
	$('#gridDiag').datagrid('updateRow',{
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
function serchICDDx(aliasICD,diagselectTypeID,ICDVer) {
	if (aliasICD == "") {
		$.messager.popover({msg: '请输入别名...',type:'alert'});
		return false;
	}
	$("#gridICD").datagrid("reload", {
		ClassName : "CT.IPMR.FPS.ICDDxSrv",
		QueryName : "QryICDDx",
		aVerID :ICDVer,
		aTypeID:diagselectTypeID,
		aAlias : aliasICD,
		aIsActive:1,
		aICDDxID:''
	});
	return ;
}
/**
 * 首页诊断列表
 */
function showEmrDiag(array){
	var columns = [[
		{field:'Index',title:'序号',width:50,align:'left'},
		{field:'TypeDesc',title:'诊断类型',width:120,align:'left'},
		{field:'ICD10',title:'疾病编码',width:160,align:'left'},		
		{field:'ICDDesc',title:'疾病名称',width:250,align:'left'},	
		{field:'InjuryICDDesc',title:'损伤中毒外部原因',width:250,align:'left',hidden:ServerObj.CodeShowInjuryICD=='1'?false:true,},
		{field:'TumICDDesc',title:'肿瘤形态学',width:250,align:'left',hidden:ServerObj.CodeShowTumICD=='1'?false:true,},
		{field:'TumDifferDesc',title:'分化程度',width:100,align:'left',hidden:ServerObj.CodeShowTumDiffer=='1'?false:true,},
		{field:'TumStagesDesc',title:'肿瘤分期',width:100,align:'left',hidden:ServerObj.CodeShowTumStages=='1'?false:true,},
		{field:'AdmitCondDesc',title:'入院病情',width:100,align:'left',},
		{field:'DischCondDesc',title:'出院情况',width:100,align:'left',hidden:ServerObj.CodeShowDischCond=='1'?false:true,}
    ]];
    var gridEmrDiag = $('#gridEmrDiag').datagrid({
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
	    data: array,
	    onDblClickRow: function(index,row) {
	    	var Index = $('#gridDiag').datagrid('getData').total;
	    	row.Index=Index+1;
	    	$('#gridDiag').datagrid('appendRow',row);
	    }
	});
	$('#emrDiagWin').dialog({
		title: "首页诊断",
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
 * 初始化诊断列表
 */
function InitgridDiag(){
	var columns = [[
		{field:'Index',title:'序号',width:50,align:'left'},
		{field:'TypeDesc',title:'诊断类型',width:120,align:'left',
			editor:{
				type: 'combogrid',
				options: ComboDic(ServerObj.FPTypeDesc=='中医首页'?'CMDiagType':'DiagType','',1)
			}
		},
		{field:'ClinicICD10',title:'临床编码',width:250,align:'left',hidden:ServerObj.CodeShowClinicICD=='1'?false:true},
		{field:'ClinicICDDesc',title:'临床诊断',width:250,align:'left',hidden:ServerObj.CodeShowClinicICD=='1'?false:true},
		{field:'ICD10',title:'疾病编码',width:160,align:'left',
			formatter:function(value,row,index)
			{
				var ICDDesc = row["ICDDesc"];
				var ICDinPair = row["ICDinPair"];
				var ICD = value+ICDinPair;
				if ((value)&&(ICDDesc=="")){return "<span style='color: #BB0000'>" + value + "</span>";	}
				return ICD;	
			}
		},		
		{field:'ICDDesc',title:'疾病名称',width:250,align:'left',
			formatter:function(value,row,index)
			{
				var ICD10 	= row["ICD10"];
				var ICDDesc = row["ICDDesc"];
				var TypeCode = row["TypeCode"];	
				if ((TypeCode==10)||(TypeCode==11)||(TypeCode==12)||(TypeCode==13)||(TypeCode==14)) {	// 中医诊断
					var ICDVer 	= ServerObj.ConfigICDVer2ID
				}else{
					var ICDVer 	= ServerObj.ConfigICDVerID
				}
				var ret = $cm({
					ClassName:"CT.IPMR.FPS.ICDDxSrv",
					MethodName:"CheckICD",
					aICDVer:ICDVer,
					aICD10:ICD10,
					aICDDesc:ICDDesc
				},false)
				if (ret!='1'){
					return "<span style='color: #BB0000'>" + ICDDesc + "</span>";	
				}
				return ICDDesc;	
			},
			editor:{
				type: 'combogrid',
				options: ComboICD(ServerObj.ConfigICDVerID,'ICD')
			}	
		},		
		{field:'AttDiag',title:'附属诊断',width:80,align:'left',
			formatter:function(value,row,index){
				var DiagID = row["DiagID"];
				var Index = row["Index"];
				var TypeID		= row["AdmitCondID"];
				var TypeDesc	= row["AdmitCondDesc"];
				if (value==''){
					var btn='<a href="javascript:void(0)" onclick="EditAttDiag(\'' + DiagID + '\''+','+'\'' + Index +  '\''+','+'\''+TypeID+  '\''+','+'\''+TypeDesc+'\')">'+$g('附属诊断')+'</a>';				
				}else{
					var btn='<a href="javascript:void(0)" onclick="EditAttDiag(\'' + DiagID + '\''+','+'\'' + Index +  '\''+','+'\''+TypeID+  '\''+','+'\''+TypeDesc+'\')">'+value+'</a>';					
				}
				return btn;
			}
		},
		{field:'InjuryICDDesc',title:'损伤中毒外部原因',width:250,align:'left',hidden:ServerObj.CodeShowInjuryICD=='1'?false:true,
			editor:{
				type: 'combogrid',
				options: ComboICD(ServerObj.ConfigICDVerID,'InjuryICD')
			}
		},
		{field:'TumICDDesc',title:'肿瘤形态学',width:250,align:'left',hidden:ServerObj.CodeShowTumICD=='1'?false:true,
			editor:{
				type: 'combogrid',
				options: ComboICD(ServerObj.ConfigICDVerID,'TumICD')
			}	
		},
		{field:'TumDifferDesc',title:'分化程度',width:100,align:'left',hidden:ServerObj.CodeShowTumDiffer=='1'?false:true,
			editor:{
				type: 'combogrid',
				options: ComboDic('TumDiffer','',1)
			}	
		},
		{field:'TumStagesDesc',title:'肿瘤分期',width:100,align:'left',hidden:ServerObj.CodeShowTumStages=='1'?false:true,
			editor:{
				type: 'combogrid',
				options: ComboDic('TumStages','',1)
			}	
		},
		{field:'AdmitCondDesc',title:'入院病情',width:100,align:'left',
			editor:{
				type: 'combogrid',
				options: ComboDic('DiseaseResult','',1)
			}
		},
		{field:'DischCondDesc',title:'出院情况',width:100,align:'left',hidden:ServerObj.CodeShowDischCond=='1'?false:true,
			editor:{
				type: 'combogrid',
				options: ComboDic('Prognosis','',1)
			}
		}
    ]];
    var gridDiag = $('#gridDiag').datagrid({
		fit: true,
		headerCls:'panel-header-gray',
		iconCls:'icon-write-order',
		pagination: false,
		singleSelect: true,
		autoRowHeight: false,
		fitColumns:true,
	    url:$URL,
	    queryParams:{
		    ClassName:"MA.IPMR.FPS.CodeDiagSrv",
			QueryName:"QryDiag",
			aVolumeID:ServerObj.VoumeID,
			aFPConfig:ServerObj.DefaultFPConfig
	    },
	    columns :columns,
	    rowStyler:setRowBgColor,
		onLoadSuccess:function(data){
			if (ServerObj.IsAttDiagCode=='1'){
				$('#gridDiag').datagrid("showColumn", "AttDiag");
			}else{
				$('#gridDiag').datagrid("hideColumn", "AttDiag");
			}
			buildAttDiagJson('gridDiag');
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
			SaveDiag(1);
		},
		onBeginEdit: function(index,row) {
			editors = $(this).datagrid('getEditors',index);
			for (var i=0;i<editors.length;i++) {
				if (editors[i].field=='TypeDesc') editorType = editors[i].target;
				if (editors[i].field=='ICDDesc') editorICD = editors[i].target;
				if (editors[i].field=='InjuryICDDesc') editorInjuryICD = editors[i].target;
				if (editors[i].field=='TumICDDesc') editorTumICD = editors[i].target;
				if (editors[i].field=='TumDifferDesc') editorTumDiffer = editors[i].target;
				if (editors[i].field=='TumStagesDesc') editorTumStages = editors[i].target;
				if (editors[i].field=='AdmitCondDesc') editorAdmitCond = editors[i].target;
				if (editors[i].field=='DischCondDesc') editorDischCond = editors[i].target;
			}
			var queryParams=editorICD.combogrid('options').queryParams;
			setTimeout(function () { 
				editorICD.combogrid('grid').datagrid("load",$.extend({},queryParams,{aICDDxID:row.ICDID},{aVerID:row.ICDVerID}));
				editorTumICD.combogrid('grid').datagrid("load",$.extend({},queryParams,{aICDDxID:row.TumICDID}));
				editorInjuryICD.combogrid('grid').datagrid("load",$.extend({},queryParams,{aICDDxID:row.InjuryICDID}));
			}, 30);
			editorType.combogrid("textbox").focus();
			if (row.TypeDesc=='门急诊诊断' || row.TypeDesc=='入院诊断' || row.TypeDesc=='损伤中毒诊断' || row.TypeDesc=='病理诊断' || row.TypeDesc=='医院感染诊断'){
				setDisable('disable');
			}else{
				setDisable('enable');
				var ICD10 = row.ICD10;
				setTumInjurySataus(ICD10);
			}
			globalObj.m_cbgChangeValueType = 0;
		},
		onStopDrag:function(row){
			if (globalObj.m_DiagDrag!='1') return;
			var Data=$('#gridDiag').datagrid('getData');
			for(var ind=0;ind<Data.total;ind++)
			{
				var tmpdata = Data.rows[ind];
				tmpdata.Index=ind+1;
				$('#gridDiag').datagrid('updateRow',{
					index: ind,	
					row: tmpdata
				});	
			}
			globalObj.m_DiagDrag=0;
		}
		,onDrop:function(targetRow, sourceRow,point){
			// 诊断移动，附属诊断结构相应变化
			if (!sourceRow) return false;
			var sourceAttDiag = $.hisui.getArrayItem(globalObj.m_attDiag.Data,'number',sourceRow.Index);
			
			var tempNum = sourceAttDiag.number;
			if (point=='top') {
				var targetNum = parseInt(targetRow.Index) ;
			}else if (point=='bottom') {
				var targetNum = parseInt(targetRow.Index) + 1;
			}else{ // 超出表格末行
				var targetNum = globalObj.m_attDiag.total + 1;
			}
			
			// 无实际的位置顺序变动
			if (tempNum==targetNum) return false;  
			
			// 朝上拖动行
			if (tempNum>targetNum)			
			{
				for (var i = 0; i < globalObj.m_attDiag.total; i++ )
				{
					if ((globalObj.m_attDiag.Data[i].number>=targetNum)&&(globalObj.m_attDiag.Data[i].number<tempNum))
					{
						globalObj.m_attDiag.Data[i].number=globalObj.m_attDiag.Data[i].number + 1;
					}	
				}	
				sourceAttDiag.number=targetNum;
			}
			// 朝下拖动行
			else if(tempNum<targetNum){	
				for (var i = 0; i < globalObj.m_attDiag.total; i++ )
				{	
					if ((globalObj.m_attDiag.Data[i].number<targetNum)&&(globalObj.m_attDiag.Data[i].number>tempNum))
					{
						globalObj.m_attDiag.Data[i].number=globalObj.m_attDiag.Data[i].number - 1;
					}
				}	
				sourceAttDiag.number=targetNum-1;	
			}
			globalObj.m_attDiag.Data.sort(function (a, b) {
				if (a.number < b.number) {
					return -1;
				} else if (a.number == b.number) {
					return 0;
				} else {
					return 1;
				}
			});	
			globalObj.m_DiagDrag = 1;	
		}
	});
	return gridDiag;
}

// 根据ICD编码设置编辑表格肿瘤形态学和损伤中毒外部原因的启用状态
function setTumInjurySataus(ICD10) {
	var ICD10Head = ICD10.substring(0,1);
	if (ServerObj.CodeShowTumICD==1) {
		if ((ICD10>'C0')&&(ICD10<'D49')) {  // 肿瘤形态学
			editorTumICD.combogrid('enable');
			editorTumDiffer.combogrid('enable');
			editorTumStages.combogrid('enable');
		}else{
			editorTumICD.combogrid('setValue', '');
			editorTumICD.combogrid('disable');
			editorTumDiffer.combogrid('setValue', '');
			editorTumDiffer.combogrid('disable');
			editorTumStages.combogrid('setValue', '');
			editorTumStages.combogrid('disable');
		}
	}else{
		editorTumICD.combogrid('setValue', '');
		editorTumICD.combogrid('disable');
		editorTumDiffer.combogrid('setValue', '');
		editorTumDiffer.combogrid('disable');
		editorTumStages.combogrid('setValue', '');
		editorTumStages.combogrid('disable');
	}
	if (ServerObj.CodeShowInjuryICD==1) {
		if ((ICD10Head=='S')||(ICD10Head=='T')) {  // 损伤中毒外部原因
			editorInjuryICD.combogrid('enable');
		}else{
			editorInjuryICD.combogrid('setValue', '');
			editorInjuryICD.combogrid('disable');
		}
	}else{
		editorInjuryICD.combogrid('setValue', '');
		editorInjuryICD.combogrid('disable');
	}
}

// 设置编辑表格数据项的启用状态
function setDisable(status) {
	if (typeof(editors)=='undefined') return;
	for (var i=0;i<editors.length;i++) {
		if (editors[i].field=='InjuryICDDesc') {
			if (ServerObj.CodeShowInjuryICD==1) {
				if (status=='disable') {
					editors[i].target.combogrid('setValue', '');
					editors[i].target.combogrid('disable');
				}else{
					editors[i].target.combogrid('enable');
				}
			}else{
				editors[i].target.combogrid('setValue', '');
				editors[i].target.combogrid('disable');
			}
		}
		if (editors[i].field=='TumICDDesc') {
			if (ServerObj.CodeShowTumICD==1) {
				if (status=='disable') {
					editors[i].target.combogrid('setValue', '');
					editors[i].target.combogrid('disable');
				}else{
					editors[i].target.combogrid('enable');
				}
			}else{
				editors[i].target.combogrid('setValue', '');
				editors[i].target.combogrid('disable');
			}
		}
		if (editors[i].field=='TumDifferDesc') {
			if (ServerObj.CodeShowTumDiffer==1) {
				if (status=='disable') {
					editors[i].target.combogrid('setValue', '');
					editors[i].target.combogrid('disable');
				}else{
					editors[i].target.combogrid('enable');
				}
			}else{
				editors[i].target.combogrid('setValue', '');
				editors[i].target.combogrid('disable');
			}
		}
		if (editors[i].field=='TumStagesDesc') {
			if (ServerObj.CodeShowTumStages==1) {
				if (status=='disable') {
					editors[i].target.combogrid('setValue', '');
					editors[i].target.combogrid('disable');
				}else{
					editors[i].target.combogrid('enable');
				}
			}else{
				editors[i].target.combogrid('setValue', '');
				editors[i].target.combogrid('disable');
			}
		}
		if (editors[i].field=='DischCondDesc') {
			if (ServerObj.CodeShowDischCond==1) {
				if (status=='disable') {
					editors[i].target.combogrid('setValue', '');
					editors[i].target.combogrid('disable');
				}else{
					editors[i].target.combogrid('enable');
				}
			}else{
				editors[i].target.combogrid('setValue', '');
				editors[i].target.combogrid('disable');
			}
		}
		if (editors[i].field=='AdmitCondDesc') {
			if (status=='disable') {
				editors[i].target.combogrid('setValue', '');
				editors[i].target.combogrid('disable');
			}else{
				editors[i].target.combogrid('enable');
			}
		}
	}
}

// 诊断表格行格式
function setRowBgColor(rowIndex, rowData) {
	if (rowData.EditFinish == '1'){
			return '' //'background-color:#E1FFFF;';
	}else{
		return '' //'background-color:#FFFFF0;';
	}
}

// 启用拖放
function enableDnd() {
	var eIndex = $('#gridDiag').datagrid('getEditingRowIndexs')[0];
	if (typeof(eIndex)=='undefined') {
		$('#gridDiag').datagrid('enableDnd');
	}else{
		$('#gridDiag').datagrid('disableDnd');
	}
}
 /**
 * 提交编目时校验
 * @param {void}
 * @return {bollen}成功 true 失败 false
 */
function check() {
	var eIndex = $('#gridDiag').datagrid('getEditingRowIndexs')[0];
	if (typeof(eIndex)=='undefined') {
		return true;
	}
	var ret = SaveDiag(1);
	return ret;
}

 /**
 * 保存诊断
 * @param {flag} 	1：保存按钮 0：单行回车后保存
 */
function SaveDiag(flag){
	if (globalObj.m_isSave) {
		globalObj.m_isSave = false;
		setTimeout(function(){
			globalObj.m_isSave = true;
		},200);
	}else{
		return false;
	}
	var eIndex = $('#gridDiag').datagrid('getEditingRowIndexs')[0];
	if (typeof(eIndex)=='undefined') {
		$.messager.popover({msg: '无正在编辑的数据...',type:'alert'});
		return false;
	}
	var select = $('#gridDiag').datagrid('getSelected');
	if (select) {	// 序号
		var RowNumber = select.Index;	
	}else{
		var RowNumber = $('#gridDiag').datagrid('getData').total+1;
	}
	RowNumber = parseInt(RowNumber)
	var eiditdata = $('#gridDiag').datagrid('getData').rows[eIndex];
	var ClinicICDDesc = eiditdata.ClinicICDDesc;
	var ClinicICD10 = eiditdata.ClinicICD10;	

	// 诊断类型
	var objType = editorType.combogrid('grid').datagrid('getSelected');
	var TypeID='',TypeDesc='',TypeCode='';
	if (objType!==null){
		TypeID = objType.ID;
		TypeDesc = objType.Desc;
		TypeCode = objType.Code;
	}else{
		TypeDesc = editorType.combogrid('getValue');
	}
	if ((TypeID=='')||(TypeDesc=='')){
		$.messager.popover({msg: '请录入诊断类型...',type:'alert'});
		editorType.next().children(':first').focus();
		return false;
	}
	if (TypeID==''&&TypeDesc!='') {
		$.messager.popover({msg: '诊断类型不标准...',type:'alert'});
		editorType.next().children(':first').focus();
		return false;
	}

	// 疾病编码
	var objICD = editorICD.combogrid('grid').datagrid('getSelected');
	var ICDID = '',ICD10 = '',ICDDesc = '',ICDVerID = '',InPairCode ='';
	if (objICD!==null){
		ICDID = objICD.ID;
		ICD10 = objICD.ICD10;
		ICDDesc = objICD.Desc;
		ICDinPair  = objICD.InPairCode;
		ICDVerID  = objICD.VerID;
	}else{
		ICDDesc = editorICD.combogrid('getValue');
	}
	if ((ICDID=='')||(ICD10=='')||(ICDDesc=='')){
		$.messager.popover({msg: '请录入疾病编码...',type:'alert'});
		editorICD.next().children(':first').focus();
		return false;
	}
	if (ICDID==''&&ICDDesc!='') {
		$.messager.popover({msg: '疾病编码不标准...',type:'alert'});
		editorICD.next().children(':first').focus();
		return false;
	}

	// 损伤中毒外部原因
	var InjuryICDID='',InjuryICD10='',InjuryICDDesc='';
	if (!editorInjuryICD.combogrid('options').disabled) {
		var record = editorInjuryICD.combogrid('grid').datagrid('getSelected');
		if (record!==null){
			InjuryICDID = record.ID;
			InjuryICD10 = record.ICD10;
			InjuryICDDesc = record.Desc;
		}else{
			InjuryICDDesc = editorInjuryICD.combogrid('getValue');
		}
		if ((InjuryICDID=='')||(InjuryICD10=='')||(InjuryICDDesc=='')){
			$.messager.popover({msg: '请录入损伤中毒外部原因...',type:'alert'});
			editorInjuryICD.next().children(':first').focus();
			return false;
		}
		if (InjuryICDID==''&&InjuryICDDesc!='') {
			$.messager.popover({msg: '损伤中毒外部原因不标准...',type:'alert'});
			editorInjuryICD.next().children(':first').focus();
			return false;
		}
	}

	// 肿瘤形态学
	var TumICDID='',TumICD10='',TumICDDesc='';
	if (!editorTumICD.combogrid('options').disabled) {
		var record = editorTumICD.combogrid('grid').datagrid('getSelected');
		if (record!==null){
			TumICDID = record.ID;
			TumICD10 = record.ICD10;
			TumICDDesc = record.Desc;
		}else{
			TumICDDesc = editorTumICD.combogrid('getValue');
		}
		if ((TumICDID=='')||(TumICD10=='')||(TumICDDesc=='')){
			$.messager.popover({msg: '请录入肿瘤形态学...',type:'alert'});
			editorTumICD.next().children(':first').focus();
			return false;
		}
		if (TumICDID==''&&TumICDDesc!='') {
			$.messager.popover({msg: '肿瘤形态学不标准...',type:'alert'});
			editorTumICD.next().children(':first').focus();
			return false;
		}
	}

	// 分化程度
	var TumDifferID='',TumDifferDesc='';
	if (!editorTumDiffer.combogrid('options').disabled) {
		var record = editorTumDiffer.combogrid('grid').datagrid('getSelected');
		if (record!==null){
			TumDifferID = record.ID;
			TumDifferDesc = record.Desc;
		}else{
			TumDifferDesc = editorTumDiffer.combogrid('getValue');
		}
		if (TumDifferID==''&&TumDifferDesc!='') {
			$.messager.popover({msg: '分化程度不标准...',type:'alert'});
			editorTumDiffer.next().children(':first').focus();
			return false;
		}
		if ((TypeCode=='3')||(TypeCode=='4')) {
			if ((TumDifferID=='')||(TumDifferDesc=='')){
				$.messager.popover({msg: '请录入分化程度...',type:'alert'});
				editorTumDiffer.next().children(':first').focus();
				return false;
			}
		}
	}
	
	// 肿瘤分期
	var TumStagesID='',TumStagesDesc='';
	if (!editorTumStages.combogrid('options').disabled) {
		var record = editorTumStages.combogrid('grid').datagrid('getSelected');
		if (record!==null){
			TumStagesID = record.ID;
			TumStagesDesc = record.Desc;
		}else{
			TumStagesDesc = editorTumStages.combogrid('getValue');
		}
		if (TumStagesID==''&&TumStagesDesc!='') {
			$.messager.popover({msg: '肿瘤分期不标准...',type:'alert'});
			editorTumStages.next().children(':first').focus();
			return false;
		}
		if ((TypeCode=='3')||(TypeCode=='4')) {
			if ((TumStagesID=='')||(TumStagesDesc=='')){
				$.messager.popover({msg: '请录入肿瘤分期...',type:'alert'});
				editorTumStages.next().children(':first').focus();
				return false;
			}
		}
	}

	// 入院病情
	var objAdmit = editorAdmitCond.combogrid('grid').datagrid('getSelected');
	var AdmitCondID='',AdmitCondDesc='';
	if (objAdmit!==null){
		AdmitCondID = objAdmit.ID;
		AdmitCondDesc = objAdmit.Desc;
	}else{
		AdmitCondDesc = editorAdmitCond.combogrid('getValue');
	}
	if (AdmitCondID==''&&AdmitCondDesc!='') {
		$.messager.popover({msg: '入院病情不标准...',type:'alert'});
		editorAdmitCond.next().children(':first').focus();
		return false;
	}
	if ((TypeCode=='3')||(TypeCode=='4')) {
		if ((AdmitCondID=='')||(AdmitCondDesc=='')){
			$.messager.popover({msg: '请录入入院病情...',type:'alert'});
			editorAdmitCond.next().children(':first').focus();
			return false;
		}
	}

	// 出院情况
	var DischCondID='',DischCondDesc='';
	if (!editorDischCond.combogrid('options').disabled) {
		var record = editorDischCond.combogrid('grid').datagrid('getSelected');
		if (record!==null){
			DischCondID = record.ID;
			DischCondDesc = record.Desc;
		}else{
			DischCondDesc = editorDischCond.combogrid('getValue');
		}
		if (DischCondID==''&&DischCondDesc!='') {
			$.messager.popover({msg: '出院情况不标准...',type:'alert'});
			editorDischCond.next().children(':first').focus();
			return false;
		}
		if ((TypeCode=='3')||(TypeCode=='4')) {
			if ((DischCondID=='')||(DischCondDesc=='')){
				$.messager.popover({msg: '请录入出院情况...',type:'alert'});
				editorDischCond.next().children(':first').focus();
				return false;
			}
		}
	}

	// 表格值赋值
	var IsDefiniteID='',IsDefiniteDesc='',AttDiag='';
	var row = $('#gridDiag').datagrid('getRows')[eIndex]
	var data = {
		Index:row.Index,
		VolumeID:row.VolumeID,
		aMasterID:row.MasterID,
		TypeID:TypeID,
		TypeCode:TypeCode,
		TypeDesc:TypeDesc,
		ICDVerID:ICDVerID,
		ICDID:ICDID,
		ICD10:ICD10,
		ICDDesc:ICDDesc,
		ICDinPair:ICDinPair,
		AdmitCondID:AdmitCondID,
		AdmitCondDesc:AdmitCondDesc,
		DischCondID:DischCondID,
		DischCondDesc:DischCondDesc,
		IsDefiniteID:IsDefiniteID,
		IsDefiniteDesc:IsDefiniteDesc,
		AttDiag:AttDiag,
		EditFinish:1,
		ClinicICDDesc:ClinicICDDesc,
		ClinicICD10:ClinicICD10,
		TumICDID:TumICDID,
		TumICD10:TumICD10,
		TumICDDesc:TumICDDesc,
		TumDifferID:TumDifferID,
		TumDifferDesc:TumDifferDesc,
		TumStagesID:TumStagesID,
		TumStagesDesc:TumStagesDesc,
		InjuryICDID:InjuryICDID,
		InjuryICD10:InjuryICD10,
		InjuryICDDesc:InjuryICDDesc
	}
	$('#gridDiag').datagrid('endEdit', eIndex);
	$('#gridDiag').datagrid('updateRow',{
		index: eIndex,	
		row: data
	});
	if (flag==0) {
		// 编辑下一行
		if (eIndex<($('#gridDiag').datagrid('getData').total-1)) {
			globalObj.m_cbgChangeValueType=1;
			$('#gridDiag').datagrid('selectRow',eIndex+1);
			$('#gridDiag').datagrid('beginEdit',eIndex+1);
		}else{
			$('#gridDiag').datagrid('unselectAll');
		}
	}
	if (!select){	// 新增行需要变动附属诊断结构
		var tjson='{"number": '+RowNumber+',"attDiag": ['+']}';
		globalObj.m_attDiag.Data.push(JSON.parse(tjson));
		globalObj.m_attDiag.number=RowNumber;
		globalObj.m_attDiag.total=globalObj.m_attDiag.total+1;	//计数变动
	}
	enableDnd();
	return true;
}

// 删除诊断
function CancelDiag(){
	var select = $('#gridDiag').datagrid('getSelected');
	if (select==null) {	
		$.messager.popover({msg: '请选择一条诊断数据...',type:'alert'});
		return false;
	}else{
		var RowNumber = select.Index;	//诊断的序号
		var rowindex = RowNumber-1
		$.messager.confirm('删除','确定删除第'+RowNumber+'条诊断?',function(r){
		    if (r){
				$('#gridDiag').datagrid('deleteRow',rowindex);
				var gridDiagData = $('#gridDiag').datagrid('getData'); 
				for (var i = 0 ;i<gridDiagData.total; i ++ ) {
					var rowdata = gridDiagData.rows[i];
					rowdata.Index =(i+1);
					$('#gridDiag').datagrid('updateRow',{
						index: i,	
						row: rowdata
					});
					globalObj.m_DiagSelectindex='';
				}
				// 删除诊断，附属诊断结构变化
				$.hisui.removeArrayItem(globalObj.m_attDiag.Data,'number',RowNumber)  // 删除数组中的元素
				globalObj.m_attDiag.total=globalObj.m_attDiag.total-1;	//计数变动
				// number值变动
				for (var i = 0; i < globalObj.m_attDiag.total; i++ )
				{
					if (globalObj.m_attDiag.Data[i].number>RowNumber)
					{
						globalObj.m_attDiag.Data[i].number=globalObj.m_attDiag.Data[i].number-1;
					}
				}
		    }
		});
	}
}

// 编目诊断移动
function moveDiag(type){
	var select = $('#gridDiag').datagrid('getSelected');
	if (select==null) {	
		$.messager.popover({msg: '请选择一条诊断数据...',type:'alert'});
		return false;
	}
	var RowNumber = select.Index;	//诊断的序号
	var rowindex = parseInt(RowNumber)-1;
	if (type=='up'){
		if (rowindex!=0) {
			moveUpDiag(rowindex);
			$('#gridDiag').datagrid('selectRow',rowindex-1)
		}
	}
	if (type=='down'){
		if (rowindex<($('#gridDiag').datagrid('getData').total-1)){
			moveUpDiag(rowindex+1);
			$('#gridDiag').datagrid('selectRow',rowindex+1)
		}
	}

}

// 上移编目诊断
function moveUpDiag(index){
	if (index!=0){
		var toupdata = $('#gridDiag').datagrid('getData').rows[index];
		var todowndata = $('#gridDiag').datagrid('getData').rows[index-1];
		var tmpdata = {
			Index:parseInt(todowndata.Index)+1,
			VolumeID:todowndata.VolumeID,
			aMasterID:todowndata.MasterID,
			TypeID:todowndata.TypeID,
			TypeCode:todowndata.TypeCode,
			TypeDesc:todowndata.TypeDesc,
			ICDVerID:todowndata.ICDVerID,
			ICDID:todowndata.ICDID,
			ICD10:todowndata.ICD10,
			ICDDesc:todowndata.ICDDesc,
			AdmitCondID:todowndata.AdmitCondID,
			AdmitCondDesc:todowndata.AdmitCondDesc,
			DischCondID:todowndata.DischCondID,
			DischCondDesc:todowndata.DischCondDesc,
			IsDefiniteID:todowndata.IsDefiniteID,
			IsDefiniteDesc:todowndata.IsDefiniteDesc,
			ICDinPair:todowndata.ICDinPair,
			AttDiag:todowndata.AttDiag,
			EditFinish:(!todowndata.EditFinish)?0:1,		// 此条是否已点保存
			ClinicICDDesc:todowndata.ClinicICDDesc,
			ClinicICD10:todowndata.ClinicICD10,
			TumICDID:todowndata.TumICDID,
			TumICD10:todowndata.TumICD10,
			TumICDDesc:todowndata.TumICDDesc,
			TumDifferID:todowndata.TumDifferID,
			TumDifferDesc:todowndata.TumDifferDesc,
			TumStagesID:todowndata.TumStagesID,
			TumStagesDesc:todowndata.TumStagesDesc,
			InjuryICDID:todowndata.InjuryICDID,
			InjuryICD10:todowndata.InjuryICD10,
			InjuryICDDesc:todowndata.InjuryICDDesc
		}
    if (!toupdata.EditFinish){
			toupdata.EditFinish=0;
		}else{
			toupdata.EditFinish=1;
		}
		toupdata.Index = toupdata.Index-1;
		$('#gridDiag').datagrid('updateRow',{
			index: index-1,	
			row: toupdata
		});
		$('#gridDiag').datagrid('updateRow',{
			index: index,	
			row: tmpdata
		});
		// 诊断移动，附属诊断结构相应变化
		for (var i = 0; i < globalObj.m_attDiag.total; i++ )
		{
			if (globalObj.m_attDiag.Data[i].number==toupdata.Index)
			{
				var tmp=globalObj.m_attDiag.Data[i].attDiag
				globalObj.m_attDiag.Data[i].attDiag=globalObj.m_attDiag.Data[i-1].attDiag;
				globalObj.m_attDiag.Data[i-1].attDiag=tmp;
			}
		}
	}
}

// 复制诊断
function CopyDiag(aFlag){
	var select = $('#gridDiag').datagrid('getSelected');
	if ((aFlag=="Copy")&&(select==null)) {	
		$.messager.popover({msg: '请选择一条诊断数据...',type:'alert'});
		return false;
	}
	var data	= $("#gridDiag").datagrid("getData");
	var length	= data.total;
	
	var RowNumber = length    //插入时候，不选行，插入到最后一行的下行
	if (select!=null) RowNumber = select.Index;	//选行的话，选中行的序号
	RowNumber = parseInt(RowNumber)
	if (aFlag=="Copy"){
		var rowdata = {
			Index:RowNumber+1,	// 插入诊断的序号
			VolumeID:'',
			aMasterID:'',
			TypeID:(typeof(select.TypeID)=='undefined')?'':select.TypeID,
			TypeCode:'',
			TypeDesc:(typeof(select.TypeDesc)=='undefined')?'':select.TypeDesc,
			ICDVerID:'',
			ICDID:'',
			ICD10:'',
			ICDDesc:'',
			AdmitCondID:(typeof(select.AdmitCondID)=='undefined')?'':select.AdmitCondID,
			AdmitCondDesc:(typeof(select.AdmitCondDesc)=='undefined')?'':select.AdmitCondDesc,
			DischCondID:(typeof(select.DischCondID)=='undefined')?'':select.DischCondID,
			DischCondDesc:(typeof(select.DischCondDesc)=='undefined')?'':select.DischCondDesc,
			IsDefiniteID:'',
			IsDefiniteDesc:'',
			ICDinPair:'',
			AttDiag:'',
			EditFinish:0,		// 新增行,未完成编辑
			ClinicICDDesc:(typeof(select.ClinicICDDesc)=='undefined')?'':select.ClinicICDDesc,
			ClinicICD10:(typeof(select.ClinicICD10)=='undefined')?'':select.ClinicICD10,
			TumICDID:'',
			TumICD10:'',
			TumICDDesc:'',
			TumDifferID:(typeof(select.TumDifferID)=='undefined')?'':select.TumDifferID,
			TumDifferDesc:(typeof(select.TumDifferDesc)=='undefined')?'':select.TumDifferDesc,
			TumStagesID:(typeof(select.TumStagesID)=='undefined')?'':select.TumStagesID,
			TumStagesDesc:(typeof(select.TumStagesDesc)=='undefined')?'':select.TumStagesDesc,
			InjuryICDID:'',
			InjuryICD10:'',
			InjuryICDDesc:''
		}
	}else{
		var rowdata = {
			Index:RowNumber+1,	// 插入诊断的序号
			VolumeID:'',
			aMasterID:'',
			TypeID:ServerObj.OtherDiagTypeID,	// 插入默认其他诊断
			TypeCode:ServerObj.OtherDiagTypeCode,
			TypeDesc:ServerObj.OtherDiagTypeDesc,
			ICDVerID:'',
			ICDID:'',
			ICD10:'',
			ICDDesc:'',
			AdmitCondID:'',
			AdmitCondDesc:'',
			DischCondID:'',
			DischCondDesc:'',
			IsDefiniteID:'',
			IsDefiniteDesc:'',
			ICDinPair:'',
			AttDiag:'',
			EditFinish:0,		// 新增行,未完成编辑
			ClinicICDDesc:'',
			ClinicICD10:'',
			TumICDID:'',
			TumICD10:'',
			TumICDDesc:'',
			TumDifferID:'',
			TumDifferDesc:'',
			TumStagesID:'',
			TumStagesDesc:'',
			InjuryICDID:'',
			InjuryICD10:'',
			InjuryICDDesc:''
		}
	}
	var Index = RowNumber		// 插入行的索引
	$('#gridDiag').datagrid('insertRow',{
		index: Index,
		row: rowdata
	});
	var gridDiagData=$('#gridDiag').datagrid('getData');
	for (var i = 0 ;i<gridDiagData.total; i ++ ) {
		var rowdata = gridDiagData.rows[i];
		rowdata.Index =(i+1);
		$('#gridDiag').datagrid('updateRow',{
			index: i,	
			row: rowdata
		});
		globalObj.m_DiagSelectindex='';
	}
	// 插入之前,附属诊断结构,选中行之后的number+1,留出的用于插入新的
	var item={number:RowNumber+1,attDiag:[]};
	for (var i = Index; i < globalObj.m_attDiag.total; i++) {
		var tnumber = globalObj.m_attDiag.Data[i].number;
		globalObj.m_attDiag.Data[i].number=tnumber+1;
	}
	$.hisui.addArrayItem(globalObj.m_attDiag.Data,'number',item)  // 增加元素并按照number排序
	globalObj.m_attDiag.Data.sort(function (a, b) {
		if (a.number < b.number) {
			return -1;
		} else if (a.number == b.number) {
			return 0;
		} else {
			return 1;
		}
	});
	globalObj.m_attDiag.total=globalObj.m_attDiag.Data.length;	// 设置total的新值
	$('#gridDiag').datagrid('selectRow',Index);
	globalObj.m_cbgChangeValueType = 1;
	$('#gridDiag').datagrid('beginEdit',Index);
	enableDnd();
}

// 组织编目诊断数据
 function getDiag(status){
 	var data = $('#gridDiag').datagrid('getData')
 	var strResult = '';
	for (var ind = 0; ind < data.total; ind++){
		var strTemp = '';
		var record = data.rows[ind];
		if (status == 'R'){	//草稿数据
			strTemp = record.ICDID
			strTemp += '^' + record.ICDVerID
			strTemp += '^' + record.ICD10
			strTemp += '^' + record.ICDinPair
			strTemp += '^' + record.ICDDesc
			strTemp += '^' + record.TypeID
			strTemp += '^' + record.TypeCode
			strTemp += '^' + record.TypeDesc
			strTemp += '^' + record.AdmitCondID
			strTemp += '^' + record.AdmitCondDesc
			strTemp += '^' + record.DischCondID
			strTemp += '^' + record.DischCondDesc
			strTemp += '^' + record.IsDefiniteID
			strTemp += '^' + record.IsDefiniteDesc
			strTemp += '^' + record.TumICDID
			strTemp += '^' + record.TumICD10
			strTemp += '^' + record.TumICDDesc
			strTemp += '^' + record.TumDifferID
			strTemp += '^' + record.TumDifferDesc
			strTemp += '^' + record.TumStagesID
			strTemp += '^' + record.TumStagesDesc
			strTemp += '^' + record.ClinicICDDesc
			strTemp += '^' + record.InjuryICDID
			strTemp += '^' + record.InjuryICD10
			strTemp += '^' + record.InjuryICDDesc
			strTemp += '^' + record.ClinicICD10
		}
		if (strResult != '') strResult += CHR_1
		strResult += CHR_2 + record.Index
		strResult += CHR_2 + record.ICDID
		strResult += CHR_2 + record.TypeID
		strResult += CHR_2 + record.AdmitCondID
		strResult += CHR_2 + record.DischCondID
		strResult += CHR_2 + record.IsDefiniteID
		strResult += CHR_2 + strTemp
		strResult += CHR_2 + record.TumICDID
		strResult += CHR_2 + record.TumICD10
		strResult += CHR_2 + record.TumICDDesc
		strResult += CHR_2 + record.TumDifferID
		strResult += CHR_2 + record.TumStagesID
		strResult += CHR_2 + record.ClinicICDDesc
		strResult += CHR_2 + record.ICD10
		strResult += CHR_2 + record.ICDDesc
		strResult += CHR_2 + record.InjuryICDID
		strResult += CHR_2 + record.InjuryICD10
		strResult += CHR_2 + record.InjuryICDDesc
		strResult += CHR_2 + record.ClinicICD10
	}
	return strResult;
 }

/**
 * NUMS: D002
 * CTOR: LIYI
 * DESC: 附属诊断录入模块
 * DATE: 2019-11-28
 * NOTE: 诊断录入模块方法定义
 * TABLE: 
 */
// 弹出附属诊断录入框
function EditAttDiag(diagid,Index,aTypeId,aTypeDesc) {
	if (ServerObj.IsMergeDiagOperPage==1){
		globalObj.m_DiagIndex = Index;
		var strUrl = "./ma.ipmr.fp.frontpage.attdiag.csp?&diagid="+diagid
		+"&Index="+Index
		+"&TypeId="+aTypeId
		+"&TypeDesc="+aTypeDesc
		+"&ConfigICDVerID="+ServerObj.ConfigICDVerID
		+"&2=2"
		websys_showModal({
			url:strUrl,
			title:'附属诊断',
			iconCls:'icon-w-epr',  
			originWindow:window,
			width:600,
			height:400
		});
	}else{
	$('#AttDiagDiag').css('display','block');
	globalObj.m_DiagIndex = Index;
	loadAttDiag();
	$('#AttDiagDiag').window({
		title: '附属诊断',
		iconCls: 'icon-w-new',
		minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
		closed: false,
		cache: false,
		modal: true,
		onBeforeOpen: function(){
			$('#cboAttAdmitCond').combogrid('setValue', aTypeId);
		},
		onOpen: function(){
			globalObj.m_attDiagOpen=1;
		},
		onClose: function(){
			globalObj.m_attDiagOpen=0;
		}
	});
	Common_Focus('cboAttICD');
	}
}

// 生成附属诊断结构
function buildAttDiagJson(grid){
	var data=$('#'+grid).datagrid('getData');
	var json='{"total": '+data.total+',"Data": ['
	var tmpjson ="";
	for (var ind = 0; ind < data.total; ind++){
		var orderindex =data.rows[ind].Index;
		var tjson='{"number": '+orderindex+',"attDiag": ['
		
		var attDiagData=$cm({
			ClassName:"MA.IPMR.FPS.CodeDiagSrv",
			QueryName:"QryAttDiag",
			aDiagID:data.rows[ind].DiagID,
			aConfigID:ServerObj.DefaultFPConfig,
			page:1,
			rows:100
		},false);
		var attjson='';
		for (var j = 0 ;j <attDiagData.total;j ++ ) {
			var attDiagRowData = attDiagData.rows[j];
			var rjson = {
				"ICDID":attDiagRowData.ICDID,
				"ICD10":attDiagRowData.ICD10,
				"ICDDesc":attDiagRowData.ICDDesc,
				"AdmitCondID":attDiagRowData.AdmitCondID,
				"AdmitCondDesc":attDiagRowData.AdmitCondDesc
			}
			tmp=JSON.stringify(rjson);
			if (attjson=="") {
				attjson=tmp;
			}else{
				attjson=attjson+","+tmp;
			}
		}
		if (attjson=='')  {
			tjson = tjson+']}';
		}else{
			tjson = tjson+attjson+']}';
		}
		if (tmpjson=='') {
			tmpjson = tjson
		}else{
			tmpjson = tmpjson+','+tjson;
		}
	}
	json = json+tmpjson+']}';
	globalObj.m_attDiag=JSON.parse(json)
}

// 初始化附属诊断表格
function InitAttDiag(){
	$('#gridAttDiag').datagrid({
		fit: true,
		rownumbers: true,
		singleSelect: false,
		autoRowHeight: false,
		loadMsg: '数据加载中...',
		fitColumns: true,
		url:'',
		columns:[[
			{field: 'ICD10',title: '疾病编码',width: 100,align: 'left'},
			{field: 'ICDDesc',title: '疾病名称',width: 230,align: 'left'},
			{field: 'AdmitCondDesc',title: '入院病情',width: 100,align: 'left'}
		]]
	});
}

// 加载附属诊断表格数据
function loadAttDiag() {
	$("#gridAttDiag").datagrid("loadData", {"rows":[],"total":0});
	for (i=0; i < globalObj.m_attDiag.total ; i++)
	{
		if (globalObj.m_attDiag.Data[i].number!=globalObj.m_DiagIndex) continue;
		var attDiag = globalObj.m_attDiag.Data[i].attDiag;
		for (j=0;j<attDiag.length ;j++ )
		{
			$('#gridAttDiag').datagrid('insertRow',{
				row: {
					ICDID: attDiag[j].ICDID,
					ICD10: attDiag[j].ICD10,
					ICDDesc: attDiag[j].ICDDesc,
					AdmitCondID:attDiag[j].AdmitCondID,
					AdmitCondDesc:attDiag[j].AdmitCondDesc
				}
			});
		}
	}
}

// 删除附属诊断
function delAttDiag(){
	var selectVol = $('#gridAttDiag').datagrid('getSelected');
	if (selectVol==null){
		$.messager.popover({msg: '请选择一条附加诊断信息...',type:'alert'});
		return false;
	}
	var rowindex = $('#gridAttDiag').datagrid("getRowIndex",selectVol)
	$('#gridAttDiag').datagrid("deleteRow",rowindex)
	updateAttDiag();
	// 更新诊断表格的附属诊断列
	updateDiagAttColumn();
}

// 添加附属诊断
function addAttDiag(){
	var objAdmit = $('#cboAttAdmitCond').combogrid('grid').datagrid('getSelected');
	var AdmitCondID='',AdmitCondDesc='';
	if (objAdmit!==null){
		AdmitCondID = objAdmit.ID;
		AdmitCondDesc = objAdmit.Desc;
	}
	var objICD = $('#cboAttICD').combogrid('grid').datagrid('getSelected');
	var ICDID = '',ICD10 = '',ICDDesc = '',ICDVerID = '',InPairCode ='';
	if (objICD!==null){
		ICDID = objICD.ID;
		ICD10 = objICD.ICD10;
		ICDDesc = objICD.Desc;
		InPairCode  = objICD.InPairCode;
		ICDVerID  = objICD.VerID;
	}
	if ((ICDID=='')||(ICD10=='')||(ICDDesc=='')){
		$.messager.popover({msg: '请录入诊断编码！',type: 'alert',timeout: 1000});
		return false;
	}
	if ((AdmitCondID=='')||(AdmitCondDesc=='')){
		$.messager.popover({msg: '请录入入院病情！',type: 'alert',timeout: 1000});
	 	return false;
	}
	// 先加进表格
	$('#gridAttDiag').datagrid('insertRow',{
		row: {
			ICDID: ICDID,
			ICD10: ICD10,
			ICDDesc: ICDDesc,
			AdmitCondID:AdmitCondID,
			AdmitCondDesc:AdmitCondDesc
		}
	});
	updateAttDiag();
	$('#cboAttAdmitCond').combogrid('setValue', '');
	$('#cboAttICD').combogrid('setValue', '');
	// 更新诊断表格的附属诊断列
	updateDiagAttColumn();
	Common_Focus('cboAttICD');
}

// 更新诊断表格的附属诊断列
function updateDiagAttColumn(){
	var Data = $('#gridAttDiag').datagrid('getData');
	if (typeof(arguments[0])=='object') {
		Data =arguments[0];
	}
	var AttDiag='';
	for (var i=0;i<Data.total ;i++ ){
		var record = Data.rows[i];
		var ICD10 = record.ICD10
		if (AttDiag=='')
		{
			AttDiag = ICD10;
		}else{
			AttDiag = AttDiag+','+ICD10;
		}
	}
	var tmprecord='';
	var dataDiag = $('#gridDiag').datagrid('getData')
	for (i=0; i < dataDiag.total ; i++)
	{
		var record = dataDiag.rows[i];
		if (record.Index==globalObj.m_DiagIndex){
			var tmprecord = record;
		}
	}
	if (tmprecord=='') return;
	tmprecord.AttDiag=AttDiag;
	$('#gridDiag').datagrid('updateRow',{
		index: globalObj.m_DiagIndex-1,	
		row: tmprecord
	});
};

// 更新附加诊断结构数据
function updateAttDiag() {
	var Data = $('#gridAttDiag').datagrid('getData');
	if (typeof(arguments[0])=='object') {
		Data =arguments[0];
	}
	// 组织当前附加诊断的数组结构
	var tarr = [];
	var jsonstr='';
	for (var i=0;i<Data.total ;i++ ){
		var record = Data.rows[i];
		var rjson = {
			"ICDID":Data.rows[i].ICDID,
			"ICD10":Data.rows[i].ICD10,
			"ICDDesc":Data.rows[i].ICDDesc,
			"AdmitCondID":Data.rows[i].AdmitCondID,
			"AdmitCondDesc":Data.rows[i].AdmitCondDesc
		}
		tarr[i]=rjson;
	}
	for (i=0; i < globalObj.m_attDiag.total ; i++)
	{
		var attDiag = globalObj.m_attDiag.Data[i]
		if (attDiag.number!=globalObj.m_DiagIndex) continue;
		globalObj.m_attDiag.Data[i].attDiag=tarr;
	}
}

// 组织编目附加诊断数据
 function getAttDiag(){
	var strResult='';
 	for (i=0; i < globalObj.m_attDiag.total ; i++)
	{
		var attDiag = globalObj.m_attDiag.Data[i].attDiag;
		if (attDiag.length==0) continue;
		var tmpatt=globalObj.m_attDiag.Data[i].number;
		for (j=0;j<attDiag.length ;j++ )
		{
			var strTmp='';
			strTemp = attDiag[j].ICDID;
			strTemp += '^' +  attDiag[j].AdmitCondID;
			tmpatt = tmpatt+CHR_1+strTemp;
		}
		if (strResult == '') {
			strResult =tmpatt
		}else{
			strResult += CHR_2 + tmpatt
		}
	}
	return strResult;
 }

// 禁用浏览器默认的 ctr+s
$(document).bind('keydown keypress', 'ctrl+s', function(e){
	var KCode		= window.event.keyCode;
	var shiftKey	= window.event.shiftKey;
	var ctrlKey		= window.event.ctrlKey;
	if ((ctrlKey)&&(KCode==83)){
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
		SaveDiag(1);	// 诊断信息存入表格
		return false;
	}
	if ((ctrlKey)&&(KCode==68)){
		CancelDiag();
		return false;
	}
	if (KCode==115){	  // F4 
		window.parent.window.SaveResult("C");
		return false;
	}
}

/**
 * 从电子病历增加诊断行
 * @param {type} 诊断类型代码：编目数据项代码前两位,如D04：其他诊断
 * @return {Boolean} True 正常, false 异常
 */
function addEmrData(type)
{
	try {
		$cm({
	    	ClassName:"MA.IPMR.FPS.CodeDiagSrv",
	    	QueryName:"QryDiag",
	    	aVolumeID:ServerObj.VoumeID,
	    	aFPConfig:ServerObj.DefaultFPConfig,
	    	aEmrFlag:1,
	    	aDiagTypeCode:type.split('^')[0],
	    	aDiagRowNum:type.split('^')[1],
	    	page:1,
	    	rows:10000
	    },function(rs){
	    	if (rs.total==0) return;
	    	var Index = $('#gridDiag').datagrid('getData').total;
	    	rs.rows[0].Index=Index+1;
	    	$('#gridDiag').datagrid('appendRow',rs.rows[0]);
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
			if  (dicType=='CMDiagType'||dicType=='DiagType'){
				var value = $(this).combogrid('getValue')
				// 非主要诊断、其他诊断 入院病情为空不可编辑
				if (value=='门急诊诊断' || value=='入院诊断' || value=='损伤中毒诊断' || value=='病理诊断'|| value=='医院感染诊断'){	
					setDisable('disable');
				}else{
					setDisable('enable');
				}

				// 在病理诊断、损伤中毒诊断切换置空ICD
				if (newValue=='病理诊断' || newValue=='损伤中毒诊断' || oldValue=='病理诊断'|| oldValue=='损伤中毒诊断'){	
					editorICD.combogrid('setValue', '');
					var queryParams=editorICD.combogrid('options').queryParams;
					editorICD.combogrid('grid').datagrid("load",$.extend({},queryParams,{aAlias:'',aTypeID:''}));
					$('.datagrid-row-editing td[field="ICD10"] div').html('');
				}

				// 中医相关诊断切换置空ICD
				if (newValue=='门急诊诊断（中医诊断）' || newValue=='门急诊诊断（中医侯证）' || newValue=='中医主证' || newValue=='中医主病' || newValue=='其他中医诊断' || oldValue=='门急诊诊断（中医诊断）' || oldValue=='门急诊诊断（中医侯证）' || oldValue=='中医主证'|| oldValue=='中医主病'|| oldValue=='其他中医诊断'){	
					editorICD.combogrid('setValue', '');
					var queryParams=editorICD.combogrid('options').queryParams;
					editorICD.combogrid('grid').datagrid("load",$.extend({},queryParams,{aAlias:'',aTypeID:''}));
					$('.datagrid-row-editing td[field="ICD10"] div').html('');
				}
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
					entercbg(this)
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
 * @param {id} id
 * @return {cmp}下拉组件
 */
function ComboICD(verId,id){
	var cbg = {
		id:id,
		url: $URL,
		idField:'Desc',
		textField: 'ICD10',
		method: 'get',
		mode:'remote',
		fitColumns:true,
		panelWidth:600,
		panelHeight:200,
		editable: true,
		sortName:'Count',
		sortOrder:'asc',
		pageSize: 50,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		enterNullValueClear:false,
		selectOnNavigation:false,
	    delay:'500',
		columns:[[
			{field:'ICD10',title:'疾病编码',width:100,
				formatter:function(value,row,index)
				{
					var ICD10 = row["ICD10"];
					var InPairCode = row["InPairCode"];
					var ICD = ICD10+InPairCode;
					return ICD;	
				}
			},
			{field:'Desc',title:'名称',width:200},
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
		},/*
		onChange:function(newValue, oldValue){
			if (globalObj.m_cbgChangeValueType) return;
			var record = $(this).combogrid("grid").datagrid("getSelected");
			if (record==null) {
				$('.datagrid-row-editing td[field="ICD10"] div').html('');
			}else{
				$('.datagrid-row-editing td[field="ICD10"] div').html(record.ICD10+record.InPairCode);
			}
		},*/
		onSelect:function(rowIndex, rowData){
			if (globalObj.m_cbgChangeValueType) return;
			if (id=='ICD') {
				$('.datagrid-row-editing td[field="ICD10"] div').html(rowData.ICD10+rowData.InPairCode);
				setTumInjurySataus(rowData.ICD10);
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
				var id = $(this).combogrid('options').id;
				var TypeCode='';
				if (id =='ICD') {
					// 当前编辑行诊断类型ID
					var objType = editorType.combogrid('grid').datagrid('getSelected');
					var TypeID='';
					if (objType!==null){
						TypeID = objType.ID;
						TypeCode=objType.Code;
					}
					if (TypeID=='') return;
				}
				if (id =='InjuryICD') {
					var TypeID=ServerObj.InjuryICDTypeID;
				}
				if (id =='TumICD') {
					var TypeID=ServerObj.TumICDTypeID;
				}
				if ((TypeCode==10)||(TypeCode==11)||(TypeCode==12)||(TypeCode==13)||(TypeCode==14)) {	// 中医编码
					Qrycbglink(this,q,TypeID,ServerObj.ConfigICDVer2ID);
				}else{
					Qrycbglink(this,q,TypeID,ServerObj.ConfigICDVerID);
				}
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
 * 表格内回车到下一个表单
 * @param {target} 	当前表单
 * @return
 */
function enterToNext(target) {
	var inputEles = $("td[field!=''] td > input[type='text'][disabled!='disabled']");
	for(var i=0;i<inputEles.length;i++){
		if ($(inputEles[i]).is($(target))) { //判断两个jQuery对象是否相等
			//校验数据，回车到下一个录入框
			if(i == inputEles.length-1){	//	最后一个表单
				SaveDiag(0);
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

function addDiagFromEmr(row) {
	var Index = $('#gridDiag').datagrid('getData').total;
	row.Index=Index+1;
	$('#gridDiag').datagrid('appendRow',row);
}
function getAttDiagobj() {
	return globalObj.m_attDiag;
}