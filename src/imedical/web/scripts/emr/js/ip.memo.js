$(function(){	
	if (paramSummaryStr != "")
	{
		var opts = JSON.parse(unescape(utf8to16(base64decode(paramSummaryStr)))); 
		var memeText = opts.memoText;
		var instanceId = opts.instanceId;  
	}
	else
	{
		var memeText = window.dialogArguments.memoText;
		var instanceId = window.dialogArguments.instanceId;
	}
	var memeTextOld = getMemeTextOld(instanceId);
	memeText = memeTextOld+" "+memeText;
	$('#memoText').val(memeText);
	//保存备注信息
	$('#memoSure').click(function(){
		var memoText = $('#memoText').val();
		memoText = stringTJson(memoText);
		if (memoText.length > 1000)
		{
			alert("备注内容超出1000字数限制");
		}else{
			$.ajax({ 
	       		type: "post", 
				url: "../EMRservice.Ajax.common.cls", 
				data: {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLInstanceData",
					"Method":"SetDocumentMemo",
					"p1":instanceId,
					"p2":memoText
				},
				error: function (XMLHttpRequest, textStatus, errorThrown) { 
					alert(textStatus); 
				}, 
				success: function (data) { 
					if (data == "1")
					{
						$.messager.confirm("操作提示", "备注修改成功!是否关闭编辑备注页面？", function (data) {
							if (data)
							{   
							   closeWindow();
							}
						});
					}
					else
					{
						$.messager.alert("提示", "备注修改失败!");
					}
				}  
			});			
		}		
	});
	
	//取消或关闭编辑备注
	$("#memoCancel").click(function(){
		closeWindow();	
	});	
	
	//关闭窗口
	function closeWindow() {
		parent.closeDialog("memoDialog");
	}
	//取原来的备注
	function getMemeTextOld(InstanceID){
		var result="";
		$.ajax({ 
			type: "post", 
			url: "../EMRservice.Ajax.common.cls", 
			async:false,
			data: {
				"OutputType":"Stream",
				"Class":"EMRservice.BL.BLInstanceData",
				"Method":"GetDocumentMemo",
				"p1":InstanceID
			},
			error: function (XMLHttpRequest, textStatus, errorThrown) { 
				alert(textStatus); 
			}, 
			success: function (data) {
				result=data;
			} 
		});
		return result
	}
});