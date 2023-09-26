Class DHCWL.InterManagement.DHCWLCommon.CommonMethod Extends %RegisteredObject
{

/// Creator：       PL
/// CreatDate：     2018-10-23
/// Description:：  
/// Table：         DHC_WorkLoad
/// Input：         Adm_Id 卡类型
/// Output：        
/// Return：        卡号^种类
/// Others：        w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetPatTotal("1","条形码")
ClassMethod CardNoAndType(papmi As %String, typeDesc As %String) As %String
{
  s cardid="" f  s cardid=$o(^DHCCARDi("CF",0,"PAPMIDR",papmi,cardid)) q:cardid=""  d
  .s cardno=$p(^DHCCARD("CF",cardid),"^",2)
  .s cardtypedr=$p(^DHCCARD("CF",cardid),"^",16)
  .s cardtype=$p(^DHCCARDTYPEDef(cardtypedr),"^",2)
  .q:cardtype'=typeDesc
  q $g(cardno)_"^"_$g(cardtype)
}

/// Creator：       PL
/// CreatDate：     2018-10-23
/// Description:：  
/// Table：         DHC_WorkLoad
/// Input：         startDate开始日期、endDate结束日期、inId索引标志（1-结算、2-下医嘱计费）、patType病人类型（O、E、I、H、""不区分返回总费用）
/// Output：        对应索引的病人类型日期段内总费用
/// Return：        总费用
/// Others：        w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetPatTotal("2015-03-10","2015-03-20","1","")
ClassMethod GetPatTotal(startDate As %String, endDate As %String, inId As %String, patType As %String) As %String
{
    i inId=1 d
    .s index="FlagDate"	
	e  d
	.s index="ORDDATE"
	s stDate=$zdh(startDate,3)
	s enDate=$zdh(endDate,3)	
	f date=stDate:1:enDate d 
	.s WLRowid=0 f  s WLRowid=$o(^DHCWorkLoad(0,index,date,WLRowid)) q:WLRowid=""  d
    ..s wlTotal=$p(^DHCWorkLoad(WLRowid),"^",16)
    ..i patType'="" q:$p(^DHCWorkLoad(WLRowid),"^",4)'=patType
    ..s patIncome=$g(patIncome)+wlTotal
    q $g(patIncome)
}

/// Creator：       PL
/// CreatDate：     2019-12-12
/// Description:：  通过DHC_WorkLoad获取病人的全部费用和药品费用
/// Table：         DHC_WorkLoad
/// Input：         PA_ADM 表ID
/// Output：        对应的病人总费用
/// Return：        总费用^药品费用
/// Others：        DHC_WorkLoad每天导入昨天的数据所以不存在日期$h的数据。 
/// w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetPatCost(7)
ClassMethod GetPatCost(admId As %String) As %String
{
	s patIncome=0,patDrug=0
	s wLRowid=0 f  s wLRowid=$o(^DHCWorkLoad(0,"PAADM",admId,wLRowid)) q:wLRowid=""  d
    .s TarCate=$p(^DHCWorkLoad(wLRowid),"^",9)    ;医嘱子分类
    .s wlTotal=$p(^DHCWorkLoad(wLRowid),"^",16)
    .i $d(^ARC("IC",0,"OrderType","R",TarCate)) d
    ..s patDrug=$g(patDrug)+wlTotal
    .s patIncome=$g(patIncome)+wlTotal
    q $g(patIncome)_"^"_$g(patDrug)
}

/// Creator：       PL
/// CreatDate：     2018-08-03
/// Description:：  通过DHCWorkLoad获取统计组分类的费用
/// Table：         
/// Input：         
/// Output：        
/// Return：        ^TMPDHCWL($j,"COST",统计组维护分类)、^TMPDHCWL($j,"TOT",adm)总费用、^TMPDHCWL($j,"REASON",adm,医保)
/// d ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GrpWlCost("2015-03-10","2015-03-20","ORDDATE","TIC","住院分类","I")
ClassMethod GrpWlCost(startDate, endDate, Index, WLStatType, vbGrpName, type) As %String
{
 k ^TMPDHCWL($j)
 s mStr=##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetStatPiece(WLStatType)
 s grpType=$p(mStr,"^",2)
 d ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetAllItem(vbGrpName,grpType)
 s stDate=$zdh(startDate,3)
 s enDate=$zdh(endDate,3)
 f date=stDate:1:enDate d 
 .s WLRowid=0 f  s WLRowid=$o(^DHCWorkLoad(0,Index,date,WLRowid)) q:WLRowid=""  d
 ..s mPiece=$p(mStr,"^",1)
 ..s wltype=$p(^DHCWorkLoad(WLRowid),"^",4)
 ..q:+$f(","_type_",",wltype)=0
 ..s mItem=$p(^DHCWorkLoad(WLRowid),"^",mPiece)
 ..q:mItem=""
 ..s wlTotal=$p(^DHCWorkLoad(WLRowid),"^",16)
 ..s adm=$p(^DHCWorkLoad(WLRowid),"^",12)
 ..s mNameDesc=$g(^TMPDHCWL($j,"childSub",mItem))
 ..q:mNameDesc=""
 ..s arpbl=$p(^DHCWorkLoad(WLRowid),"^",20)
 ..s reason=$p($g(^DHCPB(arpbl)),"^",4)
 ..i reason="" s reason="999999"
 ..s ^TMPDHCWL($j,"REASON",adm,reason)=$g(^TMPDHCWL($j,"REASON",adm,reason))+wlTotal
 ..s ^TMPDHCWL($j,"TOT",adm)=$g(^TMPDHCWL($j,"TOT",adm))+wlTotal
 ..s ^TMPDHCWL($j,"COST",adm,mNameDesc)=$g(^TMPDHCWL($j,"COST",adm,mNameDesc))+wlTotal
 q 1
}

ClassMethod GetAllItem(vbGrpName, grpType) As %String
{
  d ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).ListName()
  s mId=$g(^||TMPDHCWL($j,"GrpName",vbGrpName))
  s dhcwlitemid="" f  s dhcwlitemid=$o(^DHCWLSTAT(mId,"ITEM",dhcwlitemid)) q:dhcwlitemid=""  d
  .s childSub="" f  s childSub=$o(^DHCWLSTAT(mId,"ITEM",dhcwlitemid,"DETAIL",0,grpType,childSub))  q:childSub=""  d
  ..s itemDesc=$p(^DHCWLSTAT(mId,"ITEM",dhcwlitemid),"^",2)
  ..s ^TMPDHCWL($j,"childSub",childSub)=itemDesc
  q 1
}

ClassMethod ListName() As %String
{
 s mGrpId=0 f  s mGrpId=$o(^DHCWLSTAT(mGrpId)) q:mGrpId=""  d
 .s mGrpName=$p(^DHCWLSTAT(mGrpId),"^",2)
 .s ^TMPDHCWL($j,"GrpName",mGrpName)=mGrpId
 q 1
}

ClassMethod GetStatPiece(WLStatType) As %String
{
 i WLStatType="IC" d
 .s StatPiece=9,GrpPiece="ARCIC"
 i WLStatType="IM" d
 .s StatPiece=2,GrpPiece="ARCIM"
 i WLStatType="BG" d
 .s StatPiece=10,GrpPiece="ARCBG"
 i WLStatType="BS" d
 .s StatPiece=11,GrpPiece="ARCBS"
 i WLStatType="TM" d
 .s StatPiece=22,GrpPiece="TARIM"
 i WLStatType="TMC" d
 .s StatPiece=43,GrpPiece="TarMC"
 i WLStatType="TEC" d
 .s StatPiece=41,GrpPiece="TarEC"
 i WLStatType="TIC" d
 .s StatPiece=42,GrpPiece="TarIC"
 i WLStatType="TOC" d
 .s StatPiece=44,GrpPiece="TarOC"
 i WLStatType="TAC" d
 .s StatPiece=40,GrpPiece="TarAC"
 q StatPiece_"^"_GrpPiece
}

