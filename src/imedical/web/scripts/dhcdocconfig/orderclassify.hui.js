/**
 * orderclassify.hui.js 医嘱归类HUI
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2018-08-10
 * 
 * 注解说明
 * TABLE: 
 */
//页面全局变量
var PageLogicObj = {
	m_TreeGrid: "",
	m_ArcimCombox:"",
	m_SearchGrid: "",
	m_TreeWin:"",
	m_DocToDo_TimeRangeList:"",
	m_DocToDo_ListFunc:""
}
$(function(){
	InitHospList();
	//初始化
	//Init();
	//事件初始化
	InitEvent();
	//页面元素初始化
	//PageHandle();
})
var PUBLIC_CONSTANT={
	SESSION:{
		GROUP_ROWID : session['LOGON.GROUPID'],
        GROUP_DESC : session['LOGON.GROUPDESC'],
        GUSER_ROWID : session['LOGON.USERID'],
        GUSER_NAME : session['LOGON.USERNAME'],
        GUSER_CODE : session['LOGON.USERCODE'],
        GCTLOC_ROWID : session['LOGON.CTLOCID']
	},
	URL:{
		QUERY_GRID_URL : "./dhcdoc.config.query.grid.easyui.csp",
		QUERY_COMBO_URL : "./dhcdoc.config.query.combo.easyui.csp",
		METHOD_URL : "./dhc.method.easyui.csp"
	}
};
var OrderClassifyGrid,
	ClassifyDetailGrid,
	OrderKindTreeGrid,
	editRow1,
	editRow2,
	editRow3,
	editRow4,
	editRow5;

