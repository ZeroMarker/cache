/**
 * ordtoord.hui.js 特殊医嘱需开关联/条件医嘱设置
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2018-08-10
 * 
 * 注解说明
 * TABLE: DHC_Doc_OrdLinked
 */
 
//页面全局变量
var PageLogicObj = {
	m_ArcimCombox : "",
	m_SearchGrid: "",
	m_DiagArcimCombox: "",
	m_DiagArcimGrid: "",
	m_NeedArcimCombox: "",
	m_NeedArcimGrid: "",
	m_DurDataGrid : "",
	m_SDateBox : "",
	m_EDateBox : "",
	m_Win : "",
	m_TarcimIDOld: "",
	m_TlinkArcimIDOld: ""
	
}
$(function(){
	InitHospList();	
	//页面元素初始化
	//PageHandle();
	InitCache();
})
function InitCache(){
	var hasCache = $.DHCDoc.ConfigHasCache();
	if (hasCache!=1) {
		$.DHCDoc.CacheConfigPage();
		$.DHCDoc.storageConfigPageCache();
	}
}
function InitHospList()
{
	var hospComp = GenHospComp("DHC_Doc_OrdLinked");
	hospComp.jdata.options.onSelect = function(e,t){
		PageLogicObj.m_ArcimCombox.grid().datagrid('loadData',{total:0,rows:[]});
		PageLogicObj.m_ArcimCombox.setValue("");
		findConfig();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		//初始化
		Init();
		//事件初始化
		InitEvent();
	}
}
function Init(){
	PageLogicObj.m_DurDataGrid = InitDurDataGrid();
	//医嘱类型
	PageLogicObj.m_ArcimCombox = $HUI.combogrid("#i-aricm", {
		panelWidth: 500,
		delay:500,
		mode:'remote',
		idField: 'ArcimDR',
		textField: 'ArcimDesc',
		columns: [[
			{field:'ArcimDesc',title:'项目名称',width:100},
			{field:'ArcimDR',title:'项目ID',width:30}
		]],
		pagination : true,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CommonFunction&QueryName=FindMasterItem&arcimdesc=",
		fitColumns: true,
		enterNullValueClear:true,
		onBeforeLoad:function(param){
			if (param['q']) {
				var desc=param['q'];
			}
			param = $.extend(param,{arcimdesc:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
		}
	});
	PageLogicObj.m_SearchGrid = PageLogicObj.m_ArcimCombox.grid();
	//
	PageLogicObj.m_DiagArcimCombox = $HUI.combogrid("#i-diag-arcim", {
		panelWidth: 500,
		idField: 'ArcimDR',
		textField: 'ArcimDesc',
		delay:500,
		mode:'remote',
		columns: [[
			{field:'ArcimDesc',title:'项目名称',width:100},
			{field:'ArcimDR',title:'项目ID',width:30}
		]],
		pagination : true,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CommonFunction&QueryName=FindMasterItem",
		fitColumns: true,
		enterNullValueClear:false,
		onBeforeLoad:function(param){
			if (param['q']) {
				var desc=param['q'];
			}
			param = $.extend(param,{arcimdesc:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
		}
	});
	PageLogicObj.m_DiagArcimGrid = PageLogicObj.m_DiagArcimCombox.grid();
	
	//
	PageLogicObj.m_NeedArcimCombox = $HUI.combogrid("#i-diag-needarcim", {
		panelWidth: 500,
		idField: 'ArcimDR',
		textField: 'ArcimDesc',
		delay:500,
		mode:'remote',
		columns: [[
			{field:'ArcimDesc',title:'项目名称',width:100},
			{field:'ArcimDR',title:'项目ID',width:30}
		]],
		pagination : true,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CommonFunction&QueryName=FindMasterItem",
		fitColumns: true,
		enterNullValueClear:false,
		onBeforeLoad:function(param){
			if (param['q']) {
				var desc=param['q'];
			}
			param = $.extend(param,{arcimdesc:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
		}
	});
	PageLogicObj.m_NeedArcimGrid = PageLogicObj.m_NeedArcimCombox.grid();
}
function InitEvent(){
	$("#i-find").click(findConfig);
	$("#i-add").click(function(){opDialog("add")});
	$("#i-edit").click(function(){opDialog("edit")});
	$("#i-delete").click(function(){deConfig()});
	$(document.body).bind("keydown",BodykeydownHandler)
}

function PageHandle(){
	//
}

function InitDurDataGrid(){
	//TABLE: DHCDocIPBDictory
	var columns = [[
		{field:'TArcimDesc',title:'医嘱项',width:200},
		{field:'TlinkArcimDesc',title:'需开医嘱项',width:200},
		{field:'TStDate',title:'起始日期',width:60},
		{field:'TEndDate',title:'结束日期',width:60},
		{field:'LRowid',title:'ID',width:60,hidden:true}
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
			ClassName : "web.DHCDocOrdLinkContr",
			QueryName : "FindOrdLink",
			arcimID: "",
			HospId:$HUI.combogrid('#_HospList').getValue()
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
	var selected = PageLogicObj.m_DurDataGrid.getSelected();
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
		$("#i-id").val(selected.Rowid);
		tempValue = selected.TArcimDesc;
		tempValue2 = selected.TlinkArcimDesc;
		PageLogicObj.m_TlinkArcimIDOld = selected.TlinkArcimID;
		PageLogicObj.m_TarcimIDOld = selected.TarcimID;
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
	PageLogicObj.m_NeedArcimCombox.grid().datagrid("loadData",{"total":0,"rows":[]});
	PageLogicObj.m_DiagArcimCombox.grid().datagrid("loadData",{"total":0,"rows":[]});
	PageLogicObj.m_SDateBox = sDateBox;
	PageLogicObj.m_EDateBox = eDateBox;
	if (action == "add") {
		sDateBox.setValue("");
		eDateBox.setValue("");
		PageLogicObj.m_NeedArcimCombox.setValue("");
		PageLogicObj.m_DiagArcimCombox.setValue("");
		$("#i-id").val("");
		$("#i-action").val("add");
	} else {
		$("#i-id").val(selected.LRowid);
		$("#i-action").val("edit");
		sDateBox.setValue(selected.TStDate);
		eDateBox.setValue(selected.TEndDate);
		//setTimeout(function () {
			PageLogicObj.m_NeedArcimCombox.setValue(selected.TlinkArcimID);
			PageLogicObj.m_NeedArcimCombox.setText(selected.TlinkArcimDesc);
			PageLogicObj.m_DiagArcimCombox.setValue(selected.TarcimID);
			PageLogicObj.m_DiagArcimCombox.setText(selected.TArcimDesc);
		//},800)
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
	$.messager.confirm("提示", "确认删除吗？", function(r) {
		if (r){
			$.m({
					ClassName:"web.DHCDocOrdLinkContr",
					MethodName:"LinkOrdDel",
					arcim: selected.TarcimID,
					linkarcim:selected.TlinkArcimID,
					LRowid:selected.LRowid
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
	})
}


//保存字典信息
function saveCfg() {
	var id = $("#i-id").val();
	var action = $("#i-action").val();
	var arcim = PageLogicObj.m_DiagArcimCombox.getValue();
	if (arcim==undefined) arcim="";
	var needarcim = PageLogicObj.m_NeedArcimCombox.getValue();
	if (needarcim==undefined) needarcim="";
	var sDate = PageLogicObj.m_SDateBox.getValue();
	var eDate = PageLogicObj.m_EDateBox.getValue();
	var paraStr = id + "^" + arcim + "^" + needarcim + "^" + sDate + "^" + eDate
	
	if (arcim == "") {
		$.messager.alert('提示','医嘱项不能为空!',"info");
		return false;
	}
	if (needarcim == "") {
		$.messager.alert('提示','需开医嘱项不能为空!',"info");
		return false;
	}
	if (sDate == "") {
		$.messager.alert('提示','开始时间不能为空!',"info");
		return false;
	}
	if (arcim == needarcim) {
		$.messager.alert('提示','需开医嘱项和医嘱项目不能相同!',"info");
		return false;
	}
	//LinkOrdInsert,LinkOrdUpdate,LinkOrdDel
	var methodName = "LinkOrdUpdate";
	if (action == "add") {
		methodName = "LinkOrdInsert";
		$.m({
			ClassName:"web.DHCDocOrdLinkContr",
			MethodName:methodName,
			arcim:arcim,
			linkarcim:needarcim,
			stdate:sDate,
			enddate:eDate,
			HospId:$HUI.combogrid('#_HospList').getValue()
		},function (responseText){
			if(responseText == 0) {
				$.messager.popover({msg: '新增成功！',type:'success',timeout: 1000});
				PageLogicObj.m_Win.close();
				PageLogicObj.m_DurDataGrid.reload();
			} else {
				$.messager.alert('提示','新增失败,错误代码: '+ responseText , "info");
				return false;
			}	
		})
	} else {
		$.m({
			ClassName:"web.DHCDocOrdLinkContr",
			MethodName:methodName,
			arcim:arcim,
			linkarcim:needarcim,
			stdate:sDate,
			enddate:eDate,
			TarcimIDOld:PageLogicObj.m_TarcimIDOld,
			TlinkArcimIDOld:PageLogicObj.m_TlinkArcimIDOld,
			LRowid:id
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
	//var text = PageLogicObj.m_ArcimCombox.getText();
	var arcimID = PageLogicObj.m_ArcimCombox.getValue();
	
	PageLogicObj.m_DurDataGrid.reload({
		ClassName : "web.DHCDocOrdLinkContr",
		QueryName : "FindOrdLink",
		arcimID: arcimID,
		HospId:$HUI.combogrid('#_HospList').getValue()
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

