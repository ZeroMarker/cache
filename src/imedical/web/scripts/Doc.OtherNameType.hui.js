var PageLogicObj={
	m_otherNameTypeTabDataGrid:""
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
	PageLogicObj.m_otherNameTypeTabDataGrid=InitotherNameTypeTabDataGrid();
}
function InitEvent(){
	$('#BSave').click(BSaveClickHandle);
}
function PageHandle(){
	IntOtherNameTypeTabData();
}
function InitotherNameTypeTabDataGrid(){
	var Columns=[[ 
		{field:'NameTypeRowId',title:'',hidden:'true'},
		{field:'NameTypeDesc',title:'姓名类型',width:220,align:'left'},
		{field:'Name',title:'姓名',width:234,align:'left',
			editor : {
                    type : 'text'
           }
		}
    ]]
	var otherNameTypeTabDataGrid=$("#otherNameTypeTab").datagrid({
		fit : false,
		//height:'220',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:false,
		pagination : false,  
		idField:'NameTypeRowId',
		columns :Columns,
		onClickCell: function(index,field,value){
			if (field=="Name"){
				$(this).datagrid('beginEdit', index);
				var ed = $(this).datagrid('getEditor', {index:index,field:field});
				$(ed.target).focus();
			}
		}
	}); 
	return otherNameTypeTabDataGrid;
}
function BSaveClickHandle(){
	var retData="";
	var data=PageLogicObj.m_otherNameTypeTabDataGrid.datagrid('getData');
	for (var i=0;i<data['rows'].length;i++){
		PageLogicObj.m_otherNameTypeTabDataGrid.datagrid('endEdit',i);
		var id=data['rows'][i]['NameTypeRowId'];
		var Name=data['rows'][i]['Name'];
		if (retData==""){
		 	retData=id+'^'+Name;
		}else{
			retData=retData+'!'+id+'^'+Name;	 
		}
	}
	window.parent.NameTypeSave(retData);
	window.parent.destroyDialog('OtherNameInfoManager');
}
function IntOtherNameTypeTabData(){
	//21^11!22^33!23^44!24^!25^
	var NameTypeList=$.cm({
		ClassName:"web.UDHCOPOtherLB",
		MethodName:"GetNameType",
		dataType:"text"
	},false);
	for (var i=0;i<NameTypeList.split("^").length;i++){
		var id=NameTypeList.split("^")[i].split("!")[0];
		var desc=NameTypeList.split("^")[i].split("!")[1];
		PageLogicObj.m_otherNameTypeTabDataGrid.datagrid('appendRow',{
			NameTypeRowId: id,
			NameTypeDesc: desc,
			Name: ''
		});
		PageLogicObj.m_otherNameTypeTabDataGrid.datagrid('beginEdit',i);
	}
	if (ServerObj.OtherNameInfo!=""){
		for (var i=0;i<ServerObj.OtherNameInfo.split("!").length;i++){
			var id=ServerObj.OtherNameInfo.split("!")[i].split("^")[0];
			var name=ServerObj.OtherNameInfo.split("!")[i].split("^")[1];
			var index=PageLogicObj.m_otherNameTypeTabDataGrid.datagrid('getRowIndex',id);
			if (index>=0){
				PageLogicObj.m_otherNameTypeTabDataGrid.datagrid('updateRow',{
					index: index,
					row: {
						Name: name
					}
				});
				PageLogicObj.m_otherNameTypeTabDataGrid.datagrid('beginEdit',index);
			}
		}
	}
}
