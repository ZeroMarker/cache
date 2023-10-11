/**
 * 综合查询主页面 树形结构显示
 * 
 * Copyright (c) 2018-2019 LIYI. All rights reserved.
 * 
 * CREATED BY LIYI 2019-09-29
 * 
 * 注解说明
 * TABLE: 
 */

// 页面全局变量对象
var globalObj = {
	m_eidtplanid:'',
	m_showplancol:'',	// 显示输出列标识
	m_dynamicElType:'',
	m_limitedit:''		// 控制方案编辑
}
// 页面入口
$(function(){
	//初始化页面
	Init();
	//事件初始化
	InitEvent();
})

// 初始化页面
function Init(){
	Common_ComboToHosp("cboHospital",'',Logon.HospID);
	Common_ComboToDic("cboColumnDefCat","MQColumnCat",1,'');
	Common_ComboToDic("cboDataSource","MQDataSource",1,'');
	Common_ComboToDic("cboDateType","MQDateType",1,'');
	InitgridPlan();
	InitgridColumn();
	
    $('#cboCodeConfig').combobox({
	 	url: $URL,
		editable: true,
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		valueField: 'ID',
		textField: 'CodeMultiVerDesc',
		panelWidth:200,
		onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
			param.ClassName = 'CT.IPMR.FPS.ConfigSrv';
			param.QueryName = 'QueryCodeConfig';
			param.ResultSetType = 'array';
		}
	});
}

// 加载方案内容
function loadCurrPlan() {
	$('#gridColumn').datagrid('reload',{
		ClassName:"MA.IPMR.FPS.MQPlanSrv",
		QueryName:"QryPlanColumn",
		aPlanID:globalObj.m_eidtplanid,
		aColCatID:'',
		aAlias:'',
		aflg:globalObj.m_showplancol
	});
	InitLogicChart();
	if (globalObj.m_eidtplanid!=='') {
		$cm({
			ClassName:"MA.IPMR.FP.MQPlan",
			MethodName:"GetObjById",
			aId:globalObj.m_eidtplanid
		},function(rtn){
			// 检索条件赋值
			$('#cboDataSource').combobox('setValue',rtn.FMDataSourceDr)
			$('#cboDateType').combobox('setValue',rtn.FMDateTypeDr)
			$('#dfDateFrom').datebox('setValue',typeof(rtn.FMSttDate)=='undefined'?'':rtn.FMSttDate);
			$('#dfDateTo').datebox('setValue',typeof(rtn.FMEndDate)=='undefined'?'':rtn.FMEndDate);
			$('#cboCodeConfig').combobox('setValue',typeof(rtn.FMCodeConfigDr)=='undefined'?'':rtn.FMCodeConfigDr);
			if (typeof(rtn.FMDataSourceDr)!='undefined') {
				$cm({
					ClassName:"CT.IPMR.BT.Dictionary",
					MethodName:"GetObjById",
					aId:rtn.FMDataSourceDr
				},function(ret){
					if (ret.BDCode=='CodeData'){
						$('#cboCodeConfig').combobox('enable');
					}else{
						$('#cboCodeConfig').combobox('disable');
					}
				})
			}else{
				$('#cboCodeConfig').combobox('disable');
			}
		});
	}else{
		// 检索条件赋值
		$('#cboDataSource').combobox('setValue','');
		$('#cboDateType').combobox('setValue','');
		$('#dfDateFrom').datebox('setValue','');
		$('#dfDateTo').datebox('setValue','');
		$('#cboCodeConfig').combobox('setValue','');
	}
}

// 初始化事件
function InitEvent(){
	// 数据源选择事件
	$('#cboDataSource').combobox({
		onSelect: function(param){
			if (param.Code=='CodeData'){
				$('#cboCodeConfig').combobox('enable');
			}else{
				$('#cboCodeConfig').combobox('disable');
			}
			$('#cboCodeConfig').combobox('setValue',ServerObj.DefaultFPConfig);
		}
	});
	
	// 输出列分类选择事件
	$('#cboColumnDefCat').combobox({
		onSelect: function(param){
			$("#gridAddColumn").datagrid("reload", {
				ClassName:"MA.IPMR.FPS.MQPlanSrv",
				QueryName:"QryPlanColumn",
				aPlanID:globalObj.m_eidtplanid,
				aColCatID:param.ID,
				aAlias:$('#textAlias').val(),
				aflg:0
			})
		}
	});

	// 输出列关键字回车
	$('#textAlias').keyup(function(e){
		if(event.keyCode == 13) {
			$("#gridAddColumn").datagrid("reload", {
				ClassName:"MA.IPMR.FPS.MQPlanSrv",
				QueryName:"QryPlanColumn",
				aPlanID:globalObj.m_eidtplanid,
				aColCatID:$("#cboColumnDefCat").combobox('getValue'),
				aAlias:$('#textAlias').val(),
				aflg:0
			})
     	}
    });

	Common_ComboToDic("cboLogicCat","MQColumnCat",1,'');
	Common_ComboToDic("cboOperaMark","MQOperaMark",1,'');
	var cbox = $HUI.combobox("#cboLogicDataItem", {
		url: $URL,
		editable: true,
		defaultFilter:4,
		valueField: 'ID',
		textField: 'Desc',
		selectOnNavigation:false,
		method:'Post',
		mode:'remote',
		onBeforeLoad: function (param) {
			param.ClassName = 'CT.IPMR.FPS.MQColumnSrv';
			param.QueryName = 'QryColumn';
			param.aColCatID = $("#cboLogicCat").combobox('getValue');
			param.aAlias    = param['q'];
			param.ResultSetType = 'array';
		},
		onChange:function (newValue, oldValue){
			$m({
				ClassName:"CT.IPMR.FPS.MQColumnSrv",
				MethodName:"GetMQColumnInfo",
				aID:newValue
			},function(txtData){
				var dataType = txtData.split('^')[0];
				var DataItemCat = txtData.split('^')[1];
				var ShowCode = txtData.split('^')[2];
				renderTextVal(dataType,DataItemCat,ShowCode);
			});
		}
	});
	$('#cboLogicCat').combobox({
		onSelect: function(param){
			$("#cboLogicDataItem").combobox("clear")
			$("#cboLogicDataItem").combobox("reload")
		}
	});
	$('#t-planadd').click(function(){editPlan('add');});
	$('#t-planedit').click(function(){editPlan('edit');});
	$('#t-plandelete').click(function(){deletePlan();});
	$('#t-columnadd').click(function(){showAddColumn();});
	$('#t-columnup').click(function(){columnup();});
	$('#t-columndown').click(function(){columndown();});
}

 /**
 * NUMS: D001
 * CTOR: LIYI
 * DESC: 方案操作模块
 * DATE: 2019-09-29
 * NOTE: 包括方法：
 * TABLE: 
 */
 // 初始化方案
