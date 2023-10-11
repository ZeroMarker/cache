/**
 * icdmapping ICD编码对照
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
	ICDType:'',
	m_excelData:{total:0,rows:{}}
}
var ButtonCountObj={};
$(function() {
	Init();
	InitEvent();
})

function Init() {
	Common_ComboToDic("cboICDType","ICDType",1,'');
	Common_ComboToICDVerEdition("cboFICDVer","","");			// 版本
	Common_ComboToICDVerEdition("cboTICDVer","","");			// 对照版本
	$('#File').filebox({
		buttonText: '选择',
		prompt:'选择要导入的Excel',
		accept:'application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
		width: 180
	});
	InitGridICDMapping();
}

function InitEvent() {
	$('#cboFICDVer').combobox({
	    onChange:function(rows){
	    	var FromVerID = $("#cboFICDVer").combobox('getValue');
			var ToVerID = $("#cboTICDVer").combobox('getValue');
			// 获取基础平台ICD对照同步到病案标志
			$m({
				ClassName:"CT.IPMR.FPS.ICDMappingSrv",
				MethodName:"getICDMapSyncFlg",
				aVerID:FromVerID,
				aToVerID:ToVerID
			},function(txtData){
				if (txtData=='Y') {		// 开启同步后禁用维护功能
					$('#import').linkbutton('disable');
					$('#c-add').linkbutton('disable');
					$('#c-edit').linkbutton('disable');
					$('#c-delete').linkbutton('disable');
				}else{
					$('#import').linkbutton('enable');
					$('#c-add').linkbutton('enable');
					$('#c-edit').linkbutton('enable');
					$('#c-delete').linkbutton('enable');
				}
			});
	    }
	})
	$('#cboTICDVer').combobox({
	    onChange:function(rows){
	    	var FromVerID = $("#cboFICDVer").combobox('getValue');
			var ToVerID = $("#cboTICDVer").combobox('getValue');
			// 获取基础平台ICD对照同步到病案标志
			$m({
				ClassName:"CT.IPMR.FPS.ICDMappingSrv",
				MethodName:"getICDMapSyncFlg",
				aVerID:FromVerID,
				aToVerID:ToVerID
			},function(txtData){
				if (txtData=='Y') {		// 开启同步后禁用维护功能
					$('#import').linkbutton('disable');
					$('#c-add').linkbutton('disable');
					$('#c-edit').linkbutton('disable');
					$('#c-delete').linkbutton('disable');
				}else{
					$('#import').linkbutton('enable');
					$('#c-add').linkbutton('enable');
					$('#c-edit').linkbutton('enable');
					$('#c-delete').linkbutton('enable');
				}
			});
	    }
	})
	//添加、删除、修改、查询
	$('#c-add').click(function(){EditICDMapping('add');});
	$('#c-edit').click(function(){EditICDMapping('edit');});
	$('#c-delete').click(function(){DeleteICDMapping();});
	$("#c-search").click(function(){ ReloadICDMapping();});
	$('#downTemp').click(function() {
		window.open("../scripts/ipmr/template/编码对照Excel模板.rar", "_blank");
	});

	// 导入弹框
	$('#import').click(function() {
		var FromVerID = $("#cboFICDVer").combobox('getValue');
		var ToVerID = $("#cboTICDVer").combobox('getValue');
		if (FromVerID==''){
			$.messager.popover({msg: '请选择版本！',type: 'alert',timeout: 1000});
			return false;
		}
		if (ToVerID==''){
			$.messager.popover({msg: '请选择对照版本！',type: 'alert',timeout: 1000});
			return false;
		}
		var title = '导入：'+$("#cboFICDVer").combobox('getText')+' 对照 '+$("#cboTICDVer").combobox('getText')
		ChangeButtonEnable({'#CheckData':false,'#ImportData':false,'#ClearData':false,'#ReadExcel':true});
		InitgridTmpMap();
		var DiagImport = $HUI.dialog('#DiagImport', {
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

	// 导出
	$('#export').click(function() {
		$('#gridICDMapping').datagrid('exportByJsxlsx', {
			filename: '导出',
			extension:'xlsx'
		});
	});

	//	读取excel
	$('#ReadExcel').click(function() {
		var wb;   //wookbook
		$("#gridTmpMap").datagrid("loadData",{total:0,rows:{}});
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
       		InitgridTmpMap();
       		ChangeButtonEnable({'#CheckData':true,'#ImportData':false,'#ClearData':true,'#ReadExcel':true});
       		readfinish = 1;
        }
    	reader.readAsBinaryString(file);
	});
	
	// 校验数据
	$('#CheckData').click(function() {
		var FromVerID = $("#cboFICDVer").combobox('getValue');
		var ToVerID = $("#cboTICDVer").combobox('getValue');
		
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
				ClassName: 'CT.IPMR.FPS.ICDMappingSrv',
				MethodName: 'TestDataInput',
				Rows: JSON.stringify(Rows.slice(st,ed)),
				JIndex:jIndex,
				FVerID:FromVerID,
				TVerID:ToVerID,
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
						$.messager.popover({msg: '数据校验不通过，右侧查看原因...',type:'alert'});
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
		var FromVerID = $("#cboFICDVer").combobox('getValue');
		var ToVerID = $("#cboTICDVer").combobox('getValue');
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
				ClassName: 'CT.IPMR.FPS.ICDMappingSrv',
				MethodName: 'DataInput',
				Rows: JSON.stringify(Rows.slice(st,ed)),
				JIndex:jIndex,
				FVerID:FromVerID,
				TVerID:ToVerID,
				Start:st,
				EndFlag:EndFlag,
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
						$.messager.popover({msg: '存在导入失败的数据，右侧查看原因！',type:'alert'});
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
	});
	// 清屏
	$('#ClearData').click(function() {
		globalObj.m_excelData={total:0,rows:{}};
		$("#gridTmpMap").datagrid("loadData",globalObj.m_excelData);
		$('#File').filebox('clear');
		$('#Msg').panel({'content':" "});
		ChangeButtonEnable({'#CheckData':false,'#ImportData':false,'#ClearData':false,'#ReadExcel':true});
	});
	

	// ICD类型下拉框内容变化、加载数据事件
	$('#cboICDType').combobox({
	    onChange:function(newValue,oldValue){
		    var ICDTypeID = $("#cboICDType").combobox('getValue');
			Common_ComboToICDVerEdition("cboFICDVer","",ICDTypeID);			// 版本
			Common_ComboToICDVerEdition("cboTICDVer","",ICDTypeID);			// 对照版本
	    },
		onLoadSuccess:function(data){   //初始加载赋值
			if (data.length>0){
				$(this).combobox('select',data[0]['ID']);
				globalObj.ICDType =data[0]['Code'];
				Common_ComboGridToICD("cboFICD",'','','',1,data[0]['Code']);
			}
		},onSelect:function(record) {
			globalObj.ICDType =record.Code;
			Common_ComboGridToICD("cboFICD",'','','',1,globalObj.ICDType);
		}
	});
	
	// 版本内容变化事件
	$('#cboFICDVer').combobox({
	    onChange:function(newValue,oldValue){
		    var FICDVer = $("#cboFICDVer").combobox('getValue');
		    if (FICDVer!=""){
				Common_ComboGridToICD("cboFICD",'',FICDVer,'',1,globalObj.ICDType);
		    }
	    }
	});
}

 /**
 * NUMS: D001
 * CTOR: zhouyang
 * DESC: ICD编码对照加载模块
 * DATE: 2021-09-17
 * NOTE: 包括方法：InitGridICDMapping ，ReloadICDMapping
 * TABLE: 
 */
 
