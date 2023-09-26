/// 创建者：李阳
/// 创建日期：2011-03-12
/// 统计抗生素使用情况
Class DHCMed.INFService.Sta.AntiInfDrugSta Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/*
ClassMethod CalcOrderNumber(ArcimID, Paadm)
{
	n (ArcimID, Paadm)
	s ArcimID=ArcimID_"||1"
	s ret=0
	s orderID="" f  s orderID=$o(^OEORD(0,"Adm",Paadm,orderID)) q:orderID=""  d
	.s startDate="" f  s startDate=$o(^OEORDi(0,"ARCIM",orderID,ArcimID,startDate)) q:startDate=""  d
	..s childsub="" f  s childsub=$o(^OEORDi(0,"ARCIM",orderID,ArcimID,startDate,childsub)) q:childsub=""  d
	...s itemID=orderID_"||"_childsub
	...s orderItem=##class(DHCMed.Base.OrdItem).GetObjById(itemID)
	...q:orderItem=""
	...d orderItem.%Close()
	...s ret=ret+orderItem.OEORIDoseQty
	...s orderItem=""
	...k orderItem
	q ret
}
*/
ClassMethod CalcOrderNumber(repid, ArcimID, Paadm)
{
	n (repid, ArcimID, Paadm)
	s ArcimID=ArcimID_"||1"
	s ret=0
	s orderID="" f  s orderID=$o(^OEORD(0,"Adm",Paadm,orderID)) q:orderID=""  d
	.s startDate="" f  s startDate=$o(^OEORDi(0,"ARCIM",orderID,ArcimID,startDate)) q:startDate=""  d
	..s childsub="" f  s childsub=$o(^OEORDi(0,"ARCIM",orderID,ArcimID,startDate,childsub)) q:childsub=""  d
	...s itemID=orderID_"||"_childsub
	...s orderItem=##class(DHCMed.Base.OrdItem).GetObjById(itemID)
	...q:orderItem=""
	...;b
	...d orderItem.%Close()
	...s tmpData=$g(^CacheTemp(repid,"CalcOrderNumber",orderItem.OEORIDoctorDR))
	...s $p(tmpData,"^",1)=$p(tmpData,"^",1)+orderItem.OEORIDoseQty
	...s ^CacheTemp(repid,"CalcOrderNumber",orderItem.OEORIDoctorDR)=tmpData
	...s orderItem=""
	...k orderItem
	
	s ret=""
	s userID="" f  s userID=$o(^CacheTemp(repid,"CalcOrderNumber",userID)) q:userID=""  d
	.s:ret'="" ret=ret_$c(1)
	.s tmpData=$g(^CacheTemp(repid,"CalcOrderNumber",userID))
	.s ret=ret_userID_"^"_$p(tmpData,"^",1)
	.k ^CacheTemp(repid,"CalcOrderNumber",userID)
	q ret
}

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
     
GetPhcSubCat(arcim)
     n (arcim) 
     s s=""
     s drgfrmrowid=$p(^ARCIM(+arcim,1,1),"^",12)        ;PHC_DrgForm:药学形态
     s drugrowid=+drgfrmrowid                           ;PHC_DrgMast药理学项
     q:drugrowid=0 s
     s psubcatrowid=$p(^PHCD(drugrowid,1),"^",3)        ;PHC_SubCat药理学子分类
     q:psubcatrowid="" ""
     ;s pmincatrowid=$p(^PHCD(drugrowid,1),"^",6)        ;PHC_MinorSubCat药理学最小分类
     s phccat=+psubcatrowid                             ;phc_cat药理学分类
     s phcsub=$p(psubcatrowid,"||",2)
     s s=psubcatrowid_"/"_$p($g(^PHCC(phccat,"SC",phcsub)),"^",1)_"/"_$p($g(^PHCC(phccat,"SC",phcsub)),"^",2)
     q s
}

/// 统计抗菌类药物使用率
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.INFService.Sta.AntiInfDrugSta","QryAntiInfDrugNumber","2010-1-1","2011-12-31")
Query QryAntiInfDrugNumber(FromDate As %String, ToDate As %String) As %Query(ROWSPEC = "Department:%String:科室,Ward:%String:病区,DisNumber:%String:出院人数,HasOrderNum:%String:使用抗生素人数,Percent:%String:百分比")
{
}

ClassMethod QryAntiInfDrugNumberExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)	
	
	s:FromDate["-" FromDate=$zdh(FromDate,3)
	s:ToDate["-" ToDate=$zdh(ToDate,3)
	s:FromDate["/" FromDate=$zdh(FromDate,4)
	s:ToDate["/" ToDate=$zdh(ToDate,4)

	s indexName="DischDate" ;EstDisch
	s status=" "_"2" //索引有空格
	f tmpDate=FromDate:1:ToDate  d
	.s paadm="" f  s paadm=$o(^PAADMi(indexName,tmpDate,paadm)) q:paadm=""  d
	..q:$d(^PAADMi("PAADM_Type","I",paadm))=0 //检查是否是住院
	..s objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(paadm)
	..d objAdm.%Close()
	..s tmpData=$g(^CacheTemp("QryAntiInfDrugNumberExecute",repid,objAdm.DepartmentID,objAdm.WardID))
	..s doesQty=..HasAntiDrugOrder(paadm)
	..s $p(tmpData,"^",1)=$p(tmpData,"^",1)+1 //总数
	..s:doesQty>0 $p(tmpData,"^",2)=$p(tmpData,"^",2)+1 //做过这个医嘱的病人数量
	..s $p(tmpData,"^",3)=$p(tmpData,"^",3)+doesQty
	..s ^CacheTemp("QryAntiInfDrugNumberExecute",repid,objAdm.DepartmentID,objAdm.WardID)=tmpData
	..s objAdm=""
	..k objAdm
	s loc="" f  s loc=$o(^CacheTemp("QryAntiInfDrugNumberExecute",repid,loc)) q:loc=""  d
	.s objLoc=##class(DHCMed.Base.Ctloc).GetObjById(loc)
	.d objLoc.%Close()
	.s wardID="" f  s wardID=$o(^CacheTemp("QryAntiInfDrugNumberExecute",repid,loc,wardID)) q:wardID=""  d
	..s objWard=##class(DHCMed.Base.PacWard).GetObjById(wardID)
	..s ^CacheTemp(repid,ind)=$$WoundOperationSta(1)
	..s ind=ind+1
	..d objWard.%Close()
	
	Quit $$$OK
	
WoundOperationSta(param)
	s tmpData=$g(^CacheTemp("QryAntiInfDrugNumberExecute",repid,loc,wardID))
	s data=$lb("")
	s $li(data,1)=objLoc.Descs
	s $li(data,2)=objWard.Descs
	s $li(data,3)=$p(tmpData,"^",1)
	s $li(data,4)=$p(tmpData,"^",2)
	s $li(data,5)=""
	s:+$p(tmpData,"^",1)'=0 $li(data,5)=$number($p(tmpData,"^",2)/$p(tmpData,"^",1)*100,2)_"%"
	q data
		
	Quit $$$OK
}

ClassMethod QryAntiInfDrugNumberClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntiInfDrugNumberExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryAntiInfDrugNumberFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntiInfDrugNumberExecute ]
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

/// d ##class(%Library.ResultSet).RunQuery("DHCMed.INFService.Sta.AntiInfDrugSta","QryArcimNumberByDoctor","2010-1-1","2011-12-31",10339)
Query QryArcimNumberByDoctor(FromDate As %String, ToDate As %String, ArcimID As %String) As %Query(ROWSPEC = "UserID:%String,UserCode:%String:工号,UserName:%String:用户名,HasOrderNum:%String:使用抗生素人数,OrderNumber:%String:数量")
{
}

ClassMethod QryArcimNumberByDoctorExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, ArcimID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)	
	
	s:FromDate["-" FromDate=$zdh(FromDate,3)
	s:ToDate["-" ToDate=$zdh(ToDate,3)
	s:FromDate["/" FromDate=$zdh(FromDate,4)
	s:ToDate["/" ToDate=$zdh(ToDate,4)	

	s indexName="DischDate" ;EstDisch
	s status=" "_"2" //索引有空格
	f tmpDate=FromDate:1:ToDate  d
	.s paadm="" f  s paadm=$o(^PAADMi(indexName,tmpDate,paadm)) q:paadm=""  d
	..q:$d(^PAADMi("PAADM_Type","I",paadm))=0 //检查是否是住院
	..s calcResult=..CalcOrderNumber(repid,ArcimID,paadm)
	..f cnt=1:1:$l(calcResult,$c(1))  d
	...s tmp=$p(calcResult,$c(1),cnt)
	...q:tmp=""	
	...s careProvider=$p(tmp,"^",1)
	...s num=$p(tmp,"^",2)
	...q:careProvider=""
	...s tmpData=$g(^CacheTemp("QryArcimNumberByDoctorExecute",repid,careProvider))
	...s $p(tmpData,"^",1)=$p(tmpData,"^",1)+1 //做过这个医嘱的病人数量
	...s $p(tmpData,"^",2)=$p(tmpData,"^",2)+num //医嘱总量
	...s ^CacheTemp("QryArcimNumberByDoctorExecute",repid,careProvider)=tmpData
	
	
	s careProvider="" f  s careProvider=$o(^CacheTemp("QryArcimNumberByDoctorExecute",repid,careProvider)) q:careProvider=""  d
	.s userId=$o(^SSU("SSUSR",0,"CTPCP",+careProvider,""))
	.q:userId=""
	.s objUser=##class(DHCMed.Base.SSUser).GetObjById(userId)
	.q:objUser=""
	.d objUser.%Close()
	.s tmpData=$g(^CacheTemp("QryArcimNumberByDoctorExecute",repid,careProvider))
	.s ^CacheTemp(repid,ind)=$$BuildData(1)
	.s ind=ind+1
	
	Quit $$$OK
BuildData(param)
	s data=$lb("")
	s $li(data,1)=objUser.Rowid
	s $li(data,2)=objUser.Code
	s $li(data,3)=objUser.Name
	s $li(data,4)=$p(tmpData,"^",1)
	s $li(data,5)=$p(tmpData,"^",2)
	q data
}

ClassMethod QryArcimNumberByDoctorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = NewQuery1Execute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryArcimNumberByDoctorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = NewQuery1Execute ]
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