function InitgridPlan(){
	var columns = [[
		{field:'PlanDesc',title:'方案名称',width:300,align:'left'},
		{field:'UserDesc',title:'创建人',width:200,align:'left',hidden:ServerObj.IsLimitMQEdit=='1'?false:true}
    ]];
    var gridPlan = $('#gridPlan').datagrid({
		fit: true,
		title: "方案",
		idField: "ID" ,
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		fitColumns:true,
	    url:$URL,
	    queryParams:{
		    ClassName:"MA.IPMR.FPS.MQPlanSrv",
			QueryName:"QryPlan"
	    },
		onClickRow:function(rowIndex,rowData){
			if (rowIndex>-1) { 
				globalObj.m_eidtplanid = rowData.ID;
				globalObj.m_showplancol = 1;
				loadAuthority();	// 编辑权限
				loadCurrPlan();
			}
		},toolbar:[{
				text:'新增',
				id:'t-planadd',
				iconCls: 'icon-add'
			},{
				text:'修改',
				id:'t-planedit',
				iconCls: 'icon-edit'
			}
			,{
				text:'删除',
				id:'t-plandelete',
				iconCls: 'icon-cancel'
			}
		],
		onLoadSuccess:function(data){
			$('#gridPlan').datagrid('selectRecord',globalObj.m_eidtplanid);
			loadAuthority();	// 编辑权限
			loadCurrPlan(globalObj.m_eidtplanid);
		},
	    columns :columns
	});
	return gridPlan;
}

// 方案新增、修改事件
function editPlan(op){
	var selected = $("#gridPlan").datagrid('getSelected');
	if ((op == "edit")&&(!selected)) {
		$.messager.popover({msg: '请选择一条方案记录！',type: 'alert',timeout: 1000});
		return false;
	}
	$('#PlanDescDiag').css('display','block');
	var _title = "修改方案名称",_icon="icon-w-edit"
	if (op == "add") {
		_title = "新增新方案",_icon="icon-w-add";
		$("#txtPlanId").val('');
		$("#textPlanDesc").val('');
	} else {
		$("#txtPlanId").val(selected.ID);
		$("#textPlanDesc").val(selected.PlanDesc);
	}

	var PlanDescDiag = $HUI.dialog('#PlanDescDiag', {
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
					var PlanDesc   = $("#textPlanDesc").val();
					var PlanId   = $("#txtPlanId").val();

					if (PlanDesc==''){
						$.messager.popover({msg: '请输入查询方案名称！',type: 'alert',timeout: 1000});
						return
					}
					if (op=='add')
					{
						PlanId = $m({
							ClassName:"MA.IPMR.FP.MQPlan",
							MethodName:"NewBlankPlan",
							aUserID:Logon.UserID,
							aPlanDesc:PlanDesc
						},false);
					}
		    		if (op=='edit')
					{
						PlanId = $m({
							ClassName:"MA.IPMR.FP.MQPlan",
							MethodName:"UpdatePlanDesc",
							aId:PlanId,
							aPlanDesc:PlanDesc
						},false);
					}
					if (parseInt(PlanId) <= 0) {
						if (parseInt(PlanId)==-100){
							$.messager.alert("提示", "名称重复!", 'info');
						}else{
							$.messager.alert("错误", "保存失败!", 'error');
						}
					}else{
						globalObj.m_eidtplanid=PlanId;
						globalObj.m_showplancol=1;
						$("#txtPlanId").val('');
						$("#textPlanDesc").val('');
						$('#PlanDescDiag').window("close");
						$('#gridPlan').datagrid('reload');
					}
				}
		},{
		text:'关闭',
		iconCls:'icon-w-close',
		handler:function(){
				$('#PlanDescDiag').window("close");
			}	
		}]
	});
}
// 删除方案按钮
function deletePlan(op){
	var selected = $("#gridPlan").datagrid('getSelected');
	if (!selected) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}

	var planId = selected.ID;
	
	var flg = $m({
		ClassName:"MA.IPMR.FP.MQPlan",
		MethodName:"DelPlan",
		aPlanID:planId
	},false);
	if (parseInt(flg) <= 0) {
		$.messager.alert("错误", "删除失败!", 'error');
	}else{
		globalObj.m_eidtplanid='';
		globalObj.m_showplancol='';
		$('#gridPlan').datagrid('reload');
	}
};