// 初始化编目对照表
function InitGridICDMapping(){
	var columns = [[
		{field:'FromICD',title:'编码',width:120,align:'left'},
		{field:'FromICDDesc',title:'名称',width:200,align:'left'},
		{field:'ToICD',title:'对照编码',width:120,align:'left'},
		{field:'ToICDDesc',title:'对照名称',width:200,align:'left'},
		{field:'IsActive',title:'是否有效',width:80,align:'left',
			formatter:function(value,row,index) {
            	if (value=='Y') {
            		return '是';
            	}else{
            		return '否';
            	}         
            }
       	},
		{field:'Resume',title:'备注',width:120,align:'left'}
    ]];

	var gridICDMapping =$HUI.datagrid("#gridICDMapping",{
		fit: true,
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true,
		rownumbers: true,
		singleSelect: true,
		autoRowHeight: false,
		loadMsg:'数据加载中...',
		pageSize:50,
		pageList:[20,50,100,200,300],
		fitColumns:true,
		fixRowNumber:true,
	    url:$URL,
	    queryParams:{
		    ClassName:"CT.IPMR.FPS.ICDMappingSrv",
			QueryName:"QryMapICD",
			aFromVerID:"",
			aToVerID:"",
			aICD:""
	    },
	    columns :columns,
		onClickRow:function(rowIndex,rowData){
		}
	});
	return gridICDMapping;
}

