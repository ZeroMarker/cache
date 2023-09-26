/// 名称:    web.DHCFOrdGet
/// 描述:    医嘱录入的控制类
/// 编写者:  郭荣勇
/// 编写日期: 2009.02.20
/// 适用医院: 珠海人民医院
Class web.DHCFOrdGetEPR Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
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
ClassMethod GetOrdByAdmExecute(ByRef qHandle As %Binary, EpisodeID As %String = "", SearchStartDate As %String = "", SearchEndDate As %String = "", CategoryID As %String = "", SubsortID As %String = "", LongOrd As %String = "", ShortOrd As %String = "", OrdStat As %String = "", ordPriority As %String = "") As %Status
{
	//s ^RP("GetOrdByAdm")=EpisodeID_"^"_SearchStartDate_"^"_SearchEndDate_"^"_CategoryID_"^"_SubsortID_"^"_LongOrd_"^"_ShortOrd
	///d ##class(%ResultSet).RunQuery("web.DHCFOrdGet","GetOrdByAdm","201764","61325","61325","","")
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if (SearchStartDate'="")&&(SearchEndDate'="")&&((SearchEndDate-SearchStartDate)>365) Quit
	
	s RetNum=..GetOrdItem(repid,EpisodeID,SearchStartDate,SearchEndDate,CategoryID,SubsortID,"",LongOrd,ShortOrd,OrdStat,ordPriority)
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
 ...s ^CacheTempFHQ(repid,RetNum)=ordid_del_""_del_patname_del_patno_del_StDate_del_orddesc_del_ordstatus_del_ordqty_del_ordunit_del_admloc_del_doctor_del_OrdLoc_del_bed
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

// 判断是否是中草药医嘱

ClassMethod ZCYCheckByArcimId(ArcimId As %String) As %String
{
	
	q:$g(ArcimId)="" "0"
	s del="^"	
	s ArcimId1=$p(ArcimId,"||",1),ArcimId2=$p(ArcimId,"||",2)	
	q:'$d(^ARCIM(ArcimId1,ArcimId2))
	s subcat=$p(^ARCIM(ArcimId1,ArcimId2,1),del,10)
	s Code=$p(^ARC("IC",subcat),del,1) //药品代码
    s OrderType=$p(^ARC("IC",subcat),del,2) //药品类型
    s OrderTypeDr=$p(^ARC("IC",subcat),del,8) //药品类型DR
	if (OrderType="中草药类")
	{b  q "1"}
	else
	{q "0"}
}

ClassMethod GetOrdItem(repid As %Integer = 0, AdmId As %String = "", SearchStartDate As %String = "", SearchEndDate As %String = "", CategoryID As %String = "", SubsortID As %String = "", ArcId As %String = "", LongOrd As %String = "", ShortOrd As %String = "", OrdStat As %String = "", ordPriority As %String = "") As %Integer
{
	//Add By 20130423	
	i ordPriority="S" s ordPriority="S^OMST"
	i ordPriority="N" s ordPriority="NORM^OM"
	i ordPriority="O" s ordPriority="OUT"
	i ordPriority="Z" s ordPriority="ZCY"
	
	s ^RP("benCiItm")=LongOrd_"^"_ShortOrd
	s del="^",AdmType="",RetNum=0
	q:($g(AdmId)="") RetNum
	q:'$d(^OEORD(0,"Adm",AdmId)) RetNum	
	s OrdId1=$o(^OEORD(0,"Adm",AdmId,0))
	s PatientID=$P(^PAADM(AdmId),"^",1)
	q:OrdId1=""
	
	//Add By 20130423	
	s TempPAQUE1 = ""
	
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
	.s OEORIQty=$p(ordstr1,"^",18)
	.s OEORIPhQty=$p(ordstr1,"^",12)	
		
	.//Add By 20130423
	.s PriorityDR=$p(ordstr1,del,8)
	.s:$g(PriorityDR)="" Priority="",PriorityCode=""
	.s:$g(PriorityDR)'="" Priority=$p(^OECPR(PriorityDR),del,2),PriorityCode=$p(^OECPR(PriorityDR),del,1)	
	.Q:(ordPriority'="")&&(("^"_ordPriority_"^")'[("^"_PriorityCode_"^"))&&(ordPriority'="ZCY")
	
	.//中草药处理	
	.s PrescNo=$p(ordstr1,del,14)  //处方号
	.s ArcimId=$p(ordstr1,del,2)
	.q:((ArcId'="")&(ArcimId'=ArcId))
  .s ZCYCheckNum=..ZCYCheckByArcimId(ArcimId)
  .//临时医嘱里面过滤中草药
  .q:(ordPriority["NORM")&&(ZCYCheckNum="1")
	.i (ZCYCheckNum="1")&&(PriorityCode["NORM")&&(ordPriority="ZCY") d  q
	..i (TempPAQUE1 '[ PrescNo) d
	...s TempPAQUE1=TempPAQUE1_"^"_PrescNo	
	...s OrdMainId=OrdId1
	...s tmpVal = PrescNo,ZCYOrdId2=0,ZCYArcimDesc="",ZCYPackQty=""	,ZCYOrderQty="",ZCYOrderUOM="",ZCYPHCFRDesc="",ZCYPHDurationDesc="",num=0
	...f  s ZCYOrdId2=$o(^OEORD(0,"PrescNo",tmpVal,OrdMainId,ZCYOrdId2)) q:ZCYOrdId2=""  d
	....s ZCYordstr1=$g(^OEORD(OrdMainId,"I",ZCYOrdId2,1))
	....s ZCYordstr2=$g(^OEORD(OrdMainId,"I",ZCYOrdId2,2))
	....s ZCYArcimId=$p(ZCYordstr1,del,2)
	....s ZCYArcStr=##class(web.DHCFBArcimGet).GetArcimById(ZCYArcimId)	 	
	....q:ZCYArcStr=""
	....s OrdStatusDR=$p(ordstr1,del,13)	
	....s:$g(OrdStatusDR)'="" OrdStatus=$p(^OEC("OSTAT",OrdStatusDR),del,2),OrdStatusCode=$p(^OEC("OSTAT",OrdStatusDR),del,1)
	....s:$g(OrdStatusDR)="" OrdStatus=$g(OrdStatusDR),OrdStatusCode=""
	....Q:(OrdStat'="")&&(OrdStatusCode=OrdStat)    ;东方医院不显示停止的医嘱
	....s TempZCYArcimDesc=$p(ZCYArcStr,del,3)
	....i TempZCYArcimDesc["[" s TempZCYArcimDesc=$p(TempZCYArcimDesc,"[",1)
	....s length = $length(TempZCYArcimDesc)	
	....s ZCYArcimDesc=ZCYArcimDesc_TempZCYArcimDesc
	....s ZCYOEORIQty=$p(ZCYordstr1,"^",18)	     
    ....s ZCYDoseQty=$p(ZCYordstr2,del,1),ZCYDoseUnit=$p(ZCYordstr2,del,3)
	....s:ZCYDoseUnit'="" ZCYDoseUnit=$p(^CT("UOM",ZCYDoseUnit),del,2)
	....s ZCYArcimDesc=ZCYArcimDesc_" "_ZCYDoseQty_"("_ZCYDoseUnit_")"_" "	
	....s num=num+1
	....s Restvalue=num/4
	....i (Restvalue'[".") && (Restvalue>0) s ZCYArcimDesc=ZCYArcimDesc_$c(13)   
	...s Queid=""
	...s Queid=$o(^PAQUE1(0,"PrescNo",tmpVal,Queid))	
	...s ZCYPAQUE1Value=^PAQUE1(Queid,"DHC")	
	...s ZCYPHFreq=$p(ZCYPAQUE1Value,del,9)	
	...s ZCYPHCFRDesc=$p(^PHCFR(ZCYPHFreq),del,3)
	...s ZCYPHDurationDR=$p(ZCYPAQUE1Value,del,10)
	...s ZCYPHDurationDesc=$p(^PHCDU(ZCYPHDurationDR),del,2)
	...s ZCYOrderQty=$p(ZCYPAQUE1Value,del,13)
	...s ZCYOrderUOM=$p(ZCYPAQUE1Value,del,14)	
  ...s OrdCreateDate=$p(ordstr3,del,7),OrdCreateDate=$zd(OrdCreateDate,3)
	...s OrdCreateTime=$p(ordstr1,del,17),OrdCreateTime=..%ZT(OrdCreateTime,2)
	...s OrdStartDate=$p(ordstr1,del,9),OrdStartDate=$zd(OrdStartDate,3)
	...s OrdStartTime=$p(ordstr1,del,10),OrdStartTime=..%ZT(OrdStartTime,2)	
	...s DoseQty=ZCYOrderQty
	...s DoseUnit=ZCYOrderUOM
	...s TempordPriority="ZCY"
	...s Instr=$p(ZCYordstr2,del,7)
	...s:$g(Instr)'="" Instr=$p(^PHCIN(Instr),del,2)
	...s:$g(Instr)="" Instr=""	
	...i $e(ZCYArcimDesc,$l(ZCYArcimDesc),$l(ZCYArcimDesc))=$c(13) s ZCYArcimDesc=ZCYArcimDesc_"共"_ZCYPHDurationDesc_"副,每副"_ZCYOrderQty_ZCYOrderUOM_","_ZCYPHCFRDesc
	...e  s ZCYArcimDesc=ZCYArcimDesc_$c(13)_"共"_ZCYPHDurationDesc_"副,每副"_ZCYOrderQty_ZCYOrderUOM_","_ZCYPHCFRDesc
	...s ArcimDesc=ZCYArcimDesc	
	...s PHFreq=$p(^PHCFR(ZCYPHFreq),del,1)
	...S RetNum=RetNum+1	
	...S ^CacheTempFHQ(repid,RetNum)=$LB(OrdCreateDate,OrdCreateTime,OrdStartDate,OrdStartTime,ArcimDesc,DoseQty,DoseUnit,Priority,PHFreq,Instr,doctor,OrdStatus,Dura,OEItemID,PatientID,OrderSeqNo,QtyPackUOM,PackUOMDesc,PrescNo,dstatus,LabEpisodeNo,OrdLabSpec,OrdXDate,OrdXTime,OrdSkinTest,OrdAction,OrdDepProcNotes,OrdBilled,OrdSkinTestResult,OEORIQty,OEORIPhQty)
	.q:(ordPriority="ZCY")
	
	

	
	.s ArcimId=$p(ordstr1,del,2)
	.q:((ArcId'="")&(ArcimId'=ArcId))
	.s ArcStr=##class(web.DHCFBArcimGet).GetArcimById(ArcimId)
	.q:ArcStr=""
	.s ArcimCode=$p(ArcStr,del,2),ArcimDesc=$p(ArcStr,del,3)
	.s OrdCreateDate=$p(ordstr3,del,7),OrdCreateDate=$zd(OrdCreateDate,3)
	.s OrdCreateTime=$p(ordstr1,del,17),OrdCreateTime=..%ZT(OrdCreateTime,2)
	.s OrdStartDate=$p(ordstr1,del,9),OrdStartDate=$zd(OrdStartDate,3)
	.s OrdStartTime=$p(ordstr1,del,10),OrdStartTime=..%ZT(OrdStartTime,2)
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
	.Q:(LongOrd="on")&&(ShortOrd'="on")&&(PriorityCode'="S")
	.Q:(ShortOrd="on")&&(LongOrd'="on")&&(PriorityCode'="NORM")
	.Q:(OrdStat="on")&&(LongOrd'="on")&&(ShortOrd'="on")&&(PriorityCode'="OUT")
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
	.s BillingUOMDR=##Class(web.DHCDocOrderCommon).GetOrdPackUOMDR(OEItemID)
	.s PackUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(BillingUOMDR)
	.s HaveDispensing=0,dstatus=""
	.s dis=0  f  s dis=$O(^DHCOEDISQTY(0,"OEORI",OEItemID,dis)) Q:dis=""  d
	..s dstatus=$p(^DHCOEDISQTY(dis),"^",7)
	..s HaveDispensing=1
	.i HaveDispensing=1 d
	..i dstatus="C" s dstatus="已发"
	..i dstatus="TC" s dstatus="未发"
	..i dstatus=""  s dstatus="未打包"
	.;条码号,标本
	.s LabEpisodeNo=$p(ordstr3,del,20) ;
	.s OrdLabSpec=##Class(web.DHCOEOrdItem).GetLabSpec(OEItemID)
	.;停医嘱日期,停医嘱时间
	.s OrdXDate=$p(ordstr3,del,34)
	.if OrdXDate'="" s OrdXDate=$zd(OrdXDate,3)
	.s OrdXTime=$p(ordstr2,del,15)
	.if OrdXTime'="" s OrdXTime=..%ZT(OrdXTime,2)
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
	.S ^CacheTempFHQ(repid,RetNum)=$LB(OrdCreateDate,OrdCreateTime,OrdStartDate,OrdStartTime,ArcimDesc,DoseQty,DoseUnit,Priority,PHFreq,Instr,doctor,OrdStatus,Dura,OEItemID,PatientID,OrderSeqNo,QtyPackUOM,PackUOMDesc,PrescNo,dstatus,LabEpisodeNo,OrdLabSpec,OrdXDate,OrdXTime,OrdSkinTest,OrdAction,OrdDepProcNotes,OrdBilled,OrdSkinTestResult,OEORIQty,OEORIPhQty)
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

Query GetOrdByAdm(EpisodeID As %String = "", SearchStartDate As %String = "", SearchEndDate As %String = "", CategoryID As %String = "", SubsortID As %String = "", LongOrd As %String = "", ShortOrd As %String = "", OrdStat As %String = "") As %Query(ROWSPEC = "OrdCreateDate:%String,OrdCreateTime:%String,OrdStartDate:%String,OrdStartTime:%String,ArcimDesc:%String,DoseQty:%String,DoseUnit:%String,Priority:%String,PHFreq:%String,Instr:%String,Doctor:%String,OrdStatus:%String,Dura,OEItemID:%String,PatientID:%String,SeqNo:%String,QtyPackUOM:%String,PackUOMDesc:%String,PrescNo:%String,dstatus:%String,LabEpisodeNo:%String,OrdLabSpec:%String,OrdXDate:%String,OrdXTime:%String,OrdSkinTest:%String,OrdAction:%String,OrdDepProcNotes:%String,OrdBilled:%String,OrdSkinTestResult:%String,OEORIQty:%String,OEORIPhQty:%String")
{
}

Query GetSubsort(CategoryID As %String, OrdSubsort As %String) As %Query(ROWSPEC = "OrdSubDesc:%String,OrdSubCode:%String,OrdSubID:%String")
{
}

}
