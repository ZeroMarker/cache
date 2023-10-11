/**
 *template.js
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-04-28
 * 
 * 
 */
PLObject = {
	v_TPID: "",
	v_TPGID: "",
	v_CHosp:""
}
$(function() {
	Init();
	InitEvent();
})

function Init(){
	InitHospList();
	InitCombox();
	InitTPLGrid();
	InitStageGrid();
	InitGroupGrid();
	InitItemGrid();
}

function InitEvent () {
	$("#i-find").click(findConfig);
	
	$("#tpl-add").click(add_TPLConfig);
	$("#tpl-edit").click(edit_TPLConfig);
	$("#tpl-delete").click(del_TPLConfig);
	$("#tpl-import").click(import_TPLConfig);
	
	$("#stage-add").click(add_StageConfig);
	$("#stage-edit").click(edit_StageConfig);
	$("#stage-delete").click(del_StageConfig);
	$("#stage-up").click(up_StageConfig);
	$("#stage-down").click(down_StageConfig);
	
	
	$("#group-add").click(add_GroupConfig);
	$("#group-edit").click(edit_GroupConfig);
	$("#group-delete").click(del_GroupConfig);
	$("#group-up").click(up_GroupConfig);
	$("#group-down").click(down_GroupConfig);
	
	
	$("#item-add").click(add_ItemConfig);
	$("#item-edit").click(edit_ItemConfig);
	$("#item-delete").click(del_ItemConfig);
	$("#item-up").click(up_ItemConfig);
	$("#item-down").click(down_ItemConfig);
	
}

function InitCombox() {
	PLObject.m_Type = $HUI.combobox("#i-type", {
		url:$URL+"?ClassName=DHCDoc.Chemo.CFG.Template&QueryName=QryTPLType&ResultSetType=array",
		valueField:'id',
		textField:'text',
		blurValidValue:true,
		onSelect: function (record) {
			findConfig();
		}
	});
}

function InitTPLGrid(){
	var columns = [[
		{field:'typeDesc',title:'模板类型',width:80},
		{field:'descDesc',title:'模板描述',width:120},
		{field:'name',title:'化疗单名称',width:150},
		{field:'stagenum',title:'总周期数',width:80},
		{field:'active',title:'是否有效',width:80,
			formatter:function(value,row,index){
					if (value == "Y") {
						return "<span class='c-ok'>是</span>"
					} else {
						return "<span class='c-no'>否</span>"
					}
				}
		},
		{field:'hospName',title:'院区',width:80},
		{field:'mainNote',title:'主药备注',width:200,hidden:true},
		{field:'title',title:'化疗标题',width:200,hidden:true},
		{field:'id',title:'id',width:100,hidden:true}
	]]
	var DataGrid = $HUI.datagrid("#i-tpl", {
		fit : true,
		striped : true,
		border:false,
		singleSelect : true,
		fitColumns : true,
		rownumbers:false,
		view:detailview,
		nowrap:false,
		//autoRowHeight : false,
		pagination : true,  
		idField:'id',
		//headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCDoc.Chemo.CFG.Template",
			QueryName : "QryTPL",
			InType: "",
			InHosp:GetHospValue()
		},
		detailFormatter:function(rowIndex, rowData){
			var result=""
			if (rowData.mainNote!="") {
				result="<div style='padding:4px 0px;'><label style='font-weight:bold;'>主药备注：</label>"+rowData.mainNote
			}
			if (rowData.title!="") {
				if (result!="") {
					result=result+"<br><br><label style='font-weight:bold;'>化疗标题：</label>"+rowData.title
				} else {
					result="化疗标题："+rowData.title;
				}
				result=result+"</div>"
			}
			if (result=="") {
				result="<div style='padding:4px 0px;'><label style='color:red;'>没有维护：主药备注和化疗标题信息<label></div>"
			}
			return result;
		},
		onSelect: function (rowIndex, rowData) {
			PLObject.v_TPID = rowData.id;
			findConfig_Stage(rowData.id)
		},
		toolbar:[
				{
						text:'新增',
						id:'tpl-add',
						iconCls: 'icon-add'
				},
				{
						text:'修改',
						id:'tpl-edit',
						iconCls: 'icon-write-order'
				},{
						text:'删除',
						id:'tpl-delete',
						iconCls: 'icon-cancel'
				},{
						text:'导入',
						id:'tpl-import',
						iconCls: 'icon-import'
				}
					
		],
		columns :columns
	});
	
	PLObject.m_TPLGrid = DataGrid;
}

