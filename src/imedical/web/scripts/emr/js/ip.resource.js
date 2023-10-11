$(function(){
	initResource();
	$('#resources').tabs({tabPosition:resourceTabLocation});
	
});	
var framRecord = parent;
//初始化资源区
function initResource()
{
	$(".tabs-brand").css("font-weight","bold");
	for(i=0;i<resourceScheme.length;i++ ){
		var content = "<iframe id='fram" + resourceScheme[i].id + "' frameborder='0' src='' style='width:100%; height:100%;scrolling:no;margin:0px;'></iframe>"	
		addTab("tab"+resourceScheme[i].id,emrTrans(resourceScheme[i].title),content,false,false);
	}	
	$('#resources').tabs('select',1);
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
        if ((title == "质控提示")||(title == "病历参考"))
        {
            parent.resize(title);
        }
        else
        {
            parent.resize("病历资源");
            var tab = $('#resources').tabs('getTab',index);
            var i = index - 1;
            if (resourceScheme[i])
            {
                var width = parseInt(resourceScheme[i].width);
                if (width == ""){
                    width = 400;
                    if(tab[0].id != "tabKBTree"){
                        width = 600;
                    }
                }
                var tbIframe = $("#"+tab[0].id+" iframe:first-child");
                //if (tbIframe.attr("src") == ""){
                
                tbIframe.attr("src",formatSrc(resourceScheme[i].source));
                
                //}
                if (width != "") {
                    parent.resize("",width); //单个tab签设定宽度
                }
            }
        }
    }
});

//格式化 Src
function formatSrc(src)
{
    var src = src.replace(/\[episodeID\]/g, episodeID);
    
    if (src.indexOf("MWToken") == -1)
    {
	    if (src.indexOf("?") == -1)
    	{
			src = src + "?MWToken="+getMWToken();
    	}
    	else
    	{
	    	src = src + "&MWToken="+getMWToken();
	    }
	}
    return src;
}

//刷新知识库
function eventReflashKBNode(commandParam)
{
	if ((!document.getElementById("framKBTree"))||(!document.getElementById("framKBTree").contentWindow.GetKBNodeByTreeID)||(!commandParam)) return;
	kbParam = commandParam;
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
		if (!document.getElementById("framclipboard")) return;
		document.getElementById("framclipboard").contentWindow.setContent(commandParam.args.Value);
	}
	else if (commandParam["action"] == "appendComposite")  
	{
        if (commandParam["Type"] == "DP"){
            framRecord.appendDPComposite(commandParam["KBNodeID"]);
        }else {
            framRecord.appendComposite(commandParam["NodeID"]);
        }
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
