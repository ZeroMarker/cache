/**
 * locgroup 科室组维护
 * 
 * 
 * CREATED BY zhouyang 2019-10-22
 * 
 * 注解说明
 * TABLE: CT.IPMR.BT.LocGroup
 */
 
 
 var globalObj = {
	m_gridLocGroup 			: '' ,   				//科室分组
	m_gridLocItem  			: '' ,  				//科室列表
	m_gridLocGroupMap 		: '' , 					//科室对照
	m_HospID 				: Logon.HospID,	//医院ID
	m_HospDesc				: Logon.HospDesc,	//医院描述
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
})

function Init(){
	ComboboxToType('GroupType');
	ComboboxToType('ItemType');
	Common_ComboToHosp('ItemHosp','',Logon.HospID);
	//Common_ComboToDicCode("ItemAdmType","AdmType",1,"");
	globalObj.m_gridLocGroup 	= InitGridLocGroup();
	globalObj.m_gridLocItem  	= InitGridLocItem();
	globalObj.m_gridLocGroupMap = InitGridLocMap();
}

function InitEvent(){
	$('#ItemSearch').click(function(){LocItemSearch();})
	$("#ItemKeyword").keydown(function(){if(event.keyCode == 13){LocItemSearch();}});
	//$("#ItemType").combobox({onSelect: function () {LocItemSearch();}})
	$('#GroupSearch').click(function(){LocGroupSearch();})	
	$("#GroupKeyword").keydown(function(){if(event.keyCode == 13){LocGroupSearch();}});
	//$("#GroupType").combobox({onSelect: function () {LocGroupSearch();}})
}

//初始化科室组类型下拉框
function ComboboxToType(){
	var ItemCode = arguments[0];
    var cbox = $HUI.combobox("#"+ItemCode, {
		textField : 'text',
		valueField : 'value',
		panelHeight : 'auto',
		data : [
	        {'text' : '科室', 'value' : 'E'},
	        {'text' : '病区', 'value' : 'W'},
		],
	})
	return  cbox;
}
 /**
 * NUMS: 001
 * CTOR: zhouyang
 * DESC: 科室分组表
 * DATE: 2019-10-25
 * NOTE: 
 * TABLE: CT.IPMR.BT.LocGroup
 */
 
 
 //初始化科室组
function InitGridLocGroup(){
	var columns = [[
		{field:'Code',title:'代码',width:120,align:'left'},
		{field:'Desc',title:'科室组',width:120,align:'left'},
		{field:'Type',title:'类型',width:120,align:'left',		
			formatter: function(value,row,index){
				var Type  = row["Type"];
				if(Type == "E") {
					return "科室"
				}else if(Type == "W"){
					return "病区"
				}else 				{
					return "其他"
				}	
			}
		},
		/*
		{field:'IsActive',title:'是否有效',width:100,align:'left',		
			formatter: function(value,row,index){
				var Type  = row["IsActive"];
				if(Type == 1) {
					return "是"
				}else {
					return "否"
				}	
			}
		},
		*/
		{field:'ID',title:'ID',hidden:true,order:'asc'}
    ]];
	var gridLocGroup =$HUI.datagrid("#gridGroup",{
		fit: true,
		title:"科室组",
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
		    ClassName:"MA.IPMR.BTS.LocGroupSrv",
			QueryName:"QueryLocGroup",
			aKeyword: "",
			aType :"",
			aAddItem:'',
			aIsActive:'1'
	    },
	    columns :columns,
		onClickRow:function(rowIndex,rowData){
			if(rowIndex>-1)
			{
				InitGridLocMap(rowData.ID) 
			}	
		}
	});
	return gridLocGroup;
}
// 科室组查询
function LocGroupSearch()
{
	$("#gridGroup").datagrid("reload", {
	    ClassName:"MA.IPMR.BTS.LocGroupSrv",
		QueryName:"QueryLocGroup",
		aKeyword: $('#GroupKeyword').val(),
		aType :$('#GroupType').combobox('getValue')
	})
  	$('#gridGroup').datagrid('unselectAll');
}



 /**
 * NUMS: 002
 * CTOR: zhouyang
 * DESC: 科室列表
 * DATE: 2019-10-25
 * NOTE: 
 * TABLE: CT.IPMR.BT.Location
 */
