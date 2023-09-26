Class EPRservice.BLL.OrderData.BLOrderData.BLOrderData Extends %Persistent
{

Query GetOrdFlagByKSS(EpisodeID As %String = "", SearchStartDate As %String = "", SearchEndDate As %String = "", CategoryID As %String = "", SubsortID As %String = "", LongOrd As %String = "", ShortOrd As %String = "", OrdStat As %String = "", ordPriority As %String = "") As %Query(ROWSPEC = "OrdCreateDate:%String,OrdCreateTime:%String,OrdStartDate:%String,OrdStartTime:%String,ArcimDesc:%String,DoseQty:%String,DoseUnit:%String,Priority:%String,PHFreq:%String,Instr:%String,Doctor:%String,OrdStatus:%String,Dura,OEItemID:%String,PatientID:%String,SeqNo:%String,QtyPackUOM:%String,PackUOMDesc:%String,PrescNo:%String,dstatus:%String,LabEpisodeNo:%String,OrdLabSpec:%String,OrdXDate:%String,OrdXTime:%String,OrdSkinTest:%String,OrdAction:%String,OrdDepProcNotes:%String,OrdBilled:%String,OrdSkinTestResult:%String,OEORIQty:%String,OEORIPhQty:%String,Flag:%String")
{
}

/// Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.BLL.OrderData.BLOrderData.BLOrderData","GetOrdFlagByKSS","503","","","","","","","","")
ClassMethod GetOrdFlagByKSSExecute(ByRef qHandle As %Binary, EpisodeID As %String = "", SearchStartDate As %String = "", SearchEndDate As %String = "", CategoryID As %String = "", SubsortID As %String = "", LongOrd As %String = "", ShortOrd As %String = "", OrdStat As %String = "", ordPriority As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)
	
	s ds = ##Class(%Library.ResultSet).%New("web.DHCFOrdGetEPR:GetOrdByAdm")
	d ds.Execute(EpisodeID,SearchStartDate,SearchEndDate,CategoryID,SubsortID,LongOrd,ShortOrd,OrdStat,ordPriority)
    
	While(ds.Next())
    {
	    s Flag=..GetKSSFlag(ds.Data("OEItemID"))
	    s ^CacheTemp(repid,ind) = $LB(ds.Data("OrdCreateDate"),ds.Data("OrdCreateTime"),ds.Data("OrdStartDate"),ds.Data("OrdStartTime"),ds.Data("ArcimDesc"),ds.Data("DoseQty"),ds.Data("DoseUnit"),ds.Data("Priority"),ds.Data("PHFreq"),ds.Data("Instr"),ds.Data("Doctor"),ds.Data("OrdStatus"),ds.Data("Dura"),ds.Data("OEItemID"),ds.Data("PatientID"),ds.Data("SeqNo"),ds.Data("QtyPackUOM"),ds.Data("PackUOMDesc"),ds.Data("PrescNo"),ds.Data("dstatus"),ds.Data("LabEpisodeNo"),ds.Data("OrdLabSpec"),ds.Data("OrdXDate"),ds.Data("OrdXTime"),ds.Data("OrdSkinTest"),ds.Data("OrdAction"),ds.Data("OrdDepProcNotes"),ds.Data("OrdBilled"),ds.Data("OrdSkinTestResult"),ds.Data("OEORIQty"),ds.Data("OEORIPhQty"),Flag)
		s ind=ind+1
		
	}
	
	d ds.Close()
	Quit $$$OK
}

ClassMethod GetOrdFlagByKSSClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrdFlagByKSSExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOrdFlagByKSSFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrdFlagByKSSExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetKSSFlag(OEORDRowID As %String) As %String
{
	s Arcim=$p($g(^OEORD(+OEORDRowID,"I",$p(OEORDRowID,"||",2),1)),"^",2)
	q:Arcim="" "0"
	s KSSFlag=##Class(web.DHCDocOrderCommon).TSKSSCheck(Arcim)
	q:KSSFlag'=1 0
	
	s NotesRowID=$o(^OEORD(+OEORDRowID,"I",$p(OEORDRowID,"||",2),"DEP",""),-1)
	q:NotesRowID="" 0
	s Notes=$g(^OEORD(+OEORDRowID,"I",$p(OEORDRowID,"||",2),"DEP",NotesRowID))
	q:Notes'["抗生素" 0
	q 1
}

Storage Default
{
<Data name="BLOrderDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^EPRservice.BLL2CE7.BLOrderDataD</DataLocation>
<DefaultData>BLOrderDataDefaultData</DefaultData>
<IdLocation>^EPRservice.BLL2CE7.BLOrderDataD</IdLocation>
<IndexLocation>^EPRservice.BLL2CE7.BLOrderDataI</IndexLocation>
<StreamLocation>^EPRservice.BLL2CE7.BLOrderDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
