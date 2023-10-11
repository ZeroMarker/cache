/**
 * workflow 工作流维护
 * 
 * Copyright (c) 2018-2019 WHui. All rights reserved.
 * 
 * CREATED BY WHui 2019-10-22
 * 
 * 注解说明
 * TABLE: CT.IPMR.BT.WorkFlow (工作流)		CT.IPMR.BT.WorkFItem (工作流操作项目)
 */

// 页面全局变量
var globalObj = {
	m_gridWorkFlow : '',
	m_WorkFlowID:'',
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
})

function Init(){
	$HUI.window('#WFItemWindow').close();		// 关闭窗口
	globalObj.m_gridWorkFlow = InitgridWorkFlow();
}

function InitEvent(){
	$('#add_btn').click(function(){editWorkFlow('add');});
	$('#edit_btn').click(function(){editWorkFlow('edit');});
	$('#del_btn').click(function(){deleteWorkFlow();});
	$('#btnSave').click(function(){saveDate(globalObj.m_WorkFlowID);});
}

 /**
 * NUMS: 001
 * CTOR: WHui
 * DESC: 工作流维护
 * DATE: 2019-10-22
 * NOTE: 包括四个个方法：InitgridWorkFlow,editWorkFlow,saveWorkFlow,deleteWorkFlow
 * TABLE: CT_IPMR_BT.WorkFlow
 */
function InitgridWorkFlow(){
	var columns = [[
		{field:'Code',title:'代码',width:300,align:'left'},
		{field:'Desc',title:'描述',width:300,align:'left'},
		{field:'ID',title:'操作项目',width:300,align:'left',
			formatter:function(value,row,index){
				if (value=="") return "";
				var WorkFlowID = row["ID"];
				var btn='<a href="#" onclick="InitWFItemWindow(\'' + WorkFlowID + '\')">编辑</a>';
				return btn;
			}
		},
		{field:'Resume',title:'备注',width:400}
	]];
	
	var gridWorkFlow = $HUI.datagrid("#gridWorkFlow",{
		fit:true,
		//title:"工作流维护",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		rownumbers: true,		//如果为true, 则显示一个行号列
		singleSelect:true,
		autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		fitColumns:true,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		url:$URL,
		queryParams:{
		    ClassName:"CT.IPMR.BTS.WorkFlowSrv",
			QueryName:"QryWorkFlow",
			rows:10000
		},
		columns :columns,
		onLoadSuccess:function(data){
			if(data){
				$('.SpecialClass').linkbutton({
					plain:true
				})
			}
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
			}
		}
	});
}

// 编辑工作流
function editWorkFlow(op){
	var selected = $("#gridWorkFlow").datagrid('getSelected');
	if (( op == "edit")&&(!selected)) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	$('#WorkFlowDialog').css('display','block');
	var _title = "修改工作流配置",_icon="icon-w-edit"
	if (op == "add") {
		_title = "添加工作流配置",_icon="icon-w-add";
		$("#txtRowId").val('');
		$("#txtCode").val('');
		$("#txtDesc").val('');
		$("#txtWFResume").val('');
	} else {
		$("#txtRowId").val(selected.ID);
		$("#txtCode").val(selected.Code);
		$("#txtDesc").val(selected.Desc);
		$("#txtWFResume").val(selected.Resume);
	}
	
	var WorkFlowDialog =$HUI.dialog('#WorkFlowDialog',{
		title:_title,
		iconCls:_icon,
		modal:true,
		minimizable:false,
		maximizable:false,
		collapsible:false,
		buttons:[{
			text:'保存',
			iconCls:'icon-w-save',
			handler:function(){
				saveWorkFlow(op);
			}
		},{
			text:'关闭',
			iconCls:'icon-w-close',
			handler:function(){
				$('#WorkFlowDialog').window("close");
			}	
		}]
	});
}

