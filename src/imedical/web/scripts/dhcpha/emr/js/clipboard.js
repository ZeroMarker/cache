$(function(){

	$("#close").click(function(){
		closeWindow();
	});
	
	$("#clearall").click(function(){
		$(".contents").empty();
	});

	$("#pastall").click(function(){
		getAllContent();
	});
	
	$(".contents li .content").live("click",function(){
		var param = {"action":"insertText","text":$(this)[0].innerText}
		parent.eventDispatch(param); 
	});
	
	$(".contents li .remove").live("click",function(){
		$(this).parent().remove();
	});
		
});

function getAllContent(){   
	var result = "";
	var liLength = $(".contents li").length;   
	for(var i = 0; i < liLength; i++){    
	    var inputElement = $(".contents li .content")[i];     
        result = result+inputElement.innerText;
	}   
	var param = {"action":"insertText","text":result}
	parent.eventDispatch(param); 
}


function setContent(content)
{
	var li = $('<li></li>');
	$(li).append('<span class="content">'+content+'</span><input type="button" class="remove" value="删除" />');
	$(".contents").append(li);
}

//关闭窗口
function closeWindow()
{
	parent.$('#resources').tabs('close',"剪贴板");
}