var PageLogicObj={
	m_otherCredTypeTabDataGrid:""
}
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
})
function Init(){
	PageLogicObj.m_otherCredTypeTabDataGrid=InitotherCredTypeTabDataGrid();
}
function InitEvent(){
	$('#BSave').click(BSaveClickHandle);
}
function PageHandle(){
	IntOtherCredTypeTabData();
}
function InitotherCredTypeTabDataGrid(){
	var Columns=[[ 
		{field:'CredTypeRowId',title:'',hidden:'true'},
		{field:'CredTypeDesc',title:'证件类型',width:220,align:'left'},
		{field:'CredNum',title:'证件号码',width:234,align:'left',
			editor : {
                    type : 'text'
           }
		}
    ]]
	var otherCredTypeTabDataGrid=$("#otherCredTypeTab").datagrid({
		fit : false,
		//height:'220',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:false,
		pagination : false,  
		idField:'CredTypeRowId',
		columns :Columns,
		onClickCell: function(index,field,value){
			if (field=="CredNum"){
				$(this).datagrid('beginEdit', index);
				var ed = $(this).datagrid('getEditor', {index:index,field:field});
				$(ed.target).focus();
			}
		}
	}); 
	return otherCredTypeTabDataGrid;
}
function BSaveClickHandle(){
	var retData="";
	var data=PageLogicObj.m_otherCredTypeTabDataGrid.datagrid('getData');
	for (var i=0;i<data['rows'].length;i++){
		PageLogicObj.m_otherCredTypeTabDataGrid.datagrid('endEdit',i);
		var id=data['rows'][i]['CredTypeRowId'];
		var CredNum=data['rows'][i]['CredNum'];
		if (retData==""){
		 	retData=id+'^'+CredNum;
		}else{
			retData=retData+'!'+id+'^'+CredNum;	 
		}
	}
	window.parent.CardTypeSave(retData);
	window.parent.destroyDialog('OtherCredTypeManager');
}
function IntOtherCredTypeTabData(){
	//21^11!22^33!23^44!24^!25^
	var CredTypeList=$.cm({
		ClassName:"web.UDHCOPOtherLB",
		MethodName:"GetCredType",
		dataType:"text"
	},false);
	for (var i=0;i<CredTypeList.split("^").length;i++){
		var id=CredTypeList.split("^")[i].split("!")[0];
		var desc=CredTypeList.split("^")[i].split("!")[1];
		PageLogicObj.m_otherCredTypeTabDataGrid.datagrid('appendRow',{
			CredTypeRowId: id,
			CredTypeDesc: desc,
			CredNum: ''
		});
		PageLogicObj.m_otherCredTypeTabDataGrid.datagrid('beginEdit',i);
	}
	if (ServerObj.OtherCardInfo!=""){
		for (var i=0;i<ServerObj.OtherCardInfo.split("!").length;i++){
			var id=ServerObj.OtherCardInfo.split("!")[i].split("^")[0];
			var num=ServerObj.OtherCardInfo.split("!")[i].split("^")[1];
			var index=PageLogicObj.m_otherCredTypeTabDataGrid.datagrid('getRowIndex',id);
			if (index>=0){
				PageLogicObj.m_otherCredTypeTabDataGrid.datagrid('updateRow',{
					index: index,
					row: {
						CredNum: num
					}
				});
				PageLogicObj.m_otherCredTypeTabDataGrid.datagrid('beginEdit',index);
			}
		}
	}
}
