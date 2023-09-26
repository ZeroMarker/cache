Class web.DHCParseXML Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// /把记录集解析到这个类方法中?
ClassMethod ParseListData() As %Stream
{
	
	Quit
}

/// /把定位打印数据解析到这个方法中?
ClassMethod ParseTxtData() As %Stream
{
	Quit
}

ClassMethod ReadFrmStream(cflag As %String) As %String
{
	////d ##class(web.DHCParseXML).ReadFrmStream("Test1")
	s mystream=##class(web.DHCDataStream).ReadServerXML(cflag)
	if mystream.Size=0{
		quit 
	}
	w mystream.Size
	b
	Set tmpstream = ##class(%GlobalCharacterStream).%New()
	d tmpstream.CopyFrom(mystream)
	
	s myidx=0
	d tmpstream.Rewind()
	
	s sc=##class(%XML.TextReader).ParseStream(tmpstream,.readobj)
	If ($$$ISOK(sc)) {
		//保持原来的Stream
		
		// Read all elements within the document
		While (readobj.Read()) {
 if myidx=1{
	 		break
 }

 if (readobj.HasAttributes){
	 		w "HasAttributes",!
	 		w readobj.Depth,!
 }

 if (readobj.NodeType="attribute"){
 }

 If (readobj.NodeType = "element") {
 ;Write readobj.Name_"^"_readobj.Value,!

			}

			;w readobj.AttributeCount_"^"_readobj.NodeType,!,!
			
			If (readobj.MoveToAttributeName("name")) {
				;s readobj.Value="打印"
				;Write "name = ",readobj.Value,!
			}
			
			If (readobj.MoveToAttributeName("xcol")) {
				;Write "xcol = ",readobj.Value,!
			}
			If (readobj.MoveToAttributeName("fontname")) {
				;;b  ;;
				;Write "fontname = ",readobj.Value,!
			}
			;b
		}
	}
	
	Quit
}

ClassMethod ReadFromFile()
{
 // Create an instance of %XML.TextReader (returned by reference)
 //Set sc = ##class(%XML.TextReader).ParseFile(filename,.reader)
 Set sc = ##class(%XML.TextReader).ParseFile("E:\TrakCareJST\App\Results\Template\config.xml",.reader)
 ;b
 If ($$$ISOK(sc)) {
 // Read all elements within the document
 While (reader.Read()) {
 if (reader.NodeType="attribute"){
 }

 If (reader.NodeType = "element") {
 Write reader.Name_"^"_reader.Value,!

 }

 w reader.AttributeCount_"^"_reader.NodeType,!,!

 If (reader.MoveToAttributeName("name")) {
 Write "name = ",reader.Value,!
 }
 If (reader.MoveToAttributeName("xcol")) {
 Write "xcol = ",reader.Value,!
 }
 If (reader.MoveToAttributeName("fontname")) {
 Write "fontname = ",reader.Value,!
 }

 }
 }

 quit
}

ClassMethod SAXTest()
{
	////d ##class(web.DHCParseXML).SAXTest
	s mystream=##class(web.DHCDataStream).ReadServerXML("test1")
	if mystream.Size=0{
		quit 
	}
	
	d ##class(web.SAXHandlerNew).ParseStream(mystream)
	
	q
}

}
