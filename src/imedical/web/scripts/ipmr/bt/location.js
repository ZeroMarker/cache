/**
 * location 科室定义
 * 
 * Copyright (c) 2018-2019 LIYI. All rights reserved.
 * 
 * CREATED BY LIYI 2019-09-29
 * 
 * 注解说明
 * TABLE: 
 */

//页面全局变量对象
var globalObj = {
	m_gridLocation : ''
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
})

function Init(){
	Common_ComboToHosp("cboHospital1",'','');
	Common_ComboToDicCode("cboLocType1","LocType",1,'');
	Common_ComboToDicCode("cboAdmType1","AdmType",1,'');
	Common_ComboToDicCode("cboLocType2","LocType",1,'');
	Common_ComboToDicCode("cboAdmType2","AdmType",1,'');
	globalObj.m_gridLocation = InitgridLocation();
	Common_ComboToHosp("cboHosp");
	Common_ComboToDicCode('cboType','LocType',1,'');
	Common_MultipleComboToDicCode('cboAdmType','AdmType',1,'');
	Common_MultipleComboToLoc('cboLinkLoc','','')
}

function InitEvent(){
	$('#c-add').click(function(){
		if ($(this).hasClass("l-btn-disabled")) return;
		editlocation('add');
	});
	$('#c-edit').click(function(){
		if ($(this).hasClass("l-btn-disabled")) return;
		editlocation('edit');
	});
	$('#c-delete').click(function(){
		if ($(this).hasClass("l-btn-disabled")) return;
		deletelocation();
	});
	$('#btnSearch').click(function(){
		QueryLoc();
	});
	$('#btnSearch2').click(function(){
		QueryDpLoc();
	});
	$('#textAlias1').bind('keyup', function(event) {
	　　if (event.keyCode == "13") {
			QueryLoc();
			$('#textAlias1').val('');
	　　}
	});
	$('#textAlias2').bind('keyup', function(event) {
	　　if (event.keyCode == "13") {
			QueryDpLoc();
			$('#textAlias2').val('');
	　　}
	});
}
 /**
 * NUMS: D001
 * CTOR: LIYI
 * DESC: 科室定义
 * DATE: 2019-09-29
 * NOTE: 包括四个方法：InitgridLocation,editlocation,deletelocation,savelocation
 * TABLE: CT_IPMR_BT.system
 */

function QueryLoc(){
	var Hospital	= $("#cboHospital1").combobox('getValue');
	var LocType		= $("#cboLocType1").combobox('getValue');
	var AdmType		= $("#cboAdmType1").combobox('getValue');
	var Alias		= $("#textAlias1").val();
	$('#gridLocation').datagrid('load',  {
		ClassName:"MA.IPMR.BTS.LocationSrv",
		QueryName:"QryLoc",
		aHospId:Hospital,
		aLocType:LocType,
		aAdmType:AdmType,
		aLocGroup:'',
		aKeyword:Alias,
		aLocID:'',
		rows:10000
	});
	$('#gridLocation').datagrid('unselectAll');
}


 // 初始化表格
function InitgridLocation(){
	var columns = [[
		{field:'HospDesc',title:'医院',width:180,align:'left'},
		{field:'LocTypeDesc',title:'科室类型',width:100,align:'left'},
		{field:'AdmTypeDesc',title:'就诊类型',width:100,align:'left'},
		{field:'Code',title:'科室代码',width:100,align:'left'},
		{field:'Desc',title:'科室名称',width:180,align:'left'},
		//{field:'Desc2',title:'科室别名',width:180,align:'left'},
		{field:'LinkLocDesc',title:'关联科室',width:180,align:'left'},
		{field:'IsActive',title:'是否有效',width:80,align:'left',
			formatter:function(value,row,index){
				var IsActive	= row.IsActive;
				if (IsActive == '1'){
					return "是";
				} else {
					return "否";
				}
			}
		},
		{field:'d',title:'科室对照',width:80,align:'left',
			formatter:function(value,row,index) {
            	var LocID = row.ID;
				var LocDesc = row.Desc;
               	//return '<a href="#" class="grid-td-text-gray" onclick = OpenMapWin("' + LocID + '","' + LocDesc + '")>' + '对照' + '</a>';
               	return '<a href="#" class="grid-td-text-gray" onclick="OpenMapWin(\'' + LocID+'\',\''+ LocDesc + '\')">'+'对照'+'</a>';
            }
		}
    ]];
	var gridLocation =$HUI.datagrid("#gridLocation",{
		fit: true,
		//title: "科室维护",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 10,
		fitColumns:true,
	    url:$URL,
	    queryParams:{
		    ClassName:"MA.IPMR.BTS.LocationSrv",
			QueryName:"QryLoc",
			aHospId:'',
			aLocType:'',
			aAdmType:'',
			aLocGroup:'',
			aKeyword:'',
			aLocID:''
	    },
	    columns :columns,
		onClickRow:function(rowIndex,rowData){
		}
	});
	return gridLocation;
}

