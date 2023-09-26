/**
 * 选项与套餐关联度维护  dhchm.optionlinkordsets.js
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
			{field:'OrdSetsDesc',width:165,title:'套餐名称'},
			{field:'QDOLSlevance',width:95,title:'关联度'},
			{field:'QDOLSActive',width:60,title:'激活',
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
		$.messager.alert("提示","OID不能为空","info");
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
	var property="QDOLSParRef^QDOLSOrdSetsDR^QDOLSRelevance^QDOLSActive";
	var valList=OID+"^"+OrderSetId+"^"+Relevance+"^"+Active;
	var QDOLSID=$("#QDOLSID").val();
	
	var addRet=tkMakeServerCall("web.DHCHM.QuestionDetailSet","QDOLOSSave",QDOLSID,valList,property);
	var resultCode=addRet.split("^")[0];
	if(parseInt(resultCode)<=0){
		$.messager.alert("错误",addRet.split("^")[1],"error");	
	}else{
		$.messager.alert("提示","保存成功","success");
		dosClear();
		DOSLinkDataGrid.reload();
	}
}

function dosDelt()
{
	var QDOLSID=$("#QDOLSID").val();
	if(QDOLSID==""){
		$.messager.alert("提示","请先选中要删除的数据","info");
		return false;
	}
	$.messager.confirm("删除", "确定删除该记录?", function (r) {
		if (r) {
			var delRet=tkMakeServerCall("web.DHCHM.QuestionDetailSet","QDOLOSDelete",QDOLSID);
			var resultCode=delRet.split("^")[0];
			if(parseInt(resultCode)<0){
				$.messager.alert("错误",delRet.split("^")[1],"error");	
			}else{
				$.messager.alert("提示","删除成功","success");
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