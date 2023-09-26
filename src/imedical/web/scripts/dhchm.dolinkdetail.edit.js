/**
 * 关联问题维护  dhchm.dolinkdetail.js
 * @Author   wangguoying
 * @DateTime 2019-04-02
 */

var DOLinkDataGrid;
var init=function(){
	DOLinkDataGrid=$HUI.datagrid("#DOLinkList",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCHM.CQDOLinkDetail",
			QueryName:"CQDOLinkDetail",
			ParRef:$("#OID").val()
		},
		onSelect:function(rowIndex,rowData){
			
		},
		onDblClickRow:function(index,row){
															
		},	
		columns:[[
			{field:'TID',hidden:true,sortable:'true'},
			{field:'TLinkDetailID',hidden:true},
			{field:'TQuestionName',width:265,title:'问卷'},
			{field:'TDetailDesc',width:265,title:'问题内容'}
		]],
		fitColumns:true,
		pagination:true,
		pageSize:20,
		fit:true,
		rownumbers:true
	});
}



function dolAdd()
{
	var OID=$("#OID").val();
	var SDLinkDataGrid = $('#SDLinkID').combogrid('grid');	// get datagrid object
	var row = SDLinkDataGrid.datagrid('getSelected');	// get the selected row

	if(OID==""){
		$.messager.alert("提示","OID不能为空","info");
		return;
	}
	if((row==null)){
		$.messager.alert("提示","关联问题不能为空","info");
		return;
	}
	var addRet=tkMakeServerCall("web.DHCHM.CQDOLinkDetail","Update",OID,"",row.DOLID);
	if(addRet.split("^")[0]!="0"){
		$.messager.alert("错误",addRet.split("^")[1],"error");	
	}else{
		$.messager.alert("提示","保存成功","success");
		DOLinkDataGrid.reload();
	}
}

function dolDelt()
{
	var rows = DOLinkDataGrid.getSelections();

	if((rows<=0)){
		$.messager.alert("提示","请选择行","info");
		return;
	}
	$.messager.confirm("删除", "确定删除该记录?", function (r) {
		if (r) {
			var delRet=tkMakeServerCall("web.DHCHM.CQDOLinkDetail","Detele",rows[0].TID);
			if(delRet!="0"){
				$.messager.alert("错误","删除失败："+delRet,"error");	
			}else{
				$.messager.alert("提示","删除成功","success");
				DOLinkDataGrid.reload();
			}
		} 
	});
	
}


$(init);