/**
 * NUMS: D002
 * CTOR: LIYI
 * DESC: 列维护模块
 * DATE: 2019-09-29
 * NOTE: 包括方法：InitgridColumn
 * TABLE: 
 */

 // 初始化输出列
function InitgridColumn(){
	var columns = [[
		{field:'Desc',title:'名称',width:300,align:'left'},
		{field:'opt',title:'操作',width:50,align:'left',
			formatter:function(value,rowData,rowIndex){
				if (globalObj.m_limitedit!='1'){
	            /*var btn =  '<img title="移除" onclick="delColumn('+rowData.ID+')" src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png" style="border:0px;cursor:pointer">'   
					return btn;*/
					return "<a href='#' style='white-space:normal;color:#FB7D00' onclick='delColumn(\"" + rowData.ID + "\");'>" + $g("移除") + "</a>";
				}
			}  
      	}
    ]];
    var gridColumn = $('#gridColumn').datagrid({
		fit: true,
		title: "输出列",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		fitColumns:true,
	    url:$URL,
	    queryParams:{
		    ClassName:"MA.IPMR.FPS.MQPlanSrv",
			QueryName:"QryPlanColumn",
			aPlanID:globalObj.m_eidtplanid,
			aColCatID:'',
			aAlias:'',
			aflg:globalObj.m_showplancol
	    },toolbar:[{
				text:'新增',
				id:'t-columnadd',
				iconCls: 'icon-add'
			},{
				text:'上移',
				id:'t-columnup',
				iconCls: 'icon-up'
			},{
				text:'下移',
				id:'t-columndown',
				iconCls: 'icon-down'
			}
		],
	    columns :columns
	});
	return gridColumn;
}


function showAddColumn (){
	$("#textAlias").val('');
	$("#cboColumnDefCat").combobox('setValue','');
	var planselected = $("#gridPlan").datagrid('getSelected');
	if (!planselected) {
		$.messager.popover({msg: '请选择一条方案记录！',type: 'alert',timeout: 1000});
		return false;
	}
	$('#columnAddDiag').css('display','block');
	var columns = [[
		{field:'Desc',title:'名称',width:300,align:'left'},
		{field:'opt',title:'操作',width:50,align:'left',
			formatter:function(value,rowData,rowIndex){
            /*var btn =  '<img title="添加" onclick="addColumn('+rowData.ID+')" src="../scripts_lib/hisui-0.1.0/dist/css/icons/add.png" style="border:0px;cursor:pointer">' 
				return btn;*/
				return "<a href='#' style='white-space:normal;color:#229A06' onclick='addColumn(\"" + rowData.ID + "\");'>" + $g("添加") + "</a>"; 
			}  
      }
    ]];
    var gridAddColumn = $('#gridAddColumn').datagrid({
		fit: true,
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		fitColumns:true,
	    url:$URL,
	    queryParams:{
		    ClassName:"MA.IPMR.FPS.MQPlanSrv",
			QueryName:"QryPlanColumn",
			aPlanID:globalObj.m_eidtplanid,
			aColCatID:'',
			aAlias:'',
			aflg:0
	    },
	    columns :columns
	});

	var columnAddDiag = $HUI.dialog('#columnAddDiag', {
		title: '新增输出列',
		iconCls: 'icon-w-add',
		width: 500,
        height: 560,
	    minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
	    closed: false,
	    cache: false,
	    modal: true
	});
}
// 添加输出列
function addColumn(columnid){
	var flg = $m({
		ClassName:"MA.IPMR.FP.MQPlan",
		MethodName:"ModifyColumn",
		aPlanID:globalObj.m_eidtplanid,
		aColumnID:columnid,
		aOperType:1
	},false);
	if (parseInt(flg) <= 0) {
		if (parseInt(flg)==0){
			$.messager.popover({msg: '请选择一个方案！',type: 'alert',timeout: 1000});
		}else if (parseInt(flg)==-1){
			$.messager.alert("提示", "重复添加输出列!", 'info');
		}else if (parseInt(flg)==-2){
		}else if (parseInt(flg)==-99){
			$.messager.alert("错误", "保存失败!", 'error');
		}
	}else{
		$("#gridAddColumn").datagrid("reload");
		$("#gridColumn").datagrid("reload");
	}
}

