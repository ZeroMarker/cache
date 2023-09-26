
$(function(){ 
	document.onkeydown = function(e){ 
    var ev = document.all ? window.event : e;
    	if(ev.keyCode==13) {
			commonQuery({'datagrid':'#datagrid','formid':'#toolbar'})
     	}
	}
	
	start=(new Date()).Format("yyyy-M-d")
	$('#queryStart').datebox('setValue', start);
	$('#queryEnd').datebox('setValue', start);
	commonQuery({'datagrid':'#datagrid','formid':'#toolbar'});
});


function edit(){
	var rowsData = $("#datagrid").datagrid('getSelected')
	if (rowsData == null) {
		$.messager.alert("提示","请选择表单!");
		return;
	}
	window.open("layoutform.csp?recordId="+rowsData.ID+"&code="+rowsData.code)
}

function showDetailNew(){
	var rowsData = $("#datagrid").datagrid('getSelected')
	if (rowsData == null) {
		$.messager.alert("提示","请选择表单!");
		return;	
	}
	window.open("layoutform.csp?recordId="+rowsData.ID+"&code="+rowsData.code)
	//window.open("formrecorditm.csp?recordId="+rowsData.ID)
}

function printRecord(){
	var rowsData = $("#datagrid").datagrid('getSelected')
	if (rowsData == null) {
		$.messager.alert("提示","请选择表单!");
		return;	
	}
	window.open("formprint.csp?recordId="+rowsData.ID)
}