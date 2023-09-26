/**
 * upmanage.js 使用目的管控设置
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2019-07-16
 * 
 * 
 */
var PageLogicObj = {
	m_DateType: '',
	m_Grid: '',
	m_CHosp:""
	
}

$(function() {
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
	
	//页面元素初始化
	//PageHandle();
})


function Init(){
	PageLogicObj.m_HospGrid = InitHospGrid();
	//InitCombobox();
	PageLogicObj.m_Grid = InitGrid();
	InitHospList();
}

function InitEvent () {
	$("#i-search").click(findConfig);
	$("#i-clear").click(function(){
		clearCondition();
		findConfig();
	});
	$("#i-add").click(function() {
		AddUPM("add")
	});
	$("#i-edit").click(function() {
		AddUPM("edit")
	});
}

function InitHospGrid(){
	var columns = [[
		{field:'text',title:'院区',width:100},
		{field:'id',title:'id',width:100,hidden:true}
	]]
	var DataGrid = $HUI.datagrid("#i-hosp", {
		//title:'院区列表',
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		rownumbers:false,
		//autoRowHeight : false,
		//pagination : true,  
		//headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCAnt.KSS.Config.Authority",
			QueryName : "QryHosp"
		},
		onSelect: function (rowIndex, rowData) {
			PageLogicObj.m_CHosp = rowData.id;
			InitCombobox(rowData.id);
			clearCondition();
			findConfig();
		},
		columns :columns
	});
	
	return DataGrid;
}
	