function InitStageGrid(){
	var columns = [[
		{field:'stage',title:'周期代码',width:90},
		{field:'desc',title:'周期描述',width:100},
		{field:'startDate',title:'周期开始日期',width:100},
		{field:'endDate',title:'周期结束日期',width:100},
		{field:'nextNum',title:'周期数',width:100},
		{field:'chemoDate',title:'化疗日期',width:100},
		{field:'id',title:'id',width:100,hidden:true}
	]]
	var DataGrid = $HUI.datagrid("#i-stage", {
		fit : true,
		striped : true,
		border:false,
		singleSelect : true,
		//fitColumns : true,
		rownumbers:false,
		nowrap:false,
		//autoRowHeight : false,
		pagination : true,  
		//headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCDoc.Chemo.CFG.Stage",
			QueryName : "QryStage",
			TPID: ""
		},
		onSelect: function (rowIndex, rowData) {
			PLObject.v_TSID = rowData.id;
			findConfig_Group(rowData.id)
		},
		toolbar:[
				{
						text:'新增',
						id:'stage-add',
						iconCls: 'icon-add'
				},
				{
						text:'修改',
						id:'stage-edit',
						iconCls: 'icon-write-order'
				},{
						text:'删除',
						id:'stage-delete',
						iconCls: 'icon-cancel'
				},{
						text:'上移',
						id:'stage-up',
						iconCls: 'icon-up'
				},{
						text:'下移',
						id:'stage-down',
						iconCls: 'icon-down'
				}
					
		],
		columns :columns
	});
	
	PLObject.m_StageGrid = DataGrid;
}

function InitGroupGrid(){
	var columns = [[
		{field:'code',title:'组编号',width:60},
		{field:'desc',title:'组描述',width:250},
		{field:'planDate',title:'多选化疗日期',width:150},
		{field:'veinFlag',title:'静脉通道标志',width:100,hidden:true},
		{field:'mainDrug',title:'是否主药组',width:100,
			formatter:function(value,row,index){
					if (value == "Y") {
						return "<span class='c-ok'>是</span>"
					} else {
						return "<span class='c-no'>否</span>"
					}
				}
		},
		{field:'note',title:'组备注',width:300},
		{field:'id',title:'id',width:100,hidden:true}
	]]
	var DataGrid = $HUI.datagrid("#i-group", {
		fit : true,
		striped : true,
		border:false,
		singleSelect : true,
		//fitColumns : true,
		nowrap:false,
		rownumbers:false,
		//autoRowHeight : false,
		pagination : true,  
		//headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCDoc.Chemo.CFG.Group",
			QueryName : "QryGroup",
			TSID: ""
		},
		onSelect: function (rowIndex, rowData) {
			PLObject.v_TPGID = rowData.id;
			findConfig_Item(rowData.id)
		},
		toolbar:[
				{
						text:'新增',
						id:'group-add',
						iconCls: 'icon-add'
				},
				{
						text:'修改',
						id:'group-edit',
						iconCls: 'icon-write-order'
				},{
						text:'删除',
						id:'group-delete',
						iconCls: 'icon-cancel'
				},{
						text:'上移',
						id:'group-up',
						iconCls: 'icon-up'
				},{
						text:'下移',
						id:'group-down',
						iconCls: 'icon-down'
				}
					
		],
		columns :columns
	});
	
	PLObject.m_GroupGrid = DataGrid;
}

