/**
 * log.js ����ͬ����־
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
	//��ʼ��
	Init();
	
	//�¼���ʼ��
	InitEvent();
	
	//ҳ��Ԫ�س�ʼ��
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
		{field:'dataType',title:'��������',width:80},
		{field:'actionType',title:'��������',width:60},
		{field:'logDate',title:'����',width:80},
		{field:'logContent',title:'����',width:250,
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
		{field:'logResult',title:'���½��',width:60,
			formatter:function(value,row,index){
				if (value == "�ɹ�") {
					return "<span class='c-ok'>�ɹ�</span>";
				} else {
					return "<span class='c-no'>ʧ��</span>";
				}
			}
		},
		{field:'logTable',title:'���ݽṹ',width:150},
		{field:'logTableDr',title:'��ĿID',width:50},
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

	