// 保存工作流内容
function saveWorkFlow(op){
	var id = $("#txtRowId").val();
	var code = $("#txtCode").val();
	var desc = $("#txtDesc").val();
	var resume = $("#txtWFResume").val();
	
	if (code == '') {
		$.messager.popover({msg: '代码不允许为空！',type: 'alert',timeout: 1000});
		return false;
	}
	if (desc == '') {
		$.messager.popover({msg: '描述不允许为空！',type: 'alert',timeout: 1000});
		return false;
	}
	
	var inputStr = id;
	inputStr += '^' + code;
	inputStr += '^' + desc;
	inputStr += '^' + resume;
	
	var flg = $m({
		ClassName:"CT.IPMR.BT.WorkFlow",
		MethodName:"Update",
		aInputStr:inputStr,
		aSeparate:"^"
	},false);
	
	if (parseInt(flg) <= 0) {
		$.messager.alert("错误", "保存失败!", 'error');
		return;
	}else{
		if (op == "add") {
			$.messager.popover({msg: '新增成功！',type:'success',timeout: 1000});
		} else {
			$.messager.popover({msg: '修改成功！',type:'success',timeout: 1000});
		}
		$('#WorkFlowDialog').window("close");
		$('#gridWorkFlow').datagrid('reload');		// 重新载入当前页面数据
	}
}

// 删除工作流
function deleteWorkFlow(op){
	var selected = $('#gridWorkFlow').datagrid('getSelected');
	if (!selected) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	$.messager.confirm('确认', '确认删除该条数据?', function(r){
    	if (r){
			var flg = $m({
				ClassName:"CT.IPMR.BT.WorkFlow",
				MethodName:"DeleteById",
				aId:selected.ID
			},false);
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误", "删除失败!", 'error');
				return;
			}else{
				$('#WorkFlowDialog').window("close");
				$('#gridWorkFlow').datagrid('reload');		// 重新载入当前页面数据
				// $.messager.alert("提示","删除成功","info")
				//$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
			}
    	}
    });
}

 /**
 * NUMS: 002
 * CTOR: WHui
 * DESC: 工作流项目维护
 * DATE: 2019-10-22
 * NOTE: 包括四个个方法：InitWFItemWindow,selectWFItem,InitgridPreItems,clearData,saveDate
 * TABLE: CT_IPMR_BT.WorkFlow
 */
function InitWFItemWindow(op){
	globalObj.m_WorkFlowID = op;
	var _title = "工作流项目配置",_icon="icon-w-edit"
	var WFItemDialog =$HUI.window('#WFItemDialog',{
		title:_title,
		iconCls:_icon,
		modal:true,
		width:1200,
		height:700,
		minimizable:false,
		maximizable:false,
		collapsible:false,
		onBeforeOpen: function(){
			//$('#WFItemDialog').window('refresh');
			InitgridPreItems("");			// 初始化前提操作,用于表格占位
			// $('#gridPreItems').datagrid('loadData', { total: 0, rows: [] });
			Common_RadioToDic("radPreStepList","WorkFlowStep",3);		// 单选框,前提步骤
			Common_RadioToDic("radPostStepList","WorkFlowStep",3);		// 单选框,操作步骤
			Common_RadioToDic("radMRCategoryList","MRCategory",2);		// 单选框,病历类型
			Common_ComboToDic("cboItemType","WorkType","1");				// 下拉框,项目类型
			Common_ComboToDic("cboSubFlow","WorkSubFlow","1");			// 下拉框,操作流程
			Common_ComboToDic("cboSysOpera","SysOperation","1");			// 下拉框,系统流程
		},
		onClose: function () {
			clearData();
		}
	});
	
	var columns = [[
		{field:'ItemDesc',title:'操作项目',width:100,align:'left',
			formatter: function (value, rec, rowIndex) {
				var ItemDesc	= rec.ItemDesc;
				var ItemIndex	= rec.ItemIndex;
				if (ItemIndex != '') {
					return ItemDesc + '(' + ItemIndex + ')';
				} else {
					return ItemDesc;
				}
			}
		},
		{field:'TypeDesc',title:'项目类型',width:80,align:'left'},
		{field:'SubFlowDesc',title:'操作流程',width:80,align:'left'},
		{field:'SysOperaDesc',title:'系统操作',width:120,align:'left'},
		{field:'PreStepDesc',title:'前提步骤',width:100,align:'left'},
		{field:'PostStepDesc',title:'当前步骤',width:100,align:'left'},
		{field:'IsActiveDesc',title:'是否有效',width:80,align:'left'},
		{field:'CheckUserDesc',title:'校验用户',width:80,align:'left'},
		{field:'BeRequestDesc',title:'是否申请',width:80,align:'left'},
		{field:'BatchOperDesc',title:'批次操作',width:80,align:'left'}
	]];
	
	var gridWFItem = $HUI.datagrid("#gridWFItem",{
		fit: true,
		rownumbers: true,		//如果为true, 则显示一个行号列
		singleSelect:true,
		autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		fitColumns:false,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		url:$URL,
		queryParams:{
		    ClassName:"CT.IPMR.BTS.WorkFlowSrv",
			QueryName:"QryWFCfgItem",
			aWFlowID:op,
			rows:10000
		},
		columns :columns,
		// frozenColumns:[[ {field:'ck',checkbox:true}]],//多选框,位置固定在最左边
		toolbar:[{
			text:'上移',
			id:'moveUp_btn',
			iconCls: 'icon-up',
			handler:function(){
				moveUp(op);
			}
		},{
			text:'下移',
			id:'moveDown_btn',
			iconCls: 'icon-down',
			handler:function(){
				moveDown(op);
			}
		}/*
		,{
			text:'保存',
			id:'save_btn',
			iconCls: 'icon-save',
			handler:function(){
				saveDate(op);	// $("#WFItemID").val()-->op (工作流WorkFlow.ID)
			}
		}*/
		],
		onLoadSuccess:function(data){
			$("#moveUp_btn").linkbutton("disable");
			$("#moveDown_btn").linkbutton("disable");
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				selectWFItem(rindex,rowData);
			}
		}
	})
}