function InitItemGrid(){
	var columns = [[
		{field:'TPGIID',title:'TPGIID',width:100,hidden:true},
		{field:'arcimDesc',title:'医嘱名称',width:260},
		{field:'linkItem',title:'关联',width:100},
		{field:'mainDrug',title:'是否主药',width:100,
			formatter:function(value,row,index){
					if (value == "Y") {
						return "<span class='c-ok'>是</span>"
					} else {
						return "<span class='c-no'>否</span>"
					}
				}
		},
		{field:'dosage',title:'剂量',width:100},
		{field:'dosageUomDesc',title:'剂量单位',width:100},
		{field:'freqDesc',title:'频次',width:100},
		{field:'instrucDesc',title:'用法',width:100},
		{field:'duratDesc',title:'疗程',width:100},
		{field:'qty',title:'数量',width:100},
		{field:'uomDesc',title:'单位',width:100},
		{field:'note',title:'备注',width:100},
		{field:'priorDesc',title:'医嘱类型',width:100},
		{field:'simpleDesc',title:'标本',width:100},
		{field:'remark',title:'附加说明',width:100},
		{field:'recLocDesc',title:'接受科室',width:100},
		{field:'stage',title:'医嘱阶段',width:100},
		{field:'flowRate',title:'输液流速',width:100},
		{field:'flowRateDR',title:'流速单位',width:100},
		{field:'skinTest',title:'皮试',width:100},
		{field:'skinAction',title:'皮试备注',width:100},
		{field:'formula',title:'计算公式',width:100},
		{field:'BSAUnitSTD',title:'标准值',width:100},
		{field:'BSAUnit',title:'输入值',width:100},
		{field:'ShowDate',title:'显示日期',width:300},
		{field:'MainDrugNote',title:'主药备注',width:300}
		
	]]
	var DataGrid = $HUI.datagrid("#i-item", {
		fit : true,
		striped : true,
		border:false,
		nowrap:false,
		singleSelect : true,
		fitColumns : false,
		rownumbers:false,
		//autoRowHeight : false,
		pagination : true,  
		//headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCDoc.Chemo.CFG.Item",
			QueryName : "QryTPLGroupItem",
			TPGID: ""
		},
		onSelect: function (rowIndex, rowData) {
			
		},
		toolbar:[
				{
						text:'新增',
						id:'item-add',
						iconCls: 'icon-add'
				},
				{
						text:'修改',
						id:'item-edit',
						iconCls: 'icon-write-order'
				},{
						text:'删除',
						id:'item-delete',
						iconCls: 'icon-cancel'
				},{
						text:'上移',
						id:'item-up',
						iconCls: 'icon-up'
				},{
						text:'下移',
						id:'item-down',
						iconCls: 'icon-down'
				}
					
		],
		columns :columns
	});
	
	PLObject.m_ItemGrid = DataGrid;
}

function findConfig () {
	var type =  PLObject.m_Type.getValue()||"",
		InDesc = $.trim($("#InDesc").val());
	PLObject.m_TPLGrid.clearSelections();
	PLObject.m_TPLGrid.reload({
		ClassName : "DHCDoc.Chemo.CFG.Template",
		QueryName : "QryTPL",
		InType:type,
		InDesc:InDesc,
		InHosp:GetHospValue()
	});
}

function findConfig_Stage (TPID) {
	PLObject.m_StageGrid.reload({
		ClassName : "DHCDoc.Chemo.CFG.Stage",
		QueryName : "QryStage",
		TPID:TPID||PLObject.v_TPID
	});
}

function findConfig_Group (TSID) {
	PLObject.m_GroupGrid.reload({
		ClassName : "DHCDoc.Chemo.CFG.Group",
		QueryName : "QryGroup",
		TSID:TSID||PLObject.v_TSID
	});
}

function findConfig_Item (TPGID) {
	PLObject.m_ItemGrid.reload({
		ClassName : "DHCDoc.Chemo.CFG.Item",
		QueryName : "QryTPLGroupItem",
		TPGID:TPGID||PLObject.v_TPGID
	});
}


//周期
function add_StageConfig () {
	var TPID = PLObject.v_TPID||"";
	if (TPID=="") {
		$.messager.alert("提示", "请选择模板！", "info");
		return false;
	}
	var URL = "chemo.cfg.templatestage.edit.csp?TPID="+TPID;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-add',
		title:'添加化疗单模板周期',
		width:370,height:400,
		CallBackFunc:callback_Stage
	})
}

function edit_StageConfig () {
	var selected = PLObject.m_StageGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	var TSID = selected.id;
	var TPID = PLObject.v_TPID;
	var URL = "chemo.cfg.templatestage.edit.csp?TPID="+TPID+"&TSID="+TSID;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'修改化疗单模板周期',
		width:370,height:400,
		CallBackFunc:callback_Stage
	})
	
}

function del_StageConfig () {
	var selected = PLObject.m_StageGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	
	$.messager.confirm("提示", "确认删除？",function (r) {
		if (r) {
			$m({
				ClassName:"DHCDoc.Chemo.CFG.Stage",
				MethodName:"Delete",
				TSID:selected.id
			}, function(result){
				if (result == 0) {
					$.messager.alert("提示", "删除成功！", "info");
					findConfig_Stage();
					findConfig_Group("")
					findConfig_Item("")
					return true;
				} else {
					$.messager.alert("提示", "删除失败：" + result , "info");
					return false;
				}
			});
		}
		
	});
}

