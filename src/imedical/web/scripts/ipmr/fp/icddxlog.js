/**
 * icddxlog ICD修改日志
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
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
})

function Init(){
	Common_ComboToICDVer('cboICDVer');
	InitgridICDlog();

}

function InitEvent(){
	$('#btnQry').click(function(){QryLog()});
}
 /**
 * NUMS: D001
 * CTOR: LIYI
 * DESC: ICD修改日志
 * DATE: 2019-09-29
 * NOTE: 包括方法：InitgridICDlog,QryLog
 * TABLE: CT.IPMR.FP.ICDDxlog
 */

 // 初始化表格
function InitgridICDlog(){
	var columns = [[
		{field:'ICDVerDesc',title:'版本',width:150,align:'left'},
		{field:'OperTypeDesc',title:'维护类型',width:100,align:'left'},
		{field:'UpdateDate',title:'日期',width:100,align:'left'},
		{field:'UpdateTime',title:'时间',width:100,align:'left'},
		{field:'UpdateUser',title:'操作人',width:100,align:'left'},	
		{field:'IpAddress',title:'操作IP',width:100,align:'left'},
		{field:'Resume',title:'备注',width:200,align:'left'},
		{field:'tmp',title:'变动明细',width:100,align:'left',
			formatter:function(value,row,index) {
            	var ID = row.ID;
               	return '<a href="#" class="grid-td-text-gray" onclick = showDetail(' + ID + ')>' + '变动明细' + '</a>';            
            }
		}
    ]];
	var gridICDlog =$HUI.datagrid("#gridICDlog",{
		fit: true,
		//title: "ICD修改日志",
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
		    ClassName:"CT.IPMR.FPS.ICDDxLogSrv",
			QueryName:"QryICDLog",
			aICDDxID:'',
			aDateFrom:'',
			aDateTo:'',
			aVerID:'',
			aOperType:''
	    },
	    columns :columns
	});
	return gridICDlog;
}

function QryLog()
{
	var datefrom	= $('#dfDateFrom').datebox('getValue');	//获取日期控件的值
	var dateto		= $('#dfDateTo').datebox('getValue');		//获取日期控件的值
	var ICDVer		= $("#cboICDVer").combobox('getValue');
	var OperType	= $("#cboOperType").combobox('getValue');
	if (datefrom=='') {
		$.messager.popover({msg: '请选择开始日期！',type: 'alert',timeout: 1000});
		return false;
	}
	if (dateto=='') {
		$.messager.popover({msg: '请选择结束日期！',type: 'alert',timeout: 1000});
		return false;
	}
	$('#gridICDlog').datagrid('reload',  {
		ClassName:"CT.IPMR.FPS.ICDDxLogSrv",
		QueryName:"QryICDLog",
		aICDDxID:'',
		aDateFrom:datefrom,
		aDateTo:dateto,
		aVerID:ICDVer,
		aOperType:OperType
	});
	$('#gridICDlog').datagrid('unselectAll');
}

function showDetail(id) {
	var columns = [[
		{field: 'Property', title: '属性', width: 80, align: 'left'},
		{field: 'oldValue', title: '修改前', width: 80, align: 'left'},
		{field: 'newValue', title: '修改后', width: 80, align: 'left',
			styler: function(value,row,index){
				var changeflg	= row.changeflg;
				if (changeflg==1){
					return 'background-color:pink;';
				}
			}
		}
	]];
	var gridLogDetail = $HUI.datagrid("#gridLogDetail", {
		fit: true,
		headerCls:'panel-header-gray',
		iconCls:'icon-write-order',
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 100,
		fitColumns:true,
	    url:$URL,
	    queryParams : {
		    ClassName : "CT.IPMR.FPS.ICDDxLogSrv",
			QueryName : "QryICDLogDetail",
			aLogID : id
	    },
	    columns : columns
	});
	var ICDLogDetailDialog = $('#ICDLogDetailDialog').dialog({
	    title: 'ICD变动明细',
		iconCls: 'icon-w-new',
	    width: 800,
	    height: 560,
	    minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
	    closed: false,
	    cache: false,
	    modal: true
	});
    return ICDLogDetailDialog;
}