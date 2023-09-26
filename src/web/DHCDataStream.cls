/// /import SQLUser
Class web.DHCDataStream Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// /把文件生成Stream流函数?同时返回流
ClassMethod FileToStream(fileName As %String = "") As %Stream
{
	i fileName="" {
		Quit "String Err!"
	}
	s file=##class(%File).%New(fileName)
	Do file.Open("RU")
	s tmpstream=##class(%GlobalCharacterStream).%New()  
	d tmpstream.CopyFrom(file)  
	d file.%Close()
	quit tmpstream
}

ClassMethod ReadServerXML(CFlag As %String) As %Stream
{
	////Test    d ##class(web.DHCDataStream).ReadServerXML("test1")
	s CFlag=$g(CFlag)
	Set stream = ##class(%GlobalCharacterStream).%New()	
	////This will fetch the ?Stream Id? value used to store the stream into memo (not the value of the stream)
	&sql(select XPC_FileData into :fdata from SQLUser.DHC_XMLPConfig where XPC_Flag=:CFlag)
	////返回一个空的Stream
	b
	q:SQLCODE stream
	////Now you can open a %SerialStream object from this ID value and use the Stream API
	s fstream=##class(%SerialStream).%Open(fdata)
	//Moves the current location to the beginning of the stream
	d fstream.Rewind()
	//Stream Trans Value Translate
	b
	d stream.CopyFrom(fstream)
	b
	
	d fstream.%Close()
	d stream.Rewind()
	
	q stream			;;;stream.Size	;;"Test"	;
}

ClassMethod ReadServerXMLOld(CFlag As %String) As %Stream
{
	////%Stream
	////Test    d ##class(web.DHCDataStream).ReadServerXML("test1")
	
	s CFlag=$g(CFlag)
	Set stream = ##class(%GlobalCharacterStream).%New()
	
	////This will fetch the ?Stream Id? value used to store the stream into memo (not the value of the stream)
	&sql(select XPC_FileData into :fdata from SQLUser.DHC_XMLPConfig where XPC_Flag=:CFlag)
	////返回一个空的Stream
	q:SQLCODE stream
	
	////Now you can open a %SerialStream object from this ID value and use the Stream API
	s fstream=##class(%SerialStream).%Open(fdata)
	//Moves the current location to the beginning of the stream
	d fstream.Rewind()
	
	//Stream Trans Value Translate
	d stream.CopyFrom(fstream)
	
	d fstream.%Close()
	;b	;;ReadServerXML
	d stream.Rewind()
	
	s mystr=stream.Read(5000)
	s mylen=$l(mystr,$c(13))
	s dd=""
	f i=1:1:mylen d
		.s myval=$p(mystr,$c(13),i)
		.s rtnval="ReadStream('"_$ZCVT($g(myval),"O","JS")_"');"
		.;&javascript<#(rtnval)#>
		.s dd=dd_$p(mystr,$c(13),i)
	
	q $ZCVT($g(mystr),"O","JS") ;;$l(dd,$c(13))			;;;stream.Size	;;"Test"	;
}

ClassMethod TestEdit() As %String
{
	////如果添加其他的模版请在此标注：谢谢；zhaocz
	////d ##class(web.DHCDataStream).TestEdit()
	////   INVPrtFlag   门诊收费票据打印
	////   
	s myconfig=##class(web.DHCXMLPConfig).ReadByFlag("OrderItemPrint")
	;INVPrtFlag
	s myconfig.XPCFlag="OrderItemPrint"
	s mystream=..FileToStream("D:\config_OrderItemPrint.xml")
	d myconfig.XPCFileData.CopyFrom(mystream)
	
	d myconfig.%Save()
	d myconfig.%Close()
	
	d mystream.%Close()
}

ClassMethod TestSave() As %String
{
	////d ##class(web.DHCDataStream).TestSave()
	s myconfig=##class(User.DHCXMLPConfig).%New()
	
	s mystream=##class(web.DHCDataStream).ReadServerXML("OrderItemPrint")
	
	;s myconfig.XPCFlag="Test1"
	;s mystream=..FileToStream("D:\TrakCare\App\Results\Template\config.xml")
	s mystream=..FileToStream("D:\config_OrderItemPrint.xml")
	d myconfig.XPCFileData.CopyFrom(mystream)
	
	d myconfig.%Save()
	d myconfig.%Close()
	
	d mystream.%Close()
}

}
