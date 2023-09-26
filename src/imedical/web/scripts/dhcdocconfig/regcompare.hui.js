/**
 * regcompare.hui.js 医生号别对照
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2018-08-10
 * 
 * TABL: DHCDoc_ExceedReason
 */
//页面全局变量
var PageLogicObj = {
	m_Grid : "",
	m_Loc: "",
	m_Reg: "",
	m_Doc: "",
	m_DG_Loc: "",
	m_DG_Reg: "",
	m_DG_Doc: "",
	m_Win: "",
	m_LocListTabDataGrid:"",
	m_DocListTabDataGrid:"",
	m_MarkListTabDataGrid:"",
	m_DocListTab1DataGrid:"",
	m_MarkListTab1DataGrid:""
}
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
})
function Init(){
	var hospComp = GenHospComp("DHCMarkDoc");
	hospComp.jdata.options.onSelect = function(e,t){
		var HospID=t.HOSPRowId;
		InitCombox();
		intiloc();
		findConfig();
	}
	InitDataGrid();
	InitCombox();
}
function InitEvent(){
	$("#i-find").click(findConfig);
	$("#i-reset").click(resetConfig);
	$("#i-add").click(function(){opDialog("add")});
	$("#i-edit").click(function(){opDialog("edit")});
	$("#i-delete").click(function(){deConfig()});
	//$("#i-Alladd").click(function(){Alladd()});
	$("#i-set").click(function(){setDurTime()});
	$(document.body).bind("keydown",BodykeydownHandler)
	$("#BSave").click(MulMarkDocSave);
	$("#BSave1").click(MulDocMarkSave);
	$("#MulMarkDocWin").window({
		onClose:function(){
			findConfig();
		}
	});
	$('#tab').tabs({    
	    onSelect:function(title,index){
		    LocListTabSelect();
	    }    
	});
}
function PageHandle(){
}
function InitCombox() {
	var HospID=$HUI.combogrid('#_HospList').getValue();
	PageLogicObj.m_Loc = $HUI.combobox("#i-loc", {
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CommonFunction&QueryName=QueryLoc&depname=&UserID=&LogHospId="+HospID+ "&ResultSetType=array",
		valueField:'id',
		textField:'name',
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
			PageLogicObj.m_Reg.setValue("");
			PageLogicObj.m_Doc.setValue("");
			var locid = PageLogicObj.m_Loc.getValue();
			var url = $URL+"?ClassName=web.DHCExaBorough&QueryName=Findloc&depid=" + locid + "&ResultSetType=array";
			var url2 = $URL+"?ClassName=web.DHCExaBorough&QueryName=FindDoc&depid=" + locid + "&ResultSetType=array";
			PageLogicObj.m_Reg.reload(url);
			PageLogicObj.m_Doc.reload(url2);
		},
		onChange:function(newValue, oldValue){
			if (newValue==""){
				PageLogicObj.m_Reg.setValue("");
				PageLogicObj.m_Doc.setValue("");
				PageLogicObj.m_Loc.setValue("");
				var locid = PageLogicObj.m_Loc.getValue();
				var url = $URL+"?ClassName=web.DHCExaBorough&QueryName=Findloc&depid=" + locid + "&ResultSetType=array";
				var url2 = $URL+"?ClassName=web.DHCExaBorough&QueryName=FindDoc&depid=" + locid + "&ResultSetType=array";
				PageLogicObj.m_Reg.reload(url);
				PageLogicObj.m_Doc.reload(url2);
			}
		}
	});
	PageLogicObj.m_Reg = $HUI.combobox("#i-reg", {
		url:$URL+"?ClassName=web.DHCExaBorough&QueryName=Findloc&depid=&ResultSetType=array",
		valueField:'RowID',
		textField:'Desc',
		mode: "local",
		filter: function(q, row){
			var ops = $(this).combobox('options');  
			var mCode = false;
			if (row.code) {
				mCode = row.code.toUpperCase().indexOf(q.toUpperCase()) >= 0
			}
			var mValue = row[ops.textField].indexOf(q) >= 0;
			return mCode||mValue;  
		}
		
	});
	PageLogicObj.m_Doc = $HUI.combobox("#i-doc", {
		url:$URL+"?ClassName=web.DHCExaBorough&QueryName=FindDoc&depid=&ResultSetType=array",
		valueField:'RowID',
		textField:'Desc',
		mode: "local",
		filter: function(q, row){
			var ops = $(this).combobox('options');  
			var mCode = false;
			if (row.code) {
				mCode = row.code.toUpperCase().indexOf(q.toUpperCase()) >= 0
			}
			var mValue = row[ops.textField].indexOf(q) >= 0;
			return mCode||mValue;  
		}
		
	});

}

