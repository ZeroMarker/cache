/**
 * �����������ײ͹�����ά��  dhchm.queslinkordsets.js
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
			{field:'OrdSetsDesc',width:100,title:'�ײ�����'},
			{field:'QDLSlevance',width:40,title:'������'},
			{field:'QDLSExpression',width:100,title:'���ʽ'}
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
		$.messager.alert("��ʾ","DID����Ϊ��","info");
		return;
	}
	if((row==null)){
		$.messager.alert("��ʾ","�����ײͲ���Ϊ��","info");
		return;
	}
	var OrderSetId=row.OrderSetId;
	if(Relevance==""){
		$.messager.alert("��ʾ","�����Ȳ���Ϊ��","info");
		return;
	}
	if(Expression==""){
		$.messager.alert("��ʾ","���ʽ����Ϊ��","info");
		return;
	}
	var IsVaild=tkMakeServerCall("web.DHCHM.QuestionDetailSet","IsValidExpression",Expression)
	if(IsVaild=="0"){
		$.messager.alert("��ʾ","��Ч�ı��ʽ","info");
		return;
	}
	var property="QDLSParRef^QDLSOrdSetsDR^QDLSRelevance^QDLSExpression";
	var valList=DID+"^"+OrderSetId+"^"+Relevance+"^"+Expression;
	var QDLSID=$("#QDLSID").val();
	
	var addRet=tkMakeServerCall("web.DHCHM.QuestionDetailSet","QDNLSave",QDLSID,valList,property);
	var resultCode=addRet.split("^")[0];
	if(parseInt(resultCode)<=0){
		$.messager.alert("����",addRet.split("^")[1],"error");	
	}else{
		$.messager.alert("��ʾ","����ɹ�","success");
		dsClear();
		DSLinkDataGrid.reload();
	}
}

function dsDelt()
{
	var QDLSID=$("#QDLSID").val();
	if(QDLSID==""){
		$.messager.alert("��ʾ","����ѡ��Ҫɾ��������","info");
		return false;
	}
	$.messager.confirm("ɾ��", "ȷ��ɾ���ü�¼?", function (r) {
		if (r) {
			var delRet=tkMakeServerCall("web.DHCHM.QuestionDetailSet","QDLSDelete",QDLSID);
			var resultCode=delRet.split("^")[0];
			if(parseInt(resultCode)<0){
				$.messager.alert("����",delRet.split("^")[1],"error");	
			}else{
				$.messager.alert("��ʾ","ɾ���ɹ�","success");
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