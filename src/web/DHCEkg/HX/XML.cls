Class web.DHCEkg.HX.XML Extends (%RegisteredObject, %XML.Adaptor)
{

Property %xmlData As %String(XMLPROJECTION = "NONE") [ MultiDimensional ];

Property %pIndex As %Integer [ InitialExpression = 0 ];

Property %xmlNodeName As %String(XMLPROJECTION = "NONE") [ MultiDimensional ];

Property %xmlNodeValue As %String(XMLPROJECTION = "NONE") [ MultiDimensional ];

Property %xmlParentNode As %String(XMLPROJECTION = "NONE") [ MultiDimensional ];

Property %xmlProjection As %String(XMLPROJECTION = "NONE") [ MultiDimensional ];

Property %xmlName As %String(XMLPROJECTION = "NONE") [ MultiDimensional ];

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

Method Set(nodeName As %String, nodeValue As %String, nodeProjection As %String)
{
	//w ..%pIndex_","_nodeName_","_nodeValue,!
	s ..%xmlData(nodeName) = nodeValue
	s ..%xmlNodeName(..%pIndex) = nodeName
	s ..%xmlNodeValue(..%pIndex) = nodeValue
	s ..%xmlProjection(..%pIndex) = nodeProjection
	s ..%pIndex = ..%pIndex + 1
}

Method Length()
{
	q ..%pIndex
}

Method Next()
{
	s ..%cursor = $o(..%xmlNodeValue(..%cursor))
	q:..%cursor="" 0
	q 1
}

Method Insert(xmlobj)
{
	s ..%xmlNodeValue(..%pIndex) = xmlobj
	s ..%pIndex = ..%pIndex + 1
}

/// override %New()
ClassMethod New(parentNodeName = "", projection = "", xmlName = "") As PHA.COM.XML
{
	s xmlObj = ##class(PHA.COM.XML).%New()
	s:parentNodeName="" xmlObj.%pIndex = xmlObj.%pIndex + 1
	q:parentNodeName="" xmlObj
	s xmlObj.%xmlProjection(xmlObj.%pIndex)=projection
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
		//判断是节点还是属性
		if $d(OBJ.%xmlProjection(0))&&($zcvt(OBJ.%xmlProjection(0),"u")="ATTRIBUTE")
		{
		}
		else
		{
			//节点
			//<name
			s nodeName=OBJ.%xmlNodeName(0)
			do xmlStream.Write("<"_OBJ.%xmlNodeName(0))			
			//处理属性子节点			
			set index = $o(OBJ.%xmlNodeValue(0))
			while(index'=""){
				set xmlNodeValue = OBJ.%xmlNodeValue(index)
				s flag=0
				if $d(OBJ.%xmlProjection(index)) {
					if ($zcvt(OBJ.%xmlProjection(index),"u")="ATTRIBUTE")
					{
						s flag=1
						;do ..ObjToXML(OBJ.Get(index), 0, xmlStream)	
						//属性
						do xmlStream.Write(" "_OBJ.%xmlNodeName(index))
						do xmlStream.Write("=""")
						try
						{
							do xmlStream.Write(OBJ.%xmlNodeValue(index))
						}
						catch{}
						do xmlStream.Write("""")							
					}
				}
				elseif ('flag)
				{
					if $IsObject(xmlNodeValue) {
						do ..AttributeToXML(xmlNodeValue, xmlStream)
					}
				}
				
				set index = $o(OBJ.%xmlNodeValue(index)) //get next index
			}
			//>
			do xmlStream.Write(">")	
			//处理其他子节点
			set index = $o(OBJ.%xmlNodeValue(0))
			while(index'=""){
				set xmlNodeValue = OBJ.%xmlNodeValue(index)
				if $IsObject(xmlNodeValue) 
				{
					do ..ObjToXML(xmlNodeValue, 0, xmlStream,encoding) // recursive method
				} 
				elseif ('$d(OBJ.%xmlProjection(index))) 
				{
					if ($d(OBJ.%xmlNodeName(index))) if (OBJ.%xmlNodeName(index)="attribute1") b ;87654
					if ($d(OBJ.%xmlNodeName(index)))
					{
						do xmlStream.Write("<"_OBJ.%xmlNodeName(index)_">")
					}
					do xmlStream.Write(xmlNodeValue)
					if ($d(OBJ.%xmlNodeName(index)))
					{
						do xmlStream.Write("</"_OBJ.%xmlNodeName(index)_">")
					}
				} 
				elseif ($zcvt(OBJ.%xmlProjection(index),"u")'="ATTRIBUTE") 
				{
					if ($d(OBJ.%xmlNodeName(index))) if (OBJ.%xmlNodeName(index)="attribute1") b ;321
					if ($d(OBJ.%xmlNodeName(index)))
					{
						do xmlStream.Write("<"_OBJ.%xmlNodeName(index)_">")
					}
					do xmlStream.Write(xmlNodeValue)
					if ($d(OBJ.%xmlNodeName(index)))
					{
						do xmlStream.Write("</"_OBJ.%xmlNodeName(index)_">")
					}
				}
				set index = $o(OBJ.%xmlNodeValue(index)) //get next index
			}
			//</name>
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

/// Creator: Huxt 2019-07-22
/// Desc: 对象转XML
ClassMethod AttributeToXML(OBJ, xmlStream As %Stream.GlobalCharacter = "") As %String
{
	if $IsObject(OBJ){
		;b ; 111
		//判断是节点还是属性
		if $d(OBJ.%xmlProjection(0))&&($zcvt(OBJ.%xmlProjection(0),"u")="ATTRIBUTE")
		{
			//属性
			do xmlStream.Write(" "_OBJ.%xmlNodeName(0))
			do xmlStream.Write("=""")
			try
			{
							
				set index = $o(OBJ.%xmlNodeValue(0))
				while(index'=""){
					if $d(OBJ.%xmlNodeName(index)) {
						if ($zcvt(OBJ.%xmlNodeName(index),"u")="VALUE")
						{
							do xmlStream.Write(OBJ.%xmlNodeValue(index))
							Q
						}
					}
					set index = $o(OBJ.%xmlNodeValue(index)) //get next index
				}
				;do xmlStream.Write(OBJ.%xmlNodeValue("Value"))
			}
			catch{}
			do xmlStream.Write("""")	 
		}
	}
}

/// Creator: Huxt 2019-07-22
/// Desc: 对象转XML
ClassMethod ObjToXML111(OBJ, xmlFirstFlag As %String = "", xmlStream As %Stream.GlobalCharacter = "", encoding = "utf-8") As %String
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
		;b ; 111
		//判断是节点还是属性
		if $d(OBJ.%xmlProjection(0))&&($zcvt(OBJ.%xmlProjection(0),"u")="ATTRIBUTE")
		{
		}
		else
		{
			//节点
			//<name
			;b ; w OBJ.%xmlNodeName(0)
			s nodeName=OBJ.%xmlNodeName(0)
			;if ($d())
			do xmlStream.Write("<"_OBJ.%xmlNodeName(0))			
			//处理属性子节点			
			set index = $o(OBJ.%xmlNodeValue(0))
			while(index'=""){
				set xmlNodeValue = OBJ.%xmlNodeValue(index)
				s flag=0
				if $d(OBJ.%xmlProjection(index)) {
					b ;333
					if ($zcvt(OBJ.%xmlProjection(index),"u")="ATTRIBUTE")
					{
						b ;444
						s flag=1
						;do ..ObjToXML(OBJ.Get(index), 0, xmlStream)	
						//属性
						do xmlStream.Write(" "_OBJ.%xmlNodeName(index))
						do xmlStream.Write("=""")
						try
						{
							do xmlStream.Write(OBJ.%xmlNodeValue(index))
						}
						catch{}
						do xmlStream.Write("""")							
					}
				}
				elseif ('flag)
				{
					if $IsObject(xmlNodeValue) {
						do ..AttributeToXML(xmlNodeValue, xmlStream)
					}
				}
				
				set index = $o(OBJ.%xmlNodeValue(index)) //get next index
			}
			//>
			do xmlStream.Write(">")	
			//处理其他子节点
			set index = $o(OBJ.%xmlNodeValue(0))
			while(index'=""){
				set xmlNodeValue = OBJ.%xmlNodeValue(index)
				if $IsObject(xmlNodeValue) {
					do ..ObjToXML(xmlNodeValue, 0, xmlStream) // recursive method
				} else {
					if ($d(OBJ.%xmlNodeName(index)))
					{
						do xmlStream.Write("<"_OBJ.%xmlNodeName(index)_">")
					}
					do xmlStream.Write(xmlNodeValue)
					if ($d(OBJ.%xmlNodeName(index)))
					{
						do xmlStream.Write("</"_OBJ.%xmlNodeName(index)_">")
					}
				}
				set index = $o(OBJ.%xmlNodeValue(index)) //get next index
			}
			//</name>
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
/// w ##class(PHA.COM.XML).FromXML("<Request><ExtUserID>demo</ExtUserID><Code></Code><HospitalId>1</HospitalId><datas><data><Name>123</Name><Sex>女</Sex></data><data><Name>023</Name><Sex>男</Sex></data></datas></Request>").ExtUserID
ClassMethod FromXML(xmlStr) As PHA.COM.XML
{
	set RootNode = ""
	set id = 0
	set xmlObj = ##class(PHA.COM.XML).%New()
	if $IsObject(xmlStr) d
	.set sc = ##class(%XML.TextReader).ParseStream(xmlStr,.reader)
	else  do
	.set sc = ##class(%XML.TextReader).ParseString(xmlStr,.reader)
	;b ; zw @reader.GlobalName@
	if $$$ISOK(sc){
		while (reader.Read()) {
			;zw reader
			set Type = reader.NodeType
			;zw Type
			set Path = reader.Path
			set Value = reader.Value
			;write Type_" , "_Path_" , "_Value,!
			if Type="element" {
				set id = id + 1
				if id=1 {
					set RootNode = Path
				}
				set objArr(Path,id) = ##class(PHA.COM.XML).%New()
				;w Path_","_id,!
				;b ;
				//add by yyl,增加属性的反序列化
				if (reader.AttributeCountGet()>0)
				{
					s attrseq=""
					s target=$Order(@reader.GlobalName@(""))
					if (target'="")
					{
						s parentId=id
						f
						{
							s attrseq=$Order(@reader.GlobalName@(target,reader.seq,attrseq))
							q:(attrseq="")
							set id = id + 1
							s atrName=$li(@reader.GlobalName@(target,reader.seq,attrseq),3)
							s atrValue=$li(@reader.GlobalName@(target,reader.seq,attrseq),5)
							s atrPath=Path_"/"_atrName
							;b ; w atrValue
							set objArr(atrPath,id) = ##class(PHA.COM.XML).%New()
							do objArr(atrPath,id).Set(atrName,atrValue,"attribute")
							
							do objArr(Path,parentId).Set(atrName, atrValue,"")
							;b ; zw objArr(Path,parentId)
						}
					}
				}
				//
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
				set nodeName=$p(Path,"/",$l(Path,"/"))
				set nodeName=$replace(nodeName,"_","")
				do objArr(lastPath,tempId).Set(nodeName, objArr(Path,nId),"")
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
