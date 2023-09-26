/**
 * ѡ�����ײ͹�����ά��  dhchm.optionlinkordsets.js
 * @Author   wangguoying
 * @DateTime 2019-04-03
 */



var DOSLinkDataGrid;
var init=function(){
	DOSLinkDataGrid=$HUI.datagrid("#DOSLinkList",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCHM.QuestionDetailSet",
			QueryName:"QueryQDOLSInfo",
			ParRef:$("#OID").val(),
			OrdSetsDR:"",
			Relevance:"",
			Active:""
		},
		onSelect:function(rowIndex,rowData){
			if(rowIndex>-1){
				dosClear();
				$("#QDOLSID").val(rowData.QDOLSID);
				$("#Relevance").val(rowData.QDOLSlevance);
				$('#OrdSetsDR').combogrid('setValue', rowData.QDOLSSetsDR);
				if(rowData.QDOLSActive=="Y"){
					$("#Active").checkbox("check");
				}else{
					$("#Active").checkbox("uncheck");
				}
			}
		},
		onDblClickRow:function(index,row){
															
		},	
		columns:[[
			{field:'QDOLSID',hidden:true,sortable:'true'},
			{field:'QDOLSSetsDR',hidden:true,sortable:'true'},
			{field:'OrdSetsDesc',width:165,title:'�ײ�����'},
			{field:'QDOLSlevance',width:95,title:'������'},
			{field:'QDOLSActive',width:60,title:'����',
				formatter:function(value,row,index){
					var checked=value=="Y"? "checked":"";
					return "<input type='checkbox' disabled class='hisui-checkbox' "+checked+" >";
				}
			}
		]],
		fitColumns:true,
		pagination:true,
		pageSize:20,
		fit:true,
		rownumbers:true
	});
}



function dosAdd()
{
	var OID=$("#OID").val();
	var Relevance=$("#Relevance").val();
	var Active="N";
	if($("#Active").checkbox("getValue"))
	{
		Active="Y";
	}
	var OrdSetsDRDataGrid = $('#OrdSetsDR').combogrid('grid');	// get datagrid object
	var row = OrdSetsDRDataGrid.datagrid('getSelected');	// get the selected row

	if(OID==""){
		$.messager.alert("��ʾ","OID����Ϊ��","info");
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
	var property="QDOLSParRef^QDOLSOrdSetsDR^QDOLSRelevance^QDOLSActive";
	var valList=OID+"^"+OrderSetId+"^"+Relevance+"^"+Active;
	var QDOLSID=$("#QDOLSID").val();
	
	var addRet=tkMakeServerCall("web.DHCHM.QuestionDetailSet","QDOLOSSave",QDOLSID,valList,property);
	var resultCode=addRet.split("^")[0];
	if(parseInt(resultCode)<=0){
		$.messager.alert("����",addRet.split("^")[1],"error");	
	}else{
		$.messager.alert("��ʾ","����ɹ�","success");
		dosClear();
		DOSLinkDataGrid.reload();
	}
}

function dosDelt()
{
	var QDOLSID=$("#QDOLSID").val();
	if(QDOLSID==""){
		$.messager.alert("��ʾ","����ѡ��Ҫɾ��������","info");
		return false;
	}
	$.messager.confirm("ɾ��", "ȷ��ɾ���ü�¼?", function (r) {
		if (r) {
			var delRet=tkMakeServerCall("web.DHCHM.QuestionDetailSet","QDOLOSDelete",QDOLSID);
			var resultCode=delRet.split("^")[0];
			if(parseInt(resultCode)<0){
				$.messager.alert("����",delRet.split("^")[1],"error");	
			}else{
				$.messager.alert("��ʾ","ɾ���ɹ�","success");
				dosClear();
				DOSLinkDataGrid.reload();
			}
		} 
	});
	
}

function dosSech()
{
	var OrderSetId="";
	var OrdSetsDRDataGrid = $('#OrdSetsDR').combogrid('grid');	// get datagrid object
	var row = OrdSetsDRDataGrid.datagrid('getSelected');	// get the selected row
	if(row!=null) {
		OrderSetId=row.OrderSetId;
	}
	var Active="N";
	if($("#Active").checkbox("getValue"))
	{
		Active="Y";
	}
	var Relevance=$("#Relevance").val();
	DOSLinkDataGrid.load({ClassName:"web.DHCHM.QuestionDetailSet",QueryName:"QueryQDOLSInfo",ParRef:$("#OID").val(),OrdSetsDR:OrderSetId,Relevance:Relevance,Active:Active});
}

function dosClear()
{
	$("#QDOLSID").val("");
	$("#Relevance").val("");
	$("#Active").checkbox("check");
	$('#OrdSetsDR').combogrid('setValue', "");
}

$(init);