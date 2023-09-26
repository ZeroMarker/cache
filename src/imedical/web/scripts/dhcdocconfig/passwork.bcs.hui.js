/**
 * passwork.bcs.hui.js 交班本配置
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2018-08-10
 * 
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
	InitBaseData();
	PageLogicObj.m_Grid = InitGrid();
}
function InitEvent(){
	$("#i-find").click(findConfig);
	$("#i-add").click(function(){opDialog("add")});
	$("#i-edit").click(function(){opDialog("edit")});
	//$("#i-delete").click(function(){deConfig()});
	$("#i-rule").click(InitRuleDg);
	$("#i-pat").click(InitPatDg);
	$(document.body).bind("keydown",BodykeydownHandler)
}

function PageHandle(){
	
}

/**
 * 初始化基础数据
 */
function InitBaseData () {
	var responseText = $.m({
		ClassName:"DHCDoc.DHCDocConfig.PassWork",
		MethodName:"InitBaseData",
	},false);

	return responseText;
}
function InitPatDg () {
	if($('#dg-pat').hasClass("c-hidden")) {
		$('#dg-pat').removeClass("c-hidden");
	};
	
	$("#dg-pat-code").val("").removeAttr("disabled");
	$("#dg-pat-desc").val("");
	$("#dg-pat-isDisplay").checkbox("uncheck");
	$("#dg-pat-disNo").val("");
	$("#dg-pat-url").val("");
	$("#dg-pat-wh").val("");
			
	PageLogicObj.m_dg_patGrid = InitPatGrid();

	var cWin = $HUI.window('#dg-pat', {
		title: "病人类型",
		iconCls: "icon-w-config",
		modal: true,
		minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
		onClose: function () {
			$('#dg-pat').addClass("c-hidden");
		}
	});
	
	PageLogicObj.m_dg_ruleWin = cWin;

	InitPatEvent();
}

function InitRuleDg () {
	if($('#dg-rule').hasClass("c-hidden")) {
		$('#dg-rule').removeClass("c-hidden");
	};
	
	$("#dg-rule-code").val("").removeAttr("disabled");
	$("#dg-rule-desc").val("");
	$("#dg-rule-value").val("");
			
	PageLogicObj.m_dg_ruleGrid = InitRuleGrid();

	var cWin = $HUI.window('#dg-rule', {
		title: "规则配置",
		iconCls: "icon-w-config",
		modal: true,
		minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
		onClose: function () {
			$('#dg-rule').addClass("c-hidden");
		}
	});
	
	PageLogicObj.m_dg_ruleWin = cWin;

	InitRuleEvent();
	
}

function InitRuleEvent() {
	$("#dg-rule-save").unbind();
	$("#dg-rule-save").click(function () {
		var action = "add";
		var selected = PageLogicObj.m_dg_ruleGrid.getSelected();
		var code = $.trim($("#dg-rule-code").val());
		var desc = $.trim($("#dg-rule-desc").val());
		var value = $.trim($("#dg-rule-value").val());
		if (code == "") {
			$.messager.alert("提示","代码不能为空！","info")
			return false;
		}
		if (desc == "") {
			$.messager.alert("提示","描述不能为空！","info")
			return false;
		}
		if (selected) {
			action = "edit";
		}
		var responseText = $.m({
			ClassName:"DHCDoc.DHCDocConfig.PassWork",
			MethodName:"SaveRule",
			code:code,
			desc: desc,
			value:value,
			action:action
		},false);
		if (responseText == 0) {
			//$.messager.alert("提示","代码不能为空！","info");
			$.messager.popover({msg:"保存成功！",type:'success'});
			PageLogicObj.m_dg_ruleGrid.reload();
			$("#dg-rule-code").val("").removeAttr("disabled");
			$("#dg-rule-desc").val("");
			$("#dg-rule-value").val("");
			return true;
		} else if (responseText == "-1") {
			$.messager.popover({msg:"代码重复！",type:'alert'});
			return false;
		} else {
			$.messager.popover({msg:"保存失败！",type:'error'});
			return false;
		}
	});
}

