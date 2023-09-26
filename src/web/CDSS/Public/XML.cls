/// Creator: Xuwenhu 2022-08
/// Description: XML字符串与对象的相互转换
/// Others: 
/// 	(1)不依赖与其他类
/// 	(2)本类提供的主要方法:
/// 	obj.ToXML()
/// 	obj.ToXMLStream()
/// 	set obj = ##class(web.CDSS.Public.XML).FromXML(xmlStr)
Class web.CDSS.Public.XML Extends (%RegisteredObject, %XML.Adaptor)
{

Property %xmlData As %String(XMLPROJECTION = "NONE") [ MultiDimensional ];

Property %pIndex As %Integer [ InitialExpression = 0 ];

Property %xmlNodeName As %String(XMLPROJECTION = "NONE") [ MultiDimensional ];

Property %xmlNodeValue As %String(XMLPROJECTION = "NONE") [ MultiDimensional ];

Property %xmlParentNode As %String(XMLPROJECTION = "NONE") [ MultiDimensional ];

Property %cursor As %String;

/// 对象初始化
Method %OnNew(parentNodeName = "") As %Status [ Private, ServerOnly = 1 ]
{
	//s:parentNodeName="" $this.%pIndex = $this.%pIndex + 1 // todo...
	q:parentNodeName="" $$$OK
	s $this.%xmlNodeName($this.%pIndex) = parentNodeName
	s $this.%xmlNodeValue($this.%pIndex) = ""
	s $this.%pIndex = $this.%pIndex + 1
	q $$$OK
}

ClassMethod New(parentNodeName = "") As web.CDSS.Public.XML
{
	s xmlObj = ##class(web.CDSS.Public.XML).%New()
	//s:parentNodeName="" xmlObj.%pIndex = xmlObj.%pIndex + 1 // todo...
	q:parentNodeName="" xmlObj
	s xmlObj.%xmlNodeName(xmlObj.%pIndex) = parentNodeName
	s xmlObj.%xmlNodeValue(xmlObj.%pIndex) = ""
	s xmlObj.%pIndex = xmlObj.%pIndex + 1
	q xmlObj
}

/// 继承系统的 Get() & Set() 方法
Method %DispatchGetProperty(index As %String)
{
	q:$d(..%xmlData(index)) ..%xmlData(index)
	s nodeName = $g(..%xmlNodeName(index))
	s nodeValue = $g(..%xmlNodeValue(index))
	q nodeValue
}

Method %DispatchSetProperty(nodeName As %String, nodeValue As %String)
{
	s ..%xmlData(nodeName) = nodeValue
	s ..%xmlNodeName(..%pIndex) = nodeName
	s ..%xmlNodeValue(..%pIndex) = nodeValue
	s ..%pIndex = ..%pIndex + 1
}

/// 自定义 Get() & Set() 方法
Method Get(index As %String)
{
	q:$d(..%xmlData(index)) ..%xmlData(index)
	s nodeName = $g(..%xmlNodeName(index))
	s nodeValue = $g(..%xmlNodeValue(index))
	q nodeValue
}

Method Set(nodeName As %String, nodeValue As %String)
{
	s ..%xmlData(nodeName) = nodeValue
	s ..%xmlNodeName(..%pIndex) = nodeName
	s ..%xmlNodeValue(..%pIndex) = nodeValue
	s ..%pIndex = ..%pIndex + 1
}

/// 自定义 Insert()方法 (对Set()方法的扩展)
Method Insert(xmlobj)
{
	s ..%xmlNodeValue(..%pIndex) = xmlobj
	s ..%pIndex = ..%pIndex + 1
}

/// 属性遍历
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

/// 获取属性长度
Method Length()
{
	q ..%pIndex
}

/// ========= 返回XML字符串(序列化) =========
/// Creator: Huxt 2019-07-22
/// Desc: 	 统一调用入口
Method ToXML(encoding = "utf-8")
{
	Quit ..ObjToXML($this, "", "", encoding)
}

/// Creator: Huxt 2019-07-22
/// Desc: 	 对象转XML
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

/// ========= 返回XML流(序列化) =========
/// Creator: Huxt 2019-08-02
/// Desc: 	 统一调用入口
Method ToXMLStream(encoding = "utf-8") As %Stream.GlobalCharacter
{
	Quit ..ObjToXMLStream($this, "", "", encoding)
}

/// Creator: Huxt 2019-07-22
/// Desc: 	 对象转XML
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

/// ========= 字符串解析为对象(反序列化) =========
/// Description: 字符串解析为对象,方便取值
/// Creator: 	 Huxt 2019-08-02
/// Others:		 如果有些XML无法解析,是因为xml中的中文字符与xml头指定的编码格式不一致, 核心方法:
/// 			 set sc = ##class(%XML.TextReader).ParseStream(xmlStr, .reader)
/// 			 set sc = ##class(%XML.TextReader).ParseString(xmlStr, .reader)
/// Debug:		 w ##class(web.CDSS.Public.XML).FromXML("<Request><ExtUserID>demo</ExtUserID><Code></Code><HospitalId>1</HospitalId><datas><data><Name>123</Name><Sex>女</Sex></data><data><Name>023</Name><Sex>男</Sex></data></datas></Request>").ExtUserID
ClassMethod FromXML(xmlStr) As web.CDSS.Public.XML
{
	set RootNode = ""
	set id = 0
	s xmlStream = ..CutXmlHead(xmlStr)
	set sc = ##class(%XML.TextReader).ParseStream(xmlStream, .reader)
	if $$$ISOK(sc){
		while (reader.Read()) {
			set Type = reader.NodeType
			set Path = reader.Path
			set Value = reader.Value
			if Type = "element" {
				set id = id + 1
				if id = 1 {
					set RootNode = Path
				}
				set objArr(Path,id) = ##class(web.CDSS.Public.XML).%New()
			} elseif Type = "endelement" {
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
				// set objArr(Path,id) = Value
				if ($d(objArr(Path,id))&&($IsObject(objArr(Path,id))=0)) {
					set objArr(Path,id) = objArr(Path,id)_Value
				} else {
					set objArr(Path,id) = Value
				}
			}
		}
	} else {
		set err = $SYSTEM.Status.GetErrorText(sc)
		set err = $tr(err,"^","-")
		quit -100_"^"_err
	}
	quit:RootNode="" ##class(web.CDSS.Public.XML).%New()
	quit objArr(RootNode,1)
}

/// Descirption: 去掉xml头(<?xml version="1.0" encoding="UTF-8"?>), 返回流
/// Creaator:	 Huxt 2020-09-11
/// w ##class(web.CDSS.Public.XML).CutXmlHead("<?xml version=""1.0"" encoding=""UTF-8""?><Request><ExtUserID>demo</ExtUserID><Code></Code><HospitalId>1</HospitalId><datas><data><Name>123</Name><Sex>女</Sex></data><data><Name>023</Name><Sex>男</Sex></data></datas></Request>").Read()
ClassMethod CutXmlHead(xmlStr) As %Stream.GlobalCharacter
{
	set newStream = ##class(%Stream.GlobalCharacter).%New()
	if $IsObject(xmlStr) {
		s xmlStream = xmlStr
	} else {
		s xmlStream = ##class(%Stream.GlobalCharacter).%New()
		d xmlStream.Write(xmlStr)
	}
	set xmlStreamSize = xmlStream.SizeGet()
	do xmlStream.Rewind()
	set cnt = 0
	while 'xmlStream.AtEnd {
		set char = xmlStream.Read(1)
		continue:char=""
		set cnt = cnt + 1
		set charArr(cnt) = char
		continue:cnt=1
		if (cnt > 50) {
			do xmlStream.Rewind()
			do newStream.Write(xmlStream.Read())
		}
		if (charArr(cnt-1))="?"&&(charArr(cnt)=">") {
			do newStream.Write(xmlStream.Read(xmlStreamSize - cnt))
		}
	}
	quit newStream
}