function InitDgCombox(selectLocid) {
	PageLogicObj.m_DG_Loc = $HUI.combobox("#dg-loc", {
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CommonFunction&QueryName=QueryLoc&depname=&ResultSetType=array&LogHospId="+$HUI.combogrid('#_HospList').getValue(),
		valueField:'id',
		textField:'name',
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
			PageLogicObj.m_DG_Reg.setValue("");
			PageLogicObj.m_DG_Doc.setValue("");
			var locid = PageLogicObj.m_DG_Loc.getValue();
			var url = $URL+"?ClassName=web.DHCExaBorough&QueryName=Findloc&depid=" + locid + "&ResultSetType=array";
			var url2 = $URL+"?ClassName=web.DHCExaBorough&QueryName=FindDoc&depid=" + locid + "&ResultSetType=array";
			PageLogicObj.m_DG_Reg.reload(url);
			PageLogicObj.m_DG_Doc.reload(url2);
		}
	});
	PageLogicObj.m_DG_Reg = $HUI.combobox("#dg-reg", {
		url:$URL+"?ClassName=web.DHCExaBorough&QueryName=Findloc&depid=" + selectLocid + "&ResultSetType=array",
		valueField:'RowID',
		textField:'Desc',
		mode: "local",
		filter: function(q, row){
			var ops = $(this).combobox('options');  
			var mCode = false;
			if (row.code) {
				mCode = row.code.toUpperCase().indexOf(q.toUpperCase()) >= 0
			}
			var mValue = row[ops.textField].indexOf(q) >= 0;
			return mCode||mValue;  
		}
		
	});
	PageLogicObj.m_DG_Doc = $HUI.combobox("#dg-doc", {
		url:$URL+"?ClassName=web.DHCExaBorough&QueryName=FindDoc&depid=" + selectLocid + "&ResultSetType=array",
		valueField:'RowID',
		textField:'Desc',
		mode: "local",
		filter: function(q, row){
			var ops = $(this).combobox('options');  
			var mCode = false;
			if (row.code) {
				mCode = row.code.toUpperCase().indexOf(q.toUpperCase()) >= 0
			}
			var mValue = row[ops.textField].indexOf(q) >= 0;
			return mCode||mValue;  
		}
		
	});

}