// 移除输出列
function delColumn(columnid){
	var flg = $m({
		ClassName:"MA.IPMR.FP.MQPlan",
		MethodName:"ModifyColumn",
		aPlanID:globalObj.m_eidtplanid,
		aColumnID:columnid,
		aOperType:2
	},false);
	if (parseInt(flg) <= 0) {
		if (parseInt(flg)==0){
			$.messager.popover({msg: '请选择一个方案！',type: 'alert',timeout: 1000});
		}else if (parseInt(flg)==-1){
			$.messager.alert("提示", "重复添加输出列!", 'info');
		}else if (parseInt(flg)==-2){
		}else if (parseInt(flg)==-99){
			$.messager.alert("错误", "保存失败!", 'error');
		}
	}else{
		$("#gridColumn").datagrid("reload");
	}
}

// 上移
function columnup(){
	var selectVol = $('#gridColumn').datagrid('getSelected');
	if (selectVol==null){
		$.messager.popover({msg: '请选择输出列！',type: 'alert',timeout: 1000});
		return false;
	}
	$m({
		ClassName:"MA.IPMR.FP.MQPlan",
		MethodName:"SwapIndex",
		aplanid:globalObj.m_eidtplanid,
		aColumnID:selectVol.ID,
		aType:"UP"
	},function(txtData){
		var index = $('#gridColumn').datagrid('getRowIndex',selectVol);
		if (index==0) {
			$('#gridColumn').datagrid('reload');
		}else{
			var data =  $("#gridColumn").datagrid('getRows')[index-1];
			var tmpdata = {
					ID:data.ID,
					Code:data.Code,
					Desc:data.Desc,
					DataItems:data.DataItems,
					IsActive:data.IsActive,
					OrderNo:data.OrderNo
			}
			$('#gridColumn').datagrid('updateRow',{
				index: index-1,	
				row: selectVol
			});

			$('#gridColumn').datagrid('updateRow',{
				index: index,	
				row: tmpdata
			});
			$('#gridColumn').datagrid('selectRow',index-1);
		}
	});
};

// 下移
function columndown(){
	var selectVol = $('#gridColumn').datagrid('getSelected');
	if (selectVol==null){
		$.messager.popover({msg: '请选择输出列！',type: 'alert',timeout: 1000});
		return false;
	}
	$m({
		ClassName:"MA.IPMR.FP.MQPlan",
		MethodName:"SwapIndex",
		aplanid:globalObj.m_eidtplanid,
		aColumnID:selectVol.ID,
		aType:"DOWN"
	},function(txtData){
		var index = $('#gridColumn').datagrid('getRowIndex',selectVol);
		if (index==($("#gridColumn").datagrid('getRows').length-1)){
			$('#gridColumn').datagrid('reload');
		}else{
			var data =  $("#gridColumn").datagrid('getRows')[index+1];
			var tmpdata = {
					ID:data.ID,
					Code:data.Code,
					Desc:data.Desc,
					DataItems:data.DataItems,
					IsActive:data.IsActive,
					OrderNo:data.OrderNo
			}
			$('#gridColumn').datagrid('updateRow',{
				index: index+1,	
				row: selectVol
			});

			$('#gridColumn').datagrid('updateRow',{
				index: index,	
				row: tmpdata
			});
			$('#gridColumn').datagrid('selectRow',index+1);
		}
	});
};

/**
 * NUMS: D003
 * CTOR: LIYI
 * DESC: 检索条件模块
 * DATE: 2019-09-29
 * NOTE: 包括方法：
 * TABLE: 
 */

// 初始化条件图
 function InitLogicChart(){
    $('#chart-container').empty();
    $cm({
		ClassName:"MA.IPMR.FPS.MQLogicSrv",
		MethodName:"BuildLogicJson",
		aPlanID:globalObj.m_eidtplanid
	},function(jsonData){
		$('#chart-container').orgchart({
	      'data' : jsonData,
	      'nodeContent': 'title',
	      //'draggable': true,
	      'folded':false,
	      'parentNodeSymbol': 'fa-th-large',
	      'createNode': function($node, data) {
	        $node.on('click', function(event) {
	          if (!$(event.target).is('.edge')) {
	            }
	        });
	      }
	    })
	});
 }

// 添加关系节点
function addLogicMark(nodetype,id){
	eidtLogicMark(id,"add");
}

// 关系节点编辑
function eidtLogicMark(id,op){
	Common_ComboToDic("cboLogicMark","MQLogicMark",1,'');
	var _title = "修改关系",_icon="icon-w-edit";

	if (op == "add") {
		_title = "添加关系",_icon="icon-w-add";
		$('#cboLogicMark').combobox('setValue', '');
	} else {
		if (id!==''){
			$cm({
				ClassName:"MA.IPMR.FP.MQLogic",
				MethodName:"GetObjById",
				aId:globalObj.m_eidtplanid+'||'+id,
			},function(rtn){
				if (typeof(rtn.FMLogicMarkDr)=='undefined'){
					$('#cboLogicMark').combobox('setValue', '');
				}else{
					$('#cboLogicMark').combobox('setValue', rtn.FMLogicMarkDr);
				}
			});
		}else{
			$('#cboLogicMark').combobox('setValue', '');
		}
	}

	var LogicMarkDiag = $HUI.dialog('#LogicMarkDiag', {
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
					saveLogicMark(id,op);
				}
		},{
		text:'关闭',
		iconCls:'icon-w-close',
		handler:function(){
				$('#cboLogicMark').combobox('setValue', '');
				$('#LogicMarkDiag').window("close");
			}	
		}]
	});
}

