$(function(){
	initResource();
});	
var framRecord = parent.window.frames["framRecord"];
//初始化资源区
function initResource()
{
	var kbTree = "<iframe id='framKBTree' frameborder='0' src='emr.resource.kbtree.csp' style='width:100%; height:100%;scrolling:no;margin:0px;'></iframe>"				
	addTab("tabKBTree","知识库",kbTree,false,true);
	resourceScheme = getResourceScheme();
	for(i=0;i<resourceScheme.length;i++ ){
		var content = "<iframe id='fram" + resourceScheme[i].id + "' frameborder='0' src='' style='width:100%; height:100%;scrolling:no;margin:0px;'></iframe>"	
		addTab("tab"+resourceScheme[i].id,resourceScheme[i].title,content,false,false);
	}	
}
//资源区scheme
function getResourceScheme()
{
	strXml = convertToXml(resourceScheme);
    var objResourceScheme = new Array();
    $(strXml).find("resource>item").each(function(){
	    var id = $(this).find("id").text();
	    var title = $(this).find("title").text();
	    var source = $(this).find("source").text();
	    var width = $(this).find("width").text();
	    objResourceScheme.push({id:id,title:title,source:source,width:width})
    });
    return objResourceScheme;
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
$("#resources").tabs({
	fit:true,
	tabPosition:"right",
	border:false,
	headerWidth:70,
	tabHeight:28,
	onSelect: function(title,index){
		var tab = $('#resources').tabs('getTab',index);
		var width = 300;
		if (tab[0].id != "tabKBTree")
		{
			if (resourceScheme[index-1])
			{
				width = parseInt(resourceScheme[index-1].width);
				var tbIframe = $("#"+tab[0].id+" iframe:first-child");
				if (tbIframe.attr("src") == "") tbIframe.attr("src",resourceScheme[index-1].source);
			}
		}
		parent.resourceResize(width);
	}
});	

//刷新知识库
function eventReflashKBNode(commandParam)
{
	if ((!window.frames["framKBTree"].GetKBNodeByTreeID)||(!commandParam)) return;
	window.frames["framKBTree"].GetKBNodeByTreeID(commandParam);
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
}