function AddUPM(ac) {
	var selected = PageLogicObj.m_Grid.getSelected(),
		arcimDr = "",
		arcimText = "";
		id = "";
	if (ac == "edit") {
		if (!selected) {
			$.messager.alert("提示","请选择一条记录！","warning");
			return false;
		}
		id = selected.id;
		arcimDr = PageLogicObj.m_arcim.getValue()||selected.arcimDr;
	} else {
		id = "";
		arcimDr = PageLogicObj.m_arcim.getValue()||"";
		arcimText = PageLogicObj.m_arcim.getText()||"";
		if ((arcimText!="")&&(arcimDr=="")) {
			arcimDr = $("#i-hidden-arcim").val();
		}
		
	}
	var objCode = PageLogicObj.m_obj.getValue()||"";
	var level = PageLogicObj.m_level.getValue()||"";
	var item = PageLogicObj.m_item.getValue()||"";
	var controlType = PageLogicObj.m_type.getValue()||"";
	var active = $("#i-active").checkbox("getValue")?1:0;
	var excuteUser = session['LOGON.USERID'];
	
	if (objCode=="") {
		$.messager.alert("提示","控制大类不能为空！","warning");
		return false;
	}
	if ((level=="")||(item=="")) {
		$.messager.alert("提示","控制层级、控制项目不能为空！","warning");
		return false;
	} 
	if (arcimDr=="") {
		$.messager.alert("提示","医嘱项不能为空！","warning");
		return false;
	}
	if (controlType == "") {
		$.messager.alert("提示","控制类型不能为空！","warning");
		return false;
	}
	if (PageLogicObj.m_CHosp=="") {
		$.messager.alert("提示","院区不能为空！","warning");
		return false;
	}
	var mList = id + "^" + objCode + "^" + level + "^" + item + "^" + arcimDr + "^" + controlType + "^" + active + "^" + excuteUser + "^" + PageLogicObj.m_CHosp;
	
	var rtn = tkMakeServerCall("DHCAnt.KSS.Config.UsePurposeManage","SaveUPM", mList);
	if (rtn > 0) {
		$.messager.alert("提示","保存成功！","info");
		clearCondition();
		findConfig();
	} else if(rtn == "-110") {
		$.messager.alert("提示","配置已存在！","warning");
		return false;
	} else {
		$.messager.alert("提示","操作失败，错误代码为：" + rtn,"warning");
	}

}
function InitCombobox (InHosp) {
	InHosp = InHosp||"";
	
	//控制大类
	PageLogicObj.m_obj = $HUI.combobox("#i-obj", {
		url:$URL+"?ClassName=DHCAnt.KSS.Config.UsePurposeManage&QueryName=QryAllbasedata&type=OBJ&InHosp="+InHosp+"&ResultSetType=array",
		valueField:'code',
		textField:'desc',
		onSelect: function (record) {
			if (record != undefined) {
				var url = $URL+"?ClassName=DHCAnt.KSS.Config.UsePurposeManage&QueryName=QryCLevel&objCode=" + record.code + "&InHosp="+InHosp+"&ResultSetType=array";
			} else {
				var parDr="";
				var url = $URL+"?ClassName=DHCAnt.KSS.Config.UsePurposeManage&QueryName=QryCLevel&InHosp="+InHosp+"&ResultSetType=array";
			}
			PageLogicObj.m_level.setValue("");
			PageLogicObj.m_level.reload(url)
			
			var url2=""
			if (record != undefined) {
				url2 = $URL+"?ClassName=DHCAnt.KSS.Config.UsePurposeManage&QueryName=QryCItem&objCode=" + record.code + "&InHosp="+InHosp+"&ResultSetType=array";
			} else {
				var parDr="";
				url2 = $URL+"?ClassName=DHCAnt.KSS.Config.UsePurposeManage&QueryName=QryCItem&InHosp="+InHosp+"&ResultSetType=array";
			}
			PageLogicObj.m_item.setValue("");
			PageLogicObj.m_item.reload(url2)
			
		},
		onHidePanel:function() {
			var objCode = PageLogicObj.m_obj.getValue()||"";
			if (objCode == "") {
				PageLogicObj.m_level.setValue("");
				var url = $URL+"?ClassName=DHCAnt.KSS.Config.UsePurposeManage&QueryName=QryCLevel&ResultSetType=array";
				PageLogicObj.m_level.reload(url);
				
				PageLogicObj.m_item.setValue("");
				url = $URL+"?ClassName=DHCAnt.KSS.Config.UsePurposeManage&QueryName=QryCItem&ResultSetType=array";
				PageLogicObj.m_item.reload(url);
				
			}
		}
		
	});
	
	//控制层级
	PageLogicObj.m_level = $HUI.combobox("#i-level", {
		url:$URL+"?ClassName=DHCAnt.KSS.Config.UsePurposeManage&QueryName=QryCLevel&InHosp="+InHosp+"&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		blurValidValue:true
	});
	
	
	//控制项目
	PageLogicObj.m_item = $HUI.combobox("#i-item", {
		url:$URL+"?ClassName=DHCAnt.KSS.Config.UsePurposeManage&QueryName=QryCItem&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		blurValidValue:true
	});
	
	
	//控制类型
	PageLogicObj.m_type = $HUI.combobox("#i-type", {
		valueField:'id',
		textField:'text',
		data:[
			{id:'A',text:'提示'},
			{id:'F',text:'禁止'},
			{id:'N',text:'不控制'}
		]
	});
	
	//所属院区
	/* PageLogicObj.m_hosp = $HUI.combobox("#i-hosp", {
		url:$URL+"?ClassName=DHCAnt.KSS.Config.Authority&QueryName=QryHosp&ResultSetType=array",
		valueField:'id',
		textField:'text',
		blurValidValue:true
		
	}); */
	
	PageLogicObj.m_arcim = $HUI.combogrid("#i-arcim", {
		panelWidth:500,
		panelHeight:400,
		delay: 500,    
		mode: 'remote',    
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ArcItemConfig&QueryName=FindAllItem",
		fitColumns: true,   
		striped: true,   
		editable:true,   
		pagination : true,//是否分页   
		rownumbers:true,//序号   
		collapsible:false,//是否可折叠的   
		fit: true,//自动大小   
		pageSize: 10,//每页显示的记录条数，默认为10   
		pageList: [10],//可以设置每页记录条数的列表   
		method:'post', 
		idField: 'ArcimRowID',    
		textField: 'ArcimDesc',    
		columns: [[ 
			{field:'ArcimDesc',title:'名称',width:400,sortable:true},
			{field:'ArcimRowID',title:'ID',width:120,sortable:true},
			{field:'selected',title:'ID',width:120,sortable:true,hidden:true}
		]],
		onSelect: function (){
			var selected = $('#i-arcim').combogrid('grid').datagrid('getSelected');  
			if (selected) { 
			  $('#i-arcim').combogrid("options").value=selected.ArcimRowID;
			}
		 },
		 onBeforeLoad:function(param){
             var desc=param['q'];
             var HospId = PageLogicObj.m_Hosp.getValue()||"";
			 if (HospId=="") {
				HospId = session['LOGON.HOSPID'];
			 }
             param = $.extend(param,{Alias:param["q"],HospId:HospId});
         }
	});
	
}