function callback_Stage () {
	findConfig_Stage();
}

function up_StageConfig () {
	var selectedOld = PLObject.m_StageGrid.getSelected();
	if (!selectedOld) {
		$.messager.alert('提示','请选择一条记录...', "info");
		return false;
	}
	//Index from zero
	var rowIndexOld = PLObject.m_StageGrid.getRowIndex(selectedOld);
	if (rowIndexOld == 0) {
		$.messager.alert('提示','已是第一条记录，无法上调...', "info");
		return false;
	}
	//console.log(selectedOld)
	var oldStage = selectedOld.stage;
	var oldID=selectedOld.id;
	var preIndex = rowIndexOld - 1;
	var selectedPre = PLObject.m_StageGrid.getData().rows[preIndex];
	var preStage = selectedPre.stage;
	var preID=selectedPre.id
	
	$m({
		ClassName:"DHCDoc.Chemo.CFG.Stage",
		MethodName:"UpStage",
		oldID:oldID,
		oldStage:oldStage,
		preID:preID,
		preStage:preStage
	}, function(result){
		if (result == 0) {
			//$.messager.alert("提示", "上调成功！", "info");
			findConfig_Stage();
			return true;
		} else {
			$.messager.alert("提示", "上调失败：" + result , "info");
			return false;
		}
	});
}

function down_StageConfig () {
	var selectedOld = PLObject.m_StageGrid.getSelected();
	if (!selectedOld) {
		$.messager.alert('提示','请选择一条记录...', "info");
		return false;
	}
	//Index from zero
	var AllData = PLObject.m_StageGrid.getData();
	var totalRows = AllData.total;
	var rowIndexOld = PLObject.m_StageGrid.getRowIndex(selectedOld);
	if (rowIndexOld == (totalRows-1)) {
		$.messager.alert('提示','已是最后一条记录，无法下调...', "info");
		return false;
	}
	var nextIndex = rowIndexOld + 1;
	var selectedNext = AllData.rows[nextIndex];
	var oldStage = selectedOld.stage;
	var oldID=selectedOld.id;
	var nextStage = selectedNext.stage;
	var nextID=selectedNext.id
	
	$m({
		ClassName:"DHCDoc.Chemo.CFG.Stage",
		MethodName:"UpStage",
		oldID:oldID,
		oldStage:oldStage,
		preID:nextID,
		preStage:nextStage
	}, function(result){
		if (result == 0) {
			//$.messager.alert("提示", "上调成功！", "info");
			findConfig_Stage();
			return true;
		} else {
			$.messager.alert("提示", "下调失败：" + result , "info");
			return false;
		}
	});
		
}

//模板
function add_TPLConfig () {
	var URL = "chemo.cfg.template.edit.csp?InHosp="+GetHospValue();
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-add',
		title:'添加化疗单模板',
		width:870,height:500,
		CallBackFunc:function(id) {
			findConfig();
			setTimeout(function(){ PLObject.m_TPLGrid.selectRecord(id); }, 100);
			
		}
	})
}

function edit_TPLConfig () {
	var selected = PLObject.m_TPLGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	var TPID = selected.id;
	var URL = "chemo.cfg.template.edit.csp?TPID="+TPID+"&InHosp="+GetHospValue();
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'修改化疗单模板',
		width:870,height:500,
		CallBackFunc:callback_TPL
	})
}

function del_TPLConfig () {
	var selected = PLObject.m_TPLGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	$.messager.confirm("提示", "确认删除？",function (r) {
		if (r) {
			$m({
				ClassName:"DHCDoc.Chemo.CFG.Template",
				MethodName:"DeleteTPL",
				TPID:selected.id
			}, function(result){
				if (result == 0) {
					$.messager.alert("提示", "删除成功！", "info");
					findConfig();
					//刷新其他表格
					findConfig_Stage("")
					findConfig_Group("")
					findConfig_Item("")
					return true;
				} else {
					$.messager.alert("提示", "删除失败：" + result , "info");
					return false;
				}
			});
		}
		
	});
	
}

function callback_TPL (id) {
	findConfig();
	//setTimeout(function(){ PLObject.m_TPLGrid.selectRecord(id); }, 100);
}

function import_TPLConfig () {
	var URL = "chemo.cfg.template.import.csp";
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-import',
		title:'模板导入',
		width:$(window).width(),
		height:$(window).height()
	})
}