// 根据选中行,给右侧作流项目配置赋值
function selectWFItem(rindex,rowData){
	if (rowData.ItemIndex=='') {
		$("#moveUp_btn").linkbutton("disable");
		$("#moveDown_btn").linkbutton("disable");
	} else{
		$("#moveUp_btn").linkbutton("enable");
		$("#moveDown_btn").linkbutton("enable");
	}
	
	$("#WFItemID").val(rowData.WFItemID);
	$("#txtItemDesc").val(rowData.ItemDesc);
	$("#txtItemAlias").val(rowData.ItemAlias);
	// 权限设置2,(未知原因:setValue不触发onSelect;$HUI.combobox("#cboItemType", {});会造成赋值变空)
	$HUI.combobox("#cboItemType", {
	    onSelect: function(record){
	        // debugger
			if((record.Desc).indexOf('顺序')>-1){
				$("input[name='radPreStepList']").each(function () {
					$(this).radio("enable");
				})
				$("input[name='radPostStepList']").each(function () {
					$(this).radio("enable");
				})
			}else{
				$("input[name='radPreStepList']").each(function () {
					$(this).radio('setValue',false);
					$(this).radio("disable");
				})
				$("input[name='radPostStepList']").each(function () {
					$(this).radio('setValue',false);
					$(this).radio("disable");
				})
			}
	    }
	});
	// end2
	$("#cboItemType").combobox('setValue',rowData.TypeID);			// TypeDesc
	$("#cboSubFlow").combobox('setValue',rowData.SubFlowID);		// SubFlowDesc
	$("#cboSysOpera").combobox('setValue',rowData.SysOperaID);		// SysOperaDesc
	// 权限设置1
	
	if ((rowData.TypeDesc).indexOf('顺序')>-1) {
		$("input[name='radPreStepList']").each(function () {
			$(this).radio("enable");
		})
		$("input[name='radPostStepList']").each(function () {
			$(this).radio("enable");
		})
	} else{
		$("input[name='radPreStepList']").each(function () {
			$(this).radio('setValue',false);
			$(this).radio("disable");
		})
		$("input[name='radPostStepList']").each(function () {
			$(this).radio('setValue',false);
			$(this).radio("disable");
		})
	}
	// end1
	$("input[name='radPreStepList']").each(function () {
		$(this).radio('setValue',false);
	})
	if (rowData.PreStepCode) {
		$HUI.radio('#radPreStepList'+rowData.PreStepCode).setValue(true);   // 前提步骤
	}
	
	$("input[name='radPostStepList']").each(function () {
		$(this).radio('setValue',false);
	})
	if (rowData.PostStepCode) {
		$HUI.radio('#radPostStepList'+rowData.PostStepCode).setValue(true);   // 操作步骤
	}
	
	var WFItemID = $("#WFItemID").val()
	var xWFItemID=WFItemID!=''?WFItemID:globalObj.m_WorkFlowID;
	InitgridPreItems(xWFItemID);		// 前提操作
	// $("#gridPreItems").prop("checked",true);
	$("#chkIsActive").checkbox('setValue',rowData.IsActive==1);
	$("#chkCheckUser").checkbox('setValue',rowData.CheckUser==1);
	$("#chkBeRequest").checkbox('setValue',rowData.BeRequest==1);
	$("#chkBatchOper").checkbox('setValue',rowData.BatchOper==1);
	
	$("input[name='radMRCategoryList']").each(function () {
		$(this).radio('setValue',false);
	})
	if (rowData.MRCategory) {
		$HUI.radio('#radMRCategoryList'+rowData.MRCategory).setValue(true);   // 病历类型
	}
	$("#txtResume").val(rowData.Resume);
}

