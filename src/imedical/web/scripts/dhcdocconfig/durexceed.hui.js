/**
 * durexceed.hui.js 疗程超量原因配置
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2018-08-10
 * 
 * TABL: DHCDoc_ExceedReason
 */

//页面全局变量
var PageLogicObj = {
	m_DurDataGrid : "",
	m_SDateBox : "",
	m_EDateBox : "",
	m_Win : "",
	m_TimeWin : ""
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
	
	//页面元素初始化
	//PageHandle();
})

function Init(){
	var hospComp = GenUserHospComp();
	PageLogicObj.m_DurDataGrid = InitDurDataGrid();
	hospComp.jdata.options.onSelect = function(e,t){
		$('#i-durGrid').datagrid('reload');
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		$('#i-durGrid').datagrid('reload');
	}
}

function InitEvent(){
	$("#i-find").click(findConfig);
	$("#i-add").click(function(){opDialog("add")});
	$("#i-edit").click(function(){opDialog("edit")});
	$("#i-delete").click(function(){deConfig()});
	$("#i-set").click(function(){setDurTime()});
	$("#i-code").keydown(function(e){
		if(e.which == 13 || event.which == 9){
			findConfig();
		}
	})
	$("#i-reason").keydown(function(e){
		if(e.which == 13 || event.which == 9){
			findConfig();
		}
	})
	$(document.body).bind("keydown",BodykeydownHandler)
}

function PageHandle(){
	//
}

function InitDurDataGrid(){
	//TABLE: DHCDocIPBDictory
	var columns = [[
		{field:'TExceedCode',title:'代码',width:100},
		{field:'TExceedDesc',title:'超量原因',width:300},
		{field:'TExceedFromDate',title:'起始日期',width:100},
		{field:'TExceedEndDate',title:'截止日期',width:100},
		{field:'ExceedID',title:'ID',width:60}
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
			ClassName : "web.DHCDocExceedReason",
			QueryName : "DHCExceedReason",
			ExceedType: "",
			ExceedCode: $("#i-code").val(),
			ExceedDesc: $("#i-reason").val()
		},
		//idField:'Rowid',
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
			},{
				text:'设置限定时间',
				id:'i-set',
				iconCls: 'icon-copy-sos'
			},{
		        text: '授权医院',
		        iconCls: 'icon-house',
		        handler: function() {
			        var row=$('#i-durGrid').datagrid('getSelected');
					if (!row){
						$.messager.alert("提示","请选择一行！")
						return false
					}
					GenHospWin("DHCDoc_ExceedReason",row.ExceedID);
			    }
		    }],
		 onBeforeLoad:function(param){
		 	var HospID=$HUI.combogrid('#_HospUserList').getValue();
		 	if(HospID=='') return false;
		 	param.HospID=HospID;
		 }
	});
	
	return DurDataGrid;
}

//编辑或新增
function opDialog(action) {
	var selected = PageLogicObj.m_DurDataGrid.getSelected();
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
		$("#i-id").val(selected.Rowid);
	}
	
	if($('#i-dialog').hasClass("c-hidden")) {
		$('#i-dialog').removeClass("c-hidden");
	};
	
	//日期
	var sDateBox = $HUI.datebox("#i-diag-sdate",{
		//required:true  
	});
	
	var eDateBox = $HUI.datebox("#i-diag-edate",{
		//required:true  
	});
	PageLogicObj.m_SDateBox = sDateBox;
	PageLogicObj.m_EDateBox = eDateBox;
	if (action == "add") {
		sDateBox.setValue("");
		eDateBox.setValue("");
		$("#i-id").val("");
		$("#i-action").val("add");
		$("#i-diag-code").val("");
		$("#i-diag-reason").val("");
	} else {
		$("#i-id").val(selected.ExceedID);
		$("#i-action").val("edit");
		sDateBox.setValue(selected.TExceedFromDate);
		eDateBox.setValue(selected.TExceedEndDate);
		$("#i-diag-code").val(selected.TExceedCode);
		$("#i-diag-reason").val(selected.TExceedDesc);
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
	var selected = PageLogicObj.m_DurDataGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示","请选择一条记录！","info")
		return false;
	}
	$.m({
			ClassName:"web.DHCDocExceedReason",
			MethodName:"Delete",
			'ID': selected.ExceedID,
		},function (responseText){
			if(responseText == 0) {
				$.messager.alert('提示','删除成功！',"info");
				PageLogicObj.m_DurDataGrid.reload();
			} else {
				$.messager.alert('提示','修改失败,错误代码: '+ responseText , "info");
				return false;
			}	
		})
}

