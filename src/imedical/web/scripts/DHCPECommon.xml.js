/// DHCPECommon.xml.js
/// 创建时间		2006.10.31
/// 创建人		xuwm
/// 主要功能		处理与XML/XSL有关的功能
/// 对应表		
/// 最后修改时间	
/// 最后修改人	
/// 完成

function load_xmln(obj, xmlobj, xslfn) {
	try {
		var hiddenxml = xmlobj.innerHTML;
		var myxml = new ActiveXObject("MSXML2.FreeThreadedDOMDocument");
		myxml.async = false;	
		myxml.loadXML(hiddenxml);
		var myxsl = new ActiveXObject("MSXML2.FreeThreadedDOMDocument");
		myxsl.async = false;		
		myxsl.load(xslfn);
		
		var html = myxml.transformNode(myxsl);
		obj.innerHTML = html;
	}
		catch (exception) {
		alert(exception.description);
		obj.innerHTML = exception.description;
	}	
}
// 从XMl元素(对象)生成
// 要执行(depth)等xsl函数
// 要求:
// 		xsl的ns使用 http://www.w3.org/TR/WD-xs
//				<xsl:stylesheet xmlns:xsl="" language="JavaScript">
function load_xmlnFromXMLObject(obj, xmlobj, xslfn) {

	var xmlDoc
	var xslDoc

	var hiddenxml = xmlobj.innerHTML;
	//alert("xmlobj.innerHTML:"+hiddenxml+";");
	xmlDoc = new ActiveXObject('Microsoft.XMLDOM')
	xmlDoc.async = false;
	xmlDoc.loadXML(hiddenxml);
  
	//if (xmlDoc.parseError.errorCode != 0) {
		// 如果有错误就显示错误并终止程序
	//	objResults.innerHTML = showError(xmlDoc)
	//	return false;
	//} 
  
  
	xslDoc = new ActiveXObject('Microsoft.XMLDOM')
	xslDoc.async = false;
	xslDoc.load(xslfn)
	var html = xmlDoc.documentElement.transformNode(xslDoc);
	//alert("obj.innerHTML:"+html+";");
	obj.innerHTML = html; 
	
	var cwin=window.open("","_Black","");
	cwin.document.write(obj.innerHTML);
	cwin.document.close();
}

// 从XMl元素(对象)生成
// 要执行(depth)等xsl函数
// 要求:
// 		xsl的ns使用 http://www.w3.org/TR/WD-xs
//				<xsl:stylesheet xmlns:xsl="" language="JavaScript">
function load_xmlnFromXMLText(obj, xmlText, xslfn) {

	var xmlDoc;
	var xslDoc;

	var hiddenxml = xmlText;
	//alert("xmlobj.innerHTML:"+hiddenxml+";");
	xmlDoc = new ActiveXObject('Microsoft.XMLDOM')
	xmlDoc.async = false;
	xmlDoc.loadXML(hiddenxml);
  
	xslDoc = new ActiveXObject('Microsoft.XMLDOM')
	xslDoc.async = false;
	xslDoc.load(xslfn)
	var html = xmlDoc.documentElement.transformNode(xslDoc);
	//alert("obj.innerHTML:"+html+";");
	obj.innerHTML = html; 
	//var cwin=window.open("","_Black","");
	//cwin.document.write(obj.innerHTML);
	//cwin.document.close();
}
function showError(objDocument) {
  // 创建错误消息
  var strError = new String;
	strError = 'Invalid XML file !<BR />'
           + 'File URL: ' + objDocument.parseError.url + '<BR />'
           + 'Line No.: ' + objDocument.parseError.line + '<BR />'
           + 'Character: ' + objDocument.parseError.linepos + '<BR />'
           + 'File Position: ' + objDocument.parseError.filepos + '<BR />'
           + 'Source Text: ' + objDocument.parseError.srcText + '<BR />'
           + 'Error Code: ' + objDocument.parseError.errorCode + '<BR />'
           + 'Description: ' + objDocument.parseError.reason;
  return strError;
}