/**
 * bctranslate.js
 * 
 * Copyright (c) 2020-2090 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-09-02
 * 
 * 
 */

var PageLogicObj = {
	m_TypeGrid:"",
	m_ListGrid:"",
	v_TableName:""
}

$(function() {
	Init();
	InitEvent();
	
	//PageHandle();
})


function Init(){
	InitTypeGrid();
	InitListGrid()
	InitCombox();
}

function InitEvent () {
	$("#Find").click(FindHandler);
	$("#Clear").click(ClearHandler);
	$("#Add").click(AddHandler);
	$("#Edit").click(EditHandler);
	$("#Del").click(DelHandler);
	
	$("#ItemFind").click(ItemFindHandler);
	$("#ItemClear").click(ItemClearHandler);
	$("#BTAdd").click(BTAddHandler);
	$("#BTEdit").click(BTEditHandler);
	$("#BTDel").click(BTDelHandler);
	
	$("#InName").bind('keypress',function(event){
    	if(event.keyCode == "13") {
	    	FindHandler();
	    }
            
    });
    
    $("#TextFieldDesc").bind('keypress',function(event){
	    if (PageLogicObj.v_TableName == "") {
			$.messager.popover({msg: '请先选择翻译类型！',type:'error',timeout: 1000});
			return false;
		}
	
    	if(event.keyCode == "13") {
	    	reloadListGrid(PageLogicObj.v_TableName);
	    }
            
    });
    
}

function PageHandle() {
	
}

function AddHandler () {
	var URL = "dhcdoc.passwork.bctranslate.edit.csp";
	
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-add',
		title:'添加翻译类型',
		width:370,height:400,
		CallBackFunc: function () {
			FindHandler();
		}
	})
}

function EditHandler () {
	var selected = PageLogicObj.m_TypeGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	var ID = selected.id;
	var URL = "dhcdoc.passwork.bctranslate.edit.csp?ID="+ID;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'修改翻译类型',
		width:370,height:400,
		CallBackFunc:FindHandler
	})
}

function DelHandler () {
	var selected = PageLogicObj.m_TypeGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	$.messager.confirm("提示", "<span style='color:red;'>该操作会删除所有的翻译元素，确认删除么？</span>",function (r) {
		if (r) {
			$m({
				ClassName:"DHCDoc.PW.CFG.BCTranslate",
				MethodName:"Delete",
				ID:selected.id
			}, function(result){
				if (result == 0) {
					$.messager.alert("提示", "删除成功！", "info");
					FindHandler();
					reloadListGrid("undefined");
					return true;
				} else {
					$.messager.alert("提示", "删除失败：" + result , "info");
					return false;
				}
			});
		}
		
	});
	
}

function BTEditHandler() {
	$('#BTTableName').combobox('reload');
	//$('#BTFieldName').combobox('reload');
	$('#BTLanguages').combobox('reload');
	var record=PageLogicObj.m_ListGrid.getSelected();	
	if (!(record))
	{	
		$.messager.alert('提示','请先选择一行!',"info");
		return;
	}
	else{
		var id=record.ID;
		$.cm({
			ClassName:"web.DHCBL.BDP.BDPTranslation",
			MethodName:"OpenDataHISUI",
			id: id,      ///rowid
			RetFlag:"JSON"
		},
		function(jsonData){		

			//var parref=tkMakeServerCall("web.DHCBL.BDP.BDPTableList","GetRowidByTableName",jsonData.BTTableName);
      		//var url=$URL+"?ClassName=web.DHCBL.BDP.BDPTableField&QueryName=GetList&ResultSetType=array&ParRef=" +parref+"&filterflag="+"Y";
      		
      		var url=$URL+"?ClassName=DHCDoc.PW.CFG.BCTranslate&QueryName=QryTableItem&ResultSetType=array&TableName=" +jsonData.BTTableName;
      			
      		$('#BTFieldName').combobox('reload',url);
			//$('#BTFieldName').combobox('setValue', jsonData.BTFieldName);
			$('#form-save').form("load",jsonData);
			
		});	
		$("#myWin").show();
		
		var myWin = $HUI.dialog("#myWin",{
			iconCls:'icon-w-edit',
			resizable:true,
			title:'修改',
			modal:true,
			buttons:[{
				text:'保存',
				id:'save_btn',
				handler:function(){
					SaveFunLib(id)
				}
			},{
				text:'关闭',
				handler:function(){
					myWin.close();
				}
			}]
		});			
	}
		
}

