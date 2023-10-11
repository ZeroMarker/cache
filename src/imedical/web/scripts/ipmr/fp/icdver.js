/**
 * icdver ICD维护
 * 
 * Copyright (c) 2018-2019 zhouyang. All rights reserved.
 * 
 * CREATED BY zhouyang 2021-09-27
 * 
 * 注解说明
 * TABLE: 
 */
 // 页面全局变量对象
var globalObj = {
	m_icdtype:'',
	m_excelData:{total:0,rows:{}},
	m_verDesc:'',
	m_verCode:'',
	m_excelData1:''
}
var ButtonCountObj={};
$(function() {
	Init();
	InitEvent();
})

function Init() {
	InitGridICDSource();
	InitgridICDVersion();
	$('#File').filebox({
		buttonText: '选择',
		prompt:'选择要导入的Excel',
		accept:'application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
		width: 180
	});
}

function InitEvent() {
	// 版本维护
	$('#t-add').click(function() {editICDVersion('add');});
	$('#t-edit').click(function() {editICDVersion('edit');});
	// ICD维护
	$('#editICDDx-add').click(function() {editICDDx('add');});
	$('#editICDDx-edit').click(function() {editICDDx('edit');});
	$('#searchICD').searchbox({
		searcher:function (value,name) {
			serchICDDx( value );
        }
    });
	$('#downIcdTemp').click(function() {
		window.open("../scripts/ipmr/template/ICD编码Excel模板.rar", "_blank");
	});

	// 导入弹框
	$('#importIcd').click(function() {
		var title = '';
		if (globalObj.m_icdtype=='D') {
			title = '导入：'+globalObj.m_verDesc
		}
		if (globalObj.m_icdtype=='O') {
			title = '导入：'+globalObj.m_verDesc
		}
		ChangeButtonEnable({'#CheckData':false,'#ImportData':false,'#ClearData':false,'#ReadExcel':true});
		InitgridTmpICDDx();
		var DiagIcdImport = $HUI.dialog('#DiagIcdImport', {
			title :  title,
			iconCls : 'icon-w-edit',
			width: 1400,
       		height: 560,
			modal : true,
			minimizable : false,
			maximizable : false,
			maximizable : false,
			collapsible : false,
			onClose:function(){
				$('#File').filebox('clear');
				$('#Msg').panel({'content':" "});
				globalObj.m_excelData={total:0,rows:{}};
			}
		});
	});

	//	读取excel
	$('#ReadExcel').click(function() {
		var wb;   //wookbook
		$("#gridTmpICDDx").datagrid("loadData",{total:0,rows:{}});
		$('#Msg').panel({'content':" "});
		var filelist=$('#File').filebox("files");
		if(filelist.length==0){
			$.messager.popover({msg: '请选择要导入的Excel！',type:'alert',timeout: 1000});
			return 
		}
		var file = filelist[0];
  		var reader = new FileReader();
  		readfinish=0;
		$.messager.progress({
			title:'数据读取中...',
			value:0,
			interval:0
		});
		$.messager.progress('bar').progressbar('setValue', Math.round((99*100)/100));
		var interval=setInterval(function(){
	   		test();
		},100);
		function test() {
			if (readfinish==1) {
	   			clearInterval(interval);
				$.messager.progress('close');
	   		}
		}
        reader.onload = function(e) {
            if (reader.result){reader.content = reader.result;}
			var data = e ? e.target.result : reader.content;
            wb = XLSX.read(data, {
                type: 'binary'
            });
        	var json=to_json(wb)
        	globalObj.m_excelData = json;
        	globalObj.m_excelData1 = json;
       		InitgridTmpICDDx();
       		ChangeButtonEnable({'#CheckData':true,'#ImportData':false,'#ClearData':true,'#ReadExcel':true});
       		readfinish = 1;
        }
    	reader.readAsBinaryString(file);
	});

	// 校验数据
	$('#CheckData').click(function() {
		if(globalObj.m_excelData.total==0){
			$.messager.popover({msg: '没有需要校验的数据！',type:'alert',timeout: 1000});
			return;
		}
		Rows=globalObj.m_excelData.rows;
		// 分批次验证
		$.messager.progress({
			title:'数据校验中...',
			value:0,
			interval:0
		});
		var interval=setInterval(function(){
	   		CheckData();
		},100);
		jIndex = '',st='',ed='',num=100,EndFlag=0,msg='';
		function CheckData(){
			if (st=='') st=0;
			if (ed=='') ed=st+num;
			if (ed>Rows.length) {
				ed = Rows.length;
				EndFlag = 1;
			}
 			var jsonData = $cm({
				ClassName: 'CT.IPMR.FPS.ICDDxSrv',
				MethodName: 'TestDataInput',
				Rows: JSON.stringify(Rows.slice(st,ed)),
				JIndex:jIndex,
				ICDType:globalObj.m_icdtype,
				Start:st,
				EndFlag:EndFlag
			},false);
			msg = msg+jsonData.msg;
			if (ed==(Rows.length)) {
				clearInterval(interval);
				$.messager.progress('close');
				if (EndFlag==1) {
					if (msg=='') {
						$.messager.popover({msg: '数据校验通过！',type:'alert',timeout: 1000});
						$('#Msg').panel({'content':''})
						ChangeButtonEnable({'#CheckData':true,'#ImportData':true,'#ClearData':true,'#ReadExcel':true});
					}else{
						$.messager.popover({msg: '数据校验不通过，右侧查看原因！',type:'alert'});
						$('#Msg').panel({'content':msg})
						ChangeButtonEnable({'#CheckData':true,'#ImportData':false,'#ClearData':true,'#ReadExcel':true});
					}
				}
				return;
			}
			st=ed;
			ed=st+num;
			if (ed>Rows.length) {
				ed = Rows.length;
				EndFlag = 1;
			}
			$.messager.progress('bar').progressbar('setValue', Math.round((ed*100)/Rows.length));
			jIndex=jsonData.jIndex;
		}
	});

	// 导入
	$('#ImportData').click(function() {
		if(globalObj.m_excelData.total==0){
			$.messager.popover({msg: '没有需要导入的数据！',type:'alert',timeout: 1000});
			return;
		}
		Rows=globalObj.m_excelData.rows;
		// 分批次导入
		$.messager.progress({
			title:'数据导入中...',
			value:0,
			interval:0
		});
		var interval=setInterval(function(){
	   		importdata();
		},100);
		jIndex = '',st='',ed='',num=100,EndFlag=0,msg='';
		LogInfo = ServerObj.IpAdress;
		LogInfo += '^' + Logon.UserID;
		LogInfo += '^' + '页面导入';
		function importdata() {
			if (st=='') st=0;
			if (ed=='') ed=st+num;
			if (ed>Rows.length) {
				ed = Rows.length;
				EndFlag = 1;
			}
 			var jsonData = $cm({
				ClassName: 'CT.IPMR.FPS.ICDDxSrv',
				MethodName: 'DataInput',
				Rows: JSON.stringify(Rows.slice(st,ed)),
				JIndex:jIndex,
				ICDType:globalObj.m_icdtype,
				Start:st,
				EndFlag:EndFlag,
				VerCode:globalObj.m_verCode,
				LogInfo:LogInfo
			},false);
			msg = msg+jsonData.msg;
			if (ed==(Rows.length)) {
				clearInterval(interval);
				$.messager.progress('close');
				if (EndFlag==1) {
					if (msg=='') {
						$.messager.popover({msg: '导入成功！',type: 'success',timeout: 1000});
						$('#Msg').panel({'content':''})
					}else{
						$.messager.popover({msg: '存在导入失败的数据，右侧查看原因！',type:'alert',timeout: 1000});
						$('#Msg').panel({'content':msg})
					}
				}
				return;
			}
			st=ed;
			ed=st+num;
			if (ed>Rows.length) {
				ed = Rows.length;
				EndFlag = 1;
			}
			$.messager.progress('bar').progressbar('setValue', Math.round((ed*100)/Rows.length));
			jIndex=jsonData.jIndex;
		}
		//ChangeButtonEnable({'#CheckData':false,'#ImportData':true,'#ClearData':true,'#ReadExcel':true});
	});

	// 导出
	$('#downIcd').click(function() {
		$('#gridICDDx').datagrid('exportByJsxlsx', {
			filename: globalObj.m_verDesc,
			extension:'xlsx'
		});
	});

	
	// 清屏
	$('#ClearData').click(function() {
		ClearMain();
	});
	
}

 /**
 * NUMS: D001
 * CTOR: LIYI
 * DESC: 版本源模块
 * DATE: 2022-07-13
 * NOTE: 
 * TABLE: 
 */

 /**
 * 初始化版本源列表
 * @param {void}
 * @return {grid}
 */