function InitDataGrid(){
	var columns = [[
		{field:'Tdepname',title:'科室',width:100},
		{field:'Tdocname',title:'医生',width:100},
		{field:'Tmarkname',title:'号别',width:100},
		{field:'isDefault',title:'是否默认',width:100,
			formatter:function(value,row,index){
				if (value == 1) {
					return "<span class='c-ok'>是</span>"
				} else {
					return "<span class='c-no'>否</span>"
				}
			}
		},
		{field:'Tdepid',title:'科室ID',width:60},
		{field:'Tmarkid',title:'号别ID',width:60},
		{field:'Tlocid',title:'医生ID',width:60},
		{field:'Tid',title:'TID',width:60}
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
		pageSize:20,
		pageList : [20,50,100],
		url:$URL,
		queryParams:{
			ClassName : "DHCDoc.DHCDocConfig.CommonFunction",
			QueryName : "UFindDHCMarkDoc",
			depid: ""
		},
		//idField:'Rowid',
		columns :columns,
		toolbar:[{
				text:'添加',
				id:'i-add',
				iconCls: 'icon-add'
			},{
				text:'修改',
				id:'i-edit',
				iconCls: 'icon-edit'
			},{
				text:'删除',
				id:'i-delete',
				iconCls: 'icon-cancel'
			},{
				text:'批量保存号别',
				//id:'i-Alladd',
				iconCls: 'icon-add',
				handler: function() {
					$("#FindLoc,#FindDoc,#FindMark,#FindDoc1,#FindMark1").searchbox('setValue',""); 
					$('#MulMarkDocWin').window('open');
					$('#tab').tabs('select',0);
					if (PageLogicObj.m_LocListTabDataGrid==""){
						PageLogicObj.m_LocListTabDataGrid=InitLocListTabDataGrid();
					}else{
						PageLogicObj.m_LocListTabDataGrid.datagrid("reload");
					}
				}
			}
		]
	});
}