function BTDelHandler() {
	var row = PageLogicObj.m_ListGrid.getSelected();
	if (!(row))
	{	$.messager.alert('提示','请先选择一行!',"info");
		return;
	}
	var rowid=row.ID;
	$.messager.confirm('提示', '确定要删除所选的数据么？', function(r){
		if (r){
			var datas = tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","DeleteData",rowid);
			var data = eval('('+datas+')');
			
		    if (data.success == 'true') {
		        $.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
		        
		        reloadListGrid(PageLogicObj.v_TableName);
		        
		        //PageLogicObj.m_ListGrid.reaload();
		        //PageLogicObj.m_ListGrid.unselectAll();							 			       
		    }
		    
		    else{
		        var errorMsg ="删除失败！"
				if (data.info) {
					errorMsg =errorMsg+ '<br/>错误信息:' + data.info
				}
				$.messager.alert('操作提示',errorMsg,"error");
		    }				
		}
	});
	
}

function BTAddHandler() {
	if (PageLogicObj.v_TableName == "") {
		$.messager.popover({msg: '请先选择翻译类型！',type:'error',timeout: 1000});
		return false;
	}
	$('#BTTableName').combobox('reload');
	$('#BTTableName').combobox('disable');
	$('#BTFieldName').combobox('clear');
	$('#BTLanguages').combobox('reload');
	$("#myWin").show();
	$('#BTFieldName').combobox('disable');
	var myWin = $HUI.dialog("#myWin",{
		iconCls:'icon-w-add',
		resizable:true,
		title:'新增',
		modal:true,
		buttonAlign : 'center',
		buttons:[{
			text:'保存',
			//iconCls:'icon-save',
			id:'save_btn',
			handler:function(){					
				SaveFunLib("")								
			}
		},{
			text:'关闭',
			//iconCls:'icon-cancel',
			handler:function(){
				myWin.close();
			}
		}]
	});	
	$('#form-save').form("clear");	

	$('#BTTableName').combobox("setValue",PageLogicObj.v_TableName);
	
	if (PageLogicObj.v_TableName!="") {
		$('#BTFieldName').combobox('enable');
       	$('#BTFieldName').combobox('clear');
      	var url=$URL+"?ClassName=DHCDoc.PW.CFG.BCTranslate&QueryName=QryTableItem&ResultSetType=array&TableName=" +PageLogicObj.v_TableName;
      	$('#BTFieldName').combobox('reload',url);
	}
	
	
}

function ReloadCombox() {
	PageLogicObj.m_TextFieldName.clear();
  	var url=$URL+"?ClassName=DHCDoc.PW.CFG.BCTranslate&QueryName=QryTableItem&ResultSetType=array&TableName=" +PageLogicObj.v_TableName;
  	PageLogicObj.m_TextFieldName.reload(url);
}

function InitCombox() {
	
	PageLogicObj.m_TextLanguage = $HUI.combobox("#TextLanguage", {
		url:$URL+"?ClassName=web.DHCBL.CT.SSLanguage&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'CTLANCode',
		textField:'CTLANDesc'
	});
	
	PageLogicObj.m_TextFieldName = $HUI.combobox("#TextFieldName", {
		//url:$URL+"?ClassName=DHCDoc.DHCDocConfig.LocalConfig&QueryName=QryProductLine&ResultSetType=array",
		valueField:'id',
		textField:'text'
	});
	
	PageLogicObj.m_Product = $HUI.combobox("#product", {
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.LocalConfig&QueryName=QryProductLine&ResultSetType=array",
		valueField:'code',
		textField:'name'
	});
	
	$('#BTTableName').combobox({ 
		url:$URL+"?ClassName=DHCDoc.PW.CFG.BCTranslate&QueryName=QryType&ResultSetType=array",
		valueField:'id',
		textField:'text',
		onSelect:function(row){
        	$('#BTFieldName').combobox('enable');
           	$('#BTFieldName').combobox('clear');
          	var url=$URL+"?ClassName=DHCDoc.PW.CFG.BCTranslate&QueryName=QryTableItem&ResultSetType=array&TableName=" +row.id;
          	$('#BTFieldName').combobox('reload',url);
         }

	});
	
	$('#BTFieldName').combobox({ 
		valueField:'id',
		textField:'text'
	});
	
	$('#BTLanguages').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.SSLanguage&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'CTLANCode',
		textField:'CTLANDesc'
	});
	
	
}

