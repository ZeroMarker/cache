/**
 * prescprintdep.hui.js 处方打印格式与科室对照
 * 
 * Copyright (c) 2019-2010 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2019-01-11
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
	//初始化医院
	var hospComp = GenUserHospComp();
	hospComp.jdata.options.onSelect = function(e,t){
		Init();
		InitEvent();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		//初始化
		Init();
		//事件初始化
		InitEvent();
	}
	InitCache();
})
function InitCache(){
	var hasCache = $.DHCDoc.ConfigHasCache();
	if (hasCache!=1) {
		$.DHCDoc.CacheConfigPage();
		$.DHCDoc.storageConfigPageCache();
	}
}
function Init(){
	//科室
	PageLogicObj.m_find_Loc = $HUI.combobox("#i-find-loc", {
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CommonFunctionE2&QueryName=QryOPLoc&ResultSetType=array&hospid="+$HUI.combogrid('#_HospUserList').getValue(),
		valueField:'rowid',
		textField:'OPLocdesc',
		mode: "local",
		filter: function(q, row){
			var ops = $(this).combobox('options');  
			var mCode = false;
			if (row.ContactName) {
				mCode = row.ContactName.toUpperCase().indexOf(q.toUpperCase()) >= 0
			}
			var mValue = row[ops.textField].indexOf(q) >= 0;
			return mCode||mValue;  
		}
	})
	PageLogicObj.m_Grid = InitGrid();
}
function InitEvent(){
	$("#i-find").click(findConfig);
	$("#i-add").click(function(){opDialog("add")});
	$("#i-edit").click(function(){opDialog("edit")});
	$("#i-delete").click(function(){deConfig()});
	$(document.body).bind("keydown",BodykeydownHandler)
}
function InitGrid(){
	var columns = [[
		{field:'PrintTypeDesc',title:'处方格式',width:100},
		{field:'AgeGroup',title:'年龄段(岁)',width:50,align:"center"},
		{field:'LocDesc',title:'科室',width:300},
		
		{field:'TLocID',title:'TLocID',width:60,hidden:true}
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
			ClassName : "DHCDoc.DHCDocConfig.CommonFunctionE2",
			QueryName : "QryPrescPrintDepCompare",
			hospid:$HUI.combogrid('#_HospUserList').getValue()
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
		$("#i-id").val(selected.TLocID);
	}
	
	if($('#i-dialog').hasClass("c-hidden")) {
		$('#i-dialog').removeClass("c-hidden");
	};
	
	//$HUI.numberbox("#i-diag-agefrom", {})
	//$HUI.numberbox("#i-diag-ageto", {})
	//科室
	PageLogicObj.m_dg_Loc = $HUI.combobox("#i-diag-loc", {
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CommonFunctionE2&QueryName=QryOPLoc&ResultSetType=array&hospid="+$HUI.combogrid('#_HospUserList').getValue(),
		valueField:'rowid',
		textField:'OPLocdesc',
		mode: "local",
		filter: function(q, row){
			var ops = $(this).combobox('options');  
			var mCode = false;
			if (row.ContactName) {
				mCode = row.ContactName.toUpperCase().indexOf(q.toUpperCase()) >= 0
			}
			var mValue = row[ops.textField].indexOf(q) >= 0;
			return mCode||mValue;  
		}
	})
	//处方格式	
	PageLogicObj.m_dg_presc = $HUI.combobox("#i-diag-presc", {
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CommonFunctionE2&QueryName=QryPrescPrintType&ResultSetType=array",
		valueField:'PrintTypeID',
		textField:'PrintTypeDesc'
	})
	
	if (action == "edit") {
		PageLogicObj.m_dg_Loc.disable();
		PageLogicObj.m_dg_Loc.setValue(selected.TLocID);
		PageLogicObj.m_dg_presc.setValue(selected.PrintTypeID);
		$("#i-diag-agefrom").numberbox('setValue',selected.AgeGroup.split(" ~ ")[0]);
		$("#i-diag-ageto").numberbox('setValue',selected.AgeGroup.split(" ~ ")[1]);
	} else {
		PageLogicObj.m_dg_Loc.enable();
		PageLogicObj.m_dg_Loc.clear();
		PageLogicObj.m_dg_presc.clear();
		$("#i-diag-agefrom").numberbox('setValue',"");
		$("#i-diag-ageto").numberbox('setValue',"");
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
			ClassName:"DHCDoc.DHCDocConfig.CommonFunctionE2",
			MethodName:"DBDeletePrescPrint",
			TLocID: selected.TLocID
		},function (responseText){
			if(responseText == 0) {
				$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
				PageLogicObj.m_Grid.reload();
			} else {
				$.messager.alert('提示','删除失败,错误代码: '+ responseText , "info");
				return false;
			}	
		})
}

//保存字典信息
function saveCfg() {
	var id = $("#i-id").val();
	var action = $("#i-action").val();
	var prescType = PageLogicObj.m_dg_presc.getValue()||"";
	var loc = PageLogicObj.m_dg_Loc.getValue()||"";
	var agefrom=$("#i-diag-agefrom").numberbox('getValue');
	var ageto=$("#i-diag-ageto").numberbox('getValue');
	if (parseFloat(agefrom)>parseFloat(ageto)){
		$.messager.alert('提示','请核实处方年龄段信息！',"info");
		return false;
	}
	if ((agefrom=="")&&(ageto!="")){
		$.messager.alert('提示','请核实处方年龄段信息！',"info");
		return false;
	}
	if ((agefrom!="")&&(ageto=="")){
		$.messager.alert('提示','请核实处方年龄段信息！',"info");
		return false;
	}
	if (prescType == "") {
		$.messager.alert('提示','请选择处方格式！',"info");
		return false;
	}
	if (loc == "") {
		$.messager.alert('提示','请选择科室！',"info");
		return false;
	}
	if (action =="add") {
		$.m({
			ClassName:"DHCDoc.DHCDocConfig.CommonFunctionE2",
			MethodName:"CheckPrescPrint",
			LocID:loc,
			
			PrintTypeID:prescType,
		},function (OldPrintTypeID){
			if (OldPrintTypeID=="repeat") {
				$.messager.alert('提示','对照记录重复！',"info");
				return false;
			}else if (OldPrintTypeID !="") {
				$.messager.confirm('确认',PageLogicObj.m_dg_Loc.getText()+" 已经对照了其他处方格式，保存则会覆盖原记录，是否继续?",function(r){    
				    if (r){    
				        save(); 
				    }    
				}); 
			}else{
				save();
			}
		})
	}else{
		save();
	}
	function save(){
		$.m({
			ClassName:"DHCDoc.DHCDocConfig.CommonFunctionE2",
			MethodName:"DBSavePrescPrint",
			LocID:loc,
			AgeFrom:agefrom,
			AgeTo:ageto,
			PrintTypeID:prescType,
		},function (responseText){
			if(responseText == 0) {
				$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
				PageLogicObj.m_Win.close();
				PageLogicObj.m_Grid.reload();
			} else {
				$.messager.alert('提示','保存失败！'+ responseText , "info");
				return false;
			}	
		});
	}
}

//查找
function findConfig () {
	var inLoc = PageLogicObj.m_find_Loc.getValue()||"";
	PageLogicObj.m_Grid.reload({
		ClassName : "DHCDoc.DHCDocConfig.CommonFunctionE2",
		QueryName : "QryPrescPrintDepCompare",
		inLoc: inLoc,
		hospid:$HUI.combogrid('#_HospUserList').getValue()
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