// 保存逻辑关系
function saveLogicMark(id,op){
	var LogicMark 	= $("#cboLogicMark").combobox('getValue');
	if (LogicMark == '') {
		$.messager.popover({msg: '请选择运算符！',type: 'alert',timeout: 1000});
		return false;
	}

	$cm({
		ClassName:"MA.IPMR.FP.MQLogic",
		MethodName:"GetObjById",
		aId:globalObj.m_eidtplanid+'||'+id,
	},function(rtn){
		if (op=='add'){
			var inputStr = "";
		}else{
			var inputStr = id;
		}
		inputStr += '^' + globalObj.m_eidtplanid;
		if (op=='add'){
			inputStr += '^' + id;			// ParentID
		}else{
			if (typeof(rtn.FMParentID)=='undefined'){
				inputStr += '^' + '';			// ParentID
			}else{
				inputStr += '^' + rtn.FMParentID;			// ParentID
			}
		}
		inputStr += '^' + '';			// LogicExp
		inputStr += '^' + '';			// LogicDesc
		inputStr += '^' + LogicMark;	// LogicMark
		inputStr += '^' + '';			// LogicTerms
		inputStr += '^' + '';
		inputStr += '^' + '';
		inputStr += '^' + '';
		inputStr += '^' + '';
		inputStr += '^' + 1;
		inputStr += '^' + '';
		inputStr += '^' + 1;
		var flg = $m({
			ClassName:"MA.IPMR.FP.MQLogic",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparate:"^"
		},false);
		if (parseInt(flg) <= 0) {
			$.messager.alert("错误", "保存失败!", 'error');
		}
		$('#cboLogicMark').combobox('setValue', '');
		$('#LogicMarkDiag').window("close");
		InitLogicChart();
	});
}



// 添加逻辑条件
function addCustomLogic(nodetype,id){
	eidtLogic(id,"add");
}

// 逻辑条件编辑框
function eidtLogic(id,op){
	var _title = "修改条件",_icon="icon-w-edit";
	if (op == "add") {
		_title = "添加条件",_icon="icon-w-add";
		clearLogicDiag();
	} else {
		$cm({
			ClassName:"MA.IPMR.FP.MQLogic",
			MethodName:"GetObjById",
			aId:globalObj.m_eidtplanid+'||'+id,
		},function(rtn){
			$cm({
				ClassName:"CT.IPMR.FP.MQColumn",
				MethodName:"GetObjById",
				aId:rtn.FMDataItemDr,
			},function(ret){
					$('#cboLogicCat').combobox('setValue',ret.FMColCatDr);
			});
			$('#cboLogicDataItem').combobox('setValue', rtn.FMDataItemDr);
			$('#cboOperaMark').combobox('setValue', rtn.FMOperaMarkDr);
			setTimeout(function(){
				if ($("#textVal").hasClass('combogrid-f')) {
					$('#textVal').combogrid('setValue', rtn.FMCompValue);
				}else{
					$("#textVal").val(rtn.FMCompValue);
				}
			},300);
		});
	}

	var LogicDiag = $HUI.dialog('#LogicDiag', {
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
					saveLogic(id,op);
				}
		},{
		text:'关闭',
		iconCls:'icon-w-close',
		handler:function(){
				clearLogicDiag();
				$('#LogicDiag').window("close");
			}	
		}]
	});
}

// 保存逻辑条件
function saveLogic(id,op) {
	var DataItemCat = $("#cboLogicCat").combobox('getValue');
	var DataItem 	= $("#cboLogicDataItem").combobox('getValue');
	var OperaMark 	= $("#cboOperaMark").combobox('getValue');
	if (globalObj.m_dynamicElType == 'Combo') {
		var CompValue   = $("#textVal").combobox('getValue');
	}else{
		var CompValue   = $("#textVal").val();
	}
	
	if (DataItem == '') {
		$.messager.popover({msg: '请选择数据项！',type: 'alert',timeout: 1000});
		return false;
	}
	if (OperaMark == '') {
		$.messager.popover({msg: '请选择比较符！',type: 'alert',timeout: 1000});
		return false;
	}
	$cm({
		ClassName:"MA.IPMR.FP.MQLogic",
		MethodName:"GetObjById",
		aId:globalObj.m_eidtplanid+'||'+id,
	},function(rtn){
		if (op=='add'){
			var inputStr = "";
		}else{
			var inputStr = id;
		}
		
		inputStr += '^' + globalObj.m_eidtplanid;
		if (op=='add'){
			inputStr += '^' + id;			// ParentID
		}else{
			if (typeof(rtn.FMParentID)=='undefined'){
				inputStr += '^' + '';			// ParentID
			}else{
				inputStr += '^' + rtn.FMParentID;			// ParentID
			}
		}
		inputStr += '^' + '';			// LogicExp
		inputStr += '^' + '';			// LogicDesc
		inputStr += '^' + '';			// LogicMark
		inputStr += '^' + '';			// LogicTerms
		inputStr += '^' + DataItem;
		inputStr += '^' + OperaMark;
		inputStr += '^' + CompValue;
		inputStr += '^' + CompValue;
		inputStr += '^' + 0;
		inputStr += '^' + '';
		inputStr += '^' + 1;
		var flg = $m({
			ClassName:"MA.IPMR.FP.MQLogic",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparate:"^"
		},false);
		if (parseInt(flg) <= 0) {
			$.messager.alert("错误", "保存失败!", 'error');
		}
		clearLogicDiag();
		$('#LogicDiag').window("close");
		InitLogicChart();
	});
}