/// Creator：       PL
/// CreatDate：     2018-05-10
/// Description:：  通过PA_ADM ADM_ROWID获得身份证号码获取身份证所在地
/// Table：         CT_City、CT_Province、CT_CityArea
/// Input：         
/// Output：        
/// Return：        省^市^县
/// Others：        w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetAdd(admId)
ClassMethod GetAdd(admId As %String) As %String
{
 q:$g(admId)="" "Null"
 s iPatNo=$p(^PAADM(admId),"^",1)	
 q:$g(iPatNo)="" Null
 q:'$d(^PAPER(iPatNo,"ALL")) "Null"
 s tPatId=$p(^PAPER(iPatNo,"ALL"),"^",9)
 q:$g(tPatId)="" "Null"
 s provCode=$e(tPatId,1,2)_"0000"
 s provId=""    s provId=$o(^CT("PROV",0,"Code",provCode,""))
 s cityCode=$e(tPatId,1,6)
 s cityId=""    s cityId=$o(^CT("CIT",0,"Code",cityCode,""))
 i cityId=""  s cityCode=$e(tPatId,1,4)_"00",cityId=$o(^CT("CIT",0,"Code",cityCode,""))
 q:cityId="" "Null1" 
 s cityAreaId=""    s cityAreaId=$o(^CT("CITAREA",0,"Code",$e(tPatId,1,6),""))
 q:(provId="")||(cityId="")||(cityAreaId="") "Null"
 s provDesc=$p(^CT("PROV",provId),"^",2)
 s cityDesc=$p(^CT("CIT",cityId),"^",2)
 s cityAreaId=$p(^CT("CITAREA",cityAreaId),"^",2)
 s addStr=provDesc_"^"_cityDesc_"^"_cityAreaId
 q $g(addStr)
}

/// Creator：       PL
/// CreatDate：     2018-05-10
/// Description:：  通过日期、科室/病区的到维护的床位信息
/// Table：         PA_PATMAS PA_ADM
/// Input：         日期、科室\病区（Ward/Loc）、科室病区ID
/// Output：        固定床^实有床^备注床位
/// Return：        
/// Others：         w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).BedNum("63572","Loc","6")
ClassMethod BedNum(Date As %String, LocOrWardFlag As %String, LocOrWardId As %String) As %String
{
 s MRRowId=""
 s Return=0_"^"_0_"^"_0
 i $d(^DHCMRBed(0,"Date",Date,LocOrWardFlag,LocOrWardId))  d
 .s MRRowId=$o(^DHCMRBed(0,"Date",Date,LocOrWardFlag,LocOrWardId,"")) ;Only One
 e  d
 .s Date=$o(^DHCMRBed(0,LocOrWardFlag,LocOrWardId,"Date",Date),-1)
 .i Date'="" s MRRowId=$o(^DHCMRBed(0,"Date",Date,LocOrWardFlag,LocOrWardId,"")) ;Only One Or No Exist
 q:MRRowId="" Return
 s MRGDNum=$p(^DHCMRBed(MRRowId),"^",3)
 s MRSYNum=$p(^DHCMRBed(MRRowId),"^",4)
 s MRBZNum=$p(^DHCMRBed(MRRowId),"^",5)
 s Return=MRGDNum_"^"_MRSYNum_"^"_MRBZNum
 q Return
}

/// Creator：       PL
/// CreatDate：     2018-05-10
/// Description:：  通过PA_ADM ADM_ROWID得到同入院类型是否有多次
/// Table：         PA_PATMAS PA_ADM
/// Input：         ADM_ROWID
/// Output：        0一次、1多次
/// Return：        
/// Others：         w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetReHosp("1","O")
ClassMethod GetReHosp(admId As %String, Type As %String) As %String
{
 q:$g(admId)="" "Null"
 s iPatNo=$p(^PAADM(admId),"^",1)
 q:'$d(^PAPER(iPatNo)) "Null"
 s num=0,mflag=0
 s adm="" f  s adm=$o(^PAPERdr(iPatNo,"ADM",Type,adm)) q:adm=""  d
 .s num=$g(num)+1
 i num>1 s mflag=1
 q $g(mflag)
}

/// Creator：       PL
/// CreatDate：     2018-05-10
/// Description:：  通过PA_ADM ADM_ROWID得到病人登记号
/// Table：         PA_PATMAS PA_ADM
/// Input：         ADM_ROWID
/// Output：        病人登记号
/// Return：        
/// Others：         w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetPapmiNo("1")
ClassMethod GetPapmiNo(admId As %String) As %String
{
 q:$g(admId)="" "Null"
 s iPatNo=$p(^PAADM(admId),"^",1)
 q:'$d(^PAPER(iPatNo)) "Null"
 s tIPNo=$P($G(^PAPER(iPatNo,"PAT",1)),"^",1)
 s tOPNo=$P($G(^PAPER(iPatNo,"PAT",1)),"^",2)
 s oPapmiNo=$$CO2^at84(tIPNo,tOPNo)
 q $g(oPapmiNo)
}

/// Creator：       PL
/// CreatDate：     2018-05-10
/// Description:：  通过PA_ADM ADM_ROWID得到病人姓名
/// Table：         PA_PATMAS PA_ADM
/// Input：         ADM_ROWID
/// Output：        病人姓名
/// Return：        
/// Others：         w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetPapmiName("1")
ClassMethod GetPapmiName(admId As %String) As %String
{
 q:$g(admId)="" "Null"
 s iPatNo=$p(^PAADM(admId),"^",1)	
 q:$g(iPatNo)="" "Null"
 q:'$d(^PAPER(iPatNo)) "Null"
 s oPatName=$P($G(^PAPER(iPatNo,"ALL")),"^")
 q $g(oPatName)
}

/// Creator：       PL
/// CreatDate：     2018-05-10
/// Description:：  通过PA_ADM ADM_ROWID得到病人住院号(病案号)
/// Table：         PA_PATMAS PA_ADM
/// Input：         ADM_ROWID
/// Output：        住院号(病案号)
/// Return：        
/// Others：         w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetPapmiMedtare("1")
ClassMethod GetPapmiMedtare(admId As %String) As %String
{
 q:$g(admId)="" "Null"
 s iPatNo=$p(^PAADM(admId),"^",1)	
 q:$g(iPatNo)="" "Null"
 q:'$d(^PAPER(iPatNo,"PAT",1)) "Null"
 s oMdtrNo=$p($g(^PAPER(iPatNo,"PAT",1)),"^",22)
 q:oMdtrNo="" "Null"
 q $g(oMdtrNo)
}

/// Creator：       PL
/// CreatDate：     2018-05-10
/// Description:：  通过PA_ADM ADM_ROWID得到病人年龄
/// Table：         PA_PATMAS PA_ADM
/// Input：         ADM_ROWID
/// Output：        年龄
/// Return：        
/// Others：         w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetAge("1")
ClassMethod GetAge(admId As %String) As %String
{
 q:$g(admId)="" "Null"
 s iPatNo=$p(^PAADM(admId),"^",1)	
 q:$g(iPatNo)="" "Null"
 q:'$d(^PAPER(iPatNo,"ALL")) "Null"
 s dob=$p(^PAPER(iPatNo,"ALL"),"^",6)  ;生日
 s EstAgeMonth=$p(^PAPER(iPatNo,"ALL"),"^",16)
 s EstAgeyear=$p(^PAPER(iPatNo,"ALL"),"^",15)
 s Est=$p(^PAPER(iPatNo,"ALL"),"^",17)
 s age=$$CalAge^at182(dob,+$h,EstAgeMonth*$g(I),EstAgeyear*$g(I),Est*$g(I))
 s Ageyr=$p(age,"|",12)  ;年龄
 q $g(Ageyr)
}

