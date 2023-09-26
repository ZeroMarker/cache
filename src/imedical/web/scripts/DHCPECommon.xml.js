/// DHCPECommon.xml.js
/// ����ʱ��		2006.10.31
/// ������		xuwm
/// ��Ҫ����		������XML/XSL�йصĹ���
/// ��Ӧ��		
/// ����޸�ʱ��	
/// ����޸���	
/// ���

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
// ��XMlԪ��(����)����
// Ҫִ��(depth)��xsl����
// Ҫ��:
// 		xsl��nsʹ�� http://www.w3.org/TR/WD-xs
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
		// ����д������ʾ������ֹ����
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

// ��XMlԪ��(����)����
// Ҫִ��(depth)��xsl����
// Ҫ��:
// 		xsl��nsʹ�� http://www.w3.org/TR/WD-xs
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
  // ����������Ϣ
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