function InitGridICDSource() {
	var columns = [[
		{field:'ID',title:'ID',width:50,hidden:'true'},
		{field:'Desc',title:'描述',width:200,align:'left'}
    ]];
  	var gridICDSource = $HUI.datagrid("#gridICDSource", {
		fit: true,
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		rownumbers : true, 
		title: "ICD版本源",
		singleSelect : true,
		autoRowHeight : false,
		loadMsg : '数据加载中...',
		fitColumns : true,
		url : $URL,
	    queryParams : {
		    ClassName : "CT.IPMR.BTS.DictionarySrv",
			QueryName : "QryDictionary",
			aDicType:"ICDEdition",
			aIsActive:1,
			rows : 10000
	    },
	    columns : columns,
	    onClickRow:function(rowIndex,rowData){
			selectICDSource(rowData.ID);
		}
	});
	return gridICDSource;
}
 /**
 * 版本源列表行单选处理
 * @param {SourceID}版本源ID
 * @return {grid}
 */
function selectICDSource(SourceID){
	if (typeof(SourceID)==undefined){ 
		$.messager.popover({msg: '请选择版本源！',type:'alert',timeout: 1000});
		return ;
	}
	$("#gridICDVer").datagrid("reload", {
	    ClassName : "CT.IPMR.FPS.ICDVerSrv",
		QueryName : "QryICDVerEdition",
		aEditionID: SourceID,
		rows : 10000
	})
  	$('#gridICDVer').datagrid('unselectAll');
}

 /**
 * NUMS: D002
 * CTOR: LIYI
 * DESC: 版本维护模块
 * DATE: 2022-07-13
 * NOTE: 
 * TABLE: 
 */
 /**
 * 初始化版本列表
 * @param {void}
 * @return {grid}
 */