// 重载ICDMapping表
function ReloadICDMapping(){
	var FromVerID 	= $("#cboFICDVer").combobox('getValue');
	var ToVerID 	= $("#cboTICDVer").combobox('getValue');
	var gridICD 	= $('#cboFICD').combogrid('grid');
	var ICDSelect	= gridICD.datagrid('getSelected')
	if (FromVerID==''){
		$.messager.popover({msg: '请选择版本！',type:'alert',timeout: 1000});
		return false;
	}
	if (ToVerID==''){
		$.messager.popover({msg: '请选择对照版本！',type:'alert',timeout: 1000});
		return false;
	}
	$('#gridICDMapping').datagrid('reload',  {
		ClassName:"CT.IPMR.FPS.ICDMappingSrv",
		QueryName:"QryMapICD",
		aFromVerID:FromVerID,
		aToVerID:ToVerID,
		aICD:ICDSelect==null?'':ICDSelect.ICD10+ICDSelect.InPairCode,
		aType:$("#cboIsMap").combobox('getValue')
	});
}

 /**
 * NUMS: D001
 * CTOR: zhouyang
 * DESC: ICD编码对照操作模块
 * DATE: 2021-09-17
 * NOTE: 包括方法：EditICDMapping ，DeleteICDMapping ，SaveICDMapping
 * TABLE: 
 */
// 新增、修改ICDMapping
function EditICDMapping(op){
	var selected = $("#gridICDMapping").datagrid('getSelected');
	if (op == "edit"){
		if (!selected){
			$.messager.popover({msg: '请选择一条记录！',type:'alert',timeout: 1000});
			return false;
		}
		$('#txtFromVer').val(selected.FromVerID);
		$('#txtToVer').val(selected.ToVerID);
	}else{
		var FICDVer = $("#cboFICDVer").combobox('getValue');
		var TICDVer = $("#cboTICDVer").combobox('getValue');
		if (FICDVer==''){
			$.messager.popover({msg: '请选择版本！',type:'alert',timeout: 1000});
			return false;
		}
		if (TICDVer==''){
			$.messager.popover({msg: '请选择对照版本！',type:'alert',timeout: 1000});
			return false;
		}
		
		if (FICDVer==TICDVer){
			$.messager.popover({msg: '版本与对照版本相同！',type:'alert',timeout: 1000});
			return false;
		}
		$('#txtFromVer').val(FICDVer);
		$('#txtToVer').val(TICDVer);
	}
	Common_ComboGridToICD("cboFromICD",'',$('#txtFromVer').val(),'',1,globalObj.ICDType);
	Common_ComboGridToICD("cboToICD",'',$('#txtToVer').val(),'',1,globalObj.ICDType);
	$('#cboFromICD').combogrid({
		onSelect:function(rowIndex, rowData){
			$('#txtFromICD').val(rowData.ICD10);
		}
	});
	$('#cboToICD').combogrid({
		onSelect:function(rowIndex, rowData){
			$('#txtToICD').val(rowData.ICD10);
		}
	});
	$('#ICDMappingDialog').css('display','block');
	$('#txtFromICD').attr("disabled", true);
	$('#txtToICD').attr("disabled", true);
	var _title = "修改对照",_icon="icon-w-edit"
	if (op == "add") {
		_title = "添加对照",_icon="icon-w-add";
		$("#txtId").val('');
		$("#txtFromICD").val('');
		$("#txtToICD").val('');
		$('#cboFromICD').combogrid('clear');
		$('#cboToICD').combogrid('clear');
		$("#checkIsActive").checkbox('setValue',false);
		$("#txtResume").val('');
	} else {
		$("#txtId").val(selected.ID);
		$("#txtFromICD").val(selected.FromICD);
		$("#txtToICD").val(selected.ToICD);
		Common_SetComboGridToICDValue('#cboFromICD',selected.FromICDDesc,selected.FromICDID,selected.FromICDDesc)
		Common_SetComboGridToICDValue('#cboToICD',selected.ToICDDesc,selected.ToICDID,selected.ToICDDesc)
		$("#checkIsActive").checkbox('setValue',selected.IsActive == "Y" ? true : false);
		$("#txtResume").val(selected.Resume);
	}

	var ICDMappingDialog = $HUI.dialog('#ICDMappingDialog', {
		title: _title,
		iconCls: _icon,
		modal: true,
		minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
		buttons:[{
			text:'保存',
				iconCls:'icon-w-save',
				handler:function(){
					SaveICDMapping();
				}
		},{
		text:'关闭',
		iconCls:'icon-w-close',
		handler:function(){
				$('#ICDMappingDialog').window("close");
			}	
		}]
	});
}

