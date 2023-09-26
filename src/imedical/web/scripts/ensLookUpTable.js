$(function(){
	$('#lookuptablelist').tree({
		method: "get",     
		animate:true,  
    	lines:true,   
	    url:"web.DHCENS.STBLL.UTIL.PageLoad.cls?action=selectLookUpTableInfoTreeList",
        onClick:function(node){
			$("#dataCode").val("");
			$("#dataDesc").val("");
			$('#lookuptablelist').tree('select', node.target);
			var node = $('#lookuptablelist').tree('getSelected');
			if (node.id!="TOP") {
				sourcelookuptabledatagridlist.window.refursh(node.id);
				targetlookuptabledatagridlist.window.refursh(node.id);
				lookuptabledatagridlist.window.refursh(node.id);
			}
        } ,  
	    onContextMenu: function(e, node){
			e.preventDefault();
			$('#lookuptablelist').tree('select', node.target);
			// 显示上下文菜单
			$('#lookUpTableMm').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		}

	});
	$('#lookUpRuleBtn').click(function(){
		var node = $('#lookuptablelist').tree('getSelected');
		if (node){ 
			$("#startPosition").val("");
			$("#endPosition").val("");		
			$('#lookUpRuleDetail').window('open');
		}
	});
	$('#addBtn').click(function(){	
		var node = $('#lookuptablelist').tree('getSelected');
		if (node){  
			$("#sourceCode").val("");
			$("#sourceDesc").val("");
			$("#targetCode").val("");
			$("#targetDesc").val("");
			$('#lookUpTableData').window('open');
		}
	});
	$('#searchBtn').click(function(){
		var dataCode=$("#dataCode").val();
		var dataDesc=$("#dataDesc").val();
		var node = $('#lookuptablelist').tree('getSelected');
		if (node){ 
			sourcelookuptabledatagridlist.window.refursh(node.id+"^"+dataCode+"^"+dataDesc);
			lookuptabledatagridlist.window.refursh(node.id+"^"+dataCode+"^"+dataDesc);
			targetlookuptabledatagridlist.window.refursh(node.id+"^"+dataCode+"^"+dataDesc);
		}
	});
	$('#lookUpTableClearBtn').click(function(){
		$("#lookUpTableCode").val("");
		$("#lookUpTableDesc").val("");
	})	
});

function appendLookUpTable() {
	$("#lookUpTableCode").val("");
	$("#lookUpTableDesc").val("");
	$("#lookUpTableDiv").window('open');
}

function lookUpTableSaveBtn() {
	var lookUpTableCode=$("#lookUpTableCode").val();
	if (lookUpTableCode=="") {
		alert("请输入表代码");
		return;
	}
	var lookUpTableDesc=$("#lookUpTableDesc").val();
	if (lookUpTableDesc=="") {
		alert("请输入表名称");
		return;
	}	
	var lookUpTableInfo=lookUpTableCode+"^"+lookUpTableDesc;	
	var node = $('#lookuptablelist').tree('getRoot');
	if (node){   
		$.ajax({ 
			type: "get",
			url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=saveLookUpTableInfo&input="+escape(lookUpTableInfo),
			dateType: "json",
			success: function(data){
				var obj=eval('('+data+')');
				if (obj.retvalue=="0") {
					alert("成功");
				    var nodes = [{   
				        "id":obj.retinfo,   
				        "state":"open",
				        "text":lookUpTableDesc 
				    }];   
				    $('#lookuptablelist').tree('append', {   
				        parent:node.target,   
				        data:nodes   
				    });  
					$('#lookUpTableDiv').window('close');
				}
				else{
					alert(obj.retinfo);
				}
			}
		}) 
	}
}

function deleteLookUpTable() {
	$.messager.confirm('提示','请确认删除?',function(r){   
	    if (r){
			var node = $('#lookuptablelist').tree('getSelected');
			if (node){   
				$.ajax({ 
					type: "get",
					url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=deleteLookUpTableInfo&input="+node.id,
					dateType: "json",
					success: function(data){
						var obj=eval('('+data+')');
						if (obj.retvalue=="0") {  
							alert("成功");
			    			$('#lookuptablelist').tree('remove',node.target);
						}
						else{
							alert(obj.retinfo);
						}
					}
				}) 
			}
	    }
	})
}