function SaveFunLib(id) {
	var SAVE_ACTION_URL = "../csp/dhcdoc.passwork.bcdatatrans.csp?pClassName=web.DHCBL.BDP.BDPTranslation&pClassMethod=SaveEntity&pEntityName=web.Entity.BDP.BDPTranslation";
		
	var BTTableName=$("#BTTableName").combobox('getValue')
	if ((BTTableName==undefined)||(BTTableName=="undefined")||(BTTableName==""))
	{
		$.messager.alert('提示','表名不能为空',"info");
		return;
	}
	var BTFieldName=$("#BTFieldName").combobox('getValue')
	if ((BTFieldName==undefined)||(BTFieldName=="undefined")||(BTFieldName==""))
	{
		$.messager.alert('提示','字段名不能为空',"info");
		return;
	}
	var BTLanguages=$('#BTLanguages').combobox('getValue')
	if ((BTLanguages==undefined)||(BTLanguages=="undefined")||(BTLanguages==""))
	{
		$.messager.alert('提示','语言不能为空!',"info");
		return;
	}
	var BTFieldDesc=$("#BTFieldDesc").val()
	if ($.trim(BTFieldDesc)=="")
	{
		$.messager.alert('提示','翻译前中文不能为空!',"info");
		return;
	}
	var BTTransDesc=$("#BTTransDesc").val()
	if ($.trim(BTTransDesc)=="")
	{
		$.messager.alert('提示','翻译后内容不能为空！',"info");
		return;
	}	
	var result= tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","Translated",id,BTTableName,BTFieldName,BTLanguages,BTFieldDesc);
	if(result==0){
		$.messager.confirm('提示', "确认要保存数据吗?", function(r){
			if (r){
				///保存
				$('#form-save').form('submit', { 
					url: SAVE_ACTION_URL,
					success: function (data) { 
						  var data=eval('('+data+')'); 
						  if (data.success == 'true') {
								$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
								if (id!="")
								{
									PageLogicObj.m_ListGrid.reload();
								}
								else{
									/*
									 $.cm({
										ClassName:"web.DHCBL.BDP.BDPTranslation",
										QueryName:"GetListHISUI",
										rowid: data.id   
									},function(jsonData){
										$('#mygrid').datagrid('insertRow',{
											index:0,
											row:jsonData.rows[0]
										})
									})
									$('#mygrid').datagrid('unselectAll');
									*/
								}
								PageLogicObj.m_ListGrid.reload();
								$('#myWin').dialog('close'); // close a dialog
						  } 
						  else { 
								var errorMsg ="提交失败！"
								if (data.errorinfo) {
									errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
								}
								$.messager.alert('操作提示',errorMsg,"error");
						  }
					} 
				});
			}
		})
	}else{
		$.messager.alert('操作提示',"该字段已翻译！","info");
	}
}
	
function InitTypeGrid () {
	var columns = [[
		{field:'pline',title:'产品线',width:150},
		{field:'name',title:'描述',width:100},
		{field:'code',title:'表名',width:300},
		{field:'id',title:'id',width:100,hidden:true}
    ]]
	var DurDataGrid = $HUI.datagrid("#i-type", {
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		rownumbers:false,
		//autoRowHeight : false,
		pagination : false,  
		idField:"rowid",
		headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCDoc.PW.CFG.BCTranslate",
			QueryName : "QryType",
			InModule: ServerObj.InModule
		},
		onSelect:function(index,data){
			PageLogicObj.v_TableName = data.code;
			ReloadCombox();
			reloadListGrid(data.code)
		},
		columns :columns,
		toolbar:[{
				text:'新增',
				id:'Add',
				iconCls: 'icon-add'
			},{
				text:'修改',
				id:'Edit',
				iconCls: 'icon-write-order'
            }
            ,{
				text:'删除',
				id:'Del',
				iconCls: 'icon-cancel'
			}
		]
	});
	
	PageLogicObj.m_TypeGrid = DurDataGrid;
}