// 初始化前提操作
function InitgridPreItems(op){
	var columns = [[
		{field:'IsChecked',checkbox:true},
		{field:'ItemDesc',title:'描述',width:'120',align:'center'}
	]];
	
	var gridPreItems = $HUI.datagrid("#gridPreItems",{
		fit:true,
		// title:"前提操作",
		// headerCls:'panel-header-gray',
		// iconCls:'icon-paper',
		rownumbers: true,		//如果为true, 则显示一个行号列
		// singleSelect:true,
		showHeader:true,		//不隐藏表头
		autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		// fitColumns:true,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		checkOnSelect:true,		//true,击某一行时，选中/取消选中复选框
		selectOnCheck:true,		//true,点击复选框将会选中该行
		url:$URL,
		queryParams:{
		    ClassName:"CT.IPMR.BTS.WorkFItemSrv",
			QueryName:"QryWFCfgPreItem",
			aWFItemID:op,
			rows:10000
		},
		columns :columns,
		onLoadSuccess: function (data) {
			if (data) {
				$.each(data.rows, function (index, item) {
					if (item.IsChecked == 1) {
						$('#gridPreItems').datagrid('checkRow', index);
					}
				});
			}
		},
		// frozenColumns:[[ {field:'ck',checkbox:true,}]]
	});
}

// 关闭窗口时,清空数据
function clearData(){
	$("#WFItemID").val('');
	$("#txtItemDesc").val('');
	$("#txtItemAlias").val('');
	$('#cboItemType').combobox('setValue', '');
	$('#cboSubFlow').combobox('setValue', '');
	$('#cboSysOpera').combobox('setValue', '');
	
	$("input[name='radPreStepList']").each(function () {
		$(this).radio('setValue',false);
	})
	
	$("input[name='radPostStepList']").each(function () {
		$(this).radio('setValue',false);
	})
	
	$('#gridPreItems').datagrid('loadData', { total: 0, rows: [] });	// 清空datagrid
	$('#chkIsActive').checkbox('setValue',false);
	$('#chkCheckUser').checkbox('setValue',false);
	$('#chkBeRequest').checkbox('setValue',false);
	$('#chkBatchOper').checkbox('setValue',false);
	
	$("input[name='radMRCategoryList']").each(function () {
		$(this).radio('setValue',false);
	})
	$("#txtResume").val('');
}

// 工作流项目配置,保存按钮事件
function saveDate(op){
	var CHR_1 = "^";	//String.fromCharCode(1);
	
	var selected = $('#gridWFItem').datagrid('getSelected');
	if (!selected) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	
	var WorkItemID = selected.WFItemID;
	var arrID = WorkItemID.split("||");
	if (arrID.length>1){
		var Parref = arrID[0];
		var Childsub = arrID[1];
	} else {
		var Parref = op;		// WFlowID
		var Childsub = '';
	}
	
	var ItemID			= selected.ItemID;
	var ItemAlias		= $("#txtItemAlias").val();
	var TypeID			= $("#cboItemType").combobox('getValue');
	var SubFlowID		= $("#cboSubFlow").combobox('getValue');
	var SysOperaID		= $("#cboSysOpera").combobox('getValue');
	var PreStep			= $("input[name='radPreStepList']:checked").val();
	var PostStep		= $("input[name='radPostStepList']:checked").val();
	if (typeof(PreStep)=='undefined'){
		PreStep=''
	}
	if (typeof(PostStep)=='undefined'){
		PostStep=''
	}
	var IsActive		= $("#chkIsActive").checkbox('getValue');
	var CheckUser		= $("#chkCheckUser").checkbox('getValue');
	var BeRequest		= $("#chkBeRequest").checkbox('getValue');
	var BatchOper		= $("#chkBatchOper").checkbox('getValue');
	var MRCategory		= $("input[name='radMRCategoryList']:checked").val();
	var Resume			= $("#txtResume").val();
	
	var rows = $('#gridPreItems').datagrid('getSelections');	//datagrid('getChecked');
	var PreItems		= '';
	for (var i = 0; i < rows.length; i++) {
		PreItems=PreItems+"#"+rows[i].ItemID;
	}
	
	if (PreItems != '') PreItems=PreItems.substr(1);
	
	if (Parref == '') return;
	if (ItemID == '') return;
	if (TypeID == ''){
		$.messager.popover({msg: '项目类型不允许为空！',type: 'alert',timeout: 1000});
		return;
	}
	if (SubFlowID == ''){
		$.messager.popover({msg: '操作流程不允许为空！',type: 'alert',timeout: 1000});
		return;
	}
	
	var tmp = Parref;
	tmp += CHR_1 + Childsub;
	tmp += CHR_1 + ItemID;
	tmp += CHR_1 + ItemAlias;
	tmp += CHR_1 + TypeID;
	tmp += CHR_1 + SubFlowID;
	tmp += CHR_1 + SysOperaID;
	tmp += CHR_1 + PreStep;
	tmp += CHR_1 + PostStep;
	tmp += CHR_1 + PreItems;
	tmp += CHR_1 + (IsActive==false?0:1);
	tmp += CHR_1 + (CheckUser==false?0:1);
	tmp += CHR_1 + (BeRequest==false?0:1);
	tmp += CHR_1 + (BatchOper==false?0:1);
	tmp += CHR_1 + MRCategory;
	tmp += CHR_1 + Resume;
	
	var flg = $m({
		ClassName:"CT.IPMR.BT.WorkFItem",
		MethodName:"Update",
		aInputStr:tmp,
		aSeparate:CHR_1
	},false);
	// debugger
	if (parseInt(flg) <= 0) {
		$.messager.alert("错误", "保存失败!", 'error');
		return;
	}else{
		$.messager.popover({msg: '修改成功！',type:'success',timeout: 1000});
		$('#gridWFItem').datagrid('reload');
		$('#gridWFItem').datagrid('unselectAll');
	}
}