function InitgridICDVersion() {
	var columns = [[
		{field:'ID',title:'ID',width:50},
		{field:'Code',title:'代码',width:100},
		{field:'ICDTypeDesc',title:'ICD类型',width:100,align:'left'},
		{field:'Version',title:'版本号',width:100,align:'left'},
		{field:'ActDate',title:'启用日期',width:120,align:'left'},
		{field:'EndDate',title:'停用日期',width:120,align:'left'},
		{field:'d',title:'ICD维护',width:80,align:'left',
			formatter:function(value,row,index) {
            	var rowid = row.ID;
            	var ICDTypeCode = row.ICDTypeCode;
            	var ICDTypeDesc = row.ICDTypeDesc;
            	var EditionDesc = row.EditionDesc;
            	var Version = row.Version;
            	var VerCode = row.Code;
               	return '<a href="#" class="grid-td-text-gray" onclick = editICDDetail(' + rowid +','+'"'+ICDTypeCode+'"' +','+'"'+EditionDesc+'"' +','+'"'+Version+'"'+','+'"'+ICDTypeDesc+'"'+ ','+'"'+VerCode+'"'+ ')>' + 'ICD维护' + '</a>';            
            }
		},
		{field:'Resume',title:'备注',width:150,align:'left'}
    ]];
  	var gridICDVer = $HUI.datagrid("#gridICDVer", {
		fit: true,
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		//rownumbers : true, 
		singleSelect : true,
		pagination : true, 
		autoRowHeight : false,
		loadMsg : '数据加载中...',
		pageSize : 10,
		fitColumns : true,
		url : $URL,
		groupField:'ICDTypeDesc',
		view: groupview,
		groupFormatter: function (value, rows) {
		    return value;
		},
	    queryParams : {
		    ClassName : "CT.IPMR.FPS.ICDVerSrv",
			QueryName : "QryICDVerEdition",
			aEditionID: "",
			rows : 10000
	    },
	    columns : columns
	});
	return gridICDVer;
}

 /**
 * 编辑版本信息
 * @param {option}新增 add，修改 edit
 * @return {void}
 */
function editICDVersion(option) {
	var selSource = $("#gridICDSource").datagrid('getSelected');
	if (!selSource){
		$.messager.popover({msg: '请选择一条ICD版本源记录！',type:'alert',timeout: 1000});
		return false;
	}
	var selected = $("#gridICDVer").datagrid('getSelected');
	if ( ( option == "edit") && (!selected) ) {
		$.messager.popover({msg: '请选择一条ICD版本记录！',type:'alert',timeout: 1000});
		return false;
	}
	$('#icdVerEdit').css('display','block');
	Common_ComboToDic("cboEdition","ICDEdition",1,'');
	Common_ComboToDic("cboICDType","ICDType",1,'');
	var _title = "修改ICD版本",_icon="icon-w-edit"
	if (option == "add") {
		_title = "添加ICD版本",_icon="icon-w-add";
		$('#txtICDVerID').val('');
		$("#txtICDVerCode").val('');
		$('#txtICDVerActDate').datebox('setValue','');
		$("#txtICDVerEndDate").datebox('setValue','');
		$("#txtICDVerResume").val('');
		$("#cboEdition").combobox('setValue', selSource.ID);
		$("#cboICDType").combobox('setValue', '');
		$("#txtICDVersion").val('');
	} else {
		$("#txtICDVerID").val(selected.ID);
		$("#txtICDVerCode").val(selected.Code);
		$("#txtICDVerActDate").datebox('setValue',selected.ActDate);
		$("#txtICDVerEndDate").datebox('setValue',selected.EndDate);
		$("#txtICDVerResume").val(selected.Resume);
		$('#cboEdition').combobox('setValue',selected.EditionID);
		$("#cboICDType").combobox('setValue', selected.ICDTypeID);
		$("#txtICDVersion").val(selected.Version);
	}
	var VerEditDialog = $HUI.dialog('#icdVerEdit', {
		title :  _title,
		iconCls : _icon,
		modal : true,
		minimizable : false,
		maximizable : false,
		maximizable : false,
		collapsible : false,
		buttons : [{
			text : '保存',
			iconCls :'icon-w-save',
			handler : function() {
				saveICDVersion();
			}
		},{
			text : '关闭',
			iconCls : 'icon-w-close',
			handler : function() {
				$('#icdVerEdit').window("close");
			}	
		}]
	});
}

 /**
 * 保存版本信息
 * @param {void}
 * @return {void}
 */
function saveICDVersion() {
	var ID = $('#txtICDVerID').val();
	var ICDVerCode = $('#txtICDVerCode').val();
	var ICDVerActDate = $('#txtICDVerActDate').datebox('getValue');
	var ICDVerEndDate = $('#txtICDVerEndDate').datebox('getValue');
	var ICDVerResume = $('#txtICDVerResume').val();
	var ICDEdition =$("#cboEdition").combobox('getValue');
	var ICDType =$("#cboICDType").combobox('getValue');
	var ICDVersion = $('#txtICDVersion').val();
	if (ICDType == '') {
		$.messager.popover({msg: '请选择ICD类型！',type:'alert',timeout: 1000});
		return false;
	}
	if (ICDVerCode == '') {
		$.messager.popover({msg: '请填写代码！',type:'alert',timeout: 1000});
		return false;
	}
	if (ICDVersion == '') {
		$.messager.popover({msg: '请填写版本号！',type:'alert',timeout: 1000});
		return false;
	}
	if (ICDVerActDate == '') {
		$.messager.popover({msg: '请填写启用日期！',type:'alert',timeout: 1000});
		return false;
	}
	var inputStr = ID;
	inputStr += '^' + ICDVerCode;
	inputStr += '^' + '';
	inputStr += '^' + ICDVerActDate;
	inputStr += '^' + ICDVerEndDate;
	inputStr += '^' + ICDVerResume;
	inputStr += '^' + ICDEdition;
	inputStr += '^' + ICDType;
	inputStr += '^' + ICDVersion;
	var flg = $m({
		ClassName:"CT.IPMR.FP.ICDVer",
		MethodName:"Update",
		aInputStr:inputStr,
		aSeparate:"^"
	},false);
	if (parseInt(flg) <= 0) {
		if (parseInt(flg) == -99){
			$.messager.alert("提示", "代码重复!", 'info');
		}else if (parseInt(flg) == -100){
			$.messager.alert("提示", "版本号重复!", 'info');
		}else{
			$.messager.alert("错误", "保存失败!", 'error');
		}
		return;
	}
	$('#icdVerEdit').window("close");
	$("#gridICDVer").datagrid("reload");
	return ;
}

 /**
 * NUMS: D003
 * CTOR: LIYI
 * DESC: ICD维护
 * DATE: 2022-07-13
 * NOTE:
 * TABLE:
 */

 /**
 * 打开ICD维护弹框
 * @param {icdVerID} 版本ID
 * @param {icdType} ICD编码类型代码
 * @param {edition} ICD版本源描述
 * @param {Version} 版本号
 * @param {icdTypeDesc} ICD编码类型描述
 * @return {void}
 */
