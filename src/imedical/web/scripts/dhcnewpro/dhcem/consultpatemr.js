///初始化方法
var bedTypeStore=[];
var thisWindow=null;
var retObj=new Object();

$(window).load(function(){
	try
	{
		var args = window.dialogArguments;
		if (args)
		{
			thisWindow = args.window;
			textValue = args.text;
		}
		else
		{
			thisWindow=window.opener;
		}
		
		$("#EditPanel").val(textValue);
		initResource();
		
		
	}
	catch(ex)
	{
		$.messager.alert("错误提示:","界面加载控件出错,请刷新重新记载!");
	}
});

//点击tab改变资源区大小
$(function(){
	$("#resources").tabs({
		onSelect: function(title,index){
			var tab = $('#resources').tabs('getTab',index);
			var width = 300;
			if(tab[0].id != "tabKBTree")
			{
				if (resourceScheme[index])
				{
					width = parseInt(resourceScheme[index].width);
					var tbIframe = $("#"+tab[0].id+" iframe:first-child");
					if (tbIframe.attr("src") == "")
					{
						tbIframe.attr("src",resourceScheme[index].source);
					}
				}
			}
			$('.hisui-layout').layout('panel', 'east').panel('resize',{width:width});
			$('.hisui-layout').layout('resize');
		}
	});
});

//初始化资源区
function initResource()
{
	resourceScheme = getResourceScheme();
	for(i=0;i<resourceScheme.length;i++ ){
		var content = "<iframe id='fram" + resourceScheme[i].id + "' frameborder='0' src='' style='width:100%; height:98.5%;overflow:hidden;margin-top:5px;'></iframe>"	
		var select = false;
		if (i == 0) select = true;
		addTab("resources","tab"+resourceScheme[i].id,resourceScheme[i].title,content,false,select);
	}
}

//资源区scheme
function getResourceScheme()
{
	/*
	var jsonObj = $.parseJSON(resourceScheme.replace(/'/g,"\""));//转换为json对象
	var objResourceScheme = new Array();
	for(var i=0;i<jsonObj.length;i++){
		var id = jsonObj[i].id;
	    var title = jsonObj[i].title;
	    var source = jsonObj[i].source;
	    var width = jsonObj[i].width;
	    objResourceScheme.push({id:id,title:title,source:source,width:width})
	}
	*/
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
function addTab(ctrlId,tabId,tabTitle,content,closable,selected)
{
	$('#'+ctrlId).tabs('add',{
	    id:       tabId ,
		title:    tabTitle,
		content:  content,
		closable: closable,
		selected: selected	
   });	
}

///字符串传xml
function convertToXml(xmlString)
{ 
    var xmlDoc=null;
    //判断浏览器的类型
    //支持IE浏览器 
    if(!window.DOMParser && window.ActiveXObject){   //window.DOMParser 判断是否是非ie浏览器
        var xmlDomVersions = ['MSXML.2.DOMDocument.6.0','MSXML.2.DOMDocument.3.0','Microsoft.XMLDOM'];
        for(var i=0;i<xmlDomVersions.length;i++)
        {
            try
            {
                xmlDoc = new ActiveXObject(xmlDomVersions[i]);
                xmlDoc.async = false;
                xmlDoc.loadXML(xmlString); //loadXML方法载入xml字符串
                break;
            }catch(e){ }
        }
    }
    //支持Mozilla浏览器
    else if(window.DOMParser && document.implementation && document.implementation.createDocument)
    {
		try{
		    /* DOMParser 对象解析 XML 文本并返回一个 XML Document 对象。
		     * 要使用 DOMParser，使用不带参数的构造函数来实例化它，然后调用其 parseFromString() 方法
		     * parseFromString(text, contentType) 参数text:要解析的 XML 标记 参数contentType文本的内容类型
		     * 可能是 "text/xml" 、"application/xml" 或 "application/xhtml+xml" 中的一个。注意，不支持 "text/html"。
		     */
		    domParser = new  DOMParser();
		    xmlDoc = domParser.parseFromString(xmlString, 'text/xml');
		}catch(e){}
    }
    else
    {
        return null;
    }
    return xmlDoc;
}

function eventDispatch(obj)
{
	if (!obj) return;
	if(obj["action"] == "insertText")   
	{
		//插入文本
		insertText(obj.text);
	}
	else if (obj["action"] == "INSERT_STYLE_TEXT_BLOCK")
	{
		insertObjText(obj.args);
	}
}

function insertText(texts)
{
	if (texts == "") return;
	if (texts == undefined) return;
	title=""
	try
	{
		/*var tab = $('#resources').tabs('getSelected');
		if (tab)
		{
			title = tab.panel('options').tab[0].innerText
		}
		if (title != "") title = title + ":";*/
		$("#EditPanel").insertContent(texts);
	}catch(ex){}
}

function insertObjText(textobj)
{
	if (!textobj) return;
	var textItem = textobj.items
	if (!textItem) return;
	if (textItem.length < 1) return;
	var texts = "";
	for (var i = 0 ; i < textItem.length; i++)
	{
		var text = textItem[i].TEXT;
		if (text == "") continue;
		texts = texts=="" ? text : texts + "\n" + text
	}
	insertText(texts);
}

///保存数据
function SaveData()
{
	try
	{
		if ((targetName != "")&&(thisWindow))
		{
			var objs = thisWindow.Ext.getCmp(targetName);
			if (objs) objs.setValue($("#EditPanel").val())
		}
		else
		{
			retObj.innertTexts = $("#EditPanel").val();
			window.returnValue = retObj; 
		}
		window.close();
	}catch(ex){
		alert("保存数据出错!"+ex.Message)
	}
}

window.onbeforeunload=function(event){
	$.messager.confirm('关闭窗口提示', '是否保存编辑内容?', function(truth){
		if (truth){
			SaveData();
		}
	});
} 

	