//编辑或新增
function opDialog(action) {
	var selected = PageLogicObj.m_Grid.getSelected();
	var _title = "", _icon = "",selectLocid="";
	if (action == "add") {
		_title = "添加";
		_icon = "icon-w-add";
		$("#dg-action").val("add");
		$("#dg-id").val("");
		selectLocid=PageLogicObj.m_Loc.getValue();
	} else {
		if (!selected) {
			$.messager.alert("提示","请选择一条记录...","info")
			return false;
		}
		_title = "修改";
		_icon = "icon-w-edit";
		$("#dg-action").val("edit");
		$("#dg-id").val(selected.Tid);
		selectLocid = selected.Tdepid;
	}
	
	if($('#i-dialog').hasClass("c-hidden")) {
		$('#i-dialog').removeClass("c-hidden");
	};
	
	InitDgCombox(selectLocid);
	if (action == "add") {
		var SearchLoc=PageLogicObj.m_Loc.getValue();
		var SearchReg=PageLogicObj.m_Reg.getValue();
		var SearchDoc=PageLogicObj.m_Doc.getValue();
		
		
		PageLogicObj.m_DG_Loc.setValue(SearchLoc);
		PageLogicObj.m_DG_Reg.setValue(SearchReg);
		PageLogicObj.m_DG_Doc.setValue(SearchDoc);
		$("#dg-active").checkbox('uncheck');
	} else {
		PageLogicObj.m_DG_Loc.setValue(selected.Tdepid);
		PageLogicObj.m_DG_Doc.setValue(selected.Tlocid);
		PageLogicObj.m_DG_Reg.setValue(selected.Tmarkid);
		if (selected.isDefault == 1) {
			$("#dg-active").checkbox('check');
		} else {
			$("#dg-active").checkbox('uncheck');
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
		$.messager.alert("提示","请选择一条记录...","info")
		return false;
	}
	$.messager.confirm('提示','你确认删除么?',function(r){   
		if (r){   
			$.m({
				ClassName:"DHCDoc.DHCDocConfig.CommonFunction",
				MethodName:"deleteMarkDoc",
				'rowid': selected.Tid,
			},function (responseText){
				if(responseText == 0) {
					$.messager.alert('提示','删除成功',"info");
					PageLogicObj.m_Grid.reload();
				} else {
					$.messager.alert('提示','修改失败,错误代码: '+ responseText , "info");
					return false;
				}	
			})
		}   
	});  
	
}

//保存字典信息
function saveCfg() {
	var id = $("#dg-id").val();
	var action = $("#dg-action").val();
	var locid = PageLogicObj.m_DG_Loc.getValue();
	var reg = PageLogicObj.m_DG_Reg.getValue();
	var doc = PageLogicObj.m_DG_Doc.getValue();
	var active = $("#dg-active").checkbox("getValue");
	if (active) active = 1;
		else active = 0;

	if (locid == "") {
		$.messager.alert('提示','科室不能为空!',"info");
		return false;
	}
	if (reg == "") {
		$.messager.alert('提示','号别不能为空!',"info");
		return false;
	}
	if (doc == "") {
		$.messager.alert('提示','医生不能为空!',"info");
		return false;
	}
	//var paraStr =  id + "^" + action  + "^" + locid + "^" + reg  + "^" + doc  + "^" + active;
	$.m({
		ClassName:"DHCDoc.DHCDocConfig.CommonFunction",
		MethodName:"insertMarkDoc",
		'rowid':id,
		'depDr':locid,
		'markDr':reg,
		'docDr':doc,
		'action':action,
		'isDefault':active
	},function (responseText){
		if(responseText == 0) {
			$.messager.alert('提示','保存成功',"info");
			PageLogicObj.m_Win.close();
			PageLogicObj.m_Grid.reload();
		} else if (responseText == "-1") {
			$.messager.alert('提示','记录重复' , "info");
			return false;
		}else {
			$.messager.alert('提示','添加失败,错误代码: '+ responseText , "info");
			return false;
		}
	})

}
function resetConfig () {
	PageLogicObj.m_Loc.setValue("");
	PageLogicObj.m_Reg.setValue("");
	PageLogicObj.m_Doc.setValue("");
	PageLogicObj.m_Grid.reload({
		ClassName : "DHCDoc.DHCDocConfig.CommonFunction",
		QueryName : "UFindDHCMarkDoc",
		depid: ""
	});
}
function findConfig () {
	var locid = PageLogicObj.m_Loc.getValue();
	var reg = PageLogicObj.m_Reg.getValue();
	var doc = PageLogicObj.m_Doc.getValue();
	PageLogicObj.m_Grid.reload({
		ClassName : "DHCDoc.DHCDocConfig.CommonFunction",
		QueryName : "UFindDHCMarkDoc",
		depid: locid,
		reg: reg,
		doc: doc
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
function Alladd(){
	var locid = PageLogicObj.m_Loc.getValue();
	/*if (locid==""){
		$.messager.alert('提示','请选择科室',"info");
		return false；
		}*/
	var html="<div id ='AllChange' style='padding:10px;'>"
	html += "<table class='base-table' > "
	html +="<tr><td><span class='c-span'>科室</span><input id='List_Loc' class='textbox' type='text' /></tr></td>"
	html += "	<tr><td>"
	html += "    <div class='hisui-panel' style='padding:15px 0px 0px;height:400px;width:260px' title='医生' data-options='headerCls:"+'"panel-header-card"'+",closable:false, collapsible:false,minimizable:false,maximizable:false'>" 
	html +="		<select size='4'  multiple='multiple' id='List_Doc' style='border-style:none;height:100%;width:99%;'></select>"
	html +="			</div></td><td><label class='active-label'>&nbsp;</label></td>"
	html +="	<td><div class='hisui-panel' style='padding:15px 0px 0px;height:400px;width:260px' title='号别' data-options='headerCls:"+'"panel-header-card"'+",closable:false, collapsible:false,minimizable:false,maximizable:false'>" 
	html +="			<select size='4'  multiple='multiple' id='List_Mark' style='border-style:none;height:100%;width:99%;'></select>"
	html +="		</div></td></tr><tr height='5px'><td></td></tr><tr><td  colspan='3' style='text-align:center' ><a class='hisui-linkbutton' id='Confirm'  data-options=''>保存</a></td></tr></table></div>"
	createModalDialog("AllAddMark","批量保存号别", 552, 518,"icon-w-add","",html,"");
	intiloc()
	//LoadDocData(locid)
	$("#Confirm").click(function(){AllConfirm()});
}
function intiloc(){
	 var HospID=$HUI.combogrid('#_HospList').getValue();
	var cbox = $HUI.combobox("#List_Loc", {
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CommonFunction&QueryName=QueryLoc&depname=&UserID=&LogHospId="+HospID+ "&ResultSetType=array",
		valueField:'id',
		textField:'name',
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
			var locid = record["id"]  //PageLogicObj.m_DG_Loc.getValue();
			LoadDocData(locid)
		}
	});
}
function AllConfirm(){
	var DocDataStr=""	
	var size = $("#List_Doc option").size();
	if(size>0){
		$.each($("#List_Doc  option:selected"), function(i,own){
			var svalue = $(own).val();
			if (DocDataStr=="") DocDataStr=svalue
			else DocDataStr=DocDataStr+"^"+svalue
		})
	}
	var MarkDataStr=""
	var size = $("#List_Mark option").size();
	if(size>0){
		$.each($("#List_Mark  option:selected"), function(i,own){
			var svalue = $(own).val();
			if (MarkDataStr=="") MarkDataStr=svalue
			else MarkDataStr=MarkDataStr+"^"+svalue
		})
	}
	if (DocDataStr==""){
		$.messager.alert('提示','请选择医生',"info");
		return false;
	}
	if (DocDataStr.split("^").length!="1"){
		$.messager.alert('提示','请选择一位医生',"info");
		return false;
	}
	if (MarkDataStr==""){
		$.messager.alert('提示','请选择号别',"info");
		return false;
	}
	var locid=$HUI.combobox("#List_Loc").getValue()
	$.m({
		ClassName:"DHCDoc.DHCDocConfig.CommonFunction",
		MethodName:"insertMarkDocMulit",
		'depid':locid,
		'markstr':MarkDataStr,
		'docstr':DocDataStr
	},function (responseText){
		$.messager.alert('提示',responseText,"info");
		destroyDialog("AllAddMark");
		PageLogicObj.m_Grid.reload();
	})
}
function LoadDocData(locid){
	var HospID=$HUI.combogrid('#_HospList').getValue();
	$.m({
		ClassName:"web.DHCExaBorough",
		MethodName:"FindDocBroker",
		depid:locid,
		HospID:HospID
	},function(objScope){
		$("#List_Doc").empty();
		var vlist = ""; 
		var selectlist="";
		var objScopeArr=objScope.split(String.fromCharCode(1))
		for(var i=0;i<objScopeArr.length;i++){
			var oneGroup=objScopeArr[i];
			var oneGroupArr=oneGroup.split(String.fromCharCode(2))
			var GroupRowID=oneGroupArr[0];
			var GroupDesc=oneGroupArr[1];
			var selected=oneGroupArr[2];
			vlist += "<option value=" + GroupRowID + ">" + GroupDesc + "</option>"; 
			selectlist=selectlist+"^"+selected
		}
		$("#List_Doc").append(vlist); 
	});	
	$.m({
		ClassName:"web.DHCExaBorough",
		MethodName:"FindlocBroker",
		depid:locid
	},function(objScope){
		$("#List_Mark").empty();
		var vlist = ""; 
		var selectlist="";
		var objScopeArr=objScope.split(String.fromCharCode(1))
		for(var i=0;i<objScopeArr.length;i++){
			var oneGroup=objScopeArr[i];
			var oneGroupArr=oneGroup.split(String.fromCharCode(2))
			var GroupRowID=oneGroupArr[0];
			var GroupDesc=oneGroupArr[1];
			var selected=oneGroupArr[2];
			vlist += "<option value=" + GroupRowID + ">" + GroupDesc + "</option>"; 
			selectlist=selectlist+"^"+selected
		}
		$("#List_Mark").append(vlist); 
	});	
}
function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        //href: _url,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        content:_content,
        onClose:function(){
	        destroyDialog(id);
	    }
    });
}
function destroyDialog(id){
   //移除存在的Dialog
   $("body").remove("#"+id); 
   $("#"+id).dialog('destroy');
}
function FindLocChange(){
	PageLogicObj.m_LocListTabDataGrid.datagrid("reload");
}
function FindDocChange(){
	PageLogicObj.m_DocListTabDataGrid.datagrid("reload");
}
function FindMarkChange(){
	PageLogicObj.m_MarkListTabDataGrid.datagrid("reload");
}
function InitLocListTabDataGrid(){
	var Columns=[[ 
		{field:'name',title:'科室',width:180},
		{field:'id',title:'ID',width:80}
    ]]
	var LocListTabDataGrid=$("#LocListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		rownumbers : false,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'id',
		columns :Columns,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CommonFunction&QueryName=QueryLoc&depname=&UserID=",
		onBeforeLoad:function(param){
			$("#LocListTab").datagrid("uncheckAll");
			var desc=$("#FindLoc").searchbox('getValue'); 
			param = $.extend(param,{depname:desc,LogHospId:$HUI.combogrid('#_HospList').getValue()});
		},
		onSelect:function(){
			LocListTabSelect();
		},
		onUncheckAll:function(rows){
			if (PageLogicObj.m_DocListTabDataGrid!="") {
				PageLogicObj.m_DocListTabDataGrid.datagrid("uncheckAll").datagrid('loadData', {"total":0,"rows":[]});
			}
			if (PageLogicObj.m_MarkListTabDataGrid!=""){
				PageLogicObj.m_MarkListTabDataGrid.datagrid("uncheckAll").datagrid('loadData', {"total":0,"rows":[]});
			}
			if (PageLogicObj.m_DocListTab1DataGrid!="") {
				PageLogicObj.m_DocListTab1DataGrid.datagrid("uncheckAll").datagrid('loadData', {"total":0,"rows":[]});
			}
			if (PageLogicObj.m_MarkListTab1DataGrid!=""){
				PageLogicObj.m_MarkListTab1DataGrid.datagrid("uncheckAll").datagrid('loadData', {"total":0,"rows":[]});
			}
		}
	});
	return LocListTabDataGrid;
}
//批量号别对照-医生对号别
function InitDocListTabDataGrid(){
	var Columns=[[ 
		{field:'Desc',title:'医生',width:200},
		//{field:'RowID',title:'ID',width:80}
    ]]
	var DocListTabDataGrid=$("#DocListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		rownumbers : false,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'RowID',
		columns :Columns,
		url:$URL+"?ClassName=web.DHCExaBorough&QueryName=FindDoc&depid=&docname=",
		onBeforeLoad:function(param){
			$("#DocListTab").datagrid("uncheckAll");
			var desc=$("#FindDoc").searchbox('getValue'); 
			var selrow=PageLogicObj.m_LocListTabDataGrid.datagrid("getSelected")
			if (selrow) LocId=selrow.id;
			else  LocId="";
			param = $.extend(param,{depid:LocId,docname:desc});
		},
		onSelect:function(){
			if (PageLogicObj.m_MarkListTabDataGrid=="") {
				PageLogicObj.m_MarkListTabDataGrid=InitMarkListTabDataGrid();
			}else{
				PageLogicObj.m_MarkListTabDataGrid.datagrid("reload");
			}
		},
		onUncheckAll:function(rows){
			if (PageLogicObj.m_MarkListTabDataGrid!="") {
				PageLogicObj.m_MarkListTabDataGrid.datagrid("uncheckAll").datagrid('loadData', {"total":0,"rows":[]});
			}
		}
	});
	return DocListTabDataGrid;
} 
function InitMarkListTabDataGrid(){
	var Columns=[[ 
		{field:'RowID',title:'',checkbox:true},
		{field:'Desc',title:'号别',width:180}		
    ]]
	var MarkListTabDataGrid=$("#MarkListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		pagination : false,  
		rownumbers : false,  
		idField:'RowID',
		columns :Columns,
		url:$URL+"?ClassName=web.DHCExaBorough&QueryName=FindMarkDoc&depid=&docname=&DocId=",
		onBeforeLoad:function(param){
			$("#MarkListTab").datagrid("uncheckAll");
			var desc=$("#FindMark").searchbox('getValue'); 
			param = $.extend(param,{depid:GetSelLocId(),DocId:GetSelDocId(),docname:desc,Type:"DocToMark"});
		},
		onLoadSuccess:function(data){
			for (var i=0;i<data.rows.length;i++){
				var PoweredFlag=data.rows[i].PoweredFlag;
				if (PoweredFlag=="Y") {
					PageLogicObj.m_MarkListTabDataGrid.datagrid('selectRow',i);
				}
			}
		}
	});
	return MarkListTabDataGrid;
}
function GetSelLocId(){
	var SelRow=PageLogicObj.m_LocListTabDataGrid.datagrid('getSelections');
	if (SelRow.length==0) return "";
	var LocId=SelRow[0].id;
	return LocId;
}
function GetSelDocId(){
	var SelRow=PageLogicObj.m_DocListTabDataGrid.datagrid('getSelections');
	if (SelRow.length==0) return "";
	var DocId=SelRow[0].RowID;
	return DocId;
}
function MulMarkDocSave(){
	var LocId=GetSelLocId();
	if (LocId=="") {
		$.messager.alert("提示","请选择科室！");
		return false;
	}
	var DocId=GetSelDocId();
	if (DocId=="") {
		$.messager.alert("提示","请选择医生！");
		return false;
	}
	if (PageLogicObj.m_MarkListTabDataGrid=="") {
		$.messager.alert("提示","没有需要保存的数据!");
		return false;
	}
	var rows=PageLogicObj.m_MarkListTabDataGrid.datagrid('getRows');
	if (rows.length==0) {
		$.messager.alert("提示","没有需要保存的数据!");
		return false;
	}
	var GridSelectArr=PageLogicObj.m_MarkListTabDataGrid.datagrid('getSelections');
	var inPara="",subPara="";
	for (var i=0;i<rows.length;i++){
		var RowID=rows[i].RowID;
		if ($.hisui.indexOfArray(GridSelectArr,"RowID",RowID)>=0) {
			if (inPara == "") inPara = RowID;
			else  inPara = inPara + "^" + RowID;
		}else{
			if (subPara == "") subPara = RowID;
			else  subPara = subPara + "^" + RowID;
		}
	}
	$.m({
	    ClassName:"web.DHCExaBorough",
	    MethodName:"SaveMarkDoc",
	    Loc:LocId,
	    DocId:DocId,
	    inPara:inPara,
	    subPara:subPara
	},function(rtn){
		if(rtn==0){
			$.messager.popover({msg:'保存成功',type:'success',timeout:1000});
		}
	})
}
//批量号别对照-号别对医生
function FindDoc1Change(){
	PageLogicObj.m_DocListTab1DataGrid.datagrid("reload");
}
function FindMark1Change(){
	PageLogicObj.m_MarkListTab1DataGrid.datagrid("reload");
}
function InitMarkListTab1DataGrid(){
	var Columns=[[ 
		{field:'Desc',title:'号别',width:180}		
    ]]
	var MarkListTab1DataGrid=$("#MarkListTab1").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		rownumbers : false, 
		pageSize: 20,
		pageList : [20,100,200], 
		idField:'RowID',
		columns :Columns,
		url:$URL+"?ClassName=web.DHCExaBorough&QueryName=FindDoc&depid=&docname=&Type=MarkToDoc",
		onBeforeLoad:function(param){
			$("#MarkListTab1").datagrid("uncheckAll");
			var desc=$("#FindMark1").searchbox('getValue'); 
			param = $.extend(param,{depid:GetSelLocId(),docname:desc});
		},
		onSelect:function(){
			if (PageLogicObj.m_DocListTab1DataGrid=="") {
				PageLogicObj.m_DocListTab1DataGrid=InitDocListTab1DataGrid();
			}else{
				PageLogicObj.m_DocListTab1DataGrid.datagrid("reload");
			}
		},
		onUncheckAll:function(rows){
			if (PageLogicObj.m_DocListTab1DataGrid!="") {
				PageLogicObj.m_DocListTab1DataGrid.datagrid("uncheckAll").datagrid('loadData', {"total":0,"rows":[]});
			}
		}
	});
	return MarkListTab1DataGrid;
}
function InitDocListTab1DataGrid(){
	var Columns=[[ 
		{field:'RowID',title:'',checkbox:true},
		{field:'Desc',title:'医生',width:200},
    ]]
	var DocListTab1DataGrid=$("#DocListTab1").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		pagination : false,  
		rownumbers : false,  
		idField:'RowID',
		columns :Columns,
		url:$URL+"?ClassName=web.DHCExaBorough&QueryName=FindMarkDoc&depid=&docname=&DocId=",
		onBeforeLoad:function(param){
			$("#DocListTab1").datagrid("uncheckAll");
			var desc=$("#FindDoc1").searchbox('getValue'); 
			var selrow=PageLogicObj.m_LocListTabDataGrid.datagrid("getSelected")
			if (selrow) LocId=selrow.id;
			else  LocId="";
			param = $.extend(param,{depid:LocId,DocId:GetSelMarkId(),docname:desc,Type:"MarkToDoc"});
		},
		onLoadSuccess:function(data){
			for (var i=0;i<data.rows.length;i++){
				var PoweredFlag=data.rows[i].PoweredFlag;
				if (PoweredFlag=="Y") {
					PageLogicObj.m_DocListTab1DataGrid.datagrid('selectRow',i);
				}
			}
		}
	});
	return DocListTab1DataGrid;
} 
function GetSelMarkId(){
	var SelRow=PageLogicObj.m_MarkListTab1DataGrid.datagrid('getSelections');
	if (SelRow.length==0) return "";
	var DocId=SelRow[0].RowID;
	return DocId;
}
function MulDocMarkSave(){
	var LocId=GetSelLocId();
	if (LocId=="") {
		$.messager.alert("提示","请选择科室！");
		return false;
	}
	var MarkId=GetSelMarkId();
	if (MarkId=="") {
		$.messager.alert("提示","请选择号别！");
		return false;
	}
	if (PageLogicObj.m_DocListTab1DataGrid=="") {
		$.messager.alert("提示","没有需要保存的数据!");
		return false;
	}
	var rows=PageLogicObj.m_DocListTab1DataGrid.datagrid('getRows');
	if (rows.length==0) {
		$.messager.alert("提示","没有需要保存的数据!");
		return false;
	}
	var GridSelectArr=PageLogicObj.m_DocListTab1DataGrid.datagrid('getSelections');
	var inPara="",subPara="";
	for (var i=0;i<rows.length;i++){
		var RowID=rows[i].RowID;
		if ($.hisui.indexOfArray(GridSelectArr,"RowID",RowID)>=0) {
			if (inPara == "") inPara = RowID;
			else  inPara = inPara + "^" + RowID;
		}else{
			if (subPara == "") subPara = RowID;
			else  subPara = subPara + "^" + RowID;
		}
	}
	$.m({
	    ClassName:"web.DHCExaBorough",
	    MethodName:"SaveDocMark", //todo
	    Loc:LocId,
	    MarkId:MarkId,
	    inPara:inPara,
	    subPara:subPara
	},function(rtn){
		if(rtn==0){
			$.messager.popover({msg:'保存成功',type:'success',timeout:1000});
		}
	})
}
function LocListTabSelect(){
	var seltab=$('#tab').tabs('getSelected'); 
	var index = $('#tab').tabs('getTabIndex',seltab);
	if (index==0) {
		if (PageLogicObj.m_DocListTabDataGrid=="") {
			PageLogicObj.m_DocListTabDataGrid=InitDocListTabDataGrid();
		}else{
			PageLogicObj.m_DocListTabDataGrid.datagrid("reload");
		}
	}else{
		if (PageLogicObj.m_MarkListTab1DataGrid=="") {
			PageLogicObj.m_MarkListTab1DataGrid=InitMarkListTab1DataGrid();
		}else{
			PageLogicObj.m_MarkListTab1DataGrid.datagrid("reload");
		}
	}
}