/// Descirption: 去掉xml头(<?xml version="1.0" encoding="UTF-8"?>), 返回流
/// Creaator:	 Huxt 2020-09-11
/// w ##class(PHA.COM.XML).CutXmlHead("<?xml version=""1.0"" encoding=""UTF-8""?><Request><ExtUserID>demo</ExtUserID><Code></Code><HospitalId>1</HospitalId><datas><data><Name>123</Name><Sex>女</Sex></data><data><Name>023</Name><Sex>男</Sex></data></datas></Request>").Read()
ClassMethod NewFromXml(xmlStr) As %Stream.GlobalCharacter
{
	set RootNode = ""
	set id = 0
	s xmlStream=xmlStr
	//s xmlStream = ..CutXmlHead(xmlStr)
	if (xmlStr["?xml version="){
		s xmlStream =$p(xmlStr,"?>",2,*)
	}
	set sc = ##class(%XML.TextReader).ParseStream(xmlStream, .reader)
	if $$$ISOK(sc){
		while (reader.Read()) {
			set Type = reader.NodeType
			set Path = reader.Path
			set Value = reader.Value
			if Type = "element" {
				set id = id + 1
				if id = 1 {
					set RootNode = Path
				}
				set objArr(Path,id) = ##class(web.CDSS.Public.XML).%New()
			} elseif Type = "endelement" {
				
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
				//报错  *****
				//w $p(Path,"/",PathLength),!
				//w objArr(lastPath,tempId),!
				//w objArr(Path,nId),!
				//b:Path["//"
				//continue:(objArr(lastPath,tempId)="//")
				//b:$p(Path,"/",PathLength)="structuredBody"
				//do objArr(lastPath,tempId).Set($p(Path,"/",PathLength),objArr(Path,nId))
				//s PrePath=$p(Path,"/",PathLength)
				do objArr(lastPath,tempId).Set($p(Path,"/",$l(Path,"/")),objArr(Path,nId))
				
				
			} else {
				// set objArr(Path,id) = Value
				if ($d(objArr(Path,id))&&($IsObject(objArr(Path,id))=0)) {
					set objArr(Path,id) = objArr(Path,id)_Value
				} else {
					set objArr(Path,id) = Value
				}
			}
		}
	} else {
		set err = $SYSTEM.Status.GetErrorText(sc)
		set err = $tr(err,"^","-")
		;s ^TMP("WW1")=err
		quit -100_"^"_err
	}
	quit:RootNode="" ##class(web.CDSS.Public.XML).%New()
	quit objArr(RootNode,1)
}

}
