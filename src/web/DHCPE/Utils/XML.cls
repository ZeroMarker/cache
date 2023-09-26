/// Creator: Huxiaotian 2019-08
/// Description: XML字符串与对象的相互转换
/// Others: 
/// 	(1)不依赖与其他类
/// 	(2)本类提供的主要方法:
/// 	obj.ToXML()
/// 	obj.ToXMLStream()
/// 	set obj = ##class(web.DHCPE.Utils.XML).FromXML(xmlStr)
Class web.DHCPE.Utils.XML Extends (%RegisteredObject, %XML.Adaptor)
{

Property %xmlData As %String(XMLPROJECTION = "NONE") [ MultiDimensional ];

Property %pIndex As %Integer [ InitialExpression = 0 ];

Property %xmlNodeName As %String(XMLPROJECTION = "NONE") [ MultiDimensional ];

Property %xmlNodeValue As %String(XMLPROJECTION = "NONE") [ MultiDimensional ];

Property %xmlParentNode As %String(XMLPROJECTION = "NONE") [ MultiDimensional ];

Property %cursor As %String;

/// get & set
Method %DispatchGetProperty(index As %String)
{
	q:$d(..%xmlData(index)) ..%xmlData(index)
	s nodeName = $g(..%xmlNodeName(index))
	s nodeValue = $g(..%xmlNodeValue(index))
	q nodeValue
	//q "<"_nodeName_">"_nodeValue_"</"_nodeName_">"
}

Method %DispatchSetProperty(nodeName As %String, nodeValue As %String)
{
	s ..%xmlData(nodeName) = nodeValue
	s ..%xmlNodeName(..%pIndex) = nodeName
	s ..%xmlNodeValue(..%pIndex) = nodeValue
	s ..%pIndex = ..%pIndex + 1
}

/// new get & set
Method Get(index As %String)
{
	q:$d(..%xmlData(index)) ..%xmlData(index)
	s nodeName = $g(..%xmlNodeName(index))
	s nodeValue = $g(..%xmlNodeValue(index))
	q nodeValue
	//q "<"_nodeName_">"_nodeValue_"</"_nodeName_">"
}

Method Set(nodeName As %String, nodeValue As %String)
{
	//w ..%pIndex_","_nodeName_","_nodeValue,!
	s ..%xmlData(nodeName) = nodeValue
	s ..%xmlNodeName(..%pIndex) = nodeName
	s ..%xmlNodeValue(..%pIndex) = nodeValue
	s ..%pIndex = ..%pIndex + 1
}

Method Length()
{
	q ..%pIndex
}

Method Next(ByRef nodeName, ByRef nodeVal)
{
	s ..%cursor = $o(..%xmlNodeValue(..%cursor))
	i ..%cursor'="" {
		s nodeName = ..%xmlNodeName(..%cursor)
		s nodeVal = ..%xmlNodeValue(..%cursor)
	} else {
		s nodeName = ""
		s nodeVal = ""
	}
	q:..%cursor="" 0
	q 1
}

Method Insert(xmlobj)
{
	s ..%xmlNodeValue(..%pIndex) = xmlobj
	s ..%pIndex = ..%pIndex + 1
}

/// override %New()
ClassMethod New(parentNodeName = "") As web.DHCPE.Utils.XML
{
	s xmlObj = ##class(web.DHCPE.Utils.XML).%New()
	s:parentNodeName="" xmlObj.%pIndex = xmlObj.%pIndex + 1
	q:parentNodeName="" xmlObj
	s xmlObj.%xmlNodeName(xmlObj.%pIndex) = parentNodeName
	s xmlObj.%xmlNodeValue(xmlObj.%pIndex) = ""
	s xmlObj.%pIndex = xmlObj.%pIndex + 1
	q xmlObj
}

/// =========返回XML字符串=========
/// Creator: Huxt 2019-07-22
/// Desc: 统一调用入口
Method ToXML(encoding = "utf-8")
{
	Quit ..ObjToXML($this, "", "", encoding)
}

/// Creator: Huxt 2019-07-22
/// Desc: 对象转XML
ClassMethod ObjToXML(OBJ, xmlFirstFlag As %String = "", xmlStream As %Stream.GlobalCharacter = "", encoding = "utf-8") As %String
{
	if xmlFirstFlag="" {
		set xmlStream = ##class(%Stream.GlobalCharacter).%New()
		do xmlStream.Write("<?xml version=""1.0"" encoding="_$c(34)_encoding_$c(34)_"?>")
	}
	set $ZT="TOXMLERR"
	if $IsObject(OBJ){
		//
		if $d(OBJ.%xmlNodeValue(0)) {
			do xmlStream.Write("<"_OBJ.%xmlNodeName(0)_">")
			if $IsObject(OBJ.%xmlNodeValue(0)) {
				do ..ObjToXML(OBJ.%xmlNodeValue(0), 1, xmlStream) // recursive method
			} else {
				do xmlStream.Write(OBJ.%xmlNodeValue(0))
			}
		}
		//
		set index = $o(OBJ.%xmlNodeValue(0))
		while(index'=""){
			set xmlNodeValue = OBJ.%xmlNodeValue(index)
			if $d(OBJ.%xmlNodeName(index)) {
				do xmlStream.Write("<"_OBJ.%xmlNodeName(index)_">")
			}
			if $IsObject(xmlNodeValue) {
				do ..ObjToXML(xmlNodeValue, 0, xmlStream) // recursive method
			} else {
				do xmlStream.Write(xmlNodeValue)
			}
			if $d(OBJ.%xmlNodeName(index)) {
				do xmlStream.Write("</"_OBJ.%xmlNodeName(index)_">")
			}
			set index = $o(OBJ.%xmlNodeValue(index)) //get next index
		}
		//
		if $d(OBJ.%xmlNodeValue(0)) {
			do xmlStream.Write("</"_OBJ.%xmlNodeName(0)_">")
		}
	} else {
		//string
		do xmlStream.Write(OBJ)
	}
	//read stream as string and return------
	set returnJsonStr = ""
	if xmlFirstFlag="" {
		do xmlStream.Rewind()
		while('xmlStream.AtEnd){
			set returnJsonStr = returnJsonStr_xmlStream.Read()
		}
		//jsonStream.%Clear()
	}
	quit returnJsonStr
	
TOXMLERR
	set $ZT=""
	quit $ZE
}

