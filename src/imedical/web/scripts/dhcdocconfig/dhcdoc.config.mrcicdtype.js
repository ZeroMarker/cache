var tabDiagTypeListDataGrid;
var ICDTYPERowId="";
$(function(){ 
   InitDiagTypeList();
   LoadDiagTypeListDataGrid();
   InitEvent();
});
function InitEvent() {
	$("#Text_InputStr").bind("keydown",InputStrKeydownHandle);
	$HUI.checkbox("#Check_DeathICDType",{
        onChecked:function(e,value){
            CheckBoxClickHandler();
        }
    });
    $("#BFind").click(LoadDiagTypeListDataGrid);
    $("#BSave").click(Save);
}
function InputStrKeydownHandle(e) {
	try { keycode = websys_getKey(e); } catch (e) { keycode = websys_getKey(); }
	if (keycode==13) {
		LoadDiagTypeListDataGrid();
	}
}
function CheckBoxClickHandler(e) {
	$("#Text_InputStr").val("");
}
function Save(){
	if(ICDTYPERowId!=""){
		var DeathICDType=$("#Check_DeathICDType").checkbox("getValue")?1:0;
		var str=ICDTYPERowId+"^"+"DeathICDType"+"^"+DeathICDType;
		$.cm({
			ClassName:"DHCDoc.DHCDocConfig.Diagnose",
			MethodName:"saveDiagTypeConfig",
			dataType:"text",
			str:str
		},function(rtn){
			$.messager.popover({msg: '保存成功',type:'success'});
		});
	}else{
		$.messager.alert("提示","请选择诊断分类!");
	}
}
function InitDiagTypeList(){
	DiagTypeListColumns=[[    
		{ field: 'ICDTYPECode', title: '代码', width: 100, align: 'center'},
		{ field: 'ICDTYPEDesc', title:'描述', width: 150, align: 'center'}
		
	 ]];
	tabDiagTypeListDataGrid=$('#tabDiagTypeList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url : './dhcdoc.cure.query.grid.easyui.csp',
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"ICDTYPERowId",
		pageSize:15,
		pageList : [15,50,100,200],
		columns :DiagTypeListColumns,
		onClickRow:function(rowIndex, rowData){
			ICDTYPERowId=rowData.ICDTYPERowId;
			$.cm({
				ClassName:"DHCDoc.DHCDocConfig.Diagnose",
				MethodName:"getDiagTypeConfig",
				dataType:"text",
				DiagTypeRowId:ICDTYPERowId
			},function(rtn){
				$("#Check_DeathICDType").checkbox('uncheck');
				var arrayStr=rtn.split("^");
				 if (arrayStr[0]==1){
					$("#Check_DeathICDType").checkbox('check');
			     }
			});
		},
		onLoadSuccess:function(data){
			$(this).datagrid('unselectAll');
			ICDTYPERowId="";
		}
	});
};
function LoadDiagTypeListDataGrid()
{
	var input=$("#Text_InputStr").val();
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.Diagnose';
	queryParams.QueryName ='GetList';
	queryParams.Arg1 ="";
	queryParams.Arg2 ="";
	queryParams.Arg3 =input;
	queryParams.ArgCnt =3;
	var opts = tabDiagTypeListDataGrid.datagrid("options");
	opts.url = './dhcdoc.cure.query.grid.easyui.csp';
	tabDiagTypeListDataGrid.datagrid('load', queryParams);
};