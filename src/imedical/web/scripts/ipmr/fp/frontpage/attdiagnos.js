/**
 * 首页诊断信息
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
	m_attDiag:{},			// 附属诊断
}

// 页面入口
$(function(){
	$HUI.combogrid("#cboAttICD", {
		url: $URL,
		panelWidth:550,
		panelHeight:250,
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
	InitAttDiag();
	// 删除-附属诊断
	$('#delAttDiag').bind('click', function() {
		delAttDiag();
	});
})

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
	loadAttDiag();
}

// 加载附属诊断表格数据
function loadAttDiag() {
	$("#gridAttDiag").datagrid("loadData", {"rows":[],"total":0});
	var frames = window.parent.frames;
	for (i=0;i<frames.length;i++) {
		var frame = frames[i];
		if (frame.location.pathname=="/imedical/web/csp/ma.ipmr.fp.frontpage.main.csp") {
			globalObj.m_attDiag=frame.getAttDiagobj();
		}
	}
	for (i=0; i < globalObj.m_attDiag.total ; i++)
	{
		if (globalObj.m_attDiag.Data[i].number!=ServerObj.Index) continue;
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
	// 更新诊断表格的附属诊断列
	var Data = $('#gridAttDiag').datagrid('getData');
	var frames = window.parent.frames;
	for (i=0;i<frames.length;i++) {
		var frame = frames[i];
		if (frame.location.pathname=="/imedical/web/csp/ma.ipmr.fp.frontpage.main.csp") {
			frame.updateAttDiag(Data);
			frame.updateDiagAttColumn(Data)
		}
	}
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
	
	$('#cboAttAdmitCond').combogrid('setValue', '');
	$('#cboAttICD').combogrid('setValue', '');
	// 更新诊断表格的附属诊断列
	var Data = $('#gridAttDiag').datagrid('getData');
	var frames = window.parent.frames;
	for (i=0;i<frames.length;i++) {
		var frame = frames[i];
		if (frame.location.pathname=="/imedical/web/csp/ma.ipmr.fp.frontpage.main.csp") {
			frame.updateAttDiag(Data);
			frame.updateDiagAttColumn(Data)
		}
	}
	Common_Focus('cboAttICD');
}