function InitGrid(){
	var columns = [[
		{field:'objDesc',title:'控制大类',width:80},
		{field:'levelDesc',title:'控制层级',width:80},
		{field:'controlItem',title:'控制项目',width:80},
		{field:'arcimDesc',title:'医嘱项目',width:200},
		{field:'controlType',title:'控制类型',width:60},
		{field:'active',title:'是否激活',width:60,
			formatter:function(value,row,index){
				if (value == "1") {
					return "<span class='c-ok'>是</span>";
				} else {
					return "<span class='c-no'>否</span>";
				}
			}
		},
		{field:'id',title:'id',width:100,hidden:true}
    ]]
	var DataGrid = $HUI.datagrid("#i-grid", {
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
			ClassName : "DHCAnt.KSS.Config.UsePurposeManage",
			QueryName : "QryUPM",
			InActive:1,
			InExtendPara: "^^^"
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
		}],
		onBeforeSelect:function(index, row){
			var selrow=$("#i-grid").datagrid('getSelected');
			if (selrow){
				var oldIndex=$("#i-grid").datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					$("#i-grid").datagrid('unselectRow',index);
					return false;
				}
			}
		},
		onSelect: function (rowIndex, rowData) {
			setCondition(rowData);
		},
		onUnselect: function (rowIndex, rowData) {
			clearCondition();
		}
	});
	
	return DataGrid;
}

function clearCondition() {
	
	PageLogicObj.m_obj.select("");
	PageLogicObj.m_level.setValue("");
	PageLogicObj.m_item.setValue("");
	PageLogicObj.m_type.setValue("");
	PageLogicObj.m_arcim.setValue("");
	$("#i-hidden-arcim").val("");
	$("#i-active").checkbox("check");
	
}

function setCondition(rowData) {
	console.log(rowData)
	PageLogicObj.m_obj.select(rowData.objCode);
	setTimeout(function(){
		PageLogicObj.m_level.setValue(rowData.levelCode)
		PageLogicObj.m_item.setValue(rowData.controlItemDr);
		PageLogicObj.m_type.setValue(rowData.controlTypeCode);
		PageLogicObj.m_arcim.setText(rowData.arcimDesc);
		$("#i-hidden-arcim").val(rowData.arcimDr)
		if (rowData.active == 1) {
			$("#i-active").checkbox("check");
		} else {
			$("#i-active").checkbox("uncheck");
		}
	},50)
}

function findConfig () {
	var InLevel = PageLogicObj.m_level.getValue()||"";
	var InOBJDr = "";
	var InItemDr = "";
	var InUsePurposeDr = "";
	var InArcim = PageLogicObj.m_arcim.getValue()||"";
	var InArcimText = PageLogicObj.m_arcim.getText()||"";
	if ((InArcim=="")&&(InArcimText!="")) {
		InArcim = $("#i-hidden-arcim").val()
	}
	var InControlType = PageLogicObj.m_type.getValue()||"";
	var InActive = $("#i-active").checkbox("getValue")?1:0;
	
	var InObjCode = PageLogicObj.m_obj.getValue()||"";
	var InItem = PageLogicObj.m_item.getValue()||"";
	var InExtendPara = InObjCode + "^" + InItem + "^" + PageLogicObj.m_CHosp;
	var mList = InOBJDr+"^"+InItemDr+"^"+InUsePurposeDr+"^"+InArcim+"^"+InControlType+"^"+InActive;
	//alert(mList);
	PageLogicObj.m_Grid.reload({
		ClassName : "DHCAnt.KSS.Config.UsePurposeManage",
		QueryName : "QryUPM",
		InLevel:InLevel,
		InOBJDr: InOBJDr,
		InItemDr: InItemDr,
		InUsePurposeDr: InUsePurposeDr,
		InArcim: InArcim,
		InControlType: InControlType,
		InActive: InActive,
		InExtendPara: InExtendPara

	});
}

function InitHospList() {
	PageLogicObj.m_Hosp = GenHospComp("Ant_Config_Func_UsePurpose");
	PageLogicObj.m_Hosp.jdata.options.onSelect = function(rowIndex,data){
		PageLogicObj.m_CHosp = data.HOSPRowId;
		InitCombobox(data.HOSPRowId);
		clearCondition();
		findConfig();
	}
	PageLogicObj.m_Hosp.jdata.options.onLoadSuccess= function(data){
		PageLogicObj.m_CHosp = session['LOGON.HOSPID'];
		InitCombobox(session['LOGON.HOSPID']);
		clearCondition();
		findConfig();
	}
}
	
