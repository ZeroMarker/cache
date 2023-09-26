
function onRowContextMenu(e, rowIndex, rowData){
	e.preventDefault();
	var selected=$("#sourcetablelistDg").datagrid('getRows'); //获取所有行集合对象
	selected[rowIndex].id; //index为当前右键行的索引，指向当前行对象
	$('#sourcetablelistDg').datagrid('selectRow',rowIndex);
	$('#sourceLookUpMm').menu('show', {
	    left:e.pageX,
	    top:e.pageY
	});       
}

function insert(rowId,sourceCode,sourceDesc){
	var row = $('#sourcetablelistDg').datagrid('getSelected');
	if (row){
		var index = $('#sourcetablelistDg').datagrid('getRowIndex', row);
	} else {
		index = 0;
	}
	$('#sourcetablelistDg').datagrid('insertRow', {
		index: index,
		row:{
			rowId:rowId,
			sourceCode:sourceCode,
			sourceDesc:sourceDesc
		}
	});
}

function refursh(input){
	$('#sourcetablelistDg').datagrid({ url:"web.DHCENS.STBLL.UTIL.PageLoad.cls?action=getSourceLookUpTableData&input="+input,method:"get"});
	$('#sourcetablelistDg').datagrid('load');
}

function getSourceTableInfo() {
	var row = $('#sourcetablelistDg').datagrid('getSelected');
	if (row==null) {
		return "";
	}
	return row["rowId"]+"^"+row["sourceCode"]+row["sourceDesc"];
}

function deleteDataGridRow(){
	var row = $('#sourcetablelistDg').datagrid('getSelected');
	if (row==null) {
		return "";
	}
	var index= $('#sourcetablelistDg').datagrid('getRowIndex',row);
	$('#sourcetablelistDg').datagrid('deleteRow',index);
}

function deleteSourceLookUpData() {
	var row = $('#sourcetablelistDg').datagrid('getSelected');
	$.ajax({ 
		type: "get",
		url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=deleteSourceTableDataInfo&input="+row["rowId"],
		dateType: "json",
		success: function(data){
			var obj=eval('('+data+')');
			alert(obj.retinfo);
			if  (obj.retvalue=="0") {
				var index= $('#sourcetablelistDg').datagrid('getRowIndex',row);
				$('#sourcetablelistDg').datagrid('deleteRow',index);
			}
		}
	});
}