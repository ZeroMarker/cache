////DHCCPM_DOMComm.js

function DHCDOM_CreateXMLDOM()
{
	var arrSignatures = ["MSXML2.DOMDocument.5.0", "MSXML2.DOMDocument.4.0",
		"MSXML2.DOMDocument.3.0", "MSXML2.DOMDocument","Microsoft.XmlDom"];
	
	for (var i=0; i < arrSignatures.length; i++) {
		try {
			var oXmlDom = new ActiveXObject(arrSignatures[i]);
			return oXmlDom;
		} catch (oError) {
		}
	}throw new Error("MSXML is not installed on your system.");
}

function DHCDOM_SetDOCItemValueByXML(XMLStr)
{
	///XMLStr ="<PatInfo>"+XMLStr;
	///XMLStr +="</PatInfo>";
	XMLStr ="<?xml version='1.0' encoding='gb2312'?>"+XMLStr
	
	var xmlDoc=DHCDOM_CreateXMLDOM();
	xmlDoc.async = false;
	xmlDoc.loadXML(XMLStr);
	if(xmlDoc.parseError.errorCode != 0) 
	{ 
		alert(xmlDoc.parseError.reason); 
		return; 
	}
	var nodes = xmlDoc.documentElement.childNodes; 
	for(var i=0; i<nodes.length; i++) 
	{
		var myItemName=nodes(i).nodeName;
		var myItemValue= nodes(i).text;
		
		DHCWebD_SetObjValueXMLTrans(myItemName, myItemValue);
		
	}
	delete(xmlDoc);
}

function DHCDOM_SetDOCListItemValueByXML(XMLStr,SListName, TListName)
{
	///XMLStr ="<PatInfo>"+XMLStr;
	///XMLStr +="</PatInfo>";
	XMLStr ="<?xml version='1.0' encoding='gb2312'?>"+XMLStr
	
	var mySListObj=document.getElementById(SListName);
	if (mySListObj){
		return;
	}
	var myTListObj=document.getElementById(TListName);
	if (myTListObj){
		return;
	}
	
	var xmlDoc=DHCDOM_CreateXMLDOM();
	xmlDoc.async = false;
	xmlDoc.loadXML(XMLStr);
	if(xmlDoc.parseError.errorCode != 0) 
	{ 
		alert(xmlDoc.parseError.reason); 
		return; 
	}
	var nodes = xmlDoc.documentElement.childNodes;
	for(var i=0; i<nodes.length; i++) 
	{
		var myItemName=nodes(i).nodeName;
		var myItemValue= nodes(i).text;
		
		DHCWebD_SetObjValueXMLTrans(myItemName, myItemValue);
		
	}
	delete(xmlDoc);
}


function dd()
{
	try{
		var myxmlobj=createXMLDOM();
		
		var myxml="";
		myxmlobj.load(myxml);
	}catch(oError){
	}
}