function editICDDetail(icdVerID,icdType,edition,Version,icdTypeDesc,VerCode){
	globalObj.m_verDesc = edition+' '+icdTypeDesc+' '+Version;
	globalObj.m_icdtype = icdType;
	globalObj.m_verCode = VerCode;
	// 获取基础平台ICD版本同步到病案标志
	$m({
		ClassName:"CT.IPMR.FPS.ICDVerSrv",
		MethodName:"getICDSyncFlg",
		aVerCode:VerCode
	},function(txtData){
		if (txtData=='Y') {		// 开启同步后禁用维护功能
			$('#importIcd').linkbutton('disable');
			$('#editICDDx-add').linkbutton('disable');
			$('#editICDDx-edit').linkbutton('disable');
		}else{
			$('#importIcd').linkbutton('enable');
			$('#editICDDx-add').linkbutton('enable');
			$('#editICDDx-edit').linkbutton('enable');
		}
	});
	$('#searchICD').searchbox('setValue','');
	var icdColumns = [[
		{field: 'ID', title: 'ID',hidden:true},
		{field: 'Code', title: '代码', align: 'left'},
		{field: 'ICD10', title: '主码', align: 'left'},
		{field: 'InPairCode', title: '副码', align: 'left',hidden:icdType=='O'?true:false},
		{field: 'CatAlias', title: '类目', align: 'left'},
		{field: 'CatSubAlias', title: '亚目', align: 'left'},
		{field: 'DetailCataDesc', title: '细目', align: 'left',hidden:icdType=='D'?true:false},
		{field: 'Desc', title: '名称', align: 'left'},
		{field: 'OperTypeDesc', title: '手术类型', align: 'left',hidden:icdType=='D'?true:false},
		{field: 'OperLevelDesc', title: '手术级别', align: 'left',hidden:icdType=='D'?true:false},
		{field: 'IsGroupDRGDesc', title: '是否入组',align: 'left'},
		{field: 'DrgComplicationDesc', title: '并发症与合并症',align: 'left',hidden:icdType=='O'?true:false},
		{field: 'IsMedInsuGrayDesc', title: '医保灰码',align: 'left'},
		{field: 'Alias', title: '别名',align: 'left',
			formatter:function(value,row,index) {
            	var rowid = row.ID;
            	if (value != "" ) {
	            	return '<a href="#" class="grid-td-text-gray" onclick = editICDAlias(' + rowid + ')>' + value + '</a>';
	            } else {
					return '<a href="#" class="grid-td-text-gray" onclick = editICDAlias(' + rowid + ')>' + '空' + '</a>';
		        }               	
            }
		},
		{field: 'ActDate', title: '启用日期', align: 'left'},
		{field: 'EndDate', title: '停用日期', align: 'left'},
		{field: 'IsActive', title: '是否有效',align: 'left',
			formatter:function(value,row,index) {
            	if (value=='Y') {
            		return '是';
            	}else{
            		return '否';
            	}         
            }
		},
		{field: 'Resume', title: '备注', align: 'left'},
		{field: 'd', title: '日志',align: 'left',
			formatter:function(value,row,index) {
            	var rowid = row.ID;
            	return '<a href="#" class="grid-td-text-gray" onclick = showlogDiag(' + rowid + ')>维护日志</a>';           	
            }
        },

	]];
	var gridICDDx= $HUI.datagrid("#gridICDDx", {
		fit: true,
		iconCls : 'icon-write-order',
		rownumbers : true, 
		singleSelect : true,
		pagination : true, 
		autoRowHeight : false,
		loadMsg : '数据加载中...',
		pageSize : 10,
		//fitColumns : true,
		url : $URL,
	    queryParams : {
		    ClassName : "CT.IPMR.FPS.ICDDxSrv",
			QueryName : "QryICDDic",
			aVerID :icdVerID,
			aAlias : $('#searchICD').searchbox('getValue')
	    },
	    columns : icdColumns
	});
	var title = edition+' '+icdTypeDesc+' '+Version;
    var editICDDxDialog = $('#editICDDxDialog').dialog({
	    title: title,
		iconCls: 'icon-w-new',
	    width: 1400,
        height: 560,
	    minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
	    closed: false,
	    cache: false,
	    modal: true
	});
	return;
}
 /**
 * 维护ICD
 * @param {option}add or edit
 * @return {void}
 */
