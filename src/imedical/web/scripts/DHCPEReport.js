/// DHCPEStationCom.js
/// 创建时间		2006.03.16
/// 创建人		xuwm
/// 主要功能		编辑站点基本信息
/// 对应表		DHC_PE_Station
/// 最后修改时间	
/// 最后修改人	
/// 完成

function BodyLoadHandler() {

	pagesetup_default();
}
function pagesetup_default()
{   
	try{
	hkey_root="HKEY_CURRENT_USER\\Software\\Microsoft\\Internet Explorer\\PageSetup\\"
	var   RegWsh   =   new   ActiveXObject("WScript.Shell");
	hkey_key="margin_bottom"; 
  	var Value="0.39567"
  	RegWsh.RegWrite(hkey_root+hkey_key,Value);
  	hkey_key="margin_left"; //
  	var Value="0.59252"
  	RegWsh.RegWrite(hkey_root+hkey_key,Value);
  	hkey_key="margin_right"; //
  	var Value="0.59252"
  	RegWsh.RegWrite(hkey_root+hkey_key,Value);
  	hkey_key="margin_top"; //
  	var Value="1.37402"
  	RegWsh.RegWrite(hkey_root+hkey_key,Value);
  	hkey_key="header";
   	Value=""
   	RegWsh.RegWrite(hkey_root+hkey_key,Value);
   	Value="&b第&p页 共&P页&b"
   	hkey_key="footer";
   	RegWsh.RegWrite(hkey_root+hkey_key,Value);
   	}catch(e){alert(e.message)}
}

// ///////////////////////////////////////////////////////////////////
// ///////////////////////////////////////////////////////////////////
// ///////////////////////////////////////////////////////////////////
// ///////////////////////////////////////////////////////////////////
// 以下代码出自 大富翁网站
function load_xml(obj, xmlobj, xslobj) {
	try {
		hiddenxml = xmlobj.innerHTML;
		hiddenxsl = xslobj.xml;
		var myxml = new ActiveXObject("MSXML2.FreeThreadedDOMDocument");
		myxml.async = false;		
		myxml.loadXML(hiddenxml);
		var myxsl = new ActiveXObject("MSXML2.FreeThreadedDOMDocument");
		myxsl.async = false;		
		myxsl.loadXML(hiddenxsl);
		html = myxml.transformNode(myxsl);
		obj.innerHTML = html;
	}
	catch (exception) {
		alert(exception.description);
		obj.innerHTML = exception.description;
	}	
}

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

function load_xls(xslfn){
	try {
		var xsl = new ActiveXObject("MSXML2.FreeThreadedDOMDocument");
		xsl.async = false;
		xsl.load(xslfn);
		return xsl;
	}
	catch (exception) {
		alert(exception.description);
	}	
}

function load_xmlx(obj, xmlobj, xsl) {
	try {
		var myxml = new ActiveXObject("MSXML2.FreeThreadedDOMDocument");
		myxml.async = false;		
		myxml.loadXML(xmlobj.innerHTML);
		html = myxml.transformNode(xsl);
		obj.innerHTML = html;
	}
	catch (exception) {
		alert(exception.description);
		obj.innerHTML = exception.description;
	}	
}

function insertCode2(ss) {
	if (ss=='') return;
	var s1 = document.getElementById("S1");
	s1.focus();
	var rr = document.selection.createRange();
	rr.text = '[' + ss+ ']' + rr.text + '[/' + ss+ ']';
}

function insertCode(ss) {
	if (ss=='') return;
	var s1 = document.getElementById("S1");
	s1.focus();
	var rr = document.selection.createRange();
	rr.text += ss;
}

var msg = "";	
function showMsg() {
	if (msg!="") alert(msg.replace(/\<br\>/gi, "\n"));
}	

function SaveAs(){
	html="";
	t=document.all.item(0,0);
	while(t!=null){
		html+=t.outerHTML;
		t=t.nextSibling;
	}
	document.open("text/html","gb2312");
	document.write(html);
	document.execCommand ("SaveAs",true,document.title+"1.htm");
}

function load_xmlnFromXMLObject(obj, xmlobj, xslfn,IsClear) {

  var xmlDoc
  var xslDoc

  var hiddenxml = xmlobj.innerHTML;
  //alert("xmlobj.innerHTML:"+hiddenxml+";");
  xmlDoc = new ActiveXObject('Microsoft.XMLDOM')
  xmlDoc.async = false;
  xmlDoc.loadXML(hiddenxml);
  
  xslDoc = new ActiveXObject('Microsoft.XMLDOM')
  xslDoc.async = false;
  xslDoc.load(xslfn)
  var html = xmlDoc.documentElement.transformNode(xslDoc);
  //alert("obj.innerHTML:"+html+";");
  if (0==IsClear) { obj.innerHTML =html; }
  else { obj.innerHTML =obj.innerHTML+html; }
  
  // 调试用,察看转换后的HTML代码
  //var cwin=window.open("","_blank","");
  //cwin.document.write(obj.innerHTML);
  //cwin.document.close();
}
function prestr(){
	  //return;
    i=0;
    el=document.all.item("prestr",0)
    while(el!=null)
      {
        s=el.innerHTML;
        s=s+" ";

		s = s.replace(/(^|[^\"\'])(http|ftp|mms|rstp|news|https)(\:\/\/\S+)/gi,"$1<a href='$2$3' target='_blank'>$2$3<\/a>");
		s = s.replace(/(^|[^\/])(www\.\S+)/gi,"$1<a href='http:\/\/$2' target='_blank'>$2</a>");
		//s = s.replace(/([\w+\-\'\#\%\.\_\,\$\!\+\*]+@[\w+\.?\-\'\#\%\~\_\.\;\,\$\!\+\*]*)/gi, "<a href='mailto\:$1'>$1</a>");
       
				s=s.replace(/ firstchar=""> /g,">&nbsp;");
				s=s.replace(/\r\n /g,"<br>&nbsp;");
				s=s.replace(/  |\t/g," &nbsp;");
        s=s.replace(/\r\n/g,"<br>");
        
        el.outerHTML="<p style='margin:4 2 0 2' class='content'>"+s+"</p>";
        el=document.all.item("prestr",0);
        }
}

// ///////////////////////////////////////////////////////////////////
// ///////////////////////////////////////////////////////////////////
// ///////////////////////////////////////////////////////////////////
// ///////////////////////////////////////////////////////////////////


document.body.onload = BodyLoadHandler;