function eidtCustomLogic(nodetype,id){
	if (nodetype==1){	// 关系节点修改
		eidtLogicMark(id,"eidt");
	}else{
		eidtLogic(id,"eidt");
	}
}

// 删除节点
function cancelCustomLogic(nodetype,id){
	var flg = $m({
		ClassName:"MA.IPMR.FP.MQLogic",
		MethodName:"RemoveById",
		aId:globalObj.m_eidtplanid+"||"+id
	},false);
	if (parseInt(flg) <= 0) {
		$.messager.alert("错误提示", "保存失败!", 'info');
	}
	InitLogicChart();
}

function clearLogicDiag(){
	$('#cboLogicCat').combobox('setValue', '');
	$('#cboLogicDataItem').combobox('setValue', '');
	$('#cboOperaMark').combobox('setValue', '');
	renderTextVal('Textbox','','');
}

function NodePopover(){
	if (arguments[0] == undefined) return;
	var $this = $('#'+ arguments[0]);
	$this.popover({trigger:'hover',placement:'top',title:$g('条件'),content:arguments[1]});
	$this.popover('show');
}

// 生成数据条件检查
function checkPlanInput(){
	var selected = $("#gridPlan").datagrid('getSelected');
	if (!selected) {
		$.messager.popover({msg: '请选择一条方案记录！',type: 'alert',timeout: 1000});
		return false;
	}
	var inputStr = '';
	var planId = selected.ID;
	var planDesc = selected.PlanDesc;
	var DataSourceID = $('#cboDataSource').combobox('getValue');
	var DateTypeID = $('#cboDateType').combobox('getValue');
	var SttDate = $('#dfDateFrom').datebox('getValue');
	var EndDate = $('#dfDateTo').datebox('getValue');
	var CodeConfigID = $('#cboCodeConfig').combobox('getValue');
	var ColumnIDs = '';
	var ColumnDef = $cm({
		ClassName:"MA.IPMR.FPS.MQPlanSrv",
		QueryName:"QryPlanColumn",
		aPlanID:globalObj.m_eidtplanid,
		aColCatID:'',
		aAlias:'',
		aflg:1,
		rows:10000
	},false);
 	for (var i = 0;i<ColumnDef.rows.length;i++){
		ColumnIDs += ',' +  ColumnDef.rows[i].ID;
	}
	if (ColumnIDs != '') ColumnIDs = ColumnIDs.substr(1,ColumnIDs.length);
	if (planId==''){
		$.messager.popover({msg: '请选择方案！',type: 'alert',timeout: 1000});
		return inputStr
	}
	if (DataSourceID==''){
		$.messager.popover({msg: '请选择数据源！',type: 'alert',timeout: 1000});
		return inputStr
	}
	if (DateTypeID==''){
		$.messager.popover({msg: '请选择日期类型！',type: 'alert',timeout: 1000});
		return inputStr
	}
	if (ColumnIDs==''){
		$.messager.popover({msg: '请选输出列！',type: 'alert',timeout: 1000});
		return inputStr
	}
	if (CodeConfigID==''){
		$.messager.popover({msg: '请选编目版本！',type: 'alert',timeout: 1000});
		return inputStr
	}
	inputStr =planId;
	inputStr += '^' + planDesc;
	inputStr += '^' + DataSourceID;
	inputStr += '^' + DateTypeID;
	inputStr += '^' + SttDate;
	inputStr += '^' + EndDate;
	inputStr += '^' + ColumnIDs;
	inputStr += '^' + (selected.UserID!=''?selected.UserID : Logon.UserID);
	inputStr += '^' + CodeConfigID
	return inputStr
}

// 检索方案按钮
$('#btnQuery').click(function(){
	var inputStr = checkPlanInput();
	if (inputStr=='') return;
	
	var SttDate = $('#dfDateFrom').datebox('getValue');
	var EndDate = $('#dfDateTo').datebox('getValue');
	
	if (SttDate==''){
		$.messager.popover({msg: '请选开始日期！',type: 'alert',timeout: 1000});
		return
	}
	if (EndDate==''){
		$.messager.popover({msg: '请选结束日期！',type: 'alert',timeout: 1000});
		return
	}
	var flg = $m({
		ClassName:"MA.IPMR.FP.MQPlan",
		MethodName:"Update",
		aInputStr:inputStr,
		aSeparate:'^'
	},false);
	if (parseInt(flg) <= 0) {
		if (parseInt(flg)==-100){
			$.messager.alert("提示", "保存方案名称重复!", 'info');
		}else{
			$.messager.alert("错误", "保存方案失败!", 'error');
		}
	}else{
		showReuslt(parseInt(flg))
	}
});

