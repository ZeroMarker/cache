Include %occStatus

Class DHCCPMWeb.CPMBL.XMLSerial Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod ObjToXMLTrans()
{
}

ClassMethod XMLToObjTrans() As DHCCPMWeb.CPMSevice.entity.DHCEReports
{
	;d ##class(DHCCPMWeb.CPMBL.XMLSerial).XMLToObjTrans()
	s myrep=##class(DHCCPMWeb.CPMBL.DHCBLReports).GetCurVerRep(8,1)
	Set mystream = ##class(%GlobalCharacterStream).%New()
	
	d myrep.XMLExportToStream(.mystream)
	
	s filename=""
	
	Set reader = ##class(%XML.Reader).%New()
	// Begin processing of the XML input
	//Set sc=reader.OpenFile(filename)
	s sc=reader.OpenStream(mystream)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit  
	
	// Associate a class name with the XML element name
	Do reader.Correlate("DHCEReports","DHCCPMWeb.CPMSevice.entity.DHCEReports")
	
	//Do reader.Correlate("DHCERepPanels","DHCCPMWeb.CPMSevice.entity.DHCERepPanels")
	
	// read Sample.Person objects from xml file
	Set Count=0
	
	While reader.Next(.object,.sc) {
	    
	    Set Count=Count+1
	    s myoutobj=object
	    //Set sc=person.%Save()
	    b	;;;
	    If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit
	}
	//If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit  
	Write Count_" Sample.Person instances found."
	b
	d mystream.%Close()
	
	q myoutobj
}

ClassMethod XMLToObjTransSimple()
{
	;d ##class(DHCCPMWeb.CPMBL.XMLSerial).XMLToObjTransSimple()
	;s myrep=##class(DHCCPMWeb.CPMBL.DHCBLReports).GetCurVerRep(8,1)
	s myobj=##class(DHCCPMWeb.CPMSevice.entity.DHCERepFields).%New()
	d myobj.SetField("RFCaption" , "RFDataType", "RFDefaultValue", "RFDescription", "RFName")
	
	
	Set mystream = ##class(%GlobalCharacterStream).%New()
	
	d myobj.XMLExportToStream(.mystream)
	
	d myobj.XMLExportToString(mystr)
	
	s filename=""
	b
	
	Set reader = ##class(%XML.Reader).%New()
	// Begin processing of the XML input
	//Set sc=reader.OpenFile(filename)
	s sc=reader.OpenStream(mystream)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit  
	
	// Associate a class name with the XML element name
	Do reader.Correlate("DHCERepFields","DHCCPMWeb.CPMSevice.entity.DHCERepFields")
	
	b
	// read Sample.Person objects from xml file
	Set Count=0
	b
	While reader.Next(.object,.sc) {
	    
	    Set Count=Count+1
	    //Set sc=person.%Save()
	    b	;;;
	    If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit  
	}
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit  
	Write Count_" Sample.Person instances found."
}

ClassMethod mytest()
{
	;d ##class(DHCCPMWeb.CPMBL.XMLSerial).mytest()
	s mystr=##class(DHCCPM.Service.DHCBOPharmic).GetReport()
	b
}

ClassMethod XMLATest()
{
	n 
	;d ##class(DHCCPMWeb.CPMBL.XMLSerial).XMLATest()
	s myobj=##class(DHCCPMWeb.CPMSevice.entity.IPParas).%New()
	
	s myTPara1=##class(DHCCPMWeb.CPMSevice.entity.TxtPara).%New()
	s myTPara1.EName="PatName"
	s myTPara1.EValue=""
	s myTPara1.EDataType="String"
	
	s myTPara2=##class(DHCCPMWeb.CPMSevice.entity.TxtPara).%New()
	s myTPara2.EName="Sex"
	s myTPara2.EValue="男"
	s myTPara2.EDataType="String"
	
	s myTPara3=##class(DHCCPMWeb.CPMSevice.entity.TxtPara).%New()
	s myTPara3.EName="PAPMINo"
	s myTPara3.EValue="00000001"
	s myTPara3.EDataType="String"
	
	d myobj.IPPara.Insert(myTPara1)
	d myobj.IPPara.Insert(myTPara2)
	d myobj.IPPara.Insert(myTPara3)
	
	d myTPara1.%Close()
	d myTPara2.%Close()
	d myTPara3.%Close()
	
	d myobj.XMLExport()
	
	d myobj.%Close()
}

}
