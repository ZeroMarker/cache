var PageLogicObj={
	m_PilotProDeptSetTabDataGrid:""
};
$(function(){
	//页面数据初始化
	Init();
	//事件初始化
	InitEvent();
	PilotProDeptSetTabDataGridLoad();
});
function InitEvent(){
	$("#BFind").click(PilotProDeptSetTabDataGridLoad);
	$("#BSave").click(SaveClickHandle);
}
function SaveClickHandle(){
	var data=PageLogicObj.m_PilotProDeptSetTabDataGrid.datagrid('getData');
	for (var i=0;i<data.rows.length;i++){
		var editors = PageLogicObj.m_PilotProDeptSetTabDataGrid.datagrid('getEditors', i); 
		var selected=editors[0].target.is(':checked');
		if(selected) Flag="1";
		else Flag="0";
		var rtn=$.cm({
			ClassName:"web.PilotProject.DHCDocPPGroupSeting",
			MethodName:"SaveConfig",
			Node:"DeptApprove", 
			Node1:data.rows[i]["rowid"], 
			NodeValue:Flag
		},false);
		if (rtn!=0) {
			$.messager.alert("提示",data.rows[i]["Desc"]+",保存不成功!");
		}
	}
	PilotProDeptSetTabDataGridLoad();
	$.messager.alert("提示","保存成功!");
}
function Init(){
	PageLogicObj.m_PilotProDeptSetTabDataGrid=InitPilotProDeptSetTabDataGrid();
}
function InitPilotProDeptSetTabDataGrid(){
	var Columns=[[ 
		{field:'IfApprove',title:'药监局批准',width:100,align:'center',editor : {
                type : 'icheckbox',
                options : {
                    on : '1',
                    off : ''
                }
           }
         },
		{field:'Desc',title:'科室',width:300},
		{field:'Code',title:'',hidden:true},
		{field:'rowid',title:'',hidden:true},
		{field:'Alias',title:'',hidden:true},
		
    ]]
	var PilotProDeptSetTabDataGrid=$("#PilotProDeptSetTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'rowid',
		columns :Columns,
		onLoadSuccess:function(data){
			for (var i=0;i<data.rows.length;i++){
				PageLogicObj.m_PilotProDeptSetTabDataGrid.datagrid('beginEdit',i);
			}
		}
	}); 
	return PilotProDeptSetTabDataGrid;
}
function PilotProDeptSetTabDataGridLoad(){
	var Loc=$("#Loc").val();
	$.q({
	    ClassName : "web.PilotProject.DHCDocPPGroupSeting",
	    QueryName : "LookUpAllLoc",
	    Loc : Loc,
	    Pagerows:PageLogicObj.m_PilotProDeptSetTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_PilotProDeptSetTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}