// 删除ICDMapping
function DeleteICDMapping(){
	var selected = $("#gridICDMapping").datagrid('getSelected');
	if (!selected) {
		$.messager.popover({msg: '请选择一条记录！',type:'alert',timeout: 1000});
		return false;
	}
	$.messager.confirm('确认', '确认删除该条数据?', function(r){
    	if (r){
    		var flg = $m({
				ClassName:"CT.IPMR.FP.ICDMapping",
				MethodName:"DeleteById",
				aId:selected.ID
			},false);
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误", "删除失败!", 'error');
				return;
			}
			$("#gridICDMapping").datagrid("reload");
    	}
    });
 }

// 保存ICDMapping
function SaveICDMapping(){
	var ID				= $("#txtId").val();
	var FICDVer 		= $("#cboFICDVer").combobox('getValue');
	var TICDVer 		= $("#cboTICDVer").combobox('getValue');
	
	// 编码
	var gridFromICD 	= $('#cboFromICD').combogrid('grid');
	var FromICDSelect	= gridFromICD.datagrid('getSelected')
	var FromICD			= FromICDSelect==null?'':(FromICDSelect.ICD10+FromICDSelect.InPairCode)
	var FromICDID		= FromICDSelect==null?'':FromICDSelect.ID;
	// 对照编码
	var gridToICD 		= $('#cboToICD').combogrid('grid');
	var ToICDSelect		= gridToICD.datagrid('getSelected')
	var ToICD			= ToICDSelect==null?'':(ToICDSelect.ICD10+ToICDSelect.InPairCode)
	var ToICDID			= ToICDSelect==null?'':ToICDSelect.ID;
	if (FromICDID=='') {
		$.messager.popover({msg: '请选名称！',type:'alert',timeout: 1000});
		return false;
	}
	if (ToICDID=='') {
		$.messager.popover({msg: '请选对照名称！',type:'alert',timeout: 1000});
		return false;
	}
	var IsActive = $("#checkIsActive").checkbox('getValue') == true ? 1 : 0 ;
	var Resume = $("#txtResume").val();
	var inputStr = ID;
	inputStr += '^' + FICDVer;
	inputStr += '^' + FromICD;
	inputStr += '^' + TICDVer;
	inputStr += '^' + ToICD;
	inputStr += '^' + FromICDID;
	inputStr += '^' + ToICDID;
	inputStr += '^' + IsActive;
	inputStr += '^' + Resume;
	var LogInfo = ServerObj.IpAdress;
	LogInfo += '^' + Logon.UserID;
	LogInfo += '^' + Resume;
	var flg = $m({
		ClassName:"CT.IPMR.FPS.ICDMappingSrv",
		MethodName:"SaveMap",
		MapInfo:inputStr,
		LogInfo:LogInfo,
		aSeparate:"^"
	},false);
	if (parseInt(flg) <= 0) {
		if (parseInt(flg)==-100){
			$.messager.alert("提示", "代码重复!", 'info');
		}else{
			$.messager.alert("错误", "保存失败!", 'error');
		}
		return;
	}
	$('#ICDMappingDialog').window("close");
	ReloadICDMapping();
}

/**
 * NUMS: D002
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
function InitgridTmpMap() {
	var columns = [[
		{field:'编码',title:'编码',align:'left'},
		{field:'名称',title:'名称',align:'left'},
		{field:'对照编码',title:'对照编码',align:'left'},
		{field:'对照名称',title:'对照名称',align:'left'},
		{field:'是否有效',title:'是否有效',align:'left'},
		{field:'备注',title:'备注',align:'left'}
	]]
  	var gridTmpMap = $HUI.datagrid("#gridTmpMap", {
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
	    columns : columns
	});
	var pager = $("#gridTmpMap").datagrid("getPager");
	$(pager).pagination({
	    pageNumber: 1, //初始化的页码编号,默认1
	    pageSize: 100, //每页的数据条数，默认10
	    pageList:[100,200,300,400,500], //页面数据条数选择清单
	    total: globalObj.m_excelData.total,
	    onSelectPage: function (pageNo, pageSize) {
			var start = (pageNo - 1) * pageSize;
			var end = start + pageSize;
			$("#gridTmpMap").datagrid("loadData", globalObj.m_excelData.rows.slice(start, end));
			pager.pagination('refresh', {
		    	total: globalObj.m_excelData.total,
		    	pageNumber: pageNo
			});
	    }
	});
	return gridTmpMap;
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
	$("#gridTmpMap").datagrid("loadData",globalObj.m_excelData);
	$('#File').filebox('clear');
	$('#Msg').panel({'content':" "});
	ChangeButtonEnable({'#CheckData':false,'#ImportData':false,'#ClearData':false,'#ReadExcel':true});
}