function editICDDx(option) {
	var selected = $("#gridICDDx").datagrid('getSelected');
	if ( ( option == "edit") && (!selected) ) {
		$.messager.popover({msg: '请选择一条记录！',type:'alert',timeout: 1000});
		return false;
	}
	Common_ComboToDic("cboICDDxOperType","OperType",1,"");
	Common_ComboToDic("cboICDDxOperLevel","OperationRank",1,"");
	Common_ComboToDic("cboIsGroupDRG","ICDIsGroupDRG",1,"");
	Common_ComboToDic("cboDrgComplication","DrgComplication",1,"");
	Common_ComboToDic("cboIsMedInsuGray","ICDIsMedInsuGray",1,"");
	
	$HUI.combobox("#cboICDCat", {
		url: $URL,
		editable: true,
		defaultFilter:4,
		valueField: 'ID',
		textField: 'CatAlias',
		onBeforeLoad: function (param) {
			param.ClassName = 'CT.IPMR.FPS.ICDCatSrv';
			param.QueryName = 'QryICDCat';
			param.aICDTypeCode = $("#gridICDVer").datagrid('getSelected').ICDTypeCode;
			param.ResultSetType = 'array';
		}
	});
	$HUI.combobox("#cboICDCatSub", {
		url: $URL,
		editable: true,
		defaultFilter:4,
		valueField: 'ID',
		textField: 'CatSubAlias',
		onBeforeLoad: function (param) {
			param.ClassName = 'CT.IPMR.FPS.ICDCatSrv';
			param.QueryName = 'QryICDCatSub';
			param.aICDTypeCode = $("#gridICDVer").datagrid('getSelected').ICDTypeCode;
			param.ResultSetType = 'array';
		}
	});
	$HUI.combobox("#cboDetailCata", {
		url: $URL,
		editable: true,
		defaultFilter:4,
		valueField: 'ID',
		textField: 'DetailCataAlias',
		onBeforeLoad: function (param) {
			param.ClassName = 'CT.IPMR.FPS.ICDCatSrv';
			param.QueryName = 'QryICDDetailCata';
			param.aICDTypeCode = $("#gridICDVer").datagrid('getSelected').ICDTypeCode;
			param.ResultSetType = 'array';
		}
	});
	$('#icdDxEdit').css('display','block');
	var selectICDVerCode = $("#gridICDVer").datagrid('getSelected').Code;
	var selectICDVerDesc = $("#gridICDVer").datagrid('getSelected').Desc;
	var selectICDVerID = $("#gridICDVer").datagrid('getSelected').ID;
	if (globalObj.m_icdtype=='D') {
		$('#DetailCatatr').css('display','none');
		$('#OperTypetr').css('display','none');
		$('#OperLeveltr').css('display','none');
		$('#IsOperLevelFourtr').css('display','none');
		$('#IsOperMiniInvatr').css('display','none');
		$('#InPairCodetr').css('display','table-row');
		$('#DrgComplicationtr').css('display','table-row');
	}
	if (globalObj.m_icdtype=='O') {
		$('#InPairCodetr').css('display','none');
		$('#DrgComplicationtr').css('display','none');
		$('#DetailCatatr').css('display','table-row');
		$('#OperTypetr').css('display','table-row');
		$('#OperLeveltr').css('display','table-row');
		$('#IsOperLevelFourtr').css('display','table-row');
		$('#IsOperMiniInvatr').css('display','table-row');
	}
	var _title = "修改ICD",_icon="icon-w-edit"
	if (option == "add") {
		_title = "添加ICD",_icon="icon-w-add";
		$("#txtICDDxID").val('');
		$("#txtICDDxCode").val('');
		$("#txtICDDxDesc").val('');
		$("#txtICDDxVDesc").val(selectICDVerDesc);
		$("#txtICDDxICD10").val('');
		$("#txtICDDxInPairCode").val('');
		$("#txtICDDxMCode").val('');
		$('#txtICDActDate').datebox('setValue','');
		$('#txtICDEndDate').datebox('setValue','');
		$("#checkICDDxIsActive").checkbox('setValue',false);
		$("#txtICDDxResume").val('');
		$("#cboICDDxOperType").combobox('setValue','');
		$("#cboICDDxOperLevel").combobox('setValue','');
		$("#MRCDr").val("");
		$("#ORCDr").val("");
		$("#cboICDCat").combobox('setValue','');
		$("#cboICDCatSub").combobox('setValue','');
		//$('#txtICDDxCode').attr("disabled", false);
		//$('#txtICDDxICD10').attr("disabled", false);
		$("#cboDetailCata").combobox('setValue','');
		$("#cboIsGroupDRG").combobox('setValue','');
		$("#cboDrgComplication").combobox('setValue','');
		$("#cboIsMedInsuGray").combobox('setValue','');
	} else {
		$("#txtICDDxID").val(selected.ID);
		$("#txtICDDxCode").val(selected.Code);
		$("#txtICDDxDesc").val(selected.Desc);
		$("#txtICDDxVDesc").val(selected.VerDesc);
		$("#txtICDDxICD10").val(selected.ICD10);
		$("#txtICDDxInPairCode").val(selected.InPairCode);
		$("#txtICDDxMCode").val(selected.MCode);
		$('#txtICDActDate').datebox('setValue',selected.ActDate);
		$('#txtICDEndDate').datebox('setValue',selected.EndDate);
		$("#checkICDDxIsActive").checkbox('setValue',selected.IsActive == "Y" ? true : false);
		$("#txtICDDxResume").val(selected.Resume);
		$("#cboICDDxOperType").combobox('setValue',selected.OperTypeID);
		$("#cboICDDxOperLevel").combobox('setValue',selected.OperLevelID);
		$("#MRCDr").val(selected.MRCDr);
		$("#ORCDr").val(selected.ORCDr);
		$("#cboICDCat").combobox('setValue',selected.CatID);
		$("#cboICDCatSub").combobox('setValue',selected.CatSubID);
		//$('#txtICDDxCode').attr("disabled", true);
		//$('#txtICDDxICD10').attr("disabled", true);
		$("#cboDetailCata").combobox('setValue',selected.DetailCataID);
		$("#cboIsGroupDRG").combobox('setValue',selected.IsGroupDRGID);
		$("#cboDrgComplication").combobox('setValue',selected.DrgComplicationID);
		$("#cboIsMedInsuGray").combobox('setValue',selected.IsMedInsuGrayID);
	}
	var ICDDxEditDialog = $HUI.dialog('#icdDxEdit', {
		title :  _title,
		iconCls : _icon,
		modal : true,
		minimizable : false,
		maximizable : false,
		maximizable : false,
		collapsible : false,
		buttons : [{
			text : '保存',
			iconCls :'icon-w-save',
			handler : function() {
				saveICDDx(selectICDVerID) ;
			}
		},{
			text : '关闭',
			iconCls : 'icon-w-close',
			handler : function() {
				$('#icdDxEdit').window("close");
			}	
		}]
	});
}

 /**
 * 检索icd
 * @param {aliasICD}检索条件
 * @return {void}
 */
