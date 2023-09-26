/// 取医嘱信息
Class web.DHCFHQ.Ord.OrdInfo Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

ClassMethod GetOrdByLoc(ByRef repid As %Integer = 0, LocId As %String = "", GroupId As %String, StartDate As %String = "", EndDate As %String = "") As %Integer
{
	;W ##class(web.DHCFHQ.Ord.OrdInfo).GetOrdByLoc(1000,222,87,"2011-11-18","2011-11-18")	
	k ^CacheTempFHQ(repid)
	s del="^",RetNum=0
	q:StartDate="" RetNum
	q:EndDate="" RetNum
	s StartDate=$zdh(StartDate,3)
	s EndDate=$zdh(EndDate,3)
	s SDate=StartDate-1
	s LocDesc=""
	s GroupDesc=$p(^SSU("SSGRP",GroupId),del,1)
	if $g(LocId1)'="" s LocDesc=$p(^CTLOC(LocId1),del,2)
	s LocId1=LocId
	s LocId1=""
	f  s LocId1=$o(^OEORDi(0,"LocDateExecTime",LocId1)) q:LocId1=""  d
	.q:((LocId1'=LocId)&(GroupDesc'="财务审核门诊"))
	.;q:LocId1'=222
	.s LocDesc=$p(^CTLOC(LocId1),del,2)
	.s SDate=StartDate-1
	.f  s SDate=$o(^OEORDi(0,"LocDateExecTime",LocId1,SDate)) q:((SDate>EndDate)!(SDate=""))  d
	..s ExecTime=0
	..f  s ExecTime=$o(^OEORDi(0,"LocDateExecTime",LocId1,SDate,ExecTime)) q:ExecTime=""  d
	...s OrdId=""
	...f  s OrdId=$o(^OEORDi(0,"LocDateExecTime",LocId1,SDate,ExecTime,OrdId)) q:OrdId=""  d
	....s AdmId=$p(^OEORD(OrdId),del,1),AdmType=$p(^PAADM(AdmId),del,2)
	....if AdmType="I" d
	.....s AdmTypeDesc="住院"
	....else  d
	.....s AdmTypeDesc="门诊"
	....s OrdIdSub=""
	....f  s OrdIdSub=$o(^OEORDi(0,"LocDateExecTime",LocId1,SDate,ExecTime,OrdId,OrdIdSub)) q:OrdIdSub=""  d
	.....s OrdStat=$p(^OEORD(OrdId,"I",OrdIdSub,1),del,13)
	.....q:OrdStat'=6
	.....s OrdInfo=##class(web.DHCFHQ.Ord.OrdInfoB).GetOrdByOrdId(OrdId_"||"_OrdIdSub)
	.....q:$g(OrdInfo)=""
	.....;s OrdStatusId=$p(^OEORD(OrdId,"I",OrdIdSub,1),del,13)
	.....;q:(OrdStatusId'=6)
	.....s ArcimDesc=$p(OrdInfo,del,7)
	.....;s OrdExecId=$p(OrdInfo,del,36)
	.....S OrdExecCode=$p(OrdInfo,del,37)
	.....;B:OrdExecCode=""  //
	.....;q:OrdExecCode'="002887" 
	.....S OrdExecName=$p(OrdInfo,del,38)
	.....s OrdQty=$p(OrdInfo,del,31)
	.....s DrugOrdQty=$p(^OEORD(OrdId,"I",OrdIdSub,9),del,4)
	.....S:$G(DrugOrdQty)'="" OrdQty=DrugOrdQty
	.....s OrdUnit=$p(OrdInfo,del,32)
	.....s OrdCosts=$p(OrdInfo,del,36)
	.....;B ;
	.....B:((ArcimDesc="肌肉注射"))
	.....;W SDate,"!",OrdId,!
	.....if $d(^CacheTempFHQ(repid,0,AdmTypeDesc,LocDesc,ArcimDesc,OrdExecCode)) d
	......s OrdQty1=$p(^CacheTempFHQ(repid,0,AdmTypeDesc,LocDesc,ArcimDesc,OrdExecCode),del,4)
	......s OrdCosts1=$p(^CacheTempFHQ(repid,0,AdmTypeDesc,LocDesc,ArcimDesc,OrdExecCode),del,5)
	......s ^CacheTempFHQ(repid,0,AdmTypeDesc,LocDesc,ArcimDesc,OrdExecCode)=OrdExecCode_del_OrdExecName_del_OrdUnit_del_(OrdQty1+OrdQty)_del_(OrdCosts1+OrdCosts)
	.....if '$d(^CacheTempFHQ(repid,0,AdmTypeDesc,LocDesc,ArcimDesc,OrdExecCode)) d
	......s ^CacheTempFHQ(repid,0,AdmTypeDesc,LocDesc,ArcimDesc,OrdExecCode)=OrdExecCode_del_OrdExecName_del_OrdUnit_del_OrdQty_del_OrdCosts
    s AdmTypeDesc=""
    f  s AdmTypeDesc=$o(^CacheTempFHQ(repid,0,AdmTypeDesc)) q:AdmTypeDesc=""  d
    .s LocDesc=0
	.f  s LocDesc=$o(^CacheTempFHQ(repid,0,AdmTypeDesc,LocDesc)) q:LocDesc=""  d
	..s ArcimDesc=0
	..f  s ArcimDesc=$o(^CacheTempFHQ(repid,0,AdmTypeDesc,LocDesc,ArcimDesc)) q:ArcimDesc=""  d
	...s OrdExecCode=0
	...f  s OrdExecCode=$o(^CacheTempFHQ(repid,0,AdmTypeDesc,LocDesc,ArcimDesc,OrdExecCode)) q:OrdExecCode=""  d
	....s RetNum=RetNum+1
	....s CareCode=$p(^CacheTempFHQ(repid,0,AdmTypeDesc,LocDesc,ArcimDesc,OrdExecCode),del,1)
	....s CareDesc=$p(^CacheTempFHQ(repid,0,AdmTypeDesc,LocDesc,ArcimDesc,OrdExecCode),del,2)
	....s OrdUnit=$p(^CacheTempFHQ(repid,0,AdmTypeDesc,LocDesc,ArcimDesc,OrdExecCode),del,3)
	....s OrdQty=$p(^CacheTempFHQ(repid,0,AdmTypeDesc,LocDesc,ArcimDesc,OrdExecCode),del,4)
	....s OrdCosts=$p(^CacheTempFHQ(repid,0,AdmTypeDesc,LocDesc,ArcimDesc,OrdExecCode),del,5)
	....s ^CacheTempFHQ(repid,RetNum)=$lb(AdmTypeDesc,LocDesc,ArcimDesc,CareCode,CareDesc,OrdUnit,OrdQty,OrdCosts)
	....;w LocDesc_":"_ArcimDesc_":"_CareCode_":"_OrdUnit_":"_OrdQty_":"_OrdCosts,!
	....K ^CacheTempFHQ(repid,0,AdmTypeDesc,LocDesc,ArcimDesc,OrdExecCode)
	..
	q RetNum
}

/// 取执行医嘱的收费项目分类
ClassMethod GetOrdByLocTotal(ByRef repid As %Integer = 0, LocId As %String = "", GroupId As %String, StartDate As %String = "", EndDate As %String = "") As %Integer
{
	;W ##class(web.DHCFHQ.Ord.OrdInfo).GetOrdByLocTotal(1000,222,78,"2011-11-18","2011-11-18")
	k ^CacheTempFHQ(repid)
	s del="^",RetNum=0
	q:StartDate="" RetNum
	q:EndDate="" RetNum
	s StartDate=$zdh(StartDate,3)
	s EndDate=$zdh(EndDate,3)
	s Date=StartDate-1
	s LocDesc=""
	s GroupDesc=$p(^SSU("SSGRP",GroupId),del,1)
	if $g(LocId1)'="" s LocDesc=$p(^CTLOC(LocId1),del,2)
	s LocId1=LocId
	s LocId=""
	f  s LocId=$o(^OEORDi(0,"LocDateExecTime",LocId)) q:LocId=""  d
	.q:((LocId1'=LocId)&(GroupDesc'="财务审核门诊"))
	.s LocDesc=$p(^CTLOC(LocId),del,2)
	.s Date=StartDate-1
	.f  s Date=$o(^OEORDi(0,"LocDateExecTime",LocId,Date)) q:((Date>EndDate)!(Date=""))  d
	..s ExecTime=0
	..f  s ExecTime=$o(^OEORDi(0,"LocDateExecTime",LocId,Date,ExecTime)) q:ExecTime=""  d
	...s OrdId=""
	...f  s OrdId=$o(^OEORDi(0,"LocDateExecTime",LocId,Date,ExecTime,OrdId)) q:OrdId=""  d
	....s OrdIdSub=""
	....s AdmId=$p(^OEORD(OrdId),del,1),AdmType=$p(^PAADM(AdmId),del,2)
	....if AdmType="I" d
	.....s AdmTypeDesc="住院"
	....else  d
	.....s AdmTypeDesc="门诊"
	....f  s OrdIdSub=$o(^OEORDi(0,"LocDateExecTime",LocId,Date,ExecTime,OrdId,OrdIdSub)) q:OrdIdSub=""  d
	.....s OrdStat=$p(^OEORD(OrdId,"I",OrdIdSub,1),del,13)
	.....q:OrdStat'=6
	.....s OrdInfo=##class(web.DHCFHQ.Ord.OrdInfoB).GetOrdByOrdId(OrdId_"||"_OrdIdSub)
	.....q:$g(OrdInfo)=""
	.....s ArcimDesc=$p(OrdInfo,del,7)
	.....S OrdExecCode=$p(OrdInfo,del,37)
	.....S OrdExecName=$p(OrdInfo,del,38)
	.....
	.....s TarInfo=##class(web.DHCFHQ.Ord.OrdInfoB).GetOrdCost(OrdId_"||"_OrdIdSub)
	.....;b ;adf
	.....s len=$l(TarInfo,"@"),i=1
	.....f  s i=i+1 q:i>len  d
	......s TarStr=$p(TarInfo,"@",i)
	......s TarId=$p(TarStr,del,1)
	......q:(TarId="")
	......b ;aa
	......s TarEc=$p(^DHCTARI(TarId),del,16)
	......s EcDesc=$p(^DHCTarC("EC",TarEc),del,2)
	......s TarPatShare=$p(TarStr,del,4)
	......s TarQty=$p(TarStr,del,2)
	......if $d(^CacheTempFHQ(repid,0,AdmTypeDesc,LocDesc,OrdExecCode,OrdExecName,EcDesc)) d
	.......s ^CacheTempFHQ(repid,0,AdmTypeDesc,LocDesc,OrdExecCode,OrdExecName,EcDesc)=$g(^CacheTempFHQ(repid,0,AdmTypeDesc,LocDesc,OrdExecCode,OrdExecName,EcDesc))+TarPatShare
	......if '$d(^CacheTempFHQ(repid,0,AdmTypeDesc,LocDesc,OrdExecCode,OrdExecName,EcDesc)) d
	.......s ^CacheTempFHQ(repid,0,AdmTypeDesc,LocDesc,OrdExecCode,OrdExecName,EcDesc)=TarPatShare
    b ;
    s AdmTypeDesc=""
    f  s AdmTypeDesc=$o(^CacheTempFHQ(repid,0,AdmTypeDesc)) q:AdmTypeDesc=""  d
    .s LocDesc=0
	.f  s LocDesc=$o(^CacheTempFHQ(repid,0,AdmTypeDesc,LocDesc)) q:LocDesc=""  d
	..s OrdExecCode=0
	..f  s OrdExecCode=$o(^CacheTempFHQ(repid,0,AdmTypeDesc,LocDesc,OrdExecCode)) q:OrdExecCode=""  d
	...S OrdExecName=$o(^CacheTempFHQ(repid,0,AdmTypeDesc,LocDesc,OrdExecCode,""))
	...s EcDesc=""
	...f  s EcDesc=$o(^CacheTempFHQ(repid,0,AdmTypeDesc,LocDesc,OrdExecCode,OrdExecName,EcDesc)) q:EcDesc=""  d
	....s RetNum=RetNum+1
	....s Costs=$g(^CacheTempFHQ(repid,0,AdmTypeDesc,LocDesc,OrdExecCode,OrdExecName,EcDesc))
	....s ^CacheTempFHQ(repid,RetNum)=$lb(LocDesc,OrdExecCode,OrdExecName,EcDesc,Costs)
	....;w AdmTypeDesc_":"_LocDesc_":"_ArcimDesc_":"_CareCode_":"_OrdUnit_":"_OrdQty_":"_OrdCosts,!
	....K ^CacheTempFHQ(repid,0,AdmTypeDesc,LocDesc,OrdExecCode,OrdExecName,EcDesc)
	q RetNum
}

}
