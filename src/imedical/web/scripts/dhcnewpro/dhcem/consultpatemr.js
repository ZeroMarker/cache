///��ʼ������
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
		$.messager.alert("������ʾ:","������ؿؼ�����,��ˢ�����¼���!");
	}
});

//���tab�ı���Դ����С
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

//��ʼ����Դ��
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

//��Դ��scheme
function getResourceScheme()
{
	/*
	var jsonObj = $.parseJSON(resourceScheme.replace(/'/g,"\""));//ת��Ϊjson����
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

//����tab��ǩ
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

///�ַ�����xml
function convertToXml(xmlString)
{ 
    var xmlDoc=null;
    //�ж������������
    //֧��IE����� 
    if(!window.DOMParser && window.ActiveXObject){   //window.DOMParser �ж��Ƿ��Ƿ�ie�����
        var xmlDomVersions = ['MSXML.2.DOMDocument.6.0','MSXML.2.DOMDocument.3.0','Microsoft.XMLDOM'];
        for(var i=0;i<xmlDomVersions.length;i++)
        {
            try
            {
                xmlDoc = new ActiveXObject(xmlDomVersions[i]);
                xmlDoc.async = false;
                xmlDoc.loadXML(xmlString); //loadXML��������xml�ַ���
                break;
            }catch(e){ }
        }
    }
    //֧��Mozilla�����
    else if(window.DOMParser && document.implementation && document.implementation.createDocument)
    {
		try{
		    /* DOMParser ������� XML �ı�������һ�� XML Document ����
		     * Ҫʹ�� DOMParser��ʹ�ò��������Ĺ��캯����ʵ��������Ȼ������� parseFromString() ����
		     * parseFromString(text, contentType) ����text:Ҫ������ XML ��� ����contentType�ı�����������
		     * ������ "text/xml" ��"application/xml" �� "application/xhtml+xml" �е�һ����ע�⣬��֧�� "text/html"��
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
		//�����ı�
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

///��������
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
		alert("�������ݳ���!"+ex.Message)
	}
}

window.onbeforeunload=function(event){
	$.messager.confirm('�رմ�����ʾ', '�Ƿ񱣴�༭����?', function(truth){
		if (truth){
			SaveData();
		}
	});
} 

	