function serchICDDx(aliasICD) {
	if (aliasICD == "") {
		//$.messager.popover({msg: '请输入别名...',type:'alert'});
		//return false;
	}
	var icdVer = $("#gridICDVer").datagrid('getSelected').ID;
	$("#gridICDDx").datagrid("reload", {
		ClassName : "CT.IPMR.FPS.ICDDxSrv",
		QueryName : "QryICDDic",
		aVerID :icdVer,
		aAlias :aliasICD
	});
	return ;
}

 /**
 * 保存icd
 * @param {selectICDVerID}版本id
 * @return {void}
 */
function saveICDDx(selectICDVerID) {
	var ID = $('#txtICDDxID').val();
	var Code = $("#txtICDDxCode").val();
	var Desc = $("#txtICDDxDesc").val();
	var VerID = $("#gridICDVer").datagrid('getSelected').ID;
	var ICD10 = $("#txtICDDxICD10").val();
	var InPairCode = $("#txtICDDxInPairCode").val();
	var MCode = ''; //$("#txtICDDxMCode").val();
	var OperTypeID = $("#cboICDDxOperType").combobox('getValue');
	var MRCID = $("#MRCDr").val();
	var ORCID = $("#ORCDr").val();
	var ActDate = $('#txtICDActDate').datebox('getValue');
	var EndDate = $('#txtICDEndDate').datebox('getValue');
	var IsActive = $("#checkICDDxIsActive").checkbox('getValue') == true ? 1 : 0 ;
	var Resume = $("#txtICDDxResume").val();
	var CatID = $("#cboICDCat").combobox('getValue');
	var CatSubID  	= $("#cboICDCatSub").combobox('getValue');
	var OperLevelID = $("#cboICDDxOperLevel").combobox('getValue');
	var DetailCataID= $("#cboDetailCata").combobox('getValue');
	var IsGroupDRGID= $("#cboIsGroupDRG").combobox('getValue');
	var DrgComplicationID= $("#cboDrgComplication").combobox('getValue');
	var IsMedInsuGrayID= $("#cboIsMedInsuGray").combobox('getValue');
	
	if (Code == '') {
		$.messager.popover({msg: '请填写代码！',type:'alert',timeout: 1000});
		return false;
	}
	if (Desc == '') {
		$.messager.popover({msg: '请填写名称！',type:'alert',timeout: 1000});
		return false;
	}
	if (ICD10 == '' ) {
		$.messager.popover({msg: '请填写主码！',type:'alert',timeout: 1000});
		return false;
	}
	if (ActDate == '' ) {
		$.messager.popover({msg: '请填写启用日期！',type:'alert',timeout: 1000});
		return false;
	}
	var inputStr = ID;
	inputStr += '^' + Code;
	inputStr += '^' + Desc;
	inputStr += '^' + VerID;
	inputStr += '^' + ICD10;
	inputStr += '^' + InPairCode;
	inputStr += '^' + MCode;
	inputStr += '^' + OperTypeID;
	inputStr += '^' + MRCID;
	inputStr += '^' + ORCID;
	inputStr += '^' + ActDate;
	inputStr += '^' + EndDate;
	inputStr += '^' + IsActive;
	inputStr += '^' + Resume;
	inputStr += '^' + CatID;
	inputStr += '^' + CatSubID;
	inputStr += '^' + OperLevelID;
	inputStr += '^' + DetailCataID;
	inputStr += '^' + IsGroupDRGID;
	inputStr += '^' + DrgComplicationID;
	inputStr += '^' + IsMedInsuGrayID;
	
	var LogInfo = ServerObj.IpAdress;
	LogInfo += '^' + Logon.UserID;
	LogInfo += '^' + Resume;
	var flg = $m({
		ClassName:"CT.IPMR.FPS.ICDDxSrv",
		MethodName:"SaveICD",
		aInputStr:inputStr,
		aPYAlias:'',
		aLogInfo:LogInfo,
		aSeparate:"^"
	},false);
	if (parseInt(flg) <= 0) {
		if (parseInt(flg) == -100){
			$.messager.alert("提示", "编码名称重复!", 'info');
		}else if (parseInt(flg) == -200){
			$.messager.alert("错误", "别名保存失败!", 'error');
		}else if (parseInt(flg) == -300){
			$.messager.alert("错误", "日志保存失败!", 'error');
		}else{
			$.messager.alert("错误", "保存失败!", 'error');
		}
		return;
	}
	$('#icdDxEdit').window("close");
	$("#gridICDDx").datagrid("reload");
	return ;
}


 /**
 * NUMS: D003
 * CTOR: LIYI
 * DESC: 别名维护
 * DATE: 2022-07-13
 * NOTE: 
 * TABLE: 
 */