function Init() {
	
	InitOrderClassify();
	InitClassifyDetailGrid();
	InitTab();
	LoadCenMainPage();
	InitCache();
}
function InitHospList()
{
	var hospComp = GenHospComp("Doc_Config_OrderClassify");
	hospComp.jdata.options.onSelect = function(e,t){
		LoadCenMainPage();
		$("#orderclassify").datagrid("reload");
		var HospID=$HUI.combogrid('#_HospList').getValue();
		if ((!HospID)||(HospID=="")) {
			HospID=session['LOGON.HOSPID'];
		}
		if (PageLogicObj.m_TreeGrid != "") {
			
			$("#OrderKind").treegrid('unselectAll');
			$.cm({
				ClassName:"DHCDoc.DHCDocConfig.OrderClassify",
				MethodName:"LoadOrderKind",
				EpisodeID:"",
				HospId:HospID
			},function(data){
				$HUI.treegrid("#OrderKind").loadData(data);
			})
		}
		var tab = $('#i-tab').tabs('getSelected');
		var index = $('#i-tab').tabs('getTabIndex',tab);
		
		if (index==2){
			hiddenMainPage();
			$("#c-con").addClass("c-hidden");
			$("#c-con-2").removeClass("c-hidden");
			
			$('#orderClassify_layout').layout('panel', 'center').panel('setTitle',"数据项配置列表");
		}
		if (PageLogicObj.m_DocToDo_TimeRangeList != "") {
			PageLogicObj.m_DocToDo_TimeRangeList.datagrid("reload");
		}
		if (PageLogicObj.m_DocToDo_ListFunc != "") {
			PageLogicObj.m_DocToDo_ListFunc.datagrid("reload");
		}
		editRow1 = undefined;
		editRow2 = undefined;
		editRow3 = undefined;
		editRow4 = undefined;
		editRow5 = undefined;
		
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}
function InitEvent() {
	
}
function InitCache(){
	var hasCache = $.DHCDoc.ConfigHasCache();
	if (hasCache!=1) {
		$.DHCDoc.CacheConfigPage();
		$.DHCDoc.storageConfigPageCache();
	}
}
function InitTab() {
	$HUI.tabs("#i-tab", {
		fit:true,
		onSelect: function (title,index) {
			$('#orderClassify_layout').layout('panel', 'center').panel('setTitle',"提示和数据");
			$("#c-con-2").addClass("c-hidden");
			if (index == 0) {
				showMainPage();
				$("#tip-one").addClass("bk");
				$("#tip-two").removeClass("bk");
				$("#tip-three").removeClass("bk");
			}else if (index == 1) {
				if (PageLogicObj.m_TreeGrid == "") {
					InitOrderKindGrid();
				}
				showMainPage();
				$("#tip-one").removeClass("bk");
				$("#tip-two").addClass("bk");
				$("#tip-three").removeClass("bk");
				//$("#orderclassify").datagrid("rejectChanges");
				$("#orderclassify").datagrid("unselectAll");
			}else if (index == 2) {
				hiddenMainPage();
				$("#c-con").addClass("c-hidden");
				$("#c-con-2").removeClass("c-hidden");
				if (PageLogicObj.m_DocToDo_TimeRangeList == "") {
					Init_DocToDo_TimeRangeList();
				}
				if (PageLogicObj.m_DocToDo_ListFunc == "") {
					Init_DocToDo_ListFunc();
				}
				$('#orderClassify_layout').layout('panel', 'center').panel('setTitle',"数据项配置列表");
				$("#tip-one").removeClass("bk");
				$("#tip-two").removeClass("bk");
				$("#tip-three").addClass("bk");
			}
			
			
			
		}
	});
}

function LoadCenMainPage () {
	showMainPage();
	var cenPanel = $HUI.panel("#cenPanel",{
		title:"操作提醒",
		fit:true,
		iconCls:'icon-w-edit',
		collapsible:false
	});
}

function hiddenMainPage() {
	var hasHidden = $("#main").hasClass("c-hidden");
	if (!hasHidden) {
		$("#main").addClass("c-hidden");
	}
	$("#c-con").removeClass("c-hidden");
}

function showMainPage() {
	var hasHidden = $("#main").hasClass("c-hidden");
	if (hasHidden) {
		$("#main").removeClass("c-hidden");
	};
	
	$("#c-con").addClass("c-hidden");
}


//加载左侧：病人在院长嘱归类
function InitOrderClassify(){
	var OrderClassifyToolBar = [{
		text: '添加',
		iconCls: 'icon-add',
		handler: function() { //添加列表的操作按钮添加,修改,删除等
			//editRow1 = undefined
			showMainPage();
			OrderClassifyGrid.datagrid('unselectAll');
			if (editRow1 != undefined) {
				return;
			}else{
				editRow1 = 0;
				OrderClassifyGrid.datagrid("insertRow", {
					index: 0,
					row: {}
				});
				OrderClassifyGrid.datagrid("beginEdit", 0);
			}
		  
		}
	}, {
		text: '删除',
		iconCls: 'icon-cancel',
		handler: function() {
			var rows = OrderClassifyGrid.datagrid("getSelections");
			if (rows.length > 0) {
				if ((!rows[0].ClassifyCode)||(rows[0].ClassifyCode=="")){
					editRow1 = undefined;
					OrderClassifyGrid.datagrid("rejectChanges");
					OrderClassifyGrid.datagrid("unselectAll");
					return false;
					}
				$.messager.confirm("提示", "你确定要删除吗?",
				function(r) {
					if (r) {
						var ClassifyCodeS = [];
						for (var i = 0; i < rows.length; i++) {
							ClassifyCodeS.push(rows[i].ClassifyCode);
						}
						var ClassifyCodeStr=ClassifyCodeS.join(',')
						var HospID=$HUI.combogrid('#_HospList').getValue();
						if ((!HospID)||(HospID=="")) {
							HospID=session['LOGON.HOSPID'];
						}
						$.dhc.util.runServerMethod("DHCDoc.DHCDocConfig.OrderClassify","DelOrderClassify","false",function testget(value){
							if(value=="0"){
							   OrderClassifyGrid.datagrid('load');
							   OrderClassifyGrid.datagrid('unselectAll');
							   $.messager.show({title:"提示",msg:"删除成功"});
							   showMainPage();
							}else{
							   $.messager.alert('提示',"删除失败:"+value);
							}
							editRow1 = undefined;
					   },"","",ClassifyCodeStr,HospID);
					}
				});
			} else {
				$.messager.alert("提示", "请选择要删除的行", "error");
			}
		}
	}, {
		text: '保存',
		iconCls: 'icon-save',
		handler: function() {
			if (editRow1 == undefined){
				 $.messager.show({title:"提示",msg:"没有需要保存的数据"});  
			}
			var editors = OrderClassifyGrid.datagrid('getEditors', editRow1); 
			var rows = OrderClassifyGrid.datagrid("selectRow",editRow1).datagrid("getSelected");			
			var OrderClassifyCode=editors[0].target.val();
			var OrderClassifyDesc=editors[1].target.val();
			if ((OrderClassifyCode=="")||(OrderClassifyDesc=="")){
				$.messager.alert('提示',"数据为空,无法保存!");
				return false;
			}
			var HospID=$HUI.combogrid('#_HospList').getValue();
			if ((!HospID)||(HospID=="")) {
				HospID=session['LOGON.HOSPID'];
			}
			var value=tkMakeServerCall("DHCDoc.DHCDocConfig.OrderClassify","InsertOrderClassify",OrderClassifyCode,OrderClassifyDesc,HospID)
			if(value.split("^")[0]=="0"){
				OrderClassifyGrid.datagrid("endEdit", editRow1);
				editRow1 = undefined;
				OrderClassifyGrid.datagrid('load');
				OrderClassifyGrid.datagrid('unselectAll');
				$.messager.show({title:"提示",msg:"保存成功"});        					
			}else if(value.split("^")[0]=="-101"){
				$.messager.alert('提示',"保存失败,记录重复!");
				return false;
			}else{
				$.messager.alert('提示',"保存失败:"+value);
				return false;
			}
			editRow1 = undefined;
			
			
		}
	},{
		text: '取消编辑',
		iconCls: 'icon-redo',
		handler: function() {
			editRow1 = undefined;
			OrderClassifyGrid.datagrid("rejectChanges");
			OrderClassifyGrid.datagrid("unselectAll");
		}
	}];
	
	 var OrderClassifyColumns=[[ 
				{field:'Index',hidden:true},
				{field:'ClassifyCode',title:'代码',width:200,editor : {type : 'text'}},
				{field:'ClassifyDesc',title:'描述',width:200,editor : {type : 'text'}}
			 ]];
	OrderClassifyGrid = $("#orderclassify").datagrid({  
		fit : true,
		//width : 1500,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '加载中..',  
		pagination : false,  //
		rownumbers : true,  //
		columns :OrderClassifyColumns,
		toolbar :OrderClassifyToolBar,
		pageSize:50,
		onSelect : function(rowIndex, rowData) {
			hiddenMainPage();
		},
		onLoadSuccess:function(data){  
		},
		onClickRow:function(rowIndex, rowData){
			if (rowData.ClassifyCode=="EkgOrd"){
				ClassifyDetailGrid.datagrid('showColumn','NeedOutData')
			}else{
				ClassifyDetailGrid.datagrid('hideColumn','NeedOutData')
			}
			if ((!rowData.ClassifyCode)||(rowData.ClassifyCode == "")){
				$.messager.alert('提示',"请先保存或者更取消编辑数据"); 
				showMainPage();
			}else{
				ClassifyDetailGrid.datagrid('reload');
				}
		},
		onDblClickRow:function(rowIndex, rowData){
			if (editRow1!=undefined){
				$.messager.alert('提示',"只允许编辑一行数据");
				return
			}
			editRow1=rowIndex
			OrderClassifyGrid.datagrid("beginEdit", rowIndex);
			var editors = OrderClassifyGrid.datagrid('getEditors', editRow1);
			editors[0].target.attr("disabled",true);
		},
		onBeforeLoad:function(queryParams){
			var HospID=$HUI.combogrid('#_HospList').getValue();
			if ((!HospID)||(HospID=="")) {
				HospID=session['LOGON.HOSPID'];
			}
			editRow1=undefined;
			queryParams.ClassName ='DHCDoc.DHCDocConfig.OrderClassify';
			queryParams.QueryName ='FindOrderClassify';
			queryParams.Arg1=HospID;
			queryParams.ArgCnt =1;
		}
	});
	
}
	
function InitClassifyDetailGrid(){
	var ClassifyDetailToolBar = [{
		text: '添加',
		iconCls: 'icon-add',
		handler: function() { //添加列表的操作按钮添加,修改,删除等
			//editRow2 = undefined
			ClassifyDetailGrid.datagrid('unselectAll');
			if (editRow2 != undefined) {
				return;
			}else{
				editRow2 = 0;
				ClassifyDetailGrid.datagrid("insertRow", {
					index: 0,
					row: {}
				});
				ClassifyDetailGrid.datagrid("beginEdit", 0);
			}
		}
	},{
		text: '删除',
		iconCls: 'icon-cancel',
		handler: function() {
			var Mainrows = OrderClassifyGrid.datagrid("getSelections");
			if (Mainrows.length!= 1){
				$.messager.show({title:"提示",msg:"请选择医嘱归类"});  
				return;
			}
			var ClassifyCode=Mainrows[Mainrows.length-1].ClassifyCode;
			var rows = ClassifyDetailGrid.datagrid("getSelections");
			if (rows.length!= 1){
				$.messager.show({title:"提示",msg:"请选择医嘱项"});  
				return;
			}
			var Index=rows[rows.length-1].Index;
			var Params=ClassifyCode+"^"+Index;
			var HospID=$HUI.combogrid('#_HospList').getValue();
			if ((!HospID)||(HospID=="")) {
				HospID=session['LOGON.HOSPID'];
			}
			$.dhc.util.runServerMethod("DHCDoc.DHCDocConfig.OrderClassify","DelClassifyDetail","false",function testget(value){
				if(value=="0"){
				   ClassifyDetailGrid.datagrid('load');
				   ClassifyDetailGrid.datagrid('unselectAll');
				   $.messager.show({title:"提示",msg:"删除成功"});
				}else{
				   $.messager.alert('提示',"删除失败:"+value);
				}
				editRow2 = undefined;
		   },"","",Params,HospID);
		}
	}, {
		text: '保存',
		iconCls: 'icon-save',
		handler: function() {
			if (editRow2 == undefined){
				 $.messager.show({title:"提示",msg:"没有需要保存的数据"}); 
				 return; 
			}
			var editors = ClassifyDetailGrid.datagrid('getEditors', editRow2); 
			var rows = ClassifyDetailGrid.datagrid("selectRow",editRow2).datagrid("getSelected");
			var Index=rows.Index;
			if (Index==undefined){Index=""}
			var ARCIMDR=rows.ARCIMDR;
			if (ARCIMDR==""){
				$.messager.show({title:"提示",msg:"请配置医嘱项目"});  
				return;
			}
			var Mainrows = OrderClassifyGrid.datagrid("getSelections");
			if (Mainrows.length<=0){
				$.messager.show({title:"提示",msg:"请选择医嘱归类"});  
				return;
			}
			var ClassifyCode=Mainrows[Mainrows.length-1].ClassifyCode;
			
			var NeedOutData =  editors[1].target.is(':checked');
			if (NeedOutData) NeedOutData="Y";
			else NeedOutData="N";
			var Params=ClassifyCode+"^"+Index+"^"+ARCIMDR+"^"+NeedOutData;
			//return
			var HospID=$HUI.combogrid('#_HospList').getValue();
			if ((!HospID)||(HospID=="")) {
				HospID=session['LOGON.HOSPID'];
			}
			var value=tkMakeServerCall("DHCDoc.DHCDocConfig.OrderClassify","InsertClassifyDetail",Params,HospID)
			if(value.split("^")[0]=="0"){
				ClassifyDetailGrid.datagrid("endEdit", editRow2);
				editRow2 = undefined;
				ClassifyDetailGrid.datagrid('unselectAll').datagrid('load');
				$.messager.show({title:"提示",msg:"保存成功"});        					
			}else if(value.split("^")[0]=="-101"){
				$.messager.alert('提示',"保存失败！记录重复！");
				return false;
			}else{
				$.messager.alert('提示',"保存失败："+value);
				return false;
			}
			editRow2 = undefined;
		}
	}, {
		text: '取消编辑',
		iconCls: 'icon-redo',
		handler: function() {
			editRow2 = undefined;
			ClassifyDetailGrid.datagrid("rejectChanges");
			ClassifyDetailGrid.datagrid("unselectAll");
		}
	}, {
		text: '按子类批量添加',
		iconCls: 'icon-batch-add',
		handler: function() {
			var HospID=$HUI.combogrid('#_HospList').getValue();
			if ((!HospID)||(HospID=="")) {
				HospID=session['LOGON.HOSPID'];
			}
			var Mainrows = OrderClassifyGrid.datagrid("getSelections");
			if (Mainrows.length<=0){
				$.messager.show({title:"提示",msg:"请选择医嘱归类"});  
				return;
			}
			var Index=""
			var ClassifyCode=Mainrows[Mainrows.length-1].ClassifyCode;
			websys_showModal({
				url:"dhcdoc.util.tablelist.csp?TableName=ARC_ItemCat&HospDr="+HospID,
				title:' 子类选择',
				width:400,height:610,
				closable:false,
				CallBackFunc:function(result){
					websys_showModal("close");
					if ((typeof result=="undefined")||(result==false)){
						return;
					}
					if (result==""){
						$.messager.alert('提示',"未选中数据");
						return false;
					}
					var ArcimStr =tkMakeServerCall("DHCDoc.DHCDocConfig.ItemCat","GetArcimStrByARCCat",result,HospID)
					var NeedOutData =  "N";
					var Params=ClassifyCode+"^"+Index+"^"+ArcimStr+"^"+NeedOutData;
					
					var value=tkMakeServerCall("DHCDoc.DHCDocConfig.OrderClassify","InsertClassifyDetail",Params,HospID)
					if(value.split("^")[0]=="0"){
						ClassifyDetailGrid.datagrid('unselectAll').datagrid('load');
						$.messager.show({title:"提示",msg:"保存成功"});        					
					}else{
						$.messager.alert('提示',"保存失败："+value);
						return false;
					}

				}
			})
		}
	}];
	 var ClassifyDetailColumns=[[ 
				{field:'Index',hidden:true},
				{field:'ARCIMDR',hidden:true},
				{ field: 'ArcimDesc', title: '医嘱项名称',width:300,align: 'left', sortable: true, 
					editor:{
		              		type:'combogrid',
		                    options:{
			                    enterNullValueClear:false,
								required: true,
								panelWidth:450,
								panelHeight:350,
								delay:500,
								idField:'ArcimRowID',
								textField:'ArcimDesc',
								value:'',//缺省值 
								mode:'remote',
								pagination : true,//是否分页   
								rownumbers:true,//序号   
								collapsible:false,//是否可折叠的   
								fit: true,//自动大小   
								pageSize: 10,//每页显示的记录条数，默认为10   
								pageList: [10],//可以设置每页记录条数的列表  
								url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ArcItemConfig&QueryName=FindAllItem",
	                            columns:[[
	                                {field:'ArcimDesc',title:'名称',width:310,sortable:true},
					                {field:'ArcimRowID',title:'ID',width:100,sortable:true},
					                {field:'selected',title:'ID',width:120,sortable:true,hidden:true}
	                             ]],
								onSelect: function (rowIndex, rowData){
									var rows=$("#classifyDetail").datagrid("selectRow",editRow2).datagrid("getSelected");
									rows.ARCIMDR=rowData.ArcimRowID
								},
								onClickRow: function (rowIndex, rowData){
									var rows=$("#classifyDetail").datagrid("selectRow",editRow2).datagrid("getSelected");
									rows.ARCIMDR=rowData.ArcimRowID
								},
								onLoadSuccess:function(data){
									$(this).next('span').find('input').focus();
								},
								onBeforeLoad:function(param){
									if (param['q']) {
										var desc=param['q'];
									}
									param = $.extend(param,{Alias:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
								}
                    		}
	        			  }
				},
				{field : 'NeedOutData',title : '需要外部数据（非医嘱数据）',hidden:true,
					   editor : {
							type : 'icheckbox',
							options : {
								on : 'Y',
								off : ''
							}
						}
				 }
			 ]];
	ClassifyDetailGrid=$("#classifyDetail").datagrid({  
		fit : true,
		//width : 1500,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '加载中..',  
		rownumbers : true,  //
		pagination : true,  //
		remoteSort:false,
		//pageSize:20,
		//pageList : [15,100,200],
		columns :ClassifyDetailColumns,
		toolbar :ClassifyDetailToolBar,
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){  
		},
		onClickRow:function(rowIndex, rowData){
		},
		onDblClickRow:function(rowIndex, rowData){
			if (editRow2!=undefined){
				$.messager.alert('提示',"只允许编辑一行数据");
				return
			}
			editRow2=rowIndex
			ClassifyDetailGrid.datagrid("beginEdit", rowIndex);
			
		},
		onBeforeLoad:function(queryParams){
			var HospID=$HUI.combogrid('#_HospList').getValue();
			if ((!HospID)||(HospID=="")) {
				HospID=session['LOGON.HOSPID'];
			}
			editRow2=undefined;
			queryParams.ClassName ='DHCDoc.DHCDocConfig.OrderClassify';
			queryParams.QueryName ='FindClassifyDetails';
			queryParams.Arg1 =function (){
				var rows = OrderClassifyGrid.datagrid("getSelections");
				if (rows.length<=0){
					return "";
				}
				ClassifyCode=rows[rows.length-1].ClassifyCode;
				return ClassifyCode;
			};
			queryParams.Arg2 =HospID;
			queryParams.ArgCnt=2;
			queryParams.rows=9999999;
		}
	});
	
};

function LoadItemData(q,obj1){
	var val = q //$('#Combo_Arcim').combogrid('getValue'); 
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.ArcItemConfig';
	queryParams.QueryName ='FindAllItem';
	queryParams.Arg1 =val;
	queryParams.Arg2="";
	queryParams.Arg3="";
	queryParams.Arg4="";
	queryParams.Arg5="";
	queryParams.Arg6="";
	queryParams.Arg7="";
	queryParams.Arg8=$HUI.combogrid('#_HospList').getValue();
	queryParams.ArgCnt =8;
	var opts = obj1.combogrid("grid").datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	obj1.combogrid("grid").datagrid('load', queryParams);
};


function InitOrderKindGrid(){
	var OrderKindColumns=[[    
		{field:'RowID', hidden:true},  
		{title:'标题',field:'Title',width:180,editor : {
			type : 'text',
			options : {
			}
		}},
		{title:'医嘱项名称',field:'ArcimDesc',width:180},
		{title:'ARCIMDR',field:'ARCIMDR',hidden:false}
	]];
	var OrderKindBar = [
		{
			text: '添加',
			iconCls: 'icon-add',
			handler: function() {
				var node = $('#OrderKind').treegrid('getSelected');
				var RowID="";
				if (node){
					RowID=node.RowID;
				}
				RowID=RowID.toString();
				if (RowID.indexOf("99999")>=0){
					$.messager.alert('提示',"请选中主节点添加或不选择行添加主节点");
					return
				}
				
				//添加医嘱项
				if (RowID!=""){
					
					if($('#tree-dg').hasClass("c-hidden")) {
						$('#tree-dg').removeClass("c-hidden");
					};
					$("#tree-id").val(RowID);
					$("#tree-title").html("新增医嘱项到模板");
					//医嘱项
					PageLogicObj.m_ArcimCombox = $HUI.combogrid("#tree-arcim", {
						panelWidth: 600,
						idField: 'ArcimRowID',
						textField: 'ArcimDesc',
						columns: [[
							{field:'ArcimDesc',title:'医嘱名称',width:200,sortable:true},
							{field:'ArcimRowID',title:'ID',width:100,sortable:true},
						]],
						delay:500,
						pagination : true,
						mode:'remote',
						url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ArcItemConfig&QueryName=FindAllItem&Alias=",
						fitColumns: false,
						enterNullValueClear:true,
						onBeforeLoad:function(param){
							if (param['q']) {
								var desc=param['q'];
							}
							param = $.extend(param,{Alias:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
						},
					});
					PageLogicObj.m_SearchGrid = PageLogicObj.m_ArcimCombox.grid();
					$("#tree-action").val("add");
					var cenWin = $HUI.window('#tree-dg', {
						title: "添加",
						modal: true,
						minimizable:false,
						maximizable:false,
						maximizable:false,
						collapsible:false,
						onClose: function () {
							$('#tree-dg').addClass("c-hidden");
						}
					});
					
					PageLogicObj.m_TreeWin = cenWin;
				}else if ((typeof editRow3=="undefined")||(editRow3=="")){
					editRow3='9999999999';
					$('#OrderKind').treegrid('append',{
						data: [{
							RowID:editRow3,
							Title: ''
						}]
					})
					$('#OrderKind').treegrid('beginEdit',editRow3);
				}
			}
		},{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				
				if (!editRow3){
					return
				}
				$('#OrderKind').treegrid('endEdit',editRow3);
				var EditData=$('#OrderKind').treegrid('find',editRow3);
				if (!EditData){return}
				if (EditData.Title.length>10){
					$.messager.alert("标题过长")
					return
				}
				var HospID=$HUI.combogrid('#_HospList').getValue();
				if ((!HospID)||(HospID=="")) {
					HospID=session['LOGON.HOSPID'];
				}
				$.ajax({
					type: 'POST',
					dataType: 'json',
					url: '../DHCDoc.DHCDocConfig.OrderClassify.cls',
					async: false,
					cache: false,
					data: {
						action: 'InserOrderKindMain',
						MainRowID: EditData.RowID,
						Title: EditData.Title,
						HospId:HospID,
                        MWToken:('undefined'!==typeof websys_getMWToken)?websys_getMWToken():""
					},
					success: function (data){
						$('#OrderKind').treegrid("reload");
						editRow3="";
					},
					error : function (ret) {
						alert("err:" + ret);
					}
				}) 
			}
		},{
			text: '删除',
			iconCls: 'icon-cancel',
			handler: function() {
				var node = $('#OrderKind').treegrid('getSelected');
				if (!node){
					$.messager.alert("提示","请选择需要编辑的行","info");
					return
				}
				var RowID=node.RowID;
				
				$.messager.confirm("提示", "确认删除吗？", function(r) {
					var HospID=$HUI.combogrid('#_HospList').getValue();
					if ((!HospID)||(HospID=="")) {
						HospID=session['LOGON.HOSPID'];
					}
					if (r) {
						$.ajax({
							type: 'POST',
							dataType: 'json',
							url: '../DHCDoc.DHCDocConfig.OrderClassify.cls',
							async: false,
							cache: false,
							data: {
								action: 'DelOrderKind',
								RowID: RowID,
								HospId:HospID,
                                MWToken:('undefined'!==typeof websys_getMWToken)?websys_getMWToken():""
							},
							success: function (data){
								$('#OrderKind').treegrid("reload");
								EditRowID="";
							},
							error : function (ret) {
								alert("err:" + ret);
							}
						}) 
					}
				});
			}
		},{
			text: '取消编辑',
			iconCls: 'icon-redo',
			handler: function() {
				editRow3 = undefined;
				PageLogicObj.m_TreeGrid.reload()
				PageLogicObj.m_TreeGrid.unselectAll();
			}
		}, {
			text: '按子类批量添加',
			iconCls: 'icon-batch-add',
			handler: function() {

				var node = $('#OrderKind').treegrid('getSelected');
				var RowID="";
				if (node){
					RowID=node.RowID;
				}
				RowID=RowID.toString();
				RowID=RowID.split("99999")[0];
				if (RowID==""){
					$.messager.alert('提示',"请选中主节点添加");
					return
				}

				var HospID=$HUI.combogrid('#_HospList').getValue();
				if ((!HospID)||(HospID=="")) {
					HospID=session['LOGON.HOSPID'];
				}
				
				websys_showModal({
					url:"dhcdoc.util.tablelist.csp?TableName=ARC_ItemCat&HospDr="+HospID,
					title:' 子类选择',
					width:400,height:610,
					closable:false,
					CallBackFunc:function(result){
						websys_showModal("close");
						if ((typeof result=="undefined")||(result==false)){
							return;
						}
						if (result==""){
							$.messager.alert('提示',"未选中数据");
							return false;
						}
						var ArcimStr =tkMakeServerCall("DHCDoc.DHCDocConfig.ItemCat","GetArcimStrByARCCat",result,HospID)
						var NeedOutData =  "N";
						var value=tkMakeServerCall("DHCDoc.DHCDocConfig.OrderClassify","InserOrderKindSub",RowID,"",ArcimStr,HospID)
						if(value.split("^")[0]=="0"){
							PageLogicObj.m_TreeGrid.reload().unselectAll();
							$.messager.show({title:"提示",msg:"保存成功"});        					
						}else{
							$.messager.alert('提示',"保存失败："+value);
							return false;
						}

					}
				})
			}
		}
	];
	var HospID=$HUI.combogrid('#_HospList').getValue();
	if ((!HospID)||(HospID=="")) {
		HospID=session['LOGON.HOSPID'];
	}
	PageLogicObj.m_TreeGrid = $HUI.treegrid("#OrderKind", {
		url:'../DHCDoc.DHCDocConfig.OrderClassify.cls?action=LoadOrderKind&EpisodeID=&HospId='+HospID,
		idField:'RowID',    
		treeField:'Title',
		fit : true,
		fitColumns:true,
		border: false,   
		toolbar :OrderKindBar,
		columns:OrderKindColumns,
		onDblClickRow :function(node){
			if (editRow3 && editRow3!=""){
				$.messager.alert("提示","正在编辑行，请先保存。");
				return;
			}
			var selected = PageLogicObj.m_TreeGrid.getSelected();
			var ARCIMDR=selected.ARCIMDR;
			if (ARCIMDR !="" ) { 
				var tipDesc = '将医嘱项 "' + selected.ArcimDesc + '" 修改为：'
				
				if($('#tree-dg').hasClass("c-hidden")) {
					$('#tree-dg').removeClass("c-hidden");
				};
				
				$("#tree-title").html(tipDesc);
				$("#tree-action").val("edit");
				$("#tree-id").val(selected.RowID);
				
				
				
					
				//医嘱项
				PageLogicObj.m_ArcimCombox = $HUI.combogrid("#tree-arcim", {
					panelWidth: 600,
					idField: 'ArcimRowID',
					textField: 'ArcimDesc',
					columns: [[
						{field:'ArcimDesc',title:'医嘱名称',width:200,sortable:true},
						{field:'ArcimRowID',title:'ID',width:100,sortable:true},
					]],
					pagination : true,
					mode:'remote',
					url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ArcItemConfig&QueryName=FindAllItem&Alias=",
					fitColumns: false,
					enterNullValueClear:true,
					onBeforeLoad:function(param){
						if (param['q']) {
							var desc=param['q'];
						}
						param = $.extend(param,{Alias:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
					},
				});
				PageLogicObj.m_SearchGrid = PageLogicObj.m_ArcimCombox.grid();

				var cenWin = $HUI.window('#tree-dg', {
					title: "添加",
					///iconCls: _icon,
					modal: true,
					minimizable:false,
					maximizable:false,
					maximizable:false,
					collapsible:false,
					onClose: function () {
						$('#tree-dg').addClass("c-hidden");
					}
				});
				PageLogicObj.m_TreeWin = cenWin;
			} else {
				editRow3 = selected.RowID;
				$('#OrderKind').treegrid('beginEdit',editRow3);
			}
		},
		onBeforeLoad:function(row, param){
			param.HospId=$HUI.combogrid('#_HospList').getValue();
		}
	});
}

function saveTree() {
	var ac = $("#tree-action").val();
	var RowID = $("#tree-id").val();
	var NewItemID = PageLogicObj.m_ArcimCombox.getValue();
	var MainRowID = SubIndex = "";
	if (NewItemID == "") {
		$.messager.alert("提示", "请先选择医嘱项！", "info");
		return false;
	}
	if (ac == "add") {
		var HospID=$HUI.combogrid('#_HospList').getValue();
		if ((!HospID)||(HospID=="")) {
			HospID=session['LOGON.HOSPID'];
		}
		$.ajax({
			type: 'POST',
			dataType: 'json',
			url: '../DHCDoc.DHCDocConfig.OrderClassify.cls',
			async: false,
			cache: false,
			data: {
				action: 'InserOrderKindSub',
				MainRowID: RowID,
				ARCIMDR:NewItemID,
				HospId:HospID,
                MWToken:('undefined'!==typeof websys_getMWToken)?websys_getMWToken():""
			},
			success: function (data){
				PageLogicObj.m_TreeWin.close();
				$('#OrderKind').treegrid("reload");
				editRow3="";
			},
			error : function (ret) {
				alert("err:" + ret);
			}
		}) 
	} else {
		var HospID=$HUI.combogrid('#_HospList').getValue();
		if ((!HospID)||(HospID=="")) {
			HospID=session['LOGON.HOSPID'];
		}
		MainRowID = RowID.split("99999")[0];
		SubIndex = RowID.split("99999")[1];
		$.ajax({
			type: 'POST',
			dataType: 'json',
			url: '../DHCDoc.DHCDocConfig.OrderClassify.cls',
			async: false,
			cache: false,
			data: {
				action: 'InserOrderKindSub',
				MainRowID: MainRowID,
				SubIndex:SubIndex,
				ARCIMDR:NewItemID,
				HospId:HospID,
                MWToken:('undefined'!==typeof websys_getMWToken)?websys_getMWToken():""
			},
			success: function (data){
				PageLogicObj.m_TreeWin.close();
				$('#OrderKind').treegrid("reload");
				editRow3="";
			},
			error : function (ret) {
				alert("err:" + ret);
			}
		})
	}	
		
}

function BodykeydownHandler(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
	//浏览器中Backspace不可用  
   var keyEvent;   
   if(e.keyCode==8){   
       var d=e.srcElement||e.target;
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
        }else{   
            keyEvent=true;   
        }   
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        e.preventDefault();   
    }   
}
/***
  **Description      :加载医疗待办_时段信息
***/
function Init_DocToDo_TimeRangeList() {
	var ToolBar = [{
		text: '添加',
		iconCls: 'icon-add',
		handler: function() { //添加列表的操作按钮添加,修改,删除等
			PageLogicObj.m_DocToDo_TimeRangeList.datagrid('unselectAll');
			if (editRow4 != undefined) {
				return;
			}else{
				editRow4 = 0;
				PageLogicObj.m_DocToDo_TimeRangeList.datagrid("insertRow", {
					index: 0,
					row: {}
				});
				PageLogicObj.m_DocToDo_TimeRangeList.datagrid("beginEdit", 0);
			}
		}
	}, {
		text: '删除',
		iconCls: 'icon-cancel',
		handler: function() {
			var rows = PageLogicObj.m_DocToDo_TimeRangeList.datagrid("getSelections");
			if (rows.length > 0) {
				if (!rows[0].TimeRangeStartTime){
					editRow4 = undefined;
					PageLogicObj.m_DocToDo_TimeRangeList.datagrid("rejectChanges");
					PageLogicObj.m_DocToDo_TimeRangeList.datagrid("unselectAll");
					return 
					}
				$.messager.confirm("提示", "你确定要删除吗?",
				function(r) {
					if (r) {
						var IndexS = [];
						for (var i = 0; i < rows.length; i++) {
							IndexS.push(rows[i].Index);
						}
						var IndexSStr=IndexS.join(',')
						var HospID=$HUI.combogrid('#_HospList').getValue();
						if ((!HospID)||(HospID=="")) {
							HospID=session['LOGON.HOSPID'];
						}
						$.dhc.util.runServerMethod("DHCDoc.DHCDocConfig.DocToDo","DelTimeRangeList","false",function testget(value){
							if(value=="0"){
								PageLogicObj.m_DocToDo_TimeRangeList.datagrid('load');
								PageLogicObj.m_DocToDo_TimeRangeList.datagrid('unselectAll');
							    $.messager.show({title:"提示",msg:"删除成功"});
							   
							}else{
							   $.messager.alert('提示',"删除失败:"+value);
							}
							editRow4 = undefined;
					   },"","",IndexSStr,HospID);
					}
				});
			} else {
				$.messager.alert("提示", "请选择要删除的行", "error");
			}
		}
	}, {
		text: '保存',
		iconCls: 'icon-save',
		handler: function() {
			if (editRow4 == undefined){
				 $.messager.show({title:"提示",msg:"没有需要保存的数据"});  
			}
			var editors = PageLogicObj.m_DocToDo_TimeRangeList.datagrid('getEditors', editRow4); 
			var rows = PageLogicObj.m_DocToDo_TimeRangeList.datagrid("selectRow",editRow4).datagrid("getSelected");			
			var TimeRangeStartTime=editors[0].target.val();
			var TimeRangeEndTime=editors[1].target.val();
			if ((TimeRangeStartTime=="")||(TimeRangeEndTime=="")){
				$.messager.alert('提示',"数据为空,无法保存!");
				return false;
			}
			var HospID=$HUI.combogrid('#_HospList').getValue();
			if ((!HospID)||(HospID=="")) {
				HospID=session['LOGON.HOSPID'];
			}
			var Index=rows.Index;
			if (typeof Index=="undefined"){
				Index="";
			}
			var value=tkMakeServerCall("DHCDoc.DHCDocConfig.DocToDo","InsertTimeRangeList",Index,TimeRangeStartTime,TimeRangeEndTime,HospID)
			if(value.split("^")[0]=="0"){
				PageLogicObj.m_DocToDo_TimeRangeList.datagrid("endEdit", editRow4);
				editRow4 = undefined;
				PageLogicObj.m_DocToDo_TimeRangeList.datagrid('load');
				PageLogicObj.m_DocToDo_TimeRangeList.datagrid('unselectAll');
				$.messager.show({title:"提示",msg:"保存成功"});        					
			}else{
				$.messager.show({title:"提示",msg:"保存失败"+value});
			}
			
		}
	},{
		text: '取消编辑',
		iconCls: 'icon-redo',
		handler: function() {
			editRow4 = undefined;
			PageLogicObj.m_DocToDo_TimeRangeList.datagrid("rejectChanges");
			PageLogicObj.m_DocToDo_TimeRangeList.datagrid("unselectAll");
		}
	}];
	
	 var columns=[[ 
				{field:'Index',hidden:true},
				{field:'TimeRangeStartTime',title:'开始时间',width:200,editor : {type : 'timespinner'}},
				{field:'TimeRangeEndTime',title:'结束时间',width:200,editor : {type : 'timespinner'}}
			 ]];
	PageLogicObj.m_DocToDo_TimeRangeList = $("#DocToDo_TimeRangeList").datagrid({  
		fit : true,
		//width : 1500,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '加载中..',  
		pagination : false,  //
		rownumbers : true,  //
		columns :columns,
		toolbar :ToolBar,
		pageSize:50,
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){  
		},
		onClickRow:function(rowIndex, rowData){
		},
		onDblClickRow:function(rowIndex, rowData){
			if (editRow4!=undefined){
				$.messager.alert('提示',"只允许编辑一行数据");
				return
			}
			editRow4=rowIndex
			PageLogicObj.m_DocToDo_TimeRangeList.datagrid("beginEdit", rowIndex);
			//var editors = PageLogicObj.m_DocToDo_TimeRangeList.datagrid('getEditors', editRow4);
			//editors[0].target.attr("disabled",true);
		},
		onBeforeLoad:function(queryParams){
			var HospID=$HUI.combogrid('#_HospList').getValue();
			if ((!HospID)||(HospID=="")) {
				HospID=session['LOGON.HOSPID'];
			}
			editRow4=undefined;
			queryParams.ClassName ='DHCDoc.DHCDocConfig.DocToDo';
			queryParams.QueryName ='FindTimeRangeList';
			queryParams.Arg1=HospID;
			queryParams.ArgCnt =1;
		}
	});
}
//待办方法维护列表
function Init_DocToDo_ListFunc() {
	
	var ToolBar = [{
		text: '添加',
		iconCls: 'icon-add',
		handler: function() { //添加列表的操作按钮添加,修改,删除等
			PageLogicObj.m_DocToDo_ListFunc.datagrid('unselectAll');
			if (editRow5 != undefined) {
				return;
			}else{
				editRow5 = 0;
				PageLogicObj.m_DocToDo_ListFunc.datagrid("insertRow", {
					index: 0,
					row: {}
				});
				PageLogicObj.m_DocToDo_ListFunc.datagrid("beginEdit", 0);
				var editors = PageLogicObj.m_DocToDo_ListFunc.datagrid('getEditors', editRow5); 
				editors[0].target.val(1)
			}
		  
		}
	}, {
		text: '删除',
		iconCls: 'icon-cancel',
		handler: function() {
			var rows =PageLogicObj.m_DocToDo_ListFunc.datagrid("getSelections");
			if (rows.length > 0) {
				$.messager.confirm("提示", "你确定要删除吗?",
				function(r) {
					if (r) {
						var IndexS = [];
						for (var i = 0; i < rows.length; i++) {
							IndexS.push(rows[i].Index);
						}
						var IndexSStr=IndexS.join(',')
						var HospID=$HUI.combogrid('#_HospList').getValue();
						if ((!HospID)||(HospID=="")) {
							HospID=session['LOGON.HOSPID'];
						}
						if (IndexSStr==""){
							PageLogicObj.m_DocToDo_ListFunc.datagrid('load').datagrid('unselectAll');
							return;
						}
						$.dhc.util.runServerMethod("DHCDoc.DHCDocConfig.DocToDo","DelFuncList","false",function testget(value){
							if(value=="0"){
								PageLogicObj.m_DocToDo_ListFunc.datagrid('load').datagrid('unselectAll');
							    $.messager.show({title:"提示",msg:"删除成功"});
							   
							}else{
							   $.messager.alert('提示',"删除失败:"+value);
							}
							editRow5 = undefined;
					   },"","",IndexSStr,HospID);
					}
				});
			} else {
				$.messager.alert("提示", "请选择要删除的行", "error");
			}
		}
	}, {
		text: '保存',
		iconCls: 'icon-save',
		handler: function() {
			if (editRow5 == undefined){
				 $.messager.show({title:"提示",msg:"没有需要保存的数据"});  
			}
			var editors = PageLogicObj.m_DocToDo_ListFunc.datagrid('getEditors', editRow5); 
			var rows = PageLogicObj.m_DocToDo_ListFunc.datagrid("selectRow",editRow5).datagrid("getSelected");			
			var Level=editors[0].target.val();		//缩进级别
			var Prefix=editors[1].target.val();		//前缀
			var SuffixFunc=editors[2].target.val();	//后缀处理方法
			var URL=editors[3].target.val();
			var OutStyle=editors[4].target.val();	//外部样式
			var InStyle=editors[5].target.val();	//内部样式
			var SearchType=editors[6].target.combobox('getValue');;	//检索类型
			if (!(/(^[1-9]\d*$)/.test(Level))){
				$.messager.alert('提示',"缩进级别请填写大于0的正整数!");
				return false;
			}
			if (SuffixFunc==""){
				$.messager.alert('提示',"后缀处理方法不能为空!");
				return false;
			}
			var HospID=$HUI.combogrid('#_HospList').getValue();
			if ((!HospID)||(HospID=="")) {
				HospID=session['LOGON.HOSPID'];
			}
			var Index=rows.Index;
			if (typeof Index=="undefined"){
				Index="";
			}
			var value=tkMakeServerCall("DHCDoc.DHCDocConfig.DocToDo","InsertFuncList",Index,HospID,Level,Prefix,SuffixFunc,URL,OutStyle,InStyle,SearchType)
			if(value.split("^")[0]=="0"){
				PageLogicObj.m_DocToDo_ListFunc.datagrid("endEdit", editRow5);
				editRow5 = undefined;
				PageLogicObj.m_DocToDo_ListFunc.datagrid('load');
				PageLogicObj.m_DocToDo_ListFunc.datagrid('unselectAll');
				$.messager.show({title:"提示",msg:"保存成功"});        					
			}else{
				$.messager.alert('提示',"保存失败:"+value);
				return false;
			}
			editRow5 = undefined;
		}
	},{
		text: '取消编辑',
		iconCls: 'icon-redo',
		handler: function() {
			editRow5 = undefined;
			PageLogicObj.m_DocToDo_ListFunc.datagrid("rejectChanges");
			PageLogicObj.m_DocToDo_ListFunc.datagrid("unselectAll");
		}
	},{
		text: '关联子类',
		iconCls: 'icon-barbell',
		handler: function() {
			var rows =PageLogicObj.m_DocToDo_ListFunc.datagrid("getSelections");
			if (rows.length!=1){
				$.messager.alert('提示',"请选中一行数据");
				return false;
			}
			if (!rows[0].InstrStr){
				//$.messager.alert('提示',"请保存此行数据");
				//return false;
				}
			var HospID=$HUI.combogrid('#_HospList').getValue();
			if ((!HospID)||(HospID=="")) {
				HospID=session['LOGON.HOSPID'];
			}
			var Index=rows[0].Index;
			var OrdSubCatStr=rows[0].OrdSubCatStr;
			websys_showModal({
				//url:"dhcdoc.util.subcatlist.csp?OrdSubCatStr=" + OrdSubCatStr+"&HospDr="+HospID,
				url:"dhcdoc.util.tablelist.csp?TableName=ARC_ItemCat&IDList=" + OrdSubCatStr+"&HospDr="+HospID,
				title:' 子类选择',
				width:400,height:610,
				closable:false,
				CallBackFunc:function(result){
					websys_showModal("close");
					if ((typeof result=="undefined")||(result===false)){
						return;
					}
					
					var value=tkMakeServerCall("DHCDoc.DHCDocConfig.DocToDo","UpdateFuncListSubCat",Index,HospID,result)
					if(value.split("^")[0]=="0"){
						PageLogicObj.m_DocToDo_ListFunc.datagrid('load');
						PageLogicObj.m_DocToDo_ListFunc.datagrid('unselectAll');
						$.messager.show({title:"提示",msg:"保存成功"});        					
					}else{
						$.messager.alert('提示',"保存失败:"+value);
						return false;
					}

				}
			})
		}
	},{
		text: '关联用法',
		iconCls: 'icon-barbell',
		handler: function() {
			var rows =PageLogicObj.m_DocToDo_ListFunc.datagrid("getSelections");
			if (rows.length!=1){
				$.messager.alert('提示',"请选中一行数据");
				return false;
			}
			var HospID=$HUI.combogrid('#_HospList').getValue();
			if ((!HospID)||(HospID=="")) {
				HospID=session['LOGON.HOSPID'];
			}
			if (!rows[0].InstrStr){
				//$.messager.alert('提示',"请保存此行数据");
				//return false;
				}
			var Index=rows[0].Index;
			var InstrStr=rows[0].InstrStr;
			websys_showModal({
				url:"dhcdoc.util.tablelist.csp?TableName=PHC_Instruc&IDList=" + InstrStr+"&HospDr="+HospID,
				title:' 用法选择',
				width:400,height:610,
				closable:false,
				CallBackFunc:function(result){
					websys_showModal("close");
					if ((typeof result=="undefined")||(result===false)){
						return;
					}
					var value=tkMakeServerCall("DHCDoc.DHCDocConfig.DocToDo","UpdateFuncListInstr",Index,HospID,result)
					if(value.split("^")[0]=="0"){
						PageLogicObj.m_DocToDo_ListFunc.datagrid('load');
						PageLogicObj.m_DocToDo_ListFunc.datagrid('unselectAll');
						$.messager.show({title:"提示",msg:"保存成功"});        					
					}else{
						$.messager.alert('提示',"保存失败:"+value);
						return false;
					}

				}
			})
		}
	}];
	
	 var columns=[[ 
				{field:'Index',title:'配置编号',hidden:true},
				{field:'OrdSubCatStr',title:'子类列表(!分割)',hidden:true},
				{field:'InstrStr',title:'用法列表(!分割)',hidden:true},
				{field:'Level',title:'缩进级别',width:110,editor : {type : 'text'}},
				{field:'Prefix',title:'前缀',width:60,editor : {type : 'text'}},
				{field:'SuffixFunc',title:'后缀处理方法',width:600,editor : {type : 'text'}},
				{field:'URL',title:'URL',width:600,editor : {type : 'text'}},
				{field:'OutStyle',title:'外部样式',width:500,editor : {type : 'text'},
					formatter:function (value,row,index) {
						if (value!=""){
							return "<lable style='"+value+"'>"+value+"</lable>"
						}
						return value
					}
				},
				{field:'InStyle',title:'内部样式',width:500,editor : {type : 'text'},
					formatter:function (value,row,index) {
						if (value!=""){
							return "<lable style='"+value+"'>"+value+"</lable>"
						}
						return value
					}
				},
				{field:'SearchType',title:'检索类型',width:110,
					editor:{
						type:'combobox',
						options:{
						valueField:'code',
						textField:'desc',
						required:false,
						data:[
								{"code":"ByDate","desc":"按日期检索"},
								{"code":"ByOrder","desc":"按医嘱检索"}
							]
						}
					},
					formatter:function (value,row,index) {
						if (value=="ByDate"){
							return "按日期检索"
						}else if (value=="ByOrder"){
							return "按医嘱检索"
						}
						return value
					}
				}
			 ]];
	//配置编号^级别^前缀^后缀处理方法^URL^外部样式^内部样式^子类列表(!分割)^用法列表(!分割)^检索类型(ByDate|ByOrder)
	PageLogicObj.m_DocToDo_ListFunc = $("#DocToDoFuncList").datagrid({  
		fit : true,
		width : 1500,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '加载中..',  
		pagination : false,  //
		rownumbers : true,  //
		columns :columns,
		toolbar :ToolBar,
		pageSize:50,
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){  
		},
		onClickRow:function(rowIndex, rowData){
		},
		onDblClickRow:function(rowIndex, rowData){
			if (editRow5!=undefined){
				$.messager.alert('提示',"只允许编辑一行数据");
				return
			}
			editRow5=rowIndex
			PageLogicObj.m_DocToDo_ListFunc.datagrid("beginEdit", rowIndex);
			var editors = PageLogicObj.m_DocToDo_ListFunc.datagrid('getEditors', editRow5);
		},
		onBeforeLoad:function(queryParams){
			var HospID=$HUI.combogrid('#_HospList').getValue();
			if ((!HospID)||(HospID=="")) {
				HospID=session['LOGON.HOSPID'];
			}
			editRow5=undefined;
			queryParams.ClassName ='DHCDoc.DHCDocConfig.DocToDo';
			queryParams.QueryName ='FindTODOListFunc';
			queryParams.Arg1=HospID;
			queryParams.ArgCnt =1;
		}
	});
}
