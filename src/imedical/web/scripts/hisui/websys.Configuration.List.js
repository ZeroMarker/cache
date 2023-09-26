var closeHospWinCallback = function(obj){
	$("#twebsys_Configuration_List").datagrid("load");
}
var init = function(){
	/*$("#twebsys_Configuration_List").datagrid("options").onDblClickRow = function(rowIndex, rowData){
		GenHospWin("websys.Configuration",rowData["RowId"],closeHospWinCallback,{singleSelect:true});
	};*/
	
	var comp = GenHospComp("websys.Configuration","",{width:250});
	comp.options().onSelect = function(ind,row){
			setValueById('SingleHospId',row.HOSPRowId)
			$('#Find').click();
	}
	$('#New').click(function(){
		if ($("#twebsys_Configuration_List").datagrid("getData").total>0){
			$.messager.alert("提示","此医院已有配置不能新建配置");
			return;
		}
		if (!$(this).linkbutton('options').disabled){
			websys_lu("websys.default.csp?WEBSYS.TCOMPONENT=websys.Configuration.Edit&IsNew=1&SingleHospId="+comp.getValue());
		}
	});
}
$(init);