function moveUp(){
	var selected = $('#gridWFItem').datagrid('getSelected');
	if (!selected) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	
	var tmpId1		= selected.WFItemID;		// 选中行,WorkFItem.ID
	var tmpIndex1	= selected.ItemIndex;		// 选中行,WorkFItem.序号
	var tmpId2		= ""
	
	var Data = $('#gridWFItem').datagrid('getData');
	for (var i = 0; i < Data.total; i++) {
		var row = Data.rows[i];
		if (row.ItemIndex==(tmpIndex1*1-1)) {
			tmpId2	= row.WFItemID;
		}
	}
	if ((tmpId2 == '')&&(tmpId1 != '')){
		$.messager.popover({msg: '最上一条操作项目不能上移！',type: 'alert',timeout: 1000});
	}
	if ((tmpId2 == '')||(tmpId1 == '')) return;
	
	var flg = $m({
		ClassName:"CT.IPMR.BT.WorkFItem",
		MethodName:"SwapIndex",
		aId1:tmpId1,
		aId2:tmpId2
	},false);
	
	if (parseInt(flg) <= 0) {
		$.messager.popover({msg: '上移失败！',type:'error',timeout: 1000});
		return;
	}else{
		$.messager.popover({msg: '上移成功！',type:'success',timeout: 1000});
		$('#gridWFItem').datagrid('reload');
		$('#gridWFItem').datagrid('unselectAll');
	}
}

function moveDown(){
	var selected = $('#gridWFItem').datagrid('getSelected');
	if (!selected) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	
	var tmpId1		= selected.WFItemID;		// 选中行,WorkFItem.ID
	var tmpIndex1	= selected.ItemIndex;		// 选中行,WorkFItem.序号
	var tmpId2		= ""
	
	var Data = $('#gridWFItem').datagrid('getData');
	for (var i = 0; i < Data.total; i++) {
		var row = Data.rows[i];
		if (row.ItemIndex==(tmpIndex1*1+1)) {
			tmpId2	= row.WFItemID;
		}
	}
	
	if ((tmpId2 == '')&&(tmpId1 != '')){
		$.messager.popover({msg: '最后一条操作项目不能下移！',type: 'alert',timeout: 1000});
	}
	if ((tmpId2 == '')||(tmpId1 == '')) return;
	
	var flg = $m({
		ClassName:"CT.IPMR.BT.WorkFItem",
		MethodName:"SwapIndex",
		aId1:tmpId1,
		aId2:tmpId2
	},false);
	
	if (parseInt(flg) <= 0) {
		$.messager.popover({msg: '下移失败！',type:'error',timeout: 1000});
		return;
	}else{
		$.messager.popover({msg: '下移成功！',type:'success',timeout: 1000});
		$('#gridWFItem').datagrid('reload');
		$('#gridWFItem').datagrid('unselectAll');
	}
}