/**
 * ipb.dictionary.js 住院证字典维护
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2018-08-10
 * 
 */
 
//页面全局变量
var PageLogicObj = {
	m_DicDataGrid : "",
	m_TypeCombox : "",
	m_SDateBox : "",
	m_EDateBox : "",
	m_Win : ""
}

$(function(){
	var hospComp = GenUserHospComp();
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
	
	//页面元素初始化
	PageHandle();
	hospComp.jdata.options.onSelect = function(e,t){
		PageLogicObj.m_DicDataGrid.reload();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		PageLogicObj.m_DicDataGrid.reload();
	}
})

function Init(){
	PageLogicObj.m_DicDataGrid = InitDicDataGrid();
}

function InitEvent(){
	$("#i-add").click(function(){opDictionary("add")});
	$("#i-edit").click(function(){opDictionary("edit")});
	$(document.body).bind("keydown",BodykeydownHandler)
}

function PageHandle(){
	//
}

function InitDicDataGrid(){
	//TABLE: DHCDocIPBDictory
	var columns = [[
		{field:'Code',title:'代码',width:200},
		{field:'Desc',title:'描述',width:200},
		{field:'Type',title:'字典类别',width:150},
		{field:'Active',title:'状态',width:60},
		{field:'DateFrom',title:'起始日期',width:100},
		{field:'DateTo',title:'截止日期',width:100},
		{field:'StrA',title:'备注1',width:60},
		{field:'StrB',title:'备注2',width:60},
		{field:'StrC',title:'备注3',width:60},
		{field:'StrD',title:'备注4',width:60},
		/*{field:'HospitalDesc',title:'医院',width:260},*/
		{field:'Rowid',title:'Rowid'}
    ]]
	var DicDataGrid = $HUI.datagrid("#i-dicList", {
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		rownumbers:true,
		//autoRowHeight : false,
		pagination : true,  
		headerCls:'panel-header-gray',
		pageSize:14,
		pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "web.DHCDocIPBDictionaryCtl",
			QueryName : "QueryAll"
		},
		idField:'Rowid',
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
		        text: '授权医院',
		        iconCls: 'icon-house',
		        handler: function() {
			        var row=$('#i-dicList').datagrid('getSelected');
					if (!row){
						$.messager.alert("提示","请选择一行！")
						return false
					}
					GenHospWin("DHCDocIPBDictory",row.Rowid);
			    }
		    }],
		onBeforeLoad:function(param){
			param.HospID=$HUI.combogrid('#_HospUserList').getValue();
		}
	});
	
	return DicDataGrid;
}

//编辑或新增
function opDictionary(action) {
	var selected = PageLogicObj.m_DicDataGrid.getSelected();
	var _title = "", _icon = "" ;
	if (action == "add") {
		_title = "新增字典";
		_icon = "icon-w-add";
		$("#i-action").val("add");
		$("#i-id").val("");
	} else {
		if (!selected) {
			$.messager.alert("提示","请选择一条记录！","info")
			return false;
		}
		_title = "修改字典";
		_icon = "icon-w-edit";
		$("#i-action").val("edit");
		$("#i-id").val(selected.Rowid);
	}
	
	if($('#i-config').hasClass("c-hidden")) {
		$('#i-config').removeClass("c-hidden");
	};
	//字典类型
	var typeCombo = $HUI.combobox("#i-type", {
		url:$URL+"?ClassName=web.DHCDocIPBDictionaryCtl&QueryName=QryIPBDic&type=SYS&ResultSetType=array",
		valueField:'id',
		textField:'text'
	})
	//日期
	var sDateBox = $HUI.datebox("#i-sdate",{
		//required:true  
	});
	
	var eDateBox = $HUI.datebox("#i-edate",{
		//required:true  
	});
	PageLogicObj.m_TypeCombox = typeCombo;
	PageLogicObj.m_SDateBox = sDateBox;
	PageLogicObj.m_EDateBox = eDateBox;
	if (action == "add") {
		typeCombo.setValue("");
		sDateBox.setValue("");
		eDateBox.setValue("");
		$("#i-code").val("");
		$("#i-desc").val("");
		$("#i-note1").val("");
		$("#i-note2").val("");
		$("#i-note3").val("");
		$("#i-note4").val("");
		$("#i-active").checkbox("uncheck");
	} else {
		typeCombo.setValue(selected.Type);
		sDateBox.setValue(selected.DateFrom);
		eDateBox.setValue(selected.DateTo);
		$("#i-code").val(selected.Code);
		$("#i-desc").val(selected.Desc);
		$("#i-note1").val(selected.StrA);
		$("#i-note2").val(selected.StrB);
		$("#i-note3").val(selected.StrC);
		$("#i-note4").val(selected.StrD);
		if (selected.Active == "Y") {
			$("#i-active").checkbox("check");
		} else {
			$("#i-active").checkbox("uncheck");
		}
	}
	
	var cWin = $HUI.window('#i-config', {
		title: _title,
		iconCls: _icon,
		modal: true,
		minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
		onClose: function () {
			//$(this).window('destroy');
			$('#i-config').addClass("c-hidden");
		}
	});
	
	PageLogicObj.m_Win = cWin;
}

//保存字典信息
function saveDictionary() {
	var id = $("#i-id").val();
	var action = $("#i-action").val();
	var code = $.trim($("#i-code").val());
	var desc = $.trim($("#i-desc").val());
	var type = PageLogicObj.m_TypeCombox.getValue()||"";
	var sDate = PageLogicObj.m_SDateBox.getValue();
	var eDate = PageLogicObj.m_EDateBox.getValue();
	var note1 = $.trim($("#i-note1").val());
	var note2 = $.trim($("#i-note2").val());
	var note3 = $.trim($("#i-note3").val());
	var note4 = $.trim($("#i-note4").val());
	var active = $("#i-active").checkbox("getValue");
	if (active) {
		active = "Y"
	} else {
		active = "N"
	}
	if (type == "") {
		$.messager.alert('提示','字典类型不能为空!',"info");
		return false;
	}
	if ((code == "")||(desc == "")) {
		$.messager.alert('提示','字典代码和字典描述不能为空!',"info");
		return false;
	}
	var HospID=session['LOGON.HOSPID'];
	var paraStr = id + "^" + code + "^" + desc  + "^" + type  + "^" + active  + "^" + sDate ;
	paraStr = paraStr + "^" + eDate + "^" + note1  + "^" + note2  + "^" + note3  + "^" + note4 +"^"+HospID;
	
	$.m({
			ClassName:"web.DHCDocIPBDictionaryCtl",
			MethodName:"Update",
			'InPut':paraStr,HospID:$HUI.combogrid('#_HospUserList').getValue()
		},function (responseText){
			if(responseText > 0)
			{
				$.messager.alert('提示','保存成功！',"info");
				PageLogicObj.m_Win.close();
				PageLogicObj.m_DicDataGrid.reload();
				
			}else{
				$.messager.alert('提示','保存失败,错误代码: '+ responseText , "info");
				return false;
			}	
		})
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


