$(function(){
	$("#clearall").click(function(){
		$(".contents").empty();
	});

	$("#pastall").click(function(){
		getAllContent();
	});
	$(document).on("click",".contents li",function(){
		insertText($(this)[0].innerText);
	});
	
	$(document).on("click",".contents li .hisui-linkbutton",function(){
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
	insertText(result);
}

function insertText(text)
{
	parent.insertText(text);
}

function setContent(content)
{
	var li = $('<li></li>');
	$(li).append('<a title="删除" href="#" class="hisui-linkbutton" data-options="iconCls:'+"'icon-cancel'"+',plain:true" onclick="deletelist(this)"/><span class="content">'+content+'</span>');
	$(".contents").append(li);
	$.parser.parse('.contents');
}

function deletelist(obj)
{
	$(obj).parent().remove();
}

//关闭窗口
function closeWindow()
{
	parent.closeTab("剪贴板");
}