/// =========返回XML流=========
/// Creator: Huxt 2019-08-02
/// Desc: 统一调用入口
Method ToXMLStream(encoding = "utf-8") As %Stream.GlobalCharacter
{
	Quit ..ObjToXMLStream($this, "", "", encoding)
}

/// Creator: Huxt 2019-07-22
/// Desc: 对象转XML
ClassMethod ObjToXMLStream(OBJ, xmlFirstFlag As %String = "", xmlStream As %Stream.GlobalCharacter = "", encoding = "utf-8") As %String
{
	if xmlFirstFlag="" {
		set xmlStream = ##class(%Stream.GlobalCharacter).%New()
		do xmlStream.Write("<?xml version=""1.0"" encoding="_$c(34)_encoding_$c(34)_"?>")
	}
	set $ZT="TOXMLStreamERR"
	if $IsObject(OBJ){
		//
		if $d(OBJ.%xmlNodeValue(0)) {
			do xmlStream.Write("<"_OBJ.%xmlNodeName(0)_">")
			if $IsObject(OBJ.%xmlNodeValue(0)) {
				do ..ObjToXMLStream(OBJ.%xmlNodeValue(0), 1, xmlStream) // recursive method
			} else {
				do xmlStream.Write(OBJ.%xmlNodeValue(0))
			}
		}
		//
		set index = $o(OBJ.%xmlNodeValue(0))
		while(index'=""){
			set xmlNodeValue = OBJ.%xmlNodeValue(index)
			if $d(OBJ.%xmlNodeName(index)) {
				do xmlStream.Write("<"_OBJ.%xmlNodeName(index)_">")
			}
			if $IsObject(xmlNodeValue) {
				do ..ObjToXMLStream(xmlNodeValue, 0, xmlStream) // recursive method
			} else {
				do xmlStream.Write(xmlNodeValue)
			}
			if $d(OBJ.%xmlNodeName(index)) {
				do xmlStream.Write("</"_OBJ.%xmlNodeName(index)_">")
			}
			set index = $o(OBJ.%xmlNodeValue(index)) //get next index
		}
		//
		if $d(OBJ.%xmlNodeValue(0)) {
			do xmlStream.Write("</"_OBJ.%xmlNodeName(0)_">")
		}
	} else {
		//string
		do xmlStream.Write(OBJ)
	}
	//return stream
	if xmlFirstFlag="" {
		do xmlStream.Rewind()
		q xmlStream
	}
	q ""
	
TOXMLStreamERR
	set $ZT=""
	quit $ZE
}

/// =========字符串解析为对象=========
/// Creator: Huxt 2019-08-02
/// Desc: 字符串解析为对象,方便取值
/// w ##class(web.DHCPE.Utils.XML).FromXML("<Request><ExtUserID>demo</ExtUserID><Code></Code><HospitalId>1</HospitalId><datas><data><Name>123</Name><Sex>女</Sex></data><data><Name>023</Name><Sex>男</Sex></data></datas></Request>").ExtUserID
ClassMethod FromXML(xmlStr) As web.DHCPE.Utils.XML
{
	set RootNode = ""
	set id = 0
	set xmlObj = ##class(web.DHCPE.Utils.XML).%New()
	if $IsObject(xmlStr) d
	.set sc = ##class(%XML.TextReader).ParseStream(xmlStr,.reader)
	else  do
	.set sc = ##class(%XML.TextReader).ParseString(xmlStr,.reader)
	if $$$ISOK(sc){
		while (reader.Read()) {
			set Type = reader.NodeType
			set Path = reader.Path
			set Value = reader.Value
			//write Type_","_Path_","_Value,!
			if Type="element" {
				set id = id + 1
				if id=1 {
					set RootNode = Path
				}
				set objArr(Path,id) = ##class(web.DHCPE.Utils.XML).%New()
			} elseif Type="endelement" {
				set lastPath = $p(Path,"/",1,$l(Path,"/")-1)
				quit:lastPath=""
				set tempId = $o(objArr(lastPath,""),-1)
				quit:tempId=""
				set nId = $o(objArr(Path,""),-1)
				quit:nId=""
				if $IsObject(objArr(Path,nId)) {
					if objArr(Path,nId).Length()<=0 {
						set objArr(Path,nId) = ""
					}
				}
				do objArr(lastPath,tempId).Set($p(Path,"/",$l(Path,"/")), objArr(Path,nId))
			} else {
				//set nodeName = $p(Path,"/",$l(Path,"/"))
				//do objArr(Path,id).Set(nodeName,Value)
				set objArr(Path,id) = Value
			}
		}
	}
	quit:RootNode="" ""
	quit objArr(RootNode,1)
}

}
