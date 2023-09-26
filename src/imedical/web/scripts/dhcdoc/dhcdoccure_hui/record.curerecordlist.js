var CureRecordDataGrid;
$(document).ready(function(){
	Init();
	CureRecordDataGridLoad();		
});

function Init(){
	InitCureRecordDataGrid();
}

function InitCureRecordDataGrid()
{
	// Toolbar
	var cureRecordToolBar = [{
		id:'BtnFind',
		text:'查找', 
		iconCls:'icon-search',  
		handler:function(){
			CureRecordDataGridLoad();
		}
	},"-",{
		id:'BtnDetailView',
		text:'浏览', 
		iconCls:'icon-big-book-eye',  
		handler:function(){
			DetailView();
		}
	}];
	// 治疗申请单预约记录Grid
	CureRecordDataGrid=$('#tabCureRecordList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
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
        			{field:'DCRTitle',title:'标题',width:300},  
        			{field:'CreateUser',title:'创建人',width:100},
        			{field:'CreateDate',title:'创建时间',width:100},
        			{field:'UpdateUser',title:'最后更新人',width:100},
        			{field:'UpdateDate',title:'最后更新时间',width:100} ,
        			{field:'ID',title:'ID',width:50}    
    			 ]] ,
    	toolbar : cureRecordToolBar,
    	onDblClickRow:function(rowIndex, rowData){ 
			DetailView();
       }
	});
}
function CureRecordDataGridLoad()
{
	var DCARowIdStr=$('#DCARowIdStr').val();
	var DCARowId=$('#DCARowId').val();
	if(DCARowIdStr!="")DCARowId=DCARowIdStr;
	//var DCAARowId=$('#DCAARowId').val();
	var DCAOEOREDR=$('#DCAOEOREDR').val();	
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Record",
		QueryName:"FindCureRecordList",
		'DCARowIdStr':DCARowId,
		'DCAOEOREDR':DCAOEOREDR,
		Pagerows:CureRecordDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		CureRecordDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
	})
}
function OpenCureRecordDiag(DCRRowId)
{
	var OperateType=$('#OperateType').val();
	var DCAARowId=""; //$('#DCAARowId').val();
	var href="doccure.curerecord.hui.csp?OperateType="+OperateType+"&DCAARowId="+DCAARowId+"&DCRRowId="+DCRRowId;
	var ReturnValue=window.showModalDialog(href,"","dialogwidth:50em;dialogheight:25em;status:no;center:1;resizable:yes");
	
}

function DetailView(){
	var rows = CureRecordDataGrid.datagrid("getSelections");
	if (rows.length==0) 
	{
		$.messager.alert("提示","请选择一条治疗记录单查看");
		return;
	}else if (rows.length>1){
 		$.messager.alert("错误","您选择了多个治疗记录单！",'err')
 		return;
	}
	var DCRRowId=""
	var rowIndex = CureRecordDataGrid.datagrid("getRowIndex", rows[0]);
	var selected=CureRecordDataGrid.datagrid('getRows'); 
	var DCRRowId=selected[rowIndex].Rowid;
	if(DCRRowId=="")
	{
		$.messager.alert('Warning','请选择一条治疗记录');
		return false;
	}
	OpenCureRecordDiag(DCRRowId);	
}