function XMLWriter()
{
    this.XML=[];
    this.Nodes=[];
    this.State="";
    this.FormatXML = function(Str)
    {
        if (Str)
            return Str.replace(/&/g, "&amp;").replace(/\"/g, "&quot;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
        return ""
    }
    this.BeginNode = function(Name)
    {
        if (!Name) return;
        if (this.State=="beg") this.XML.push(">");
        this.State="beg";
        this.Nodes.push(Name);
        this.XML.push("<"+Name);
    }
    this.EndNode = function()
    {
        if (this.State=="beg")
        {
            this.XML.push("/>");
            this.Nodes.pop();
        }
        else if (this.Nodes.length>0)
            this.XML.push("</"+this.Nodes.pop()+">");
        this.State="";
    }
    this.Attrib = function(Name, Value)
    {
        if (this.State!="beg" || !Name) return;
        this.XML.push(" "+Name+"=\""+this.FormatXML(Value)+"\"");
    }
    this.WriteString = function(Value)
    {
        if (this.State=="beg") this.XML.push(">");
        this.XML.push(this.FormatXML(Value));
        this.State="";
    }
    this.Node = function(Name, Value)
    {
        if (!Name) return;
        if (this.State=="beg") this.XML.push(">");
        this.XML.push((Value=="" || !Value)?"<"+Name+"/>":"<"+Name+">"+this.FormatXML(Value)+"</"+Name+">");
        this.State="";
    }
    this.Close = function()
    {
        while (this.Nodes.length>0)
            this.EndNode();
        this.State="closed";
    }
    this.ToString = function(){return this.XML.join("");}
}
	
function DHCDOM_WriteXMLInParameter()
{
	

	var myxmlstr="";
	try
	{
		var xmlobj=new XMLWriter();
		xmlobj.BeginNode("IPParas");
		xmlobj.BeginNode("IPPara");
		
		for(var myIdx=0;myIdx<m_CPMPrintAry.length;myIdx++){
			//m_CPMPrintDataTypeAry
			//m_CPMPrintAry
			//m_CPMPrintDispTypeAry
			xmlobj.BeginNode("TxtPara");
			xmlobj.Attrib("EName", m_CPMPrintAry[myIdx]);
			
			///var myval=DHCWebD_GetObjValueXMLTrans(m_CPMPrintAry[myIdx]);
			///xmlobj.Attrib("EValue", myval);
			var myval=DHCWebD_GetObjValueXMLTrans2(m_CPMPrintAry[myIdx]);
			xmlobj.Attrib("EValue", myval);
			
			xmlobj.Attrib("EDataType",m_CPMPrintDataTypeAry[myIdx]);
			xmlobj.EndNode();
		}
		
		///Add System Parameter
		for(var myIdx=0;myIdx<m_CPMSysPrintAry.length;myIdx++){
			//m_CPMSysPrintDataTypeAry
			//m_CPMSysPrintAry
			//
			//m_CPMSysPrintDataValue
			xmlobj.BeginNode("TxtPara");
			xmlobj.Attrib("EName", m_CPMSysPrintAry[myIdx]);
			///var myval=DHCWebD_GetObjValue(m_CPMPrintAry[myIdx]);
			var myval = m_CPMSysPrintDataValue[myIdx];	//DHCWebD_GetObjValueXMLTrans(m_CPMSysPrintAry[myIdx]);
			xmlobj.Attrib("EValue", myval);
			xmlobj.Attrib("EDataType",m_CPMSysPrintDataTypeAry[myIdx]);
			xmlobj.EndNode();
		}
		xmlobj.Close();
		myxmlstr = xmlobj.ToString();
	}catch(Err)
	{
		alert("Error: " + Err.description);
	}
	
	return myxmlstr;
}

function DHCDOM_GetEntityClassInfoToXML(ParseInfo)
{
	var myxmlstr="";
	try
	{
		var myary=ParseInfo.split("^");
		
		var xmlobj=new XMLWriter();
		xmlobj.BeginNode(myary[0]);
		for(var myIdx=1;myIdx<myary.length;myIdx++){
			
			xmlobj.BeginNode(myary[myIdx]);
			
			///xmlobj.Attrib("EName", m_CPMPrintAry[myIdx]);
			//var myval=DHCWebD_GetObjValue(myary[myIdx]);
			var myval = DHCWebD_GetObjValueXMLTransA(myary[myIdx]);
			
			xmlobj.WriteString(myval);
			
			xmlobj.EndNode();
		}
		xmlobj.Close();
		myxmlstr = xmlobj.ToString();
	}catch(Err)
	{
		alert("Error: " + Err.description);
	}
	
	return myxmlstr;
}

function DHCDOM_GetEntityClassInfoToXMLA(ParseInfo)
{
	var myxmlstr="";
	try
	{
		var myary=ParseInfo.split("^");
		
		var xmlobj=new XMLWriter();
		xmlobj.BeginNode(myary[0]);
		for(var myIdx=1;myIdx<myary.length;myIdx++){
			xmlobj.BeginNode(myary[myIdx]);
			///xmlobj.Attrib("EName", m_CPMPrintAry[myIdx]);
			//var myval=DHCWebD_GetObjValue(myary[myIdx]);
			var Tobj=document.getElementById(myary[myIdx]);
			if(Tobj){
				
				switch (Tobj.type)
				{
					case "select-multiple":
						var myCount=Tobj.options.length;
						for (var mySMIdx=0;mySMIdx<myCount;mySMIdx++){
							var myOptValue=Tobj.options[mySMIdx].value;
							var myvalary=myOptValue.split("^");
							
							////<CardTypeListItem>DDD</CardTypeListItem>
							
							if (Tobj.options[mySMIdx].selected){
								xmlobj.BeginNode(myary[myIdx]+"Item");
								xmlobj.WriteString(myvalary[0]);
								
								xmlobj.EndNode();
							}
						}
						
						break;
					default:
						var myval = DHCWebD_GetObjValueXMLTransA(myary[myIdx]);
						xmlobj.WriteString(myval);
						
						break;
				}
			}
			xmlobj.EndNode();
			
		}
		xmlobj.Close();
		myxmlstr = xmlobj.ToString();
	}catch(Err)
	{
		alert("Error: " + Err.description);
	}
	
	return myxmlstr;
}


function WriteTestXML()
{
	try
	{
		var XML=new XMLWriter();
		XML.BeginNode("Example");
                XML.Attrib("SomeAttribute", "And Some Value");
                XML.Attrib("AnotherAttrib", "...");
                XML.WriteString("This is an example of the JS XML WriteString method.");
                XML.Node("Name", "Value");
                XML.BeginNode("SubNode");
                XML.BeginNode("SubNode2");
                XML.EndNode();
                XML.BeginNode("SubNode3");
                XML.WriteString("Blah blah.");
                XML.EndNode();
                XML.Close(); // Takes care of unended tags.
                // The replace in the following line are only for making the XML look prettier in the textarea.
                //document.getElementById("ExampleOutput").value=XML.ToString().replace(/</g,"\n<");
                
                alert(XML.ToString().replace(/</g,"\n<"));
            }
            catch(Err)
            {
                alert("Error: " + Err.description);
            }
            return false;
        }

function DHCCPMReportShow()
{
		var url='dhccpmreport.csp';
		url += "?ID=d50623iLocation";
		//url += "&CONTEXT=Kweb.CTLoc:LookUpLoc";
		url += "&TLUJSF=LookupAdmLoc";
		url += "&TForm=udhcOPAdmFindCSPTEST";
		var obj=document.getElementById('Location');
		if (obj) url += "&P1=" + websys_escape(obj.value);
		
		websys_lu(url,1,'');
}

//*************************************************************

//lidong 20080515 判断元素是否为checkBox类型?如果是则把它的值设为1?不是则设为""?
function DHCWebD_GetObjValueXMLTrans2(TName){
	var Tobj=document.getElementById(TName);
	if(!Tobj){
		return "";
	}
	var myValue="";
	switch (Tobj.type)
	{
		case "select-one":
			var myIdx=obj.options.selectedIndex;
			if(myIdx<0){
				return myValue;
			}
			myValue=obj.options[myIdx].value;
			break;
		case "checkbox":
			if (Tobj.checked==true)
			{
				myValue="1";
			}else{
				myValue="";
			}
			
			break;
		default:
			myValue = Tobj.value;		//txtobj.value;
			break;
	}
	return myValue;
}
//lidong 20080514 从DHCWeb.OPOEData.js中拷贝到此
/*
function DHCWebD_GetObjValue(objname)
{
	var obj=document.getElementById(objname);
	var transval="";
	if (obj){
		switch (obj.type)
		{
			case "select-one":
				myidx=obj.selectedIndex;
				transval=obj.options[myidx].text;
				break;
			case "checkbox":
				transval=obj.checked;
				break;
			default:
				transval=obj.value;
				break;
		}
	}
	return transval;
}

///Special for XML Data Stream;
function DHCWebD_GetObjValueXMLTrans(TName){
	var Tobj=document.getElementById(TName);
	if(!Tobj){
		return "";
	}
	var myValue="";
	switch (Tobj.type)
	{
		case "select-one":
			var myIdx=obj.options.selectedIndex;
			if(myIdx<0){
				return myValue;
			}
			myValue=obj.options[myIdx].value;
			break;
		case "checkbox":
			if (Tobj.checked==true)
			{
				myValue="on";
			}else{
				myValue="";
			}
			
			break;
		default:
			myValue = Tobj.value;		//txtobj.value;
			break;
	}
	return myValue;
}

//lidong
*/
//DHCCPMReportShow();
//兼容ie和chrome
function DHCDOM_CreateXMLDOMNew(XMLStr)
{
	if (window.DOMParser){
	     var parser=new DOMParser();
	     var xmlDoc=parser.parseFromString(XMLStr,"text/xml");
    }else { // Internet Explorer
  		var xmlDoc = DHCDOM_CreateXMLDOM();
  		xmlDoc.async="false";
  		xmlDoc.loadXML(XMLStr); 
  		if (xmlDoc.parseError.errorCode != 0) {
			$.messager.alert("提示",xmlDoc.parseError.reason);
			return;
		}
    }
    return xmlDoc;
}
function getNodeValue(nodes,index){
	if (window.DOMParser){
		return nodes.item(index).textContent;
	}else{
		return nodes(index).text;
	}
}
function getNodeName(nodes,index){
	if (window.DOMParser){
		return nodes.item(index).nodeName
	}else{
		return nodes(index).nodeName;
	}
}