// 新增、修改事件
function editlocation(op){
	var selected = $("#gridLocation").datagrid('getSelected');
	if (( op == "edit")&&(!selected)) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	
	var _title = "修改科室",_icon="icon-w-edit"
	if (op == "add") {
		_title = "添加科室",_icon="icon-w-add";
		$("#txtId").val('');
		$("#cboHosp").combobox('setValue', '');
		$("#cboType").combobox('setValue', '');
		$("#cboAdmType").combobox('setValues', []);
		$("#txtCode").val('');
		$("#txtDesc").val('');
		$("#txtDesc2").val('');
		$("#cboLinkLoc").combobox('setValues', []);
		$("#chkActive").checkbox("setValue",false);
	} else {
		$("#txtId").val(selected.ID);
		$("#cboHosp").combobox('setValue', selected.HospID);
		$("#cboType").combobox('setValue', selected.LocType);
		var AdmType = selected.AdmType;
		var arrAdmType=[];
		for (i=0;i<AdmType.split(',').length ;i++ )
		{
			arrAdmType.push(AdmType.split(',')[i])
		}
		$("#cboAdmType").combobox('setValues', arrAdmType);
		$("#txtCode").val(selected.Code);
		$("#txtDesc").val(selected.Desc);
		$("#txtDesc2").val(selected.Desc2);
		var LinkLoc = selected.LinkLoc;
		var arrLinkLoc=[];
		for (i=0;i<LinkLoc.split(',').length ;i++ )
		{
			arrLinkLoc.push(LinkLoc.split(',')[i])
		}
		$("#cboLinkLoc").combobox('setValues', arrLinkLoc);
		$("#chkActive").checkbox("setValue",selected.IsActive=='1'?true:false);
	}

	var LocationDialog = $HUI.dialog('#LocationDialog', {
		title: _title,
		iconCls: _icon,
		modal: true,
		minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
		buttons:[{
			text:'保存',
				iconCls:'icon-w-save',
				handler:function(){
					savelocation();
				}
		},{
		text:'关闭',
		iconCls:'icon-w-close',
		handler:function(){
				$('#LocationDialog').window("close");
			}	
		}]
	});
}

// 删除事件
function deletelocation(){

	var selected = $("#gridLocation").datagrid('getSelected');
	if (!selected) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	$.messager.confirm('确认', '确认删除该条数据?', function(r){
    	if (r){
    		var flg = $m({
				ClassName:"MA.IPMR.BT.Location",
				MethodName:"DeleteById",
				aId:selected.ID
			},false);
			
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误", "删除失败!", 'error');
				return;
			}
			$("#gridLocation").datagrid("reload");
    	}
    });
}

// 保存操作
function savelocation(){
	var id = $("#txtId").val();
	var hospid = $("#cboHosp").combobox('getValue');
	var loctype = $("#cboType").combobox('getValue');
	var admtype = $("#cboAdmType").combobox('getValues');
	var code = $("#txtCode").val();
	var desc = $("#txtDesc").val();
	var desc2 = $("#txtDesc2").val();
	var linkloc = $("#cboLinkLoc").combobox('getValues');
	var isactive = $("#chkActive").checkbox("getValue")?"1":"0";
	if (hospid == '') {
		$.messager.popover({msg: '请选择医院！',type: 'alert',timeout: 1000});
		return false;
	}
	if (loctype == '') {
		$.messager.popover({msg: '请选择科室类型！',type: 'alert',timeout: 1000});
		return false;
	}
	if (admtype == '') {
		$.messager.popover({msg: '请选择就诊类型！',type: 'alert',timeout: 1000});
		return false;
	}
	if (code == '') {
		$.messager.popover({msg: '请填写科室代码！',type: 'alert',timeout: 1000});
		return false;
	}
	if (desc == '') {
		$.messager.popover({msg: '请填写科室名称！',type: 'alert',timeout: 1000});
		return false;
	}
	var inputStr = id;
	inputStr += '^' + code;
	inputStr += '^' + desc;
	inputStr += '^' + desc2;
	inputStr += '^' + loctype;
	inputStr += '^' + linkloc;
	inputStr += '^' + admtype;
	inputStr += '^' + hospid;
	inputStr += '^' + isactive;

	var flg = $m({
		ClassName:"MA.IPMR.BT.Location",
		MethodName:"Update",
		aInputStr:inputStr,
		aSeparate:"^"
	},false);
	
	if (parseInt(flg) <= 0) {
		if (parseInt(flg)==-100){
			$.messager.alert("提示", "科室代码重复!", 'info');
		}else{
			$.messager.alert("错误", "保存失败!", 'error');
		}
		return;
	}
	$('#LocationDialog').window("close");
	$("#gridLocation").datagrid("reload");
}

 /**
 * NUMS: D002
 * CTOR: LIYI
 * DESC: 对照
 * DATE: 2019-09-29
 * NOTE: 包括方法
 * TABLE: 
 */

 function QueryDpLoc(){
	var LocType		= $("#cboLocType2").combobox('getValue');
	var AdmType		= $("#cboAdmType2").combobox('getValue');
	var Alias		= $("#textAlias2").val();
	$('#gridDpLoc').datagrid('load',  {
		ClassName:"CT.IPMR.DPS.LocationSrv",
		QueryName:"QryLoc",
		aLocType:LocType,
		aAdmType:AdmType,
		aKeyword:Alias,
		rows:10000
	});
	$('#gridDpLoc').datagrid('unselectAll');
}