function InitPatEvent() {
	$("#dg-pat-save").unbind();
	$("#dg-pat-save").click(function () {
		var action = "add";
		var selected = PageLogicObj.m_dg_patGrid.getSelected();
		var code = $.trim($("#dg-pat-code").val());
		var desc = $.trim($("#dg-pat-desc").val());
		var isDisplay = $("#dg-pat-isDisplay").checkbox("getValue")?1:0;
		var disNo = $.trim($("#dg-pat-disNo").val());
		var url = $.trim($("#dg-pat-url").val());
		var wh = $.trim($("#dg-pat-wh").val());
		if (code == "") {
			$.messager.alert("提示","代码不能为空！","info")
			return false;
		}
		if (desc == "") {
			$.messager.alert("提示","描述不能为空！","info")
			return false;
		}
		if (disNo == "") {
			$.messager.alert("提示","显示顺序不能为空！","info")
			return false;
		}
		if (url == "") {
			$.messager.alert("提示","模板链接不能为空！","info")
			return false;
		}
		if (wh == "") {
			$.messager.alert("提示","宽高不能为空！","info")
			return false;
		}
		if (selected) {
			action = "edit";
		}
		var responseText = $.m({
			ClassName:"DHCDoc.DHCDocConfig.PassWork",
			MethodName:"SavePat",
			code:code,
			desc: desc,
			isDisplay:isDisplay,
			disNo:disNo,
			url:url,
			wh:wh,
			action:action
		},false);
		if (responseText == 0) {
			//$.messager.alert("提示","代码不能为空！","info");
			$.messager.popover({msg:"保存成功！",type:'success'});
			PageLogicObj.m_dg_patGrid.reload();
			$("#dg-pat-code").val("").removeAttr("disabled");
			$("#dg-pat-desc").val("");
			$("#dg-pat-isDisplay").checkbox("uncheck");
			$("#dg-pat-disNo").val("");
			$("#dg-pat-url").val("");
			$("#dg-pat-wh").val("");
			return true;
		} else if (responseText == "-1") {
			$.messager.popover({msg:"代码重复！",type:'alert'});
			return false;
		} else {
			$.messager.popover({msg:"保存失败！",type:'error'});
			return false;
		}
	});
}

/**
 * 加载病人类型Grid
 */
function InitPatGrid(){
	var columns = [[
		{field:'code',title:'代码',width:100},
		{field:'desc',title:'描述',width:100},
		{field:'isDisplay',title:'是否显示',width:80,
			formatter:function(value,row,index){
				if (value == 1) {
					return "<span class='c-ok'>是</span>"
				} else {
					return "<span class='c-no'>否</span>"
				}
			}
		},
		{field:'disNo',title:'显示顺序',width:80},
		{field:'wh',title:'宽高',width:80},
		{field:'tplURL',title:'模板链接',width:200},
    ]]
	var DurDataGrid = $HUI.datagrid("#dg-patgrid", {
		fit : true,
		border : false,
		striped : true,
		nowrap:false,
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
			ClassName : "DHCDoc.DHCDocConfig.PassWork",
			QueryName : "QryPat"
		},
		onBeforeSelect:function(index, row){
			var selrow = PageLogicObj.m_dg_patGrid.getSelected();
			if (selrow){
				var oldIndex = PageLogicObj.m_dg_patGrid.getRowIndex(selrow);
				if (oldIndex == index){
					PageLogicObj.m_dg_patGrid.unselectRow(index);
					return false;
				}
			}
		},
		onUnselect: function (rowIndex, rowData) {
			$("#dg-pat-code").val("").removeAttr("disabled");
			$("#dg-pat-desc").val("");
			$("#dg-pat-isDisplay").checkbox("uncheck");
			$("#dg-pat-disNo").val("");
			$("#dg-pat-url").val("");
			$("#dg-pat-wh").val("");
		},
		onSelect: function (rowIndex, rowData) {
			$("#dg-pat-code").val(rowData.code).attr("disabled","disabled");;
			$("#dg-pat-desc").val(rowData.desc);
			$("#dg-pat-disNo").val(rowData.disNo);
			$("#dg-pat-url").val(rowData.tplURL);
			$("#dg-pat-wh").val(rowData.wh);
			if (rowData.isDisplay == 1) {$("#dg-pat-isDisplay").checkbox("check")}
			else {$("#dg-pat-isDisplay").checkbox("uncheck")}
		},
		columns :columns
	});
	
	return DurDataGrid;
}

/**
 * 加载规则列表Grid
 */
function InitRuleGrid(){
	var columns = [[
		{field:'code',title:'代码',width:50},
		{field:'desc',title:'描述',width:100},
		{field:'value',title:'数值',width:200}
    ]]
	var DurDataGrid = $HUI.datagrid("#dg-rulegrid", {
		fit : true,
		border : false,
		striped : true,
		nowrap:false,
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
			ClassName : "DHCDoc.DHCDocConfig.PassWork",
			QueryName : "QryRule"
		},
		onBeforeSelect:function(index, row){
			var selrow = PageLogicObj.m_dg_ruleGrid.getSelected();
			if (selrow){
				var oldIndex = PageLogicObj.m_dg_ruleGrid.getRowIndex(selrow);
				if (oldIndex == index){
					PageLogicObj.m_dg_ruleGrid.unselectRow(index);
					return false;
				}
			}
		},
		onUnselect: function (rowIndex, rowData) {
			$("#dg-rule-code").val("").removeAttr("disabled");
			$("#dg-rule-desc").val("");
			$("#dg-rule-value").val("");
		},
		onSelect: function (rowIndex, rowData) {
			$("#dg-rule-code").val(rowData.code).attr("disabled","disabled");
			$("#dg-rule-desc").val(rowData.desc);
			$("#dg-rule-value").val(rowData.value);
		},
		columns :columns
	});
	
	return DurDataGrid;
}