/**
 * NUMS: M004
 * CTOR: liyi
 * DESC: 输出模块
 * DATE: 2020-05-13
 * NOTE: 包括方法：
 * TABLE: 
 */

function showReuslt(planid) {
	$cm({
    	ClassName:"MA.IPMR.FPS.MQPlanSrv",
    	QueryName:"QryPlanColumn",
		aPlanID:planid,
		aColCatID:'',
		aAlias:'',
		aflg:1,
		page:1,						 //可选项，页码，默认1
    	rows:1000					 //可选项，获取多少条数据，默认50
    },function(rs){
    	var columns = [[]];
		for (i=0;i<rs.rows.length ;i++){
			var ItemDesc = rs.rows[i].Desc
			var ItemCode = rs.rows[i].Code
			//var colitem  = {field: 'item'+(i+1) ,title: ItemDesc, width: ItemDesc.length*20, align: 'left'}
			var colitem  = {field: 'item'+(i+1) ,title: ItemDesc, align: 'left'}
			columns[0].push(colitem);
		}
		var gridResult = $HUI.datagrid("#gridResult",{
			fit:true,
			//title:"查询结果",
			headerCls:'panel-header-gray',
			iconCls:'icon-paper',
			singleSelect:true,
			pagination: true, 		//如果为true, 则在DataGrid控件底部显示分页工具栏
			rownumbers: true,		//如果为true, 则显示一个行号列
			autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
			loadMsg:'数据加载中...',
			pageSize: 500,
			pageList:[100,200,500,1000],
			fitColumns:false,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
			url:$URL,
			queryParams:{
				ClassName:"MA.IPMR.FPS.MQQry",
				QueryName:"QryOutputRst",
				aPlanID:planid,
				aDateFrom:$("#dfDateFrom").datebox('getValue'),
				aDateTo:$("#dfDateTo").datebox('getValue'),
				aHospID:$("#cboHospital").combobox('getValue'),
				rows:10000
			},toolbar:[{
				text:'导出',
				iconCls: 'icon-export',
				handler:function(){
					var data = $('#gridResult').datagrid('getData');
					if (data.rows.length==0)
					{
						$.messager.popover({msg: '请先查询再导出！',type: 'alert',timeout: 1000});
						return;
					}
					//$('#gridResult').datagrid('Export', {
					//替换为xlsx.full.min.js导出
					$('#gridResult').datagrid('exportByJsxlsx', {
						filename: '综合查询',
						extension:'xls'
					});
				}
			},{
				text:'编目',
				iconCls: 'icon-edit',
				handler:function(){
					var selData	= $('#gridResult').datagrid('getSelections');
					var selLen	= selData.length;
					if (selLen==0) {
						$.messager.popover({msg: '请选择一查询结果！',type: 'alert',timeout: 1000});
						return;
					}
					var selRowArray = selData[0];
					var EpisodeID = selRowArray.EpisodeID;
					
					var strURL = "./ma.ipmr.fp.frontpage.main.csp?EpisodeID=" + EpisodeID;
					/*
					var iWidth=(window.screen.availWidth-10)*0.6;                         //弹出窗口的宽度;
					var iHeight=(window.screen.availHeight-50)*0.8;                        //弹出窗口的高度;
					var iTop = (window.screen.height-30-iHeight)/2;       //获得窗口的垂直位置;
					var iLeft = (window.screen.width-10-iWidth)/2;        //获得窗口的水平位置;
					window.open(strURL,"_blank", "height="+iHeight+",width="+iWidth+',top='+iTop+',left='+iLeft+",status=yes,toolbar=no,menubar=no,scrollbars=yes");
					*/
					 var title='病案编目';
					 websys_showModal({
					 	url:strURL,
					 	title:title,
					 	iconCls:'icon-w-epr',  
					 	originWindow:window,
					 	width:'100%',
					 	height:'100%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
					 });
					
				}
			}],
			columns :columns
		});
    });
	var resultDiag = $HUI.dialog('#resultDiag', {
		title: '查询结果',
		iconCls: 'icon-w-list',
		width: 1200,
        height: 650,
	    minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
	    closed: false,
	    cache: false,
	    modal: true
	});
}

function cbgToDataItem(){
	var ItemCode	= arguments[0];
	var ItemCat		= arguments[1];
	var IsShowCode	= arguments[2];
	var HospID		= arguments[3];
	var LinkCmp	    = arguments[4];
	if (typeof(ItemCode)=='undefined') ItemCode='';
	if (typeof(ItemCat)=='undefined') ItemCat='';
	if (typeof(IsShowCode)=='undefined') IsShowCode='';
	if (typeof(HospID)=='undefined') HospID='';
	if (typeof(LinkCmp)=='undefined') LinkCmp='';
	var textField = 'Desc';
	if (IsShowCode=='1') {
		textField = 'Code';
	}
	var cbox = $HUI.combogrid("#"+ItemCode, {
		url: $URL,
		panelWidth:300,
		panelHeight:250,
		editable: true,
		defaultFilter:4, 
		idField:textField,
		textField: textField,
		method:'Post',
		mode:'remote',
		multiple: false,
		enterNullValueClear:false,
		fitColumns:true,
		hasDownArrow:true,
		pageSize: 10000,
		delay:200,
		columns:[[
		    {field:'Code',title:'代码',width:50},
		    {field:'Desc',title:'描述',width:200}
		   ]],
		queryParams:{
		   ClassName:'MA.IPMR.FPS.DataMasterSrv',
			QueryName:'QryDic',
			aDataItemCat:ItemCat,
			aHospID:HospID,
			aAlias:'',
			aLinkValue:'',
			rows:1000
		},
		keyHandler: {
			enter: function (e) {
			},
			up: function (e) {
				e.preventDefault();
			},
			down: function (e) {
				e.preventDefault();
			},
			query: function (q) {
				var queryParams=$(this).combogrid('options').queryParams;
				$(this).combogrid("grid").datagrid('load', {
					ClassName:queryParams.ClassName,
					QueryName:queryParams.QueryName,
					aDataItemCat:queryParams.aDataItemCat,
					aHospID:queryParams.aHospID,
					aAlias:q,
					aLinkValue:''
				});
				$(this).combogrid("setValue",q);
			}
		}
	});
	return  cbox;
}

