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
	// �������뵥ԤԼ��¼Grid
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
		loadMsg : '������..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"Rowid",
		pageSize : 5,
		pageList : [5,15,50,100],
		columns :[[   
        			{field:'Rowid',title:'',width:1,hidden:true}, 
        			{field:'PatientNo',title:'�ǼǺ�',width:80,align:'center'},   
        			{field:'PatientName',title:'����',width:60,align:'center'},
        			{field:'ArcimDesc',title:'������Ŀ',width:200,align:'center'},
        			{field:'DDCTRCTLoc',title:'����',width:100,align:'center'},  
        			{field:'DDCTRCTPCP',title:'��Դ',width:60,align:'center'},
        			{field:'DDCTRStatus',title:'״̬',width:50,align:'center'},
        			{field:'DDCTRUser',title:'������',width:60,align:'center'},
        			{field:'DDCTRDate',title:'����ʱ��',width:100,align:'center'}
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
		$.messager.alert("��ʾ","��ѡ��һ�������¼.");
		return;
	}
	var DCRRowId=""
	var rowIndex = CureTriageListDataGrid.datagrid("getRowIndex", rows[0]);
	var selected=CureTriageListDataGrid.datagrid('getRows'); 
	var DCCTRRowId=selected[rowIndex].Rowid;
	if(DCCTRRowId=="")
	{
		$.messager.alert('Warning','��ѡ��һ�������¼');
		return false;
	}
	$.m({
		ClassName:"DHCDoc.DHCDocCure.Triage",
		MethodName:"CancelTriaged",
		'DDCTRRowID':DCCTRRowId,
		'UserID':session['LOGON.USERID'],
	},function testget(value){
		if(value == "0"){
			$.messager.show({title:"��ʾ",msg:"ȡ���ɹ�"});
			//location.reload();
			LoadCureTriageListDataGrid();
			if(window.frames.parent.CureApplyDataGrid){
				window.frames.parent.RefreshDataGrid();
			}
		}else{
			if(value=="100")value="����Ϊ��"
			else if(value=="101")value="����Ϊ��"
			else if(value=="102")value="�Ƿ���״̬�Ĳ�����ȡ��"
			else if(value=="103")value="�Ѿ�ԤԼ������ȡ��"
			else if(value=="104")value="ִ�м�¼�Ѿ�ִ�в�����ȡ��"
			else if(value=="-301")value="��������¼ʧ��"
			else if(value=="-300")value="�������뵥״̬ʧ��"
			$.messager.alert("��ʾ","ȡ��ʧ��,"+value);
		}
	});	
}