/**
 * codetype.hui.js 外部数据对照类型维护HUI
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2018-08-10
 * 
 * 注解说明
 * TABLE: 
 * 		DHCDoc_CT_ExtDataType 
 */
 
//页面全局变量
var PageLogicObj = {
	m_TypeCombox : "",
	m_TypeComboxValue : "",
	m_Grid : "",
	m_Diag_HiscodeCombox: "",
	m_Diag_TypeCombox: "",
	m_Win : ""
	
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
	
	//页面元素初始化
	PageHandle();
})

function Init(){
	PageLogicObj.m_Grid = InitGrid();
}
function InitEvent(){
	$("#i-add").click(function(){opDialog("add")});
	$("#i-edit").click(function(){opDialog("edit")});
	//$("#i-delete").click(function(){deConfig()});
	$(document.body).bind("keydown",BodykeydownHandler)
}

function PageHandle(){
	
}

function InitGrid(){
	var columns = [[
		{field:'TCTEDTCode',title:'代码',width:100},
		{field:'TCTEDTDesc',title:'名称',width:100},
		{field:'TCTEDTActive',title:'有效标识',width:100},
		//{field:'TCTEDTClassName',title:'类名',width:100},
		//{field:'TCTEDTQueryName',title:'Query名',width:100},
		{field:'TCTEDTTable',title:'HIS表名',width:100},
		{field:'TCTEDTTableCode',title:'HIS表代码字段',width:100},
		{field:'TCTEDTTableDesc',title:'HIS表描述字段',width:100},
		{field:'TCTEDTRowId',title:'ID',width:60,hidden:false}
    ]]
	var DurDataGrid = $HUI.datagrid("#i-durGrid", {
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		rownumbers:true,
		//autoRowHeight : false,
		pagination : true,  
		headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "web.DHCDocCTExtDataType",
			QueryName : "QueryExtDataType"
		},
		columns :columns,
		toolbar:[{
				text:'新增',
				id:'i-add',
				iconCls: 'icon-add'
			},{
				text:'修改',
				id:'i-edit',
				iconCls: 'icon-write-order'
			}
		]
	});
	
	return DurDataGrid;
}

//编辑或新增
function opDialog(action) {
	var selected = PageLogicObj.m_Grid.getSelected();
	var tempValue = "",tempValue2 = "";
	var _title = "", _icon = "" ;
	if (action == "add") {
		_title = "新增";
		_icon = "icon-w-add";
		$("#i-action").val("add");
		$("#i-id").val("");
	} else {
		if (!selected) {
			$.messager.alert("提示","请选择一条记录！","info")
			return false;
		}
		_title = "修改";
		_icon = "icon-w-edit";
		$("#i-action").val("edit");
		$("#i-id").val(selected.TCTEDTRowId);
	}
	
	if($('#i-dialog').hasClass("c-hidden")) {
		$('#i-dialog').removeClass("c-hidden");
	};
	
	if (action == "add") {
		//$("#i-action").val("add");
		$("#i-diag-code").val("");
		$("#i-diag-name").val("");
		$("#i-diag-table").val("");
		$("#i-diag-tableCode").val("");
		$("#i-diag-tableDesc").val("");
		//$("#i-diag-cls").val("");
		//$("#i-diag-query").val("");
		$("#i-diag-active").checkbox("uncheck")
		
	} else {
		//$("#i-action").val("edit");
		// HISCodeRowId
		$("#i-diag-code").val(selected.TCTEDTCode);
		$("#i-diag-name").val(selected.TCTEDTDesc);
		$("#i-diag-table").val(selected.TCTEDTTable);
		$("#i-diag-tableCode").val(selected.TCTEDTTableCode);
		$("#i-diag-tableDesc").val(selected.TCTEDTTableDesc);
		//$("#i-diag-cls").val(selected.TCTEDTClassName);
		//$("#i-diag-query").val(selected.TCTEDTQueryName);
		if (selected.TCTEDTActive == "是") {
			$("#i-diag-active").checkbox("check")
		} else {
			$("#i-diag-active").checkbox("uncheck")
		}
		
	}
	
	var cWin = $HUI.window('#i-dialog', {
		title: _title,
		iconCls: _icon,
		modal: true,
		minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
		onClose: function () {
			//$(this).window('destroy');
			$('#i-dialog').addClass("c-hidden");
		}
	});
	
	PageLogicObj.m_Win = cWin;
}

//保存字典信息
function saveCfg() {
	var id = $("#i-id").val();
	var action = $("#i-action").val();
	
	var code = $.trim($("#i-diag-code").val());
	var name = $.trim($("#i-diag-name").val());
	//var cls = $.trim($("#i-diag-cls").val());
	//var query = $.trim($("#i-diag-query").val());
	var table = $.trim($("#i-diag-table").val());
	var tableCode = $.trim($("#i-diag-tableCode").val());
	var tableDesc = $.trim($("#i-diag-tableDesc").val());
	var active = $("#i-diag-active").checkbox("getValue");
	if (active) {
		active = "Y"
	} else {
		active = "N"
	}
	var paraInStr = code + "^" + name + "^" + "" + "^" + "" + "^" + active + "^" + table + "^" + tableCode + "^" + tableDesc;
	var paraUpStr = paraInStr;
	if (code == "") {
		$.messager.alert('提示','请输入有效的代码!',"info");
		return false;
	}
	if (name == "") {
		$.messager.alert('提示','请输入有效的描述!',"info");
		return false;
	}
	/*if (cls == "") {
		$.messager.alert('提示','请输入有效的类!',"info");
		return false;
	}
	if (query == "") {
		$.messager.alert('提示','请输入有效的Query名称!',"info");
		return false;
	}*/
	if (table == "") {
		$.messager.alert('提示','请输入有效的表!',"info");
		return false;
	}
	if (tableCode == "") {
		$.messager.alert('提示','请输入有效的HIS代码!',"info");
		return false;
	}
	if (tableDesc == "") {
		$.messager.alert('提示','请输入有效的HIS描述!',"info");
		return false;
	}
	var myoptval=$.cm({
				ClassName:"web.DHCDocExtData",
				MethodName:"CheckforTableexcite",
				dataType:"text",
				Table:table,
				TableCode:tableCode,
				TableDesc:tableDesc
			},false);
	if (myoptval!=0){
		$.messager.alert('提示',myoptval,"info");
		return false;
		}
	var methodName = "UpdateExtDataType";
	if (action == "add") {
		methodName = "InsertExtDataType";
		$.m({
			ClassName:"web.DHCDocCTExtDataType",
			MethodName:methodName,
			Instr:paraInStr
		},function (responseText){
			if(responseText == 0) {
				$.messager.alert('提示','新增成功！',"info");
				PageLogicObj.m_Win.close();
				PageLogicObj.m_Grid.reload();
				
			} else {
				$.messager.alert('提示','新增失败,错误代码: '+ responseText , "info");
				return false;
			}	
		})
	} else {
		$.m({
			ClassName:"web.DHCDocCTExtDataType",
			MethodName:methodName,
			InStr:paraUpStr,
			CTEDTRowid:id
		},function (responseText){
			if(responseText == 0) {
				$.messager.alert('提示','修改成功！',"info");
				PageLogicObj.m_Win.close();
				PageLogicObj.m_Grid.reload();
				
			} else {
				$.messager.alert('提示','修改失败,错误代码: '+ responseText , "info");
				return false;
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


