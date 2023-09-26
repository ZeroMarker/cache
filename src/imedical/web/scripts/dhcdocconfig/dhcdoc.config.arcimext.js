var ArcimListDataGrid;
var ArcimRowId="";
$(function(){
   InitHospList(); 
   InitEvent();
   $("#BFind").click(LoadArcimListDataGrid);
   $("#BSave").click(SaveARCIMExt);
});
function InitHospList()
{
	var hospComp = GenHospComp("Doc_BaseConfig_ArcimExt");
	hospComp.jdata.options.onSelect = function(e,t){
		$("#Text_InputStr").val("");
		$("#Check_StopAfterLongOrder,#Check_NotAutoStop").checkbox('uncheck');
		ArcimListDataGrid.datagrid('loadData',{total:0,rows:[]})
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		InitArcimList();
	}
}
function InitEvent() {
	$("#Text_InputStr").bind("keydown",InputStrKeydownHandle);
	$HUI.checkbox("#Check_StopAfterLongOrder",{
        onChecked:function(e,value){
            CheckBoxClickHandler();
        }
    });
    $HUI.checkbox("#Check_NotAutoStop",{
        onChecked:function(e,value){
            CheckBoxClickHandler();
        }
    });
}
function InputStrKeydownHandle(e) {
	try { keycode = websys_getKey(e); } catch (e) { keycode = websys_getKey(); }
	if (keycode==13) {
		LoadArcimListDataGrid();
	}
}
function CheckBoxClickHandler(e) {
	$("#Text_InputStr").val("");
}
function SaveARCIMExt(){
	if(ArcimRowId!=""){
		var StopAfterLongOrder=0;
		if ($("#Check_StopAfterLongOrder").checkbox("getValue")) {
		  StopAfterLongOrder=1;
		};
		var NotAutoStop=0;
		if ($("#Check_NotAutoStop").checkbox("getValue")){
			NotAutoStop=1;
		};
		var val=0+"^"+NotAutoStop+"^"+StopAfterLongOrder;
		$.cm({
			ClassName:"DHCDoc.DHCDocConfig.ARCIMExt",
			MethodName:"saveARCIMConfig",
			dataType:"text",
			ArcimRowId:ArcimRowId,
			val:val
		},function(rtn){
			$.messager.popover({msg: '保存成功',type:'success'});
		});
	}else{
		$.messager.alert("提示","请选择医嘱项!");
	}
}
function InitArcimList(){
	ArcimListColumns=[[    
		{ field: 'ArcimDesc', title:'医嘱项名称', width: 200, align: 'center'},
		{ field: 'ArcimRowID', title: '医嘱项ID', width: 50, align: 'center'}	
	 ]];
	ArcimListDataGrid=$('#tabArcimList').datagrid({  
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
		idField:"ArcimRowID",
		pageSize:15,
		pageList : [15,50,100,200],
		columns :ArcimListColumns,
		onClickRow:function(rowIndex, rowData){
			ArcimRowId=rowData.ArcimRowID;
			$.cm({
				ClassName:"DHCDoc.DHCDocConfig.ARCIMExt",
				MethodName:"getARCIMConfig",
				dataType:"text",
				ArcimRowId:ArcimRowId
			},function(rtn){
				$("#Check_NotAutoStop,#Check_StopAfterLongOrder").checkbox('uncheck');
				var arrayStr=rtn.split("^");
				 if (arrayStr[1]==1){
					$("#Check_NotAutoStop").checkbox('check');
			     }
				 if(arrayStr[2]==1){
					 $("#Check_StopAfterLongOrder").checkbox('check');
				 }
			});
		},
		onLoadSuccess:function(data){
			$(this).datagrid('unselectAll');
			ArcimRowId="";
		}
	});
};
function LoadArcimListDataGrid()
{
	var StopAfterLongOrder=0;
	if ($("#Check_StopAfterLongOrder").checkbox("getValue")) {
	  StopAfterLongOrder=1;
	};
	var NotAutoStop=0;
	if ($("#Check_NotAutoStop").checkbox("getValue")){
		NotAutoStop=1;
	};
	var input=$("#Text_InputStr").val();
	if ((input=="")&&(StopAfterLongOrder==0)&&(NotAutoStop==0)){
		$.messager.alert("提示","请输入医嘱别名或勾选右侧配置进行查询!");
		return false;
	}
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.ArcItemConfig';
	queryParams.QueryName ='FindAllItem';
	queryParams.Alias =input;
	queryParams.StopAfterLongOrder =StopAfterLongOrder;
	queryParams.NotAutoStop =NotAutoStop;
	queryParams.GroupID =session['LOGON.GROUPID'];
	queryParams.HospId=$HUI.combogrid('#_HospList').getValue()
	var opts = ArcimListDataGrid.datagrid("options");
	//opts.url = './dhcdoc.cure.query.grid.easyui.csp';
	opts.url = $URL;
	ArcimListDataGrid.datagrid('load', queryParams);
};