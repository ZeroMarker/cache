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
	m_Win : "",
	m_ExtOrgGrid:"",
	m_ExtOrgWin:"",
	m_ExtOrgCombox : "",
	m_Diag_ExtOrgCombox:""
	
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
			findConfig();
		},
		onSelect: function () {
			findConfig();
		}
	});
	PageLogicObj.m_ExtOrgCombox = $HUI.combobox("#i-extorg", {
		url:$URL+"?ClassName=web.DHCDocExtData&QueryName=ExtOrgDataQuery&Active=Y&ResultSetType=array",
		valueField:'ExtOrgRowid',
		textField:'TExtOrgDesc',
		//editable:false,
		onSelect: function () {
			findConfig();
		}
	});
	PageLogicObj.m_Grid = InitGrid();
	PageLogicObj.m_ExtOrgGrid = InitExtOrgGrid();
}
function InitEvent(){
	$("#i-find").click(findConfig);
	$("#i-add").click(function(){opDialog("add")});
	$("#i-edit").click(function(){opDialog("edit")});
	$("#i-delete").click(function(){deConfig()});
	$("#i-ExtOrg").click(ExtOrgHandle);
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
		{field:'TMUCExtOrgDr',title:'外部机构id',width:60,hidden:true},
		{field:'TMUCExtOrg',title:'外部机构',width:100},
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
			},'-',{
				id:"tip",
				iconCls: 'icon-help',
				handler: function(){
					InitTip();
					$("#tip").popover('show');
				}
			}
		],
		onDblClickRow:function(index, row){
			opDialog("edit");
		}
	});
	
	return DurDataGrid;
}

function InitTip(){
	var _content = "<ul class='tip_class'><li style='font-weight:bold'>使用说明</li>" + 
		"<li>根据HIS字典表ID获取对照数据接口：</li>" + 
		"<li><span>##class(web.DHCDocExtData).GetExtData</li></span>" + 
		"<li><span>说明:</span>代码类型、HIS字典表ID不能为空,机构代码为空则取未维护机构的通用对照数据</li>" +
		"<li><span>入参:</span>代码类型、HIS字典表ID、机构代码</li>" +
		"<li><span>出参:</span>0^外部代码_$C(1)_外部名称</li>" +
		"<li><span>出参:</span>非0^错误信息</li>" +
		'<li><span>示例:</span>##class(web.DHCDocExtData).GetExtData("freq",1,"01")</li>'
	$("#tip").popover({
		trigger:'hover',
		content:_content
	});
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
	PageLogicObj.m_Diag_ExtOrgCombox = $HUI.combobox("#i-diag-ExtOrg", {
		url:$URL+"?ClassName=web.DHCDocExtData&QueryName=ExtOrgDataQuery&Active=Y&ResultSetType=array",
		valueField:'ExtOrgRowid',
		textField:'TExtOrgDesc',
		filter:function(q, row){
			var opts = $(this).combobox('options');
			return row[opts.textField].toUpperCase().indexOf(q.toUpperCase()) >= 0;
		}
	});
	if (action == "add") {
		//$("#i-action").val("add");
		PageLogicObj.m_Diag_HiscodeCombox.setValue("");
		$("#i-diag-hisname").val("");
		$("#i-diag-wbcode").val("");
		$("#i-diag-wbname").val("");
		$("#i-diag-active").checkbox("uncheck")
		PageLogicObj.m_Diag_ExtOrgCombox.setValue("");
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
		PageLogicObj.m_Diag_ExtOrgCombox.setValue(selected.TMUCExtOrgDr);
	}
	
	var cWin = $HUI.window('#i-dialog', {
		title: _title,
		iconCls: _icon,
		modal: true,
		minimizable:false,
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
	var ExtOrgId = PageLogicObj.m_Diag_ExtOrgCombox.getValue();
	var ExtOrg = PageLogicObj.m_Diag_ExtOrgCombox.getText();
	var hisname = $("#i-diag-hisname").val();
	var wbcode = $("#i-diag-wbcode").val();
	var wbname = $("#i-diag-wbname").val();
	var active = $("#i-diag-active").checkbox("getValue");
	if (active) {
		active = "Y"
	} else {
		active = "N"
	}
	var paraInStr = type + "^" + hisCodeId + "^" + hisCode + "^" + hisname + "^" + wbcode + "^" + wbname + "^" + active +"^"+ ExtOrgId;
	var paraUpStr = hisCodeId + "^" + hisCode + "^" + hisname + "^" + wbcode + "^" + wbname + "^" + active +"^"+ ExtOrgId;
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
		rpResult = tkMakeServerCall("web.DHCDocExtData","RepeatExtData",type,hisCodeId,"",ExtOrgId);
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
				//$.messager.alert('提示','新增成功！',"info");
				$.messager.popover({msg: '新增成功！',type:'success',timeout: 1000});
				PageLogicObj.m_Win.close();
				PageLogicObj.m_Grid.reload();
				
			} else {
				$.messager.alert('提示','新增失败,错误代码: '+ responseText , "info");
				return false;
			}	
		})
	} else {
		rpResult = tkMakeServerCall("web.DHCDocExtData","RepeatExtData",type,hisCodeId,id,ExtOrgId);
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
				//$.messager.alert('提示','修改成功！',"info");
				$.messager.popover({msg: '修改成功！',type:'success',timeout: 1000});
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
	var Code = $("#i-code").val();
	var Desc = $("#i-desc").val();
	var SelectExtOrg = PageLogicObj.m_ExtOrgCombox.getValue();
	PageLogicObj.m_Grid.reload({
		ClassName : "web.DHCDocExtData",
		QueryName : "ExtDataQuery",
		SelectTypeCode: SelectTypeCode,
		Code: Code,
		Desc: Desc,
		SelectExtOrg:SelectExtOrg
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
    }else if (keyCode==13) {
		if ((SrcObj.tagName=="A")||(SrcObj.tagName=="INPUT")) {
			var myComName=SrcObj.id;
			if (myComName=="i-code"){
				findConfig();
			}else if(myComName=="i-desc"){
				findConfig();
			}
			return true;
		}
		return true;
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        e.preventDefault();   
    }   
}


function ExtOrgHandle(){
	var cWin = $HUI.dialog('#i-ExtOrg-dialog', {
		title: "外部机构维护",
		width:680,
		height:500,
		iconCls: "icon-save",
		modal: true,
		minimizable:false,
		maximizable:false,
		collapsible:false,
		onClose: function () {
		}
	});
	$("#i-diag-ExtOrgCode,#i-diag-ExtOrgDesc").val("");
	$("#i-diag-ExtOrgActive").checkbox('setValue',false);
	PageLogicObj.m_ExtOrgWin = cWin;
	findExtOrg();
	$('#i-ExtOrg-dialog').window('open');
}

function InitExtOrgGrid(){
	var columns = [[
		{field:'TExtOrgCode',title:'机构代码',width:100},
		{field:'TExtOrgDesc',title:'机构描述',width:100},
		{field:'TExtOrgActiveFlag',title:'可用标识',width:100},
		{field:'ExtOrgRowid',title:'ID',width:60,hidden:true}
    ]]
	var ExtOrgDataGrid = $("#tabExtOrg").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		rownumbers:true,
		//autoRowHeight : false,
		pagination : true,  
		pageSize: 10,
		pageList : [10,20,50],
		idField:'ExtOrgRowid',
		columns :columns,
		toolbar:[{
				text:'新增',
				id:'i-extadd',
				iconCls: 'icon-add',
				handler:function(){
					SaveExtOrg("add")	
				}
			},{
				text:'修改',
				id:'i-extedit',
				iconCls: 'icon-write-order',
				handler:function(){
					SaveExtOrg("edit")	
				}
			}
		],
		onSelect:function(index,row){
			SetSelRowData(row)	
		},
		onUnselect:function(index, row){
			$("#i-diag-ExtOrgCode,#i-diag-ExtOrgDesc").val("");
			$("#i-diag-ExtOrgActive").checkbox('uncheck');
		},
		onBeforeSelect:function(index, row){
			var selrow=PageLogicObj.m_ExtOrgGrid.datagrid('getSelected');
			if (selrow){
				var oldIndex=PageLogicObj.m_ExtOrgGrid.datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					PageLogicObj.m_ExtOrgGrid.datagrid('unselectRow',index);
					return false;
				}
			}
		}
	});
	
	return ExtOrgDataGrid;
}

