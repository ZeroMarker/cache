/// 该类来自PHA.COM.XML
/// Creator: Huxiaotian 2019-08
/// Description: XML字符串与对象的相互转换
/// Others: 
/// 	(1)不依赖与其他类
/// 	(2)本类提供的主要方法:
/// 	obj.ToXML()
/// 	obj.ToXMLStream()
/// 	set obj = ##class(DHCMA.Util.IO.XML).FromXML(xmlStr)
/// 	set obj = ##class(DHCMA.Util.IO.XML).Parse(xmlStr)
Class DHCMA.Util.IO.XML Extends (%RegisteredObject, %XML.Adaptor)
{

Property %xmlData As %String(XMLPROJECTION = "NONE") [ MultiDimensional ];

Property %pIndex As %Integer [ InitialExpression = 0 ];

Property %xmlNodeName As %String(XMLPROJECTION = "NONE") [ MultiDimensional ];

Property %xmlNodeValue As %String(XMLPROJECTION = "NONE") [ MultiDimensional ];

Property %xmlIsCData As %String(XMLPROJECTION = "NONE") [ MultiDimensional ];

Property %xmlParentNode As %String;

Property %cursor As %String;

/// 新增属性 2021-08-14
Property %xmlText As %String;

Property %aIndex As %Integer [ InitialExpression = 0 ];

Property %xmlAttrName As %String(XMLPROJECTION = "NONE") [ MultiDimensional ];

Property %xmlAttrValue As %String(XMLPROJECTION = "NONE") [ MultiDimensional ];

Property %xmlAttrIndexName As %String(XMLPROJECTION = "NONE") [ MultiDimensional ];

Property %xmlAttrNameIndex As %String(XMLPROJECTION = "NONE") [ MultiDimensional ];

Property IsAddHead As %Boolean [ InitialExpression = 1 ];

Property %xmlNodeObj As DHCMA.Util.IO.XML(XMLPROJECTION = "NONE") [ MultiDimensional ];

Property %xmlNodeObjIndex As DHCMA.Util.IO.XML(XMLPROJECTION = "NONE") [ MultiDimensional ];

/// 对象初始化
Method %OnNew(parentNodeName = "") As %Status [ Private, ServerOnly = 1 ]
{
	q:(parentNodeName = "") $$$OK
	s $this.%xmlParentNode = parentNodeName
	q $$$OK
}

ClassMethod New(parentNodeName = "") As DHCMA.Util.IO.XML
{
	s xmlObj = ##class(DHCMA.Util.IO.XML).%New()
	q:(parentNodeName = "") xmlObj
	s xmlObj.%xmlParentNode = parentNodeName
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
Method Get(index As %String, type As %String = "string")
{
	s type = $zcvt(type, "L")
	if (type = "object") {
		s nodeValue = $g(..%xmlNodeValue(index))
		if ($IsObject(nodeValue)) {
			q nodeValue
		}
		q ..GetNodeObj(index)
	}
	q:$d(..%xmlData(index)) ..%xmlData(index)
	s nodeName = $g(..%xmlNodeName(index))
	s nodeValue = $g(..%xmlNodeValue(index))
	q nodeValue
}

Method Set(nodeName As %String, nodeValue As %String, isCData As %Boolean = 0)
{
	s ..%xmlData(nodeName) = nodeValue
	s ..%xmlNodeName(..%pIndex) = nodeName
	s ..%xmlNodeValue(..%pIndex) = nodeValue
	s ..%xmlIsCData(..%pIndex) = isCData
	s ..%pIndex = ..%pIndex + 1
}

Method GetNodeObj(index) [ Private ]
{
	q:$d(..%xmlNodeObj(index)) ..%xmlNodeObj(index)
	q $g(..%xmlNodeObjIndex(index))
}

Method SetNodeObj(nodeName, nodeValue, nodeObj) [ Private ]
{
	s ..%xmlNodeObj(nodeName) = nodeObj
	s ..%xmlNodeObjIndex(..%pIndex) = nodeObj
	d ..Set(nodeName, nodeValue)
}

Method GetText()
{
	q ..%xmlText
}

Method SetText(value)
{
	s ..%xmlText = value
}

Method GetAttr(name)
{
	s aIndex = ..GetAttrIndex(name)
	q:(aIndex = "") ""
	q $g(..%xmlAttrValue(aIndex))
}

Method SetAttr(name, value)
{
	s aIndex = ..GetAttrIndex(name)
	if (aIndex '= "") {
		s ..%xmlAttrName(aIndex) = name
		s ..%xmlAttrValue(aIndex) = value
		q
	}
	s ..%xmlAttrIndexName(..%aIndex) = name
	s ..%xmlAttrNameIndex(name) = ..%aIndex
	s ..%xmlAttrName(..%aIndex) = name
	s ..%xmlAttrValue(..%aIndex) = value
	s ..%aIndex = ..%aIndex + 1
}

Method GetAttrName(index)
{
	q $g(..%xmlAttrIndexName(index))
}

Method GetAttrIndex(name)
{
	q $g(..%xmlAttrNameIndex(name))
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
	if (..%cursor '= "") {
		s nodeName = ..%xmlNodeName(..%cursor)
		s nodeVal = ..%xmlNodeValue(..%cursor)
	} else {
		s nodeName = ""
		s nodeVal = ""
	}
	q:(..%cursor = "") 0
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
	if (xmlFirstFlag = "") {
		set xmlStream = ##class(%Stream.GlobalCharacter).%New()
		if (OBJ.IsAddHead) {
			do xmlStream.Write("<?xml version=""1.0"" encoding="_$c(34)_encoding_$c(34)_"?>")
		}
	}
	set $ZT = "TOXMLERR"
	if $IsObject(OBJ){
		// 1.父节点start
		if (OBJ.%xmlParentNode '= "") {
			do xmlStream.Write("<"_OBJ.%xmlParentNode)
			set attrIdx = ""
			for {
				set attrIdx = $o(OBJ.%xmlAttrName(attrIdx))
				quit:(attrIdx = "")
				set attrName = OBJ.%xmlAttrName(attrIdx)
				set atrrValue = OBJ.%xmlAttrValue(attrIdx)
				do xmlStream.Write(" " _ attrName _ "=" _ $c(34) _ atrrValue _ $c(34))
			}
			do xmlStream.Write(">")
		}
		// 2.子节点
		if (OBJ.%xmlText '= "") {
			do xmlStream.Write(OBJ.%xmlText)
		} else {
			set index = ""
			for {
				set index = $o(OBJ.%xmlNodeValue(index))
				quit:(index = "")
				set xmlNodeValue = OBJ.%xmlNodeValue(index)
				if $d(OBJ.%xmlNodeName(index)) {
					do xmlStream.Write("<"_OBJ.%xmlNodeName(index)_">")
				}
				if $IsObject(xmlNodeValue) {
					do ..ObjToXML(xmlNodeValue, 0, xmlStream, "") // recursive method
				} else {
					if ($g(OBJ.%xmlIsCData(index)) = 1) {
						do xmlStream.Write("<![CDATA[" _ xmlNodeValue _ "]]>")
					} else {
						do xmlStream.Write(xmlNodeValue)
					}
				}
				if $d(OBJ.%xmlNodeName(index)) {
					do xmlStream.Write("</"_OBJ.%xmlNodeName(index)_">")
				}
			}
		}
		// 3.父节点end
		if (OBJ.%xmlParentNode '= "") {
			do xmlStream.Write("</"_OBJ.%xmlParentNode_">")
		}
	} else {
		// string
		do xmlStream.Write(OBJ)
	}
	// read stream as string and return ------
	set returnJsonStr = ""
	if (xmlFirstFlag = "") {
		do xmlStream.Rewind()
		while('xmlStream.AtEnd){
			set returnJsonStr = returnJsonStr_xmlStream.Read()
		}
	}
	quit returnJsonStr
	
TOXMLERR
	set $ZT = ""
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
	if (xmlFirstFlag = "") {
		set xmlStream = ##class(%Stream.GlobalCharacter).%New()
		if (OBJ.IsAddHead) {
			do xmlStream.Write("<?xml version=""1.0"" encoding="_$c(34)_encoding_$c(34)_"?>")
		}
	}
	set $ZT = "TOXMLStreamERR"
	if $IsObject(OBJ) {
		// 1.父节点start
		if (OBJ.%xmlParentNode '= "") {
			do xmlStream.Write("<"_OBJ.%xmlParentNode)
			set attrIdx = ""
			for {
				set attrIdx = $o(OBJ.%xmlAttrName(attrIdx))
				quit:(attrIdx = "")
				set attrName = OBJ.%xmlAttrName(attrIdx)
				set atrrValue = OBJ.%xmlAttrValue(attrIdx)
				do xmlStream.Write(" " _ attrName _ "=" _ $c(34) _ atrrValue _ $c(34))
			}
			do xmlStream.Write(">")
		}
		// 2.子节点
		if (OBJ.%xmlText '= "") {
			do xmlStream.Write(OBJ.%xmlText)
		} else {
			set index = ""
			for {
				set index = $o(OBJ.%xmlNodeValue(index))
				quit:(index = "")
				set xmlNodeValue = OBJ.%xmlNodeValue(index)
				if $d(OBJ.%xmlNodeName(index)) {
					do xmlStream.Write("<"_OBJ.%xmlNodeName(index)_">")
				}
				if $IsObject(xmlNodeValue) {
					do ..ObjToXMLStream(xmlNodeValue, 0, xmlStream) // recursive method
				} else {
					if ($g(OBJ.%xmlIsCData(index)) = 1) {
						do xmlStream.Write("<![CDATA[" _ xmlNodeValue _ "]]>")
					} else {
						do xmlStream.Write(xmlNodeValue)
					}
				}
				if $d(OBJ.%xmlNodeName(index)) {
					do xmlStream.Write("</"_OBJ.%xmlNodeName(index)_">")
				}
			}
		}
		// 3.父节点end
		if (OBJ.%xmlParentNode '= "") {
			do xmlStream.Write("</"_OBJ.%xmlParentNode_">")
		}
	} else {
		// string
		do xmlStream.Write(OBJ)
	}
	// return stream
	if (xmlFirstFlag = "") {
		do xmlStream.Rewind()
		q xmlStream
	}
	q ""
	
TOXMLStreamERR
	set $ZT = ""
	quit $ZE
}

/// ========= 字符串解析为对象(反序列化) =========
/// Description: 字符串解析为对象,方便取值
/// Creator: 	 Huxt 2019-08-02
/// Input:       xmlStr - xml字符串或流
///              isCutHead - 是否去掉xml头信息
/// Output:      xml对象
/// Others:		 如果有些XML无法解析,是因为xml中的中文字符与xml头指定的编码格式不一致, 核心方法:
/// 			 set sc = ##class(%XML.TextReader).ParseStream(xmlStr, .reader)
/// 			 set sc = ##class(%XML.TextReader).ParseString(xmlStr, .reader)
/// Debug:
/// w ##class(DHCMA.Util.IO.XML).FromXML("<Request><ExtUserID>demo</ExtUserID><Code></Code><HospitalId>1</HospitalId><datas><data><Name>123</Name><Sex>女</Sex></data><data><Name>023</Name><Sex>男</Sex></data></datas></Request>").ExtUserID
ClassMethod FromXML(xmlStr, isCutHead = "Y") As DHCMA.Util.IO.XML
{
	set RootNode = ""
	set id = 0
	s xmlStream = ..CutXmlHead(xmlStr, isCutHead)
	set sc = ##class(%XML.TextReader).ParseStream(xmlStream, .reader)
	if $$$ISOK(sc){
		while (reader.Read()) {
			set Type = reader.NodeType
			set Path = reader.Path
			set Value = reader.Value
			if (Type = "element") {
				set id = id + 1
				if id = 1 {
					set RootNode = Path
				}
				set objArr(Path,id) = ##class(DHCMA.Util.IO.XML).%New()
			} elseif (Type = "endelement") {
				set lastPath = $p(Path, "/", 1, $l(Path,"/") - 1)
				continue:(lastPath = "")
				set tempId = $o(objArr(lastPath, ""), -1)
				continue:(tempId = "")
				set nId = $o(objArr(Path, ""), -1)
				continue:(nId = "")
				if $IsObject(objArr(Path, nId)) {
					if (objArr(Path, nId).Length() <= 0) {
						set objArr(Path, nId) = ""
					}
				}
				do objArr(lastPath, tempId).Set($p(Path, "/", $l(Path,"/")), objArr(Path,nId))
			} else {
				// set objArr(Path,id) = Value
				if ($d(objArr(Path, id))&&($IsObject(objArr(Path, id)) = 0)) {
					set objArr(Path, id) = objArr(Path, id) _ Value
				} else {
					set objArr(Path, id) = Value
				}
			}
		}
	} else {
		set err = $SYSTEM.Status.GetErrorText(sc)
		set err = $tr(err,"^","-")
		quit -100 _ "^" _ err
	}
	quit:(RootNode = "") ##class(DHCMA.Util.IO.XML).%New()
	quit objArr(RootNode, 1)
}

/// Description: 解析xml流或者字符串,可以包含节点属性. 此方法是对FromXML()方法的扩展
/// Creator: 	 Huxt 2021-08-15
/// Input:       xmlStr - xml字符串或流
///              isCutHead - 是否去掉xml头信息
/// Output:      xml对象
/// Others:		 主要针对有些包含节点属性的无法解析的xml
/// Debug:
/// w ##class(DHCMA.Util.IO.XML).Parse("<Request><ExtUserID attr1=""aaa"" attr2=""bbb"">demo</ExtUserID><Code></Code><HospitalId>1</HospitalId><datas><data><Name>123</Name><Sex>女</Sex></data><data><Name>023</Name><Sex>男</Sex></data></datas></Request>").Get("ExtUserID","object").GetAttr("attr2")
ClassMethod Parse(xmlStr, isCutHead = "Y")
{
	set RootNode = ""
	set id = 0
	s xmlStream = ..CutXmlHead(xmlStr, isCutHead)
	set sc = ##class(%XML.TextReader).ParseStream(xmlStream, .reader)
	if $$$ISOK(sc) {
		set lastElePath = "", lastEleCount = 0, rCount = 0
		while (reader.Read()) {
			set rCount = rCount + 1
			set Type = reader.NodeType
			set Path = reader.Path
			set Value = reader.Value
			if (Type = "element") {
				set lastElePath = Path
				set lastEleCount = rCount
				set id = id + 1
				set parXmlKey = $p(Path, "/", $l(Path,"/"))
				set objArr(Path, id) = ##class(DHCMA.Util.IO.XML).%New(parXmlKey)
				set objArrAdd(Path, id) = ##class(DHCMA.Util.IO.XML).%New(parXmlKey)
				set attrCount = reader.AttributeCount
				if (attrCount > 0) {
					for attrIndex = 1 : 1 : attrCount {
						do reader.MoveToAttributeIndex(attrIndex)
						set attrName = reader.Name
						set attrValue = reader.Value
						do objArr(Path, id).SetAttr(attrName, attrValue)
						do objArrAdd(Path, id).SetAttr(attrName, attrValue)
					}
				}
				if (id = 1) {
					set RootNode = Path
				}
			} elseif (Type = "endelement") {
				set lastPath = $p(Path, "/", 1, $l(Path,"/") - 1)
				continue:(lastPath = "")
				set tempId = $o(objArr(lastPath, ""), -1)
				continue:(tempId = "")
				set nId = $o(objArr(Path, ""), -1)
				continue:(nId = "")
				set parXmlKey = $p(Path, "/", $l(Path,"/"))
				if (lastEleCount = rCount - 1)&&(lastElePath = Path) {
					set lastElePath = "", lastEleCount = 0
					do objArr(lastPath, tempId).SetNodeObj(parXmlKey, "", objArrAdd(Path, nId))
				} else {
					if ('$IsObject(objArr(Path, nId)))&&($IsObject(objArrAdd(Path, nId))) {
						do objArrAdd(Path, nId).SetText(objArr(Path, nId))
					}
					do objArr(lastPath, tempId).SetNodeObj(parXmlKey, objArr(Path, nId), objArrAdd(Path, nId))
				}
			} else {
				set lastElePath = "", lastEleCount = 0
				if ($d(objArr(Path, id))&&($IsObject(objArr(Path, id)) = 0)) {
					set objArr(Path, id) = objArr(Path, id) _ Value
				} else {
					set objArr(Path, id) = Value
				}
			}
		}
	} else {
		set err = $SYSTEM.Status.GetErrorText(sc)
		set err = $tr(err, "^", "-")
		quit -100 _ "^" _ err
	}
	quit:(RootNode = "") ##class(DHCMA.Util.IO.XML).%New()
	quit objArr(RootNode, 1)
}

/// Descirption: 去掉xml头(<?xml version="1.0" encoding="UTF-8"?>), 返回流
/// Creaator:	 Huxt 2020-09-11
/// w ##class(DHCMA.Util.IO.XML).CutXmlHead("<?xml version=""1.0"" encoding=""UTF-8""?><Request><ExtUserID>demo</ExtUserID><Code></Code><HospitalId>1</HospitalId><datas><data><Name>123</Name><Sex>女</Sex></data><data><Name>023</Name><Sex>男</Sex></data></datas></Request>").Read()
ClassMethod CutXmlHead(xmlStr, isCutHead = "Y") As %Stream.GlobalCharacter
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
	if (isCutHead = "Y") {
		set cnt = 0
		while 'xmlStream.AtEnd {
			set char = xmlStream.Read(1)
			continue:char=""
			continue:char=" "
			set cnt = cnt + 1
			set charArr(cnt) = char
			continue:cnt=1
			if (cnt > 50) {
				do xmlStream.Rewind()
				do newStream.Write(xmlStream.Read())
			}
			if (charArr(cnt-1)="?")&&(charArr(cnt)=">") {
				do newStream.Write(xmlStream.Read(xmlStreamSize - cnt))
			}
		}
	} else {
		while 'xmlStream.AtEnd {
			do newStream.Write(xmlStream.Read())
		}
	}
	quit newStream
}

