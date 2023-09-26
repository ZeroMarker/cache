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
	m_TreeWin:""
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
	editRow3;

function Init() {
	
	InitOrderClassify();
	InitClassifyDetailGrid();
	InitTab();
	LoadCenMainPage();
}
function InitHospList()
{
	var hospComp = GenHospComp("Doc_Config_OrderClassify");
	hospComp.jdata.options.onSelect = function(e,t){
		LoadCenMainPage();
		$("#orderclassify").datagrid("reload");
		if (PageLogicObj.m_TreeGrid != "") {
			var HospID=$HUI.combogrid('#_HospList').getValue();
			if ((!HospID)||(HospID=="")) {
				HospID=session['LOGON.HOSPID'];
			}
			$.cm({
				ClassName:"DHCDoc.DHCDocConfig.OrderClassify",
				MethodName:"LoadOrderKind",
				EpisodeID:"",
				HospId:HospID
			},function(data){
				$HUI.treegrid("#OrderKind").loadData(data);
			})
		}
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}
function InitEvent() {
	
}

function InitTab() {
	$HUI.tabs("#i-tab", {
		fit:true,
		onSelect: function (title,index) {
			if (index == 1) {
				if (PageLogicObj.m_TreeGrid == "") {
					InitOrderKindGrid();
					
				}
				showMainPage();
				$("#tip-two").addClass("bk");
				$("#tip-one").removeClass("bk");
				//$("#orderclassify").datagrid("rejectChanges");
				$("#orderclassify").datagrid("unselectAll");
			} else {
				$("#tip-one").addClass("bk");
				$("#tip-two").removeClass("bk");
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
			ClassifyDetailGrid.datagrid('reload');
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
				ClassifyDetailGrid.datagrid('load');
				ClassifyDetailGrid.datagrid('unselectAll');
				$.messager.show({title:"提示",msg:"保存成功"});        					
			}else if(value.split("^")[0]=="-101"){
				$.messager.alert('提示',"保存失败,记录重复!");
				return false;
			}else{
				$.messager.alert('提示',"保存失败:"+value);
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
	}];
	 var ClassifyDetailColumns=[[ 
				{field:'Index',hidden:true},
				{field:'ARCIMDR',hidden:true},
				{ field: 'ArcimDesc', title: '医嘱项名称',width:300,align: 'left', sortable: true, 
					editor:{
						type:'combogrid',
						options:{
							required: true,
							panelWidth:450,
							panelHeight:350,
							delay:200,
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
							url:PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
							columns:[[
								{field:'ArcimDesc',title:'名称',width:300,sortable:true},
								{field:'ArcimRowID',title:'ID',width:120,sortable:true},
								{field:'selected',title:'ID',width:120,sortable:true,hidden:true}
							 ]],
							 keyHandler:{
								up: function () {
									var selected = $(this).combogrid('grid').datagrid('getSelected');
									if (selected) {
										var index = $(this).combogrid('grid').datagrid('getRowIndex', selected);
										if (index > 0) {
											$(this).combogrid('grid').datagrid('selectRow', index - 1);
										}
									} else {
										var rows = $(this).combogrid('grid').datagrid('getRows');
										$(this).combogrid('grid').datagrid('selectRow', rows.length - 1);
									}
								 },
								 down: function () {
									var selected = $(this).combogrid('grid').datagrid('getSelected');
									if (selected) {
										var index = $(this).combogrid('grid').datagrid('getRowIndex', selected);
										if (index < $(this).combogrid('grid').datagrid('getData').rows.length - 1) {
											$(this).combogrid('grid').datagrid('selectRow', index + 1);
										}
									} else {
										$(this).combogrid('grid').datagrid('selectRow', 0);
									}
								},
								left:function(){
									return false
								},
								right:function(){
									return false
								},            
								enter: function () { 
									var selected = $(this).combogrid('grid').datagrid('getSelected');  
									if (selected) { 
									  $(this).combogrid("options").value=selected.ArcimDesc;
									  var rows=ClassifyDetailGrid.datagrid("selectRow",editRow2).datagrid("getSelected");
									}
									$(this).combogrid('hidePanel');
									$(this).focus();
								},
								query:function(q){
									var object1=new Object();
									object1=$(this)
									if (this.AutoSearchTimeOut) {
										window.clearTimeout(this.AutoSearchTimeOut)
										this.AutoSearchTimeOut=window.setTimeout(function(){ LoadItemData(q,object1);},400); 
									}else{
										this.AutoSearchTimeOut=window.setTimeout(function(){ LoadItemData(q,object1);},400); 
									}
									$(this).combogrid("setValue",q);
								}
							},
							onSelect: function (rowIndex, rowData){
								//debugger
								var rows=ClassifyDetailGrid.datagrid("selectRow",editRow2).datagrid("getSelected");
								rows.ARCIMDR=rowData.ArcimRowID
							},
							onClickRow: function (rowIndex, rowData){
								var rows=ClassifyDetailGrid.datagrid("selectRow",editRow2).datagrid("getSelected");
								rows.ARCIMDR=rowData.ArcimRowID
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
		pagination : true,  //
		rownumbers : true,  //
		//pageList : [50,100,200],
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
				console.log(node);
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
						HospId:HospID
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
								HospId:HospID
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
				alert("正在编辑行，请先保存。");
				return;
			}
			var selected = PageLogicObj.m_TreeGrid.getSelected();
			var ARCIMDR=selected.ARCIMDR;
			if (ARCIMDR !="" ) { 
				//console.log(selected);
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
				HospId:HospID
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
				HospId:HospID
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


