/// creator:qujian
/// date:2022-08-04
/// desc:取医嘱的历史信息
Class DHCDoc.Order.History Extends DHCDoc.Util.RegisteredObject
{

/// 查询医嘱的门诊历史使用记录
/// d ##class(%ResultSet).RunQuery("DHCDoc.Order.History","GetOPAdmHistoryArcim","5953","2086||1")
Query GetOPAdmHistoryArcim(EpisodeID As %String = "", ARCIMDR As %String = "") As %Query(ROWSPEC = "ARCIMDesc:%String,TDate:%String,doseQty:%String,doseUOM:%String")
{
}

ClassMethod GetOPAdmHistoryArcimClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOPAdmHistoryArcimExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOPAdmHistoryArcimFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOPAdmHistoryArcimExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetOPAdmHistoryArcimExecute(ByRef qHandle As %Binary, EpisodeID As %String = "", ARCIMDR As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)	
	If $g(ind)="" Set ind=1
	s PatientID=$P(^PAADM(EpisodeID),"^",1)
	s adm="0"
	s MaintionDoseUom=""
	Set langid=..%LanguageID()
	for{
		s adm=$O(^PAPERdr(PatientID,"ADM","O",adm))
		q:adm=""
		s orderParref=""
		s orderParref=$O(^OEORD(0,"Adm",adm,""))
		continue:orderParref=""
		s orderId=0
		s SttDate=""

		for{
			s SttDate=$O(^OEORDi(0,"ARCIM",orderParref,ARCIMDR,SttDate))
			q:SttDate=""
			s orderId=""
			for{
				s orderId=$O(^OEORDi(0,"ARCIM",orderParref,ARCIMDR,SttDate,orderId))
				q:orderId=""
				s str1 = ^OEORD(orderParref,"I",orderId,1)
				s str2 = ^OEORD(orderParref,"I",orderId,2)
				s itemStatDr = $p(str1,"^",13) 
				s TItemStatCode=""
				s:+itemStatDr>0 TItemStatCode = $p(^OEC("OSTAT",itemStatDr),"^",1)
				continue:((TItemStatCode="D")||(TItemStatCode="U")||(TItemStatCode="C"))
				s oeori=orderParref_"||"_orderId
				s doseQty = ##class(DHCDoc.Interface.Inside.Service).GetOrdDoseQty(oeori) //$p(str2,"^",1)	;用量 OEORI_DoseQty
				s doseUnitDr= $p(str2,"^",3)	;剂量单位 OEORI_Unit_DR
				s doseUOM=##class(web.DHCDocOrderCommon).GetUOMDesc(doseUnitDr)
				if (MaintionDoseUom=""){
					s MaintionDoseUom=doseUnitDr
				}else{
					 s factor=1
					 i MaintionDoseUom'="" d
					 .i doseUnitDr'=MaintionDoseUom d
					 ..s ctcfId=$o(^CT("CTCF",0,"UOM",MaintionDoseUom,doseUnitDr,""))
					 ..i ctcfId'="" s factor=$p(^CT("CTCF",ctcfId),"^",3)
					 s doseQty=factor*doseQty
				}
				s MaintionDoseUomDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(MaintionDoseUom)
				s TStDate = ..%ZD($p(str1,"^",9)) //$zd($p(str1,"^",9),3)
				s TStTime = ..%ZT($p(str1,"^",10),1)
				s TDate=TStDate_"  "_TStTime
				s ItmMastDR=$p(str1,"^",2)
				s ARCIMDesc=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",2)	
				s ARCIMDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ARCIMDesc,langid)
				q:ind>7
				set Data=$lb(ARCIMDesc,TDate,doseQty,MaintionDoseUomDesc)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
				
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

}
