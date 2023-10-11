/**
 * orderclassify.hui.js ҽ������HUI
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2018-08-10
 * 
 * ע��˵��
 * TABLE: 
 */
//ҳ��ȫ�ֱ���
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
	//��ʼ��
	//Init();
	//�¼���ʼ��
	InitEvent();
	//ҳ��Ԫ�س�ʼ��
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
			
			$('#orderClassify_layout').layout('panel', 'center').panel('setTitle',"�����������б�");
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
			$('#orderClassify_layout').layout('panel', 'center').panel('setTitle',"��ʾ������");
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
				$('#orderClassify_layout').layout('panel', 'center').panel('setTitle',"�����������б�");
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
		title:"��������",
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


//������ࣺ������Ժ��������
function InitOrderClassify(){
	var OrderClassifyToolBar = [{
		text: '���',
		iconCls: 'icon-add',
		handler: function() { //����б�Ĳ�����ť���,�޸�,ɾ����
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
		text: 'ɾ��',
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
				$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����?",
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
							   $.messager.show({title:"��ʾ",msg:"ɾ���ɹ�"});
							   showMainPage();
							}else{
							   $.messager.alert('��ʾ',"ɾ��ʧ��:"+value);
							}
							editRow1 = undefined;
					   },"","",ClassifyCodeStr,HospID);
					}
				});
			} else {
				$.messager.alert("��ʾ", "��ѡ��Ҫɾ������", "error");
			}
		}
	}, {
		text: '����',
		iconCls: 'icon-save',
		handler: function() {
			if (editRow1 == undefined){
				 $.messager.show({title:"��ʾ",msg:"û����Ҫ���������"});  
			}
			var editors = OrderClassifyGrid.datagrid('getEditors', editRow1); 
			var rows = OrderClassifyGrid.datagrid("selectRow",editRow1).datagrid("getSelected");			
			var OrderClassifyCode=editors[0].target.val();
			var OrderClassifyDesc=editors[1].target.val();
			if ((OrderClassifyCode=="")||(OrderClassifyDesc=="")){
				$.messager.alert('��ʾ',"����Ϊ��,�޷�����!");
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
				$.messager.show({title:"��ʾ",msg:"����ɹ�"});        					
			}else if(value.split("^")[0]=="-101"){
				$.messager.alert('��ʾ',"����ʧ��,��¼�ظ�!");
				return false;
			}else{
				$.messager.alert('��ʾ',"����ʧ��:"+value);
				return false;
			}
			editRow1 = undefined;
			
			
		}
	},{
		text: 'ȡ���༭',
		iconCls: 'icon-redo',
		handler: function() {
			editRow1 = undefined;
			OrderClassifyGrid.datagrid("rejectChanges");
			OrderClassifyGrid.datagrid("unselectAll");
		}
	}];
	
	 var OrderClassifyColumns=[[ 
				{field:'Index',hidden:true},
				{field:'ClassifyCode',title:'����',width:200,editor : {type : 'text'}},
				{field:'ClassifyDesc',title:'����',width:200,editor : {type : 'text'}}
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
		loadMsg : '������..',  
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
				$.messager.alert('��ʾ',"���ȱ�����߸�ȡ���༭����"); 
				showMainPage();
			}else{
				ClassifyDetailGrid.datagrid('reload');
				}
		},
		onDblClickRow:function(rowIndex, rowData){
			if (editRow1!=undefined){
				$.messager.alert('��ʾ',"ֻ����༭һ������");
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
		text: '���',
		iconCls: 'icon-add',
		handler: function() { //����б�Ĳ�����ť���,�޸�,ɾ����
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
		text: 'ɾ��',
		iconCls: 'icon-cancel',
		handler: function() {
			var Mainrows = OrderClassifyGrid.datagrid("getSelections");
			if (Mainrows.length!= 1){
				$.messager.show({title:"��ʾ",msg:"��ѡ��ҽ������"});  
				return;
			}
			var ClassifyCode=Mainrows[Mainrows.length-1].ClassifyCode;
			var rows = ClassifyDetailGrid.datagrid("getSelections");
			if (rows.length!= 1){
				$.messager.show({title:"��ʾ",msg:"��ѡ��ҽ����"});  
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
				   $.messager.show({title:"��ʾ",msg:"ɾ���ɹ�"});
				}else{
				   $.messager.alert('��ʾ',"ɾ��ʧ��:"+value);
				}
				editRow2 = undefined;
		   },"","",Params,HospID);
		}
	}, {
		text: '����',
		iconCls: 'icon-save',
		handler: function() {
			if (editRow2 == undefined){
				 $.messager.show({title:"��ʾ",msg:"û����Ҫ���������"}); 
				 return; 
			}
			var editors = ClassifyDetailGrid.datagrid('getEditors', editRow2); 
			var rows = ClassifyDetailGrid.datagrid("selectRow",editRow2).datagrid("getSelected");
			var Index=rows.Index;
			if (Index==undefined){Index=""}
			var ARCIMDR=rows.ARCIMDR;
			if (ARCIMDR==""){
				$.messager.show({title:"��ʾ",msg:"������ҽ����Ŀ"});  
				return;
			}
			var Mainrows = OrderClassifyGrid.datagrid("getSelections");
			if (Mainrows.length<=0){
				$.messager.show({title:"��ʾ",msg:"��ѡ��ҽ������"});  
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
				$.messager.show({title:"��ʾ",msg:"����ɹ�"});        					
			}else if(value.split("^")[0]=="-101"){
				$.messager.alert('��ʾ',"����ʧ�ܣ���¼�ظ���");
				return false;
			}else{
				$.messager.alert('��ʾ',"����ʧ�ܣ�"+value);
				return false;
			}
			editRow2 = undefined;
		}
	}, {
		text: 'ȡ���༭',
		iconCls: 'icon-redo',
		handler: function() {
			editRow2 = undefined;
			ClassifyDetailGrid.datagrid("rejectChanges");
			ClassifyDetailGrid.datagrid("unselectAll");
		}
	}, {
		text: '�������������',
		iconCls: 'icon-batch-add',
		handler: function() {
			var HospID=$HUI.combogrid('#_HospList').getValue();
			if ((!HospID)||(HospID=="")) {
				HospID=session['LOGON.HOSPID'];
			}
			var Mainrows = OrderClassifyGrid.datagrid("getSelections");
			if (Mainrows.length<=0){
				$.messager.show({title:"��ʾ",msg:"��ѡ��ҽ������"});  
				return;
			}
			var Index=""
			var ClassifyCode=Mainrows[Mainrows.length-1].ClassifyCode;
			websys_showModal({
				url:"dhcdoc.util.tablelist.csp?TableName=ARC_ItemCat&HospDr="+HospID,
				title:' ����ѡ��',
				width:400,height:610,
				closable:false,
				CallBackFunc:function(result){
					websys_showModal("close");
					if ((typeof result=="undefined")||(result==false)){
						return;
					}
					if (result==""){
						$.messager.alert('��ʾ',"δѡ������");
						return false;
					}
					var ArcimStr =tkMakeServerCall("DHCDoc.DHCDocConfig.ItemCat","GetArcimStrByARCCat",result,HospID)
					var NeedOutData =  "N";
					var Params=ClassifyCode+"^"+Index+"^"+ArcimStr+"^"+NeedOutData;
					
					var value=tkMakeServerCall("DHCDoc.DHCDocConfig.OrderClassify","InsertClassifyDetail",Params,HospID)
					if(value.split("^")[0]=="0"){
						ClassifyDetailGrid.datagrid('unselectAll').datagrid('load');
						$.messager.show({title:"��ʾ",msg:"����ɹ�"});        					
					}else{
						$.messager.alert('��ʾ',"����ʧ�ܣ�"+value);
						return false;
					}

				}
			})
		}
	}];
	 var ClassifyDetailColumns=[[ 
				{field:'Index',hidden:true},
				{field:'ARCIMDR',hidden:true},
				{ field: 'ArcimDesc', title: 'ҽ��������',width:300,align: 'left', sortable: true, 
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
								value:'',//ȱʡֵ 
								mode:'remote',
								pagination : true,//�Ƿ��ҳ   
								rownumbers:true,//���   
								collapsible:false,//�Ƿ���۵���   
								fit: true,//�Զ���С   
								pageSize: 10,//ÿҳ��ʾ�ļ�¼������Ĭ��Ϊ10   
								pageList: [10],//��������ÿҳ��¼�������б�  
								url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ArcItemConfig&QueryName=FindAllItem",
	                            columns:[[
	                                {field:'ArcimDesc',title:'����',width:310,sortable:true},
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
				{field : 'NeedOutData',title : '��Ҫ�ⲿ���ݣ���ҽ�����ݣ�',hidden:true,
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
		loadMsg : '������..',  
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
				$.messager.alert('��ʾ',"ֻ����༭һ������");
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
		{title:'����',field:'Title',width:180,editor : {
			type : 'text',
			options : {
			}
		}},
		{title:'ҽ��������',field:'ArcimDesc',width:180},
		{title:'ARCIMDR',field:'ARCIMDR',hidden:false}
	]];
	var OrderKindBar = [
		{
			text: '���',
			iconCls: 'icon-add',
			handler: function() {
				var node = $('#OrderKind').treegrid('getSelected');
				var RowID="";
				if (node){
					RowID=node.RowID;
				}
				RowID=RowID.toString();
				if (RowID.indexOf("99999")>=0){
					$.messager.alert('��ʾ',"��ѡ�����ڵ���ӻ�ѡ����������ڵ�");
					return
				}
				
				//���ҽ����
				if (RowID!=""){
					
					if($('#tree-dg').hasClass("c-hidden")) {
						$('#tree-dg').removeClass("c-hidden");
					};
					$("#tree-id").val(RowID);
					$("#tree-title").html("����ҽ���ģ��");
					//ҽ����
					PageLogicObj.m_ArcimCombox = $HUI.combogrid("#tree-arcim", {
						panelWidth: 600,
						idField: 'ArcimRowID',
						textField: 'ArcimDesc',
						columns: [[
							{field:'ArcimDesc',title:'ҽ������',width:200,sortable:true},
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
						title: "���",
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
			text: '����',
			iconCls: 'icon-save',
			handler: function() {
				
				if (!editRow3){
					return
				}
				$('#OrderKind').treegrid('endEdit',editRow3);
				var EditData=$('#OrderKind').treegrid('find',editRow3);
				if (!EditData){return}
				if (EditData.Title.length>10){
					$.messager.alert("�������")
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
			text: 'ɾ��',
			iconCls: 'icon-cancel',
			handler: function() {
				var node = $('#OrderKind').treegrid('getSelected');
				if (!node){
					$.messager.alert("��ʾ","��ѡ����Ҫ�༭����","info");
					return
				}
				var RowID=node.RowID;
				
				$.messager.confirm("��ʾ", "ȷ��ɾ����", function(r) {
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
			text: 'ȡ���༭',
			iconCls: 'icon-redo',
			handler: function() {
				editRow3 = undefined;
				PageLogicObj.m_TreeGrid.reload()
				PageLogicObj.m_TreeGrid.unselectAll();
			}
		}, {
			text: '�������������',
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
					$.messager.alert('��ʾ',"��ѡ�����ڵ����");
					return
				}

				var HospID=$HUI.combogrid('#_HospList').getValue();
				if ((!HospID)||(HospID=="")) {
					HospID=session['LOGON.HOSPID'];
				}
				
				websys_showModal({
					url:"dhcdoc.util.tablelist.csp?TableName=ARC_ItemCat&HospDr="+HospID,
					title:' ����ѡ��',
					width:400,height:610,
					closable:false,
					CallBackFunc:function(result){
						websys_showModal("close");
						if ((typeof result=="undefined")||(result==false)){
							return;
						}
						if (result==""){
							$.messager.alert('��ʾ',"δѡ������");
							return false;
						}
						var ArcimStr =tkMakeServerCall("DHCDoc.DHCDocConfig.ItemCat","GetArcimStrByARCCat",result,HospID)
						var NeedOutData =  "N";
						var value=tkMakeServerCall("DHCDoc.DHCDocConfig.OrderClassify","InserOrderKindSub",RowID,"",ArcimStr,HospID)
						if(value.split("^")[0]=="0"){
							PageLogicObj.m_TreeGrid.reload().unselectAll();
							$.messager.show({title:"��ʾ",msg:"����ɹ�"});        					
						}else{
							$.messager.alert('��ʾ',"����ʧ�ܣ�"+value);
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
				$.messager.alert("��ʾ","���ڱ༭�У����ȱ��档");
				return;
			}
			var selected = PageLogicObj.m_TreeGrid.getSelected();
			var ARCIMDR=selected.ARCIMDR;
			if (ARCIMDR !="" ) { 
				var tipDesc = '��ҽ���� "' + selected.ArcimDesc + '" �޸�Ϊ��'
				
				if($('#tree-dg').hasClass("c-hidden")) {
					$('#tree-dg').removeClass("c-hidden");
				};
				
				$("#tree-title").html(tipDesc);
				$("#tree-action").val("edit");
				$("#tree-id").val(selected.RowID);
				
				
				
					
				//ҽ����
				PageLogicObj.m_ArcimCombox = $HUI.combogrid("#tree-arcim", {
					panelWidth: 600,
					idField: 'ArcimRowID',
					textField: 'ArcimDesc',
					columns: [[
						{field:'ArcimDesc',title:'ҽ������',width:200,sortable:true},
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
					title: "���",
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
		$.messager.alert("��ʾ", "����ѡ��ҽ���", "info");
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
	//�������Backspace������  
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
  **Description      :����ҽ�ƴ���_ʱ����Ϣ
***/
function Init_DocToDo_TimeRangeList() {
	var ToolBar = [{
		text: '���',
		iconCls: 'icon-add',
		handler: function() { //����б�Ĳ�����ť���,�޸�,ɾ����
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
		text: 'ɾ��',
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
				$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����?",
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
							    $.messager.show({title:"��ʾ",msg:"ɾ���ɹ�"});
							   
							}else{
							   $.messager.alert('��ʾ',"ɾ��ʧ��:"+value);
							}
							editRow4 = undefined;
					   },"","",IndexSStr,HospID);
					}
				});
			} else {
				$.messager.alert("��ʾ", "��ѡ��Ҫɾ������", "error");
			}
		}
	}, {
		text: '����',
		iconCls: 'icon-save',
		handler: function() {
			if (editRow4 == undefined){
				 $.messager.show({title:"��ʾ",msg:"û����Ҫ���������"});  
			}
			var editors = PageLogicObj.m_DocToDo_TimeRangeList.datagrid('getEditors', editRow4); 
			var rows = PageLogicObj.m_DocToDo_TimeRangeList.datagrid("selectRow",editRow4).datagrid("getSelected");			
			var TimeRangeStartTime=editors[0].target.val();
			var TimeRangeEndTime=editors[1].target.val();
			if ((TimeRangeStartTime=="")||(TimeRangeEndTime=="")){
				$.messager.alert('��ʾ',"����Ϊ��,�޷�����!");
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
				$.messager.show({title:"��ʾ",msg:"����ɹ�"});        					
			}else{
				$.messager.show({title:"��ʾ",msg:"����ʧ��"+value});
			}
			
		}
	},{
		text: 'ȡ���༭',
		iconCls: 'icon-redo',
		handler: function() {
			editRow4 = undefined;
			PageLogicObj.m_DocToDo_TimeRangeList.datagrid("rejectChanges");
			PageLogicObj.m_DocToDo_TimeRangeList.datagrid("unselectAll");
		}
	}];
	
	 var columns=[[ 
				{field:'Index',hidden:true},
				{field:'TimeRangeStartTime',title:'��ʼʱ��',width:200,editor : {type : 'timespinner'}},
				{field:'TimeRangeEndTime',title:'����ʱ��',width:200,editor : {type : 'timespinner'}}
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
		loadMsg : '������..',  
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
				$.messager.alert('��ʾ',"ֻ����༭һ������");
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
//���췽��ά���б�
function Init_DocToDo_ListFunc() {
	
	var ToolBar = [{
		text: '���',
		iconCls: 'icon-add',
		handler: function() { //����б�Ĳ�����ť���,�޸�,ɾ����
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
		text: 'ɾ��',
		iconCls: 'icon-cancel',
		handler: function() {
			var rows =PageLogicObj.m_DocToDo_ListFunc.datagrid("getSelections");
			if (rows.length > 0) {
				$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����?",
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
							    $.messager.show({title:"��ʾ",msg:"ɾ���ɹ�"});
							   
							}else{
							   $.messager.alert('��ʾ',"ɾ��ʧ��:"+value);
							}
							editRow5 = undefined;
					   },"","",IndexSStr,HospID);
					}
				});
			} else {
				$.messager.alert("��ʾ", "��ѡ��Ҫɾ������", "error");
			}
		}
	}, {
		text: '����',
		iconCls: 'icon-save',
		handler: function() {
			if (editRow5 == undefined){
				 $.messager.show({title:"��ʾ",msg:"û����Ҫ���������"});  
			}
			var editors = PageLogicObj.m_DocToDo_ListFunc.datagrid('getEditors', editRow5); 
			var rows = PageLogicObj.m_DocToDo_ListFunc.datagrid("selectRow",editRow5).datagrid("getSelected");			
			var Level=editors[0].target.val();		//��������
			var Prefix=editors[1].target.val();		//ǰ׺
			var SuffixFunc=editors[2].target.val();	//��׺������
			var URL=editors[3].target.val();
			var OutStyle=editors[4].target.val();	//�ⲿ��ʽ
			var InStyle=editors[5].target.val();	//�ڲ���ʽ
			var SearchType=editors[6].target.combobox('getValue');;	//��������
			if (!(/(^[1-9]\d*$)/.test(Level))){
				$.messager.alert('��ʾ',"������������д����0��������!");
				return false;
			}
			if (SuffixFunc==""){
				$.messager.alert('��ʾ',"��׺����������Ϊ��!");
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
				$.messager.show({title:"��ʾ",msg:"����ɹ�"});        					
			}else{
				$.messager.alert('��ʾ',"����ʧ��:"+value);
				return false;
			}
			editRow5 = undefined;
		}
	},{
		text: 'ȡ���༭',
		iconCls: 'icon-redo',
		handler: function() {
			editRow5 = undefined;
			PageLogicObj.m_DocToDo_ListFunc.datagrid("rejectChanges");
			PageLogicObj.m_DocToDo_ListFunc.datagrid("unselectAll");
		}
	},{
		text: '��������',
		iconCls: 'icon-barbell',
		handler: function() {
			var rows =PageLogicObj.m_DocToDo_ListFunc.datagrid("getSelections");
			if (rows.length!=1){
				$.messager.alert('��ʾ',"��ѡ��һ������");
				return false;
			}
			if (!rows[0].InstrStr){
				//$.messager.alert('��ʾ',"�뱣���������");
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
				title:' ����ѡ��',
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
						$.messager.show({title:"��ʾ",msg:"����ɹ�"});        					
					}else{
						$.messager.alert('��ʾ',"����ʧ��:"+value);
						return false;
					}

				}
			})
		}
	},{
		text: '�����÷�',
		iconCls: 'icon-barbell',
		handler: function() {
			var rows =PageLogicObj.m_DocToDo_ListFunc.datagrid("getSelections");
			if (rows.length!=1){
				$.messager.alert('��ʾ',"��ѡ��һ������");
				return false;
			}
			var HospID=$HUI.combogrid('#_HospList').getValue();
			if ((!HospID)||(HospID=="")) {
				HospID=session['LOGON.HOSPID'];
			}
			if (!rows[0].InstrStr){
				//$.messager.alert('��ʾ',"�뱣���������");
				//return false;
				}
			var Index=rows[0].Index;
			var InstrStr=rows[0].InstrStr;
			websys_showModal({
				url:"dhcdoc.util.tablelist.csp?TableName=PHC_Instruc&IDList=" + InstrStr+"&HospDr="+HospID,
				title:' �÷�ѡ��',
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
						$.messager.show({title:"��ʾ",msg:"����ɹ�"});        					
					}else{
						$.messager.alert('��ʾ',"����ʧ��:"+value);
						return false;
					}

				}
			})
		}
	}];
	
	 var columns=[[ 
				{field:'Index',title:'���ñ��',hidden:true},
				{field:'OrdSubCatStr',title:'�����б�(!�ָ�)',hidden:true},
				{field:'InstrStr',title:'�÷��б�(!�ָ�)',hidden:true},
				{field:'Level',title:'��������',width:110,editor : {type : 'text'}},
				{field:'Prefix',title:'ǰ׺',width:60,editor : {type : 'text'}},
				{field:'SuffixFunc',title:'��׺������',width:600,editor : {type : 'text'}},
				{field:'URL',title:'URL',width:600,editor : {type : 'text'}},
				{field:'OutStyle',title:'�ⲿ��ʽ',width:500,editor : {type : 'text'},
					formatter:function (value,row,index) {
						if (value!=""){
							return "<lable style='"+value+"'>"+value+"</lable>"
						}
						return value
					}
				},
				{field:'InStyle',title:'�ڲ���ʽ',width:500,editor : {type : 'text'},
					formatter:function (value,row,index) {
						if (value!=""){
							return "<lable style='"+value+"'>"+value+"</lable>"
						}
						return value
					}
				},
				{field:'SearchType',title:'��������',width:110,
					editor:{
						type:'combobox',
						options:{
						valueField:'code',
						textField:'desc',
						required:false,
						data:[
								{"code":"ByDate","desc":"�����ڼ���"},
								{"code":"ByOrder","desc":"��ҽ������"}
							]
						}
					},
					formatter:function (value,row,index) {
						if (value=="ByDate"){
							return "�����ڼ���"
						}else if (value=="ByOrder"){
							return "��ҽ������"
						}
						return value
					}
				}
			 ]];
	//���ñ��^����^ǰ׺^��׺������^URL^�ⲿ��ʽ^�ڲ���ʽ^�����б�(!�ָ�)^�÷��б�(!�ָ�)^��������(ByDate|ByOrder)
	PageLogicObj.m_DocToDo_ListFunc = $("#DocToDoFuncList").datagrid({  
		fit : true,
		width : 1500,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '������..',  
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
				$.messager.alert('��ʾ',"ֻ����༭һ������");
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
