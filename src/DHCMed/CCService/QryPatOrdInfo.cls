/// 名称: DHCMed.CCService.QryPatOrdInfo
/// 描述: 患者医嘱信息查询常用方法
/// 编写者：liuyh
/// 编写日期: 2010-06-11
Class DHCMed.CCService.QryPatOrdInfo Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Description:  查找本次就诊的所有医嘱
/// Table:        OEC_OrderCategory
/// Input:        EpisodeID:就诊指针, SearchStartDate:开始日期,SearchEndDate:截止日期
/// CategoryID:	  大类指针, SubsortID:子类指针
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.QryPatOrdInfo","GetOrdList",50,"","","","","","","")
Query GetOrdList(EpisodeID As %String = "", SearchStartDate As %String = "", SearchEndDate As %String = "", CategoryID As %String = "", SubsortID As %String = "", LongOrd As %String = "", ShortOrd As %String = "", OrdStat As %String = "") As %Query(ROWSPEC = "OrdCreateDate:%String,OrdCreateTime:%String,OrdStartDate:%String,OrdStartTime:%String,ArcimDesc:%String,DoseQty:%String,DoseUnit:%String,Priority:%String,PHFreq:%String,Instr:%String,Doctor:%String,OrdStatus:%String,Dura,OEItemID:%String,PatientID:%String,SeqNo:%String,QtyPackUOM:%String,PackUOMDesc:%String,PrescNo:%String,dstatus:%String,LabEpisodeNo:%String,OrdLabSpec:%String,OrdXDate:%String,OrdXTime:%String,OrdSkinTest:%String,OrdAction:%String,OrdDepProcNotes:%String,OrdBilled:%String,OrdSkinTestResult:%String")
{
}

