var CureTriageListDataGrid;
function InitCureTriageListEvent(){
	$('#btnTriageListSearch').bind("click",function(){
		CureTriageListDataGridLoad();	
	})
	$('#btnTriageListCancel').bind("click",function(){
		BtnTLCancelClick();	
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
		singleSelect : false,
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
					{field:'RowCheck',checkbox:true},
        			{field:'Rowid',title:'',width:1,hidden:true}, 
        			{field:'PatientNo',title:'登记号',width:80,align:'left'},   
        			{field:'PatientName',title:'姓名',width:60,align:'left'},
        			{field:'ArcimDesc',title:'治疗项目',width:200,align:'left'},
        			{field:'DDCTRCTLoc',title:'科室',width:100,align:'left'},  
        			{field:'DDCTRCTPCP',title:'资源',width:60,align:'left'},
        			{field:'DDCTRStatus',title:'状态',width:50,align:'left'},
        			{field:'DDCTRUser',title:'操作人',width:60,align:'left'},
        			{field:'DDCTRDate',title:'操作时间',width:100,align:'left'}
       			 ]] ,
	});
}
function CureTriageListDataGridLoad()
{
	var DCARowIdStr=PageAppListAllObj._SELECT_DCAROWID; //$('#DCARowIdStr').val();
	var DDCTRIRowID=""; //$('#DDCTRIRowID').val();
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
		CureTriageListDataGrid.datagrid("clearSelections");
		CureTriageListDataGrid.datagrid("clearChecked");
	})
}

function BtnTLCancelClick(){
	var selectrows=""
	var rowobj=$('#tabCureTriageList').datagrid("getSelections")
	var length=rowobj.length
	if (length==0){
		$.messager.alert("提示","请选择一条分诊记录.");
		return;
	}
	var success=true;
	for (var i=0;i<length;i++){
		var Rowid=rowobj[i].Rowid
		if (Rowid==""){continue}
		if (("^"+selectrows+"^").indexOf("^"+Rowid+"^")>=0){continue}
		if (selectrows!=""){selectrows=selectrows+"^"+Rowid}else{selectrows=Rowid}
		var PatientName=rowobj[i].PatientName;
		var ArcimDesc=rowobj[i].ArcimDesc;
		var value=$.cm({
		ClassName:"DHCDoc.DHCDocCure.Triage",
		MethodName:"CancelTriaged",
			'DDCTRRowID':Rowid,
		'UserID':session['LOGON.USERID'],
			dataType:"text"
		},false)
		if(value == "0"){
			//$.messager.show({title:"提示",msg:"取消成功"});
		}else{
			if(value=="100")value="参数为空"
			else if(value=="101")value="参数为空"
			else if(value=="102")value=PatientName+",["+ArcimDesc+"]非分配状态的不允许取消"
			else if(value=="103")value=PatientName+",["+ArcimDesc+"]已经预约不允许取消"
			else if(value=="104")value=PatientName+",["+ArcimDesc+"]执行记录已经执行不允许取消"
			else if(value=="-301")value=PatientName+",["+ArcimDesc+"]保存分配记录失败"
			else if(value=="-300")value=PatientName+",["+ArcimDesc+"]更新申请单状态失败"
			$.messager.alert("提示","取消失败,"+value);
			success=false;
		}
	}
	if(success){
			$.messager.show({title:"提示",msg:"取消成功"});
	}
			CureTriageListDataGridLoad();
			if(window.frames.parent.CureApplyDataGrid){
				window.frames.parent.RefreshDataGrid();
			}else{
				RefreshDataGrid();	
			}
}