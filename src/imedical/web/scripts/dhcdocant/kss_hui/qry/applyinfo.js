/**
 * log.js 数据同步日志
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2019-07-16
 * 
 * 
 */
var PageLogicObj = {
	m_DateType: '',
	m_Grid: ''
	
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
	PageLogicObj.m_DateType = $HUI.combobox("#i-dataType", {
		url:$URL+"?ClassName=DHCFPM.Common.LogExcute&QueryName=QryDatatType&ResultSetType=array",
		valueField:'id',
		textField:'text',
		blurValidValue:true
	});
	PageLogicObj.m_Grid = InitGrid();
}

function InitEvent () {
	$("#i-search").click(findConfig);
}
function InitGrid(){
	var columns = [[
		{field:'dataType',title:'数据类型',width:80},
		{field:'actionType',title:'操作类型',width:60},
		{field:'logDate',title:'日期',width:80},
		{field:'logContent',title:'内容',width:250,
			formatter:function(value,row,index){
				var subContent = "";
				if (value!="") {
					if (value.length>30){
						subContent = value.substring(0,30)+"..."
					} else {
						subContent = value;
					}
				}
				return '<a style="color:#000;" title2="'+value+'" class="hisui-tooltip" onmouseover="ShowDetail(this)">'+subContent+'</a>';
			}
		},
		{field:'logResult',title:'更新结果',width:60,
			formatter:function(value,row,index){
				if (value == "成功") {
					return "<span class='c-ok'>成功</span>";
				} else {
					return "<span class='c-no'>失败</span>";
				}
			}
		},
		{field:'logTable',title:'数据结构',width:150},
		{field:'logTableDr',title:'项目ID',width:50},
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
			ClassName : "DHCFPM.Common.LogExcute",
			QueryName : "QryLog",
			findDate: '',
			inDataType: ''
		},
		//idField:'Rowid',
		columns :columns
	});
	
	return DataGrid;
}

function findConfig () {
	var findDate = $("#i-findDate").datebox("getValue")||"";
	var dataType = PageLogicObj.m_DateType.getValue()||"";
	PageLogicObj.m_Grid.reload({
		ClassName : "DHCFPM.Common.LogExcute",
		QueryName : "QryLog",
		findDate: findDate,
		inDataType: dataType

	});
}

function ShowDetail (that) {
	var _width = $(that).parent().width();
	$(that).popover({
		content:$(that).attr("title2"),
		trigger:'hover',
		placement:'top',
		animated:'fade',
		//style:'inverse',
		width:_width
	})
	$(that).popover("show");
	/*
		//$(that).tooltip({position:'bottom',width:_width}).tooltip('show');
		$(that).webuiPopover({
			title:'',
			content:222,
			trigger:'hover',
			placement:"bottom",
			//style:'inverse',
			height:50
			
		});
		$(that).webuiPopover('show');
	*/
}

	
