Class DHCCPM.INCOMMON.DHCPAPATMAS Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Property PAADMS As list Of DHCCPM.INCOMMON.DHCPAADM;

Property PatName As %String(TRUNCATE = 1);

Property PatID As %String(TRUNCATE = 1);

Property RowID As %String(TRUNCATE = 1);

Method Trans()
{
	//s ..id=..methidd(..patname)
}

Method XMLDeserializeOLD(ByRef object As %ObjectHandle, XMLStream As %String)
{
	;ByRef oref As %ObjectHandle, ByRef sc As %Status
	;提供一个反序列化的函数
	;s myobj=##class(DHCCPM.INCOMMON.DHCPAPATMAS).%New()
	;d myobj.XMLDeserialize(.myobj,"")
	;或者直接执行一个类方法
	;d ##class(DHCCPM.INCOMMON.DHCPAPATMAS).XMLDeserialize(.obj,"")
	
	s XMLStream="<DHCPAPATMAS><PatName>Pat</PatName><RowID/></DHCPAPATMAS>"
	Set reader = ##class(%XML.Reader).%New()
	// Begin processing of the XML input
	// Set sc=reader.OpenFile(filename)
	s sc=reader.OpenString(XMLStream)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit  
	b		;;;Open
	//可以获取Object的类名
	//和其他信息
	//
	// Associate a class name with the XML element name
	Do reader.Correlate("DHCPAPATMAS","DHCCPM.INCOMMON.DHCPAPATMAS")
	
	// read Sample.Person objects from xml file
	Set Count=0
	if reader.Next(.myDesobj,.sc) {
	    Set Count=Count+1
	    s object=myDesobj
	    //Set sc=person.%Save()
	    b	;;;
	    If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit
	}
	
	d myDesobj.%Close()
}

ClassMethod CloneXMLDeserializeOld(XMLStream As %String) As %ObjectHandle
{
	;ByRef oref As %ObjectHandle, ByRef sc As %Status
	;提供一个反序列化的函数
	;s myobj=##class(DHCCPM.INCOMMON.DHCPAPATMAS).%New()
	;d myobj.XMLDeserialize(.myobj,"")
	;或者直接执行一个类方法
	;s myobj=##class(DHCCPM.INCOMMON.DHCPAPATMAS).CloneXMLDeserialize("", "DHCCPM.INCOMMON.DHCPAPATMAS")
	
	;Do ##super()
	
	s XMLStream="<DHCPAPATMAS><PatName>Pat</PatName><RowID/></DHCPAPATMAS>"
	Set reader = ##class(%XML.Reader).%New()
	// Begin processing of the XML input
	// Set sc=reader.OpenFile(filename)
	s sc=reader.OpenString(XMLStream)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit sc
	b		;;;Open
	//可以获取Object的类名
	//和其他信息
	//
	// Associate a class name with the XML element name
	Do reader.Correlate("DHCPAPATMAS","DHCCPM.INCOMMON.DHCPAPATMAS")
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

Method ListProperties() [ CodeMode = objectgenerator ]
{
	//w ##class(DHCCPM.INCOMMON.DHCPAPATMAS).ListProperties()
    For i = 1:1:%compiledclass.Properties.Count() {
        Set prop = %compiledclass.Properties.GetAt(i).Name
        Do %code.WriteLine(" Write """ _ prop _ """,!")
    }
    //Do %code.WriteLine(" Quit")
    Quit $$$OK
}

}
