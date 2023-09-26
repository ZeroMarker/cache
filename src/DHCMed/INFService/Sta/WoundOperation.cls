/// 创建者：李阳
/// 创建日期：2011-03-09
/// 侵害性操作感染率统计
Class DHCMed.INFService.Sta.WoundOperation Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod HasOrder(ArcimID, Paadm)
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
	...;w "医嘱名称："_orderItem.ARCIMCode_"   "_orderItem.ARCIMDesc_"    "_orderItem.OSTATCode_"  "_orderItem.OSTATDesc,!
	...s orderItem=""
	...k orderItem
	...s ret=1
	q ret
}

/// 一个侵害性操作感染率统计
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.INFService.Sta.WoundOperation","WoundOperationSta","2010-1-1","2011-12-31","",12107)
Query WoundOperationSta(FromDate As %String, ToDate As %String, WoundType As %String, ArcimID As %String) As %Query(ROWSPEC = "Loc:%String:科室,Ward:%String:病区,PatientNumber:%String:使用医嘱数量,InfectionNumber:%String:院内感染数量,WoundNumber:%String:侵害操作数量,WoundPercent:%String:感染率")
{
}

ClassMethod WoundOperationStaExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, WoundType As %String, ArcimID As %String) As %Status
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
	..s tmpData=$g(^CacheTemp("WoundOperationStaExecute",repid,objAdm.DepartmentID,objAdm.WardID))
	..s hasThatOrder=..HasOrder(ArcimID,paadm)
	..s $p(tmpData,"^",1)=$p(tmpData,"^",1)+1 //总数
	..s:hasThatOrder=1 $p(tmpData,"^",2)=$p(tmpData,"^",2)+1 //做过这个医嘱的病人数量
	..s:hasThatOrder=1 HasOrderPatNumber=HasOrderPatNumber+1
	..s opeInfFlag=0
	..s reportID="" f  s reportID=$o(^DHCMed.INF.ReportI("TypePaadm",status,paadm,reportID)) q:reportID=""  d
	...s:hasThatOrder=1 $p(tmpData,"^",3)=$p(tmpData,"^",3)+1 //做过这个医嘱的院内感染数量
	...s:hasThatOrder=0 $p(tmpData,"^",4)=$p(tmpData,"^",4)+1 //未做过这个医嘱的院内感染数量
	...s infPosOpeID="" f  s infPosOpeID=$o(^DHCMed.INF.RepPosI("InfRepDr",reportID,infPosOpeID)) q:infOpeChild=""  d
	....s objInfPosOpe=##class(DHCMed.INF.RepPos).%OpenId(infPosOpeID)
	....q:objInfPosOpe=""
	....d objInfPosOpe.%Close()
	....s:((objInfPosOpe.InroadOpr=WoundType)&&(WoundType'="")) opeInfFlag=1
	....s objInfPosOpe=""
	....k objInfPosOpe
	..s:opeInfFlag $p(tmpData,"^",5)=$p(tmpData,"^",5)+1
	..s ^CacheTemp("WoundOperationStaExecute",repid,objAdm.DepartmentID,objAdm.WardID)=tmpData
	..s objAdm=""
	..k objAdm
	
	s loc="" f  s loc=$o(^CacheTemp("WoundOperationStaExecute",repid,loc)) q:loc=""  d
	.s objLoc=##class(DHCMed.Base.Ctloc).GetObjById(loc)
	.d objLoc.%Close()
	.s wardID="" f  s wardID=$o(^CacheTemp("WoundOperationStaExecute",repid,loc,wardID)) q:wardID=""  d
	..s objWard=##class(DHCMed.Base.PacWard).GetObjById(wardID)
	..s ^CacheTemp(repid,ind)=$$WoundOperationSta(1)
	..s ind=ind+1
	..d objWard.%Close()
	
	Quit $$$OK
	
WoundOperationSta(param)
	s tmpData=$g(^CacheTemp("WoundOperationStaExecute",repid,loc,wardID))
	s data=$lb("")
	s $li(data,1)=objLoc.Descs
	s $li(data,2)=objWard.Descs
	s $li(data,3)=$p(tmpData,"^",2)
	s $li(data,4)=$p(tmpData,"^",3)
	s $li(data,5)=$p(tmpData,"^",5)
	s $li(data,6)=""
	s:+$p(tmpData,"^",2)'=0 $li(data,6)=$number($p(tmpData,"^",5)/$p(tmpData,"^",2)*100,2)_"%"
	q data
}

ClassMethod WoundOperationStaClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = WoundOperationStaExecute ]
{
	Set repid=$li(qHandle,2)
	kill ^CacheTemp("WoundOperationStaExecute",repid)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod WoundOperationStaFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = WoundOperationStaExecute ]
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
