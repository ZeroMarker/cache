/**
 * dataitemmap 编目数据项对照
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
	m_gridMap:''
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
})

function Init(){
	Common_ComboToDic('cboDFrontPageType','FrontPageType',1,'');
	Common_ComboToDic('cboGFrontPageType','FrontPageType',1,'');
	InitgridDataItem();
	InitgridGlossary();
	globalObj.m_gridMap = InitgridMap();
}

function InitEvent(){
	$('#cboDFrontPageType').combobox({
			onSelect: function () {
				$("#gridDataItem").datagrid("reload", {
					ClassName:"CT.IPMR.FPS.DataItemSrv",
					QueryName:"QueryDataItem",
					aFPTypeID:$("#cboDFrontPageType").combobox('getValue'),
					aAlias:$('#txtDataItemAlias').val(),
					aMapped:($('#chkDataItemNoMapped').checkbox('getValue')==true?'0':'')
				})
			  	$('#gridDataItem').datagrid('unselectAll');
			}
		}
	);
	$('#cboGFrontPageType').combobox({
			onSelect: function () {
				$("#gridGlossary").datagrid("reload", {
					ClassName:"CT.IPMR.BTS.GlossarySrv",
					QueryName:"QueryGlossary",
					aFPTypeID:$("#cboGFrontPageType").combobox('getValue'),
					aAlias:$('#txtGlossaryAlias').val()
				})
			  	$('#gridGlossary').datagrid('unselectAll');
			}
		}
	);
	$('#DataItemSearch').click(function(e){
        DataItemSearch();
    });
    /*
    $('#DataItemRefresh').click(function(e){
        DataItemRefresh();
    });
    */
    $('#txtDataItemAlias').keyup(function(e){
       DataItemEnter();
    });

    $('#GlossarySearch').click(function(e){
        GlossarySearch();
    });
    /*
    $('#GlossaryRefresh').click(function(e){
        GlossaryRefresh();
    });
    */
    $('#txtGlossaryAlias').keyup(function(e){
       GlossaryEnter();
    });
	
	 $('#AutoContrast').click(function(e){
        AutoContrast();
    });
    
    $HUI.checkbox("#chkDataItemNoMapped", {
		onCheckChange: function(e,value){
			DataItemSearch();
		}
	});
}
 /**
 * NUMS: D001
 * CTOR: LIYI
 * DESC: 编目数据项模块
 * DATE: 2019-09-29
 * NOTE: 包括四个方法：InitgridDataItem,DataItemSearch,DataItemRefresh,DataItemEnter
 * TABLE: CT.IPMR.FP.DataItem
 */

 // 初始化编目数据项表格
function InitgridDataItem(){
	
	var columns = [[
		{field:'Code',title:'代码',width:150,align:'left'},
		{field:'Desc',title:'名称',width:200,align:'left'},
		{field:'FPTypeID',title:'FPTypeID',hidden:true},
		{field:'ID',title:'ID',hidden:true,order:'asc'}
    ]];
	var gridDataItem =$HUI.datagrid("#gridDataItem",{
		fit: true,
		title: "编目数据项",
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
		    ClassName:"CT.IPMR.FPS.DataItemSrv",
			QueryName:"QueryDataItem",
			aFPTypeID:'-1',
			aAlias:'',
			aMapped:''
	    },
	    columns :columns,
	    onClickRow:function(rowIndex,rowData){
			if (rowIndex>-1) { 
				InitgridMap(rowData.FPTypeID,rowData.Code)
			}
		}
	});
	return gridDataItem;
}
// 搜索事件
function DataItemSearch(){
	$("#gridDataItem").datagrid("reload", {
		ClassName:"CT.IPMR.FPS.DataItemSrv",
		QueryName:"QueryDataItem",
		aFPTypeID:$("#cboDFrontPageType").combobox('getValue'),
		aAlias:$('#txtDataItemAlias').val(),
		aMapped:($('#chkDataItemNoMapped').checkbox('getValue')==true?'0':'')
	})
  	$('#gridDataItem').datagrid('unselectAll');
  }
// 清屏事件
function DataItemRefresh(){
	$('#txtDataItemAlias').val('');
	$("#gridDataItem").datagrid("reload", {
		ClassName:"CT.IPMR.FPS.DataItemSrv",
		QueryName:"QueryDataItem",
		aFPTypeID:'',
		aAlias:''
	})
  	$('#gridDataItem').datagrid('unselectAll');
}
// 输入框回车事件
function DataItemEnter(){
	 if(event.keyCode == 13) {
          DataItemSearch();
     }
}
 

/**
 * NUMS: D002
 * CTOR: LIYI
 * DESC: 术语集模块
 * DATE: 2019-09-29
 * NOTE: 包括四个方法：InitgridGlossary,GlossarySearch,GlossaryRefresh,GlossaryEnter,contrast,AutoContrast
 * TABLE: CT.IPMR.BT.Glossary
 */