function InitGridLocItem()
{
	var columns = [[
		{field:'Code',title:'代码',width:150,align:'left'},
		{field:'Desc',title:'科室名称',width:200,align:'left'},
		{field:'Desc2',title:'别名',width:200,align:'left'},
		{field:'LocType',title:'科室类型',width:100,align:'left',		
			formatter: function(value,row,index){
				var Type  = row["LocType"];
				if(Type == "E") {
					return $g("科室")
				}else if(Type == "W"){
					return $g("病区")
				}else{
					return $g("其他")
				}	
			}
		},
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
		{field:'Operate',title:'操作',width:50,align:'left',
			formatter:function(){  
                /*var btn =  '<img title="对照" onclick="associate()" src="../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png" style="border:0px;cursor:pointer">'   
				return btn; */
				return "<a href='#' style='white-space:normal;color:#229A06' onclick='associate();'>" + "对照" + "</a>";
			}  
      	},
		{field:'ID',title:'ID',hidden:true,order:'asc'}
    ]];
	var gridLocItem =$HUI.datagrid("#gridItem",{
		fit: true,
		title:"科室列表",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		fitColumns:true,
	    url:$URL,
	    queryParams:{
		    ClassName	:"MA.IPMR.BTS.LocationSrv",
			QueryName	:"QryLoc",
			aLocGroup 	:"",
			aLocType 	:"",
			aAdmType 	:"",
			aHospId 	:"",
			//aLocType, aAdmType,  aKeyword= ""
	    },
	    columns :columns,
		onClickRow:function(rowIndex,rowData){	
		},
		onLoadSuccess:function(data){
		}
	});
	return gridLocItem;
}
// 科室列表查询
function LocItemSearch()
{
	$("#gridItem").datagrid("reload", {
	    ClassName :	"MA.IPMR.BTS.LocationSrv",
		QueryName :	"QryLoc",
		aKeyword  :	$('#ItemKeyword').val(),
		aLocType  :	$('#ItemType').combobox('getValue'),
		aLocGroup :	"",
		aHospId   :	$('#ItemHosp').combobox('getValue'),
		aAdmType  : ""
		//aAdmType  :	$('#ItemAdmType').combobox('getValue'),
	})
  	$('#gridItem').datagrid('unselectAll');
}

//分组与科室对照
function associate()
{
	setTimeout(function(){
		var rowLocGroup = $('#gridGroup').datagrid('getSelected');
		var rowLocItem = $('#gridItem').datagrid('getSelected');

		if(!rowLocGroup)
		{
			$.messager.popover({msg: '请选择需要对照的科室组！',type: 'alert',timeout: 1000});
	    	return;
		}
		var flg = $m({
			ClassName:"MA.IPMR.BT.LocGroupMap",
			MethodName:"Insert",
			aLocGroupDr:rowLocGroup.ID,
			aLocDr:rowLocItem.ID
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg)==-100){
				$.messager.alert("提示", "已对照该科室!", 'info');
			}else{
				$.messager.alert("错误", "对照失败!", 'error');
			}
			return;
		}else{
			$.messager.popover({msg: '对照成功！',type: 'success',timeout: 1000});
		}
		$("#gridMap").datagrid("reload");
	},100)
}




/**
 * NUMS: 003
 * CTOR: zhouyang
 * DESC: 科室对照表
 * DATE: 2019-10-25
 * NOTE: 
 * TABLE: MA.IPMR.BT.LocGroupMap
 */

 // 初始化已对照科室
function InitGridLocMap(lg){
	if (globalObj.m_gridLocGroupMap) {
		$("#gridMap").datagrid("reload", {
			ClassName:"MA.IPMR.BTS.LocGroupMapSrv",
			QueryName:"QueryLocGroupMap",
			aLocGroupDr: lg,
		})
		return;
	}
	var columns = [[
		{field:'opt',title:'操作',width:120,align:'left',
				formatter:function(){
	                /*var btn =  '<img title="取消对照" onclick="delAssociate()" src="../scripts_lib/hisui-0.1.0/dist/css/icons/compare_no.png" style="border:0px;cursor:pointer">'   
					return btn;*/
					return "<a href='#' style='white-space:normal;color:#FB7D00' onclick='delAssociate();'>" + "取消对照" + "</a>";
				}  
	    },
		{field:'Code',title:'代码',width:100,align:'left'},
		{field:'Desc',title:'科室名称',width:250,align:'left'},
		{field:'Type',title:'科室类型',width:100,align:'left',		
			formatter: function(value,row,index){
				var Type  = row["Type"];
				if(Type == "E") {
					return $g("科室")
				}else if(Type == "W"){
					return $g("病区")
				}else{
					return $g("其他")
				}	
			}
		},
		{field:'IsActive',title:'科室是否有效',width:120,align:'left'},
		{field:'ID',title:'ID',hidden:true,order:'asc'}
    ]];
	var gridMap =$HUI.datagrid("#gridMap",{
		fit: true,
		title: "已对照科室",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 10,
		fitColumns:false,
		toolbar: [],
	    url:$URL,
	    queryParams:{
			ClassName:"MA.IPMR.BTS.LocGroupMapSrv",
			QueryName:"QueryLocGroupMap",
			aLocGroupDr: lg,
	    },
	    columns :columns
	});
	return gridMap;
}

// 取消对照事件
function delAssociate(){
	setTimeout(function(){
		var Map = $('#gridMap').datagrid('getSelected');
		var flg = $m({
			ClassName:"MA.IPMR.BT.LocGroupMap",
			MethodName:"DeleteById",
			aId:Map.ID
		},false);
		if (parseInt(flg) <= 0) {
			$.messager.alert("错误", "取消对照失败!", 'error');
			return;
		}else{
			$.messager.popover({msg: '取消对照成功！',type: 'success',timeout: 1000});
		}
		$("#gridMap").datagrid("reload");
	},100)
}