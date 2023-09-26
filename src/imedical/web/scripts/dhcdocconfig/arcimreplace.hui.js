/**
 * arcimreplace.hui.js 常用维护中医嘱项替换
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
	m_Grid : "",
	m_Win: "",
	m_ArcimCombox: "",
	m_AType: "",
	m_UserCombox:"",
	m_DepCombox: "",
	m_SearchGrid: "",
	m_RCombox: "",
	m_RGrid: "",
	m_CCombox: "",
	m_CGrid: ""
}

$(function(){
	var hospComp = GenUserHospComp();
	hospComp.jdata.options.onSelect = function(e,t){
		Init();
		$("#i-replace").click(replaceConfig);
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		//初始化
		Init();
		//事件初始化
		InitEvent();
	}
})

function Init(){
	InitDataGrid();
	InitArcimCombox("i-arcim", PageLogicObj, "search");
	
	PageLogicObj.m_AType = $HUI.combobox("#i-atype",{
		valueField:'id',
		textField:'text',
		data:[
			{id:'ARCOS',text:'医嘱套'},{id:'TMPL',text:'医嘱模板'},{id:'USE',text:'常用用法维护'}
		]
	})
	
	PageLogicObj.m_UserCombox = $HUI.combobox("#i-user", {
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CommonFunction&QueryName=LookUpUser&desc=&ResultSetType=array&HospId="+$HUI.combogrid('#_HospUserList').getValue(),
		valueField:'ID',
		textField:'USER',
		onSelect: function (record) {
			PageLogicObj.m_DepCombox.setValue("");
		}
	})
	
	PageLogicObj.m_DepCombox  = $HUI.combobox("#i-loc", {
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CommonFunction&QueryName=LookUpCTLoc&desc=&ResultSetType=array&HospId="+$HUI.combogrid('#_HospUserList').getValue(),
		valueField:'ID',
		textField:'CTLOC',
		mode: "local",
		filter: function(q, row){
			var ops = $(this).combobox('options');  
			var mCode = false;
			if (row.ContactName) {
				mCode = row.ContactName.toUpperCase().indexOf(q.toUpperCase()) >= 0
			}
			var mValue = row[ops.textField].indexOf(q) >= 0;
			return mCode||mValue;  
		},
		onSelect: function (record) {
			PageLogicObj.m_UserCombox.setValue("");
			//PageLogicObj.m_UserCombox.disable();
		}
	})
	
}
function InitEvent(){
	$("#i-find").click(findConfig);
	$("#i-reset").click(resetConfig);
	$("#i-replace").click(replaceConfig);
	$(document.body).bind("keydown",BodykeydownHandler)
}

function PageHandle(){
	//
}

function InitArcimCombox(selector, OBJ , type) {
	var comboxOBJ = $HUI.combogrid("#" + selector, {
		panelWidth: 500,
		panelHeight: 350,
		idField: 'ArcimDR',
		textField: 'ArcimDesc',
		//method: 'get',
		columns: [[
			{field:'ArcimDesc',title:'项目名称',width:120},
			{field:'ArcimDR',title:'ID',width:30}
		]],
		pagination : true,
		mode:'remote',
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CommonFunction&QueryName=FindMasterItem&arcimdesc=",
		fitColumns: true,
		enterNullValueClear:false,
		onBeforeLoad:function(param){
			if (param['q']) {
				var desc=param['q'];
			}
			param = $.extend(param,{arcimdesc:desc,HospId:$HUI.combogrid('#_HospUserList').getValue()});
		},
		/*onChange:function () {
			var curInput = comboxOBJ.getText();
			//console.log("1111111111111: " + curInput);
			gridOBJ.datagrid("reload", {
				ClassName : 'DHCDoc.DHCDocConfig.CommonFunction',
				QueryName : 'FindMasterItem',
				arcimdesc: curInput
			})
		}
		,
		onSelect: function (rowIndex, rowData) {
			var curInputStr = rowData.OrdInfo;	//PageLogicObj.m_ArcimCombox.getText();
			var curInput = curInputStr.split("^")[4];
			console.log(curInput);
			//console.log("222222222222: " + curInput);
			PageLogicObj.m_SearchGrid.datagrid("reload", {
				ClassName : 'DHCDoc.DHCDocConfig.CommonFunction',
				QueryName : 'LookUpItemNew',
				Item: curInput,
				GroupID:session['LOGON.GROUPID']
			})
			
		}*/
	});
	var gridOBJ = comboxOBJ.grid();
	
	if (type == "search") {
		OBJ.m_ArcimCombox = comboxOBJ;
		OBJ.m_SearchGrid = gridOBJ;
	} else if (type == "dg-c") {
		OBJ.m_CCombox = comboxOBJ;
		OBJ.m_CGrid = gridOBJ;
	} else {
		OBJ.m_RCombox = comboxOBJ;
		OBJ.m_RGrid = gridOBJ;
	}
}

