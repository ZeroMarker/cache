/**
 * codetbl.hui.js 医生站代码表外部对照
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2018-08-10
 * 
 * 注解说明：
 * 		TABLE: DHC_DocExtData
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
	PageLogicObj.m_TypeCombox = $HUI.combobox("#i-type", {
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CommonFunction&QueryName=QueryExtDataType&ResultSetType=array",
		valueField:'TCTEDTRowId',
		textField:'TCTEDTDesc',
		editable:false,
		onLoadSuccess: function () {
			var data = $(this).combobox('getData');
			$(this).combobox("select",data[0].TCTEDTRowId);
			PageLogicObj.m_TypeComboxValue = data[0].TCTEDTRowId;
		},
		onSelect: function () {
			findConfig();
		}
	});
	PageLogicObj.m_Grid = InitGrid();
}
function InitEvent(){
	$("#i-find").click(findConfig);
	$("#i-add").click(function(){opDialog("add")});
	$("#i-edit").click(function(){opDialog("edit")});
	$("#i-delete").click(function(){deConfig()});
	$(document.body).bind("keydown",BodykeydownHandler)
}

function PageHandle(){
	
}

function InitGrid(){
	var columns = [[
		{field:'THISCode',title:'HIS代码',width:100},
		{field:'THISDesc',title:'HIS名称',width:100},
		{field:'TMUCCode',title:'外部代码',width:100},
		{field:'TMUCDesc',title:'外部名称',width:100},
		{field:'TActiveFlag',title:'可用标识',width:100},
		{field:'HidRowid',title:'ID',width:60,hidden:true}
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
			ClassName : "web.DHCDocExtData",
			QueryName : "ExtDataQuery",
			SelectTypeCode: PageLogicObj.m_TypeComboxValue
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
			},{
				text:'删除',
				id:'i-delete',
				iconCls: 'icon-cancel'
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
		$("#i-id").val(selected.HidRowid);
	}
	
	if($('#i-dialog').hasClass("c-hidden")) {
		$('#i-dialog').removeClass("c-hidden");
	};
	var type = PageLogicObj.m_TypeCombox.getValue();
	PageLogicObj.m_Diag_TypeCombox = $HUI.combobox("#i-diag-type", {
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CommonFunction&QueryName=QueryExtDataType&ResultSetType=array",
		valueField:'TCTEDTRowId',
		textField:'TCTEDTDesc',
		value:type,
		disabled:true
	});
	
	PageLogicObj.m_Diag_HiscodeCombox = $HUI.combobox("#i-diag-hiscode", {
		url:$URL+"?ClassName=web.DHCDocExtData&QueryName=HisCodeQuery&SelectType="+type+"&SelectHISCode=&ResultSetType=array",
		valueField:'HISRowid',
		textField:'HISCode',
		onSelect: function (record) {
			$("#i-diag-hisname").val(record.HISDesc);	//attr("disabled","disabled");
		}
	});
	if (action == "add") {
		//$("#i-action").val("add");
		PageLogicObj.m_Diag_HiscodeCombox.setValue("");
		$("#i-diag-hisname").val("");
		$("#i-diag-wbcode").val("");
		$("#i-diag-wbname").val("");
		$("#i-diag-active").checkbox("uncheck")
		
	} else {
		//$("#i-action").val("edit");
		// HISCodeRowId
		PageLogicObj.m_Diag_HiscodeCombox.setValue(selected.HISCodeRowId);
		$("#i-diag-hisname").val(selected.THISDesc);
		$("#i-diag-wbcode").val(selected.TMUCCode);
		$("#i-diag-wbname").val(selected.TMUCDesc);
		if (selected.TActiveFlag == "是") {
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

function deConfig () {
	var selected = PageLogicObj.m_Grid.getSelected();
	if (!selected) {
		$.messager.alert("提示","请选择一条记录！","info")
		return false;
	}
	$.m({
			ClassName:"web.DHCDocExtData",
			MethodName:"DeleteExtData",
			MUCRowid: selected.HidRowid
		},function (responseText){
			if(responseText == 0) {
				$.messager.alert('提示','删除成功！',"info");
				PageLogicObj.m_Grid.reload();
			} else {
				$.messager.alert('提示','修改失败,错误代码: '+ responseText , "info");
				return false;
			}	
		})
}


//保存字典信息
function saveCfg() {
	var id = $("#i-id").val();
	var action = $("#i-action").val();
	var type = PageLogicObj.m_TypeCombox.getValue();
	var hisCodeId = PageLogicObj.m_Diag_HiscodeCombox.getValue();
	var hisCode = PageLogicObj.m_Diag_HiscodeCombox.getText();
	var hisname = $("#i-diag-hisname").val();
	var wbcode = $("#i-diag-wbcode").val();
	var wbname = $("#i-diag-wbname").val();
	var active = $("#i-diag-active").checkbox("getValue");
	if (active) {
		active = "Y"
	} else {
		active = "N"
	}
	var paraInStr = type + "^" + hisCodeId + "^" + hisCode + "^" + hisname + "^" + wbcode + "^" + wbname + "^" + active;
	var paraUpStr = hisCodeId + "^" + hisCode + "^" + hisname + "^" + wbcode + "^" + wbname + "^" + active;
	if (hisCodeId == "") {
		$.messager.alert('提示','HIS代码不能为空!',"info");
		return false;
	}
	/*if (wbcode == "") {
		$.messager.alert('提示','外部代码不能为空!',"info");
		return false;
	}
	if (wbname == "") {
		$.messager.alert('提示','外部名称不能为空!',"info");
		return false;
	}*/
	
	var methodName = "ModifyExtData";
	if (action == "add") {
		rpResult = tkMakeServerCall("web.DHCDocExtData","RepeatExtData",type,hisCodeId);
		if ( rpResult == "R") {
			$.messager.alert('提示','记录已存在!',"info");
			return false;
		}
		methodName = "InsertExtData";
		$.m({
			ClassName:"web.DHCDocExtData",
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
		rpResult = tkMakeServerCall("web.DHCDocExtData","RepeatExtData",type,hisCodeId,id);
		if ( rpResult == "R") {
			$.messager.alert('提示','记录已存在!',"info");
			return false;
		}
		$.m({
			ClassName:"web.DHCDocExtData",
			MethodName:methodName,
			InStr:paraUpStr,
			MUCRowid:id
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

//查找
function findConfig () {
	//var text = PageLogicObj.m_ArcimCombox.getText();
	var SelectTypeCode = PageLogicObj.m_TypeCombox.getValue();
	
	PageLogicObj.m_Grid.reload({
		ClassName : "web.DHCDocExtData",
		QueryName : "ExtDataQuery",
		SelectTypeCode: SelectTypeCode
	});
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


