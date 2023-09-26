/// 抗菌素应用统计
/// 创建者：李阳
/// 创建日期：2011-03-15
Class DHCMed.INFService.Sta.AntiInfDrugUsageSta Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

ClassMethod HasAntiDrugOrder(Paadm)
{
	n (Paadm)
	s ret=0
	s orderID="" f  s orderID=$o(^OEORD(0,"Adm",Paadm,orderID)) q:orderID=""  d
	.s ArcimID="" f  s ArcimID=$o(^OEORDi(0,"ARCIM",orderID,ArcimID)) q:ArcimID=""  d
	..s aricmItem=##class(DHCMed.Base.Arcim).GetObjById(ArcimID)
	..q:aricmItem=""
	..d aricmItem.%Close()
	..q:aricmItem.ARCICOrderType'="R" //不是药品
	..s type=$$GetPhcCat(ArcimID)
	..q:type'["抗生素" //药学分类不是抗生素
	..s startDate="" f  s startDate=$o(^OEORDi(0,"ARCIM",orderID,ArcimID,startDate)) q:startDate=""  d
	...s childsub="" f  s childsub=$o(^OEORDi(0,"ARCIM",orderID,ArcimID,startDate,childsub)) q:childsub=""  d
	....s itemID=orderID_"||"_childsub
	....s orderItem=##class(DHCMed.Base.OrdItem).GetObjById(itemID)
	....q:orderItem=""
	....d orderItem.%Close()
	....;w orderItem.OSTATCode_" "_orderItem.OSTATDesc,!
	....;q:orderItem.OSTATCode'="E" //必须是已经执行的医嘱
	....s ret=1
	..s arcimItem=""
	..k arcimItem
	q ret
	
GetPhcCat(arcim)
     n (arcim) 
     s s=""
     s drgfrmrowid=$p(^ARCIM(+arcim,1,1),"^",12)        ;PHC_DrgForm:药学形态
     s drugrowid=+drgfrmrowid                           ;PHC_DrgMast药理学项
     q:drugrowid=0 s
     s psubcatrowid=$p(^PHCD(drugrowid,1),"^",3)        ;PHC_SubCat药理学子分类
     ;s pmincatrowid=$p(^PHCD(drugrowid,1),"^",6)        ;PHC_MinorSubCat药理学最小分类
     s phccat=+psubcatrowid                             ;phc_cat药理学分类
     s s=phccat_"/"_$p($g(^PHCC(phccat)),"^",1)_"/"_$p($g(^PHCC(phccat)),"^",2)
     q s
}

/// 抗菌素应用统计
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.INFService.Sta.AntiInfDrugUsageSta","AntiInfDrugUsageSta",1,"2010-1-1","2011-12-31")
Query AntiInfDrugUsageSta(Type As %String, FromDate As %String, ToDate As %String) As %Query(ROWSPEC = "Department:%String:科室,Ward:%String:病区,RepCnt:%String:报告数量,AntiInfDrugCnt:%String:使用抗生素数量,CareUseCnt:%String:治疗用药数量,CareUsage:%String:治疗用药百分比,PreventUseCnt:%String:预防用药数量,PreventUsage:%String:预防用药百分比,CarePreventUseCnt:%String:治疗+预防用药数量,CarePreventUsage:%String:治疗、预防药物使用率,UnionUseCnt:%String:联合用药数量,UnionUsage:%String:联合用药使用率")
{
}