function InitDataGrid(){
	var columns = [[
		{field:'cfgType',title:'维护类型',width:60},
		{field:'desc',title:'描述',width:300},
		{field:'RowId',title:'RowId',width:50}
    ]]
	PageLogicObj.m_Grid = $HUI.datagrid("#i-grid", {
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
		view:detailview,	//detailview	scrollview
		queryParams:{
			ClassName : "DHCDoc.DHCDocConfig.CommonFunction",
			QueryName : "QryReplaceArcim",
			arcimrow: "",
			HospId:$HUI.combogrid('#_HospUserList').getValue()
		},
		detailFormatter:function(rowIndex, rowData){
			var result = '';
			var colName1 = ""
			if (rowData.cfgType == "医嘱套") {
				colName1 = "医嘱项ID"
			} else {
				colName1 = "类型"
			}
			if (rowData.cfgType.indexOf("常用用法维护")<0) {
				var detailArr = rowData.detail.split("!");
				result = '<table style="padding:10px;">';
				for (var i=0; i<detailArr.length; i++) {
					var curRecord = detailArr[i].split("^")
					var id = curRecord[0],name=curRecord[1],type=curRecord[2];
					result = result + '<tr>' +
								'<td style="border:0;padding:2px;padding-right:30px"><p><span class="title">'+ colName1 + ': </span>' + type + '</p></td>' +
								'<td style="border:0;padding:2px;padding-right:30px"><p><span class="title">描述: </span>' + name + '</p></td>' +
								'<td style="border:0;padding:2px;padding-right:30px"><p><span class="title">ID: </span>' + id + '</p></td>' +
							'</tr>';
				}	
				result = result + '</table>';
			} else {
				var detailArr = rowData.detail.split("^");
				var Dose = detailArr[0],Instr = detailArr[1],PHFreq = detailArr[2],Durat = detailArr[3],TPAAdmType = detailArr[4];
				result = "<p style='padding:10px;'>" +
						"<span class='title'>单次剂量: </span><span class='title3'>" + Dose + "</span>" + 
						"<span class='title'>用法: </span><span class='title3'>" + Instr + "</span>" + 
						"<span class='title'>频次: </span><span class='title3'>" + PHFreq + "</span>" + 
						"<span class='title'>疗程: </span><span class='title3'>" + Durat + "</span>" + 
						"<span class='title'>就诊类型: </span><span class='title3'>" + TPAAdmType + "</span>" + 
						"</p>";
			}
			return result;
		},
		columns :columns,
		toolbar:[{
				text:'替换医嘱项',
				id:'i-replace',
				iconCls: 'icon-set-paper'
			}
		]
	});
	
}

//编辑或新增
function replaceConfig() {
	var selected = PageLogicObj.m_Grid.getSelected();
	var _title = "", _icon = "" ;
	$("#i-tip").val();
	if (!selected) {
		$("#i-tip").html("替换所有");
		$("#dg-yzt").checkbox("enable");
		$("#dg-tpl").checkbox("enable");
		$("#dg-use").checkbox("enable");
		$("#dg-yzt").checkbox("check");
		$("#dg-tpl").checkbox("check");
		$("#dg-use").checkbox("uncheck");
	} else {
		$("#i-tip").html("替换当前所选择->" + selected.cfgType + ": " + selected.RowId);
		$("#dg-yzt").checkbox("disable");
		$("#dg-tpl").checkbox("disable");
		$("#dg-use").checkbox("disable");
		$("#dg-yzt").checkbox("uncheck");
		$("#dg-tpl").checkbox("uncheck");
		$("#dg-use").checkbox("uncheck");
	}
	_title = "替换医嘱项";
	_icon = "icon-w-edit";
	
	$("#dg-action").val("edit");
	//$("#dg-id").val(selected.Rowid);
	
	if($('#dg').hasClass("c-hidden")) {
		$('#dg').removeClass("c-hidden");
	};
	
	//var bArcimStr = PageLogicObj.m_ArcimCombox.getText();
	//var bArcim = bArcimStr.split("-")[1];
	//$("#dg-cArcim").html(bArcim);
	InitArcimCombox("dg-cArcim", PageLogicObj, "dg-c");
	InitArcimCombox("dg-rArcim", PageLogicObj, "dg-r");
	
	PageLogicObj.m_CCombox.setValue("");
	PageLogicObj.m_RCombox.setValue("");
	
	var cWin = $HUI.window('#dg', {
		title: _title,
		iconCls: _icon,
		modal: true,
		minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
		onClose: function () {
			//$(this).window('destroy');
			$('#dg').addClass("c-hidden");
		}
	});
	
	PageLogicObj.m_Win = cWin;
	console.log(PageLogicObj);
}