function InitListGrid () {
	var columns = [[
		{field:'ID',title:'ID',width:60,sortable:true,hidden:true},//,hidden:true
		{field:'BTTableName',title:'类名',width:150,sortable:true,hidden:true},//,sorter:sort_int 
		{field:'BTFieldName',title:'字段名',width:100,sortable:true,hidden:false},
		{field:'BTFieldDesc',title:'翻译前中文',width:100,sortable:true},
		{field:'BTLanguages',title:'语言',width:50,sortable:true},
		{field:'BTTransDesc',title:'翻译后内容',width:100,sortable:true},
		
    ]]
	var DurDataGrid = $HUI.datagrid("#i-list", {
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		rownumbers:false,
		//autoRowHeight : false,
		pagination : false,  
		idField:"rowid",
		headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			//ClassName : "web.DHCBL.BDP.BDPTranslation",
			//QueryName : "GetListHISUI",
			//language: "",
			//tablename: ""
		},
		onSelect:function(index,data){
			
		},
		columns :columns,
		toolbar:[{
				text:'新增',
				id:'BTAdd',
				iconCls: 'icon-add'
			},{
				text:'修改',
				id:'BTEdit',
				iconCls: 'icon-write-order'
            }
            ,{
				text:'删除',
				id:'BTDel',
				iconCls: 'icon-cancel'
			}
		]
	});
	
	PageLogicObj.m_ListGrid = DurDataGrid;
}

function reloadListGrid(tablename,language) {
	PageLogicObj.m_ListGrid.clearSelections();
	var fielddesc = $.trim($("#TextFieldDesc").val());
		fieldname = PageLogicObj.m_TextFieldName.getValue()||"",
		language = PageLogicObj.m_TextLanguage.getValue()||"";
		
	PageLogicObj.m_ListGrid.reload({
		ClassName : "DHCDoc.PW.CFG.BCTranslate",
		QueryName : "GetListHISUI",
		language: language,	//language||"EN",
		tablename: tablename,
		fieldname:fieldname,
		fielddesc:fielddesc
	})
}

function FindHandler() {
	var InModule=PageLogicObj.m_Product.getValue()||"",
		InCode=$.trim($("#InName").val());
	
	PageLogicObj.m_TypeGrid.clearSelections();
	PageLogicObj.m_TypeGrid.reload({
		ClassName : "DHCDoc.PW.CFG.BCTranslate",
		QueryName : "QryType",
		InModule:InModule,
		InCode: InCode
	})
}

function ClearHandler() {
	PageLogicObj.v_TableName="";
	PageLogicObj.m_Product.clear();
	$("#InName").val("");
	FindHandler();
	PageLogicObj.m_TextLanguage.clear();
	PageLogicObj.m_TextFieldName.clear();
	$("#TextFieldDesc").val("");
	var url=$URL+"?ClassName=DHCDoc.PW.CFG.BCTranslate&QueryName=QryTableItem&ResultSetType=array&TableName=" +"undefined";
  	PageLogicObj.m_TextFieldName.reload(url);
	reloadListGrid("undefined");
	
}

function ItemFindHandler() {
	if (PageLogicObj.v_TableName == "") {
		$.messager.popover({msg: '请先选择翻译类型！',type:'error',timeout: 1000});
		return false;
	}
	reloadListGrid(PageLogicObj.v_TableName);
}

function ItemClearHandler() {
	$("#TextFieldDesc").val("");
	PageLogicObj.m_TextFieldName.clear();
	PageLogicObj.m_TextLanguage.clear();
	reloadListGrid(PageLogicObj.v_TableName);
	
}