function SetSelRowData(row){
	$("#i-diag-ExtOrgCode").val(row["TExtOrgCode"]);
	$("#i-diag-ExtOrgDesc").val(row["TExtOrgDesc"]);
	var ActiveFlag=row["TExtOrgActiveFlag"];
	if (ActiveFlag=="Y") {
		$("#i-diag-ExtOrgActive").checkbox('check');
	}else{
		$("#i-diag-ExtOrgActive").checkbox('uncheck');
	}
}

function SaveExtOrg(param){
	var Code=$("#i-diag-ExtOrgCode").val();
	var Desc=$("#i-diag-ExtOrgDesc").val();
	var Rowid="";
	if(param=="edit"){
		var row=PageLogicObj.m_ExtOrgGrid.datagrid("getSelected");
		if(row){
			Rowid=row.ExtOrgRowid;
		}
		if(Rowid==""){
			$.messager.alert("提示","请选择一行数据.","warning")	
			return false;
		}
	}
	if(Code==""){
		$.messager.alert("提示","机构代码不能为空.","warning",function(){
			$('#i-diag-ExtOrgCode').next('span').find('input').focus();		
		})	
		return false;
	}
	if(Desc==""){
		$.messager.alert("提示","机构描述不能为空.","warning",function(){
			$('#i-diag-ExtOrgDesc').next('span').find('input').focus();	
		})	
		return false;
	}
	var ActiveFlag=$HUI.checkbox("#i-diag-ExtOrgActive").getValue();
	if(ActiveFlag){
		ActiveFlag="Y";
	}else{
		ActiveFlag="N";
	}
	
	$.cm({
		ClassName:"web.DHCDocExtData",
		MethodName:"SaveExtOrg",
		Code:Code,
		Desc:Desc,
		Active:ActiveFlag,
		Rowid:Rowid,
		dataType:"text"
	},function(val){
		if(val==0){
			$.messager.popover({msg:"操作成功!",type:'success',timeout: 1000})	
			findExtOrg();
		}else{
			var msg="操作失败!"
			if(val=="1"){
				msg=msg+"存在重复的代码数据."	
			}
			else if(val=="2"){
				msg=msg+"存在重复的描述数据."	
			}
			else{
				msg=msg+"错误代码:"+val;
			}
			$.messager.alert("错误",msg,"error")	
		}	
	})
}
function findExtOrg(){
	$.cm({
	    ClassName : "web.DHCDocExtData",
	    QueryName : "ExtOrgDataQuery",
	    Pagerows:PageLogicObj.m_ExtOrgGrid.datagrid("options").pageSize,
	    rows:99999
	},function(GridData){
		PageLogicObj.m_ExtOrgGrid.datagrid("unselectAll");
		PageLogicObj.m_ExtOrgGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}