function ComboICD(verId,id,IsShowCode){
	var textField = 'Desc';
	if (IsShowCode=='1') {
		textField = 'ICD10';
	}
	var cbg = $HUI.combogrid("#"+id, {
		url: $URL,
		idField:textField,
		textField: textField,
		mode:'remote',
		fitColumns:true,
		panelWidth:600,
		panelHeight:350,
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
		},
		keyHandler: {
			up: function(e) {
				e.preventDefault();
			},
			down: function(e) {
				e.preventDefault();
			},
			enter: function(e) {
			},
			query: function(q,e) {
				var queryParams=$(this).combogrid('options').queryParams;
				$(this).combogrid("grid").datagrid('load', {
					ClassName:queryParams.ClassName,
					QueryName:queryParams.QueryName,
					aVerID:queryParams.aVerID,
					aTypeID:queryParams.aTypeID,
					aAlias:q,
					aIsActive:queryParams.aIsActive,
					aICDDxID:queryParams.aICDDxID,
					rows:10000
				});
				$(this).combogrid("setValue",q);
			}
		}
	});
	return cbg;
}

function renderTextVal(dataType,DataItemCat,ShowCode) {
	if (dataType=='DIC') {
		globalObj.m_dynamicElType = 'Combo';
		$('#dynamicEl').empty();
		var html = '<input class="hisui-combobox textbox" id="textVal"  style="width:300px;"></input>'
		$('#dynamicEl').append(html);
		cbgToDataItem('textVal',DataItemCat,ShowCode);
	}else if (dataType=='ICD') {
		globalObj.m_dynamicElType = 'Combo';
		var fpConfigID = $("#cboCodeConfig").combobox('getValue');
		if (fpConfigID=='') {
			$.messager.popover({msg: '请选择编目版本！',type: 'alert',timeout: 1000});
			return;
		}
		$('#dynamicEl').empty();
		var html = '<input class="hisui-combobox textbox" id="textVal"  style="width:300px;"></input>'
		$('#dynamicEl').append(html);
		// 获取版本配置
		$cm({
			ClassName:"CT.IPMR.FP.Config",
			MethodName:"GetObjById",
			aId:fpConfigID
		},function(rtn){
			var ICDVer = rtn.FCICDVer 		// 西医诊断
			var OprVer = rtn.FCOprVer		// 手术
			var ICDVer2 = rtn.FCICDVer2	// 中医诊断
			/*D10-D14 中医诊断*/
			if ((DataItemCat.indexOf('D10')>-1)
				||(DataItemCat.indexOf('D11')>-1)
				||(DataItemCat.indexOf('D12')>-1)
				||(DataItemCat.indexOf('D13')>-1)
				||(DataItemCat.indexOf('D14')>-1)
			) {
				ComboICD(ICDVer2,'textVal',ShowCode);
			}else if (DataItemCat.indexOf('O')>-1) {	// 手术
				ComboICD(OprVer,'textVal',ShowCode);
			}else{	// 西医 
				ComboICD(ICDVer,'textVal',ShowCode);
			}
		});
	}else{
		globalObj.m_dynamicElType = 'Textbox';
		$('#dynamicEl').empty();
		var html = '<input class="hisui-textbox textbox" id="textVal"  style="width:293px;"></input>'
		$('#dynamicEl').append(html)
		$('#textVal').val('');
	}
}

function loadAuthority(){
	globalObj.m_limitedit = '0';
	var selected = $("#gridPlan").datagrid('getSelected');
	if (selected){
		if ((ServerObj.IsLimitMQEdit=='1')&&(selected.UserID!=Logon.UserID)){
			globalObj.m_limitedit = '1';
		}
	}
	if (globalObj.m_limitedit=='1'){
		$('#t-planedit').linkbutton("disable");
		$('#t-plandelete').linkbutton("disable");
		$('#t-columnadd').linkbutton("disable");
		$('#t-columnup').linkbutton("disable");
		$('#t-columndown').linkbutton("disable");
	}else{
		$('#t-planedit').linkbutton("enable");
		$('#t-plandelete').linkbutton("enable");
		$('#t-columnadd').linkbutton("enable");
		$('#t-columnup').linkbutton("enable");
		$('#t-columndown').linkbutton("enable");
	}
}