function InitGrid(){
	var columns = [[
		{field:'code',title:'代码',width:100},
		{field:'name',title:'班次',width:100},
		{field:'seqno',title:'第几班次',width:100},
		{field:'sTime',title:'起始时间',width:100},
		{field:'eTime',title:'结束时间',width:100},
        {field:'nextDay',title:'跨日标志',width:100,
			formatter:function(value,row,index){
                if (value == 2) {
                    return "横跨今天和明天"
                } else if (value == 1) {
                    return "单跨明天"
                } else {
					return "不跨日"
				}
            }
		},
        {field:'active',title:'是否激活',width:100,
            formatter:function(value,row,index){
                if (value == 1) {
                    return "<span class='c-ok'>是</span>"
                } else {
                    return "<span class='c-no'>否</span>"
                }
            }
        },
        {field:'note',title:'备注',width:60},
        {field:'rowid',title:'ID',width:60,hidden:true}
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
			ClassName : "DHCDoc.DHCDocConfig.PassWork",
			QueryName : "QryPWConfig"
		},
		onUnselect:function(){
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
            ,{
				text:'病人类型',
				id:'i-pat',
				iconCls: 'icon-batch-cfg'
			},{
				text:'规则配置',
				id:'i-rule',
				iconCls: 'icon-paper-cfg'
			}
		]
	});
	
	return DurDataGrid;
}

//编辑或新增
function opDialog(action) {
	var selected = PageLogicObj.m_Grid.getSelected();
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
		$("#i-id").val(selected.rowid);
	}
	
	if($('#i-dialog').hasClass("c-hidden")) {
		$('#i-dialog').removeClass("c-hidden");
	};
	
	PageLogicObj.m_nextday = $HUI.combobox("#i-diag-nextday",{
		valueField:'id',
		textField:'text',
		multiple:false,
		//rowStyle:'checkbox', //显示成勾选行形式
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'0',text:'不跨日'},{id:'1',text:'单跨明天'},{id:'2',text:'横跨今天和明天'}
		]
	});
	
	if (action == "add") {
		$("#i-diag-code").val("");
        $("#i-diag-name").val("");
		$("#i-diag-seqno").numberbox("setValue","");
        $("#i-diag-stime").timespinner("clear");
        $("#i-diag-etime").timespinner("clear");
        //$("#i-diag-nextday").checkbox("uncheck");
		PageLogicObj.m_nextday.setValue(0);
        $("#i-diag-active").checkbox("uncheck");
        $("#i-diag-note").val("");
	} else {
        $("#i-diag-code").val(selected.code);
        $("#i-diag-name").val(selected.name);
		$("#i-diag-seqno").numberbox("setValue",selected.seqno)
        $("#i-diag-stime").timespinner("setValue", selected.sTime);
        $("#i-diag-etime").timespinner("setValue", selected.eTime);
        //if (selected.nextDay == 1) $("#i-diag-nextday").checkbox("check")
        //else $("#i-diag-nextday").checkbox("uncheck")
		PageLogicObj.m_nextday.setValue(selected.nextDay);
        if (selected.active == 1) $("#i-diag-active").checkbox("check")
        else $("#i-diag-active").checkbox("uncheck");
        $("#i-diag-note").val(selected.note);
	}
	$("#i-diag-code").validatebox("validate");
	$("#i-diag-name").validatebox("validate");
	$("#i-diag-seqno").numberbox("validate");
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
    var code = $.trim($("#i-diag-code").val());
    var name = $.trim($("#i-diag-name").val());
    var stime = $("#i-diag-stime").timespinner("getValue")||"";
    var etime = $("#i-diag-etime").timespinner("getValue")||"";
    var nextday = PageLogicObj.m_nextday.getValue();	//$("#i-diag-nextday").checkbox("getValue")?1:0;
    var active = $("#i-diag-active").checkbox("getValue")?1:0;
    var note = $.trim($("#i-diag-note").val());
    var seqno = $.trim($("#i-diag-seqno").val());
	var paraInStr = id + "^" + code + "^" + name + "^" + stime + "^" + etime + "^" + nextday + "^" + active;
	paraInStr = paraInStr + "^" + note + "^" + seqno;
	if (code == "") {
		$.messager.alert('提示','班次代码不能为空!',"info");
		return false;
	}
	if (name == "") {
		$.messager.alert('提示','班次名称不能为空!',"info");
		return false;
    }
	if (seqno == "") {
		$.messager.alert('提示','第几班次不能为空!',"info");
		return false;
    }
    rpResult = tkMakeServerCall("DHCDoc.DHCDocConfig.PassWork","HasBCCode", id, code);
    if ( rpResult == 1) {
        $.messager.alert('提示','班次代码已存在!',"info");
        return false;
    }
    $.m({
        ClassName:"DHCDoc.DHCDocConfig.PassWork",
        MethodName:"DBSave",
        inPara:paraInStr
    },function (responseText){
        if(responseText > 0) {
            $.messager.alert('提示','保存成功！',"info");
            PageLogicObj.m_Win.close();
            PageLogicObj.m_Grid.reload();
        } else {
            $.messager.alert('提示','保存失败,错误代码: '+ responseText , "info");
            return false;
        }	
    })
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


