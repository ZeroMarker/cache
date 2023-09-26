$(function(){	
	var memeText = window.dialogArguments.memoText;
	var instanceId = window.dialogArguments.instanceId; 
    
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
						alert('备注修改成功!');	
						closeWindow();
					}
					else
					{
						alert('备注修改失败!')	
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
		window.opener = null;
		window.open('', '_self');
		window.close();
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