function setDurTime() {
	if($('#i-time').hasClass("c-hidden")) {
		$('#i-time').removeClass("c-hidden");
	};
	//赋值
	$.m({
		ClassName:"web.DHCDocExceedReason",
		MethodName:"GetExceedDate",
		'AdmType':"O"
	},function (responseText){
		$("#i-time-mz").val(responseText);	
	})
	
	$.m({
		ClassName:"web.DHCDocExceedReason",
		MethodName:"GetExceedDate",
		'AdmType':"E"
	},function (responseText){
		$("#i-time-jz").val(responseText);	
	})
	
	//
	var cWin = $HUI.window('#i-time', {
		title: "设置限定时间",
		iconCls: "icon-w-clock",
		modal: true,
		minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
		onClose: function () {
			//$(this).window('destroy');
			$('#i-time').addClass("c-hidden");
		}
	});
	PageLogicObj.m_TimeWin = cWin;
}

function saveTime () {	
	var mzTime = $.trim($("#i-time-mz").val());	
	var jzTime = $.trim($("#i-time-jz").val());	
	var otn=tkMakeServerCall("web.DHCDocExceedReason","SetExceedDate","O",mzTime);
	var etn=tkMakeServerCall("web.DHCDocExceedReason","SetExceedDate","E",jzTime);
	$.messager.alert('提示','设置成功！',"info");
	PageLogicObj.m_TimeWin.close();
}

//保存字典信息
function saveCfg() {
	var id = $("#i-id").val();
	var action = $("#i-action").val();
	var code = $.trim($("#i-diag-code").val());
	var desc = $.trim($("#i-diag-reason").val());
	var sDate = PageLogicObj.m_SDateBox.getValue();
	var eDate = PageLogicObj.m_EDateBox.getValue();
	var type = "";
	
	if (code == "") {
		$.messager.alert('提示','代码不能为空！',"info");
		return false;
	}
	if (desc == "") {
		$.messager.alert('提示','超量原因不能为空！',"info");
		return false;
	}
	var methodName = "Update";
	var paraStr = code + "^" + desc  + "^" + type + "^" + sDate  + "^" + eDate;
	
	if (action == "add") {
		methodName = "Insert";
		$.m({
			ClassName:"web.DHCDocExceedReason",
			MethodName:methodName,
			'str':paraStr,
			HospID:$HUI.combogrid('#_HospUserList').getValue()
		},function (responseText){
			if(responseText == 0) {
				$.messager.alert('提示','新增成功！',"info");
				PageLogicObj.m_Win.close();
				PageLogicObj.m_DurDataGrid.reload();
				
			} else {
				$.messager.alert('提示','新增失败,错误代码: '+ responseText , "info");
				return false;
			}	
		})
	} else {
		$.m({
			ClassName:"web.DHCDocExceedReason",
			MethodName:methodName,
			'ID': id,
			'str':paraStr
		},function (responseText){
			if(responseText == 0) {
				$.messager.alert('提示','修改成功！',"info");
				PageLogicObj.m_Win.close();
				PageLogicObj.m_DurDataGrid.reload();
				
			} else {
				$.messager.alert('提示','修改失败,错误代码: '+ responseText , "info");
				return false;
			}	
		})
	}
}
function findConfig () {
	var code = $("#i-code").val();
	var reason = $("#i-reason").val();
	PageLogicObj.m_DurDataGrid.reload({
		ClassName : "web.DHCDocExceedReason",
		QueryName : "DHCExceedReason",
		ExceedType: "",
		ExceedCode: code,
		ExceedDesc: reason
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