//化疗组
function add_GroupConfig () {
	var selected = PLObject.m_StageGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择周期！", "info");
		return false;
	}
	var TSID=selected.id;
	var URL = "chemo.cfg.templategroup.edit.csp?TSID="+TSID;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-add',
		title:'添加化疗单模板化疗组',
		width:370,height:400,
		CallBackFunc:callback_Group
	})
}

function edit_GroupConfig () {
	var selected = PLObject.m_StageGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择周期！", "info");
		return false;
	}
	var selected2 = PLObject.m_GroupGrid.getSelected();
	if (!selected2) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	var TPGID = selected2.id;
	var TSID=selected.id;
	var URL = "chemo.cfg.templategroup.edit.csp?TSID="+TSID+"&TPGID="+TPGID;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'修改化疗单模板化疗组',
		width:370,height:400,
		CallBackFunc:callback_Group
	})
}

function del_GroupConfig () {
	var selected = PLObject.m_GroupGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	
	$.messager.confirm("提示", "确认删除？",function (r) {
		if (r) {
			$m({
				ClassName:"DHCDoc.Chemo.CFG.Group",
				MethodName:"Delete",
				ID:selected.id
			}, function(result){
				if (result == 0) {
					$.messager.alert("提示", "删除成功！", "info");
					findConfig_Group();
					findConfig_Item("")
					return true;
				} else {
					$.messager.alert("提示", "删除失败：" + result , "info");
					return false;
				}
			});
		}
		
	});
	
}

function callback_Group () {
	findConfig_Group();
}

function up_GroupConfig () {
	var selectedOld = PLObject.m_GroupGrid.getSelected();
	if (!selectedOld) {
		$.messager.alert('提示','请选择一条记录！', "info");
		return false;
	}
	//Index from zero
	var rowIndexOld = PLObject.m_GroupGrid.getRowIndex(selectedOld);
	if (rowIndexOld == 0) {
		$.messager.alert('提示','已是第一条记录，无法上调！', "info");
		return false;
	}
	//console.log(selectedOld)
	var oldCode = selectedOld.code;
	var oldID=selectedOld.id;
	var preIndex = rowIndexOld - 1;
	var selectedPre = PLObject.m_GroupGrid.getData().rows[preIndex];
	var preCode = selectedPre.code;
	var preID=selectedPre.id
	
	$m({
		ClassName:"DHCDoc.Chemo.CFG.Group",
		MethodName:"UpGroup",
		oldID:oldID,
		oldCode:oldCode,
		preID:preID,
		preCode:preCode
	}, function(result){
		if (result == 0) {
			//$.messager.alert("提示", "上调成功！", "info");
			findConfig_Group();
			return true;
		} else {
			$.messager.alert("提示", "上调失败：" + result , "info");
			return false;
		}
	});
}

function down_GroupConfig () {
	var selectedOld = PLObject.m_GroupGrid.getSelected();
	if (!selectedOld) {
		$.messager.alert('提示','请选择一条记录！', "info");
		return false;
	}
	//Index from zero
	var AllData = PLObject.m_GroupGrid.getData();
	var totalRows = AllData.total;
	var rowIndexOld = PLObject.m_GroupGrid.getRowIndex(selectedOld);
	if (rowIndexOld == (totalRows-1)) {
		$.messager.alert('提示','已是最后一条记录，无法下调！', "info");
		return false;
	}
	var nextIndex = rowIndexOld + 1;
	var selectedNext = AllData.rows[nextIndex];
	var oldCode = selectedOld.code;
	var oldID=selectedOld.id;
	var preCode = selectedNext.code;
	var preID=selectedNext.id;
	
	$m({
		ClassName:"DHCDoc.Chemo.CFG.Group",
		MethodName:"UpGroup",
		oldID:oldID,
		oldCode:oldCode,
		preID:preID,
		preCode:preCode
	}, function(result){
		if (result == 0) {
			findConfig_Group();
			return true;
		} else {
			$.messager.alert("提示", "下调失败：" + result , "info");
			return false;
		}
	});
}

//化疗项目
function add_ItemConfig () {
	var selected = PLObject.m_GroupGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择化疗组！", "info");
		return false;
	}
	var TPGID=selected.id;
	var TPGIID=""
	var URL = "chemo.cfg.templategroupitem.edit.csp?TPGID="+TPGID+"&TPGIID="+TPGIID+"&InHosp="+GetHospValue();
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-add',
		title:'添加化疗单模板化疗组项目',
		width:500,height:680,
		CallBackFunc:callback_Item
	})
}

