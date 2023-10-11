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
	InitCache();
})
function InitCache(){
	var hasCache = $.DHCDoc.hasCache();
	if (hasCache!=1) {
		$.DHCDoc.CacheConfigPage();
		$.DHCDoc.storageConfigPageCache();
	}
}
function Init(){
	InitDataGrid();
	InitArcimCombox("i-arcim", PageLogicObj, "search");
	
	PageLogicObj.m_AType = $HUI.combobox("#i-atype",{
		valueField:'id',
		textField:'text',
		data:[
			{id:'ARCOS',text:'医嘱套'},{id:'TMPL',text:'医嘱模板'},{id:'USE',text:'常用用法维护'}
			,{id:'CureAppend',text:'治疗项目绑定医嘱'},{id:'LabAppend',text:'检验绑定医嘱'},{id:'SkinAppend',text:'皮试绑定医嘱'}
			,{id:'ItemListAppend',text:'附加医嘱绑定-按医嘱'},{id:'CatListAppend',text:'附加医嘱绑定-按子类'},{id:'CMPrescTypeLinkFee',text:'草药录入设置-处方剂型关联费用'}
			,{id:'ArcWardAppend',text:'病区绑定医嘱设置'}
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
		{field:'index',checkbox:true},
		{field:'cfgType',title:'维护类型',width:60},
		{field:'desc',title:'描述',width:300},
		{field:'RowId',title:'RowId',width:50}
    ]]
	PageLogicObj.m_Grid = $HUI.datagrid("#i-grid", {
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : true,
		rownumbers:true,
		idField:'index',
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
					var curRecord = detailArr[i].split("^");
					curRecord.push("","","","","","","","","","");
					var id = curRecord[0],name=curRecord[1],type=curRecord[2];
					var DoseStr=curRecord[3],Instr=curRecord[4];
					var PackQty=curRecord[5],RecLocDesc=curRecord[6];
					var SpecDesc=curRecord[7];
					if ((rowData.cfgType == "医嘱套")&&(type.indexOf("||")<0)) {
						colName1="医嘱套ID";
					}else{
						if (rowData.cfgType == "医嘱套") {
							colName1 = "医嘱项ID"
						} else {
							colName1 = "类型"
						}
					}
					result = result + '<tr>';
					result = result + '<td style="border:0;padding:2px;padding-right:30px"><p><span class="title">'+ colName1 + ': </span>' + type + '</p></td>';
					result = result + '<td style="border:0;padding:2px;padding-right:30px"><p><span class="title">描述: </span>' + name + '</p></td>';
					if (DoseStr!=""){
						result = result + '<td style="border:0;padding:2px;padding-right:30px"><p><span class="title">单次剂量: </span>' + DoseStr + '</p></td>';	
					}
					if (Instr!=""){
						result = result + '<td style="border:0;padding:2px;padding-right:30px"><p><span class="title">用法: </span>' + Instr + '</p></td>';	
					}
					if (PackQty!=""){
						result = result + '<td style="border:0;padding:2px;padding-right:30px"><p><span class="title">数量: </span>' + PackQty + '</p></td>';	
					}
					if (RecLocDesc!=""){
						result = result + '<td style="border:0;padding:2px;padding-right:30px"><p><span class="title">接收科室: </span>' + RecLocDesc + '</p></td>';	
					}
					if (SpecDesc!=""){
						result = result + '<td style="border:0;padding:2px;padding-right:30px"><p><span class="title">标本: </span>' + SpecDesc + '</p></td>';	
					}
					result = result + '<td style="border:0;padding:2px;padding-right:30px"><p><span class="title">ID: </span>' + id + '</p></td>';
					result = result + '</tr>';
				}	
				result = result + '</table>';
			} else {
				var detailArr = rowData.detail.split("^");
				var Dose = detailArr[0],Instr = detailArr[1],PHFreq = detailArr[2],Durat = detailArr[3],TPAAdmType = detailArr[4],PackQty=detailArr[5];
				
				result = "<p style='padding:10px;'>" +
						"<span class='title'>单次剂量: </span><span class='title3'>" + Dose + "</span>" + 
						"<span class='title'>用法: </span><span class='title3'>" + Instr + "</span>" + 
						"<span class='title'>频次: </span><span class='title3'>" + PHFreq + "</span>" + 
						"<span class='title'>疗程: </span><span class='title3'>" + Durat + "</span>" + 
						"<span class='title'>数量: </span><span class='title3'>" + PackQty + "</span>" + 
						"</p>";
			}
			return result;
		},
		onBeforeLoad:function(param){
			$("#i-grid").datagrid('unselectAll');
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
	var selected = PageLogicObj.m_Grid.getSelections();
	var _title = "", _icon = "" ;
	$("#i-tip").val();
	if (selected.length==0) {
		$("#i-tip").html("替换所有");
		$("#selectAll").checkbox("enable").checkbox('check');
		$("input[id^='dg-']").each(function(index,obj){
			if (obj.type!="checkbox"){return true}
			$(obj).checkbox("enable");
			$(obj).checkbox("check");
		});
		
		//$("#dg-use").checkbox("uncheck");
	} else {
		if (selected.length>1) {
			$("#i-tip").html("替换当前所选择");
		}else{
			$("#i-tip").html("替换当前所选择->" + selected[0].cfgType + ": " + selected[0].RowId);
		}
		$("#selectAll").checkbox("disable").checkbox('uncheck');
		$("input[id^='dg-']").each(function(index,obj){
			if (obj.type!="checkbox"){return true}
			$(obj).checkbox("disable");
			$(obj).checkbox("uncheck");
		});
		
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
	var selected = PageLogicObj.m_Grid.getSelections();
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
	var HospId=$HUI.combogrid('#_HospUserList').getValue();
	var id = "", atype = "";
	var selectTypeStr="";
	var para = carcim + "^" + rarcim;
	if (selected.length>0) {
		for (var i=0;i<selected.length;i++){
			var atype = selected[i].cfgCode;
			var id = selected[i].RowId;
			if (selectTypeStr=="") selectTypeStr=atype+"^"+id;
			else selectTypeStr=selectTypeStr+String.fromCharCode(1)+atype+"^"+id;
		}
		//atype = selected.cfgCode;
		//id = selected.RowId;
	} else {
		var yzt = $("#dg-yzt").checkbox("getValue");
		var tpl = $("#dg-tpl").checkbox("getValue");
		var use = $("#dg-use").checkbox("getValue");
		var CureAppend = $("#dg-CureAppend").checkbox("getValue");
		var LabAppend = $("#dg-LabAppend").checkbox("getValue");
		var SkinAppend = $("#dg-SkinAppend").checkbox("getValue");
		var ItemListAppend = $("#dg-ItemListAppend").checkbox("getValue");
		var CatListAppend = $("#dg-CatListAppend").checkbox("getValue");
		var CMPrescTypeLinkFee = $("#dg-CMPrescTypeLinkFee").checkbox("getValue");
		var ArcWardAppend = $("#dg-ArcWardAppend").checkbox("getValue");
		if (yzt) {
			if (atype == "") atype = "ARCOS"
			else atype = atype + "^" + "ARCOS";
		}
		if (tpl) {
			if (atype == "") atype = "TMPL"
			else atype = atype + "^" + "TMPL";
		}
		if (use) {if (atype == ""){atype = "USE"}else{atype = atype + "^" + "USE";}};
		if (CureAppend) {if (atype == ""){atype = "CureAppend"}else{atype = atype + "^" + "CureAppend";}};
		if (LabAppend) {if (atype == ""){atype = "LabAppend"}else{atype = atype + "^" + "LabAppend";}};
		if (SkinAppend) {if (atype == ""){atype = "SkinAppend"}else{atype = atype + "^" + "SkinAppend";}};
		if (ItemListAppend) {if (atype == ""){atype = "ItemListAppend"}else{atype = atype + "^" + "ItemListAppend";}};
		if (CatListAppend) {if (atype == ""){atype = "CatListAppend"}else{atype = atype + "^" + "CatListAppend";}};
		if (CMPrescTypeLinkFee) {if (atype == ""){atype = "CMPrescTypeLinkFee"}else{atype = atype + "^" + "CMPrescTypeLinkFee";}};
		if (ArcWardAppend) {if (atype == ""){atype = "ArcWardAppend"}else{atype = atype + "^" + "ArcWardAppend";}};
	}
	if (atype==""){
		$.messager.alert('提示','请选择至少一项进行替换' , "info");
		return false;
	}
	$.messager.confirm("警告", "批量替换医嘱前请核实绑定数据的单次剂量单位、数量单位、接收科室、标本等信息是否能正确使用，否则将导致严重问题，是否继续？", function (r) {
		if (r) {
			Deal();
		}else{
			return
		}
	});

	function Deal(){
		if (selectTypeStr) {
			var result = tkMakeServerCall("DHCDoc.DHCDocConfig.CommonFunction","SaveArcimReplaceBySel", selectTypeStr, para,HospId);
		}else{
			var result = tkMakeServerCall("DHCDoc.DHCDocConfig.CommonFunction","SaveArcimReplace", id, atype, para,HospId);
		}
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
	
	
}
function resetConfig() {
	PageLogicObj.m_ArcimCombox.setValue("");
	PageLogicObj.m_AType.setValue("");
	PageLogicObj.m_DepCombox.setValue("");
	PageLogicObj.m_UserCombox.setValue("");
	PageLogicObj.m_Grid.reload({
		ClassName : "DHCDoc.DHCDocConfig.CommonFunction",
		QueryName : "QryReplaceArcim",
		arcimrow: "",
		HospId:$HUI.combogrid('#_HospUserList').getValue()
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
function selectAllChkChange(e,value){
	$("input[id^='dg-']").each(function(index,obj){
		if (obj.type=="checkbox"){
			if (value) {
				$(obj).checkbox("check");
			}else{
				$(obj).checkbox("uncheck");
			}
		}
	});
}

