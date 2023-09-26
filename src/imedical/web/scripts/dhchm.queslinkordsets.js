/**
 * 问题内容与套餐关联度维护  dhchm.queslinkordsets.js
 * @Author   wangguoying
 * @DateTime 2019-04-03
 */
var DSLinkDataGrid;
var init=function(){
	DSLinkDataGrid=$HUI.datagrid("#DSLinkList",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCHM.QuestionDetailSet",
			QueryName:"QueryQDLOrdSetsInfo",
			ParRef:$("#DID").val()
		},
		onSelect:function(rowIndex,rowData){
			if(rowIndex>-1){
				dsClear();
				$("#QDLSID").val(rowData.QDLSID);
				$("#Relevance").val(rowData.QDLSlevance);
				$("#Expression").val(rowData.QDLSExpression);
				$('#OrdSetsDR').combogrid('setValue', rowData.QDLSSetsDR);
			}
		},
		onDblClickRow:function(index,row){
															
		},	
		columns:[[
			{field:'QDLSID',hidden:true,sortable:'true'},
			{field:'QDLSSetsDR',hidden:true,sortable:'true'},
			{field:'OrdSetsDesc',width:100,title:'套餐名称'},
			{field:'QDLSlevance',width:40,title:'关联度'},
			{field:'QDLSExpression',width:100,title:'表达式'}
		]],
		fitColumns:true,
		pagination:true,
		pageSize:20,
		fit:true,
		rownumbers:true
	});
}



function dsAdd()
{
	var DID=$("#DID").val();
	var Relevance=$("#Relevance").val();
	var Expression=$("#Expression").val();
	var OrdSetsDRDataGrid = $('#OrdSetsDR').combogrid('grid');	// get datagrid object
	var row = OrdSetsDRDataGrid.datagrid('getSelected');	// get the selected row

	if(DID==""){
		$.messager.alert("提示","DID不能为空","info");
		return;
	}
	if((row==null)){
		$.messager.alert("提示","关联套餐不能为空","info");
		return;
	}
	var OrderSetId=row.OrderSetId;
	if(Relevance==""){
		$.messager.alert("提示","关联度不能为空","info");
		return;
	}
	if(Expression==""){
		$.messager.alert("提示","表达式不能为空","info");
		return;
	}
	var IsVaild=tkMakeServerCall("web.DHCHM.QuestionDetailSet","IsValidExpression",Expression)
	if(IsVaild=="0"){
		$.messager.alert("提示","无效的表达式","info");
		return;
	}
	var property="QDLSParRef^QDLSOrdSetsDR^QDLSRelevance^QDLSExpression";
	var valList=DID+"^"+OrderSetId+"^"+Relevance+"^"+Expression;
	var QDLSID=$("#QDLSID").val();
	
	var addRet=tkMakeServerCall("web.DHCHM.QuestionDetailSet","QDNLSave",QDLSID,valList,property);
	var resultCode=addRet.split("^")[0];
	if(parseInt(resultCode)<=0){
		$.messager.alert("错误",addRet.split("^")[1],"error");	
	}else{
		$.messager.alert("提示","保存成功","success");
		dsClear();
		DSLinkDataGrid.reload();
	}
}

function dsDelt()
{
	var QDLSID=$("#QDLSID").val();
	if(QDLSID==""){
		$.messager.alert("提示","请先选中要删除的数据","info");
		return false;
	}
	$.messager.confirm("删除", "确定删除该记录?", function (r) {
		if (r) {
			var delRet=tkMakeServerCall("web.DHCHM.QuestionDetailSet","QDLSDelete",QDLSID);
			var resultCode=delRet.split("^")[0];
			if(parseInt(resultCode)<0){
				$.messager.alert("错误",delRet.split("^")[1],"error");	
			}else{
				$.messager.alert("提示","删除成功","success");
				dsClear();
				DSLinkDataGrid.reload();
			}
		} 
	});
	
}

function dsSech()
{
	var OrderSetId="";
	var OrdSetsDRDataGrid = $('#OrdSetsDR').combogrid('grid');	// get datagrid object
	var row = OrdSetsDRDataGrid.datagrid('getSelected');	// get the selected row
	if(row!=null) {
		OrderSetId=row.OrderSetId;
	}
	DSLinkDataGrid.load({ClassName:"web.DHCHM.QuestionDetailSet",QueryName:"QueryQDLOrdSetsInfo",ParRef:$("#DID").val(),OrdSetsDR:OrderSetId});
}

function dsClear()
{
	$("#QDLSID").val("");
	$("#Relevance").val("");
	$("#Expression").val("");
	$('#OrdSetsDR').combogrid('setValue', "");
}

$(init);