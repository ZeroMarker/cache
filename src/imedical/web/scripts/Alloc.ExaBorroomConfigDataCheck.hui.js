var PageLogicObj={
	m_ExaBorRoomConfDataCheckTabDataGrid:""
};
$(function(){
	var hospComp = GenUserHospComp();
	hospComp.jdata.options.onSelect = function(e,t){
		ExaBorRoomConfDataCheckTabDataGridLoad();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		//��ʼ��
		Init();
		//������ݳ�ʼ��
		ExaBorRoomConfDataCheckTabDataGridLoad();
	}
	
});
function Init(){
	PageLogicObj.m_ExaBorRoomConfDataCheckTabDataGrid=InitExaBorRoomConfDataCheckTabDataGrid();
}
function InitExaBorRoomConfDataCheckTabDataGrid(){
	var toobar=[{
        text: '����',
        iconCls: 'icon-export',
        handler: function() {ExportExcel();}
    }];
	var Columns=[[ 
		{field:'desc',title:'�����Ŀ',width:200},
		{field:'chkMsg',title:'�����',width:300}
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
		ExcelName:'�������Ҽ����ϸ',
		ClassName:'web.DHCDocRegConfigDataCheck',
		QueryName:'ExaBorRoomConfigDataCheck',
		HospID:$HUI.combogrid('#_HospUserList').getValue()
	}, false);
	if(typeof websys_writeMWToken=='function') rtn=websys_writeMWToken(rtn);
	location.href = rtn;
}

