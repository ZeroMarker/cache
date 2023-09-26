Class DHCCPM.BLL.NewClass1 Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Method MyMethod() [ CodeMode = objectgenerator ]
{
	    s myinfo=%class.Name
	    w myinfo
        Do %code.WriteLine(" Write """ _ %class.Name _ """")
        Do %code.WriteLine(" Quit")
        Quit $$$OK
}

/// 
/// 在M中调用 WebService的方式
/// 
ClassMethod testkb()
{
	s AEKBCategory = ##Class(EPRservice.entity.EKBCategory).%New()
	s AEKBCategory.ID="14"
	
	
	 set AEKBCategory.Name="UUU"
 //s ^AA("objKBCategory")=AEKBCategory.Name_"@@"_AEKBCategory.ParentID_"@@"_AEKBCategory.ID
 set AEKBCategory.ParentID="13"
 set AEKBCategory.Description="8888"
 d ##class(EPRservice.BOKBCategory).UpdateKBCategory(AEKBCategory)
}

ClassMethod Test()
{
	;d ##class(DHCCPM.BLL.NewClass1).Test()
	
	s mystr="<INV><ADMDate>1aaaaaa</ADMDate></INV>"
	s mystr="<INV><ADMDate>1aaaaaa</ADMDate></INV>"
	s myobj=##class(DHCCPM.INCOMMON.INV).%New()
	;b		;
	d myobj.XMLDeserialize(.myobj, mystr)
	w myobj.ADMDate
	w myobj.ADMRowID
	b
	d myobj.XMLExportToString(.mystr)
	w mystr
	d myobj.%Close()
}

ClassMethod TestList()
{
	;d ##class(DHCCPM.BLL.NewClass1).TestList()
	
	s mystr="<INV><ADMDate>1aaaaaa</ADMDate></INV>"
	s mystr="<INV><ADMDate>1aaaaaa</ADMDate></INV>"
	s mystr="<DHCPAPATMAS><PatName>Pat</PatName><RowID/></DHCPAPATMAS>"
	s mystr="<PAADMS><DHCPAADM><ADMDate>12121</ADMDate></DHCPAADM><DHCPAADM><ADMDate>12121</ADMDate></DHCPAADM></PAADMS></DHCPAPATMAS>"
	
	s myadm=##class(DHCCPM.INCOMMON.DHCPAADM).%New()
	
	s myadm.ADMDate="ADMDate"

	s myadm1=##class(DHCCPM.INCOMMON.DHCPAADM).%New()
	
	s myadm1.ADMDate="2007-08-10"
	
	s myobj=##class(DHCCPM.INCOMMON.DHCPAPATMAS).%New()
	s myobj.PatName="张山"
	s myobj.RowID=12
	d myobj.PAADMS.Insert(myadm)
	d myobj.PAADMS.Insert(myadm1)
	
	d myobj.XMLExportToString(.myXMLStr)
	w myXMLStr
	d myobj.%Close()
	b		;
	s myDesXML="<DHCPAPATMAS xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/20001/XMLSchema'><PAADMS><DHCPAADM><ADate>ADMDate</ADate></DHCPAADM><DHCPAADM><ADate>2007-08-10</ADate></DHCPAADM></PAADMS><PatName>张山aaaa</PatName><RowID>12</RowID></DHCPAPATMAS>"

	s myobj1=##class(DHCCPM.INCOMMON.DHCPAPATMAS).%New()
	
	//d myobj1.XMLNodeDeserialize(.myobj1,"DHCPAPATMAS", myXMLStr)
	d myobj1.XMLDeserialize(.myobj1, myDesXML)
	d myobj1.Trans()
	
	//d myobj.XMLDeserialize(myXMLStr)
	w myobj1.PatName,!
	w myobj1.RowID,!
	s myobjadm=myobj1.PAADMS.GetAt(myobj1.PAADMS.Count())
	w myobjadm.ADMDate
	b
	///d myobj.XMLExport()
	
	d myobj.%Close()
}

}