function lookUpTableDataSaveBtn() { 
	var node = $('#lookuptablelist').tree('getSelected');
	if (node){  
		var sourceCode=$("#sourceCode").val();
		if (sourceCode=="") {
			alert("请输入源数据代码");
			return;
		}
		var sourceDesc=$("#sourceDesc").val();
		if (sourceDesc=="") {
			alert("请输入源数据名称");
			return;
		}
		var targetCode=$("#targetCode").val();
		if (targetCode=="") {
			alert("请输入目标数据代码");
			return;
		}
		var targetDesc=$("#targetDesc").val();
		if (targetDesc=="") {
			alert("请输入目标数据名称");
			return;
		}
		var lookuptableData=node.id+"^"+sourceCode+"^"+sourceDesc+"^"+targetCode+"^"+targetDesc;
		$.ajax({ 
			type: "get",
			url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=saveLookUpTableDataInfo&input="+escape(lookuptableData),
			dateType: "json",
			success: function(data){
				var obj=eval('('+data+')');
				if (obj.retvalue=="0") {  
					alert("成功");
					$('#lookUpTableData').window('close');
					//sourcelookuptabledatagridlist.window.insert(obj.sourceTableDr,sourceCode,sourceDesc);
					//targetlookuptabledatagridlist.window.insert(obj.targetTableDr,targetCode,targetDesc);
					targetlookuptabledatagridlist.window.refursh(node.id+"^^");
					lookuptabledatagridlist.window.insert(obj.lookuptabledata,sourceCode,sourceDesc,targetCode,targetDesc);
				}
				else{
					alert(obj.retinfo);
				}
			}
		}) 
	}
}

function lookUpTableDataClearBtn() {
	$("#sourceCode").val("");
	$("#sourceDesc").val("");
	$("#targetCode").val("");
	$("#targetDesc").val("");
}

function getTreeNodeId() {
	var node = $('#lookuptablelist').tree('getSelected');
	return node.id;
}

function canCelRelevanceInfo(input) {
	var dataCode=$("#dataCode").val();
	var dataDesc=$("#dataDesc").val();
	var node = $('#lookuptablelist').tree('getSelected');
	if (node){ 
		sourcelookuptabledatagridlist.window.refursh(node.id+"^"+dataCode+"^"+dataDesc);
		targetlookuptabledatagridlist.window.refursh(node.id+"^"+dataCode+"^"+dataDesc);
	}		
}

function relevanceInfo() {
	var dataCode=$("#dataCode").val();
	var dataDesc=$("#dataDesc").val();
	var sourceInfo=sourcelookuptabledatagridlist.window.getSourceTableInfo();
	var targetInfo=targetlookuptabledatagridlist.window.getTargetTableInfo();
	if (sourceInfo=="") {
		alert("请选中关联源数据行");
		return;
	}
	if (targetInfo=="") {
		alert("请选中关联目标数据行");
		return;
	}
	var sourceArr=sourceInfo.split("^");
	var targetArr=targetInfo.split("^");
	var node = $('#lookuptablelist').tree('getSelected');
	if (node){ 
		var relevanceInfo=node.id+"^"+sourceArr[0]+"^"+targetArr[0];
		$.ajax({ 
			type: "get",
			url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=relevanceInfo&input="+relevanceInfo,
			dateType: "json",
			success: function(data){
				var obj=eval('('+data+')');
				if (obj.retvalue=="0") {  
					alert("成功");
					sourcelookuptabledatagridlist.window.deleteDataGridRow();
					//targetlookuptabledatagridlist.window.deleteDataGridRow();
					lookuptabledatagridlist.window.refursh(node.id+"^"+dataCode+"^"+dataDesc);
				}
				else{
					alert(obj.retinfo);
				}
			}
		}) 
	}
}

function cancleRuleBtn() {
	$('#lookUpRuleDetail').window('close');	
}

function saveRuleBtn() {
	alert("功能为实现");
}