// 打开对照页面
function OpenMapWin(LocID,LocDesc) {
	var mapColumns = [[
		{field: 'SysDesc', title: '系统名称', width: 80, align: 'left'},
		{field: 'LocCode', title: '外部科室代码', width: 80, align: 'left'},
		{field: 'LocDesc', title: '外部科室名称', width: 120, align: 'left'},
		{field:'IsActive',title:'是否有效',width:80,align:'left',		
			formatter: function(value,row,index){
				var Type  = row["IsActive"];
				if(Type == 1) {
					return $g("是")
				}else {
					return $g("否")
				}	
			}
		},
		{field:'opt',title:'取消对照',width:50,align:'left',
			formatter:function(value,row,index) {
				var MapID = row.MapID;
				/*var btn =  '<img title="取消对照" onclick=UnMap("'+MapID+'") src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png" style="border:0px;cursor:pointer">'   
				return btn;  */
				return "<a href='#' style='white-space:normal;color:#FB7D00' onclick='UnMap(\"" + MapID + "\");'>" + "取消" + "</a>";
			}  
	  }
	]];
	var gridMap= $HUI.datagrid("#gridMap", {
		fit: true,
		title:'已对照科室',
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		rownumbers : true, 
		singleSelect : true,
		pagination : true, 
		autoRowHeight : false,
		loadMsg : '数据加载中...',
		pageSize : 10,
		fitColumns : true,
		url : $URL,
	    queryParams : {
		    ClassName : "CT.IPMR.DPS.LocationMapSrv",
			QueryName : "QryMapLoc",
			aIpmrLocId :LocID
	    },
	    columns : mapColumns
	});
	var Columns = [[
		{field: 'SysDesc', title: '系统名称', width: 80, align: 'left'},
		{field: 'LocCode', title: '科室代码', width: 80, align: 'left'},
		{field: 'LocDesc', title: '科室名称', width: 120, align: 'left'},
		{field:'IsActive',title:'是否有效',width:50,align:'left',
			formatter:function(value,row,index){
				var IsActive	= row.IsActive;
				if (IsActive == '1'){
					return "是";
				} else {
					return "否";
				}
			}
		},
		{field:'opt',title:'对照',width:40,align:'left',
			formatter:function(value,row,index) { 
				var HisLocID = row.LocID;     
                /*var btn =  '<img title="对照" onclick=Map("'+HisLocID+ '","' + LocID +'") src="../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png" style="border:0px;cursor:pointer">'   
				return btn;  */
				return "<a href='#' style='white-space:normal;color:#229A06' onclick='Map(\"" + HisLocID + "\",\"" + LocID + "\");'>" + "对照" + "</a>"; 
			}  
      	}
	]];
	var gridDpLoc= $HUI.datagrid("#gridDpLoc", {
		fit: true,
		title:'外部科室',
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		rownumbers : true, 
		singleSelect : true,
		pagination : true, 
		autoRowHeight : false,
		loadMsg : '数据加载中...',
		pageSize : 10,
		fitColumns : true,
		url : $URL,
	    queryParams : {
		    ClassName : "CT.IPMR.DPS.LocationSrv",
			QueryName : "QryLoc",
			aLocType:'',
			aAdmType:'',
			aKeyword:''
	    },
	    columns : Columns
	});
	var MapDialog = $('#MapDialog').dialog({
	    title: '科室对照-'+LocDesc,
		iconCls: 'icon-w-new',
	    width: 1200,
        height: 560,
	    minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
	    closed: false,
	    cache: false,
	    modal: true
	});
	return;
}

function Map(HisLocID,LocID) {
	var inputStr = '';
	inputStr += '^' + LocID;
	inputStr += '^' + HisLocID;
	var flg = $m({
		ClassName:"CT.IPMR.DP.LocationMap",
		MethodName:"Update",
		aInputStr:inputStr,
		aSeparate:"^"
	},false);
	
	if (parseInt(flg) <= 0) {
		if (parseInt(flg)==-100){
			$.messager.alert("提示", "重复对照!", 'info');
		}else{
			$.messager.alert("错误", "对照失败!", 'error');
		}
		return;
	}
	$("#gridMap").datagrid("reload");

}

function UnMap(MapID) {
	$.messager.confirm('确认', '确认取消对照该条数据?', function(r){
    	if (r){
    		var flg = $m({
				ClassName:"CT.IPMR.DP.LocationMap",
				MethodName:"DeleteById",
				aId:MapID
			},false);
			
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误", "取消对照失败!", 'error');
				return;
			}
			$("#gridMap").datagrid("reload");
    	}
    });
}