/// Creator：       PL
/// CreatDate：     2018-05-10
/// Description:：  通过PA_ADM ADM_ROWID得到病人性别
/// Table：         PA_PATMAS PA_ADM
/// Input：         ADM_ROWID
/// Output：        性别
/// Return：        
/// Others：         w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetSex("1")
ClassMethod GetSex(admId As %String) As %String
{
 q:$g(admId)="" "Null"
 s iPatNo=$p(^PAADM(admId),"^",1)	
 q:$g(iPatNo)="" "Null"
 q:'$d(^PAPER(iPatNo,"ALL")) "Null"
 s sexid=$p(^PAPER(iPatNo,"ALL"),"^",7)
 q:sexid="" ""
 q:'$d(^CT("SEX",sexid)) ""
 s sexdesc=$p(^CT("SEX",sexid),"^",2)
 q $g(sexdesc)
}

/// Creator：       PL
/// CreatDate：     2018-05-10
/// Description:：  通过PA_ADM ADM_ROWID得到出生国籍
/// Table：         PA_PATMAS PA_ADM
/// Input：         ADM_ROWID
/// Output：        国籍
/// Return：        
/// Others：         w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetCouOfBir("1")
ClassMethod GetCouOfBir(admId As %String) As %String
{
 q:$g(admId)="" "Null"
 s iPatNo=$p(^PAADM(admId),"^",1)	
 q:$g(iPatNo)="" "Null"
 q:'$d(^PAPER(iPatNo,"ALL")) "Null"
 s conId=$p(^PAPER(iPatNo,"ALL"),"^",11)
 s conDesc=$p(^CT("COU",conId),"^",2) 
 q $g(conDesc)
}

/// Creator：       PL
/// CreatDate：     2018-05-10
/// Description:：  通过PA_ADM ADM_ROWID得到出生民族
/// Table：         PA_PATMAS PA_ADM
/// Input：         ADM_ROWID
/// Output：        民族
/// Return：        
/// Others：         w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetVolkDesc("1")
ClassMethod GetVolkDesc(admId As %String) As %String
{
 q:$g(admId)="" "Null"
 s iPatNo=$p(^PAADM(admId),"^",1)	
 q:$g(iPatNo)="" "Null"
 q:'$d(^PAPER(iPatNo,"PER",2)) "Null"
 s volk=$p(^PAPER(iPatNo,"PER",2),"^",1)
 s volkDesc=$p( ^CT("NAT",volk),"^",2) 
 q $g(volkDesc)
}

/// Creator：       PL
/// CreatDate：     2018-05-10
/// Description:：  通过PA_ADM ADM_ROWID得到病人工作单位
/// Table：         PA_PATMAS PA_ADM
/// Input：         ADM_ROWID
/// Output：        工作单位
/// Return：        
/// Others：         w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetWork("1")
ClassMethod GetWork(admId As %String) As %String
{
 q:$g(admId)="" "Null"
 s iPatNo=$p(^PAADM(admId),"^",1)	
 q:$g(iPatNo)="" Null
 q:'$d(^PAPER(iPatNo,"PER")) "Null" 
 s Work=$p(^PAPER(iPatNo,"PER",4),"^",18)   ;病人单位
 q $g(Work)
}

/// Creator：       PL
/// CreatDate：     2018-07-02
/// Description:：  通过PA_ADM ADM_ROWID得到病人省地址
/// Table：         PA_PATMAS PA_ADM
/// Input：         ADM_ROWID
/// Output：        省地址
/// Return：        
/// Others：         w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetProvince("1")
ClassMethod GetProvince(admId As %String) As %String
{
 q:$g(admId)="" "Null"
 s iPatNo=$p(^PAADM(admId),"^",1)	
 q:$g(iPatNo)="" Null
 q:'$d(^PAPER(iPatNo,"PER")) "Null" 
 s provinceId=$p(^PAPER(iPatNo,"PER",4),"^",2)   ;病人地址
 q:$g(provinceId)="" "Null"
 s provinceDesc=$p(^CT("PROV",provinceId),"^",2)
 q $g(provinceDesc)
}

/// Creator：       PL
/// CreatDate：     2018-07-02
/// Description:：  通过PA_ADM ADM_ROWID得到病人市地址
/// Table：         PA_PATMAS PA_ADM
/// Input：         ADM_ROWID
/// Output：        市地址
/// Return：        
/// Others：         w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetCity("1")
ClassMethod GetCity(admId As %String) As %String
{
 q:$g(admId)="" "Null"
 s iPatNo=$p(^PAADM(admId),"^",1)	
 q:$g(iPatNo)="" Null
 q:'$d(^PAPER(iPatNo,"PER")) "Null" 
 s cityId=$p(^PAPER(iPatNo,"PER",1),"^",5)   ;病人地址
 q:$g(cityId)="" "Null"
 s cityDesc=$p(^CT("CIT",cityId),"^",2)
 q $g(cityDesc)
}

