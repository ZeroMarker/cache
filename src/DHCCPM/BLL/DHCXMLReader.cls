Class DHCCPM.BLL.DHCXMLReader Extends %RegisteredObject [ Abstract, ClassType = "", LegacyInstanceContext, ProcedureBlock ]
{

Method RepairPropertyValue(ByRef object As %ObjectHandle) As %String
{
	;修复属性值为$c(0)  值
	;Properties
	;包名称 + 类名称
	s myClassName=##this.%ClassName(1)
	set ClassDef = ##class(%Library.ClassDefinition).%OpenId(myClassName)
	s myCount=ClassDef.Properties.Count()
	
	f i = 1:1:myCount d
	.s myPropertyName=ClassDef.Properties.GetAt(i).Name
	.i $ZOBJPROPERTY(object, myPropertyName)=$c(0) d
	..s $ZOBJPROPERTY(object, myPropertyName)=""
	.;w $ZOBJPROPERTY(object, myPropertyName)=$c(0),!,myPropertyName, !
	
	d ClassDef.%Close()
	quit $$$OK
}

Method XMLDeserialize(ByRef object As %ObjectHandle, XMLStream As %String)
{
	;ByRef oref As %ObjectHandle, ByRef sc As %Status
	;提供一个反序列化的函数
	;s myobj=##class(DHCCPM.INCOMMON.DHCPAPATMAS).%New()
	;d myobj.XMLDeserialize(.myobj,"")
	;或者直接执行一个类方法
	;d ##class(DHCCPM.INCOMMON.DHCPAPATMAS).XMLDeserialize(.obj,"")
	;只有类名称
	s myClassName=##this.%ClassName(0)
	;获取节点名称
	s myNode=""
	s myNode=myClassName
	
	d ..XMLNodeDeserialize(.object, myNode, XMLStream)
	
	quit
	
	;n reader
	Set reader = ##class(%XML.Reader).%New()
	// Begin processing of the XML input
	// Set sc=reader.OpenFile(filename)
	s sc=reader.OpenString(XMLStream)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit  
	
	//可以获取Object的类名
	//和其他信息
	//##this   来替换
	;n myClassName, myNode
	//s myClassName=%this_""
	//s myClassName=$P(myClassName,"@",2)
	s myClassName=##this.%ClassName(1)
	;获取节点名称
	s myNode=""
	s mylen=$l(myClassName,".")
	s myNode=$p(myClassName,".",mylen)
	
	// Associate a class name with the XML element name
	Do reader.Correlate(myNode, myClassName)
	
	;n myDesobj
	// read Sample.Person objects from xml file
	Set Count=0
	if reader.Next(.myDesobj,.sc) {
	    Set Count=Count+1
	    s object=myDesobj
	    If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit
	}
	
	if ($ISOBJECT(myDesobj)){
		d myDesobj.%Close()
		s myDesobj=""
	}
	
	Quit
}

Method XMLNodeDeserialize(ByRef object As %ObjectHandle, XMLNode As %String, XMLStream As %String)
{
	;ByRef oref As %ObjectHandle, ByRef sc As %Status
	;提供一个反序列化的函数
	;s myobj=##class(DHCCPM.INCOMMON.DHCPAPATMAS).%New()
	;d myobj.XMLDeserialize(.myobj,"")
	;或者直接执行一个类方法
	;d ##class(DHCCPM.INCOMMON.DHCPAPATMAS).XMLDeserialize(.obj,"")
	
	q:($g(XMLNode)="")
	q:($g(XMLStream)="")
	
	;n reader
	Set reader = ##class(%XML.Reader).%New()
	// Begin processing of the XML input
	// Set sc=reader.OpenFile(filename)
	s sc=reader.OpenString(XMLStream)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit  
	
	//可以获取Object的类名
	//和其他信息
	//##this   来替换
	;n myClassName, myNode
	//s myClassName=%this_""
	//s myClassName=$P(myClassName,"@",2)
	s myClassName=##this.%ClassName(1)
	s myNode=$g(XMLNode) 			;$p(myClassName,".",mylen)
	
	// Associate a class name with the XML element name
	Do reader.Correlate(myNode, myClassName)
	
	;n myDesobj
	// read Sample.Person objects from xml file
	Set Count=0
	if reader.Next(.myDesobj,.sc) {
	    Set Count=Count+1
	    s object=myDesobj
	    If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit
	}
	
	if ($ISOBJECT(myDesobj)){
		d myDesobj.%Close()
		s myDesobj=""
	}
	
	d ..RepairPropertyValue(object)
	
	Quit
}

Method XMLDeserializeOld(XMLStream As %String)
{
	;ByRef oref As %ObjectHandle, ByRef sc As %Status
	;提供一个反序列化的函数
	;s myobj=##class(DHCCPM.INCOMMON.DHCPAPATMAS).%New()
	;d myobj.XMLDeserialize(.myobj,"")
	;或者直接执行一个类方法
	;d ##class(DHCCPM.INCOMMON.DHCPAPATMAS).XMLDeserialize(.obj,"")
	
	;n reader
	//s XMLStream="<DHCPAPATMAS><PatName>Pat</PatName><RowID/></DHCPAPATMAS>"
	Set reader = ##class(%XML.Reader).%New()
	// Begin processing of the XML input
	// Set sc=reader.OpenFile(filename)
	s sc=reader.OpenString(XMLStream)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit  
	
	//可以获取Object的类名
	//和其他信息
	//##this   来替换
	;n myClassName, myNode
	//s myClassName=object_""
	s myClassName=%this_""
	s myClassName=$P(myClassName,"@",2)
	s myNode=""
	s mylen=$l(myClassName,".")
	s myNode=$p(myClassName,".",mylen)
	
	// Associate a class name with the XML element name
	Do reader.Correlate(myNode, myClassName)
	
	;n myDesobj
	// read Sample.Person objects from xml file
	Set Count=0
	if reader.Next(.myDesobj,.sc) {
	    Set Count=Count+1
	    s ##this=myDesobj
	    If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit
	}
	b		;;TMP
	if ($ISOBJECT(myDesobj)){
		d myDesobj.%Close()
		s myDesobj=""
	}
	b	;;
	Quit
}

Method GetInfo() As %Status [ CodeMode = generator ]
{
	//n myInfo
	
	// Begin processing of the XML input
	// Set sc=reader.OpenFile(filename)
	//s myInfo=%class.Name
	QUIT $$$OK
}

ClassMethod CloneXMLDeserialize(XMLStream As %String, ClassName As %String) As %ObjectHandle
{
	;ByRef oref As %ObjectHandle, ByRef sc As %Status
	;提供一个反序列化的函数
	;s myobj=##class(DHCCPM.INCOMMON.DHCPAPATMAS).%New()
	;d myobj.XMLDeserialize(.myobj,"")
	;或者直接执行一个类方法
	;s myobj=##class(DHCCPM.INCOMMON.DHCPAPATMAS).CloneXMLDeserialize("")
	
	;Do ##super()
	
	s XMLStream="<DHCPAPATMAS><PatName>Pat</PatName><RowID/></DHCPAPATMAS>"
	Set reader = ##class(%XML.Reader).%New()
	// Begin processing of the XML input
	// Set sc=reader.OpenFile(filename)
	s sc=reader.OpenString(XMLStream)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit sc
	;b		;;;Open
	//可以获取Object的类名
	//和其他信息
	//
	//s myClassName=..GetClassName()
	// Associate a class name with the XML element name
	
	Do reader.Correlate("DHCPAPATMAS",ClassName)
	s object=""
	// read Sample.Person objects from xml file
	Set Count=0
	if reader.Next(.myDesobj,.sc) {
	    Set Count=Count+1
	    s object=myDesobj
	    If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit
	}
	d myDesobj.%Close()
	
	quit object
}

/// 交换数据
/// 前提条件：  
/// 1. 利用两个属性值相同来 交换数据
/// 2. 
/// 目的： 
/// 可以为同一个对象生成不同的XML数据结构
Method ExchangeData(SourceObject As %ObjectHandle) As %String
{
	//本身类的属性
	;k TMPLibClassDef($j)
	;转换为变量 检测
	d ..KillTMP()
	
	s TMPLibClassDef=""
	d ..SetPropertyList(SourceObject, .TMPLibClassDef)
	
	s myClassName=##this.%ClassName(1)
	set ClassDef = ##class(%Library.ClassDefinition).%OpenId(myClassName)
	s myCount=ClassDef.Properties.Count()
	
	f i = 1:1:myCount d
	.s myPropertyName=ClassDef.Properties.GetAt(i).Name
	.q:'($d(TMPLibClassDef($j,"PropertyName",myPropertyName)))
	.;i $ZOBJPROPERTY(%this, myPropertyName)=$c(0) d
	.;b	;;;
	.s $ZOBJPROPERTY(%this, myPropertyName)=$ZOBJPROPERTY(SourceObject, myPropertyName)
	
	d ClassDef.%Close()
	;b	;KillTMP
	d ..KillTMP()
	
	quit $$$OK
}

/// 计算相同属性的数据
/// 同时在计算时
/// 前提条件：  
/// 1. 利用两个属性值相同来 计算属性值
/// 2. 
/// 目的： 对于 多个对象的统一 计算可以减少 代码量
Method CalculateData(SourceObject As %ObjectHandle, OperSign As %String) As %String
{
	//本身类的属性
	;k TMPLibClassDef($j)
	;OperSign
	;转换为变量 检测
	d ..KillTMP()
	
	s TMPLibClassDef=""
	d ..SetPropertyList(SourceObject, .TMPLibClassDef)
	
	s myClassName=##this.%ClassName(1)
	set ClassDef = ##class(%Library.ClassDefinition).%OpenId(myClassName)
	s myCount=ClassDef.Properties.Count()
	
	f i = 1:1:myCount d
	.s myPropertyName=ClassDef.Properties.GetAt(i).Name
	.q:'($d(TMPLibClassDef($j,"PropertyName",myPropertyName)))
	.;i $ZOBJPROPERTY(%this, myPropertyName)=$c(0) d
	.;b	;;;
	.s $ZOBJPROPERTY(%this, myPropertyName)=$ZOBJPROPERTY(SourceObject, myPropertyName)
	
	d ClassDef.%Close()
	;b	;KillTMP
	d ..KillTMP()
	
	quit $$$OK
}

/// 生成属性列表
Method SetPropertyList(OID As %ObjectHandle, ByRef TMPLibClassDef) As %String [ Private ]
{
	s myClassName=OID.%ClassName(1)
	set ClassDef = ##class(%Library.ClassDefinition).%OpenId(myClassName)
	s myCount=ClassDef.Properties.Count()
	
	f i = 1:1:myCount d
	.s myPropertyName=ClassDef.Properties.GetAt(i).Name
	.q:(myPropertyName="")
	.s TMPLibClassDef($j,"PropertyName",myPropertyName)=""
	.;s ^TMPLibClassDef($j,"PropertyName",myPropertyName)=ClassDef.Properties.GetAt(i).Type
	
	d ClassDef.%Close()
	
	quit $$$OK
}

/// 生成参数列表
Method SetParameterList(OID As %ObjectHandle) As %String [ Private ]
{
	s myClassName=OID.%ClassName(1)
	set ClassDef = ##class(%Library.ClassDefinition).%OpenId(myClassName)
	s myCount=ClassDef.Parameters.Count()
	
	f i = 1:1:myCount d
	.s myParameterName=ClassDef.Parameters.GetAt(i).Name
	.q:(myParameterName="")
	.s TMPLibClassDef($j,"ParameterName",myParameterName)=""
	
	d ClassDef.%Close()
	
	quit $$$OK
}

Method KillTMP()
{
	k TMPLibClassDef($j)
}

Method XMLExportToStringExp(ByRef XmlData As %String) As %Status
{
	s myXmlDate=""
	
	s myXmlTagStr=""
	s myClassNameTag = ##this.%ClassName(0)
	s myClassName=##this.%ClassName(1)
	set ClassDef = ##class(%Library.ClassDefinition).%OpenId(myClassName)
	s myCount=ClassDef.Properties.Count()
	
	f i = 1:1:myCount d
	.s myPropertyName=ClassDef.Properties.GetAt(i).Name
	.s myParameterXmlName=ClassDef.Properties.GetAt(i).Parameters.GetAt("XMLNAME")
	.i (myParameterXmlName="") d
	..s myParameterXmlName=myPropertyName
	.i $ZOBJPROPERTY(##this, myPropertyName)=$c(0) d
	..s $ZOBJPROPERTY(##this, myPropertyName)=""
	.s myXmlVal = $ZOBJPROPERTY(##this, myPropertyName)
	.s myXmlTagStr=myXmlTagStr_"<"_myParameterXmlName_">"_myXmlVal_"</"_myParameterXmlName_">"
	.;w $ZOBJPROPERTY(object, myPropertyName)=$c(0),!,myPropertyName, !
	
	s myXmlDate = "<"_myClassNameTag_">"_myXmlTagStr_"</"_myClassNameTag_">"
	
	d ClassDef.%Close()
	
	s XmlData=myXmlDate
	
	q $$$OK
}

}