function edit_ItemConfig () {
	var selected = PLObject.m_GroupGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择化疗组！", "info");
		return false;
	}
	var selected2 = PLObject.m_ItemGrid.getSelected();
	if (!selected2) {
		$.messager.alert("提示", "请选择化疗项目！", "info");
		return false;
	}
	var TPGID=selected.id;
	var TPGIID=selected2.TPGIID;
	var URL = "chemo.cfg.templategroupitem.edit.csp?TPGID="+TPGID+"&TPGIID="+TPGIID+"&InHosp="+GetHospValue();
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'修改化疗单模板化疗组项目',
		width:500,height:680,
		CallBackFunc:callback_Item
	})
}

function del_ItemConfig () {
	var selected = PLObject.m_ItemGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	
	$.messager.confirm("提示", "确认删除？",function (r) {
		if (r) {
			$m({
				ClassName:"DHCDoc.Chemo.CFG.Item",
				MethodName:"DeleteTPLGroupItem",
				TPGIID:selected.TPGIID
			}, function(result){
				if (result == 0) {
					$.messager.alert("提示", "删除成功！", "info");
					findConfig_Item();
					return true;
				} else {
					$.messager.alert("提示", "删除失败：" + result , "info");
					return false;
				}
			});
		}
		
	});
	
}

function callback_Item () {
	findConfig_Item();
}

function up_ItemConfig () {
	var selectedOld = PLObject.m_ItemGrid.getSelected();
	if (!selectedOld) {
		$.messager.alert('提示','请选择一条记录...', "info");
		return false;
	}
	//Index from zero
	var rowIndexOld = PLObject.m_ItemGrid.getRowIndex(selectedOld);
	if (rowIndexOld == 0) {
		$.messager.alert('提示','已是第一条记录，无法上调...', "info");
		return false;
	}
	//console.log(selectedOld)
	var oldSeqno = selectedOld.Seqno;
	var oldID=selectedOld.TPGIID;
	var preIndex = rowIndexOld - 1;
	var selectedPre = PLObject.m_ItemGrid.getData().rows[preIndex];
	var preSeqno = selectedPre.Seqno;
	var preID=selectedPre.TPGIID
	
	$m({
		ClassName:"DHCDoc.Chemo.CFG.Item",
		MethodName:"UpItem",
		oldID:oldID,
		oldSeqno:oldSeqno,
		preID:preID,
		preSeqno:preSeqno
	}, function(result){
		if (result == 0) {
			findConfig_Item();
			return true;
		} else {
			$.messager.alert("提示", "上调失败：" + result , "info");
			return false;
		}
	});	
}

function down_ItemConfig () {
	var selectedOld = PLObject.m_ItemGrid.getSelected();
	if (!selectedOld) {
		$.messager.alert('提示','请选择一条记录...', "info");
		return false;
	}
	//Index from zero
	var AllData = PLObject.m_ItemGrid.getData();
	var totalRows = AllData.total;
	var rowIndexOld = PLObject.m_ItemGrid.getRowIndex(selectedOld);
	if (rowIndexOld == (totalRows-1)) {
		$.messager.alert('提示','已是最后一条记录，无法下调...', "info");
		return false;
	}
	var nextIndex = rowIndexOld + 1;
	var selectedNext = AllData.rows[nextIndex];
	var oldSeqno = selectedOld.Seqno;
	var oldID=selectedOld.TPGIID;
	var preSeqno = selectedNext.Seqno;
	var preID=selectedNext.TPGIID
	
	$m({
		ClassName:"DHCDoc.Chemo.CFG.Item",
		MethodName:"UpItem",
		oldID:oldID,
		oldSeqno:oldSeqno,
		preID:preID,
		preSeqno:preSeqno
	}, function(result){
		if (result == 0) {
			findConfig_Item();
			return true;
		} else {
			$.messager.alert("提示", "上调失败：" + result , "info");
			return false;
		}
	});	
}

function InitHospList()
{
	var hospComp = GenHospComp("Doc_BaseConfig_CNMedCode");
	hospComp.jdata.options.onSelect = function(rowIndex,data){
		PLObject.v_CHosp = data.HOSPRowId;
		Clear();
		findConfig();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		//Init();
	}
}

function GetHospValue() {
	if (PLObject.v_CHosp == "") {
		return session['LOGON.HOSPID'];
	}
	
	return PLObject.v_CHosp
}

function Clear() {
	PLObject.m_Type.clear();
	$("#InDesc").val("");
}