/**
 * lifedosage.js
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-04-28
 * 
 * 
 */
var PLObject = {
	v_Arcim: ""
}
$(function() {
	Init();
	InitEvent();
})


function Init(){
	//InitCombox()
	InitGrid();
	
}

function InitEvent () {
	$("#i-find").click(findConfig);
	$("#i-clear").click(clearConfig)
	$("#i-add").click(addConfig);
	$("#i-edit").click(editConfig);
	$("#i-delete").click(deleteConfig);
	$(document.body).bind("keydown",BodykeydownHandler)
}

function InitCombox() {
	Combox_ItemDesc();
}

function Combox_ItemDesc(){
	$("#i-drug").lookup({
		width:300,
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'ArcimDR',
        textField:'ArcimDesc',
        columns:[[  
           {field:'ArcimDesc',title:'名称',width:320,sortable:true},
            {field:'ArcimDR',title:'ID',width:70,sortable:true}
        ]],
        pagination:true,
        panelWidth:400,
        panelHeight:400,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'DHCDoc.THPY.COM.Qry',QueryName: 'FindMasterItem'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        if (desc=="") return false;
			param = $.extend(param,{arcimdesc:desc});
	    },onSelect:function(ind,item){
		   PLObject.v_Arcim = item.ArcimDR;
		}
    });
}

function InitGrid(){
	var columns = [[
		{field:'arcimDesc',title:'医嘱名称',width:300},
		{field:'name',title:'简写名称',width:100},
		{field:'arcimCode',title:'医嘱代码',width:100},
		{field:'active',title:'是否激活',width:100,
			formatter:function(value,row,index){
					if (value == "1") {
						return "<span class='c-ok'>是</span>"
					} else {
						return "<span class='c-no'>否</span>"
					}
				}
		},
		{field:'id',title:'id',width:100,hidden:true}
	]]
	var DataGrid = $HUI.datagrid("#i-list", {
		fit : true,
		striped : true,
		border:false,
		singleSelect : true,
		fitColumns : true,
		rownumbers:false,
		//autoRowHeight : false,
		pagination : true,  
		//headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCDoc.Chemo.CFG.DrugDic",
			QueryName : "QryDrug",
			InArcim: ""
		},
		onSelect: function (rowIndex, rowData) {
			
		},
		toolbar:[
				{
						text:'新增',
						id:'i-add',
						iconCls: 'icon-add'
				},
				{
						text:'修改',
						id:'i-edit',
						iconCls: 'icon-write-order'
				},{
						text:'删除',
						id:'i-delete',
						iconCls: 'icon-cancel'
				}
					
		],
		columns :columns
	});
	
	PLObject.m_Grid = DataGrid;
}

function findConfig () {
	var InDesc = $.trim($("#i-drug").val());
	PLObject.m_Grid.reload({
		ClassName : "DHCDoc.Chemo.CFG.DrugDic",
		QueryName : "QryDrug",
		InDesc: InDesc	//PLObject.v_Arcim
	});
}

function addConfig () {
	var DID = ""
	var URL = "chemo.cfg.drugdic.edit.csp?DID="+DID;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-add',
		title:'添加',
		width:560,height:500,
		CallBackFunc:callback
	})
}

function editConfig () {
	var selected = PLObject.m_Grid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	var URL = "chemo.cfg.drugdic.edit.csp?DID="+selected.id;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'修改',
		width:560,height:500,
		CallBackFunc:callback
	})
}

function deleteConfig () {
	var selected = PLObject.m_Grid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	
	$.messager.confirm("提示", "确认删除？",function (r) {
		if (r) {
			$m({
				ClassName:"DHCDoc.Chemo.CFG.DrugDic",
				MethodName:"Delete",
				DID:selected.id
			}, function(result){
				if (result == 0) {
					$.messager.alert("提示", "删除成功！", "info");
					findConfig();
					return true;
				} else {
					$.messager.alert("提示", "删除失败：" + result , "info");
					return false;
				}
			});
		}
		
	});
	
}

function callback () {
	findConfig();
}

function clearConfig() {
	//PLObject.v_Arcim = "";
	//$("#i-drug").lookup("setText","");
	$("#i-drug").val("");
	findConfig();
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
	if (keyCode==13) {
		if(SrcObj && SrcObj.id.indexOf("i-drug")>=0){
			findConfig();
		}
		return true;
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
