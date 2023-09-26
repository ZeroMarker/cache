/**
 * 模块:		药库
 * 子模块:		库存项关联收费项维护
 * createdate:	2018-11-09
 * creator:		yunhaibao
 */
var CurDate=$.fn.datebox.defaults.formatter(new Date());
var HASBEENUSED="";	// 是否发生业务
$(function(){
	try{
		InitDict();
		InitIncLinkTarGrid();
		$("#btnAdd").on("click",AddIncLinkTar);
		$("#btnUpdate").on("click",SaveIncLinkTar);
	    $("#btnClear").on("click",ClearContent);
		$("#btnClose").on("click",CloseContent);
		document.onkeypress = DHCSTEASYUI.BanBackspace;
		document.onkeydown = DHCSTEASYUI.BanBackspace;
	}catch(e){
		$.messager.alert("错误提示",e.message,"error");
		$.messager.progress('close');
	}
});

function InitDict(){
	$("#dtStDate,#dtEdDate").datebox({});
	$("#dtStDate").datebox("setValue",CurDate);
	var tmpOptions={
		ClassName:"web.DHCST.INCLINKTAR",
		QueryName:"GetTarItem",
		StrParams:"",
		pageSize:30, 
		pageList:[30,50,100],  
		pagination:true,	
    	columns: [[
			{field:'tarItmId',title:'tarItmId',width:100,sortable:true,hidden:true},
			{field:'tarItmCode',title:'收费项代码',width:100,sortable:true},
			{field:'tarItmDesc',title:'收费项名称',width:100,sortable:true}
	    ]],
		idField:'tarItmId',
		textField:'tarItmDesc',
		mode:"remote",
		onLoadSuccess:function(data) {
			//$("#cmbTarItm").combogrid("clear");
		}	
    };
	$("#cmbTarItm").dhcstcombogrideu(tmpOptions);

}

function InitIncLinkTarGrid(){
		var gridColumns=[[ 
		{field:'lnkId',title:'关联Id',width:155,hidden:true,align:'center'},
		{field:'tarItmId',title:'收费项Id',width:155,hidden:true,align:'center'},
		{field:'tarItmCode',title:'收费项代码',width:100,align:'left'},
		{field:'tarItmDesc',title:'收费项名称',width:200,align:'left'},
		{field:'uomDesc',title:'单位',width:80,hidden:false},
		{field:'qty',title:'数量',width:50,hidden:false},
		{field:'sp',title:'价格',width:80,align:"right"},
		{field:'lnkStDate',title:'开始日期',width:100,hidden:false,align:'center'},
		{field:'lnkEdDate',title:'结束日期',width:100,hidden:false,align:'center'}
		
	]];
	var options={
		ClassName:"web.DHCST.INCLINKTAR",
		QueryName:"QueryIncLinkTar",
		queryParams:{
			StrParams:urlIncItmId 
		},
		nowrap:false,
		pagination:false,
		columns:gridColumns,
		onClickRow:function(rowIndex,rowData){
			if (rowData){
				$("#dtStDate").datebox("setValue",rowData.lnkStDate||"");
				$("#dtEdDate").datebox("setValue",rowData.lnkEdDate||"");
				$("#cmbTarItm").combogrid("setValue",rowData.tarItmId);
				$("#cmbTarItm").combogrid("setText",rowData.tarItmDesc);
				MakeReadOnly(true)
			}
		}
	};
	$('#incLinkTarGrid').dhcstgrideu(options);  
}


function CloseContent(){
	$.messager.confirm('关闭提示', '您确认关闭吗?', function(r){
		if (r){	
			parent.$('#maintainWin').window("close");
		}
	});
}
// 此处清屏,不需要提示
function ClearContent(){
	$("#dtStDate").datebox("setValue",CurDate);
	$("#dtEdDate").datebox("setValue","");
	$("#cmbTarItm").combogrid("clear")
	$("#incLinkTarGrid").datagrid("reload");
	MakeReadOnly(false);
}
function AddIncLinkTar(){
	var gridSelected=$('#incLinkTarGrid').datagrid('getSelected')||"";
	
	if (gridSelected!=""){
		debugger
		$.messager.alert("提示","选择表格内记录后,只能修改或清屏后增加","error");
		return;
	}
	SaveIncLinkTar();
}
function SaveIncLinkTar(){
	var incId=urlIncItmId;
	var tarItmId=$("#cmbTarItm").combobox("getValue");
	var stDate=$("#dtStDate").datebox("getValue");
	var edDate=$("#dtEdDate").datebox("getValue");
	var lnkId="";
	var gridSelected=$('#incLinkTarGrid').datagrid('getSelected');
	if (gridSelected){
		lnkId=gridSelected.lnkId||"";
	}
	var inputStr=incId+"^"+tarItmId+"^"+1+"^"+stDate+"^"+edDate
	var saveRet=tkMakeServerCall("web.DHCST.INCLINKTAR","SaveIncLinkTar",lnkId,inputStr);
	var saveArr=saveRet.split("^");
	var saveVal=saveArr[0];
	var saveInfo=saveArr[1];
	if (saveVal<0){
		$.messager.alert("提示",saveInfo,saveVal==-10?"warning":"error");
	}else{
		ClearContent();
	}
}

function MakeReadOnly(tfFlag){
	$("#cmbTarItm").combogrid("readonly",tfFlag)
	$("#dtStDate").datebox("readonly",tfFlag)
}