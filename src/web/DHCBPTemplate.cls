Import SQLUser

Class web.DHCBPTemplate Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCBPTemplate","FindTemplateList")
Query FindTemplateList(TemplateCatCode As %String = "") As %Query(ROWSPEC = "Id:%String,Code:%String,Description:%String,IfActive:%String,BPCTBPCTCatID:%String,BPCTBPCTCatDesc:%String,Data:%String") [ SqlProc ]
{
}

ClassMethod FindTemplateListExecute(ByRef qHandle As %Binary, TemplateCatCode As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s tBPCTRowId=0
	f  s tBPCTRowId=$o(^DHCBPC("Template",tBPCTRowId)) q:tBPCTRowId=""  d
		.s Code=$lg(^DHCBPC("Template",tBPCTRowId),1)
		.s Description=$lg(^DHCBPC("Template",tBPCTRowId),2)
		.s IfActive=$lg(^DHCBPC("Template",tBPCTRowId),3)
		.q:IfActive'="Y"
		.s BPCTBPCTCatID=$lg(^DHCBPC("Template",tBPCTRowId),4)		
		.i BPCTBPCTCatID'="" d
		..s BPCTBPCTCatCode= $lg(^DHCBPC("TCat",BPCTBPCTCatID),1)		
		..q:((TemplateCatCode'="")&&(BPCTBPCTCatCode'="")&&(TemplateCatCode'=BPCTBPCTCatCode))
		..s BPCTBPCTCatDesc= $lg(^DHCBPC("TCat",BPCTBPCTCatID),2)	
		.s Data=$lg(^DHCBPC("Template",tBPCTRowId),5)
	    .d OutputRow1	    
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(tBPCTRowId,Code,Description,IfActive,BPCTBPCTCatID,BPCTBPCTCatDesc,Data)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindTemplateListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTemplateListExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindTemplateListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTemplateListExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Debug:			w ##class(web.DHCBPTemplate).GetJScriptData("103")
ClassMethod GetJScriptData(moduleId As %String) As %String
{
	quit:'##class(User.DHCBPCModule).%ExistsId(moduleId) "E^模块ID错误"
	set templateId=""
	&sql(select TOP 1 RowId into :templateId from DHC_BPC_PrintTemplate where DataModule=:moduleId order by RowId Desc)
	quit:templateId="" $SYSTEM.Encryption.Base64Encode("function OnLoaded(){}")
	set template=##class(User.DHCBPCPrintTemplate).%OpenId(templateId)
	set jsData=template.JScriptData.Read(100000)
	quit:jsData="" $SYSTEM.Encryption.Base64Encode("function OnLoaded(){}")
	quit jsData
}

}
