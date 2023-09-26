Class web.DHCBL.CARD.DHCTimeRangeBuilder Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod DHCTimeRangeDelete(DHCTimeRangeInfo As %String) As %String
{
 TStart

 s PDHCTimeRangeInfo=##class(web.DHCEntity.PCA.DHCTimeRange).%New()
	d PDHCTimeRangeInfo.XMLNodeDeserialize(.PDHCTimeRangeInfo,"TransContent",DHCTimeRangeInfo)
 set status=##class(web.DHCBL.CARD.DHCTimeRange).DHCTimeRangeDelete(PDHCTimeRangeInfo)
	if status="-100" {
		TRollback
		quit -100 
	}
	
 TCommit
 quit 0
}

ClassMethod DHCTimeRangeInsert(DHCTimeRangeInfo As %String, HospID = "") As %String
{
	s ^yjm("insertBuilder")=DHCTimeRangeInfo
 TStart

 s PDHCTimeRangeInfo=##class(web.DHCEntity.PCA.DHCTimeRange).%New()
	d PDHCTimeRangeInfo.XMLNodeDeserialize(.PDHCTimeRangeInfo,"TransContent",DHCTimeRangeInfo)
	//s ^yjm("TRCode")=PDHCTimeRangeInfo.TRCode
 set status=##class(web.DHCBL.CARD.DHCTimeRange).DHCTimeRangeInsert(PDHCTimeRangeInfo,HospID)
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

ClassMethod DHCTimeRangeUpdate(DHCTimeRangeInfo As %String) As %String
{
	//s ^yjm("insertBuilder")=DHCTimeRangeInfo
 TStart

 s PDHCTimeRangeInfo=##class(web.DHCEntity.PCA.DHCTimeRange).%New()
	d PDHCTimeRangeInfo.XMLNodeDeserialize(.PDHCTimeRangeInfo,"TransContent",DHCTimeRangeInfo)
 set status=##class(web.DHCBL.CARD.DHCTimeRange).DHCTimeRangeUpdate(PDHCTimeRangeInfo)
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

}
