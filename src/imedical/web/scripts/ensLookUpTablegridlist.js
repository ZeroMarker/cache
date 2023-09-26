
function insert(rowId,sourceCode,sourceDesc,targetCode,targetDesc){
	var row = $('#lookuptablelistDg').datagrid('getSelected');
	if (row){
		var index = $('#lookuptablelistDg').datagrid('getRowIndex', row);
	} else {
		index = 0;
	}
	$('#lookuptablelistDg').datagrid('insertRow', {
		index: index,
		row:{
			rowId:rowId,
			sourceCode:sourceCode,
			sourceDesc:sourceDesc,
			targetCode:targetCode,
			targetDesc:targetDesc			
		}
	});
}

function refursh(input){
	$('#lookuptablelistDg').datagrid({ url:"web.DHCENS.STBLL.UTIL.PageLoad.cls?action=getLookUpTableData&input="+input,method:"get"});
	$('#lookuptablelistDg').datagrid('load');
}

function canCelRelevanceInfo() {
	var row = $('#lookuptablelistDg').datagrid('getSelected');
	if (row==null) {
		alert("请选中取消关联数据行");
		return;
	}
	var index= $('#lookuptablelistDg').datagrid('getRowIndex',row)
	$.ajax({ 
		type: "get",
		url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=canCelRelevanceInfo&input="+row["rowId"],
		dateType: "json",
		success: function(data){
			var obj=eval('('+data+')');
			if (obj.retvalue=="0") {  
				alert("成功");
				$('#lookuptablelistDg').datagrid('deleteRow',index);
				parent.canCelRelevanceInfo();
			}
			else{
				alert(obj.retinfo);
			}
		}
	})	
}

function relevanceInfo() {
	parent.relevanceInfo();
}