ClassMethod GetAreaAddressDesc(iCITAREARowId As %String) As %String
{
 q:$g(iCITAREARowId)="" "Null"
 q:'$d(^CT("CITAREA",iCITAREARowId)) "Null"
 s tCITAREADesc=$p(^CT("CITAREA",iCITAREARowId),"^",2)
 i tCITAREADesc [ "-" s oCITAREADesc=$p(tCITAREADesc,"-",2)
 q $g(oCITAREADesc)
}

/// Creator：       PL
/// CreatDate：     2018-05-10
/// Description:：  通过PA_ADM ADM_ROWID得到病人区域地址
/// Table：         PA_PATMAS PA_ADM
/// Input：         ADM_ROWID
/// Output：        区域地址
/// Return：        
/// Others：         w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetAreaAddress("1")
ClassMethod GetAreaAddress(admId As %String) As %String
{
 q:$g(admId)="" "Null"
 s iPatNo=$p(^PAADM(admId),"^",1)	
 q:$g(iPatNo)="" Null
 q:'$d(^PAPER(iPatNo,"PER")) "Null" 
 s CityArea=$p(^PAPER(iPatNo,"PER",4),"^",9)   ;病人地址
 s CityAreaDesc=##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetAreaAddressDesc(CityArea)
 q $g(CityAreaDesc)
}

/// Creator：       PL
/// CreatDate：     2018-05-10
/// Description:：  通过PA_ADM ADM_ROWID得到病人详细地址
/// Table：         PA_PATMAS PA_ADM
/// Input：         ADM_ROWID
/// Output：        详细地址
/// Return：        
/// Others：         w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetDetailAddress("66")
ClassMethod GetDetailAddress(admId As %String) As %String
{
 q:$g(admId)="" "Null"
 s iPatNo=$p(^PAADM(admId),"^",1)	
 q:$g(iPatNo)="" "Null"
 q:'$d(^PAPER(iPatNo,"PER","ADD")) "Null"
 s StName=$p(^PAPER(iPatNo,"PER","ADD",1),"^")   ;病人地址
 q $g(StName)
}

/// Creator：       PL
/// CreatDate：     2018-05-10
/// Description:：  通过PA_ADM ADM_ROWID得到病人人员类别
/// Table：         PAC_ADMREASON PA_ADM
/// Input：         ADM_ROWID
/// Output：        人员类别
/// Return：        
/// Others：         w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetReason("66")
ClassMethod GetReason(admId As %String) As %String
{
 q:$g(admId)="" "Null"
 s reasonid=$p($g(^PAADM(admId,1)),"^",7)  ;病人身份
 q:reasonid="" ""
 q:'$d(^PAC("ADMREA",reasonid)) ""
 s reasondesc=$p(^PAC("ADMREA",reasonid),"^",2)
 q $g(reasondesc)
}

/// Creator：       PL
/// CreatDate：     2018-05-10
/// Description:：  通过PA_ADM ADM_ROWID得到病人转归情况
/// Table：         PAC_ADMREASON PA_ADM
/// Input：         ADM_ROWID
/// Output：        转归情况
/// Return：        
/// Others：         w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).DischCondit("66")
ClassMethod DischCondit(admId As %String) As %String
{
 q:$g(admId)="" "Null"
 s disResult=$p(^MR(admId,"PRO",1),"^",10)
 q:disResult="" ""
 q:'$d(^PAC("DISCON",disResult)) ""
 s disResultdesc=$p(^PAC("DISCON",disResult),"^",2)
 q $g(disResultdesc)
}

/// Creator：       PL
/// CreatDate：     2018-05-10
/// Description:：  通过PA_ADM ADM_ROWID得到病人人员床位
/// Table：         PA_ADM
/// Input：         ADM_ROWID
/// Output：        人员床位
/// Return：        
/// Others：         w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetBed("66")
ClassMethod GetBed(admId As %String) As %String
{
 q:$g(admId)="" "Null"
 s Bedid=$p(^PAADM(admId),"^",73)  ;床位ID
 q:Bedid="" "Null"
 s WardRowID=$p(Bedid,"||",1)
 s BEDChildsub=$p(Bedid,"||",2) 
 q:'$d(^PAWARD(WardRowID,"BED",BEDChildsub)) "Null"
 s BedCode=$p(^PAWARD(WardRowID,"BED",BEDChildsub),"^",1)  ;床位
 q $g(BedCode)
}

/// Creator：       PL
/// CreatDate：     2018-05-10
/// Description:：  通过CT_Loc.CTLOC_RowID得到CTLOC的描述
/// Table：         CT_LOC
/// Input：         CTLOC_RowID
/// Output：        CTLOC的描述
/// Return：        
/// Others：         w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetDepDesc("66")
ClassMethod GetDepDesc(CTLocRowid As %String) As %String
{
 q:$g(CTLocRowid)="" "Null"
 i $d(^CTLOC(CTLocRowid)) s LocDesc1=$p(^CTLOC(CTLocRowid),"^",2)   
 e  s LocDesc1="Null"
 i LocDesc1 [ "-" s rLocDesc=$p(LocDesc1,"-",2)
 e  s rLocDesc=LocDesc1 
 q $g(rLocDesc)
}

/// Creator：       PL
/// CreatDate：     2018-05-10
/// Description:：  通过CT_Loc.CTLOC_RowID得到CTLOC科室编码
/// Table：         CT_LOC
/// Input：         CTLOC_RowID
/// Output：        CTLOC的描述
/// Return：        
/// Others：         w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetDepCode("66")
ClassMethod GetDepCode(CTLocRowid As %String) As %String
{
 q:$g(CTLocRowid)="" "Null"
 i $d(^CTLOC(CTLocRowid)) s LocDesc1=$p(^CTLOC(CTLocRowid),"^",2)    
 e  s LocDesc1="Null"
 i LocDesc1 [ "-" s rLocDesc=$p(LocDesc1,"-",1)
 e  s rLocDesc=LocDesc1 
 q $g(rLocDesc)
}

/// Creator：       PL
/// CreatDate：     2018-05-10
/// Description:：  通过PAC_Ward.WARD_RowID取出病区的描述
/// Table：         PAC_Ward
/// Input：         WARD_RowID
/// Output：        病区描述
/// Return：        
/// Others：         w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetWardDesc("66")
ClassMethod GetWardDesc(iWardRowid As %String) As %String
{
 q:$g(iWardRowid)="" "Null"
 i $d(^PAWARD(iWardRowid)) s LocDesc1=$p(^PAWARD(iWardRowid),"^",2)   
 e  s LocDesc1="Null"
 i LocDesc1 [ "-" s rLocDesc=$p(LocDesc1,"-",2)
 e  s rLocDesc=LocDesc1 
 q $g(rLocDesc)
}

/// Creator：       PL
/// CreatDate：     2018-05-10
/// Description:：  通过CT_CareProv.CTPCP_RowId获得医护人员的代码
/// Table：         CT_CareProv
/// Input：         CTPCP_RowId
/// Output：        医护人员的代码
/// Return：        
/// Others：         w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetPatDocCode("66")
ClassMethod GetPatDocCode(iDocId As %String) As %String
{
 q:$g(iDocId)="" "Null"
 q:'$d(^CTPCP(iDocId)) "Null"
 s oPatDoc=$p(^CTPCP(iDocId,1),"^",1)
 q $g(oPatDoc)
}

/// Creator：       PL
/// CreatDate：     2018-05-10
/// Description:：  通过CT_CareProv.CTPCP_RowId获得医护人员的描述
/// Table：         CT_CareProv
/// Input：         CTPCP_RowId
/// Output：        医护人员的描述
/// Return：        
/// Others：         w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetPatDoc("66")
ClassMethod GetPatDoc(iDocId As %String) As %String
{
 q:$g(iDocId)="" "Null"
 q:'$d(^CTPCP(iDocId)) "Null"
 s oPatDoc=$p(^CTPCP(iDocId,1),"^",2)
 q $g(oPatDoc)
}

/// Creator：       PL
/// CreatDate：     2018-05-10
/// Description:：  通过PA_PatMas.PAPMI_RowId,获得病人的手机号码
/// Table：         PA_PatMas
/// Input：         PAPMI_RowId
/// Output：        手机号码
/// Return：        
/// Others：         w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetMobPhone("66")
ClassMethod GetMobPhone(admId As %String) As %String
{
 q:$g(admId)="" "Null"
 s iPatNo=$p(^PAADM(admId),"^",1)	
 q:$g(iPatNo)="" Null
 q:'$d(^PAPER(iPatNo,"PER",4)) "Null"
 s tMobPhone=$p(^PAPER(iPatNo,"PER",4),"^",21) 
 q:$g(tMobPhone)="" "Null"
 q $g(tMobPhone)
}

/// Creator：       PL
/// CreatDate：     2018-05-10
/// Description:：  通过PA_ADM ADM_ROWID,获得病人的电话号码
/// Table：         PA_ADM
/// Input：         ADM_ROWID
/// Output：        电话号码
/// Return：        
/// Others：         w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetTel("66")
ClassMethod GetTel(admId As %String) As %String
{
 q:$g(admId)="" "Null"
 s iPatNo=$p(^PAADM(admId),"^",1)	
 q:$g(iPatNo)="" Null
 q:'$d(^PAPER(iPatNo,"PER",1)) "Null"
 s tTel=$p(^PAPER(iPatNo,"PER",1),"^",11) 
 q:$g(tTel)="" "Null"
 q $g(tTel)
}

/// Creator：       PL
/// CreatDate：     2018-05-10
/// Description:：  通过PA_ADM ADM_ROWID,获得病人的身份证号码
/// Table：         PA_PatMas、PA_ADM
/// Input：         ADM_ROWID
/// Output：        身份证号码
/// Return：        
/// Others：         w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetPatId("66")
ClassMethod GetPatId(admId As %String) As %String
{
 q:$g(admId)="" "Null"
 s iPatNo=$p(^PAADM(admId),"^",1)	
 q:$g(iPatNo)="" Null
 q:'$d(^PAPER(iPatNo,"ALL")) "Null"
 s tPatId=$p(^PAPER(iPatNo,"ALL"),"^",9) 
 q:$g(tPatId)="" "Null"
 q $g(tPatId)
}

/// Creator：       PL
/// CreatDate：     2018-05-10
/// Description:：  通过SS_USER.SS_USER_RowId,获得用户表描述
/// Table：         SS_USER
/// Input：         SS_USER_RowId
/// Output：        用户表描述
/// Return：        
/// Others：         w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetUsrName("66")
ClassMethod GetUsrName(rowId As %String) As %String
{
 q:$g(rowId)="" "" 
 q:'$d(^SSU("SSUSR",rowId)) ""
 s usrName=$p(^SSU("SSUSR",rowId),"^",2)
 q $g(usrName)
}

/// Creator：       PL
/// CreatDate：     2018-05-10
/// Description:：  通过PA_Adm.PAADM_RowID获得第一个出院诊断
/// Table：         PA_Adm
/// Input：         DIS出院诊断,M主诊断,PRE预期诊断,C008入院诊断
/// Output：        用户表描述
/// Return：        
/// Others：         w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetFriDisDiagnos("66","")
ClassMethod GetFriDisDiagnos(admId As %String, iDiagnosCode As %String = "DIS") As %String
{
 q:$g(admId)="" "Null"
 q:'$d(^PAADM(admId)) "Null"
 s admMainDR=$p(^PAADM(admId),"^",61)
 q:$g(admMainDR)="" "Null"
 q:'$d(^MR(admMainDR,"DIA")) "Null"
 s docId=""
 s mrdiaSub=0 f  s mrdiaSub=$o(^MR(admMainDR,"DIA",mrdiaSub)) q:(mrdiaSub="")!($g(mrcidDesc)'="")  d
 .s typSub=0  f  s typSub=$o(^MR(admMainDR,"DIA",mrdiaSub,"TYP",typSub)) q:typSub=""  d
 ..s typDiagDr=$p(^MR(admMainDR,"DIA",mrdiaSub,"TYP",typSub),"^")
 ..q:typDiagDr=""
 ..s dtypCode=$p(^MRC("DTYP",typDiagDr),"^")
 ..q:dtypCode'=iDiagnosCode
 ..s mrdiaIcdCode=$p(^MR(admMainDR,"DIA",mrdiaSub),"^")
 ..s docId=$p(^MR(admMainDR,"DIA",mrdiaSub),"^",4)
 ..s reMark=$g(^MR(admMainDR,"DIA",mrdiaSub,"DES",1))
 ..i mrdiaIcdCode'=""  d
 ...i $d(^MRC("ID",mrdiaIcdCode))  d
 ....s mrcidDesc=$p($g(^MRC("ID",mrdiaIcdCode)),"^",2)
 ....s mrcidCode=$p($g(^MRC("ID",mrdiaIcdCode)),"^",4)
 ....i reMark'="" s mrcidDesc=mrcidDesc_"*"_reMark
 ..e  i reMark'="" s mrcidDesc="*"_reMark s mrcidCode=""
 q $g(mrcidDesc)_"^"_$g(mrcidCode)
}

/// Creator：       ET
/// CreatDate：     2018-05-10
/// Description:：  通过PA_Adm.PAADM_RowID,获得病人的卡号,卡类型
/// Table：         PA_PatMas
/// Input：         PAPMI_RowId
/// Output：        病人的工作单位
/// Return：        zw ^DHCCARDTYPEDef
/// Others：        w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetCardInfo("1","条形码")
ClassMethod GetCardInfo(admId As %String, typeDesc As %String) As %String
{
 q:$g(admId)="" "Null"
 s iPatNo=$p(^PAADM(admId),"^",1)	
 q:$g(iPatNo)="" "Null"
 s cardid="" f  s cardid=$o(^DHCCARDi("CF",0,"PAPMIDR",iPatNo,cardid)) q:cardid=""  d
 .s cardno=$p(^DHCCARD("CF",cardid),"^",2)
 .s cardtypedr=$p(^DHCCARD("CF",cardid),"^",16)
 .s cardtype=$p(^DHCCARDTYPEDef(cardtypedr),"^",2)
 .q:cardtype'=typeDesc
 .;w cardtypedr_"^"_cardtype,!
 q $g(cardno)_"^"_$g(cardtype)
}

/// Creator：       PL
/// CreatDate：     2018-05-10
/// Description:：  通过PA_Adm.PAADM_RowID,获得病人的工作单位
/// Table：         PA_PatMas
/// Input：         PAPMI_RowId
/// Output：        病人的工作单位
/// Return：        
/// Others：         w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetCityFlag("66")
ClassMethod GetCityFlag(admId As %String) As %String
{
 q:$g(admId)="" "Null"
 s iPatNo=$p(^PAADM(admId),"^",1)	
 q:$g(iPatNo)="" "Null"
 q:'$d(^DHCPERSON(0,"PAPERSON",iPatNo)) "Null"
 s id=0 f  s id=$o(^DHCPERSON(0,"PAPERSON",iPatNo,id)) q:id=""  d
 .s cityflag=$p(^DHCPERSON(id),"^",12) 
 q:$g(cityflag)="" "Null"
 q $g(cityflag)
}

/// Creator：       PL
/// CreatDate：     2018-05-10
/// Description:：  通过PA_ADM.ADM_RowId,获得病人符合（N天）再入院标志
/// Table：         PA_ADM
/// Input：         ADM_RowId
/// Output：        再入院标志
/// Return：        
/// Others：         w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetReadmission(211,7,15,"感染性发热")
ClassMethod GetReadmission(PAADMRowid As %String, days As %String, MdiagNos As %String = "") As %String
{
 q:$g(PAADMRowid)="" "Null"
 s PreAdmdr=PAADMRowid
 s papmidr=$p(^PAADM(PreAdmdr),"^",1)
 s admdate=$p(^PAADM(PreAdmdr),"^",6)
 s PAADMRowid=$o(^PAPERdr(papmidr,"ADM","I",PAADMRowid),-1)    //本次记录的上一次就诊记录
 q:PAADMRowid="" 0
 s disdate=$p(^PAADM(PAADMRowid),"^",17)
 s diag=##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetFriDisDiagnos(PAADMRowid,"M")
 s diag=$p(diag,"^",1)
 i MdiagNos'="" q:MdiagNos'=diag 0
 s day=admdate-disdate
 i (day<days) s flag=1
 e  s flag=0
 q flag
}

/// Creator：       PL
/// CreatDate：     2018-05-10
/// Description:：  通过PA_ADM.ADM_RowId,获得病人的婚姻状况
/// Table：         PA_PatMas、PA_ADM
/// Input：         ADM_RowId
/// Output：        婚姻状况
/// Return：        
/// Others：         w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetMarry("66")
ClassMethod GetMarry(admId As %String) As %String
{
 q:$g(admId)="" "Null"
 s iPatNo=$p(^PAADM(admId),"^",1)	
 q:$g(iPatNo)="" "Null"
 s Code=$p(^PAPER(iPatNo,"PER",2),"^",3)
 q:Code="" "Null"
 s MaritalStatusCode=$p(^CT("MAR",Code),"^",1)
 s MaritalStatusName=$p(^CT("MAR",Code),"^",2)
 q MaritalStatusCode_"^"_MaritalStatusName
}

/// Creator：       PL
/// CreatDate：     2018-05-10
/// Description:：  通过PA_AdmTransaction,PAADM_RowId获得病人转科表第一个科室
/// Table：         PA_AdmTransaction
/// Input：         PAADM_RowId
/// Output：        转科表第一个科室
/// Return：        
/// Others：         w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetfirstLoc("66")
ClassMethod GetfirstLoc(admId As %String) As %String
{
 s fistLoc=""
 s sub=""  f  s sub=$o(^PAADM(admId,"TRANS",sub)) q:(sub="")||(fistLoc'="")  d
 .s fistLoc=$p(^PAADM(admId,"TRANS",sub),"^",6) 
 q fistLoc
}

/// Creator：       PL
/// CreatDate：     2018-05-10
/// Description:：  通过PA_AdmTransaction,PAADM_RowId获得病人转科表第一个医生
/// Table：         PA_AdmTransaction
/// Input：         PAADM_RowId
/// Output：        转科表第一个医生
/// Return：        
/// Others：         w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetfirstDoc("66")
ClassMethod GetfirstDoc(admId As %String) As %String
{
 s fistDoc=""
 s sub=""  f  s sub=$o(^PAADM(admId,"TRANS",sub)) q:(sub="")||(fistDoc'="")  d
 .s fistDoc=$p(^PAADM(admId,"TRANS",sub),"^",5) 
 q fistDoc
}

/// Creator：       PL
/// CreatDate：     2018-05-10
/// Description:：  通过PA_AdmTransaction,PAADM_RowId获得病人邮编
/// Table：         PA_Person
/// Input：         PAADM_RowId
/// Output：        邮编
/// Return：        
/// Others：         w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetZipCode("66")
ClassMethod GetZipCode(admId As %String) As %String
{
 q:$g(admId)="" "Null"
 s iPatNo=$p(^PAADM(admId),"^",1)	
 q:$g(iPatNo)="" Null
 q:'$d(^PAPER(iPatNo,"PER")) "Null"
 s zipId=$p(^PAPER(iPatNo,"PER",1),"^",7)
 s zipCode=$p($g(^CT("ZIP",zipId)),"^",1)
 q:$g(zipCode)="" "Null"
 q $g(zipCode)
}

/// Creator：       PL
/// CreatDate：     2019-01-16
/// Description:：  国籍缩写
/// Table：         
/// Input：         国籍缩写
/// Output：        
/// Return：        
/// Others：         w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetnationalityChange("阿鲁巴")
ClassMethod GetnationalityChange(nation As %String) As %String
{
 i nation["阿鲁巴" s mRetun="ABW"
 i nation["阿富汗" s mRetun="AFG"
 i nation["安哥拉" s mRetun="AGO"
 i nation["安圭拉" s mRetun="AIA"
 i nation["阿尔巴尼亚" s mRetun="ALB"
 i nation["安道尔" s mRetun="AND"
 i nation["荷属安的列斯" s mRetun="ANT"
 i nation["阿联酋" s mRetun="ARE"
 i nation["阿根廷" s mRetun="ARG"
 i nation["亚美尼亚" s mRetun="ARM"
 i nation["美属萨摩亚" s mRetun="ASM"
 i nation["南极洲" s mRetun="ATA"
 i nation["法属南部领土" s mRetun="ATF"
 i nation["安提瓜和巴布达" s mRetun="ATG"
 i nation["澳大利亚" s mRetun="AUS"
 i nation["奥地利" s mRetun="AUT"
 i nation["阿塞拜疆" s mRetun="AZE"
 i nation["布隆迪" s mRetun="BDI"
 i nation["比利时" s mRetun="BEL"
 i nation["贝宁" s mRetun="BEN"
 i nation["布基纳法索" s mRetun="BFA"
 i nation["孟加拉国" s mRetun="BGD"
 i nation["保加利亚" s mRetun="BGR"
 i nation["巴林" s mRetun="BHR"
 i nation["巴哈马" s mRetun="BHS"
 i nation["波斯尼亚和黑塞哥维那" s mRetun="BIH"
 i nation["白俄罗斯" s mRetun="BLR"
 i nation["伯利兹" s mRetun="BLZ"
 i nation["百幕大" s mRetun="BMU"
 i nation["玻利维亚" s mRetun="BOL"
 i nation["巴西" s mRetun="BRA"
 i nation["巴巴多斯" s mRetun="BRB"
 i nation["文莱" s mRetun="BRN"
 i nation["不丹" s mRetun="BTN"
 i nation["布维岛" s mRetun="BVT"
 i nation["博茨瓦纳" s mRetun="BWA"
 i nation["中非" s mRetun="CAF"
 i nation["加拿大" s mRetun="CAN"
 i nation["科科斯群岛" s mRetun="CCK"
 i nation["瑞士" s mRetun="CHE"
 i nation["智利" s mRetun="CHL"
 i nation["中国" s mRetun="CHN"
 i nation["科特迪瓦" s mRetun="CIV"
 i nation["喀麦隆" s mRetun="CMR"
 i nation["刚果民主共和国" s mRetun="COD"
 i nation["刚果" s mRetun="COG"
 i nation["库克群岛" s mRetun="COK"
 i nation["哥伦比亚" s mRetun="COL"
 i nation["科摩罗" s mRetun="COM"
 i nation["佛得角" s mRetun="CPV"
 i nation["哥斯达黎加" s mRetun="CRI"
 i nation["古巴" s mRetun="CUB"
 i nation["圣诞岛" s mRetun="CXR"
 i nation["开曼群岛" s mRetun="CYM"
 i nation["塞浦路斯" s mRetun="CYP"
 i nation["捷克" s mRetun="CZE"
 i nation["德国" s mRetun="DEU"
 i nation["吉布提" s mRetun="DJI"
 i nation["多米尼加" s mRetun="DMA"
 i nation["丹麦" s mRetun="DNK"
 i nation["多米尼家共和国" s mRetun="DOM"
 i nation["阿尔及利亚" s mRetun="DZA"
 i nation["厄瓜多尔" s mRetun="ECU"
 i nation["埃及" s mRetun="EGY"
 i nation["厄立特里亚" s mRetun="ERI"
 i nation["西撒哈拉" s mRetun="ESH"
 i nation["西班牙" s mRetun="ESP"
 i nation["爱沙尼亚" s mRetun="EST"
 i nation["埃塞俄比亚" s mRetun="ETH"
 i nation["芬兰" s mRetun="FIN"
 i nation["斐济" s mRetun="FJI"
 i nation["马尔维纳斯群岛" s mRetun="FLK"
 i nation["法国" s mRetun="FRA"
 i nation["法罗群岛" s mRetun="FRO"
 i nation["密克罗尼西亚" s mRetun="FSM"
 i nation["加蓬" s mRetun="GAB"
 i nation["英国（独立领土公民、出国不用）" s mRetun="GBD"
 i nation["英国（海外国民，出国不用）" s mRetun="GBN"
 i nation["英国（海外公民，出国不用）" s mRetun="GBO"
 i nation["英国（保护公民，出国不用）" s mRetun="GBP"
 i nation["英国" s mRetun="GBR"
 i nation["英国（隶属，出国不用）" s mRetun="GBS"
 i nation["格鲁吉亚" s mRetun="GEO"
 i nation["加纳" s mRetun="GHA"
 i nation["直布罗陀" s mRetun="GIB"
 i nation["几内亚" s mRetun="GIN"
 i nation["瓜德罗普" s mRetun="GLP"
 i nation["冈比亚" s mRetun="GMB"
 i nation["几内亚比绍" s mRetun="GNB"
 i nation["赤道几内亚" s mRetun="GNQ"
 i nation["希腊" s mRetun="GRC"
 i nation["格林纳达" s mRetun="GRD"
 i nation["格陵兰" s mRetun="GRL"
 i nation["危地马拉" s mRetun="GTM"
 i nation["法属圭亚那" s mRetun="GUF"
 i nation["关岛" s mRetun="GUM"
 i nation["圭亚那" s mRetun="GUY"
 i nation["香港" s mRetun="HKG"
 i nation["赫德岛和麦克唐纳岛" s mRetun="HMD"
 i nation["洪都拉斯" s mRetun="HND"
 i nation["克罗地亚" s mRetun="HRV"
 i nation["海地" s mRetun="HTI"
 i nation["匈牙利" s mRetun="HUN"
 i nation["印度尼西亚" s mRetun="IDN"
 i nation["印度" s mRetun="IND"
 i nation["英属印度洋领土" s mRetun="IOT"
 i nation["爱尔兰" s mRetun="IRL"
 i nation["伊朗" s mRetun="IRN"
 i nation["伊拉克" s mRetun="IRQ"
 i nation["冰岛" s mRetun="ISL"
 i nation["以色列" s mRetun="ISR"
 i nation["意大利" s mRetun="ITA"
 i nation["牙买加" s mRetun="JAM"
 i nation["约旦" s mRetun="JOR"
 i nation["日本" s mRetun="JPN"
 i nation["约翰斯顿岛" s mRetun="JTN"
 i nation["哈萨克斯坦" s mRetun="KAZ"
 i nation["肯尼亚" s mRetun="KEN"
 i nation["吉尔吉斯斯坦" s mRetun="KGZ"
 i nation["柬埔寨" s mRetun="KHM"
 i nation["基里巴斯" s mRetun="KIR"
 i nation["圣基茨和尼维斯" s mRetun="KNA"
 i nation["韩国（南朝鲜）" s mRetun="KOR"
 i nation["科威特" s mRetun="KWT"
 i nation["老挝" s mRetun="LAO"
 i nation["黎巴嫩" s mRetun="LBN"
 i nation["利比里亚" s mRetun="LBR"
 i nation["利比亚" s mRetun="LBY"
 i nation["圣卢西亚" s mRetun="LCA"
 i nation["列支敦土登" s mRetun="LIE"
 i nation["斯里兰卡" s mRetun="LKA"
 i nation["莱索托" s mRetun="LSO"
 i nation["立陶宛" s mRetun="LTU"
 i nation["卢森堡" s mRetun="LUX"
 i nation["拉脱维亚" s mRetun="LVA"
 i nation["澳门" s mRetun="MAC"
 i nation["摩洛哥" s mRetun="MAR"
 i nation["摩纳哥" s mRetun="MCO"
 i nation["摩尔多瓦" s mRetun="MDA"
 i nation["马达加斯加" s mRetun="MDG"
 i nation["马尔代夫" s mRetun="MDV"
 i nation["墨西哥" s mRetun="MEX"
 i nation["马绍尔群岛" s mRetun="MHL"
 i nation["中途岛" s mRetun="MID"
 i nation["马其顿" s mRetun="MKD"
 i nation["马里" s mRetun="MLI"
 i nation["马耳他" s mRetun="MLT"
 i nation["缅甸" s mRetun="MMR"
 i nation["蒙古" s mRetun="MNG"
 i nation["北马里亚纳" s mRetun="MNP"
 i nation["莫桑比克" s mRetun="MOZ"
 i nation["毛里塔尼亚" s mRetun="MRT"
 i nation["蒙特塞拉特" s mRetun="MSR"
 i nation["马提尼克" s mRetun="MTQ"
 i nation["毛里求斯" s mRetun="MUS"
 i nation["马拉维" s mRetun="MWI"
 i nation["马来西亚" s mRetun="MYS"
 i nation["马约特" s mRetun="MYT"
 i nation["纳米比亚" s mRetun="NAM"
 i nation["新喀里多尼亚" s mRetun="NCL"
 i nation["尼日尔" s mRetun="NER"
 i nation["诺福克岛" s mRetun="NFK"
 i nation["尼日利亚" s mRetun="NGA"
 i nation["尼加拉瓜" s mRetun="NIC"
 i nation["纽埃" s mRetun="NIU"
 i nation["荷兰" s mRetun="NLD"
 i nation["挪威" s mRetun="NOR"
 i nation["尼波尔" s mRetun="NPL"
 i nation["瑙鲁" s mRetun="NRU"
 i nation["中间地带" s mRetun="NTZ"
 i nation["新西兰" s mRetun="NZL"
 i nation["阿曼" s mRetun="OMN"
 i nation["巴基斯坦" s mRetun="PAK"
 i nation["巴拿马" s mRetun="PAN"
 i nation["皮特凯恩群岛" s mRetun="PCN"
 i nation["秘鲁" s mRetun="PER"
 i nation["菲律宾" s mRetun="PHL"
 i nation["贝劳" s mRetun="PLW"
 i nation["巴布亚新几内亚" s mRetun="PNG"
 i nation["波兰" s mRetun="POL"
 i nation["波多黎各" s mRetun="PRI"
 i nation["朝鲜" s mRetun="PRK"
 i nation["葡萄牙" s mRetun="PRT"
 i nation["巴拉圭" s mRetun="PRY"
 i nation["巴勒斯坦" s mRetun="PST"
 i nation["法属菠利尼西亚" s mRetun="PYF"
 i nation["卡塔尔" s mRetun="QAT"
 i nation["留尼汪" s mRetun="REU"
 i nation["罗马尼亚" s mRetun="ROM"
 i nation["俄罗斯" s mRetun="RUS"
 i nation["卢旺达" s mRetun="RWA"
 i nation["沙特阿拉伯" s mRetun=" sAU"
 i nation["苏丹" s mRetun=" sDN"
 i nation["塞内加尔" s mRetun=" sEN"
 i nation["新加坡" s mRetun=" sGP"
 i nation["南乔治亚岛和南桑德韦奇岛" s mRetun=" sGS"
 i nation["圣赫勒拿" s mRetun=" sHN"
 i nation["斯瓦尔巴群岛" s mRetun=" sJM"
 i nation["所罗门群岛" s mRetun=" sLB"
 i nation["塞拉利昂" s mRetun=" sLE"
 i nation["萨尔瓦多" s mRetun=" sLV"
 i nation["圣马力诺" s mRetun=" sMR"
 i nation["索马里" s mRetun=" sOM"
 i nation["圣皮埃尔和密克隆" s mRetun=" sPM"
 i nation["塞班" s mRetun=" sS"
 i nation["圣多美和普林西比" s mRetun=" sTP"
 i nation["苏里南" s mRetun=" sUR"
 i nation["斯洛伐克" s mRetun=" sVK"
 i nation["斯洛文尼亚" s mRetun=" sVN"
 i nation["瑞典" s mRetun=" sWE"
 i nation["斯威士兰" s mRetun=" sWZ"
 i nation["锡金" s mRetun=" sX"
 i nation["塞尔维亚" s mRetun=" sF"
 i nation["塞舌尔" s mRetun=" sYC"
 i nation["叙利亚" s mRetun=" sYR"
 i nation["特克斯和凯科斯群岛" s mRetun="TCA"
 i nation["乍得" s mRetun="TCD"
 i nation["多哥" s mRetun="TGO"
 i nation["泰国" s mRetun="THA"
 i nation["塔吉克斯坦" s mRetun="TJK"
 i nation["托克劳" s mRetun="TKL"
 i nation["土库曼斯坦" s mRetun="TKM"
 i nation["东帝汶" s mRetun="TMP"
 i nation["汤加" s mRetun="TON"
 i nation["特立尼达和多巴哥" s mRetun="TTO"
 i nation["突尼斯" s mRetun="TUN"
 i nation["土耳其" s mRetun="TUR"
 i nation["图瓦卢" s mRetun="TUV"
 i nation["台湾" s mRetun="TWN"
 i nation["坦桑尼亚" s mRetun="TZA"
 i nation["乌干达" s mRetun="UGA"
 i nation["乌克兰" s mRetun="UKR"
 i nation["美属太平洋各群岛" s mRetun="UMI"
 i nation["联合国" s mRetun="UN"
 i nation["联合国" s mRetun="UNA"
 i nation["联合国" s mRetun="UNO"
 i nation["乌拉圭" s mRetun="URY"
 i nation["美国" s mRetun="USA"
 i nation["乌兹别克斯坦" s mRetun="UZB"
 i nation["梵蒂冈" s mRetun="VAT"
 i nation["圣文森特和格林纳丁斯" s mRetun="VCT"
 i nation["委内瑞拉" s mRetun="VEN"
 i nation["英属维尔京群岛" s mRetun="VGB"
 i nation["美属维尔京群岛" s mRetun="VIR"
 i nation["越南" s mRetun="VNM"
 i nation["瓦努阿图" s mRetun="VUT"
 i nation["威克岛" s mRetun="WAK"
 i nation["瓦利斯和富图纳群岛" s mRetun="WLF"
 i nation["西萨摩亚" s mRetun="WSM"
 i nation["无国籍（无国籍人）" s mRetun="XXA"
 i nation["无国籍（难民）" s mRetun="XXB"
 i nation["无国籍（未声明国籍）" s mRetun="XXX"
 i nation["也门" s mRetun="YEM"
 i nation["南斯拉夫" s mRetun="YUG"
 i nation["南非" s mRetun="ZAF"
 i nation["扎伊尔" s mRetun="ZAR"
 i nation["赞比亚" s mRetun="ZMB"
 i nation["津巴布韦" s mRetun="ZWE"
 i nation["国籍不详" s mRetun="ZZZ"
 q $g(mRetun)
}

/// Creator：       PL
/// CreatDate：     2019-01-16
/// Description:：  民族CODE
/// Table：         
/// Input：         民族
/// Output：        民族
/// Return：        
/// Others：         w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).Volk("汉族")
ClassMethod Volk(mData As %String) As %String
{
	i mData="汉族" s mRet="01"
	i mData="蒙古族" s mRet="02"
	i mData="回族" s mRet="03"
	i mData="藏族" s mRet="04"
	i mData="维吾尔族" s mRet="05"
	i mData="苗族" s mRet="06"
	i mData="彝族" s mRet="07"
	i mData="壮族" s mRet="08"
	i mData="布依族" s mRet="09"
	i mData="朝鲜族" s mRet="10"
	i mData="满族" s mRet="11"
	i mData="侗族" s mRet="12"
	i mData="瑶族" s mRet="13"
	i mData="白族" s mRet="14"
	i mData="土家族" s mRet="15"
	i mData="哈尼族" s mRet="16"
	i mData="哈萨克族" s mRet="17"
	i mData="傣族" s mRet="18"
	i mData="黎族" s mRet="19"
	i mData="傈僳族" s mRet="20"
	i mData="佤族" s mRet="21"
	i mData="畲族" s mRet="22"
	i mData="高山族" s mRet="23"
	i mData="拉祜族" s mRet="24"
	i mData="水族" s mRet="25"
	i mData="东乡族" s mRet="26"
	i mData="纳西族" s mRet="27"
	i mData="景颇族" s mRet="28"
	i mData="柯尔克孜" s mRet="29"
	i mData="土族" s mRet="30"
	i mData="达斡尔族" s mRet="31"
	i mData="仫佬族" s mRet="32"
	i mData="羌族" s mRet="33"
	i mData="布朗族" s mRet="34"
	i mData="撒拉族" s mRet="35"
	i mData="毛南族" s mRet="36"
	i mData="仡佬族" s mRet="37"
	i mData="锡伯族" s mRet="38"
	i mData="阿昌族" s mRet="39"
	i mData="普米族" s mRet="40"
	i mData="塔吉克族" s mRet="41"
	i mData="怒族" s mRet="42"
	i mData="乌孜别克" s mRet="43"
	i mData="俄罗斯族" s mRet="44"
	i mData="鄂温克族" s mRet="45"
	i mData="崩龙族" s mRet="46"
	i mData="保安族" s mRet="47"
	i mData="裕固族" s mRet="48"
	i mData="京族" s mRet="49"
	i mData="塔塔尔族" s mRet="50"
	i mData="独龙族" s mRet="51"
	i mData="鄂伦春族" s mRet="52"
	i mData="赫哲族" s mRet="53"
	i mData="门巴族" s mRet="54"
	i mData="珞巴族" s mRet="55"
	i mData="基诺族" s mRet="56"
	i mData="其他" s mRet="99"
    q $g(mRet)
}

/// Creator：       PL
/// CreatDate：     2019-01-16
/// Description:：  VB科室统计组
/// Table：         
/// Input：         统计组ID、His科室ID
/// Output：        统计组描述、代码
/// Return：        
/// Others：         w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetLocGrp(10,3)
ClassMethod GetLocGrp(mId As %String, mloc As %String) As %String
{
 s ChildSub=""
 f  s ChildSub=$o(^DHCWLCFG("GRP",mId,"SUBGRP",ChildSub))  q:ChildSub=""   d
 .s SubGrpRowid=mId_"||"_ChildSub
 .s topLocDesc=$p(^DHCWLCFG("GRP",mId,"SUBGRP",ChildSub),"^",2)
 .s SUBGRPDEPRowid=0 f  s SUBGRPDEPRowid=$o(^DHCWLCFGR("SUBGRPDEP","SUBGRP",SubGrpRowid,SUBGRPDEPRowid)) q:SUBGRPDEPRowid=""  d
 ..s Loc=$P($G(^DHCWLCFGR("SUBGRPDEP",SUBGRPDEPRowid)),"^",3)
 ..s ^||TMPDHCWL($j,"LOC",Loc)=topLocDesc 
 s mRet=$g(^||TMPDHCWL($j,"LOC",mloc))
 q $g(mRet)
}

/// Creator：       PL
/// CreatDate：     2019-01-16
/// Description:：  VB科室统计组
/// Table：         
/// Input：         统计组ID、His项目ID 分类：TARIM、TarEC
/// Output：        统计组描述、代码
/// Return：        
/// Others：         w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).GetItemGrp(14,21,"TarEC")
ClassMethod GetItemGrp(mId As %String, mCode As %String, Type As %String) As %String
{
  s dhcwlitemid="" f  s dhcwlitemid=$o(^DHCWLSTAT(mId,"ITEM",dhcwlitemid)) q:dhcwlitemid=""  d
  .s childSub="" f  s childSub=$o(^DHCWLSTAT(mId,"ITEM",dhcwlitemid,"DETAIL",0,Type,childSub))  q:childSub=""  d
  ..s itemDesc=$p(^DHCWLSTAT(mId,"ITEM",dhcwlitemid),"^",2)
  ..s ^||TMPDHCWL($j,"childSub",childSub)=itemDesc
 s mRet=$g(^||TMPDHCWL($j,"childSub",mCode))
 q $g(mRet)
}

/// Creator：       PL
/// CreatDate：     2019-01-16
/// Description:：  省CODE
/// Table：         
/// Input：         省描述
/// Output：        省标准代码
/// Return：        
/// Others：         w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).ProCode("北京市")
ClassMethod ProCode(mData As %String) As %String
{
 i mData="北京市"  s mRet="110000"
 i mData="天津市"  s mRet="120000"
 i mData="河北省"  s mRet="130000"
 i mData="山西省"  s mRet="140000"
 i mData="内蒙古自治区"  s mRet="150000"
 i mData="辽宁省"  s mRet="210000"
 i mData="吉林省"  s mRet="220000"
 i mData="黑龙江省"  s mRet="230000"
 i mData="上海市"  s mRet="310000"
 i mData="江苏省"  s mRet="320000"
 i mData="浙江省"  s mRet="330000"
 i mData="安徽省"  s mRet="340000"
 i mData="福建省"  s mRet="350000"
 i mData="江西省"  s mRet="360000"
 i mData="山东省"  s mRet="370000"
 i mData="河南省"  s mRet="410000"
 i mData="湖北省"  s mRet="420000"
 i mData="湖南省"  s mRet="430000"
 i mData="广东省"  s mRet="440000"
 i mData="广西壮族自治区"  s mRet="450000"
 i mData="海南省"  s mRet="460000"
 i mData="重庆市"  s mRet="500000"
 i mData="四川省"  s mRet="510000"
 i mData="贵州省"  s mRet="520000"
 i mData="云南省"  s mRet="530000"
 i mData="西藏自治区	"  s mRet="540000"
 i mData="陕西省"  s mRet="610000"
 i mData="甘肃省"  s mRet="620000"
 i mData="青海省"  s mRet="630000"
 i mData="宁夏回族自治区"  s mRet="640000"
 i mData="新疆维吾尔自治区"  s mRet="650000"
 q $g(mRet)
}

/// 医嘱组号
/// w ##class(DHCWL.InterManagement.DHCWLCommon.CommonMethod).OrdItmPriority("1||128")
ClassMethod OrdItmPriority(oeori As %String) As %String
{
	s ord=+oeori
	s itm=$p(oeori,"||",2)
	q:ord="" ""
	q:itm="" ""
	s pr=$p($g(^OEORD(ord,"I",itm,1)),"^",8)
	q:pr="" ""
	s priority=$P($g(^OECPR(pr)),"^",2)
	q priority
}

}