/// =================================================
/// Descirption: xml字符串(或流)转为json对象
/// Creaator:	 wzl 2020-11-06
/// w ##class(DHCMA.Util.IO.XML).Xml2Object(xmlStr).%ToJSON()
ClassMethod Xml2Object(XMLStream, isCutHead = "Y") As %DynamicObject
{
	s XMLStream = ..CutXmlHead(XMLStream, isCutHead)
	s Stream = ##class(%GlobalCharacterStream).%New()
	if $IsObject(XMLStream) s sc = ##class(%XML.TextReader).ParseStream(XMLStream, .reader)
	else  s sc = ##class(%XML.TextReader).ParseString(XMLStream, .reader)
	if $$$ISOK(sc) {
		while (reader.Read()) {
			set Type = reader.NodeType
			set Path = reader.Path
			set Value = reader.Value
			if Type = "element" {
				s cnt = +$g(mapTmpData("eleDetail",Path))
				s mapTmpData("eleDetail",Path) = cnt + 1
			}
			if Type = "chars" {
				s cnt = +$g(mapPathCharCnt(Path))
				i cnt = 0 s cnt = 1
				s mapPathCharCnt(Path) = cnt + 1
				s mapTmpData("pathVal", Path, cnt) = Value
			}
		}
	}
	s Path = ""
	f {
		s Path = $o(mapTmpData("eleDetail",Path),-1)
		q:Path=""
		s pathCnt = mapTmpData("eleDetail",Path)
		s valFlag = 0
		i $d(mapTmpData("pathVal",Path)) s valFlag = 1
		s parPath = ..GetParPath(Path)
		s grandPath = ..GetGrandPath(Path)
		s lastPath = $p(Path,"/",1,$l(Path,"/")-1)
		i parPath '= "" s mapTmpData("parPath",lastPath,Path) = ""
		i lastPath '= "" {
			i (grandPath'="")&&(pathCnt>1)&&($g(mapTmpData("dataType",Path))'="Array") {
				s mapTmpData("dataType",lastPath) = "Array"
			} else {
				s mapTmpData("dataType",lastPath) = "Object"
			}
		}
		if valFlag = 1 {
			s cntPath = 0
			f {
				s cntPath = $o(mapTmpData("pathVal", Path, cntPath))
				q:cntPath=""
				s val = mapTmpData("pathVal", Path, cntPath)
				s realPath = $p(Path,"/",$l(Path,"/"))
				q:lastPath=""
				s mapMainData("pathNodeVal",Path,cntPath) = val	
				s parData = $g(mapMainData("pathNodeVal",lastPath,cntPath))
				i parData = "" {
					s parData = ##class(%DynamicObject).%New()
				}
				d parData.%Set(realPath, $g(mapMainData("pathNodeVal",Path,cntPath)))
			   	s mapMainData("pathNodeVal",lastPath,cntPath) = parData
			   	i mapTmpData("dataType",lastPath) = "Object" s mapMainDataList(lastPath) = parData
			}
		}
	}
	f  {
		s Path = $o(mapTmpData("dataType",Path),-1)
		q:Path=""
		s lastPath = $p(Path,"/",1,$l(Path,"/")-1)
		continue:lastPath=""
		i (mapTmpData("dataType",lastPath)="Array")&&($g(mapMainDataList(lastPath))'="") {
			s mapTmpData("dataType", lastPath) = "Object"
		}
	}
	f  {
		s Path = $o(mapTmpData("eleDetail",Path),-1)
		q:Path=""
		s pathCnt = mapTmpData("eleDetail",Path)
		s lastPath = $p(Path,"/",1,$l(Path,"/")-1)
		s realPath = $p(Path,"/",$l(Path,"/"))
		s valFlag = 0
		i $d(mapTmpData("pathVal",Path)) s valFlag = 1
		continue:valFlag=1
		continue:lastPath=""
		i mapTmpData("dataType",lastPath) = "Array" {
			s tmpArr = $g(mapMainDataList(lastPath))
			i tmpArr = "" s tmpArr=##class(%DynamicArray).%New()
			s cntPath = ""
			f {
				s cntPath = $o(mapMainData("pathNodeVal",Path,cntPath))
				q:cntPath=""
				d tmpArr.%Push(mapMainData("pathNodeVal",Path,cntPath))
			}
			s mapMainDataList(lastPath) = tmpArr
		} else {
			i (lastPath'="")&&($d(mapMainData("pathNodeVal",Path,1)))&&($g(mapTmpData("dataType",lastPath))="Object")&&($g(mapTmpData("dataType",Path))="Array") {
				s tmpArr = ##class(%DynamicArray).%New()
				s maxLen = 0
				s cldPath = ""
				f {
					s cldPath = $o(mapTmpData("parPath",Path,cldPath))
					q:cldPath=""
					s tmpLen = $o(mapMainData("pathNodeVal",cldPath,""),-1)
					i maxLen < tmpLen s maxLen = tmpLen
				}
				f cldCntPath = 1 : 1 : maxLen {
					s cldObj = ##class(%DynamicObject).%New()
					s cldPath = ""
					f {
						s cldPath = $o(mapTmpData("parPath",Path,cldPath))
						q:cldPath=""
						s val = $g(mapMainData("pathNodeVal",cldPath,cldCntPath))
						s cldRealPath = $p(cldPath,"/",$l(cldPath,"/"))
						d cldObj.%Set(cldRealPath,val)
					}
					d tmpArr.%Push(cldObj)
				}
				s mapMainDataList(Path) = tmpArr
			}
			s tmpObj = $g(mapMainDataList(lastPath))
			i tmpObj = "" s tmpObj = ##class(%DynamicObject).%New()
			d tmpObj.%Set(realPath, $g(mapMainDataList(Path)))
			s mapMainDataList(lastPath) = tmpObj
		}
	}
	q mapMainDataList($o(mapMainDataList("")))
}

ClassMethod GetParPath(Path) As %GlobalCharacterStream
{
	s len = $l(Path, "/")
	q:(len < 2) ""
	q $p(Path, "/", 1, (len-1))
}

ClassMethod GetGrandPath(Path) As %GlobalCharacterStream
{
	s len = $l(Path, "/")
	q:(len < 3) ""
	q $p(Path, "/", 1, (len-2))
}

}
