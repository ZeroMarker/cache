$(function(){
	initResource();
});	
var framRecord = parent.parent.editPage;
//初始化资源区
function initResource()
{
	for(i=0;i<resourceScheme.length;i++ ){
		var content = "<iframe id='fram" + resourceScheme[i].id + "' frameborder='0' src='' style='width:100%; height:100%;scrolling:no;margin:0px;'></iframe>"	
		addTab("tab"+resourceScheme[i].id,emrTrans(resourceScheme[i].title),content,false,false);
	}	
	$('#resources').tabs('select',0);
}

//增加tab标签
function addTab(tabId,tabTitle,content,closable,selected)
{	
		$('#resources').tabs('add',{
			id:       tabId ,
			title:    tabTitle,
			content:  content,
			closable: closable,
			selected: selected	
	   });	
}

//添加资源区
function addClipboardTab(id,title,content,closable)
{
   if($('#resources').tabs('exists',title)){
   	   $('#resources').tabs('select',title);
   }else{	
	   $('#resources').tabs('add',{
		    id: id,
			title: title,
			content: content,
			closable: closable
	   });
   }
   
}

//点击tab改变资源区大小
$HUI.tabs("#resources",{
	onSelect: function(title,index){
		var tab = $('#resources').tabs('getTab',index);
		if (resourceScheme[index])
		{
			var tbIframe = $("#"+tab[0].id+" iframe:first-child");
			if (tbIframe.attr("src") == "") tbIframe.attr("src",formatSrc(resourceScheme[index].source));
		}
	}
});	

//格式化 Src
function formatSrc(src)
{
    var src = src.replace(/\[episodeID\]/g, episodeID);
    return src;
}

//刷新知识库
function eventReflashKBNode(commandParam)
{
	if ((!document.getElementById("framKBTree").contentWindow.GetKBNodeByTreeID)||(!commandParam)) return;
	document.getElementById("framKBTree").contentWindow.GetKBNodeByTreeID(commandParam);
}

function getElementContext()
{
	if (!framRecord) return; 
	framRecord.getElementContext();
}

///判断当前文档的只读状态
function getReadOnlyStatus()
{
	if (!framRecord) return; 
	var result = framRecord.getReadOnlyStatus().ReadOnly;
	return result;
}

//插入内容
function eventDispatch(commandParam)
{
	if (!framRecord) return; 
	if (commandParam["action"] == "insertText")   
	{
		//插入文本
		framRecord.insertText(commandParam["text"]);
	}
	else if (commandParam["action"] == "INSERT_STYLE_TEXT_BLOCK")
	{
		framRecord.cmdDoExecute(commandParam);
	}
	else if (commandParam["action"] == "eventSendCopyCutData")
	{
		if (!window.frames["framclipboard"]) return;
		window.frames["framclipboard"].setContent(commandParam.args.Value);
	}
	else if (commandParam["action"] == "appendComposite")  
	{
		framRecord.appendComposite(commandParam["NodeID"]);
	}
	else if (commandParam["action"] == "replaceComposite")  
	{
		framRecord.replaceComposite(commandParam["NodeID"]);
	}
		else if(commandParam["action"] == "SAVE_SECTION")
	{
		return framRecord.saveSection(commandParam.args);	
	}
	else if(commandParam["action"] == "CREATE_DOCUMENT_BY_INSTANCE")
	{
		parent.operateRecord(commandParam.args);
	}
	else if(commandParam["action"] == "GET_DOCUMENT_CONTEXT")
	{
		return framRecord.getDocumentContext();
	}
	else
	{
		framRecord.cmdDoExecute(commandParam);
	}
}
