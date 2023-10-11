var PageLogicObj={
	m_PatEpiosdeListDataGrid:"",
	NewPatientID:""
}
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
})
function Init(){
	InitPatInfoBanner("",ServerObj.PatientID);
	PageLogicObj.m_PatEpiosdeListDataGrid=InitPatEpiosdeListDataGrid();
	$HUI.datebox("#StartDate").setValue(ServerObj.StartDate);
	$HUI.datebox("#EndDate").setValue(ServerObj.EndDate);	
	
	}
	
function InitEvent(){
	$("#BFind").click(CardToSaveTabDataGridLoad);
	}
function PageHandle(){
	CardToSaveTabDataGridLoad();
	}
function InitPatEpiosdeListDataGrid(){
	if (ServerObj.Code==""){
		var Columns=[[ 
			{field:'EpisodeID',hidden:true,title:''},
			{field:'Date',title:'就诊日期',width:110},
			{field:'LocID',title:'就诊科室',width:150},
			{field:'DocID',title:'主管/就诊医生',width:150},
			{field:'Arcim',title:'项目',width:405},
			{field:'ODate',title:'医嘱日期',width:110},
			{field:'Amount',title:'单价',width:100}
	    ]]
	}else{
		var Columns=[[ 
			{field:'EpisodeID',hidden:true,title:''},
			{field:'Date',title:'就诊日期',width:120},
			{field:'LocID',title:'就诊科室',width:460},
			{field:'DocID',title:'主管/就诊医生',width:465}
			
	    ]]
	}
	var PatCardListTabDataGrid=$("#PatEpiosdeListTab").datagrid({
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
		idField:'TPatientID',
		columns :Columns,
		onSelect:function(index, row){
		},
		onRowContextMenu:function(e, index, row){
			
		}
	});
	PatCardListTabDataGrid.datagrid('loadData', { total: 0, rows: [] });  
	return PatCardListTabDataGrid;
	}
function CardToSaveTabDataGridLoad(){
	var StartDate=$HUI.datebox("#StartDate").getValue();
	if (StartDate=="") StartDate=ServerObj.StartDate
	var EndDate=$HUI.datebox("#EndDate").getValue();
	if (EndDate=="") EndDate=ServerObj.EndDate
	var AdmRecorder=""
	if ($HUI.checkbox("#AdmRecorder").getValue()==true){AdmRecorder="1"}
	$.q({
	    ClassName : "web.DHCPATCardUnite",
	    QueryName : "QueryFeeNew",
	    Code : ServerObj.Code,
	    PatientID : ServerObj.PatientID,
	    StartDate:StartDate,
	    EndDate:EndDate,
	    AdmRecorder:AdmRecorder,
	    Pagerows:PageLogicObj.m_PatEpiosdeListDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_PatEpiosdeListDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}