ClassMethod AntiInfDrugUsageStaExecute(ByRef qHandle As %Binary, Type As %String, FromDate As %String, ToDate As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)	
	
	q:Type="" $$$OK
	s Type=" "_Type
	s:FromDate["-" FromDate=$zdh(FromDate,3)
	s:ToDate["-" ToDate=$zdh(ToDate,3)
	s:FromDate["/" FromDate=$zdh(FromDate,4)
	s:ToDate["/" ToDate=$zdh(ToDate,4)	
	
	f tmpDate=FromDate:1:ToDate  d
	.q:$d(^DHCMed.INF.ReportI("TypeDate",Type,tmpDate))=0
	.s reportID="" f  s reportID=$o(^DHCMed.INF.ReportI("TypeDate",Type,tmpDate,reportID)) q:reportID=""  d
	..s objReport=##class(DHCMed.INF.Report).%OpenId(reportID)
	..d objReport.%Close()
	..s objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(objReport.PaadmDR)
	..d objAdm.%Close()
	..s tmpData=$g(^CacheTemp(repid,"AntiInfDrugUsageStaExecute",objAdm.DepartmentID,objAdm.WardID))
	..s tmp=""
	..s $p(tmpData,"^",1)=$p(tmpData,"^",1)+1 //报告数量
	..s:..HasAntiDrugOrder(objReport.PaadmDR) $p(tmpData,"^",2)=$p(tmpData,"^",2)+1
	..s drugRecID="" f  s drugRecID=$o(^DHCMed.INF.RepDrugI("InfRepDr",reportID,drugRecID)) q:drugRecID=""  d
	...s objDrugRec=##class(DHCMed.INF.RepDrug).%OpenId(drugRecID)
	...q:objDrugRec=""
	...d objDrugRec.%Close()
	...s:objDrugRec.Aim=1 $p(tmp,"^",1)=1 //治疗用药
	...s:objDrugRec.Aim=2 $p(tmp,"^",2)=1 //预防用药
	...s:objDrugRec.Aim=3 $p(tmp,"^",3)=1 //预防+治疗
	...s:objDrugRec.UniteDrug'=1 $p(tmp,"^",4)=1 //联合用药
	...s objDrugRec=""
	...k objDrugRec
	..s:$p(tmp,"^",1)=1 $p(tmpData,"^",3)=$p(tmpData,"^",3)+1 //治疗用药
	..s:$p(tmp,"^",2)=1 $p(tmpData,"^",4)=$p(tmpData,"^",4)+1 //预防用药
	..s:$p(tmp,"^",3)=1 $p(tmpData,"^",5)=$p(tmpData,"^",5)+1 //预防+治疗
	..s:$p(tmp,"^",4)=1 $p(tmpData,"^",6)=$p(tmpData,"^",6)+1 //联合用药
	..s ^CacheTemp(repid,"AntiInfDrugUsageStaExecute",objAdm.DepartmentID,objAdm.WardID)=tmpData
	..s objReport=""
	..s objAdm=""
	..k objReport
	..k objAdm
	
	
	s loc="" f  s loc=$o(^CacheTemp(repid,"AntiInfDrugUsageStaExecute",loc)) q:loc=""  d
	.;w "LOC:"_loc,!
	.s objLoc=##class(DHCMed.Base.Ctloc).GetObjById(loc)
	.d objLoc.%Close()
	.s wardID="" f  s wardID=$o(^CacheTemp(repid,"AntiInfDrugUsageStaExecute",loc,wardID)) q:wardID=""  d
	..;w "WARD:"_wardID,!
	..s objWard=##class(DHCMed.Base.PacWard).GetObjById(wardID)
	..s ^CacheTemp(repid,ind)=$$BuildAntiInfDrugUsageSta(1)
	..s ind=ind+1
	..d objWard.%Close()
	k ^CacheTemp(repid,"AntiInfDrugUsageStaExecute")
	

	Quit $$$OK
	
BuildAntiInfDrugUsageSta(param)
	s tmpData=$g(^CacheTemp(repid,"AntiInfDrugUsageStaExecute",loc,wardID))
	s data=$lb("")
	s $li(data,1)=objLoc.Descs
	s $li(data,2)=objWard.Descs
	s $li(data,3)=$p(tmpData,"^",1) //RepCnt:%String:报告数量
	s $li(data,4)=$p(tmpData,"^",2) //使用抗生素数量
	s $li(data,5)=$p(tmpData,"^",3)	//CareUseCnt:%String:治疗用药数量
	s $li(data,6)=$number($p(tmpData,"^",3)/$p(tmpData,"^",1)*100,2)_"%" //CareUsage:%String:治疗用药百分比
	s $li(data,7)=$p(tmpData,"^",4)	//PreventUseCnt:%String:预防用药数量
	s $li(data,8)=$number($p(tmpData,"^",4)/$p(tmpData,"^",1)*100,2)_"%" //PreventUsage:%String:预防用药百分比
	s $li(data,9)=$p(tmpData,"^",5)	//CarePreventUseCnt:%String:治疗+预防用药数量
	s $li(data,10)=$number($p(tmpData,"^",5)/$p(tmpData,"^",1)*100,2)_"%" //CarePreventUsage:%String:治疗、预防药物使用率
	s $li(data,11)=$p(tmpData,"^",6)	//UnionUseCnt:%String:联合用药数量
	s $li(data,12)=$number($p(tmpData,"^",6)/$p(tmpData,"^",1)*100,2)_"%" //UnionUseCnt:%String:联合用药数量
	q data
}

ClassMethod AntiInfDrugUsageStaClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AntiInfDrugUsageStaExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod AntiInfDrugUsageStaFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AntiInfDrugUsageStaExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