ClassMethod GetOrdListExecute(ByRef qHandle As %Binary, EpisodeID As %String = "", SearchStartDate As %String = "", SearchEndDate As %String = "", CategoryID As %String = "", SubsortID As %String = "", LongOrd As %String = "", ShortOrd As %String = "", OrdStat As %String = "") As %Status
{
	s:SearchStartDate["/" SearchStartDate=$zdh(SearchStartDate)
	s:SearchEndDate["/" SearchEndDate=$zdh(SearchEndDate)
	s:SearchStartDate["-" SearchStartDate=$zdh(SearchStartDate,3)
	s:SearchEndDate["-" SearchEndDate=$zdh(SearchEndDate,3)
	s ^RP("GetOrdByAdm")=EpisodeID_"^"_SearchStartDate_"^"_SearchEndDate_"^"_CategoryID_"^"_SubsortID_"^"_LongOrd_"^"_ShortOrd
	///d ##class(%ResultSet).RunQuery("web.DHCFOrdGet","GetOrdByAdm","201764","61325","61325","","")
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if (SearchStartDate'="")&&(SearchEndDate'="")&&((SearchEndDate-SearchStartDate)>365) Quit
	
	s RetNum=..GetOrdItem(repid,EpisodeID,SearchStartDate,SearchEndDate,CategoryID,SubsortID,"",LongOrd,ShortOrd,OrdStat)
	s i=0
	s SeqNo=1
	s SubSeqCount=1
	f  s i=$o(^CacheTempFHQ(repid,i)) q:i=""  d
	.s Data=^CacheTempFHQ(repid,i)
	.s OEItemID=$list(Data,14)
	.s OEItemIDChildsub=+$P($list(Data,14),"||",2)
	.i $d(^OEORD(+OEItemID,"I",$p(OEItemID,"||",2),11)) s LinkOrderItemChildsub=$P($p(^OEORD(+OEItemID,"I",$p(OEItemID,"||",2),11),"^",39),"||",2)
	.if $G(LinkOrderItemChildsub)="" d
	..s ^CacheTemp("DHCMedFindOrdItem",$j,"master",OEItemIDChildsub)=Data
	.e  d
	..if '$D(^CacheTemp("DHCMedFindOrdItem",$j,"master",LinkOrderItemChildsub)) d
	...s ^CacheTemp("DHCMedFindOrdItem",$j,"master",LinkOrderItemChildsub)=""
	..s ^CacheTemp("DHCMedFindOrdItem",$j,"master",LinkOrderItemChildsub,"sub",OEItemIDChildsub)=Data
	
	s SeqNo=0
	s mas=0 for  s mas=$O(^CacheTemp("DHCMedFindOrdItem",$j,"master",mas)) q:mas=""  d
	. s s1=^CacheTemp("DHCMedFindOrdItem",$j,"master",mas)
	. s PSeq=$p(mas,"||",2)
	. i s1'="" d 
	. .s SeqNo=SeqNo+1
	. .s $List(s1,16)=SeqNo
	. .s Data=s1
	. .d OutputRow
	. s SubSeqCount=0
	. s sub=0  for  s sub=$O(^CacheTemp("DHCMedFindOrdItem",$j,"master",mas,"sub",sub)) q:sub=""  d
	. . s s2=^CacheTemp("DHCMedFindOrdItem",$j,"master",mas,"sub",sub)
	. . i s1="" d
	. . . s SeqNo= SeqNo+1
	. . . s $List(s2,16)=SeqNo
	. . . s Data=s2
	. . . d OutputRow
	. . e  d
	. . . s PSeq=$p(sub,"||",2)
	. . . s SubSeqCount=SubSeqCount+1
	. . . s SubSeqNo=SeqNo_"."_SubSeqCount
	. . . s $List(s2,16)=SubSeqNo
	. . . s Data=s2
	. . . d OutputRow
	
	Set qHandle=$lb(0,repid,0)
	k ^CacheTempFHQ(repid)
	k ^CacheTemp("DHCMedFindOrdItem",$j,"master")
 quit $$$OK
OutputRow
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetOrdListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrdListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOrdListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrdListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	
	Quit $$$OK
}

ClassMethod GetOrdItem(repid As %Integer = 0, AdmId As %String = "", SearchStartDate As %String = "", SearchEndDate As %String = "", CategoryID As %String = "", SubsortID As %String = "", ArcId As %String = "", LongOrd As %String = "", ShortOrd As %String = "", OrdStat As %String = "") As %Integer
{
	s ^RP("benCiItm")=LongOrd_"^"_ShortOrd
	s del="^",AdmType="",RetNum=0
	
	q:($g(AdmId)="") RetNum
	q:'$d(^OEORD(0,"Adm",AdmId)) RetNum
	s OrdId1=$o(^OEORD(0,"Adm",AdmId,0))
	s PatientID=$P(^PAADM(AdmId),"^",1)
	q:OrdId1=""
	s OrdId2=0
	s OrdCreateDate="",OrdCreateTime="",OrdStartDate="",OrdStartTime="",ArcimDesc=""
	f  s OrdId2=$o(^OEORD(OrdId1,"I",OrdId2)) q:OrdId2=""  d
	.s OEItemID=OrdId1_"||"_OrdId2
	.s ordstr1=$g(^OEORD(OrdId1,"I",OrdId2,1))
	.s ordstr2=$g(^OEORD(OrdId1,"I",OrdId2,2))
	.s ordstr3=$g(^OEORD(OrdId1,"I",OrdId2,3))
	.s ordstr5=$g(^OEORD(OrdId1,"I",OrdId2,5))
	.s ordstr9=$g(^OEORD(OrdId1,"I",OrdId2,9))
	.s ordstr11=$g(^OEORD(OrdId1,"I",OrdId2,11))
	.s ArcimId=$p(ordstr1,del,2)
	.q:((ArcId'="")&(ArcimId'=ArcId))
	.s ArcStr=..GetArcimById(ArcimId)
	.q:ArcStr=""
	.s ArcimCode=$p(ArcStr,del,2),ArcimDesc=$p(ArcStr,del,3)
	.s OrdCreateDate=$p(ordstr3,del,7),OrdCreateDate=$zd(OrdCreateDate,3)
	.s OrdCreateTime=$p(ordstr1,del,17),OrdCreateTime=$zt(OrdCreateTime,2)
	.s OrdStartDate=$p(ordstr1,del,9),OrdStartDate=$zd(OrdStartDate,3)
	.s OrdStartTime=$p(ordstr1,del,10),OrdStartTime=$zt(OrdStartTime,2)
	.s PrescNo=$p(ordstr1,del,14)
	.s DoseQty=$p(ordstr2,del,1),DoseUnit=$p(ordstr2,del,3)
	.//guorongyong start 2008-11-25
	.s OrdcatDR=""
	.s SubsortDR=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1),del,10)
	.s:SubsortDR'="" OrdcatDR=$p(^ARC("IC",SubsortDR),del,8)
	.Q:(SubsortID'="")&&(SubsortID'=SubsortDR)
	.Q:(CategoryID'="")&&(CategoryID'=OrdcatDR)
	.Q:(SearchStartDate'="")&&(SearchEndDate'="")&&(($zdh(OrdStartDate,3)<SearchStartDate)||($zdh(OrdStartDate,3)>SearchEndDate))
	.s OrderSeqNo=$p(ordstr3,del,4)
	.//end
	.s:DoseUnit'="" DoseUnit=$p(^CT("UOM",DoseUnit),del,2)
	.s PriorityDR=$p(ordstr1,del,8)
	.s:$g(PriorityDR)="" Priority="",PriorityCode=""
	.s:$g(PriorityDR)'="" Priority=$p(^OECPR(PriorityDR),del,2),PriorityCode=$p(^OECPR(PriorityDR),del,1)
	.;w !,Priority_"^"_PriorityCode
	.Q:(+LongOrd=0)&(LongOrd'="")&(PriorityCode'=LongOrd)	//优先级输入框为空时或取的值为数字
	.;Q:(ShortOrd="on")&&(LongOrd'="on")&&(PriorityCode'="NORM")
	.s PHFreq=$p(ordstr2,del,4)
	.s:($g(PHFreq)'="")&&($d(^PHCFR(PHFreq))) PHFreq=$p(^PHCFR(PHFreq),del,1)
	.s:$g(PHFreq)="" PHFreq=""
	.s Instr=$p(ordstr2,del,7)
	.s:$g(Instr)'="" Instr=$p(^PHCIN(Instr),del,2)
	.s:$g(Instr)="" Instr=""
	.s OrdStatusDR=$p(ordstr1,del,13)
	
	.s:$g(OrdStatusDR)'="" OrdStatus=$p(^OEC("OSTAT",OrdStatusDR),del,2),OrdStatusCode=$p(^OEC("OSTAT",OrdStatusDR),del,1)
	.s:$g(OrdStatusDR)="" OrdStatus=$g(OrdStatusDR),OrdStatusCode=""
	.Q:(OrdStat'="")&&(OrdStatusCode=OrdStat)    ;东方医院不显示停止的医嘱
	
	.s Dura=$p(ordstr2,del,6)
	.s:$g(Dura)'="" Dura=$p(^PHCDU(Dura),del,3)
	.s:$g(Dura)="" Dura=""
	.s doctor=$p(ordstr1,del,11)
	.s:$g(doctor)'="" doctor=$p(^CTPCP(doctor,1),del,2)
	.s:$g(doctor)="" doctor=""
	.s QtyPackUOM=$p(ordstr9,del,4)
	.s PackUOMDesc=""
	.s BillingUOMDR=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),8),"^",14)
	.if BillingUOMDR'="" s PackUOMDesc=$p(^CT("UOM",BillingUOMDR),"^",2)
	.s HaveDispensing=0,dstatus=""
	.s dis=0  f  s dis=$O(^DHCOEDISQTY(0,"OEORI",OEItemID,dis)) Q:dis=""  d
	..s dstatus=$p(^DHCOEDISQTY(dis),"^",7)
	..s HaveDispensing=1
	.i HaveDispensing=1 d
	..i dstatus="C" s dstatus="已发"
	..i dstatus="P" s dstatus="未发"
	..i dstatus=""  s dstatus="未打包"
	.;条码号,标本
	.s LabEpisodeNo=$p(ordstr3,del,20) ;
	.s OrdLabSpec=..GetLabSpec(OEItemID)
	.;停医嘱日期,停医嘱时间
	.s OrdXDate=$p(ordstr3,del,34)
	.if OrdXDate'="" s OrdXDate=$zd(OrdXDate,3)
	.s OrdXTime=$p(ordstr2,del,15)
	.if OrdXTime'="" s OrdXTime=$zt(OrdXTime,2)
	.;皮试,皮试备注,备注,
	.s OrdSkinTest=$p(ordstr5,del,2)
	.s OrdAction=$p(ordstr11,del,21)
	.i OrdAction'="" s OrdAction=$P($G(^OEC("ACT",OrdAction)),"^",2) 
	.s OrdDepProcNotes=$g(^OEORD(OrdId1,"I",OrdId2,"DEP",1))
	.s OrdBilled=$p(ordstr3,"^",5)
	.s abnorm=$p($g(^OEORD(OrdId1,"I",OrdId2,11)),"^",3)
	.s OrdSkinTestResult=""
	.i OrdSkinTest="Y" d
	..i abnorm="Y" s OrdSkinTestResult="阳性"
	..e  s OrdSkinTestResult="阴性"
	.;
	.S RetNum=RetNum+1
	.S ^CacheTempFHQ(repid,RetNum)=$LB(OrdCreateDate,OrdCreateTime,OrdStartDate,OrdStartTime,ArcimDesc,DoseQty,DoseUnit,Priority,PHFreq,Instr,doctor,OrdStatus,Dura,OEItemID,PatientID,OrderSeqNo,QtyPackUOM,PackUOMDesc,PrescNo,dstatus,LabEpisodeNo,OrdLabSpec,OrdXDate,OrdXTime,OrdSkinTest,OrdAction,OrdDepProcNotes,OrdBilled,OrdSkinTestResult)
	.;W OrdCreateDate,OrdCreateTime,OrdStartDate,OrdStartTime,ArcimDesc,DoseQty,DoseUnit,PHFreq,Instr,doctor,!
	q RetNum
}

ClassMethod GetArcimById(ArcimId As %String) As %String
{
	q:$g(ArcimId)="" ""
	s del="^"
	s ArcCode="",ArcDesc="",subcat="",drug="",startdate="",enddate="",Priority=""
	s ArcimId1=$p(ArcimId,"||",1),ArcimId2=$p(ArcimId,"||",2)
	q:'$d(^ARCIM(ArcimId1,ArcimId2))
	s Unit=""
 	s ArcCode=$p(^ARCIM(ArcimId1,ArcimId2,1),del,1)
 	s ArcDesc=$p(^ARCIM(ArcimId1,ArcimId2,1),del,2)
 	s subcat=$p(^ARCIM(ArcimId1,ArcimId2,1),del,10)
	s:subcat'="" subcat=$p(^ARC("IC",subcat),del,2)
	s UnitDr=$p(^ARCIM(ArcimId1,ArcimId2,8),del,14)
	s:$g(UnitDr)'="" Unit=$p(^CT("UOM",UnitDr),del,2)
	s drug=$p(^ARCIM(ArcimId1,ArcimId2,1),del,12)
 	i $g(drug)'="" d
 	.s drug1=$p(drug,"||",1),drug2=$p(drug,"||",2),drug=$p(^PHCD(drug1,drug2),del,2)
 	s startdate=$P($p(^ARCIM(ArcimId1,ArcimId2,1),del,13),"Z",1)
 	if $g(startdate)'="" s startdate=$zd(startdate,3)
 	s enddate=$p(^ARCIM(ArcimId1,ArcimId2,7),del,1)
 	if $g(enddate)'="" s enddate=$zd(enddate,3)
 	q:(($g(stopflag)'="")&(enddate<$zd($h,3)))
 	s Priority=$p(^ARCIM(ArcimId1,ArcimId2,8),del,22)
 	IF $G(Priority)'="" S Priority=$p(^OECPR(Priority),del,2)
 	s RetStr=ArcimId_del_ArcCode_del_ArcDesc_del_subcat_del_drug_del_startdate_del_enddate_del_Priority_del_Unit
	q RetStr
}

ClassMethod GetLabSpec(OrderItemRowid As %String) As %String
{
 	s SpecStr=""
 	s OrderRowid=$p(OrderItemRowid,"||",1)
 	s Childsub=$p(OrderItemRowid,"||",2)
 	s spec=0 for  s spec=$o(^OEORD(OrderRowid,"I",Childsub,"SPEC",spec)) QUIT:spec=""  do
 	. s SpecCode=$P($g(^OEORD(OrderRowid,"I",Childsub,"SPEC",spec)),"^",1)
 	. s SpecDesc=$p($G(^TTAB("SPEC",SpecCode)),"\",1)
 	. i SpecStr="" s SpecStr=SpecDesc
 	. e  s SpecStr=SpecStr+","+SpecDesc
 	Q SpecStr

 	n (Ord, Sub,OrderItemRowid)
 	s Ord=+OrderItemRowid
 	s Sub=$P(OrderItemRowid,"||",2)
 	s retno=""
 	q:Ord="" retno
 	q:'$d(^OEORD(Ord,"I",Sub,1)) retno
 	s ItmMastDR=$p(^OEORD(Ord,"I",Sub,1),"^",2)
 	q:ItmMastDR="" retno
 	s arcsub=$p(ItmMastDR,"||",2)
 	q:arcsub="" retno
 	s excode=""
 	s chl=0 f  s chl=$o(^ARCIM(+ItmMastDR,arcsub,"EXT",chl)) q:chl=""  d
 	.s tod=$p(^ARCIM(+ItmMastDR,arcsub,"EXT",chl),"^",2)
 	.q:(tod'="")&(tod<+$h)
 	.s excode=$p(^ARCIM(+ItmMastDR,arcsub,"EXT",chl),"^",4)
 	q:excode="" retno
	s contdr=$o(^TTAB("TS",excode,"SC",""))
	q:contdr="" retno
	s specdr=$o(^TTAB("TS",excode,"SC",contdr,""))
	q:specdr="" retno  
	s specdesc=$p($G(^TTAB("SPEC",specdr)),"\",1)
	q specdesc
}

/// Creator：     liuyh
/// CreatDate：   2010-06-11
/// Description:  查询医嘱大类
/// Table：       OEC_OrderCategory
/// Input
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.QryPatOrdInfo","QueryQECATInfo")
Query QueryQECATInfo() As %Query(ROWSPEC = "rowid:%String,desc:%String")
{
}

ClassMethod QueryQECATInfoExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""

	f  s rowid=$o(^OEC("ORCAT",rowid)) q:rowid=""  d
	.s $li(data,1)=rowid
	.s $li(data,2)=$p($g(^OEC("ORCAT",rowid)),"^",2)
	.q:$li(data,2)=""
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
	q $$$OK
}

ClassMethod QueryQECATInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryQECATInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryQECATInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryQECATInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// Creator：     liuyh
/// CreatDate：   2010-06-11
/// Description:  查询医嘱大类
/// Table：       OEC_OrderCategory
/// Input
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.QryPatOrdInfo","QueryARCItemCatInfo",1)
Query QueryARCItemCatInfo(OrdCatDR As %String) As %Query(ROWSPEC = "rowid:%String,desc:%String")
{
}

ClassMethod QueryARCItemCatInfoExecute(ByRef qHandle As %Binary, OrdCatDR As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""
	;q:+OrdCatDR=0 $$$OK

	f  s rowid=$o(^ARC("IC",0,"OrdCat",OrdCatDR,rowid)) q:rowid=""  d
	.s $li(data,1)=rowid
	.s $li(data,2)=$p($g(^ARC("IC",rowid)),"^",2)
	.q:$li(data,2)=""
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
	q $$$OK
}

ClassMethod QueryARCItemCatInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryARCItemCatInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryARCItemCatInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryARCItemCatInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// Creator：     liuyh
/// CreatDate：   2010-06-11
/// Description:  查询医嘱优先级
/// Table：       OEC_Priority
/// Input
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.QryPatOrdInfo","QueryAllOECPR")
Query QueryAllOECPR() As %Query(ROWSPEC = "rowid:%String,code:%String,desc:%String")
{
}

ClassMethod QueryAllOECPRExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""
	;q:+OrdCatDR=0 $$$OK

	f  s rowid=$o(^OECPR(rowid)) q:rowid=""  d
	.s $li(data,1)=rowid
	.s $li(data,2)=$p($g(^OECPR(rowid)),"^",1)	//code
	.s $li(data,3)=$p($g(^OECPR(rowid)),"^",2)	//desc
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
	q $$$OK
}

ClassMethod QueryAllOECPRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAllOECPRExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryAllOECPRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAllOECPRExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

}
