Class web.DHCBL.CARD.DHCRBCReasonNotAvailBuilder Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod DHCRBCReasonNotAvailInsert(DHCRBCReasonNotAvailInfo As %String) As %String
{
 TStart

 s PDHCRBCReasonNotAvailInfo=##class(web.DHCEntity.PCA.DHCRBCReasonNotAvail).%New()
 d PDHCRBCReasonNotAvailInfo.XMLNodeDeserialize(.PDHCRBCReasonNotAvailInfo,"TransContent",DHCRBCReasonNotAvailInfo)
 set status=##class(web.DHCBL.CARD.DHCRBCReasonNotAvail).DHCRBCReasonNotAvailInsert(PDHCRBCReasonNotAvailInfo)
	if status="-100" {
		TRollback
		quit -100 
	}
	if status="10" {
		TRollback
		quit 10 
	}	
	
 TCommit
 quit 0
}

ClassMethod DHCRBCReasonNotAvailUpdate(DHCRBCReasonNotAvailInfo As %String) As %String
{
 //DHCRBCReasonNotAvailUpdate   

 TStart

 s PDHCRBCReasonNotAvailInfo=##class(web.DHCEntity.PCA.DHCRBCReasonNotAvail).%New()
	d PDHCRBCReasonNotAvailInfo.XMLNodeDeserialize(.PDHCRBCReasonNotAvailInfo,"TransContent",DHCRBCReasonNotAvailInfo)
 set status=##class(web.DHCBL.CARD.DHCRBCReasonNotAvail).DHCRBCReasonNotAvailUpdate(PDHCRBCReasonNotAvailInfo)
	if status="-100" {                                      
		TRollback
		quit -100 
	}
	
 TCommit
 quit 0
}

//w ##class(web.DHCBL.CARD.DHCRBCReasonNotAvailBuilder).GetTIDByCode("03")

ClassMethod GetTIDByCode(InPutCode As %String, ID As %String) As %String
{
	s InPutCode=$$ALPHAUP^SSUTIL4(InPutCode)
	s RowID=""
	i InPutCode'="" s RowID=$O(^RBC("NA",0,"Code",InPutCode,RowID))
	q:(+RowID'=ID) (+RowID)
	q 0
}

}