function deConfig () {
	var selected = PageLogicObj.m_DurDataGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示","请选择一条记录...","info")
		return false;
	}
	$.m({
			ClassName:"web.DHCDocOrdLinkContr",
			MethodName:"LinkOrdDel",
			arcim: selected.TarcimID,
			linkarcim:selected.TlinkArcimID,
			LRowid:selected.LRowid
		},function (responseText){
			if(responseText == 0) {
				$.messager.alert('提示','删除成功',"info");
				PageLogicObj.m_DurDataGrid.reload();
			} else {
				$.messager.alert('提示','修改失败,错误代码: '+ responseText , "info");
				return false;
			}	
		})
}


//保存字典信息
function saveCfg() {
	var selected = PageLogicObj.m_Grid.getSelected();
	
	var carcim = PageLogicObj.m_CCombox.getValue()||"";
	var rarcim = PageLogicObj.m_RCombox.getValue()||"";
	if (carcim == "") {
		$.messager.alert('提示','请选择包含医嘱项' , "info");
		return false;
	}
	if (rarcim == "") {
		$.messager.alert('提示','请选择替换医嘱项' , "info");
		return false;
	}
	if ( carcim == rarcim ) {
		$.messager.alert('提示','所替换的和原先的相同...' , "info");
		return false;
	}
	var id = "", atype = "";
	var para = carcim + "^" + rarcim;
	if (selected) {
		atype = selected.cfgCode;
		id = selected.RowId;
		//alert(selected.acostype);;
	} else {
		var yzt = $("#dg-yzt").checkbox("getValue");
		var tpl = $("#dg-tpl").checkbox("getValue");
		var use = $("#dg-use").checkbox("getValue");
		if (yzt) {
			if (atype == "") atype = "ARCOS"
			else atype = atype + "^" + "ARCOS";
		}
		if (tpl) {
			if (atype == "") atype = "TMPL"
			else atype = atype + "^" + "TMPL";
		}
		if (use) {
			if (atype == "") atype = "USE"
			else atype = atype + "^" + "USE";
		}
	}
	var HospId=$HUI.combogrid('#_HospUserList').getValue();
	var result = tkMakeServerCall("DHCDoc.DHCDocConfig.CommonFunction","SaveArcimReplace", id, atype, para,HospId);
	if (result == 1) {
		PageLogicObj.m_Win.close();
		PageLogicObj.m_Grid.reload();
		$.messager.alert('提示','保存成功...' , "info");
		return true;
	} else if (result == 2) {
		$.messager.alert('提示','所替换的医嘱项不存在...' , "info");
		return false;
	} else {
		$.messager.alert('提示','保存失败...' , "info");
		return false;
	}
	
	
	
}
function resetConfig() {
	PageLogicObj.m_ArcimCombox.setValue("");
	PageLogicObj.m_AType.setValue("");
	PageLogicObj.m_DepCombox.setValue("");
	PageLogicObj.m_UserCombox.setValue("");
	PageLogicObj.m_Grid.reload({
		ClassName : "DHCDoc.DHCDocConfig.CommonFunction",
		QueryName : "QryReplaceArcim"
	});
	
}
function findConfig () {
	var text = PageLogicObj.m_ArcimCombox.getText();
	var arcimID = PageLogicObj.m_ArcimCombox.getValue();
	var atype = PageLogicObj.m_AType.getValue();
	var locid = PageLogicObj.m_DepCombox.getValue();
	var userid = PageLogicObj.m_UserCombox.getValue();
	//alert(userid);
	PageLogicObj.m_Grid.reload({
		ClassName : "DHCDoc.DHCDocConfig.CommonFunction",
		QueryName : "QryReplaceArcim",
		atype: atype,
		arcimrow: arcimID,
		locid: locid,
		ssuid: userid,
		HospId:$HUI.combogrid('#_HospUserList').getValue()
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