function editICDAlias(icdDxRowID) {
	var selectAliasRowIndex = '';
	var icdAliasColumns = [[
		{field: 'ID', title: 'ID', hidden:true },
		{field: 'ICDDxAlias', title: '别名', width: 250, align: 'left'}
	]];
	var gridICDDxAlias = $HUI.datagrid("#gridICDDxAlias", {
		fit: true,
		headerCls:'panel-header-gray',
		iconCls:'icon-write-order',
		pagination: false,
		rownumbers: true,
		singleSelect: true,
		autoRowHeight: false,
		loadMsg:'数据加载中...',
		pageSize: 100,
		fitColumns:true,
	    url:$URL,
	    queryParams : {
		    ClassName : "CT.IPMR.FPS.ICDDxSrv",
			QueryName : "QryICDDxAlias",
			aICDDxID : icdDxRowID
	    },
	    columns : icdAliasColumns ,
	    onClickRow:function(rowIndex,rowData){
	    	if (selectAliasRowIndex!==rowIndex) {
	    		$("#txtAlias").val(rowData.ICDDxAlias);
				$("#txtAliasID").val(rowData.ID);
				$("#txtAliasICDVerID").val(rowData.ICDVer);
				selectAliasRowIndex = rowIndex;
	    	}else{
	    		$("#txtAlias").val('');
				$("#txtAliasID").val('');
				$("#txtAliasICDVerID").val('');
				$('#gridICDDxAlias').datagrid('unselectAll');
				selectAliasRowIndex = '';
	    	}
		}
	});
	var ICDDxAliasDialog = $('#ICDDxAliasDialog').dialog({
	    title: '别名维护',
		iconCls: 'icon-w-new',
	    width: 400,
	    height: 500,
	    minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
	    closed: false,
	    cache: false,
	    modal: true,
	    buttons:[{
			text:'保存',
				iconCls:'icon-w-save',
				handler:function(){
					saveICDDxAlias();
				}
		},{text:'删除',
				iconCls:'icon-w-cancel',
				handler:function(){
					delICDDxAlias();
				}
		}],
		onClose:function(){
			$("#txtAliasID").val('');
			$("#txtAlias").val('');
			$("#txtAliasICDVerID").val('');
		}
	});
    return ICDDxAliasDialog;
}

function saveICDDxAlias() {
	var icdDxID = $("#gridICDDx").datagrid('getSelected').ID;
	var childSubID = $("#txtAliasID").val();
	var childID	= childSubID.indexOf("||")>0?childSubID.split("||")[1]:'';
	var alias = $("#txtAlias").val();
	var icdVerID = $("#txtAliasICDVerID").val();
	var icdVerID = icdVerID==''?$("#gridICDVer").datagrid('getSelected').ID:icdVerID;
	var aInputStr = icdDxID + "^" + childID + "^" + icdVerID + "^" + alias;
	if (alias=='') {
		$.messager.popover({msg: '别名不允许为空！',type:'alert',timeout: 1000});
		return;
	}
	
	var flg = $m({
		ClassName : "CT.IPMR.FP.ICDAlias",
		MethodName : "Update",
		aInputStr : aInputStr,
		aSeparate : '^'
	},false);
	if (parseInt(flg) <= 0) {
		$.messager.alert("错误", "保存失败!", 'error');
		return;
	} else {
		$("#txtAliasID").val('');
		$("#txtAlias").val('');
		$("#txtAliasICDVerID").val('');
		$("#gridICDDxAlias").datagrid("reload");
	}
}

function delICDDxAlias() {
	var SelectedRow =$('#gridICDDxAlias').datagrid('getSelected');
	if (SelectedRow==null) {
		$.messager.popover({msg: '请选择要删除的别名！',type:'alert',timeout: 1000});
		return;
	}
	var flg = $m({
		ClassName : "CT.IPMR.FP.ICDAlias",
		MethodName : "DeleteById",
		Id : SelectedRow.ID
	},false);

	if (parseInt(flg) <= 0) {
		$.messager.alert("错误", "删除失败!", 'error');
		return;
	} else {
		$("#txtAliasID").val('');
		$("#txtAlias").val('');
		$("#txtAliasICDVerID").val('');
		$("#gridICDDxAlias").datagrid("reload");
	}
}

 /**
 * NUMS: D004
 * CTOR: LIYI
 * DESC: 导入模块
 * DATE: 2022-07-13
 * NOTE: 
 * TABLE: 
 */

 /**
 * 初始化excel数据
 * @param {data}
 * @return {grid}
 */
function InitgridTmpICDDx() {
	var columnObj = {
		D:[[
			{field:'代码',title:'代码',checknull:true,align:'left'},
			{field:'主码',title:'主码',checknull:true,align:'left'},
			{field:'副码',title:'副码',align:'left'},
			{field:'名称',title:'名称',checknull:true,align:'left'},
			{field:'别名',title:'别名',align:'left'},
			{field:'是否入组',title:'是否入组',align:'left'},
			{field:'合并症与并发症',title:'合并症与并发症',align:'left'},
			{field:'启用日期',title:'启用日期',checknull:true,align:'left'},
			{field:'停用日期',title:'停用日期',align:'left'},
			{field:'是否有效',title:'是否有效',checknull:true,align:'left'},
			{field:'备注',title:'备注',align:'left'},
			{field:'是否灰码',title:'是否灰码',align:'left'}
		]],
		O:[[
			{field:'代码',title:'代码',checknull:true,align:'left'},
			{field:'主码',title:'主码',checknull:true,align:'left'},
			{field:'名称',title:'名称',checknull:true,align:'left'},
			{field:'别名',title:'别名',align:'left'},
			{field:'是否入组',title:'是否入组',align:'left'},
			{field:'手术类型',title:'手术类型',checknull:true,align:'left'},
			{field:'手术级别',title:'手术级别',checknull:true,align:'left'},
			{field:'启用日期',title:'启用日期',checknull:true,align:'left'},
			{field:'停用日期',title:'停用日期',align:'left'},
			{field:'是否有效',title:'是否有效',checknull:true,align:'left'},
			{field:'备注',title:'备注',align:'left'},
			{field:'是否灰码',title:'是否灰码',align:'left'}
		]]
	}
  	var gridTmpICDDx = $HUI.datagrid("#gridTmpICDDx", {
		fit: true,
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		rownumbers : true, 
		singleSelect : true,
		pagination : true, 
		autoRowHeight : false,
		pageSize: 100,
		fitColumns : true,
		data:globalObj.m_excelData.total == 0 ? [] : globalObj.m_excelData.rows.slice(0, 100), 
		pageList:[100,200,300,400,500],
	    columns : columnObj[globalObj.m_icdtype]
	});
	var pager = $("#gridTmpICDDx").datagrid("getPager");
	$(pager).pagination({
	    pageNumber: 1, //初始化的页码编号,默认1
	    pageSize: 100, //每页的数据条数，默认10
	    pageList:[100,200,300,400,500], //页面数据条数选择清单
	    total: globalObj.m_excelData.total,
	    onSelectPage: function (pageNo, pageSize) {
			var start = (pageNo - 1) * pageSize;
			var end = start + pageSize;
			$("#gridTmpICDDx").datagrid("loadData", globalObj.m_excelData.rows.slice(start, end));
			pager.pagination('refresh', {
		    	total: globalObj.m_excelData.total,
		    	pageNumber: pageNo
			});
	    }
	});
	return gridTmpICDDx;
}