// 初始化术语集表格
function InitgridGlossary(){
	var columns = [[
		{field:'FPTypeDesc',title:'首页类型',width:80,align:'left'},
		{field:'Code',title:'代码',width:120,align:'left'},
		{field:'Desc',title:'名称',width:200,align:'left'},
		{field:'MapInfo',title:'已对照信息',width:200,align:'left',
			formatter:function(value,row,index){
				if (row.MapDataItemCode!='') {
					return row.MapDataItemCode+' '+row.MapDataItemDesc;
				}else{
					return '';
				}
			}
      	},
		{field:'opt',title:'操作',width:50,align:'left',
			formatter:function(){  
                /*var btn =  '<img title="对照" onclick="contrast()" src="../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png" style="border:0px;cursor:pointer">'   
				return btn;*/
				return "<a href='#' style='white-space:normal;color:#229A06' onclick='contrast();'>" + "对照" + "</a>";
			}  
      	},
		{field:'ID',title:'ID',hidden:true,order:'asc'}
    ]];
	var gridGlossary =$HUI.datagrid("#gridGlossary",{
		fit: true,
		title: "术语集",
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
		    ClassName:"CT.IPMR.BTS.GlossarySrv",
			QueryName:"QueryGlossary",
			aFPTypeID:'-1',
			aAlias:'',
			aIsActive:'1'
	    },
	    columns :columns
	});
	return gridGlossary;
}

// 搜索事件
function GlossarySearch(){
	$("#gridGlossary").datagrid("reload", {
		ClassName:"CT.IPMR.BTS.GlossarySrv",
		QueryName:"QueryGlossary",
		aFPTypeID:$("#cboGFrontPageType").combobox('getValue'),
		aAlias:$('#txtGlossaryAlias').val(),
		aIsActive:'1'
	})
  	$('#gridGlossary').datagrid('unselectAll');
  }
// 清屏事件
function GlossaryRefresh(){
	$('#txtGlossaryAlias').val('');
	$("#gridGlossary").datagrid("reload", {
		ClassName:"CT.IPMR.BTS.GlossarySrv",
		QueryName:"QueryGlossary",
		aFPTypeID:'',
		aAlias:'',
		aIsActive:'1'
	})
  	$('#gridGlossary').datagrid('unselectAll');
}
// 输入框回车事件
function GlossaryEnter(){
	 if(event.keyCode == 13) {
          GlossarySearch();
     }
}
// 对照事件
function contrast(){
	setTimeout(function(){
		var DataItemRecord = $('#gridDataItem').datagrid('getSelected');
		var GlossaryRecord = $('#gridGlossary').datagrid('getSelected');
		if(!DataItemRecord)
		{
			$.messager.popover({msg: '请选择需要对照的编目数据项！',type: 'alert',timeout: 1000});
	    	return;
		}
		var inputStr = '';
		inputStr += '^' + GlossaryRecord.ID;
		inputStr += '^' + DataItemRecord.ID;
		var flg = $m({
			ClassName:"CT.IPMR.FP.DataItemMap",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparate:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg)==-100){
				$.messager.alert("提示", "该术语集已对照编目数据项!", 'info');
			}else{
				$.messager.alert("错误", "对照失败!", 'error');
			}
			return;
		}else{
			$.messager.popover({msg: '对照成功！',type: 'success',timeout: 1000});
		}
		$("#gridMap").datagrid("reload");
	},100)
	/*
	$("#gridMap").datagrid("reload", {
		ClassName:"CT.IPMR.FPS.DataItemMapSrv",
		QueryName:"QueryMapGlossary",
		aFPTypeID: DataItemRecord.FPTypeID,
		aDataItemCode:GlossaryRecord.Code
	})
	*/
}

// 自动对照
function AutoContrast(){
	$m({
		ClassName:"CT.IPMR.FPS.DataItemMapSrv",
		MethodName:"AutoContrast"
	},function(txtData){
		if (txtData =='OK') {
			$.messager.popover({msg: '自动对照完成！',type: 'success',timeout:2000});
		}
	});
}
/**
 * NUMS: D003
 * CTOR: LIYI
 * DESC: 已对照模块
 * DATE: 2019-09-29
 * NOTE: 包括四个方法：InitgridMap,delContrast
 * TABLE: CT.IPMR.FP.DataItemMap
 */

 // 初始化已对照表格
function InitgridMap(FPTypeID,Code){
	if (globalObj.m_gridMap) {
		$("#gridMap").datagrid("reload", {
			ClassName:"CT.IPMR.FPS.DataItemMapSrv",
			QueryName:"QueryMapGlossary",
			aFPTypeID: FPTypeID,
			aDataItemCode:Code
		})
		return;
	}
	var columns = [[
		{field:'BGFPTypeDesc',title:'首页类型',width:120,align:'left'},
		{field:'BGCode',title:'代码',width:150,align:'left'},
		{field:'BGDesc',title:'名称',width:200,align:'left'},
		{field:'opt',title:'操作',width:50,align:'left',
				formatter:function(){
	                /*var btn =  '<img title="取消对照" onclick="delContrast()" src="../scripts_lib/hisui-0.1.0/dist/css/icons/compare_no.png" style="border:0px;cursor:pointer">'   
					return btn;*/
					return "<a href='#' style='white-space:normal;color:#FB7D00' onclick='delContrast();'>" + "取消对照" + "</a>";
				}  
	      },
		{field:'MapID',title:'MapID',hidden:true,order:'asc'}
    ]];
	var gridMap =$HUI.datagrid("#gridMap",{
		fit: true,
		title: "已对照术语集",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 10,
		toolbar: [],
		fitColumns:true,
	    url:$URL,
	    queryParams:{
		    ClassName:"CT.IPMR.FPS.DataItemMapSrv",
			QueryName:"QueryMapGlossary",
			aFPTypeID:'',
			aDataItemCode:''
	    },
	    columns :columns
	});
	return gridMap;
}

// 取消对照事件
function delContrast(){
	setTimeout(function(){
		var MapRecord = $('#gridMap').datagrid('getSelected');
		var flg = $m({
			ClassName:"CT.IPMR.FP.DataItemMap",
			MethodName:"DeleteById",
			aId:MapRecord.MapID
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