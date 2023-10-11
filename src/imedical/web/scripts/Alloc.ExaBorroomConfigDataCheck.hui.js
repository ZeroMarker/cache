var PageLogicObj={
	m_ExaBorRoomConfDataCheckTabDataGrid:""
};
$(function(){
	var hospComp = GenUserHospComp();
	hospComp.jdata.options.onSelect = function(e,t){
		ExaBorRoomConfDataCheckTabDataGridLoad();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		//初始化
		Init();
		//表格数据初始化
		ExaBorRoomConfDataCheckTabDataGridLoad();
	}
	
});
function Init(){
	PageLogicObj.m_ExaBorRoomConfDataCheckTabDataGrid=InitExaBorRoomConfDataCheckTabDataGrid();
}
function InitExaBorRoomConfDataCheckTabDataGrid(){
	var toobar=[{
        text: '导出',
        iconCls: 'icon-export',
        handler: function() {ExportExcel();}
    }];
	var Columns=[[ 
		{field:'desc',title:'监测项目',width:200},
		{field:'chkMsg',title:'监测结果',width:300}
    ]]
	var ExaBorRoomConfDataCheckTabDataGrid=$("#ExaBorRoomConfDataCheckTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 15,
		pageList : [15,100,200],
		idField:'index',
		columns :Columns,
		toolbar:toobar
	});
	return ExaBorRoomConfDataCheckTabDataGrid;
}
function ExaBorRoomConfDataCheckTabDataGridLoad(){
	$.q({
	    ClassName : "web.DHCDocRegConfigDataCheck",
	    QueryName : "ExaBorRoomConfigDataCheck",
	    HospID:$HUI.combogrid('#_HospUserList').getValue(),
	    Pagerows:PageLogicObj.m_ExaBorRoomConfDataCheckTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_ExaBorRoomConfDataCheckTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	});
}
function ExportExcel(){
	var rtn = $cm({
		dataType:'text',
		ResultSetType:'Excel',
		ExcelName:'诊区诊室监测明细',
		ClassName:'web.DHCDocRegConfigDataCheck',
		QueryName:'ExaBorRoomConfigDataCheck',
		HospID:$HUI.combogrid('#_HospUserList').getValue()
	}, false);
	if(typeof websys_writeMWToken=='function') rtn=websys_writeMWToken(rtn);
	location.href = rtn;
}

