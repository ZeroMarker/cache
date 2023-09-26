/**
 * ��������ά��  dhchm.dolinkdetail.js
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
			{field:'TQuestionName',width:265,title:'�ʾ�'},
			{field:'TDetailDesc',width:265,title:'��������'}
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
		$.messager.alert("��ʾ","OID����Ϊ��","info");
		return;
	}
	if((row==null)){
		$.messager.alert("��ʾ","�������ⲻ��Ϊ��","info");
		return;
	}
	var addRet=tkMakeServerCall("web.DHCHM.CQDOLinkDetail","Update",OID,"",row.DOLID);
	if(addRet.split("^")[0]!="0"){
		$.messager.alert("����",addRet.split("^")[1],"error");	
	}else{
		$.messager.alert("��ʾ","����ɹ�","success");
		DOLinkDataGrid.reload();
	}
}

function dolDelt()
{
	var rows = DOLinkDataGrid.getSelections();

	if((rows<=0)){
		$.messager.alert("��ʾ","��ѡ����","info");
		return;
	}
	$.messager.confirm("ɾ��", "ȷ��ɾ���ü�¼?", function (r) {
		if (r) {
			var delRet=tkMakeServerCall("web.DHCHM.CQDOLinkDetail","Detele",rows[0].TID);
			if(delRet!="0"){
				$.messager.alert("����","ɾ��ʧ�ܣ�"+delRet,"error");	
			}else{
				$.messager.alert("��ʾ","ɾ���ɹ�","success");
				DOLinkDataGrid.reload();
			}
		} 
	});
	
}


$(init);