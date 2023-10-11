$(function() {
    if( isModify == "Y")
    {
		initData();    
	}
    
	$("#publicSave").click(function(){
		var nodeText = $("#nodeText").val();
		if (nodeText == "") {
			$.messager.alert("提示信息", '请输入节点名称');	
			return;
		}
		var content = $("#nodeVaue").val();
		var content = content.replace(/\"/g, "&quot;");
		jQuery.ajax({
			type: "POST",
			dataType: "text",
			url: "../EMRservice.Ajax.common.cls",
			async: true,
			data: {
				"OutputType":"String",
				"Class":"EMRservice.BL.BLTextKBContent",
				"Method":"NewData",
				"p1":nodeID,
				"p2":content,
				"p3":userCode,
				"p4":nodeText,
				"p5":isModify
			},
			success: function(d) {
				if (d !== "1") {
					$.messager.alert("提示信息",'新增数据失败,失败代码'+d);
				}else {
					$.messager.alert("提示信息",'已保存并自动审核');
					closeWindow();
				}
			},
			error : function(d) { alert("NewData error");}
		});	
	});
});

function initData(){
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLTextKBContent",
			"Method":"GetContent",
			"p1":nodeID
		},
		success: function(d) {
			d = d.replace(/<br\s*\/?>/g, "\n");
			d = d.replace(/&nbsp;/g," ");
			d = d.replace(/&quot;/g, "\"");
			$("#nodeVaue").val(d);
		},
		error : function(d) { alert("GetContent error");}
	});	
	$("#nodeText").val(nodeName);
}

//关闭窗口
function closeWindow()
{
    if((parent)&&(parent.closeDialog)){
		parent.closeDialog("HisUIKnowledgebaseText");
	}
}