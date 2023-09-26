

function onRowContextMenu(e, rowIndex, rowData){
	e.preventDefault();
	var selected=$("#targettablelistDg").datagrid('getRows'); //获取所有行集合对象
	selected[rowIndex].id; //index为当前右键行的索引，指向当前行对象
	$('#targettablelistDg').datagrid('selectRow',rowIndex);
	$('#targetLookUpMm').menu('show', {
		left:e.pageX,
		top:e.pageY
	});       
}

function insert(rowId,targetCode,targetDesc){
	var row = $('#targettablelistDg').datagrid('getSelected');
	if (row){
		var index = $('#targettablelistDg').datagrid('getRowIndex', row);
	} else {
		index = 0;
	}
	$('#targettablelistDg').datagrid('insertRow', {
		index: index,
		row:{
			rowId:rowId,
			targetCode:targetCode,
			targetDesc:targetDesc
		}
	});
}

function refursh(input){
	$('#targettablelistDg').datagrid({ url:"web.DHCENS.STBLL.UTIL.PageLoad.cls?action=getTargetLookUpTableData&input="+input,method:"get"});
	$('#targettablelistDg').datagrid('load');
}

function getTargetTableInfo() {
	var row = $('#targettablelistDg').datagrid('getSelected');
	if (row==null) {
		return "";
	}
	return row["rowId"]+"^"+row["targetCode"]+row["targetDesc"];;
}


function deleteDataGridRow(){
	var row = $('#targettablelistDg').datagrid('getSelected');
	if (row==null) {
		return "";
	}
	var index= $('#targettablelistDg').datagrid('getRowIndex',row)
	$('#targettablelistDg').datagrid('deleteRow',index);
}

function deleteTargetLookUpData(){
	var nodeId=parent.getTreeNodeId();
	var row = $('#targettablelistDg').datagrid('getSelected');
	var input=nodeId+"^"+row["rowId"];
	$.ajax({ 
		type: "get",
		url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=deleteTargetTableDataInfo&input="+input,
		dateType: "json",
		success: function(data){
			var obj=eval('('+data+')');
			alert(obj.retinfo);
			if  (obj.retvalue=="0") {
				var index= $('#targettablelistDg').datagrid('getRowIndex',row);
				$('#targettablelistDg').datagrid('deleteRow',index);
			}
		}
	});
}