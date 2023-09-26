/// 名称:    web.DHCFOrdGet
/// 描述:    医嘱录入的控制类
/// 编写者:  郭荣勇
/// 编写日期: 2009.02.20
/// 适用医院: 珠海人民医院
Class web.DHCFOrdGet Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 找大类
ClassMethod GetCategoryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCategoryExecute ]
{
	Quit ##Class(web.DHCFBASICINFO).QueryClose(qHandle)
}

/// Creator:      郭荣勇
/// CreatDate:    2009.02.20
/// Description:  查找大类
/// Table:        OEC_OrderCategory
/// Input:        OrdCategory:大类名称,大类代码
/// Return:       
/// Others:       
ClassMethod GetCategoryExecute(ByRef qHandle As %Binary, OrdCategory As %String) As %Status
{
 //d ##class(%ResultSet).RunQuery("web.DHCFOrdGet","GetCategory","")
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 s CategoryID=0
 f  s CategoryID=$O(^OEC("ORCAT",CategoryID)) q:CategoryID=""  d
 .s OrdCategoryDesc=$p(^OEC("ORCAT",CategoryID),"^",2)
 .s OrdCategoryCode=$p(^OEC("ORCAT",CategoryID),"^",1)
 .s OrdCategoryID=CategoryID
 .Q:(OrdCategory'="")&&(OrdCategoryDesc'[OrdCategory)&&(OrdCategoryCode'[OrdCategory)
 .d OutputRow2

 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2
 set Data=$lb(OrdCategoryDesc,OrdCategoryCode,OrdCategoryID)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod GetCategoryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCategoryExecute ]
{
 s Row= ##Class(web.DHCFBASICINFO).QueryFetch(qHandle,AtEnd)
 Quit $$$OK
}

ClassMethod GetOrdByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrdByAdmExecute ]
{
	Quit ##Class(web.DHCFBASICINFO).QueryClose(qHandle)
}

/// Creator:      郭荣勇
/// CreatDate:    2009.02.20
/// Description:  查找本次就诊的所有医嘱
/// Table:        OEC_OrderCategory
/// Input:        EpisodeID:就诊指针, SearchStartDate:开始日期,SearchEndDate:截止日期
/// CategoryID:	  大类指针, SubsortID:子类指针
/// Return:       
/// Others:       
ClassMethod GetOrdByAdmExecute(ByRef qHandle As %Binary, EpisodeID As %String = "", SearchStartDate As %String = "", SearchEndDate As %String = "", CategoryID As %String = "", SubsortID As %String = "", LongOrd As %String = "", ShortOrd As %String = "", OutOrd As %String = "", OrdStat As %String = "") As %Status
{
	s ^RP("GetOrdByAdm")=EpisodeID_"^"_SearchStartDate_"^"_SearchEndDate_"^"_CategoryID_"^"_SubsortID_"^"_LongOrd_"^"_ShortOrd
	///d ##class(%ResultSet).RunQuery("web.DHCFOrdGet","GetOrdByAdm","201764","61325","61325","","")
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if (SearchStartDate'="")&&(SearchEndDate'="")&&((SearchEndDate-SearchStartDate)>365) Quit
	
	s RetNum=..GetOrdItem(repid,EpisodeID,SearchStartDate,SearchEndDate,CategoryID,SubsortID,"",LongOrd,ShortOrd,OutOrd,OrdStat)
	s i=0
	s SeqNo=1
	s SubSeqCount=1
	f  s i=$o(^CacheTempFHQ(repid,i)) q:i=""  d
	.s Data=^CacheTempFHQ(repid,i)
	.s OEItemID=$list(Data,14)
	.s OEItemIDChildsub=+$P($list(Data,14),"||",2)
	.i $d(^OEORD(+OEItemID,"I",$p(OEItemID,"||",2),11)) s LinkOrderItemChildsub=$P($p(^OEORD(+OEItemID,"I",$p(OEItemID,"||",2),11),"^",39),"||",2)
	.if $G(LinkOrderItemChildsub)="" d
	..s ^CacheTemp("DHCFindOrdItem",$j,"master",OEItemIDChildsub)=Data
	.e  d
	..if '$D(^CacheTemp("DHCFindOrdItem",$j,"master",LinkOrderItemChildsub)) d
	...s ^CacheTemp("DHCFindOrdItem",$j,"master",LinkOrderItemChildsub)=""
	..s ^CacheTemp("DHCFindOrdItem",$j,"master",LinkOrderItemChildsub,"sub",OEItemIDChildsub)=Data
	
	s SeqNo=0
	s mas=0 for  s mas=$O(^CacheTemp("DHCFindOrdItem",$j,"master",mas)) q:mas=""  d
	. s s1=^CacheTemp("DHCFindOrdItem",$j,"master",mas)
	. s PSeq=$p(mas,"||",2)
	. i s1'="" d 
	. .s SeqNo=SeqNo+1
	. .s $List(s1,16)=SeqNo
	. .s Data=s1
	. .d OutputRow
	. s SubSeqCount=0
	. s sub=0  for  s sub=$O(^CacheTemp("DHCFindOrdItem",$j,"master",mas,"sub",sub)) q:sub=""  d
	. . s s2=^CacheTemp("DHCFindOrdItem",$j,"master",mas,"sub",sub)
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
	k ^CacheTemp("DHCFindOrdItem",$j,"master")
 quit $$$OK
OutputRow
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetOrdByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrdByAdmExecute ]
{
 s Row= ##Class(web.DHCFBASICINFO).QueryFetch(qHandle,AtEnd)
 Quit $$$OK
}

/// 通过接收科室和医嘱项ID查找医嘱
ClassMethod GetOrdByArcimId(repid As %Integer = 0, Para As %String = "") As %Integer
{
 ;s Para=146||2^2007-08-01^2
 ;w $$class(web.DHCFOrdGet).GetOrdByArcimId(1,"146||2^2007-08-01^2")
 S del="^",i=1,RetNum=0
 s ArcId=$p(Para,del,1)
 s StDate=$p(Para,del,2)
 s RecLocId=$p(Para,del,3)
 s childid=""
 S orddate="",OrdId1="",OrdId2=""
 f  s orddate=$o(^OEORDi(0,"OrdDep",RecLocId,StDate,orddate)) q:orddate=""  d
 .f  set OrdId1=$o(^OEORDi(0,"OrdDep",RecLocId,StDate,orddate,OrdId1)) q:OrdId1=""  d
 ..f  set OrdId2=$o(^OEORDi(0,"OrdDep",RecLocId,StDate,orddate,OrdId1,OrdId2)) q:OrdId2=""  d
 ...s ordid=OrdId1_"||"_OrdId2
 ...S adm=##class(web.DHCFBPat).GetAdmByOeord(ordid)
 ...q:adm=""
 ...s AdmType=$p(^PAADM(AdmId,1),del,2)
 ...s BillStatus=$p(^OEORD(OrdId1,"I",OrdId2,3),del,5)
 ...Q:((AdmType="O") & (BillStatus'="P"))
 ...s adminfo=""
 ...s adminfo=##class(web.DHCFBPat).GetAdmInfoByAdm(adm)
 ...;patno patname patname2_sex_age_pattype_admloc_"就诊日期"_admdate_ward_room_bed_doctor_patstatus
 ...;  1      2       3      4   5       6    7               8       9   10   11   12     13
 ...s patno="",patname="",patward="",bed="",doctor="",patstatus=""
 ...if adminfo'=""  d
 ....s patno=$p(adminfo,del,1),patname=$p(adminfo,del,2),admloc=$p(adminfo,del,7)
 ....s bed=$p(adminfo,del,11),doctor=$p(adminfo,del,12),patstatus=$p(adminfo,del,13)
 ...q:((patstatus'="")&(patstatus'="A"))
 ...s arcimid=$p(^OEORD(OrdId1,"I",OrdId2,1),del,2),arcimid1=$p(arcimid,"||"),arcimid2=$p(arcimid,"||",2)
 ...q:arcimid'=ArcId
 ...s OrdInfo=##class(web.DHCFBOrdGet).GetOrdByOrdId(ordid)
 ...q:OrdInfo=""
 ...s orddesc=$p(OrdInfo,del,6)
 ...s ordstatus=$p(^OEORD(OrdId1,"I",OrdId2,1),del,13)
 ...q:ordstatus'="1"
 ...S ordstatus=$p(OrdInfo,del,14)
 ...s ordqty=$p(OrdInfo,del,8)
 ...s ordunit=$p(OrdInfo,del,9)
 ...s StDate=$p(OrdInfo,del,4)
 ...s OrdLoc=$p(OrdInfo,del,16)
 ...S RetNum=RetNum+1
 ...s ^CacheTempFHQ(repid,RetNum)=ordid_del_""_del_patname_del_patno_del_StDate_del_orddesc_del_ordstatus_del_ordqty_del_ordunit_del_admloc_del_doctor_del_OrdLoc_del_bed_del_OrderPackQty
 ;W OrdId,OrdCreateDate,OrdCreateTime,OrdStartDate,OrdStartTime,ArcimDesc,OeoriDr,DoseQty,DoseUnit,Priority,PHFreq,Instr,doctor,OrdStatus,Dura,OrdLoc
	;      1			2		3			4				5			6		7		8		9		10	    11	    12	 	13		14     15   16
	;        RecDep,AdmLoc,BillStatus,StopDate,StopTime,StopDoctor,PrescNo
	;         17	18			19		20		21		22            23
 q RetNum
}

ClassMethod GetOrdByPatNo(repid As %Integer, Para As %String = "") As %Integer
{
	S del="^",i=1,RetNum=0
	;Para=PatNo_del_RecLocId_del_ConfirmDate
	s EOrdStatus=1  ;执行医嘱壮态
	s PatNo=$p(Para,del,1),StDate=$p(Para,del,2),RecLocId=$p(Para,del,3)
 s PatInfo=##class(web.DHCFBPat).GetPatInfoByPatNo(PatNo)
 q:PatInfo="" 0
 s PatNo=$p(PatInfo,del,2),PatName=$p(PatInfo,del,3)
 S OrdId="",OrdId1=0,OrdId2=0
	f  s OrdId1=$o(^OEORDi(0,"RecDepStartDateTime",RecLocId,StDate,OrdId1)) q:OrdId1=""  d 
	.s OrdId2=0
	.f  s OrdId2=$o(^OEORDi(0,"RecDepStartDateTime",RecLocId,StDate,OrdId1,OrdId2)) q:OrdId2=""  d
	..s OrdStatus=$p(^OEORD(OrdId1,"I",OrdId2,1),del,13)
	..q:OrdStatus'=1  ;医嘱壮态不等1时退出
	..s OrdId=OrdId1_"||"_OrdId2
	..s AdmId=##class(web.DHCFBPat).GetAdmByOeord(OrdId)
	..q:AdmId=""
	..s AdmType=$p(^PAADM(AdmId,1),del,2)
 ..s BillStatus=$p(^OEORD(OrdId1,"I",OrdId2,3),del,5)
 ..Q:((AdmType="O") & (BillStatus'="P"))  ;如果是门诊病人没有交费就不能显示
	..s OrdInfo=##class(web.DHCFBOrdGet).GetOrdByOrdId(OrdId)
 ..q:OrdInfo=""
 ..s OrdDesc=$p(OrdInfo,del,6)
 ..S ordstatus=$p(OrdInfo,del,14)
 ..s ordqty=$p(OrdInfo,del,8)
 ..s ordunit=$p(OrdInfo,del,9)
 ..s SttDate=$p(OrdInfo,del,4)
 ..s OrdLoc=$p(OrdInfo,del,16)
 ..s Doctor=$p(OrdInfo,del,13)
 ..s AdmLoc=$p(OrdInfo,del,18)
 ..s bed=""
 ..S RetNum=RetNum+1
 ..s ^CacheTempFHQ(repid,RetNum)=OrdId_del_""_del_PatName_del_PatNo_del_SttDate_del_OrdDesc_del_ordstatus_del_ordqty_del_ordunit_del_AdmLoc_del_Doctor_del_OrdLoc_del_bed
 q RetNum
}

ClassMethod GetOrdByRecLoc(repid As %Integer = 0, Para As %String = "") As %Integer
{
	//通过接收科室和ADM号来查找医嘱
 S sep="&",del="^",i=1,RetNum=0
 s Adm=$p(Para,del,1)
 s RecLoc=$p(Para,del,2)
 s ArcimId=$p(Para,del,3)
 Q:($g(Adm)="") 0
 s orderid=$o(^OEORD(0,"Adm",Adm,""))
 q:orderid="" 0
 s adminfo=""
 s adminfo=##class(web.DHCFBPat).GetAdmInfoByAdm(Adm)
 ;patno_sep_patname_sep_patname2_sep_sex_sep_age_sep_pattype_sep_admloc_sep_"就诊日期"_admdate_sep_ward_sep_room_sep_bed_sep_doctor
 ;  1         2              3        4       5         6         7                   8            9        10      11       12
 s patno="",patname="",patward="",bed="",doctor=""
 if adminfo'=""  d
 .s patno=$p(adminfo,del,1),patname=$p(adminfo,del,2),admloc=$p(adminfo,del,7)
 .S bed=$p(adminfo,del,11),doctor=$p(adminfo,del,12),patstatus=$p(adminfo,del,13)
 q:((patstatus'="")&(patstatus'="A")) 0
 s childid=""
 f  s childid=$o(^OEORDi(0,"RecDepOrd",orderid,RecLoc,childid)) q:childid=""  d
 .S ordid=orderid_"||"_childid
 .s AdmType=$p(^PAADM(Adm,1),del,2)
 .s BillStatus=$p(^OEORD(orderid,"I",childid,3),del,5)
 .Q:((AdmType="O") & (BillStatus'="P"))
 .s ordstatus=$p(^OEORD(orderid,"I",childid,1),del,13)
 .q:ordstatus'="1"
 .s OrdInfo=##class(web.DHCFBOrdGet).GetOrdByOrdId(ordid)
 .q:OrdInfo=""
 .s orddesc=$p(OrdInfo,del,6)
 .S ordstatus=$p(OrdInfo,del,14)
 .s ordqty=$p(OrdInfo,del,8)
 .s ordunit=$p(OrdInfo,del,9)
 .s StDate=$p(OrdInfo,del,4)
 .s OrdLoc=$p(OrdInfo,del,16)
 .S RetNum=RetNum+1
 .s ^CacheTempFHQ(repid,RetNum)=ordid_del_""_del_patname_del_patno_del_StDate_del_orddesc_del_ordstatus_del_ordqty_del_ordunit_del_admloc_del_doctor_del_OrdLoc
 q RetNum
}

ClassMethod GetOrdConfirmByArcId(repid As %Integer, Para As %String = "") As %Integer
{
	S del="^",i=1,RetNum=0
	;Para=PatNo_del_RecLocId_del_ConfirmDate
	s EOrdStatus=6  ;执行医嘱壮态
	s ArcimId=$p(Para,del,1),RecLocId=$p(Para,del,2),ConfirmDate=$p(Para,del,3)
	s OrdId1=0,OrdId2=0,StId=0
	f  s OrdId1=$o(^OEORDi(0,"StatDate",ConfirmDate,OrdId1)) q:OrdId1=""  d
	.f  s OrdId2=$o(^OEORDi(0,"StatDate",ConfirmDate,OrdId1,OrdId2)) q:OrdId2=""  d
	..q:ArcimId'=$p(^OEORD(OrdId1,"I",OrdId2,1),del,2)
	..s OrdStatus=$p(^OEORD(OrdId1,"I",OrdId2,1),del,13)
	..q:OrdStatus'=EOrdStatus
	..s RecDep=$p(^OEORD(OrdId1,"I",OrdId2,3),del,6)
	..q:RecDep'=RecLocId
	..s StUser="",StDate="",StTime=""
	..f  s StId=$o(^OEORDi(0,"StatDate",ConfirmDate,OrdId1,OrdId2,StId)) q:StId=""  d
	...s StDate=$p(^OEORD(OrdId1,"I",OrdId2,"ST",StId),del,1)
	...q:($p(^OEORD(OrdId1,"I",OrdId2,"ST",StId),del,3)'=EOrdStatus)  ;医嘱壮态不等执行壮态时退出
	...s StUser=$p(^OEORD(OrdId1,"I",OrdId2,"ST",StId),del,4)
	...s:StUser'="" StUser=$p(^SSU("SSUSR",StUser),del,2)
	...s StTime=$p(^OEORD(OrdId1,"I",OrdId2,"ST",StId),del,2)
	...s StTime=..%ZT(StTime)
	..q:StDate'=ConfirmDate
	..S StDate=$ZD(StDate,3)
	..s OrdId=OrdId1_"||"_OrdId2
	..s OrdInfo=##class(web.DHCFBOrdGet).GetOrdByOrdId(OrdId)
	..q:OrdInfo=""
	..s OrdDesc=$p(OrdInfo,del,6)
 ..S OrdStatus=$p(OrdInfo,del,14)
 ..s OrdQty=$p(OrdInfo,del,8)
 ..s OrdUnit=$p(OrdInfo,del,9)
 ..s StDate=$p(OrdInfo,del,4)
 ..s OrdLoc=$p(OrdInfo,del,16)
 ..s AdmLoc=$p(OrdInfo,del,18)
 ..s Doctor=$p(OrdInfo,del,13)
 ..s PatNo=$p(OrdInfo,del,24)
 ..s PatInfo=##class(web.DHCFBPat).GetPatInfoByPatNo(PatNo)
 ..s PatNo=$p(PatInfo,del,2),PatName=$p(PatInfo,del,3)
 ..S RetNum=RetNum+1
 ..s ConfirmStatus="1"
 ..s ^CacheTempFHQ(repid,RetNum)=OrdId_del_ConfirmStatus_del_PatName_del_PatNo_del_StDate_del_OrdDesc_del_OrdStatus_del_OrdQty_del_OrdUnit_del_AdmLoc_del_Doctor_del_OrdLoc_del_StUser_del_StDate_del_StTime
	q RetNum
}

/// 根据病人登记号?接收科室?确认日期来查询已经确认的医嘱信息
ClassMethod GetOrdConfirmByPatno(repid, Para) As %Integer
{
	S del="^",i=1,RetNum=0
	;Para=PatNo_del_RecLocId_del_ConfirmDate
	s EOrdStatus=6  ;执行医嘱壮态
	s PatNo=$p(Para,del,1),RecLocId=$p(Para,del,2),ConfirmDate=$p(Para,del,3)
 s PatInfo=##class(web.DHCFBPat).GetPatInfoByPatNo(PatNo)
 q:PatInfo="" 0
 s PatNo=$p(PatInfo,del,2),PatName=$p(PatInfo,del,3)
 S OrdId="",OrdId1=0,OrdId2=0
	f  s OrdId1=$o(^OEORDi(0,"RecDep2",PatNo,RecLocId,OrdId1)) q:OrdId1=""  d 
	.f  s OrdId2=$o(^OEORDi(0,"RecDep2",PatNo,RecLocId,OrdId1,OrdId2)) q:OrdId2=""  d
	..s OrdStatus=$p(^OEORD(OrdId1,"I",OrdId2,1),del,13)
	..q:OrdStatus'=EOrdStatus  ;医嘱壮态不等执行壮态时退出
	..s OrdStatusId=0
	..s StUser="",StDate="",StTime=""
	..f  s OrdStatusId=$o(^OEORD(OrdId1,"I",OrdId2,"ST",OrdStatusId)) q:OrdStatusId=""  d
	...s StDate=$p(^OEORD(OrdId1,"I",OrdId2,"ST",OrdStatusId),del,1)
	...q:StDate'=ConfirmDate
	...q:($p(^OEORD(OrdId1,"I",OrdId2,"ST",OrdStatusId),del,3)'=EOrdStatus)  ;医嘱壮态不等执行壮态时退出
	...s StUser=$p(^OEORD(OrdId1,"I",OrdId2,"ST",OrdStatusId),del,4)
	...s:StUser'="" StUser=$p(^SSU("SSUSR",StUser),del,2)
	...s StTime=$p(^OEORD(OrdId1,"I",OrdId2,"ST",OrdStatusId),del,2)
	...s StTime=..%ZT(StTime)
	..q:StDate'=ConfirmDate  ;查询时间与确认时间不一样时退出
	..S StDate=$ZD(StDate,3)
	..s OrdId=OrdId1_"||"_OrdId2
	..s OrdInfo=##class(web.DHCFBOrdGet).GetOrdByOrdId(OrdId)
	..q:OrdInfo=""
 ..s OrdDesc=$p(OrdInfo,del,6)
 ..S OrdStatus=$p(OrdInfo,del,14)
 ..s OrdQty=$p(OrdInfo,del,8)
 ..s OrdUnit=$p(OrdInfo,del,9)
 ..s StDate=$p(OrdInfo,del,4)
 ..s OrdLoc=$p(OrdInfo,del,16)
 ..s AdmLoc=$p(OrdInfo,del,18)
 ..s Doctor=$p(OrdInfo,del,13)
 ..S RetNum=RetNum+1
 ..s ConfirmStatus=1
	..s ^CacheTempFHQ(repid,RetNum)=OrdId_del_ConfirmStatus_del_PatName_del_PatNo_del_StDate_del_OrdDesc_del_OrdStatus_del_OrdQty_del_OrdUnit_del_AdmLoc_del_Doctor_del_OrdLoc_del_StUser_del_StDate_del_StTime
	q RetNum
}

ClassMethod GetOrdItem(repid As %Integer = 0, AdmId As %String = "", SearchStartDate As %String = "", SearchEndDate As %String = "", CategoryID As %String = "", SubsortID As %String = "", ArcId As %String = "", LongOrd As %String = "", ShortOrd As %String = "", OutOrd As %String = "", OrdStat As %String = "") As %Integer
{
	s ^RP("benCiItm")=LongOrd_"^"_ShortOrd_"^"_OutOrd
	s del="^",AdmType="",RetNum=0
	q:($g(AdmId)="") RetNum
	q:'$d(^OEORD(0,"Adm",AdmId)) RetNum
	s AdmType=$p(^PAADM(AdmId),"^",2)
	s OrdId1=$o(^OEORD(0,"Adm",AdmId,0))
	s PatientID=$P(^PAADM(AdmId),"^",1)
    s PAADMRegConDisDR=$P($G(^PAADM(AdmId,"DHC")),"^",25)
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
	.s ArcStr=##class(web.DHCFBArcimGet).GetArcimById(ArcimId)
	.q:ArcStr=""
	.s EpissubtypeId=$P($g(^PAADM(AdmId,1)),"^",6)
	.s AdmReasonId=$P($g(^PAADM(AdmId,1)),"^",7)
	.s arctpdr=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",10)
	.s drgformId=$P(^ARCIM(+ArcimId,$P(ArcimId,"||",2),1),"^",12)
	.s arctype=$p(^ARC("IC",arctpdr),"^",7) ;ARC_ItemCat 表中的ARCIC_Ordertype ,="R"是药物
	.s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+ArcimId)
	.s Pqty=""
	.i INCIRowid'="" d
	..s oeori=OrdId1_"||"_OrdId2
	..s dis=$O(^DHCOEDISQTY(0,"OEORI",oeori,0))
	..q:dis=""
	..q:'$d(^DHCOEDISQTY(dis))
	..s Pqty=$p(^DHCOEDISQTY(dis),"^",2)
	.e  d
	..s pqty=0,pbrowid=0
	..f  s pbrowid=$o(^DHCPBi(0,"OEORI",OEItemID,pbrowid)) q:pbrowid=""  d
	...q:$d(^DHCPB(pbrowid))=10 ;add hujunbin 15.2.5
    ...q:$d(^DHCPB(pbrowid))=0 ;add hujunbin 15.2.5
    ...s confdr=$o(^DHCIPBillPatFeeConfirmi(0,"Bill",+pbrowid,""))
    ...s pb=pbrowid  ;+2015-3-19 hujunbin 底下获取账单的时候+pb就等于0了
    ...s pbosub=0
    ...f  s pbosub=$o(^DHCPBi(0,"OEORI",OEItemID,pbrowid,pbosub)) q:pbosub=""  d
    ....q:$d(^DHCPB(pbrowid,"O",pbosub))=10
    ....s pbo=^DHCPB(pbrowid,"O",pbosub)
    ....s pbbillqty=$p(pbo,"^",5)
    ....s pbrefundqty=$p(pbo,"^",6)
    ....s pqty=pqty+pbbillqty+pbrefundqty
	..i +pqty'=0 s Pqty=pqty
	..e  s Pqty=$p(^OEORD(OrdId1,"I",OrdId2,1),"^",12)
	..//s Pqty=$p(^OEORD(OrdId1,"I",OrdId2,1),"^",12)
	.s BaseUOMDesc=""
	.i INCIRowid'="" d
	..; INCI_CTUOM_DR  库存基本单位
	..s BaseUOMRowid=$p($g(^INCI(INCIRowid,1)),"^",10)
	..s BaseUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(BaseUOMRowid)
	.i $g(Pqty)'="" s Pqty=Pqty_""_BaseUOMDesc
	.s ArcimCode=$p(ArcStr,del,2),ArcimDesc=$p(ArcStr,del,3)
	.s ReqPartDesc=##Class(web.DHCAPPInterface).GetExaReqPartDesc(OEItemID)
	.s ArcimDesc=ArcimDesc_ReqPartDesc
	.s OrdCreateDate=$p(ordstr3,del,7),OrdCreateDate=..%ZD(OrdCreateDate) //$zd(OrdCreateDate,3)
	.s OrdCreateTime=$p(ordstr1,del,17),OrdCreateTime=..%ZT(OrdCreateTime,2)
	.s OrdStartDate=$p(ordstr1,del,9),OrdStartDate=..%ZD(OrdStartDate) //$zd(OrdStartDate,3)
	.s OrdStartTime=$p(ordstr1,del,10),OrdStartTime=..%ZT(OrdStartTime,2)
	.s OrderPrescNo=$p(ordstr1,del,14)
	.s DoseqtySum=$p(ordstr1,del,12)
	.s OrderPackQty=$p(ordstr9,del,4)
	.;非药品
	.i arctype'="R" d
	..s DoseqtySum=$p($g(^OEORD(OrdId1,"I",OrdId2,1)),"^",12)
	..i +Pqty'=0 s OrderPackQty=Pqty
	..e  s OrderPackQty=DoseqtySum
	..//s OrderPackQty=DoseqtySum
	.;如果整包装数量是空也不能把单次计量直接赋值
	.;i OrderPackQty=""  d
	.;.s OrderPackQty=DoseqtySum
	.s QtyPackUOM=$p(ordstr9,del,4)
	.s ReLoc=""
	.s ReLocID=$p($g(^OEORD(OrdId1,"I",OrdId2,3)),"^",6)
	.If ReLocID'="" Set ReLoc=$P($P($G(^CTLOC(ReLocID)),"^",2),"-",2)
	.s BillingUOMDR=##Class(web.DHCDocOrderCommon).GetOrdPackUOMDR(OrdId1_"||"_OrdId2)
	.s PackUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(BillingUOMDR)
	.s OEORIPrice=$p(ordstr3,del,25)
	.i OrderPackQty'="" d
	..i OrderPackQty<1 s OrderPackQty="0"_$number(OrderPackQty)
	..;包含基础单位和整包装代为的价格转换
	..s ExpStr=OrdId1_"||"_OrdId2_"^^"_AdmId_"^"_ReLocID //PAADMRegConDisDR_"^"_
	..s ArcPrice=##class(web.DHCDocOrderCommon).GetOrderPrice(EpissubtypeId,AdmReasonId,ArcimId , $H, "", "","", OEORIPrice,"",PAADMRegConDisDR,ProtocolPackUOMDR,ExpStr)
	.else  d
	..;只是基本单位的价格
	..s ExpStr=PAADMRegConDisDR_"^"_OrdId1_"||"_OrdId2_"^^"_AdmId_"^"_ReLocID
	..s ArcPrice=##class(web.UDHCJFPRICE).GetOrderPrice(EpissubtypeId,AdmReasonId,ArcimId , $H, "", "","", OEORIPrice,"",ExpStr)
	.s ArcPrice=$j($p(ArcPrice,"^",1),3,4)
	.s PrescNo=$p(ordstr1,del,14)
	.s DoseQty=$p(ordstr2,del,1)
	.s DoseUnitID=$p(ordstr2,del,3)
	.//guorongyong start 2008-11-25
	.s OrdcatDR=""
	.s SubsortDR=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1),del,10)
	.s:SubsortDR'="" OrdcatDR=$p(^ARC("IC",SubsortDR),del,8)
	.Q:(SubsortID'="")&&(SubsortID'=SubsortDR)
	.Q:(CategoryID'="")&&(CategoryID'=OrdcatDR)
	.s DateFormat=##class(websys.Conversions).DateFormat()
	.Q:(SearchStartDate'="")&&(SearchEndDate'="")&&(($zdh(OrdStartDate,DateFormat)<SearchStartDate)||($zdh(OrdStartDate,DateFormat)>SearchEndDate))
	.s OrderSeqNo=$p(ordstr3,del,4)
	.//end
	.s DoseUnit=""
	.s:DoseUnitID'="" DoseUnit=$p(^CT("UOM",DoseUnitID),del,2)
	.s PriorityDR=$p(ordstr1,del,8)
	.s:$g(PriorityDR)="" Priority="",PriorityCode=""
	.s:$g(PriorityDR)'="" Priority=$p(^OECPR(PriorityDR),del,2),PriorityCode=$p(^OECPR(PriorityDR),del,1)
	.;w !,Priority_"^"_PriorityCode
	.Q:(LongOrd="on")&&(ShortOrd'="on")&&(OutOrd'="on")&&(PriorityCode'="S")
	.Q:(ShortOrd="on")&&(LongOrd'="on")&&(OutOrd'="on")&&(PriorityCode'="NORM")
	.Q:(OutOrd="on")&&(ShortOrd'="on")&&(LongOrd'="on")&&(PriorityCode'="OUT")
	.s PHFreq=""
	.s PHFreqDR=$p(ordstr2,del,4)
	.s:($g(PHFreqDR)'="")&&($d(^PHCFR(PHFreqDR))) PHFreq=$p(^PHCFR(PHFreqDR),del,1)
	.s:$g(PHFreq)="" PHFreq=""
	.s Instr=$p(ordstr2,del,7)
	.s:$g(Instr)'="" Instr=$p(^PHCIN(Instr),del,2)
	.s:$g(Instr)="" Instr=""
	.s OrdStatusDR=$p(ordstr1,del,13)
	
	.s:$g(OrdStatusDR)'="" OrdStatus=$p(^OEC("OSTAT",OrdStatusDR),del,2),OrdStatusCode=$p(^OEC("OSTAT",OrdStatusDR),del,1)
	.s:$g(OrdStatusDR)="" OrdStatus=$g(OrdStatusDR),OrdStatusCode=""
	.Q:(OrdStat'="")&&(OrdStatusCode=OrdStat)    ;东方医院不显示停止的医嘱
	
	.s DuraDR=$p(ordstr2,del,6)
	.s Dura=""
	.s:$g(DuraDR)'="" Dura=$p(^PHCDU(DuraDR),del,3)
	.//s:$g(Dura)="" Dura=""
	.s doctor=$p(ordstr1,del,11)
	.s:$g(doctor)'="" doctor=$p($g(^CTPCP(doctor,1)),del,2)
	.s:$g(doctor)="" doctor=""
	.s HaveDispensing=0,dstatus="",TotalQty=0
	.//存储退药数量,发药数量
	.s DspConfirmQty=0,ConfirmQty=0 
	.s dis=0  f  s dis=$O(^DHCOEDISQTY(0,"OEORI",OEItemID,dis)) Q:dis=""  d
	..s TotalQty=$p(^DHCOEDISQTY(dis),"^",2)
	..s dstatus=$p(^DHCOEDISQTY(dis),"^",7)
	..s HaveDispensing=1
	..//发药或退药数量
	..s dconfirmqty=$p(^DHCOEDISQTY(dis),"^",11)
	..i dstatus="R" d 
	...//退药数量
	...s DspConfirmQty=DspConfirmQty+dconfirmqty
	..i dstatus="C" d
	...s ConfirmQty=ConfirmQty+dconfirmqty
	.i HaveDispensing=1 d
	..i dstatus="C" s dstatus="已发"
	..i dstatus="TC" s dstatus="未发"
	..i dstatus=""  s dstatus="未打包"
	..i (DspConfirmQty'=0) d
	...i DspConfirmQty=ConfirmQty s dstatus="已退药"
	...i DspConfirmQty<ConfirmQty s dstatus="部分退药"
	.;条码号,标本
	.s LabEpisodeNo=$p(ordstr3,del,20) ;
	.s OrdLabSpec=##Class(web.DHCOEOrdItem).GetLabSpec(OEItemID)
	.;停医嘱日期,停医嘱时间
	.s OrdXDate=$p(ordstr3,del,34)
	.if OrdXDate'="" s OrdXDate=..%ZD(OrdXDate) //$zd(OrdXDate,3)
	.s OrdXTime=$p(ordstr2,del,15)
	.if OrdXTime'="" s OrdXTime=..%ZT(OrdXTime,2)
	.;皮试,皮试备注,备注,
	.s OrdSkinTest=$p(ordstr5,del,2)
	.s OrdAction=$p(ordstr11,del,21)
	.i OrdAction'="" s OrdAction=$P($G(^OEC("ACT",OrdAction)),"^",2) 
	.s OrdDepProcNotes=$g(^OEORD(OrdId1,"I",OrdId2,"DEP",1))
	.i OrdDepProcNotes=""  s OrdDepProcNotes=$p($g(^OEORD(OrdId1,"I",OrdId2,2)),"^",8)
	.s OrdBilled=$p(ordstr3,"^",5)
	.i ((PriorityCode'="S")&&(PriorityCode'="OMST")&&(AdmType="I")) d
	..s OEOREBilled=$p($g(^OEORD(OrdId1,"I",OrdId2,"X",1)),"^",6)
	..i OEOREBilled'="" s OrdBilled=OEOREBilled
	.i OrdBilled="P" s OrdBilled="已收费"
	.i OrdBilled="B" s OrdBilled="已账单"
	.i OrdBilled="TB" s OrdBilled="未账单"
	.i OrdBilled="I"  s OrdBilled="待退费"
	.i (AdmType'="I")&&(OrdBilled="待退费") s OrdBilled="未计费"
	.i (AdmType="O") s OrdBilled=##class(web.UDHCJFBaseCommon).CheckOeBilled(OrdId1_"||"_OrdId2) 
	.s abnorm=$p($g(^OEORD(OrdId1,"I",OrdId2,11)),"^",3)
	.s OrdSkinTestResult=""
	.i OrdSkinTest="Y" d
	..i abnorm="Y" s OrdSkinTestResult="阳性"
	
	..i abnorm="N" s OrdSkinTestResult="阴性"
	.;
	.;医嘱退费情况判断
	.s RePay=##class(web.DHCBillInterface).IOrdItmInvStatusByOeoriDR(OrdId1_"||"_OrdId2)
	.s RePay=$p(RePay,"^")
	.i " 0 1 2 "[(" "_RePay_" ") s RePay=$Case(RePay,"0":"","1":"部分退费","2":"全部退费")
	.e  s RePay="其他"
	.S RetNum=RetNum+1
	.s OrdRowid=OrdId1_"||"_OrdId2
	.s LabNo=$p($g(^OEORD(OrdId1,"I",OrdId2,3)),"^",20)
	.s UserDepart="",UserDepartType=""
	.s UserDepartId=$p($g(^OEORD(OrdId1,"I",OrdId2,7)),"^",2)
	.If UserDepartId'=""  d
	..Set UserDepart=$P($P($G(^CTLOC(UserDepartId)),"^",2),"-",2)
	..Set UserDepartType=$P($G(^CTLOC(UserDepartId)),"^",13)
	.;Q:(UserDepartId="")&((onlydoc="Y")||(onlyNurse="Y")||(onlyloc'=""))
	.;Q:(onlydoc="Y")&(UserDepartType="W")
	.;Q:(onlyNurse="Y")&(UserDepartType="E")
	.;Q:(onlyloc'="")&(onlyloc'=UserDepartId)
	.
	.s UserAdd=$p($g(^OEORD(OrdId1,"I",OrdId2,7)),"^",1)
	.If UserAdd'="" Set UserAdd=$P($G(^SSU("SSUSR",UserAdd)),"^",2)
	.s XUser=$p($g(^OEORD(OrdId1,"I",OrdId2,3)),"^",29)
	.if XUser'="" Set XUser=$P($G(^CTPCP(XUser,1)),"^",2)
	.s EndDate=$p($g(^OEORD(OrdId1,"I",OrdId2,9)),"^",9)
	.s EndTime=$p($g(^OEORD(OrdId1,"I",OrdId2,9)),"^",10)
	.If EndDate'="" Set EndDate=$ZD(EndDate,3)
	.If EndTime'="" Set EndTime=..%ZT(EndTime,1)
	.s CoverMainInsur=$p($g(^OEORD(OrdId1,"I",OrdId2,3)),"^",3)
	.s BillTypeRowid=$p($g(^OEORD(OrdId1,"I",OrdId2,11)),"^",18)
	.s BillType=""
	.If BillTypeRowid'=""  Set BillType=$P($G(^PAC("ADMREA",BillTypeRowid)),"^",2)
	.s OrderType=""
	.if arctpdr'="" s OrderType=$P(^ARC("IC",arctpdr),"^",7)
	.s OrderSum=OrderPackQty*ArcPrice
	.//门诊非药品医嘱进行了单位换算,在计算单个医嘱总价时要进行再次换算
	.if (AdmType'="I") d
	..//s ProtocolPackUOMDR=$p($g(^OEORD(OrdId1,"I",OrdId2,"DHC")),"^",13)
	..s ProtocolPackUOMDR=##Class(web.DHCDocOrderCommon).GetOrdPackUOMDR(OrdId1_"||"_OrdId2)
	..s convFac=##class(appcom.OEDispensing).convFac(ArcimId,ProtocolPackUOMDR)
	..i (OrderType'="R")&&(+convFac'=0) s OrderSum=OrderSum/convFac
	.s ActiveQty="",ActiveQtySum=""
	.i (OrderType="R") d
	..;如果没有填数量则自动计算数量
	..i +OrderPackQty=0  d
	...s OrdMesage=##class(web.DHCDocOrderCommon).GetOrderMesage(OrdId1_"||"_OrdId2)
	...;s OrderPackQty=TotalQty
	...;s OrderSum=TotalQty*ArcPrice
	...;s ActiveQty=ConfirmQty-DspConfirmQty 
	...;s ActiveQtySum=ActiveQty*ArcPrice	;有效价格
	...;s ActiveQtySum=$fn(ActiveQtySum,"",2)
	...;s ActiveQty=ActiveQty_BaseUOMDesc	;有效数量
	...s ActiveQtySum=$fn($P(OrdMesage,"^",11),"",2)
	...s ActiveQty=$P(OrdMesage,"^",12)
	...s OrderPackQty=ActiveQty
	...s Pqty=ActiveQty
	...s ActiveQty=ConfirmQty-DspConfirmQty
	..e  d
	...;有整包装数量,按整包装计算有效数量的价格
	...s ActiveQty=ConfirmQty-DspConfirmQty
	...s ActiveQtySum=OrderPackQty*ArcPrice	;有效价格
	...s ActiveQtySum=$fn(ActiveQtySum,"",2)
	...s ActiveQty=ActiveQty_BaseUOMDesc	;有效数量
	.s:(+ActiveQtySum<=0) ActiveQtySum=OrderSum ;有效价格没有按照开医嘱价格计算
	.i DspConfirmQty'=0 d
	..//加上基本单位
	..s DspConfirmQty=DspConfirmQty_BaseUOMDesc
	.s MaterialBarCode=$p($G(^OEORD(OrdId1,"I",OrdId2,"DHC")),"^",14) ;高值条码
	.;--------
	.s ToInpatient=""
	.s PatientType=$P(^PAADM(AdmId),"^",2)
	.i PatientType="O"  s ToInpatient="门诊医嘱"
	.i PatientType="I"  s ToInpatient="住院医嘱"
	.i PatientType="E"  s ToInpatient="急诊医嘱"
	.i $d(^DHCOPIPADMCON("OPADMORDER",AdmId,OrdRowid)) s ToInpatient="已转入住院医嘱"
	.S RetNum=RetNum+1
	.S ^CacheTempFHQ(repid,RetNum)=$LB(OrdCreateDate,OrdCreateTime,OrdStartDate,OrdStartTime,ArcimDesc,DoseQty,DoseUnit,Priority,PHFreq,Instr,doctor,OrdStatus,Dura,OEItemID,PatientID,OrderSeqNo,QtyPackUOM,PackUOMDesc,PrescNo,dstatus,LabEpisodeNo,OrdLabSpec,OrdXDate,OrdXTime,OrdSkinTest,OrdAction,OrdDepProcNotes,OrdBilled,OrdSkinTestResult,OrderPackQty,OrderPrescNo,Pqty,ArcPrice,ReLoc,LabNo,UserDepart,UserAdd,XUser,EndDate,EndTime,CoverMainInsur,BillType,DspConfirmQty,ActiveQty,ActiveQtySum,MaterialBarCode,RePay,ToInpatient)
	.;W OrdCreateDate,OrdCreateTime,OrdStartDate,OrdStartTime,ArcimDesc,DoseQty,DoseUnit,PHFreq,Instr,doctor,!
	q RetNum
}

/// 找子类
ClassMethod GetSubsortClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSubsortExecute ]
{
	Quit ##Class(web.DHCFBASICINFO).QueryClose(qHandle)
}

ClassMethod GetSubsortExecute(ByRef qHandle As %Binary, CategoryID As %String = "", OrdSubsort As %String = "") As %Status
{
 //d ##class(%ResultSet).RunQuery("web.DHCFOrdGet","GetSubsort","48","")
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 if CategoryID="" Set qHandle=$lb(0,repid,0)  Quit $$$OK
 s SubsortID=0
 f  s SubsortID=$O(^ARC("IC",0,"OrdCat",CategoryID,SubsortID)) q:SubsortID=""  d
 .s OrdSubDesc=$p(^ARC("IC",SubsortID),"^",2)
 .s OrdSubCode=$p(^ARC("IC",SubsortID),"^",1)
 .s OrdSubID=SubsortID
 .Q:(OrdSubsort'="")&&(OrdSubDesc'[OrdSubsort)&&(OrdSubCode'[OrdSubsort)
 .d OutputRow3

 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow3
 set Data=$lb(OrdSubDesc,OrdSubCode,OrdSubID)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod GetSubsortFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSubsortExecute ]
{
 s Row= ##Class(web.DHCFBASICINFO).QueryFetch(qHandle,AtEnd)
 Quit $$$OK
}

Query GetCategory(OrdCategory As %String) As %Query(ROWSPEC = "OrdCategoryDesc:%String,OrdCategoryCode:%String,OrdCategoryID:%String")
{
}

Query GetOrdByAdm(EpisodeID As %String = "", SearchStartDate As %String = "", SearchEndDate As %String = "", CategoryID As %String = "", SubsortID As %String = "", LongOrd As %String = "", ShortOrd As %String = "", OutOrd As %String = "", OrdStat As %String = "") As %Query(ROWSPEC = "OrdCreateDate:%String,OrdCreateTime:%String,OrdStartDate:%String,OrdStartTime:%String,ArcimDesc:%String,DoseQty:%String,DoseUnit:%String,Priority:%String,PHFreq:%String,Instr:%String,Doctor:%String,OrdStatus:%String,Dura,OEItemID:%String,PatientID:%String,SeqNo:%String,QtyPackUOM:%String,PackUOMDesc:%String,PrescNo:%String,dstatus:%String,LabEpisodeNo:%String,OrdLabSpec:%String,OrdXDate:%String,OrdXTime:%String,OrdSkinTest:%String,OrdAction:%String,OrdDepProcNotes:%String,OrdBilled:%String,OrdSkinTestResult:%String,OrderPackQty:%String,OrderPrescNo:%String,Pqty:%String,ArcPrice:%String,ReLoc:%String,LabNo:%String,userDep:%String,UserAdd:%String,XUser:%String,EndDate:%String,EndTime:%String,CoverMainInsur:%String,BillType:%String,DspConfirmQty:%String,ActiveQty:%String,ActiveQtySum:%String,MaterialBarCode:%String,RePay:%String,ToInpatient:%String")
{
}

Query GetSubsort(CategoryID As %String, OrdSubsort As %String) As %Query(ROWSPEC = "OrdSubDesc:%String,OrdSubCode:%String,OrdSubID:%String")
{
}

ClassMethod FindAdmOrderItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAdmOrderItemsExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 入参：就诊号，安全组ID，医嘱优先级，接收科室，开医嘱医生，药品标识
/// 出参：医嘱名称，医嘱状态，医嘱优先级，开始日期，开始时间，剂量，剂量单位，频次，用法，疗程，单价，数量，数量单位，皮试，接收科室，用户登录科室，开医嘱科室，总金额，处方号，备注，开医嘱医生，医嘱添加人，开医嘱日期，序号，主序号，关联序号，标本号，医嘱ID，医嘱项ID，剂量单位ID，频次ID，医嘱优先级ID，用法ID，疗程ID，数量单位ID，接收科室ID，用户登录科室ID，开医嘱科室ID，医嘱状态ID，医嘱基本单位ID，开医嘱医生ID，医嘱添加人ID，医嘱套ID，药学项ID，最大疗程ID，医嘱类型，医嘱费别ID，医嘱费别，频次系数，频次间隔时间，疗程系数，关联医嘱ID
ClassMethod FindAdmOrderItemsExecute(ByRef qHandle As %Binary, EpisodeID As %String, GroupRowId As %String = "", PriorID As %String, CTLOCRowId As %String, DocNameID As %String, DrugFlag As %String, ItemStatStr As %String = "", IsIncludeCNMed As %String = "", CurLogonHosp As %String = "") As %Status
{
 	;d ##class(%ResultSet).RunQuery("web.DHCFOrdGet","FindAdmOrderItems",4069150,299,"","","",""," I E V ","Y")
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if EpisodeID="" Set qHandle=$lb(0,repid,0) Quit $$$OK
 	set PatType="", InsType="", PriorRowid="", InstrRowid="", LinkTo="", OEPrice="",LabEpisodeNo=""
 	set UseCNMedEntry=..%GetConfig("UseCNMedEntry",CurLogonHosp)
 	i IsIncludeCNMed="Y",UseCNMedEntry=1 s UseCNMedEntry=0
 	
 	set PAADMType=$p($g(^PAADM(EpisodeID)),"^",2)
 	set PatType=$P(^PAADM(EpisodeID,1),"^",6)  //PAADM_Epissubtype_DR
	//if GroupRowId="" s GroupRowId=%session.Get("LOGON.GROUPID")
	set NoDisplayItemCat=..%GetConfig("NoDisplayItemCat",CurLogonHosp)
	do ResetVariables4
 	
	&SQL(DECLARE OrdCur0 CURSOR FOR
		 SELECT OEORI_Rowid,OEORI_ItmMast_DR,OEORI_ItmMast_DR->ARCIM_Desc,
			OEORI_SttDat,OEORI_SttTim,Todate(OEORI_SttDat,'yyyy-mm-dd'),
			OEORI_DoseQty,OEORI_Unit_DR,OEORI_Unit_DR->CTUOM_Desc,
			OEORI_QtyPackUOM,
			OEORI_Priority_dr,OEORI_Priority_dr->OECPR_Desc,
			OEORI_Itemstat_dr,OEORI_Itemstat_dr->OSTAT_Desc,
			OEORI_PHFreq_DR,OEORI_PHFreq_DR->PHCFR_Desc1,
			OEORI_Instr_DR,OEORI_Instr_DR->PHCIN_Desc1,
			OEORI_Durat_DR,OEORI_Durat_DR->PHCDU_Desc1,
			OEORI_RecDep_DR,OEORI_RecDep_DR->CTLOC_Desc,
			OEORI_UserDepartment_DR,OEORI_UserDepartment_DR->CTLOC_Desc,
			OEORI_Doctor_DR,OEORI_Doctor_DR->CTPCP_Desc,OEORI_UserAdd,OEORI_UserAdd->SSUSR_Name,
			OEORI_Billed,OEORI_AdministerSkinTest,OEORI_BBExtCode,
			OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType,
			OEORI_SeqNo,OEORI_LinkNo,OEORI_LinkToOrder,OEORI_PrescNo,OEORI_LabEpisodeNo,
			OEORI_ARCOS_DR,OEORI_BBExtCode,OEORI_OEORI_DR,Todate(OEORI_Date,'yyyy-mm-dd'),
			OEORI_OrdDept_DR,OEORI_OrdDept_DR->CTLOC_Desc
		 INTO :OrderItemRowid,:ARCIMRowid,:OrderName,:OrderSttDate,:OrderSttTime,:StartDate,
			:OrderDoseQty,:OrderDoseUOMRowid,:OrderDoseUOM,:OrderPackQty,
			:OrderPriorRowid,:OrderPrior,:OrderStatusRowid,:OrderStatus,:OrderFreqRowid,:OrderFreq,
			:OrderInstrRowid,:OrderInstr,:OrderDurRowid,:OrderDur,
			:OrderRecDepRowid,:OrderRecDep,:OrderUserDepRowid,:OrderUserDep,
			:OrderDocRowid,:OrderDoc,:OrderUserAddRowid,:OrderUserAdd,
			:OrderBilled,:OrderSkinTest,:OrderBillTypeRowid,:OrderType,
			:OrderSeqNo,:OrderMasterSeqNo,:OrderLinkTo,:OrderPrescNo,:OrderLabEpisodeNo,
			:OrderARCOSRowid,:OrderBillTypeRowid,:LinkOrderItem,:OrderDate,
			:OrderOrdDepRowid,:OrderOrdDep
		 From SQLUser.OE_OrdItem 
		 WHERE OEORI_OEORD_PARREF->OEORD_ADM_DR=:EpisodeID
		 Order By OEORI_SttDat desc)
	 &SQL(OPEN OrdCur0)
	 For  &SQL(FETCH OrdCur0) QUIT:SQLCODE  do
	 	. s OrderPackUOMRowid=##Class(web.DHCDocOrderCommon).GetOrdPackUOMDR(OrderItemRowid)
		. s OrderPackUOM=##class(web.DHCDocOrderCommon).GetUOMDesc(OrderPackUOMRowid)
	 	. s ItemStatCode=""
	 	. s ItemStatDR=$p($g(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),1)),"^",13)
	 	. i ItemStatDR'="" s ItemStatCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)
	 	. Q:(ItemStatStr'="")&&(ItemStatStr'[(" "_ItemStatCode_" "))
	 	. Q:(ItemStatStr="")&&(ItemStatCode="I")
		. Q:((PriorID'="")&(PriorID'=OrderPriorRowid))
		. ;Q:((SttDate'="")&(OrderSttDate<SttDate)&(PAADMType="I"))
		. ;Q:((EndDate'="")&(OrderSttDate>EndDate)&(PAADMType="I"))
		. ;Q:(GOrderNameID'=ARCIMRowid)&&(GOrderNameID'="")
		. Q:(CTLOCRowId'="")&&(OrderUserDepRowid'=CTLOCRowId)
		. Q:(DocNameID'="")&&(DocNameID'=OrderDocRowid)
		. ;非医生录入的医嘱退出
	    . s CarPrvTpDR=$p($g(^CTPCP(+$g(OrderDocRowid),1)),"^",4)
	    . s DoctorType=$p($g(^CT("CPT",+$g(CarPrvTpDR))),"^",4)
	    . Q:(PAADMType'="I")&&(DoctorType'="DOCTOR")
	    . s IsLinkOrderItemInstr=##class(web.DHCOEOrdItem).IsLinkOrderItemInstr($g(LinkOrderItem),ARCIMRowid)
		. Q:(IsLinkOrderItemInstr=1)
		. ;检验自动绑定上的医嘱不显示
		. s LinkLabNo=$p($g(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),"DHC")),"^",22)
		. Q:LinkLabNo'=""
		. s subcat=$p($g(^ARCIM(+ARCIMRowid,1,1)),"^",10)
		. Q:(NoDisplayItemCat'="")&(subcat'="")&(("^"_NoDisplayItemCat_"^")[("^"_subcat_"^"))
		. s PHPrescType=##class(web.DHCDocOrderCommon).GetPHPrescType(subcat)
		. ;使用草药录入程序
		. Q:(PHPrescType="3")&(UseCNMedEntry="1")
		. s orcat=$p($g(^ARC("IC",+subcat)),"^",8)
		. s orcatdesc=""
		. i orcat'="" s orcatdesc=$p($g(^OEC("ORCAT",orcat)),"^",2)
		. s RecDepDesc=$p(OrderRecDep,"-",2)
		. i RecDepDesc'="" s OrderRecDep=RecDepDesc
		. ;s retPrice=##class(web.DHCDocOrderEntry).GetOrderPrice(PatType, InsType, ARCIMRowid, OrderSttDate, PriorRowid, InstrRowid, LinkTo, OEPrice)
		. s retPrice=##class(web.DHCDocOrderCommon).GetOrderPrice(PatType, InsType, ARCIMRowid, OrderSttDate, PriorRowid, InstrRowid, LinkTo, OEPrice,OrderRecDepRowid)
		. s OrderPrice=$P(retPrice,"^",1)
		. s DiscPrice=$P(retPrice,"^",2)
		. s InsPrice=$P(retPrice,"^",3)
		. s PatPrice=$P(retPrice,"^",4)
		. s OrderPrice=$fn($P(retPrice,"^",1),"",4)
		. s OrderSum=OrderPackQty*OrderPrice
		. i OrderBillTypeRowid="" s OrderBillType="自费"
		. e  s OrderBillType=$P(^PAC("ADMREA",OrderBillTypeRowid),"^",2)
		. s OrderDoseQty=$TR(OrderDoseQty," ","")
		. i OrderType'="R" d
		. . s DoseqtySum=$p($g(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),1)),"^",12)
		. . s OrderPackQty=DoseqtySum
		. s OrderPackUOM=$p(OrderPackUOM,"(",1)
		. s OrderSum=OrderPackQty*OrderPrice
		. s OrderDepProcNote=$g(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),"DEP",1))
		. ;s Spec=..GetLabSpec(Rowid)
		. s OrderDrugFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ARCIMRowid)
		. s OrderFreqFactor="1",OrderFreqInterval="",OrderDurFactor="1"
		. if OrderFreqRowid'="" d
		..s OrderFreqFactor=$P($g(^PHCFR(OrderFreqRowid)),"^",2)
		..s OrderFreqInterval=$P($g(^PHCFR(OrderFreqRowid)),"^",5)
		.i OrderDurRowid'="" s OrderDurFactor=$P($g(^PHCDU(OrderDurRowid)),"^",2)
		.s OrderItemInValid=##Class(web.DHCDocOrderEntry).ValARCItem(ARCIMRowid)
		.if OrderItemInValid=0  d
		..;s OrderItemInValid=##Class(web.DHCDocOrderEntry).ValOrdcat(GroupRowId,orcat)
		.s ServerMaterial=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),7)),"^",6)
		.s TypeClass=""
		.i OrderType="R" d
		..i PHPrescType="3" s TypeClass="草药"
		..e  s TypeClass="西药"
		.e  i OrderType="L" s TypeClass="检验"
		.e  i (" Service S ")[(" "_ServerMaterial_" ") s TypeClass="检查"
		.e  s TypeClass="其他"
		. s Data1=$lb(OrderName,OrderStatus,OrderPrior,OrderSttDate,OrderSttTime,OrderDoseQty,OrderDoseUOM,OrderFreq,OrderInstr,OrderDur,OrderPrice,OrderPackQty,OrderPackUOM,OrderSkinTest,OrderRecDep,OrderUserDep,OrderOrdDep,OrderSum,OrderPrescNo,OrderDepProcNote,OrderDoc,OrderUserAdd,OrderDate,OrderSeqNo,OrderMasterSeqNo,OrderLinkTo,OrderLabEpisodeNo,OrderItemRowid,ARCIMRowid,OrderDoseUOMRowid,OrderFreqRowid,OrderPriorRowid,OrderInstrRowid,OrderDurRowid,OrderPackUOMRowid,OrderRecDepRowid,OrderUserDepRowid,OrderOrdDepRowid,OrderStatusRowid,OrderBaseUOMRowid,OrderDocRowid,OrderUserAddRowid,OrderARCOSRowid,OrderDrugFormRowid,OrderMaxDurRowid,OrderType,OrderBillTypeRowid,OrderBillType,OrderFreqFactor,OrderFreqInterval,OrderDurFactor,LinkOrderItem,EpisodeID,OrderBillTypeRowid,OrderItemInValid,TypeClass)
		.;
		. s OrderItemRowidchild=$P(OrderItemRowid,"||",2)
		. s LinkOrderItemchild=$P(LinkOrderItem,"||",2)
		. i LinkOrderItem="" s ^CacheTemp("DHCAdmOrdItem",$j,"adm",EpisodeID,"master",OrderItemRowidchild)=Data1
		. e  d
		. .if '$D(^CacheTemp("DHCAdmOrdItem",$j,"adm",EpisodeID,"master",LinkOrderItemchild)) d
		. . .s ^CacheTemp("DHCAdmOrdItem",$j,"adm",EpisodeID,"master",LinkOrderItemchild)=""
		. .s ^CacheTemp("DHCAdmOrdItem",$j,"adm",EpisodeID,"master",LinkOrderItemchild,"sub",OrderItemRowidchild)=Data1
		&SQL(CLOSE OrdCur0)
 		
		s SeqNo=0
		s adm=0 for  s adm=$O(^CacheTemp("DHCAdmOrdItem",$j,"adm",adm)) q:adm=""  d
		.s mas=0 for  s mas=$O(^CacheTemp("DHCAdmOrdItem",$j,"adm",adm,"master",mas)) q:mas=""  d
		.. s s1=^CacheTemp("DHCAdmOrdItem",$j,"adm",adm,"master",mas)
		.. q:s1=""
		.. q:((DrugFlag="R")&&($List(s1,47)'="R"))
		.. i s1'="" d 
		.. .s SeqNo=SeqNo+1
		.. .s $List(s1,24)=SeqNo
		.. .s Data=s1
		.. .d OutputRow4
		.. s SubSeqCount=0
		.. s sub=0  for  s sub=$O(^CacheTemp("DHCAdmOrdItem",$j,"adm",adm,"master",mas,"sub",sub)) q:sub=""  d
		.. . s s2=^CacheTemp("DHCAdmOrdItem",$j,"adm",adm,"master",mas,"sub",sub)
		.. . i s1="" d
		.. . . s SeqNo= SeqNo+1
		.. . . s $List(s2,24)=SeqNo
		.. . . s Data=s2
		.. . . d OutputRow4
		.. . e  d
		.. . . s SubSeqCount=SubSeqCount+1
		.. . . s SubSeqNo=SeqNo_"."_SubSeqCount
		.. . . s $List(s2,24)=SubSeqNo
		.. . . s Data=s2
		.. . . d OutputRow4
	 K ^CacheTemp("DHCAdmOrdItem",$j,"adm")
	 Set qHandle=$lb(0,repid,0)
	 Quit $$$OK
	 
OutputRow4
	;set Data=$lb(OrderName,OrderStatus,OrderPrior,OrderSttDate,OrderSttTime,OrderDoseQty,OrderDoseUOM,OrderFreq,OrderInstr,OrderDur,OrderPrice,OrderPackQty,OrderPackQtyUOM,OrderSkinTest,OrderRecDep,OrderUserDep,OrderOrdDep,OrderSum,OrderPrescNo,OrderDepProcNote,OrderDoc,OrderUserAdd,OrderDate,OrderSeqNo,OrderMasterSeqNo,OrderLinkTo,OrderLabEpisodeNo,OrderItemRowid,ARCIMRowid,OrderSttDate,OrderDoseUOMRowid,OrderFreqRowid,OrderPriorRowid,OrderInstrRowid,OrderDurRowid,OrderPackUOMRowid,OrderRecDepRowid,OrderUserDepRowid,OrderOrdDepRowid,OrderStatusRowid,OrderBaseUOMRowid,OrderDocRowid,OrderUserAddRowid,OrderLinkto,OrderARCOSRowid,OrderDrugFormRowid,OrderMaxDurRowid,OrderType,OrderBillTypeRowid,OrderMaxDurRowid,OrderBillType,DepProcNotes)
	
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
ResetVariables4
	set (OrderName,OrderStatus,OrderPrior,OrderSttDate,OrderSttTime,OrderDoseQty,OrderDoseUOM,OrderFreq,OrderInstr,OrderDur,OrderPrice,OrderPackQty,OrderPackUOM,OrderSkinTest,OrderRecDep,OrderUserDep,OrderOrdDep,OrderSum,OrderPrescNo,OrderDepProcNote,OrderDoc,OrderUserAdd,OrderDate,OrderSeqNo,OrderMasterSeqNo,OrderLinkTo,OrderLabEpisodeNo,OrderItemRowid,ARCIMRowid,OrderDoseUOMRowid,OrderFreqRowid,OrderPriorRowid,OrderInstrRowid,OrderDurRowid,OrderPackUOMRowid,OrderRecDepRowid,OrderUserDepRowid,OrderOrdDepRowid,OrderStatusRowid,OrderBaseUOMRowid,OrderDocRowid,OrderUserAddRowid,OrderARCOSRowid,OrderDrugFormRowid,OrderMaxDurRowid,OrderType,OrderBillTypeRowid,OrderBillType,OrderFreqFactor,OrderFreqInterval,OrderDurFactor,LinkOrderItem)=""
	Quit
}

ClassMethod FindAdmOrderItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAdmOrderItemsExecute ]
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

Query FindAdmOrderItems(EpisodeID As %String, GroupRowId As %String, PriorID As %String, CTLOCRowId As %String, DocNameID As %String, DrugFlag As %String, ItemStatStr As %String = "", IsIncludeCNMed As %String = "") As %Library.Query(CONTAINID = "", ROWSPEC = "OrderName:%String,OrderStatus:%String,OrderPrior:%String,OrderStartDate:%String,OrderStartTime:%String,OrderDoseQty:%String,OrderDoseUOM:%String,OrderFreq:%String,OrderInstr:%String,OrderDur:%String,OrderPrice:%String,OrderPackQty:%String,OrderPackUOM:%String,OrderSkinTest:%String,OrderRecDep:%String,OrderUserDep:%String,OrderOrdDep:%String,OrderSum:%String,OrderPrescNo:%String,OrderDepProcNote:%String,OrderDoc:%String,OrderUserAdd:%String,OrderDate:%String,OrderSeqNo:%String,OrderMasterSeqNo:%String,OrderLinkTo:%String,OrderLabEpisodeNo:%String,OrderItemRowid:%String,OrderARCIMRowid:%String,OrderDoseUOMRowid:%String,OrderFreqRowid:%String,OrderPriorRowid:%String,OrderInstrRowid:%String,OrderDurRowid:%String,OrderPackUOMRowid:%String,OrderRecDepRowid:%String,OrderUserDepRowid:%String,OrderOrdDepRowid:%String,OrderStatusRowid:%String,OrderBaseUOMRowid:%String,OrderDocRowid:%String,OrderUserAddRowid:%String,OrderARCOSRowid:%String,OrderDrugFormRowid:%String,OrderMaxDurRowid:%String,OrderType:%String,OrderBillTypeRowid:%String,OrderBillType:%String,OrderFreqFactor:%String,OrderFreqInterval:%String,OrderDurFactor:%String,LinkOrderItem:%String,EpisodeID:%String,OrderBillTypeRowId:%String,OrderItemInValid:%String,TypeClass:%String")
{
}

/// 入参：就诊号,用户id
/// 根据就诊号返回病人费用信息
/// w ##class(web.UDHCJFInterface).getpatFeeInfo(167580,1)
ClassMethod getpatFeeInfo(PAADMRowid, UserId)
{
	
	q:PAADMRowid="" ""
	q:UserId="" ""
	s Rtn=##class(web.UDHCJFBILL).BILL(PAADMRowid,UserId)
	s TotalAmount=0,PayedAmount=0,NotPayedAmount=0
	s PBRowId=0
	f  s PBRowId=$o(^DHCPB(0,"ADM",PAADMRowid,PBRowId)) q:PBRowId=""  d
	.s Amount=+$p($g(^DHCPB(PBRowId)),"^",8)
	.s TotalAmount=TotalAmount+Amount
	.s PBPaydeFlag=$p($g(^DHCPB(PBRowId)),"^",16)
	.i PBPaydeFlag="P" d 
	..s PayedAmount=PayedAmount+Amount 
	s NotPayedAmount=TotalAmount-PayedAmount
	q TotalAmount_"^"_PayedAmount_"^"_NotPayedAmount
}

}
