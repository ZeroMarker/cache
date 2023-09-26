var CureTriageListDataGrid;
$(document).ready(function(){
	Init();
	InitEvent();
});

function Init(){
	InitCureTriageListDataGrid();	
}

function InitEvent(){
	$('#btnSearch').bind("click",function(){
		LoadCureTriageListDataGrid();	
	})
	$('#btnCancel').bind("click",function(){
		BtnCancelClick();	
	})	
}

function InitCureTriageListDataGrid()
{
	var cureToolBar = [{
	}];
	// 治疗申请单预约记录Grid
	CureTriageListDataGrid=$('#tabCureTriageList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : true,
		//scrollbarSize : '40px',
		//url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"Rowid",
		pageSize : 5,
		pageList : [5,15,50,100],
		columns :[[   
        			{field:'Rowid',title:'',width:1,hidden:true}, 
        			{field:'PatientNo',title:'登记号',width:80,align:'center'},   
        			{field:'PatientName',title:'姓名',width:60,align:'center'},
        			{field:'ArcimDesc',title:'治疗项目',width:200,align:'center'},
        			{field:'DDCTRCTLoc',title:'科室',width:100,align:'center'},  
        			{field:'DDCTRCTPCP',title:'资源',width:60,align:'center'},
        			{field:'DDCTRStatus',title:'状态',width:50,align:'center'},
        			{field:'DDCTRUser',title:'操作人',width:60,align:'center'},
        			{field:'DDCTRDate',title:'操作时间',width:100,align:'center'}
       			 ]] ,
	});
	LoadCureTriageListDataGrid();
}
function LoadCureTriageListDataGrid()
{
	var DCARowIdStr=$('#DCARowIdStr').val();
	var DDCTRIRowID=$('#DDCTRIRowID').val();
	var CheckCancel="";
	var Check=$("#CheckCancel").prop("checked")
	if (Check){CheckCancel="C"}
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Triage",
		QueryName:"QueryTriageList",
		'DCARowIDStr':DCARowIdStr,
		'DDCTRIRowID':DDCTRIRowID,
		'Status':CheckCancel,
		Pagerows:CureTriageListDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		CureTriageListDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
	})
}

function BtnCancelClick(){
	var rows = CureTriageListDataGrid.datagrid("getSelections");
	if (rows.length==0) 
	{
		$.messager.alert("提示","请选择一条分诊记录.");
		return;
	}
	var DCRRowId=""
	var rowIndex = CureTriageListDataGrid.datagrid("getRowIndex", rows[0]);
	var selected=CureTriageListDataGrid.datagrid('getRows'); 
	var DCCTRRowId=selected[rowIndex].Rowid;
	if(DCCTRRowId=="")
	{
		$.messager.alert('Warning','请选择一条分诊记录');
		return false;
	}
	$.m({
		ClassName:"DHCDoc.DHCDocCure.Triage",
		MethodName:"CancelTriaged",
		'DDCTRRowID':DCCTRRowId,
		'UserID':session['LOGON.USERID'],
	},function testget(value){
		if(value == "0"){
			$.messager.show({title:"提示",msg:"取消成功"});
			//location.reload();
			LoadCureTriageListDataGrid();
			if(window.frames.parent.CureApplyDataGrid){
				window.frames.parent.RefreshDataGrid();
			}
		}else{
			if(value=="100")value="参数为空"
			else if(value=="101")value="参数为空"
			else if(value=="102")value="非分配状态的不允许取消"
			else if(value=="103")value="已经预约不允许取消"
			else if(value=="104")value="执行记录已经执行不允许取消"
			else if(value=="-301")value="保存分配记录失败"
			else if(value=="-300")value="更新申请单状态失败"
			$.messager.alert("提示","取消失败,"+value);
		}
	});	
}