//是否为空("",null,undefined)
function isEmpty(strVal) {
	if (strVal == '' || strVal == null || strVal == undefined) {
		return true;
	} else {
		return false;
	}
}
// excel数据转换json
function to_json(workbook) {
	//取 第一个sheet 数据
    var jsonData={};
	var result = XLSX.utils.sheet_to_json(workbook.Sheets[workbook.SheetNames[0]]);
	jsonData.rows=result;
	jsonData.total=result.length
	return jsonData;
};

/**
 * 控制按钮是否可用
 * @param {} Obj: 比如 {'#SearchBT':true, '#SaveBT':false}
 */
function ChangeButtonEnable(Obj) {
	for(var Btn in Obj){
		var IsEnable = Obj[Btn] == true ? 'enable' : 'disable';
		$(Btn).linkbutton(IsEnable);
		if(isEmpty(ButtonCountObj[Btn])){
			ButtonCountObj[Btn]=1;
		}else{
			ButtonCountObj[Btn]=ButtonCountObj[Btn]+1;
		}
	}
}

function ClearMain(){
	globalObj.m_excelData={total:0,rows:{}};
	$("#gridTmpICDDx").datagrid("loadData",globalObj.m_excelData);
	$('#File').filebox('clear');
	$('#Msg').panel({'content':" "});
	ChangeButtonEnable({'#CheckData':false,'#ImportData':false,'#ClearData':false,'#ReadExcel':true});
}

 /**
 * NUMS: D005
 * CTOR: LIYI
 * DESC: 日志模块
 * DATE: 2022-07-13
 * NOTE: 
 * TABLE: 
 */

/**
 * 打开日志弹框
 * @param {id} icddx表ID
 */
function showlogDiag(id) {
	var columns = [[
		{field:'OperTypeDesc',title:'维护类型',width:100,align:'left'},
		{field:'UpdateDate',title:'日期',width:120,align:'left'},
		{field:'UpdateTime',title:'时间',width:100,align:'left'},
		{field:'UpdateUser',title:'操作人',width:120,align:'left'},
		{field:'IpAddress',title:'操作IP',width:120,align:'left'},
		{field:'Resume',title:'备注',width:150,align:'left'},
		{field:'d',title:'变动明细',width:100,align:'left',
			formatter:function(value,row,index) {
            	var ID = row.ID;
               	return '<a href="#" class="grid-td-text-gray" onclick = showDetail(' + ID + ')>' + '变动明细' + '</a>';            
            }
        }
    ]];
  	var gridIcdLog = $HUI.datagrid("#gridIcdLog", {
		fit: true,
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		rownumbers : true, 
		singleSelect : true,
		autoRowHeight : false,
		loadMsg : '数据加载中...',
		fitColumns : true,
		url : $URL,
	    queryParams : {
		    ClassName : "CT.IPMR.FPS.ICDDxLogSrv",
			QueryName : "QryICDLog",
			aICDDxID:id,
			aDateFrom:'',
			aDateTo:'',
			aVerID:'',
			aOperType:'',
			rows : 10000
	    },
	    columns : columns
	});

	var DiagIcdLog = $HUI.dialog('#DiagIcdLog', {
		title :  '维护日志',
		iconCls : 'icon-w-edit',
		width: 800,
   		height: 560,
		modal : true,
		minimizable : false,
		maximizable : false,
		maximizable : false,
		collapsible : false,
		onClose:function(){
			
		}
	});
}
/**
 * 打开变动明细弹框
 * @param {id} 日志id
 */
function showDetail(id) {
	var columns = [[
		{field: 'Property', title: '属性', width: 50, align: 'left'},
		{field: 'oldValue', title: '修改前', width: 80, align: 'left'},
		{field: 'newValue', title: '修改后', width: 80, align: 'left',
			styler: function(value,row,index){
				var changeflg	= row.changeflg;
				if (changeflg==1){
					return 'background-color:pink;';
				}
			}
		}
	]];
	var gridLogDetail = $HUI.datagrid("#gridLogDetail", {
		fit: true,
		headerCls:'panel-header-gray',
		iconCls:'icon-write-order',
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 100,
		fitColumns:true,
	    url:$URL,
	    queryParams : {
		    ClassName : "CT.IPMR.FPS.ICDDxLogSrv",
			QueryName : "QryICDLogDetail",
			aLogID : id
	    },
	    columns : columns
	});
	var ICDLogDetailDialog = $('#ICDLogDetailDialog').dialog({
	    title: '变动明细',
		iconCls: 'icon-w-new',
	    width: 800,
	    height: 560,
	    minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
	    closed: false,
	    cache: false,
	    modal: true
	});
    return ICDLogDetailDialog;
}