Class web.DHCOperPrice Extends %RegisteredObject
{

ClassMethod GetAdmInfoByOpaId(opaId As %String) As %String
{
 //w ##class(web.DHCOperPrice).GetAdmInfo("19830")
 s AdmRowid=$p(^DHCANOPArrange(opaId),"^",1)
 s operStartDate=$p(^DHCANOPArrange(opaId),"^",14)
 if (+operStartDate<=0){
	s operStartDate=+$h	 
}
 s PapmiRowid=$P(^PAADM(AdmRowid),"^",1)
 Quit:PapmiRowid=""
 Set PapmiOPNo=$p($g(^PAPER(PapmiRowid,"PAT",1)),"^",2)
 Set PapmiIPNo=$p($g(^PAPER(PapmiRowid,"PAT",1)),"^",1)
 Set PapmiNo=##Class(web.PAPatMas).GetRegistration(PapmiRowid)
 Set PatientName=$P($G(^PAPER(PapmiRowid,"ALL")),"^",1)
 Set PatientDOB=$P($G(^PAPER(PapmiRowid,"ALL")),"^",6)
 Set PatientBirthday=$ZD($G(PatientDOB),3)
 Set FPatientBirthday=..YearToFormat(PatientBirthday)
 
 Set PatientSexDr=$P($G(^PAPER(PapmiRowid,"ALL")),"^",7)
 Set PapmiName3=$P($G(^PAPER(PapmiRowid,"ALL")),"^",19)  //医保号
 If PatientSexDr'="" Set PatientSex=$P($G(^CT("SEX",PatientSexDr)),"^",2)
 else  Set PatientSex=""
 
 Set Pattype=""
 Set PatientSocialStausDR=$p($g(^PAPER(PapmiRowid,"PER",1)),"^",10)
 If PatientSocialStausDR'=""  Do
 .Set Pattype=$p(^CT("SS",PatientSocialStausDR),"^",2)
 
 Set PatientCompany=$g(^PAPER(PapmiRowid,"PER","ADD",1))
 Set PatientComAdd=$p($g(^PAPER(PapmiRowid,"PER",4)),"^",18)
 Set EmployeeNO=$P($G(^PAPER(PapmiRowid,"EMP")),"^",5)
 Set PatientMaritalDr=$p($g(^PAPER(PapmiRowid,"PER",2)),"^",3)
 If PatientMaritalDr'="" s PatientMarital= $P($G(^CT("MAR",PatientMaritalDr)),"^",2)
 Else  Set PatientMarital="未知"
 Set PatCategoryRowid=$p($g(^PAPER(PapmiRowid,"PAT",1)),"^",8)
 Set Medcare=$p($g(^PAPER(PapmiRowid,"PAT",1)),"^",22)
 
 Set Age=..CalAge(PatientDOB,operStartDate,"","","")
 Set AgeYear=$P(Age,"|",12)
 Set AgeMonth=$P(Age,"|",13)
 Set AgeDay=$P(Age,"|",14)
 Set AgeDesc=..FormatAge(AgeYear,AgeMonth,AgeDay)
 set lessThanSixYear="N"
 if (+AgeYear<6) set lessThanSixYear="Y"
 Set RealName=$P($G(^PAPER(PapmiRowid,"ALL")),"^",21)
 Set RealCard=$P($G(^PAPER(PapmiRowid,"ALL")),"^",22)
 Set SupplyName=$P($G(^PAPER(PapmiRowid,"ALL")),"^",23)
 Set SupplyCard=$P($G(^PAPER(PapmiRowid,"ALL")),"^",24)
 Set GovernCardNo=$p($g(^PAPER(PapmiRowid,"PER",4)),"^",4)
 Set AdmReasonRowid=""
 Set AdmReasonRowid=$P($G(^PAADM(AdmRowid,1)),"^",7)
 Set BillType=""
 If AdmReasonRowid'="" Set BillType=$P($G(^PAC("ADMREA",AdmReasonRowid)),"^",2)
 Set DepCodeDR=""
 Set DepCodeDR=$P($G(^PAADM(AdmRowid)),"^",4)
 Set DepDesc=$P(^CTLOC(DepCodeDR),"^",2)
 Set DepDesc=$P(DepDesc,"-",2)
 Set PACBedDr=""
 Set PACBedDr=$P($G(^PAADM(AdmRowid)),"^",73)
 s bedSub=$p($p($g(^PAADM(AdmRowid)),"^",73),"||",2)
 s curWardId=$p($g(^PAADM(AdmRowid)),"^",70)  
 i (bedSub'="")&(curWardId'="") s BedNo=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
 Set BedNo=$g(BedNo)
 Set AdmDate=$P($G(^PAADM(AdmRowid)),"^",6)
 if AdmDate'="" Set AdmDate=$ZD(AdmDate,3)
 If AdmDate'="" Set FAdmDate=..YearToFormat(AdmDate)
 Else  Set FAdmDate=""
 Set ret= PapmiRowid_"^"_PapmiNo_"^"_PatientName_"^"_PatientSex_"^"_AgeDesc_"^"_FPatientBirthday_"^"_Pattype_"^"_PatientSocialStausDR_"^"_PatientSexDr_"^"_BillType_"^"_DepDesc_"^"_BedNo_"^"_FAdmDate
 Set ret1=PatientDOB_"^"_PatientCompany_"^"_AgeYear_"^"_AgeMonth_"^"_AgeDay_"^"_PatientComAdd_"^"_EmployeeNO_"^"_PatientMarital_"^"_PatCategoryRowid_"^"_Medcare_"^"_RealName_"^"_RealCard_"^"_SupplyName_"^"_SupplyCard_"^"_GovernCardNo_"^"_PapmiName3_"^"_AdmReasonRowid
 Q ret_"^"_ret1
}

ClassMethod GetAdmInfo(AdmRowid As %String) As %String
{
 //w ##class(web.DHCOperPrice).GetAdmInfo("19830")
 s PapmiRowid=$P(^PAADM(AdmRowid),"^",1)
 Quit:PapmiRowid=""
 Set PapmiOPNo=$p($g(^PAPER(PapmiRowid,"PAT",1)),"^",2)
 Set PapmiIPNo=$p($g(^PAPER(PapmiRowid,"PAT",1)),"^",1)
 Set PapmiNo=##Class(web.PAPatMas).GetRegistration(PapmiRowid)
 Set PatientName=$P($G(^PAPER(PapmiRowid,"ALL")),"^",1)
 Set PatientDOB=$P($G(^PAPER(PapmiRowid,"ALL")),"^",6)
 Set PatientBirthday=$ZD($G(PatientDOB),3)
 Set FPatientBirthday=..YearToFormat(PatientBirthday)
 
 Set PatientSexDr=$P($G(^PAPER(PapmiRowid,"ALL")),"^",7)
 Set PapmiName3=$P($G(^PAPER(PapmiRowid,"ALL")),"^",19)  //医保号
 If PatientSexDr'="" Set PatientSex=$P($G(^CT("SEX",PatientSexDr)),"^",2)
 else  Set PatientSex=""
 
 Set Pattype=""
 Set PatientSocialStausDR=$p($g(^PAPER(PapmiRowid,"PER",1)),"^",10)
 If PatientSocialStausDR'=""  Do
 .Set Pattype=$p(^CT("SS",PatientSocialStausDR),"^",2)
 
 Set PatientCompany=$g(^PAPER(PapmiRowid,"PER","ADD",1))
 Set PatientComAdd=$p($g(^PAPER(PapmiRowid,"PER",4)),"^",18)
 Set EmployeeNO=$P($G(^PAPER(PapmiRowid,"EMP")),"^",5)
 Set PatientMaritalDr=$p($g(^PAPER(PapmiRowid,"PER",2)),"^",3)
 If PatientMaritalDr'="" s PatientMarital= $P($G(^CT("MAR",PatientMaritalDr)),"^",2)
 Else  Set PatientMarital="未知"
 Set PatCategoryRowid=$p($g(^PAPER(PapmiRowid,"PAT",1)),"^",8)
 Set Medcare=$p($g(^PAPER(PapmiRowid,"PAT",1)),"^",22)
 
 Set Age=..CalAge(PatientDOB,+$H,"","","")
 Set AgeYear=$P(Age,"|",12)
 Set AgeMonth=$P(Age,"|",13)
 Set AgeDay=$P(Age,"|",14)
 Set AgeDesc=..FormatAge(AgeYear,AgeMonth,AgeDay)
 Set RealName=$P($G(^PAPER(PapmiRowid,"ALL")),"^",21)
 Set RealCard=$P($G(^PAPER(PapmiRowid,"ALL")),"^",22)
 Set SupplyName=$P($G(^PAPER(PapmiRowid,"ALL")),"^",23)
 Set SupplyCard=$P($G(^PAPER(PapmiRowid,"ALL")),"^",24)
 Set GovernCardNo=$p($g(^PAPER(PapmiRowid,"PER",4)),"^",4)
 Set AdmReasonRowid=""
 Set AdmReasonRowid=$P($G(^PAADM(AdmRowid,1)),"^",7)
 Set BillType=""
 If AdmReasonRowid'="" Set BillType=$P($G(^PAC("ADMREA",AdmReasonRowid)),"^",2)
 Set DepCodeDR=""
 Set DepCodeDR=$P($G(^PAADM(AdmRowid)),"^",4)
 Set DepDesc=$P(^CTLOC(DepCodeDR),"^",2)
 Set DepDesc=$P(DepDesc,"-",2)
 Set PACBedDr=""
 Set PACBedDr=$P($G(^PAADM(AdmRowid)),"^",73)
 s bedSub=$p($p($g(^PAADM(AdmRowid)),"^",73),"||",2)
 s curWardId=$p($g(^PAADM(AdmRowid)),"^",70)  
 i (bedSub'="")&(curWardId'="") s BedNo=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
 Set BedNo=$g(BedNo)
 Set AdmDate=$P($G(^PAADM(AdmRowid)),"^",6)
 if AdmDate'="" Set AdmDate=$ZD(AdmDate,3)
 If AdmDate'="" Set FAdmDate=..YearToFormat(AdmDate)
 Else  Set FAdmDate=""
 Set ret= PapmiRowid_"^"_PapmiNo_"^"_PatientName_"^"_PatientSex_"^"_AgeDesc_"^"_FPatientBirthday_"^"_Pattype_"^"_PatientSocialStausDR_"^"_PatientSexDr_"^"_BillType_"^"_DepDesc_"^"_BedNo_"^"_FAdmDate
 Set ret1=PatientDOB_"^"_PatientCompany_"^"_AgeYear_"^"_AgeMonth_"^"_AgeDay_"^"_PatientComAdd_"^"_EmployeeNO_"^"_PatientMarital_"^"_PatCategoryRowid_"^"_Medcare_"^"_RealName_"^"_RealCard_"^"_SupplyName_"^"_SupplyCard_"^"_GovernCardNo_"^"_PapmiName3
 Q ret_"^"_ret1
}

ClassMethod CalAge(IBirth As %String, IToday As %String, EstMth As %String = "", EstYr As %String = "", EstStamp As %String = "")
{
 s IBirth=$g(IBirth),IToday=$g(IToday)
 ;hack of date of birth
 i IBirth>2980000 s IBirth=""
 i IBirth<0 s IBirth=""
 q:'$G(IBirth) ""
 ;
 s XBirth=$ZD(IBirth)
 s XToday=$ZD(IToday)
 s AgeMth=XToday-XBirth
 s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
 s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
 s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
 s AgeYear=CurrYear-BirthYear
 ;
 i AgeDay<0 d
 . s AgeMth=AgeMth-1
 . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
 . q:XToday'=2
 . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
 i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
 ;
 s $P(AgeYr,"|",12)=AgeYear
 q AgeYr_"|"_AgeMth_"|"_AgeDay
}

ClassMethod FormatAge(AgeYear As %String, AgeMonth As %String, AgeDay As %String) As %String
{
	if AgeYear>0 s AgeDesc=AgeYear_"岁"
	else  d
	.if AgeMonth>0 s AgeDesc=AgeMonth_"月"
	.else  s AgeDesc=AgeDay_"天"
	Q AgeDesc
}

ClassMethod YearToFormat(InDate As %String) As %String
{
  Set OutDate=$P(InDate,"-",1)_"年"_$P(InDate,"-",2)_"月"_$P(InDate,"-",3)_"日"	
  Q OutDate
}

ClassMethod GeOperfo(OPARowid As %String) As %String
{
  //w ##class(web.DHCOperPrice).GeOperfo("70")
  Set RetStr=""
  Set AppDate=$P($G(^DHCANOPArrange(OPARowid)),"^",3)
  Set AppDate=$ZD(AppDate,3)
  Set AppUsr=$P($G(^DHCANOPArrange(OPARowid)),"^",6)
  If AppUsr'="" Set AppUserDesc=$P($G(^SSU("SSUSR",AppUsr)),"^",2)
  Else  Set AppUserDesc=""
  Set AppTime=$P($G(^DHCANOPArrange(OPARowid)),"^",5)
  Set AppTime=$ZT(AppTime,1)
  Set OPERStrDate=$P($G(^DHCANOPArrange(OPARowid)),"^",14)
  Set OPERStrDate=$ZD(OPERStrDate,3)
  Set OPERStrTime=$P($G(^DHCANOPArrange(OPARowid)),"^",15)
  Set OPERStrTime=$ZT(OPERStrTime,1)
  Set AnaestDr=$P($G(^DHCANOPArrange(OPARowid)),"^",2)
  Set OPEREndDate=$P($G(^DHCANOPArrange(OPARowid)),"^",16)
  If OPEREndDate'="" Set OPEREndDate=$ZD(OPEREndDate,3)
  Else  Set OPEREndDate=""
  Set OPEREndTime=$P($G(^DHCANOPArrange(OPARowid)),"^",17)
  If OPEREndTime'="" Set OPEREndTime=$ZT(OPEREndTime,1)
  Else  Set OPEREndTime=""
  Set OPAStatus=$P($G(^DHCANOPArrange(OPARowid)),"^",27)
  //A-申请,D-拒绝,R-安排,I-入室,O-术中, L-离开,F-完成,N-非预约
  If OPAStatus="A" Set OPAStatus="申请"
  If OPAStatus="D" Set OPAStatus="拒绝"
  If OPAStatus="R" Set OPAStatus="安排"
  If OPAStatus="I" Set OPAStatus="入室"
  If OPAStatus="O" Set OPAStatus="术中"
  If OPAStatus="L" Set OPAStatus="离开"
  If OPAStatus="F" Set OPAStatus="完成"
  If OPAStatus="N" Set OPAStatus="非预约"
  Set OPERDescStr=""
  Set OPERRowid=0 For  Set OPERRowid=$O(^OR(+AnaestDr,"ANA",$P(AnaestDr,"||",2),"OP",OPERRowid)) Q:OPERRowid=""  Do
  .Set OPERCodeRowid=$P(^OR(+AnaestDr,"ANA",$P(AnaestDr,"||",2),"OP",OPERRowid),"^",6)
  .Q:OPERCodeRowid=""
  .Set OPERDesc=$P($G(^ORC("OPER",+OPERCodeRowid)),"^",2)
  .if (OPERDesc="") set OPERDesc=$get(^OR(+AnaestDr,"ANA",$P(AnaestDr,"||",2),"OP",OPERRowid,"REM",2))
  .If OPERDescStr="" Set OPERDescStr=OPERDesc
  .Else  Set OPERDesc=OPERDescStr_";"_OPERDesc
  Set ANAMethodDr=$P($G(^OR(+AnaestDr,"ANA",$P(AnaestDr,"||",2))),"^",5)
  If ANAMethodDr'="" Set ANAMethodDesc=$P($G(^ORC("ANMET",ANAMethodDr)),"^",2)
  Else  Set ANAMethodDesc=""
  Set RetStr=$G(AppDate)_"^"_$G(AppTime)_"^"_$G(AppUserDesc)_"^"_$G(OPERStrDate)_"^"_$G(OPERStrTime)_"^"_$G(OPERDesc)_"^"_$G(ANAMethodDesc)_"^"_$G(OPEREndDate)_"^"_$G(OPEREndTime)_"^"_$G(OPAStatus)
  Q RetStr
}

ClassMethod OEORDByAdm(Adm As %String) As %String
{
   //w ##class(web.DHCOperPrice).OEORDByAdm("19830")
  Set Flag=0
  If $O(^OEORD(0,"Adm",Adm,-1))="" Do
  .Set NowDate=+$H
  .Set NowTime=$P($H,",",2)
  .&sql(Insert into SQLUSER.oe_order Set OEORD_Adm_DR=:Adm,OEORD_Date=:NowDate,OEORD_Time=:NowTime)
  .if SQLCODE'=0 Set Flag=1
  if Flag=1 q "-100"
  Set OEORDRowid=$O(^OEORD(0,"Adm",Adm,-1))
  Set SubRowid=0 For  Set SubRowid=$O(^OEORD(OEORDRowid,"I",SubRowid)) Q:SubRowid=""  Do
  .Set AnaestDr=$P($G(^OEORD(OEORDRowid,"I",SubRowid,4)),"^",9)
  .Q:AnaestDr=""
  .Set ItmMastDR=$P($G(^OEORD(OEORDRowid,"I",SubRowid,1)),"^",2)
  .Set ItmMastDesc=$P($G(^ARCIM(+ItmMastDR,1)),"^",2)
  .;w ItmMastDesc,!
  Q OEORDRowid
}

ClassMethod GetReloc() As %String
{
  //w ##class(web.DHCOperPrice).GetReloc()
  Set RetStr=""
  Set CTLOCRowid="0" For  Set CTLOCRowid=$O(^CTLOC(CTLOCRowid)) Q:CTLOCRowid=""  Do
  .Set CTLOCType=$P($G(^CTLOC(CTLOCRowid)),"^",13)
  .Q:CTLOCType'="E"
  .Set CTDesc=$P($G(^CTLOC(CTLOCRowid)),"^",2)	
  .Set CTDesc=$P(CTDesc,"-",2)
  .If RetStr="" Set RetStr=CTLOCRowid_$c(1)_CTDesc
  .Else  Set RetStr=RetStr_$c(2)_CTLOCRowid_$c(1)_CTDesc
  Q RetStr
}

ClassMethod FindOEORDByAdm(EpisodeID As %String, DHCANORowid As %String, UserID As %String, CTloc As %String)
{
  //w ##class(web.DHCOperPrice).FindOEORDByAdm("19340","430","3117","312")
  Set ^yjy(134)=EpisodeID_"^"_DHCANORowid_"^"_UserID
  Set OEORDRowId=$O(^OEORD(0,"Adm",EpisodeID,-1))
  Set OPERDr=$P(^DHCANOPArrange(DHCANORowid),"^",2)
  Set AppRowid=$P(^DHCANOPArrange(DHCANORowid),"^",41)
  If OEORDRowId="" Q "-1"
  Set ChildOEORDRowId=0 For  Set ChildOEORDRowId=$O(^OEORD(OEORDRowId,"I",ChildOEORDRowId)) Q:ChildOEORDRowId=""  Do
  .Set AnaestDR=$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,4)),"^",9)
  .;b
  .q:AnaestDR'=OPERDr
  .Set ItmMast=$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",2)
  .q:ItmMast="undefined"  //ck20101222 数据报错
  .Set OEORIItemStat=$p($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",13)
  .Set OEState=$p($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",13)
  .;b
  .Q:OEORIItemStat="4"
  .Set ItmDesc=$P(^ARCIM($P(ItmMast,"||",1),$P(ItmMast,"||",2),1),"^",2)
  .Set ItmCode=$P(^ARCIM($P(ItmMast,"||",1),$P(ItmMast,"||",2),1),"^",1)
  .Set UserDepartme=$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,7)),"^",2)
  .;Q:$G(UserDepartme)'=CTloc
  .Set AppointmentDate=$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",9)
  .Set sttdate=AppointmentDate
  .If (AppointmentDate'="") Set AppointmentDate=$ZD(AppointmentDate,3)
  .Set AppointmentTime=$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",10)
  .If AppointmentTime'="" Set AppointmentTime=$ZT(AppointmentTime,3)
  .Set TDate=$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,3)),"^",7)
  .If TDate'="" Set TDate=$ZD(TDate,3)
  .Set TTime=$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",17)
  .If TTime'="" Set TTime=$ZT(TTime,3)
  .Set AdmType=$P(^PAADM(EpisodeID),"^",2)
  .If AdmType="O" Set AdmType="门诊"
  .If AdmType="I" Set AdmType="住院"
  .If AdmType="E" Set AdmType="急诊"
  .Set AdmReason=$P($G(^PAADM(EpisodeID,1)),"^",7)
  .Set CheckPrice=..CheckTar(OEORDRowId,ChildOEORDRowId,EpisodeID,ItmMast,AdmReason,"",UserID,AppRowid)
  .Set Price=##class(web.DHCDocOrderEntry).GetOrderPrice("", AdmReason, ItmMast, "", "", "", "", "") 
  .Set Price=$P(Price,"^",1)
  .Set Price=$j(Price,3,2)
  .Set QtyNum=$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",12)
  .Set PriceStatus=..CheckStatus(OEORDRowId,ChildOEORDRowId,EpisodeID)
  .;w "PriceStatus="_PriceStatus,!
  .Set SumPrice=QtyNum*Price
  .Set SumPrice=$j(SumPrice,3,2)
  .Set ChangePrice="修改"
  .Set OEORDRowid=OEORDRowId_"||"_ChildOEORDRowId
  .Set EXRowid=$O(^DHCEXDE(0,"OEORI",EpisodeID,OEORDRowid,-1))
  .If EXRowid'="" d
  ..Set Price=..GetPrice(EpisodeID,OEORDRowid)
  ..Set SumPrice=Price*QtyNum
  ..Set SumPrice=$j(SumPrice,3,2)
  .Set OEORDDr=OEORDRowId_"||"_ChildOEORDRowId
  .Set DoseUOM=$p($g(^OEORD(OEORDRowId,"I",ChildOEORDRowId,2)),"^",3)
  .if DoseUOM'="" Set CTUOMDesc=$p(^CT("UOM",DoseUOM),"^",2)  
  .Else  Set CTUOMDesc=""
  .Set ReLocRowid=$p($g(^OEORD(OEORDRowId,"I",ChildOEORDRowId,3)),"^",6)
  .Set ReLoc=$p($g(^CTLOC(ReLocRowid)),"^",2) s ReLoc=$p(ReLoc,"-",2)
  .Set OEORDDate=$p($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,11)),"^",4)
  .Set OEORDDate=$Zd(OEORDDate,3)
  .Set OEORDTime=$p($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,11)),"^",5)
  .Set OEORDTime=$ZT(OEORDTime,1)
  .Set OEORDUser=$p($g(^OEORD(OEORDRowId,"I",ChildOEORDRowId,7)),"^",1)
  .Set OEORDUserDesc=$P(^SSU("SSUSR",OEORDUser),"^",2)
  .if (PriceStatus'="")&(EXRowid'="") Do
  ..if $P($G(^DHCEXDE(EXRowid)),"^",11)'="" Set OEORDDate=$ZD($P($G(^DHCEXDE(EXRowid)),"^",11),3)
  ..if $P($G(^DHCEXDE(EXRowid)),"^",12)'="" Set OEORDTime=$ZT($P($G(^DHCEXDE(EXRowid)),"^",12),1)
  .Set PriceStatus=$P($G(^DHCEXDE(EXRowid)),"^",17)
  .if PriceStatus="" Set PriceStatus="未划价"
  .if (PriceStatus="0") Set PriceStatus="已划价"
  .if PriceStatus=1 Set PriceStatus="已收费"
  .if PriceStatus="F" Set PriceStatus="退费"
  .Set str=ItmDesc_"^"_ItmMast_"^"_QtyNum_"^"_Price_"^"_SumPrice_"^"_CTUOMDesc_"^"_OEORDDr_"^"_ReLoc_"^"_OEORDDate_"^"_OEORDTime_"^"_OEORDUserDesc_"^"_PriceStatus_"^"_$g(PriceCode)
  .Set retval="OEORDList"_"('"_$ZCVT(str,"O","JS")_"');"
  .&javascript<#(retval)#>
}

ClassMethod CheckTar(OEORDRowId As %String, ChildOEORDRowId As %String, EpisodeID As %String, arcim As %String, AdmReason As %String, sttdate As %String, UserID As %String, AppRowid As %String) As %String
{
  Set EXRowid=$O(^DHCEXDE(0,"OEORI",EpisodeID,OEORDRowId_"||"_ChildOEORDRowId,-1))
  Set ^yjy(99)=AppRowid
  Set Price=0,DiscPrice=0,InsPrice=0,PatPrice=0,HVCNo=""
  Set ExecuDate="",sttdate=+$h
  If EXRowid="" D
  .For  Set ExecuDate=$o( ^DHCOLT(0,"ARCIM",arcim,"Z",ExecuDate)) q:ExecuDate=""  d
  ..q:ExecuDate>sttdate
  ..;b //ccq12
  ..Set OLT=""
  ..For  Set OLT=$O(^DHCOLT(0,"ARCIM",arcim,"Z",ExecuDate,OLT)) q:OLT=""  d
  ...Set EndDate=$P(^DHCOLT(OLT),"^",5)
  ...If EndDate="" Set EndDate=+$H+1
  ...Quit:EndDate<sttdate
  ...;b //ccq13
  ...Set OrdQty=$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",12)  
  ...Set qty0=$P(^DHCOLT(OLT),"^",3)
  ...Set Itm=$P(^DHCOLT(OLT),"^",2)
  ...Set err=##class(web.UDHCJFPRICE).GetItmPrice(Itm,sttdate,AdmReason,"","")
  ...;set err=##class(web.DHCDocOrderEntry).GetOrderPrice("", AdmReason, arcim, "", "", "", "", "")
  ...set ^DHCCCQ(EpisodeID,"Price",$h)=err_"#"_AdmReason
  ...Set Price=$P(err,"^",1)  ;*qty0
  ...Set DiscPrice=$P(err,"^",2)*qty0
  ...Set InsPrice=$P(err,"^",3)*qty0
  ...Set PatPrice=$P(err,"^",4)*qty0 
  ...Set qty0=qty0*OrdQty
  ...Set EXCosts=Price*qty0
  ...Set ^yjy(34,1)=EXCosts_"^"_OrdQty_"^"_qty0
  ...Set EXDoctorDr =$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",11)
  ...Set EXOrdDeptDr =$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",3)  
  ...Set EXRecDeptDr =$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,3)),"^",6) 
  ...set OEORDDr=OEORDRowId_"||"_ChildOEORDRowId
  ...Set BillDate=+$h
  ...Set BillTime=$P($h,",",2)
  ...;b //ccq3
  ...Quit:'$D(^DHCTARIi("TARI",Itm))
  ...;b //cccq
  ...;&sql(Insert into SQLUSER.DHC_ExamDetails Set EX_Adm_Dr=:EpisodeID,EX_Oeori_Dr=:OEORDDr,EX_Tari_Dr=:Itm,EX_Price=:Price,EX_Amount=:qty0,EX_Costs=:EXCosts,EX_Billing_Date=:BillDate,EX_Billing_Time=:BillTime,EX_User_Dr=:UserID,EX_Doctor_Dr=:EXDoctorDr,EX_OrdDept_Dr=:EXOrdDeptDr,EX_RecDept_Dr=:EXRecDeptDr)
  ...Set HVCNo=$p($g(^OEORD(OEORDRowId,"I",ChildOEORDRowId,12)),"^",61)   //高值耗材条码
  ...i HVCNo'="" Set ^DHCANHVCDetail(BillDate,BillTime,OEORDRowId_"||"_ChildOEORDRowId)=HVCNo_"^"_EpisodeID
  ...;b //ccq2
  ...If $D(^DHCEXDEItem(AppRowid,"OEORI",OEORDDr,0)) Do
  ....Set ItemNo=^DHCEXDEItem(AppRowid,"OEORI",OEORDDr,0)+1
  ....Set ^DHCEXDEItem(AppRowid,"OEORI",OEORDDr,ItemNo)=%ROWID
  ....Set ^DHCEXDEItem(AppRowid,"OEORI",OEORDDr,0)=ItemNo
  ...If '$D(^DHCEXDEItem(AppRowid,"OEORI",OEORDDr,0)) Do
  ....Set ^DHCEXDEItem(AppRowid,"OEORI",OEORDDr,0)=1
  ....Set ^DHCEXDEItem(AppRowid,"OEORI",OEORDDr,1)=%ROWID
  q 0
}

ClassMethod GetPrice(EpisodeID, OEORDRowid) As %String
{
	Set Price=0
	Set EXRowid="" For  Set EXRowid=$O(^DHCEXDE(0,"OEORI",EpisodeID,OEORDRowid,EXRowid)) Q:EXRowid=""  d
	.Set EXPrice=$P($G(^DHCEXDE(EXRowid)),"^",9)
	.Set EXAmount=$P($G(^DHCEXDE(EXRowid)),"^",8)
	.Q:$P($G(^DHCEXDE(EXRowid)),"^",18)="F"
	.Set Price=Price+$j((EXPrice),3,3)
	Set Price=$j(Price,3,2)
	q Price
}

ClassMethod GetPriceHVC(EpisodeID, OEORDRowid) As %String
{
	Set Price=0
	Set EXRowid="" For  Set EXRowid=$O(^DHCEXDE(0,"OEORI",EpisodeID,OEORDRowid,EXRowid)) Q:EXRowid=""  d
	.Set EXPrice=$P($G(^DHCEXDE(EXRowid)),"^",9)
	.Set EXAmount=$P($G(^DHCEXDE(EXRowid)),"^",8)
	.;Q:$P($G(^DHCEXDE(EXRowid)),"^",18)="F"
	.Set Price=Price+$j((EXPrice),3,3)
	Set Price=$j(Price,3,2)
	q Price
}

ClassMethod CheckStatus(OEORDRowId As %String, ChildOEORDRowId As %String, EpisodeID As %String) As %String
{
	Set Flag=0
	Set EXOeoriDr=OEORDRowId_"||"_ChildOEORDRowId
	Set EXRowid="" For  Set EXRowid=$O(^DHCEXDE(0,"OEORI",EpisodeID,EXOeoriDr,EXRowid))  Q:EXRowid=""  Do
	.Set EXAStatus=$P($G(^DHCEXDE(EXRowid)),"^",17)
	.If (EXAStatus="") Set Flag=""
	.Else  Set Flag=1
	Quit Flag
}

ClassMethod SavePrice(EpisodeID As %String, DHCOPERNO As %String, UserID As %String) As %String
{
  //w ##class(web.DHCOperPrice).SavePrice("1519313","20590","3819")
  Set PriceList=""
  Set SetActiveStr=""
  Set CHARGEITEMNO=0
  Set OEORDItemCount=1
  Set ANADr=$P(^DHCANOPArrange(DHCOPERNO),"^",2)
  Set EXOeoriDr="" For  Set EXOeoriDr=$O(^DHCEXDE(0,"OEORI",EpisodeID,EXOeoriDr)) Q:EXOeoriDr=""  Do
  .Set EXRowid=""  For  Set EXRowid=$O(^DHCEXDE(0,"OEORI",EpisodeID,EXOeoriDr,EXRowid))  Q:EXRowid=""  Do
  ..Set EXStatus=$P($G(^DHCEXDE(EXRowid)),"^",18)
  ..Set AppRowid=$P(^DHCANOPArrange(DHCOPERNO),"^",41)
  ..Set AnaestDR=$P($G(^OEORD(+EXOeoriDr,"I",$P(EXOeoriDr,"||",2),4)),"^",9)
  ..Q:ANADr'=AnaestDR
  ..Set OEState=$p($G(^OEORD(+EXOeoriDr,"I",$P(EXOeoriDr,"||",2),1)),"^",13)
  ..Q:OEState=4
  ..Set EXBillingAttr=$P($G(^DHCEXDE(EXRowid)),"^",17)
  ..Set EXTariDr=$P($G(^DHCEXDE(EXRowid)),"^",7)
  ..Q:EXTariDr=""
  ..Set OPERATORNO="",ITEMCODE=""
  ..Set ItemSubCate=$P($G(^DHCTARI(EXTariDr)),"^",4)
  ..Set ITEMNAME=$P($G(^DHCTARI(EXTariDr)),"^",2)
  ..Set ITEMNAME=$TR(ITEMNAME,"[")
  ..Set ITEMNAME=$TR(ITEMNAME,"]")
  ..Set ITEMCLASSDR=$P($G(^DHCTARI(EXTariDr)),"^",4)
  ..Set ITEMCLASS=$P($G(^DHCTarC("CC",ITEMCLASSDR)),"^",1)
  ..If (ItemSubCate=3)||(ItemSubCate=4) Set ITEMCODE=$P($G(^DHCTARI(EXTariDr)),"^",1)
  ..Else  Set ITEMCODE=$P($G(^DHCTARI(EXTariDr)),"^",13)
  ..Set PHCDRowid=""
  ..If (ItemSubCate=3)||(ItemSubCate=4) d
  ...Set PHCDRowid=$O(^PHCD(0,"Code",ITEMCODE,-1))
  ...Q:PHCDRowid=""
  ...Set GenRowid=$P($G(^PHCD(PHCDRowid,4)),"^",1)
  ...Set ITEMCODE=$P($G(^PHCGE("GE",GenRowid)),"^",1)
  ..Set GenericDR=$P($G(^ARCIM(EXTariDr,1,8)),"^",20)
  ..Set ITEMSPEC=""
  ..If (ItemSubCate'=3)&(ItemSubCate'=4) d
  ...Set ITEMSPEC=$P($G(^DHCTARI(EXTariDr)),"^",21)
  ..If (ItemSubCate=3)||(ItemSubCate=4) d
  ...Set ITEMCODE1=$P($G(^DHCTARI(EXTariDr)),"^",1)
  ...Set INCIRowid=$O(^INCI(0,"Code",ITEMCODE1,-1))
  ...Q:INCIRowid=""
  ...Set INFORowid=$O(^DHCITMINFO(0,"INCI",INCIRowid,-1))
  ...Q:INFORowid=""
  ...Set ITEMSPEC=$P($G(^DHCITMINFO(INFORowid)),"^",27)
  ..If ITEMCODE="" Set ITEMCODE=$P($G(^DHCTARI(EXTariDr)),"^",1)
  ..Set TARIUOMDr=$P($G(^DHCTARI(EXTariDr)),"^",3)
  ..Set AMOUNT=$P($G(^DHCEXDE(EXRowid)),"^",8)
  ..Set UNITS=$P($G(^CT("UOM",TARIUOMDr)),"^",2)
  ..set CHECKFLOW=$P(^DHCANOPArrange(DHCOPERNO),"^",41) 
  ..Q:CHECKFLOW=""
  ..Set EXAMITEMNO=OEORDItemCount
  ..Set OEORDItemCount=OEORDItemCount+1
  ..;Q:EXAMITEMNO=""
  ..Set PATIENTInfo=##class(web.DHCENS.PatientInfo).GetHisAdmByPaadm(EpisodeID)
  ..Set PATIENTID=""
  ..If $p(^PAADM(EpisodeID),"^",2)="O" d
  ...Set PATIENTID=$P(PATIENTInfo,"^",1)
  ...Set VISITID=""
  ..If $p(^PAADM(EpisodeID),"^",2)="I" d
  ...Set PATIENTID=$P(PATIENTInfo,"^",1)
  ...Set VISITID=$P(PATIENTInfo,"^",3)
  ..Set OEORIOrdDeptDR=$P($G(^OEORD(+EXOeoriDr,"I",$P(EXOeoriDr,"||",2),7)),"^",2)
  ..Set ORDEREDBY=$P($G(^CTLOC(OEORIOrdDeptDR)),"^",1)
  ..Set RecDept=$P($G(^DHCEXDE(EXRowid)),"^",16)
  ..Set PERFORMEDBY="" ;
  ..Set PERFORMEDBYDr=$P($G(^OEORD(+EXOeoriDr,"I",$P(EXOeoriDr,"||",2),3)),"^",6)
  ..If PERFORMEDBYDr'="" Set PERFORMEDBY=$P($G(^CTLOC(PERFORMEDBYDr)),"^",1)
  ..Set COSTS=$P($G(^DHCEXDE(EXRowid)),"^",10)
  ..Set CHARGES=$J((COSTS*AMOUNT),3,2)
  ..Set BILLINGTIME=$P($G(^DHCEXDE(EXRowid)),"^",12)
  ..Set EXBillingDate=$P($G(^DHCEXDE(EXRowid)),"^",11)
  ..Set BILLINGDATETIME=$TR($ZD(EXBillingDate,3),"-")_$TR($ZT(BILLINGTIME),":")
  ..Set OPERATORNODr=$P($G(^DHCEXDE(EXRowid)),"^",14)
  ..If OPERATORNODr'="" Set OPERATORNO=$P($G(^CTPCP(OPERATORNODr,1)),"^",1)
  ..;Set OPERATORNODr=$P($G(^DHCEXDE(EXRowid)),"^",13)
  ..;If OPERATORNODr'="" Set OPERATORNO=$P($G(^SSU("SSUSR",OPERATORNODr)),"^",1)
  ..Set VERIFIEDINDICATOR="01 "
  ..Set DoctorName=""
  ..Set DoctorDr=$P($G(^OEORD(+EXOeoriDr,"I",$P(EXOeoriDr,"||",2),1)),"^",11)
  ..If DoctorDr'="" Set DoctorName=$P($g(^CTPCP(DoctorDr,1)),"^",2)
  ..Set BILLINGATTR="0"
  ..If $P($G(^DHCEXDE(EXRowid)),"^",17)="1" Set BILLINGATTR="1" 
  ..Set Status="A" 
  ..if EXStatus="F" Set Status="F" 
  ..Set DHCKey=EXRowid
  ..If (ItemSubCate=3)||(ItemSubCate=4) Set ITEMNAME=$TR(ITEMNAME,ITEMSPEC)
  ..If $p(^PAADM(EpisodeID),"^",2)="O" Do
  ...;Set CHARGEITEMNO=CHARGEITEMNO+1
  ...Set CHARGEITEMNO=""
  ...Set ItemNoRwoid=0 For  Set ItemNoRwoid=$O(^DHCEXDEItem(AppRowid,"OEORI",EXOeoriDr,ItemNoRwoid)) Q:ItemNoRwoid=""  Do
  ....Set ItemNoAppRowid=^DHCEXDEItem(AppRowid,"OEORI",EXOeoriDr,ItemNoRwoid)
  ....If ItemNoAppRowid=EXRowid Set CHARGEITEMNO=ItemNoRwoid
  ...set CHECKFLOW=$P(^DHCANOPArrange(DHCOPERNO),"^",41)
  ...Set PriceList=PriceList_"<OutBillItemsOper>"
  ...Set PriceList=PriceList_"<OperaApplyFlow>"_CHECKFLOW_"</OperaApplyFlow>"
  ...Set PriceList=PriceList_"<OperItemNo>"_EXAMITEMNO_"</OperItemNo>"
  ...Set PriceList=PriceList_"<ChargeItemNo>"_CHARGEITEMNO_"</ChargeItemNo>"
  ...Set PriceList=PriceList_"<PatientId>"_PATIENTID_"</PatientId>"
  ...Set PriceList=PriceList_"<VisitId>"_VISITID_"</VisitId>"
  ...Set PriceList=PriceList_"<ItemClass>"_ITEMCLASS_"</ItemClass>"
  ...Set PriceList=PriceList_"<ItemName>"_ITEMNAME_"</ItemName>"
  ...Set PriceList=PriceList_"<ItemCode>"_ITEMCODE_"</ItemCode>"
  ...Set PriceList=PriceList_"<ItemSpec>"_ITEMSPEC_"</ItemSpec>"
  ...Set PriceList=PriceList_"<Amount>"_AMOUNT_"</Amount>"
  ...Set PriceList=PriceList_"<Units>"_UNITS_"</Units>"
  ...Set PriceList=PriceList_"<OrderedBy>"_ORDEREDBY_"</OrderedBy>"
  ...Set PriceList=PriceList_"<PerformedBy>"_PERFORMEDBY_"</PerformedBy>"
  ...Set PriceList=PriceList_"<Costs>"_COSTS_"</Costs>"
  ...Set PriceList=PriceList_"<Charges>"_CHARGES_"</Charges>"
  ...Set PriceList=PriceList_"<BillingDateTime>"_BILLINGDATETIME_"</BillingDateTime>"
  ...Set PriceList=PriceList_"<OperatorNo>"_OPERATORNO_"</OperatorNo>"
  ...Set PriceList=PriceList_"<VerifiedIndicator>"_VERIFIEDINDICATOR_"</VerifiedIndicator>"
  ...Set PriceList=PriceList_"<DoctorName>"_DoctorName_"</DoctorName>"
  ...Set PriceList=PriceList_"<BillingAttr>"_BILLINGATTR_"</BillingAttr>"
  ...Set PriceList=PriceList_"<Status>"_Status_"</Status>"
  ...Set PriceList=PriceList_"<DhcKey>"_DHCKey_"</DhcKey>"
  ...Set PriceList=PriceList_"</OutBillItemsOper>"
  
  ..If $p(^PAADM(EpisodeID),"^",2)="I" Do
  ...;Set CHARGEITEMNO=CHARGEITEMNO+1
  ...Set CHARGEITEMNO=""
  ...Set ItemNoRwoid=0 For  Set ItemNoRwoid=$O(^DHCEXDEItem(AppRowid,"OEORI",EXOeoriDr,ItemNoRwoid)) Q:ItemNoRwoid=""  Do
  ....Set ItemNoAppRowid=^DHCEXDEItem(AppRowid,"OEORI",EXOeoriDr,ItemNoRwoid)
  ....If ItemNoAppRowid=EXRowid Set CHARGEITEMNO=ItemNoRwoid
  ...if EXStatus="F" Set AMOUNT=-AMOUNT,COSTS=-COSTS
  ...set CHECKFLOW=$P(^DHCANOPArrange(DHCOPERNO),"^",41)
  ...Set PriceList=PriceList_"<InpBilldetailOper>"
  ...Set PriceList=PriceList_"<OperaApplyFlow>"_CHECKFLOW_"</OperaApplyFlow>"
  ...Set PriceList=PriceList_"<OperItemNo>"_EXAMITEMNO_"</OperItemNo>"
  ...Set PriceList=PriceList_"<ChargeItemNo>"_CHARGEITEMNO_"</ChargeItemNo>"
  ...Set PriceList=PriceList_"<PatientId>"_PATIENTID_"</PatientId>"
  ...Set PriceList=PriceList_"<VisitId>"_VISITID_"</VisitId>"
  ...Set PriceList=PriceList_"<ItemNo>"_EXAMITEMNO_"</ItemNo>"
  ...Set PriceList=PriceList_"<ItemClass>"_ITEMCLASS_"</ItemClass>"
  ...Set PriceList=PriceList_"<ItemName>"_ITEMNAME_"</ItemName>"
  ...Set PriceList=PriceList_"<ItemCode>"_ITEMCODE_"</ItemCode>"
  ...Set PriceList=PriceList_"<ItemSpec>"_ITEMSPEC_"</ItemSpec>"
  ...Set PriceList=PriceList_"<Amount>"_AMOUNT_"</Amount>"
  ...Set PriceList=PriceList_"<Units>"_UNITS_"</Units>"
  ...Set PriceList=PriceList_"<OrderedBy>"_ORDEREDBY_"</OrderedBy>"
  ...Set PriceList=PriceList_"<PerformedBy>"_PERFORMEDBY_"</PerformedBy>"
  ...Set PriceList=PriceList_"<Costs>"_COSTS_"</Costs>"
  ...Set PriceList=PriceList_"<Charges>"_CHARGES_"</Charges>"
  ...Set PriceList=PriceList_"<BillingDateTime>"_BILLINGDATETIME_"</BillingDateTime>"
  ...Set PriceList=PriceList_"<OperatorNo>"_OPERATORNO_"</OperatorNo>"
  ...Set PriceList=PriceList_"<DhcPbd>"_DHCKey_"</DhcPbd>"
  ...Set PriceList=PriceList_"<DoctorName>"_DoctorName_"</DoctorName>"
  ...Set PriceList=PriceList_"</InpBilldetailOper>"
  ..Set SetActiveStr=SetActiveStr_"^"_EXRowid

  if PriceList="" q "-100"
  If $p(^PAADM(EpisodeID),"^",2)="O" Do
  .Set Str="<Request><OutBillItemsOperList>"
  .Set Str=Str_PriceList_"</OutBillItemsOperList></Request>"
  .s StreamTarStr=##class(%GlobalCharacterStream).%New()
  .s StreamSendTarFlag=##class(%GlobalCharacterStream).%New()
  .d StreamTarStr.Write(Str)
  .s obj=##class(web.DHCENS.WebService.DHCSoap).%New()
  .s StreamSendTarFlag=obj.DhcService("OutBillItemsOper",StreamTarStr)
  .d StreamSendTarFlag.Rewind()
  .s Len=StreamSendTarFlag.SizeGet()
  .d StreamSendTarFlag.Rewind()
  .s SendTarFlag=StreamSendTarFlag.Read(Len)
  .Set PAADMType1=$p(^PAADM(EpisodeID),"^",2)
  .Set SendTarFlag=$P(SendTarFlag,"Returncode>",2)
  .If (SendTarFlag="0</") Set ActiveFlag=..SetStatus(SetActiveStr,PAADMType1,UserID)
 
  if PriceList="" q "-100"
  If $p(^PAADM(EpisodeID),"^",2)="I" Do
  .Set Str="<Request><InpBilldetailOperList>"
  .Set Str=Str_PriceList_"</InpBilldetailOperList></Request>"
  .s StreamTarStr=##class(%GlobalCharacterStream).%New()
  .s StreamSendTarFlag=##class(%GlobalCharacterStream).%New()
  .d StreamTarStr.Write(Str)
  .s obj=##class(web.DHCENS.WebService.DHCSoap).%New()
  .s StreamSendTarFlag=obj.DhcService("InpBilldetailOper",StreamTarStr)
  .d StreamSendTarFlag.Rewind()
  .s Len=StreamSendTarFlag.SizeGet()
  .d StreamSendTarFlag.Rewind()
  .s SendTarFlag=StreamSendTarFlag.Read(Len)
  .Set PAADMType1=$p(^PAADM(EpisodeID),"^",2)
  .Set SendTarFlag=$P(SendTarFlag,"Returncode>",2)
  .If (SendTarFlag="0</") Set ActiveFlag=..SetStatus(SetActiveStr,PAADMType1,UserID)
   q SendTarFlag
}

ClassMethod GetOperPriceInfo(EpisodeID As %String, DHCANORowid As %String, USERID As %String, LocId As %String) As %String
{
	//w ##class(web.DHCOperPrice).GetOperPriceInfo("17794","483","3117","312")
    Set RetStr=""
    Set ^yjy("Oper")=EpisodeID_"^"_DHCANORowid_"^"_USERID_"^"_LocId
    Q:'$D(^DHCPRICELIMIT) ""
	;If '$D(^DHCPRICELIMIT("USER",USERID)) Q RetStr
	Set OEORDRowId=$O(^OEORD(0,"Adm",EpisodeID,-1))
    Set OPERDr=$P(^DHCANOPArrange(DHCANORowid),"^",2)
    Set AppRowid=$P(^DHCANOPArrange(DHCANORowid),"^",41)
    If OEORDRowId="" Q "-1"
    Set ChildOEORDRowId=0 For  Set ChildOEORDRowId=$O(^OEORD(OEORDRowId,"I",ChildOEORDRowId)) Q:ChildOEORDRowId=""  Do
   .Set AnaestDR=$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,4)),"^",9)
   .q:AnaestDR'=OPERDr
   .Set ItmMast=$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",2)
   .Set OEORIItemStat=$p($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",13)
   .Set OEState=$p($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",13)
   .Q:OEORIItemStat="4"
   .Set ExaTarInfo=""
   .Set OEORDDr=OEORDRowId_"||"_ChildOEORDRowId
   .Set ExaRowid="" For  Set ExaRowid=$O(^DHCEXDE(0,"OEORI",EpisodeID,OEORDDr,ExaRowid))  Q:ExaRowid=""  Do
   ..Q:ExaRowid=""
   ..Set EXBillingAttr=$P($G(^DHCEXDE(ExaRowid)),"^",17)
   ..If EXBillingAttr="1" Do
   ...Set EXTariDr=$P($G(^DHCEXDE(ExaRowid)),"^",7)
   ...Set TarItemDesc=$P($G(^DHCTARI(EXTariDr)),"^",2)
   ...Set EXAmount=$P($G(^DHCEXDE(ExaRowid)),"^",8)
   ...Q:EXAmount=0
   ...Set EXPrice=$P($G(^DHCEXDE(ExaRowid)),"^",9)
	...Set EXCosts=$P($G(^DHCEXDE(ExaRowid)),"^",10)
	...set EXId=ExaRowid
	...If ExaTarInfo'="" Set ExaTarInfo=ExaTarInfo_$c(2)_EXId_$c(1)_TarItemDesc_"  "_EXAmount_"X"_EXPrice_"元   小计:"_EXCosts_"元"_$c(1)_OEORDDr
	...Else  Set ExaTarInfo=EXId_$c(1)_TarItemDesc_"  "_EXAmount_"X"_EXPrice_"元   小计:"_EXCosts_"元"_$c(1)_OEORDDr
	.If ExaTarInfo'="" Do
	..Set ArcimDr=$P($G(^OEORD(+OEORDDr,"I",$P(OEORDDr,"||",2),1)),"^",2)
	..Set ArcimDesc=$P($G(^ARCIM(+ArcimDr,1,1)),"^",2)
	..Set OEORDStr=OEORDDr_$c(1)_ArcimDesc_$c(1)_"O"
	..Set RetStr=RetStr_$c(2)_OEORDStr_$c(2)_ExaTarInfo
	Q RetStr
}

ClassMethod SetStatus(SetActiveStr As %String, PAADMType As %String, UserID As %String) As %String
{
	Set Flag=0
	Set NowDate=+$h
	Set NowTime=$P($h,",",2)
	Tstart
	For i=2:1:$L(SetActiveStr,"^") Do
	.Set ExaRowid=$P(SetActiveStr,"^",i)
	.Set EXStatus=$P($G(^DHCEXDE(ExaRowid)),"^",18)
	.Set EXBillingAttr=$P($G(^DHCEXDE(ExaRowid)),"^",17)
	.Set NowDate=+$h
	.Set NowTime=$P($h,",",2)
	.Q:EXBillingAttr'=""
	.Q:EXStatus="F"
	.Q:ExaRowid=""
	.if PAADMType="I" do
	..;&sql(Update SQLUSER.DHC_ExamDetails Set EX_Status='A',EX_Billing_Attr='1',EX_Billing_Date=:NowDate,EX_Billing_Time=:NowTime,EX_chargeUser_Dr=:UserID,EX_Billingcharge_Date=:NowDate,EX_Billingcharge_Time=:NowTime Where EX_Rowid=:ExaRowid)
	..If (SQLCODE=0) d  Set Flag=1
	..Else  TRollback
	.if PAADMType="O" do
	..;&sql(Update SQLUSER.DHC_ExamDetails Set EX_Status='A',EX_Billing_Attr='0',EX_Billing_Date=:NowDate,EX_Billing_Time=:NowTime,EX_chargeUser_Dr=:UserID,EX_Billingcharge_Date=:NowDate,EX_Billingcharge_Time=:NowTime Where EX_Rowid=:ExaRowid)
	..If (SQLCODE=0) d  Set Flag=1
	..Else  TRollback
	TC
	Q Flag
}

ClassMethod SetHVCStatus(SetActiveStr As %String, PAADMType As %String, UserID As %String) As %String
{
	Set Flag=0
	Set NowDate=+$h
	Set NowTime=$P($h,",",2)
	Tstart
	For i=2:1:$L(SetActiveStr,"^") Do
	.Set ExaRowid=$P(SetActiveStr,"^",i)
	.Set EXStatus=$P($G(^DHCEXDE(ExaRowid)),"^",18)
	.Set EXBillingAttr=$P($G(^DHCEXDE(ExaRowid)),"^",17)
	.Set NowDate=+$h
	.Set NowTime=$P($h,",",2)
	.Q:EXBillingAttr'=""
	.Q:EXStatus="F"
	.Q:ExaRowid=""
	.if PAADMType="I" do
	..;&sql(Update SQLUSER.DHC_ExamDetails Set EX_Status='K',EX_Billing_Attr='1',EX_Billing_Date=:NowDate,EX_Billing_Time=:NowTime,EX_chargeUser_Dr=:UserID,EX_Billingcharge_Date=:NowDate,EX_Billingcharge_Time=:NowTime Where EX_Rowid=:ExaRowid)
	..If (SQLCODE=0) d  Set Flag=1
	..Else  TRollback
	.if PAADMType="O" do
	..;&sql(Update SQLUSER.DHC_ExamDetails Set EX_Status='K',EX_Billing_Attr='0',EX_Billing_Date=:NowDate,EX_Billing_Time=:NowTime,EX_chargeUser_Dr=:UserID,EX_Billingcharge_Date=:NowDate,EX_Billingcharge_Time=:NowTime Where EX_Rowid=:ExaRowid)
	..If (SQLCODE=0) d  Set Flag=1
	..Else  TRollback
	TC
	Q Flag
}

ClassMethod ReturnFee(ReturnStr As %String, DHCANORowid As %String, EpisodeID As %String, Usrid As %String) As %String
{
   //w ##class(web.DHCOperPrice).ReturnFee("^^6656","70","19139","1")
  Set ^yjy(100)=ReturnStr
  Set PriceList=""
  Set SetActiveStr=""
  Set CHARGEITEMNO=0
  Set OEORDItemCount=1
  Set OEORDRowId=$O(^OEORD(0,"Adm",EpisodeID,-1))
  Set OPERDr=$P(^DHCANOPArrange(DHCANORowid),"^",2)
  Set AppRowid=$P(^DHCANOPArrange(DHCANORowid),"^",41)
  //2010-4-19上午,因退费时报Status未定义,因此在此定义一下,且赋空值
  Set Status=""
  If OEORDRowId="" Q "-1"
  Set ChildOEORDRowId=0 For  Set ChildOEORDRowId=$O(^OEORD(OEORDRowId,"I",ChildOEORDRowId)) Q:ChildOEORDRowId=""  Do
  .Set AnaestDR=$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,4)),"^",9)
  .q:AnaestDR'=OPERDr
  .Set ItmMast=$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",2)
  .Set OEORIItemStat=$p($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",13)
  .Set OEState=$p($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",13)
  .Q:OEORIItemStat="4"
  .Set ExaTarInfo=""
  .Set EXOeoriDr=OEORDRowId_"||"_ChildOEORDRowId
  .Set OEORDRowId=OEORDRowId
  .Set ChildOEORDRowId=ChildOEORDRowId
  .Set EXRowid=""  For  Set EXRowid=$O(^DHCEXDE(0,"OEORI",EpisodeID,EXOeoriDr,EXRowid))  Q:EXRowid=""  Do
  ..Set EXStatus=$P($G(^DHCEXDE(EXRowid)),"^",18)
  ..Set EXBillingAttr=$P($G(^DHCEXDE(EXRowid)),"^",17)
  ..Set EXTariDr=$P($G(^DHCEXDE(EXRowid)),"^",7)
  ..Q:EXTariDr=""
  ..Set OPERATORNO="",ITEMCODE=""
  ..Set ItemSubCate=$P($G(^DHCTARI(EXTariDr)),"^",4)
  ..Set ITEMNAME=$P($G(^DHCTARI(EXTariDr)),"^",2)
  ..Set ITEMNAME=$TR(ITEMNAME,"[")
  ..Set ITEMNAME=$TR(ITEMNAME,"]")
  ..Set ITEMCLASSDR=$P($G(^DHCTARI(EXTariDr)),"^",4)
  ..Set ITEMCLASS=$P($G(^DHCTarC("CC",ITEMCLASSDR)),"^",1)
  ..If (ItemSubCate=3)||(ItemSubCate=4) Set ITEMCODE=$P($G(^DHCTARI(EXTariDr)),"^",1)
  ..Else  Set ITEMCODE=$P($G(^DHCTARI(EXTariDr)),"^",13)
  ..Set PHCDRowid=""
  ..If (ItemSubCate=3)||(ItemSubCate=4) d
  ...Set PHCDRowid=$O(^PHCD(0,"Code",ITEMCODE,-1))
  ...Q:PHCDRowid=""
  ...Set GenRowid=$P($G(^PHCD(PHCDRowid,4)),"^",1)
  ...Set ITEMCODE=$P($G(^PHCGE("GE",GenRowid)),"^",1)
  ..Set GenericDR=$P($G(^ARCIM(EXTariDr,1,8)),"^",20)
  ..Set ITEMSPEC=""  
  ..If (ItemSubCate'=3)&(ItemSubCate'=4) d
  ...Set ITEMSPEC=$P($G(^DHCTARI(EXTariDr)),"^",21)
  ..If (ItemSubCate=3)||(ItemSubCate=4) d
  ...Set ITEMCODE1=$P($G(^DHCTARI(EXTariDr)),"^",1)
  ...Set INCIRowid=$O(^INCI(0,"Code",ITEMCODE1,-1))
  ...Q:INCIRowid=""
  ...Set INFORowid=$O(^DHCITMINFO(0,"INCI",INCIRowid,-1))
  ...Q:INFORowid=""
  ...Set ITEMSPEC=$P($G(^DHCITMINFO(INFORowid)),"^",27)
  ..If ITEMCODE="" Set ITEMCODE=$P($G(^DHCTARI(EXTariDr)),"^",1)
  ..Set TARIUOMDr=$P($G(^DHCTARI(EXTariDr)),"^",3)
  ..Set AMOUNT=$P($G(^DHCEXDE(EXRowid)),"^",8)
  ..Set UNITS=$P($G(^CT("UOM",TARIUOMDr)),"^",2)
  ..set CHECKFLOW=$P(^DHCANOPArrange(DHCANORowid),"^",41)
  ..Q:CHECKFLOW=""
  ..Set EXAMITEMNO=OEORDItemCount
  ..Set OEORDItemCount=OEORDItemCount+1
  ..Set PATIENTInfo=##class(web.DHCENS.PatientInfo).GetHisAdmByPaadm(EpisodeID)
  ..If $p(^PAADM(EpisodeID),"^",2)="O" d
  ...Set PATIENTID=$P(PATIENTInfo,"^",1)
  ...Set VISITID=""
  ..If $p(^PAADM(EpisodeID),"^",2)="I" d
  ...Set PATIENTID=$P(PATIENTInfo,"^",1)
  ...Set VISITID=$P(PATIENTInfo,"^",3)
  ..Set OEORIOrdDeptDR=$P($G(^OEORD(+EXOeoriDr,"I",$P(EXOeoriDr,"||",2),7)),"^",2)
  ..Set ORDEREDBY=$P($G(^CTLOC(OEORIOrdDeptDR)),"^",1)
  ..Set RecDept=$P($G(^DHCEXDE(EXRowid)),"^",16)
  ..Set PERFORMEDBY="" ;
  ..Set PERFORMEDBYDr=$P($G(^OEORD(+EXOeoriDr,"I",$P(EXOeoriDr,"||",2),3)),"^",6)
  ..If PERFORMEDBYDr'="" Set PERFORMEDBY=$P($G(^CTLOC(PERFORMEDBYDr)),"^",1)
  ..Set COSTS=$P($G(^DHCEXDE(EXRowid)),"^",10)
  ..Set CHARGES=$J((COSTS*AMOUNT),3,2)
  ..Set BILLINGTIME=$P($G(^DHCEXDE(EXRowid)),"^",12)
  ..Set EXBillingDate=$P($G(^DHCEXDE(EXRowid)),"^",11)
  ..Set BILLINGDATETIME=$TR($ZD(EXBillingDate,3),"-")_$TR($ZT(BILLINGTIME),":")
  ..Set OPERATORNODr=$P($G(^DHCEXDE(EXRowid)),"^",13)
  ..If OPERATORNODr'="" Set OPERATORNO=$P($G(^SSU("SSUSR",OPERATORNODr)),"^",1)
  ..Set VERIFIEDINDICATOR="01 "
  ..Set DoctorName=""
  ..Set DoctorDr=$P($G(^OEORD(+EXOeoriDr,"I",$P(EXOeoriDr,"||",2),1)),"^",11)
  ..If DoctorDr'="" Set DoctorName=$P($g(^CTPCP(DoctorDr,1)),"^",2)
  ..Set BILLINGATTR="0"
  ..If $P($G(^DHCEXDE(EXRowid)),"^",17)="1" Set BILLINGATTR="1" 
  ..if EXStatus'="F" Set Status="A" 
  ..Set DHCKey=EXRowid
  ..If (ItemSubCate=3)||(ItemSubCate=4) Set ITEMNAME=$TR(ITEMNAME,ITEMSPEC)
  ..If $p(^PAADM(EpisodeID),"^",2)="O" Do
  ...;Set CHARGEITEMNO=CHARGEITEMNO+1
  ...Set CHARGEITEMNO=""
  ...Set ItemNoRwoid=0 For  Set ItemNoRwoid=$O(^DHCEXDEItem(AppRowid,"OEORI",EXOeoriDr,ItemNoRwoid)) Q:ItemNoRwoid=""  Do
  ....Set ItemNoAppRowid=^DHCEXDEItem(AppRowid,"OEORI",EXOeoriDr,ItemNoRwoid)
  ....If ItemNoAppRowid=EXRowid Set CHARGEITEMNO=ItemNoRwoid
  ...Set RetFlag=0
  ...For l=1:1:$L(ReturnStr,"^") Do
  ....Set RetRowid=$P(ReturnStr,"^",l)
  ....If RetRowid=EXRowid Set RetFlag=1
  ...if RetFlag=1 Set Status="F",OPERATORNO=Usrid
   ...Set PriceList=PriceList_"<OutBillItemsOper>"
  ...Set PriceList=PriceList_"<OperaApplyFlow>"_CHECKFLOW_"</OperaApplyFlow>"
  ...Set PriceList=PriceList_"<OperItemNo>"_EXAMITEMNO_"</OperItemNo>"
  ...Set PriceList=PriceList_"<ChargeItemNo>"_CHARGEITEMNO_"</ChargeItemNo>"
  ...Set PriceList=PriceList_"<PatientId>"_PATIENTID_"</PatientId>"
  ...Set PriceList=PriceList_"<VisitId>"_VISITID_"</VisitId>"
  ...Set PriceList=PriceList_"<ItemClass>"_ITEMCLASS_"</ItemClass>"
  ...Set PriceList=PriceList_"<ItemName>"_ITEMNAME_"</ItemName>"
  ...Set PriceList=PriceList_"<ItemCode>"_ITEMCODE_"</ItemCode>"
  ...Set PriceList=PriceList_"<ItemSpec>"_ITEMSPEC_"</ItemSpec>"
  ...Set PriceList=PriceList_"<Amount>"_AMOUNT_"</Amount>"
  ...Set PriceList=PriceList_"<Units>"_UNITS_"</Units>"
  ...Set PriceList=PriceList_"<OrderedBy>"_ORDEREDBY_"</OrderedBy>"
  ...Set PriceList=PriceList_"<PerformedBy>"_PERFORMEDBY_"</PerformedBy>"
  ...Set PriceList=PriceList_"<Costs>"_COSTS_"</Costs>"
  ...Set PriceList=PriceList_"<Charges>"_CHARGES_"</Charges>"
  ...Set PriceList=PriceList_"<BillingDateTime>"_BILLINGDATETIME_"</BillingDateTime>"
  ...Set PriceList=PriceList_"<OperatorNo>"_OPERATORNO_"</OperatorNo>"
  ...Set PriceList=PriceList_"<VerifiedIndicator>"_VERIFIEDINDICATOR_"</VerifiedIndicator>"
  ...Set PriceList=PriceList_"<DoctorName>"_DoctorName_"</DoctorName>"
  ...Set PriceList=PriceList_"<BillingAttr>"_BILLINGATTR_"</BillingAttr>"
  ...Set PriceList=PriceList_"<Status>"_Status_"</Status>"
  ...Set PriceList=PriceList_"<DhcKey>"_DHCKey_"</DhcKey>"
  ...Set PriceList=PriceList_"</OutBillItemsOper>"
  
  ..If $p(^PAADM(EpisodeID),"^",2)="I" Do
  ...;Set CHARGEITEMNO=CHARGEITEMNO+1
  ...Set CHARGEITEMNO=""
  ...Set ItemNoRwoid=0 For  Set ItemNoRwoid=$O(^DHCEXDEItem(AppRowid,"OEORI",EXOeoriDr,ItemNoRwoid)) Q:ItemNoRwoid=""  Do
  ....Set ItemNoAppRowid=^DHCEXDEItem(AppRowid,"OEORI",EXOeoriDr,ItemNoRwoid)
  ....If ItemNoAppRowid=EXRowid Set CHARGEITEMNO=ItemNoRwoid
  ...Set RetFlag=0
  ...For l=1:1:$L(ReturnStr,"^") Do
  ....Set RetRowid=$P(ReturnStr,"^",l)
  ....If RetRowid=EXRowid Set RetFlag=1,AMOUNT=-AMOUNT,COSTS=-COSTS,OPERATORNO=Usrid
  ...if EXStatus="F" Set AMOUNT=-AMOUNT,COSTS=-COSTS
  ...Set PriceList=PriceList_"<InpBilldetailOper>"
  ...Set PriceList=PriceList_"<OperaApplyFlow>"_CHECKFLOW_"</OperaApplyFlow>"
  ...Set PriceList=PriceList_"<OperItemNo>"_EXAMITEMNO_"</OperItemNo>"
  ...Set PriceList=PriceList_"<ChargeItemNo>"_CHARGEITEMNO_"</ChargeItemNo>"
  ...Set PriceList=PriceList_"<PatientId>"_PATIENTID_"</PatientId>"
  ...Set PriceList=PriceList_"<VisitId>"_VISITID_"</VisitId>"
  ...Set PriceList=PriceList_"<ItemNo>"_EXAMITEMNO_"</ItemNo>"
  ...Set PriceList=PriceList_"<ItemClass>"_ITEMCLASS_"</ItemClass>"
  ...Set PriceList=PriceList_"<ItemName>"_ITEMNAME_"</ItemName>"
  ...Set PriceList=PriceList_"<ItemCode>"_ITEMCODE_"</ItemCode>"
  ...Set PriceList=PriceList_"<ItemSpec>"_ITEMSPEC_"</ItemSpec>"
  ...Set PriceList=PriceList_"<Amount>"_AMOUNT_"</Amount>"
  ...Set PriceList=PriceList_"<Units>"_UNITS_"</Units>"
  ...Set PriceList=PriceList_"<OrderedBy>"_ORDEREDBY_"</OrderedBy>"
  ...Set PriceList=PriceList_"<PerformedBy>"_PERFORMEDBY_"</PerformedBy>"
  ...Set PriceList=PriceList_"<Costs>"_COSTS_"</Costs>"
  ...Set PriceList=PriceList_"<Charges>"_CHARGES_"</Charges>"
  ...Set PriceList=PriceList_"<BillingDateTime>"_BILLINGDATETIME_"</BillingDateTime>"
  ...Set PriceList=PriceList_"<OperatorNo>"_OPERATORNO_"</OperatorNo>"
  ...Set PriceList=PriceList_"<DhcPbd>"_DHCKey_"</DhcPbd>"
  ...Set PriceList=PriceList_"<DoctorName>"_DoctorName_"</DoctorName>"
  ...Set PriceList=PriceList_"</InpBilldetailOper>"
  ..Set SetActiveStr=SetActiveStr_"^"_EXRowid

  if PriceList="" q "-100"
  If $p(^PAADM(EpisodeID),"^",2)="O" Do
   .Set Str="<Request><OutBillItemsOperList>"
  .Set Str=Str_PriceList_"</OutBillItemsOperList></Request>"
  .;w Str,!
  .s StreamTarStr=##class(%GlobalCharacterStream).%New()
  .s StreamSendTarFlag=##class(%GlobalCharacterStream).%New()
  .d StreamTarStr.Write(Str)
  .s obj=##class(web.DHCENS.WebService.DHCSoap).%New()
  .s StreamSendTarFlag=obj.DhcService("OutBillItemsOper",StreamTarStr)
  .d StreamSendTarFlag.Rewind()
  .s Len=StreamSendTarFlag.SizeGet()
  .d StreamSendTarFlag.Rewind()
  .s SendTarFlag=StreamSendTarFlag.Read(Len)
  .;w SendTarFlag,!
  .Set PAADMType1=$p(^PAADM(EpisodeID),"^",2)
  .Set SendTarFlag=$P(SendTarFlag,"Returncode>",2)
  .If (SendTarFlag="0</") Set ActiveFlag=..SetReturnStatus(ReturnStr)
 
  if PriceList="" q "-100"
  If $p(^PAADM(EpisodeID),"^",2)="I" Do
  .Set Str="<Request><InpBilldetailOperList>"
  .Set Str=Str_PriceList_"</InpBilldetailOperList></Request>"
  .;w Str,!
  .s StreamTarStr=##class(%GlobalCharacterStream).%New()
  .s StreamSendTarFlag=##class(%GlobalCharacterStream).%New()
  .d StreamTarStr.Write(Str)
  .s obj=##class(web.DHCENS.WebService.DHCSoap).%New()
  .s StreamSendTarFlag=obj.DhcService("InpBilldetailOper",StreamTarStr)
  .d StreamSendTarFlag.Rewind()
  .s Len=StreamSendTarFlag.SizeGet()
  .d StreamSendTarFlag.Rewind()
  .s SendTarFlag=StreamSendTarFlag.Read(Len)
  .Set PAADMType1=$p(^PAADM(EpisodeID),"^",2)
  .Set SendTarFlag=$P(SendTarFlag,"Returncode>",2)
  .If (SendTarFlag="0</") Set ActiveFlag=..SetReturnStatus(ReturnStr)
  q SendTarFlag
}

ClassMethod SetReturnStatus(ReturnStr As %String) As %String
{

	Set Flag=0
	Tstart
	For i=1:1:$L(ReturnStr,"^") Do
	.Set ExaRowid=$P(ReturnStr,"^",i)
	.Q:ExaRowid=""
	.;&sql(Update SQLUSER.DHC_ExamDetails Set EX_Status='F',EX_Billing_Attr='F' Where EX_Rowid=:ExaRowid)
	.If (SQLCODE=0) d  Set Flag=1
	.Else  TRollback
	TC
	Q Flag
}

ClassMethod GetAccCard(DHCOPERNO As %String, EpisodeID As %String, UserID As %String) As %String
{
  Set CHECKFLOW=$P(^DHCANOPArrange(DHCOPERNO),"^",41)
  Set PATIENTInfo=##class(web.DHCENS.PatientInfo).GetHisAdmByPaadm(EpisodeID)
  If $p(^PAADM(EpisodeID),"^",2)="O" d
  .Set PATIENTID=$P(PATIENTInfo,"^",2)_"_"_$P(PATIENTInfo,"^",3)
  If $p(^PAADM(EpisodeID),"^",2)="I"  Q "ADMType"	
  Set PinNumber=^RISPassWord(UserID)
  Set RetStr=PATIENTID_"^"_PinNumber_"^"_CHECKFLOW
  Q RetStr
}

ClassMethod GetDrugOEORD(EpisodeID As %String, OPERNo As %String) As %String
{
  //w ##class(web.DHCOperPrice).GetDrugOEORD("20106","166")
  Set ^yjy("GetDrugOEORD")=EpisodeID_"^"_OPERNo
  If EpisodeID="" Q ""
  If OPERNo="" Q ""
  Set OrdStr=""
  If '$D(^DHCANChargeInWeb(EpisodeID,OPERNo)) Q ""
  Set OEORDStr=^DHCANChargeInWeb(EpisodeID,OPERNo)
  For i=1:1:$L(OEORDStr,$c(1)) Do
  .Set OEORDList=$P(OEORDStr,$c(1),i)
  .Q:OEORDList=""
  .Set arcimId=$P($G(OEORDList),"^",1)
  .Set startDate=$P($G(OEORDList),"^",2)
  .Set startTime=$P($G(OEORDList),"^",3)
  .Set recDepId=$P($G(OEORDList),"^",4)
  .Set doseQty=$P($G(OEORDList),"^",5)
  .Set doseQtySum=$P($G(OEORDList),"^",6)
  .Set doseUomId=$P($G(OEORDList),"^",7)
  .Set instrId=$P($G(OEORDList),"^",8)
  .Set seqNo=$P($G(OEORDList),"^",9)
  .Set masterSeqNo=$P($G(OEORDList),"^",10)
  .Set OEORDUser=$P($G(OEORDList),"^",11)
  .Set UserLoc=$P($G(OEORDList),"^",12)
  .Set BillPrice=$p(##Class(web.UDHCJFPRICE).GetOrderPrice("","",arcimId,+$H,"","","",""),"^",4)
  .If (arcimId="")||(startDate="")||(doseQty="")||(OEORDUser="")||(UserLoc="") Do
  ..Set ^DHCANChargeInWeb(EpisodeID,OPERNo,"ERROR",i)=OEORDStr
  .//OrdStr=GetOrderARCIMRowid+'^N^3^^^^'+GetAPrice+'^'+GetReCtloc+'^'+'1'+'^^^^'+OrderPackUOMRowid+'^'+GetOrderNum+'^^^^^^1^N^^N^^^^^^^N^^^^^^^'+OPERRowid;
  .Set OrdStr=arcimId_"^^N^3^^^^"_BillPrice_"^"_recDepId_"^1^^^^"_doseUomId_"^"_doseQtySum_"^^^^^^1^N^^N^^^^^^^N^^^^^^^"_OPERNo
  .//Set OrdStr=arcimId_"^^"_startDate_"^"_startTime_"^1^1^93^1^486||1^^0.8^398^0.8^4^63^50^1^^2^N^^N^^^^^^^N^^^^^^"_OPERNo
  .Set ret=##Class(web.DHCOEOrdItem).SaveOrderItems(EpisodeID,OrdStr,OEORDUser,UserLoc,OEORDUser)
  .;w ret,!
  Q 0
}

ClassMethod OperOrdSet(GROUPID As %String)
{
  //w ##class(web.DHCOperPrice).OperOrdSet("105")
  Set OrdArry="",OrdCount=0
  Set ARCOSRowid=0 For  Set ARCOSRowid=$O(^ARCOS(ARCOSRowid)) Q:ARCOSRowid=""  Do
  .Set ARCOSActiveFlag=$P(^ARCOS(ARCOSRowid),"^",4)
  .Q:ARCOSActiveFlag'="Y"
  .Set ARCOSDesc=$P(^ARCOS(ARCOSRowid),"^",2)
  .Set OrdSubCatDR=$P(^ARCOS(ARCOSRowid),"^",9)
  .Set SubCatFlag=0
  .Set SSORDChildsub="" For  Set SSORDChildsub=$O(^SSU("SSGRP",GROUPID,"SSORD",SSORDChildsub)) Q:SSORDChildsub=""  Do
  ..Set SSORDOrdCatDR=$P(^SSU("SSGRP",GROUPID,"SSORD",SSORDChildsub),"^",5)
  ..If SSORDOrdCatDR=OrdSubCatDR Set SubCatFlag=1
  .Q:SubCatFlag=0
  .If OrdArry="" Set OrdArry=ARCOSRowid_$c(1)_ARCOSDesc Set OrdCount=OrdCount+1
  .Else  Set OrdArry=OrdArry_"^"_ARCOSRowid_$c(1)_ARCOSDesc Set OrdCount=OrdCount+1
  .if OrdCount=5 Do
  ..Set retval="OrdSet"_"('"_$ZCVT(OrdArry,"O","JS")_"');"
  ..&javascript<#(retval)#>
  ..Set OrdArry="",OrdCount=0
}

ClassMethod OPERDrugPrice(DHCOPERNO As %String, EpisodeID As %String, OPERRowid As %String) As %String
{
  //w ##class(web.DHCOperPrice).OPERDrugPrice("490","19389","19389||1")
  //Set ^yjy("OPERDrugPrice")=DHCOPERNO_"^"_EpisodeID_"^"_OPERRowid
  Set ^yjy(555)=DHCOPERNO_"^"_EpisodeID_"^"_OPERRowid
  If DHCOPERNO="" Q "-2001"
  If EpisodeID="" Q "-2002"
  Set i=1
  Set DrugRowid=0 For  Set DrugRowid=$O(^DHCANChargeInWeb(EpisodeID,DHCOPERNO,DrugRowid)) Q:DrugRowid=""  Do
  .Q:$D(^DHCANChargeInWebi(EpisodeID,DHCOPERNO,DrugRowid))
  .Set DrugStr=^DHCANChargeInWeb(EpisodeID,DHCOPERNO,DrugRowid)
  .b
  .Q:DrugStr=""
  .Set ArcimDr=$P($G(DrugStr),"^",1)
  .Q:ArcimDr=""
  .Set StartDate=$P($G(DrugStr),"^",2)
  .If StartDate["-" Set StartDate=$zdh(StartDate,3)
  .Set StartDate=$zd(StartDate,4)
  .Set StartTime=$P($G(DrugStr),"^",3)
  .Set ReLoc=$P($G(DrugStr),"^",4)
  .Q:ReLoc=""
  .Set doseQty=$P($G(DrugStr),"^",5)
  .Set doseQtySum=$P($G(DrugStr),"^",6)
  .Set doseUomId=$P($G(DrugStr),"^",7)
  .Set instrId=$P($G(DrugStr),"^",8)
  .Set seqNo=$P($G(DrugStr),"^",9)
  .Set masterSeqNo=$P($G(DrugStr),"^",10)
  .Set UserId=$P($G(DrugStr),"^",11)
  .Set LocId=$P($G(DrugStr),"^",12)
  .Set BillPrice=$p(##Class(web.UDHCJFPRICE).GetOrderPrice("","",ArcimDr,+$H,"","","",""),"^",4)
  .Set OrderCatDr=$P($G(^ARCIM(+ArcimDr,1,1)),"^",10)
  .Set OrderType=$P($G(^ARC("IC",OrderCatDr)),"^",7)
  .Set OrderPriorRowid=3 //临时医嘱
  .Set OrderPackQty=""
  .Set BillTypeRowid=1
  .Set OrderDrugFormRowid=""
  .Set OrderDepProcNotes=""
  .Set OrderFreqRowid=4 //PHCFR_RowId Qd
  .Set OrderDurRowid=63 //PHCDU_RowId 1天
  .Set PHPrescType=""
  .Set OrderMasterSeqNo=""
  .Set OrderSeqNo=i
  .Set AdmReason=57  //自费
  .Set DateStr=ArcimDr_"^"_OrderType_"^"_OrderPriorRowid_"^"_StartDate_"^"_StartTime_"^"_OrderPackQty_"^"_BillPrice
  .Set DateStr=DateStr_"^"_ReLoc_"^"_AdmReason_"^"_OrderDrugFormRowid_"^"_OrderDepProcNotes_"^"_doseQty
  .Set DateStr=DateStr_"^"_doseUomId_"^"_doseQtySum_"^"_OrderFreqRowid_"^"_OrderDurRowid_"^"_instrId
  .Set DateStr=DateStr_"^"_PHPrescType_"^"_OrderMasterSeqNo_"^"_OrderSeqNo_"^N^^N^^^^^^^N^^^^^^"_DHCOPERNO
  .;w DateStr,!
  .Set ret=##Class(web.DHCOEOrdItem).SaveOrderItems(EpisodeID,DateStr,UserId,LocId,"")
  .Set i=i+1
  .Set OrdId=$P(ret,"*",2)
  .If OrdId["||" Do
  ..Set ^DHCANChargeInWebi(EpisodeID,DHCOPERNO,DrugRowid)=OrdId
  .Set $P(^OEORD(+OrdId,"I",$P(OrdId,"||",2),4),"^",9)=DHCOPERNO
}

ClassMethod GetDrugOrdStatus(Ord As %String) As %String
{
  //w ##class(web.DHCOperPrice).GetDrugOrdStatus("1291||59")
  Set ChildOrd=$P(Ord,"||",2)
  If '$D(^OEORD(+Ord,"I",ChildOrd)) Q "-1"
  Set Status=##Class(web.DHCService).AppOrdStatus(Ord)
  If Status=0 Set PayStatus="已收费",PayCode="P"
  If Status=1 Set PayStatus="未划价",PayCode="TB"
  If Status=2 Set PayStatus="未收费",PayCode="B"
  Set EpisodeID=$P(^OEORD(+Ord),"^",1)
  Set AdmType=$P(^PAADM(EpisodeID),"^",2)
  Set RetStr="0"_"^"_AdmType_"^"_PayCode_"^"_PayStatus
  Q RetStr
}

ClassMethod GetTarRowid(Ord As %String) As %String
{
  //w ##class(web.DHCOperPrice).GetTarRowid("1291||59")
  Set RetStr=""
  Set EpisodeID=$P(^OEORD(+Ord),"^",1)
  Set EXRowid=""  For  Set EXRowid=$O(^DHCEXDE(0,"OEORI",EpisodeID,Ord,EXRowid))  Q:EXRowid=""  Do
  .Set RetStr=RetStr_"^"_EXRowid
  Q RetStr
}

ClassMethod NurseOrderInsert(Input As %String) As %String
{
  //w ##class(web.DHCOperPrice).NurseOrderInsert("")
  K ^DHCNURSEOEORD($j)
  Set Count=1
  Set AdviceIdFlag=0
  //set ^yjy(12)=Input
  //Set Input=^yjy(12)
  //Set Input="<Request><NurseOrders><AdviceId></AdviceId><PatientId>1803299</PatientId><VisitId>1</VisitId><OrderNo>1</OrderNo><OrderSubNo>134</OrderSubNo><RepeatIndicator>1</RepeatIndicator><OrderClass>A</OrderClass><OrderText>维生素B1片</OrderText><OrderCode>O020001TA0</OrderCode><Spec>10mg*100鄂华中制药</Spec><Units>瓶</Units><Dosage>10.0000</Dosage><DosageUnits>rmg</DosageUnits><Administration>口服</Administration><StartDateTime>20100424123028</StartDateTime><StopDateTime>20100408123028</StopDateTime><Duration></Duration><DurationUnits></DurationUnits><Frequency></Frequency><FreqCounter>1</FreqCounter><FreqInterval>1</FreqInterval><FreqIntervalUnit>日</FreqIntervalUnit><FreqDetail></FreqDetail><PerformSchedule></PerformSchedule><PerformResult></PerformResult><OrderingDept>3902</OrderingDept><Doctor>张志凌</Doctor><StopDoctor>张志凌</StopDoctor><Nurse>李波</Nurse><StopNurse>LIBO</StopNurse><EnterDateTime>20100408123029</EnterDateTime><StopOrderDateTime>20100424124034</StopOrderDateTime><OrderStatus>2</OrderStatus><DrugBillingAttr>0</DrugBillingAttr><BillingAttr>0</BillingAttr><LastPerformDateTime></LastPerformDateTime><LastAcctingDateTime></LastAcctingDateTime></NurseOrders></Request>"
  //Set Input="<Request><NurseOrders><AdviceId></AdviceId><PatientId>E1934567</PatientId><VisitId>1</VisitId><OrderNo>38</OrderNo><OrderSubNo>1</OrderSubNo><RepeatIndicator>0</RepeatIndicator><OrderClass>A</OrderClass><OrderText>UW液</OrderText><OrderCode>S010006LS1</OrderCode><Spec>1000ml美国杜邦</Spec><Units>袋</Units><Dosage>90.0000</Dosage><DosageUnits>ml</DosageUnits><Administration>静脉注射</Administration><StartDateTime>20100507171217</StartDateTime><StopDateTime>20100507171217</StopDateTime><Duration></Duration><DurationUnits></DurationUnits><Frequency></Frequency><FreqCounter>1</FreqCounter><FreqInterval>1</FreqInterval><FreqIntervalUnit>日</FreqIntervalUnit><FreqDetail></FreqDetail><PerformSchedule></PerformSchedule><PerformResult></PerformResult><OrderingDept>7001</OrderingDept><Doctor>徐道妙</Doctor><StopDoctor>徐道妙</StopDoctor><Nurse>彭小贝</Nurse><StopNurse>PXBEI</StopNurse><EnterDateTime>20100507171220</EnterDateTime><StopOrderDateTime>20100507171510</StopOrderDateTime><OrderStatus>2</OrderStatus><DrugBillingAttr>0</DrugBillingAttr><BillingAttr>0</BillingAttr><LastPerformDateTime></LastPerformDateTime><LastAcctingDateTime></LastAcctingDateTime></NurseOrders><NurseOrders><AdviceId></AdviceId><PatientId>E1934567</PatientId><VisitId>1</VisitId><OrderNo>38</OrderNo><OrderSubNo>2</OrderSubNo><RepeatIndicator>0</RepeatIndicator><OrderClass>A</OrderClass><OrderText>精氨酸针</OrderText><OrderCode>I061002IJ0</OrderCode><Spec>20ml沪第一生化</Spec><Units>支</Units><Dosage>80.0000</Dosage><DosageUnits>ml</DosageUnits><Administration>静脉注射</Administration><StartDateTime>20100507171217</StartDateTime><StopDateTime>20100507171217</StopDateTime><Duration></Duration><DurationUnits></DurationUnits><Frequency></Frequency><FreqCounter>1</FreqCounter><FreqInterval>1</FreqInterval><FreqIntervalUnit>日</FreqIntervalUnit><FreqDetail></FreqDetail><PerformSchedule></PerformSchedule><PerformResult></PerformResult><OrderingDept>7001</OrderingDept><Doctor>徐道妙</Doctor><StopDoctor>徐道妙</StopDoctor><Nurse>彭小贝</Nurse><StopNurse>PXBEI</StopNurse><EnterDateTime>20100507171255</EnterDateTime><StopOrderDateTime>20100507171510</StopOrderDateTime><OrderStatus>2</OrderStatus><DrugBillingAttr>0</DrugBillingAttr><BillingAttr>0</BillingAttr><LastPerformDateTime></LastPerformDateTime><LastAcctingDateTime></LastAcctingDateTime></NurseOrders><NurseOrders><AdviceId></AdviceId><PatientId>E1934567</PatientId><VisitId>1</VisitId><OrderNo>38</OrderNo><OrderSubNo>3</OrderSubNo><RepeatIndicator>0</RepeatIndicator><OrderClass>A</OrderClass><OrderText>呋苄西林钠针</OrderText><OrderCode>A012001IJ0</OrderCode><Spec>1g苏二叶制药</Spec><Units>支</Units><Dosage>70.0000</Dosage><DosageUnits>g</DosageUnits><Administration>静脉注射</Administration><StartDateTime>20100507171217</StartDateTime><StopDateTime>20100507171217</StopDateTime><Duration></Duration><DurationUnits></DurationUnits><Frequency></Frequency><FreqCounter>1</FreqCounter><FreqInterval>1</FreqInterval><FreqIntervalUnit>日</FreqIntervalUnit><FreqDetail></FreqDetail><PerformSchedule></PerformSchedule><PerformResult></PerformResult><OrderingDept>7001</OrderingDept><Doctor>徐道妙</Doctor><StopDoctor>徐道妙</StopDoctor><Nurse>彭小贝</Nurse><StopNurse>PXBEI</StopNurse><EnterDateTime>20100507171327</EnterDateTime><StopOrderDateTime>20100507171510</StopOrderDateTime><OrderStatus>2</OrderStatus><DrugBillingAttr>0</DrugBillingAttr><BillingAttr>0</BillingAttr><LastPerformDateTime></LastPerformDateTime><LastAcctingDateTime></LastAcctingDateTime></NurseOrders></Request>"
  Set reader = ##class(%XML.Reader).%New()
  Set sc=reader.OpenString(Input)
  Do reader.Correlate("NurseOrders","web.DHCNurseOrders")
  While (reader.Next(.object,.sc)) {
	   Set AdviceId=object.AdviceId
	   Set PatientId=object.PatientId
	   Set VisitId=object.VisitId
	   Set OrderNo=object.OrderNo
	   Set OrderSubNo=object.OrderSubNo
	   Set RepeatIndicator=object.RepeatIndicator
	   Set OrderClass=object.OrderClass
	   Set OrderText=object.OrderText
	   Set OrderCode=object.OrderCode
	   Set Dosage=object.Dosage
	   Set DosageUnits=object.DosageUnits
	   Set Administration=object.Administration
	   Set StartDateTime=object.StartDateTime
	   Set StopDateTime=object.StopDateTime
	   Set Duration=object.Duration
	   Set DurationUnits=object.DurationUnits
	   Set Frequency=object.Frequency
	   Set FreqCounter=object.FreqCounter
	   Set FreqInterval=object.FreqInterval
	   Set FreqIntervalUnit=object.FreqIntervalUnit
	   Set FreqDetail=object.FreqDetail
	   Set PerformSchedule=object.PerformSchedule
	   Set PerformResult=object.PerformResult
	   Set OrderingDept=object.OrderingDept
	   Set Doctor=object.Doctor
	   Set StopDoctor=object.StopDoctor
	   Set Nurse=object.Nurse
	   Set StopNurse=object.StopNurse
	   Set EnterDateTime=object.EnterDateTime
	   Set StopOrderDateTime=object.StopOrderDateTime
	   Set OrderStatus=object.OrderStatus
	   Set DrugBillingAttr=object.DrugBillingAttr
	   Set BillingAttr=object.BillingAttr
	   Set LastPerformDateTime=object.LastPerformDateTime
	   Set LastAcctingDateTime=object.LastAcctingDateTime
	   Set Spec=object.Spec
	   Set Units=object.Units
	   Set DataStr=""
	   if (+AdviceId'>0)&(AdviceIdFlag=0) Do
	   .Set AdviceIdNo=..GetAdviceId()
	   .Set AdviceIdFlag=1
	   If (+AdviceId'>0) Set AdviceId=AdviceIdNo
	   Set DataStr=AdviceId_"^"_PatientId_"^"_VisitId_"^"_OrderNo_"^"_OrderSubNo_"^"_RepeatIndicator_"^"_OrderCode_"^"_Dosage_"^"_DosageUnits_"^"_Administration_"^"_StartDateTime_"^"_Duration_"^"_DurationUnits
	   Set DataStr=DataStr_"^"_Frequency_"^"_FreqCounter_"^"_FreqInterval_"^"_FreqIntervalUnit_"^"_OrderingDept_"^"_Doctor
	   Set DataStr=DataStr_"^"_StopDoctor_"^"_Nurse_"^"_StopNurse_"^"_EnterDateTime_"^"_StopOrderDateTime
	   Set DataStr=DataStr_"^"_OrderStatus_"^"_DrugBillingAttr_"^"_BillingAttr_"^"_Spec_"^"_Units_"^"_OrderText
	   If (PatientId'="") DO
	   .Set ^DHCNURSEOEORD($j,Count)=DataStr
	   .Set Count=Count+1
     }
  If $system.Status.IsError(sc) do $system.OBJ.DisplayError(sc)
  Set Returncode=0
  Set i=1
  If $D(^DHCNURSEOEORD($J)) Do
  .Set DataRowid="" For  Set DataRowid=$O(^DHCNURSEOEORD($j,DataRowid)) Q:DataRowid=""  Do
  ..Set PreData=^DHCNURSEOEORD($j,DataRowid)
  ..Set VisitId=$P(PreData,"^",3)
  ..Set Patient=$P(PreData,"^",2)
  ..Set Returncode=-1
  ..Set OrderText=$P(PreData,"^",30)
  ..;Set PaadmType=$E(Patient,1,1)
  ..If VisitId'="" Set PaadmType="I"
  ..//Set PatientId=$E(Patient,2,$L(Patient))
  ..Set OARowid=""
  ..Set PAAdmId=""
  ..If (PaadmType="I")||(PaadmType="H") Do
  ...Q:VisitId=""
  ...Set OARowid=$O(^DHCENSOA("0","VisitId","I",PatientId,VisitId,-1))
  ...Set PAAdmId=$P($G(^DHCENSOA(OARowid)),"^",3)
  ..Else  Do
  ...Set OARowidTemp="",OADate="",OAVisitNo="",OADateTmp="",OAVisitNoTmp=""
  ...Set OARowid="" For  Set OARowid=$O(^DHCENSOA(0,"PatientId",PatientId,OARowid)) Q:OARowid=""  Do
  ....Set OAVisitDate=$P($G(^DHCENSOA(OARowid)),"^",6)
  ....Set OAVisitNo=$P($G(^DHCENSOA(OARowid)),"^",7)
  ....If (OAVisitDate>OADateTmp)||((OAVisitDate=OADateTmp)&(OAVisitNo>OAVisitNoTmp))  Do
  .....Set OARowidTemp=OARowid
  .....Set OAVisitNoTmp=OAVisitNo
  .....Set OADateTmp=OAVisitDate
  ...Q:OARowidTemp=""
  ...Set PAAdmId=$P($G(^DHCENSOA(OARowidTemp)),"^",3)
  ..Q:PAAdmId=""
  ..Set OrderNo=$P(PreData,"^",4)
  ..Q:OrderNo=""
  ..Set OrderSubNo=$P(PreData,"^",5)
  ..Q:OrderSubNo=""
  ..Set BaseData=PAAdmId_"^"_AdviceId_"^"_OrderNo_"^"_OrderSubNo
  ..Q:$D(^DHCLHN(0,"PAADM",PAAdmId,OrderNo,OrderSubNo,-1)) //这句话在停医嘱的时候还要处理一下
  ..Set OrderCode=$P(PreData,"^",7)
  ..If OrderCode="" Do ..InsertErr(BaseData,"OrderCodeErr")
  ..Q:OrderCode="" 
  ..Set Spec="",Units="",OrderText="",DrugFlag=0
  ..Set Spec=$P(PreData,"^",28)
  ..Set Units=$P(PreData,"^",29)
  ..Set OrderText=$P(PreData,"^",30)
  ..Set AdviceId=$P(PreData,"^",1)
  ..Set DOSAGE=$P(PreData,"^",8)
  ..Set DosageUnits=$P(PreData,"^",9)
  ..Set Administration=$P(PreData,"^",10)
  ..Set ARCIMDR=$O(^ARCIM(0,"Code",$ZCONVERT(OrderCode,"U"),-1))
  ..If (+ARCIMDR'>0) Do
  ...Set OEORDDESC=OrderText_Spec_Units
  ...Set OEORDDESC=$ZCONVERT(OEORDDESC,"U")
  ...Set OEORDDESC=$$ALPHAUP^SSUTIL4(OEORDDESC)
  ...Set ARCIMDR=$O(^ARCIM(0,"Desc",OEORDDESC,-1))
  ...;w ARCIMDR_"  "_OEORDDESC,!
  ...If ARCIMDR'=""  Set DrugFlag=1
  ..If +ARCIMDR'>0 Set ErrMessage="ARCIMDRErr OrderCode="_OrderCode_" |"_$G(OrderText) Do ..InsertErr(BaseData,ErrMessage)
  ..Q:+ARCIMDR'>0 //调试的时候因为没有对照所以先屏蔽
  ..;w $P(^ARCIM(ARCIMDR,1,1),"^",2),!
  ..Set PHCINRowId=$O(^PHCIN(0,"Code",$ZCONVERT(Administration,"U"),-1)) //给药途径
  ..If (PHCINRowId="")&(Administration'="") Do
  ...Set AdministrationCode=$ZCONVERT(Administration,"U")
  ...&sql(Insert into SQLUSER.PHC_Instruc Set PHCIN_Code=:AdministrationCode,PHCIN_Desc1=:Administration,PHCIN_Desc2=:Administration)
  ...If SQLCODE=0 Set PHCINRowId=%ROWID
  ..Set DosageUomRowid=$O(^CT("UOM",0,"Desc",$ZCONVERT(DosageUnits,"U"),-1)) //默认计量单位
  ..If (DosageUomRowid="")&(DosageUnits'="") Do
  ...Set DosageUnitsCode=$ZCONVERT(DosageUnits,"U")
  ...&sql(Insert into SQLUSER.CT_UOM Set CTUOM_Code=:DosageUnitsCode,CTUOM_Desc=:DosageUnits,CTUOM_ForeignDesc=:DosageUnits)
  ...If SQLCODE=0 Set DosageUomRowid=%ROWID
  ..Set StartDateTime=$P(PreData,"^",11)
  ..Set StartDate="",StartTime=""
  ..If StartDateTime'="" Do 
  ...Set StartDate=$E(StartDateTime,1,8)
  ...Set StartTime=$E(StartDateTime,9,15)
  ...Set StartDate=$ZDH(StartDate,5)
  ...Set StartTime=$E(StartTime,1,2)_":"_$E(StartTime,3,4)
  ...Set StartTime=$ZTH(StartTime,2)
  ..Else  Set StartDate=+$H,StartTime=$P($H,",",2)
  ..Set StopDate="",StopTime=""
  ..Set StopDateTime=$P(PreData,"^",24)
  ..If StopDateTime'="" Do 
  ...Set StopDate=$E(StopDateTime,1,8)
  ...Set StopTime=$E(StopDateTime,9,15)
  ...Set StopDate=$ZDH(StopDate,5)
  ...Set StopTime=$E(StopTime,1,2)_":"_$E(StopTime,3,4)
  ...Set StopTime=$ZTH(StopTime,2)
  ..Set OrdStatus=$P(PreData,"^",25)
  ..If ('$D(^DHCLHN(0,"PAADM",PAAdmId,OrderNo,OrderSubNo))&(OrdStatus=3)||(OrdStatus=4)) Set Returncode=0
  ..Q:Returncode=0
  ..Set Duration=""
  ..Set Duration=$P(PreData,"^",12)
  ..Set DurationUnits=""
  ..Set DurationUnits=$P(PreData,"^",13)
  ..Set Frequency=""
  ..Set Frequency=$P(PreData,"^",14)
  ..Set FreqCounter=""
  ..Set FreqCounter=$P(PreData,"^",15)
  ..Set FreqInterval=""
  ..Set FreqInterval=$P(PreData,"^",16)
  ..Set FreqIntervalUnit=""
  ..Set FreqIntervalUnit=$P(PreData,"^",17)
  ..Set OrderingDept=""
  ..Set OrderingDept=$P(PreData,"^",18)
  ..If OrderingDept="" Do ..InsertErr(BaseData,"OrderingDeptErr")
  ..Q:OrderingDept=""
  ..Set Doctor=$P(PreData,"^",19)
  ..If Doctor="" Do ..InsertErr(BaseData,"DoctorErr")
  ..Q:Doctor=""
  ..Set Nurse="",StopNurse=""
  ..Set Nurse=$P(PreData,"^",21)
  ..Set StopNurse=$P(PreData,"^",22)
  ..Set StopNurse=$ZCONVERT(StopNurse,"U")
  ..Set RepeatIndicator=$P(PreData,"^",6)
  ..If DrugFlag=1 Set FreqDesc="每"_FreqIntervalUnit_FreqInterval_"次"
  ..Else  Set FreqDesc=$ZCONVERT(FreqIntervalUnit,"U")
  ..Set FreqRowid=""
  ..Set FreqRowid=$O(^PHCFR(0,"Desc1",FreqDesc,""))
  ..If (FreqRowid="")&(FreqDesc'="")&(FreqCounter'="") Do
  ...&sql(Insert into SQLUSER.PHC_Freq Set PHCFR_Factor=:FreqCounter,PHCFR_Desc1=:FreqDesc,PHCFR_code=:FreqDesc)
  ...If SQLCODE=0 Set FreqRowid=%ROWID
  ..If FreqRowid="" Set FreqRowid=4
  ..Set LHNFlag=0
  ..Set SSUserRowid=$O(^SSU("SSUSR",0,"SSUSR_Name",$ZCONVERT(Doctor,"U"),-1))
  ..Set NurseRowid=$O(^SSU("SSUSR",0,"SSUSR_Name",$ZCONVERT(Nurse,"U"),-1))
  ..Set StopNurseRowid=$O(^SSU("SSUSR",0,"SSUSR_Initials",$ZCONVERT(StopNurse,"U"),-1))
  ..If (SSUserRowid="")&(NurseRowid="") Do ..InsertErr(BaseData,"DoctorRowidErr")
  ..Q:(SSUserRowid="")&(NurseRowid="")
  ..If (SSUserRowid="")&(NurseRowid'="") Set SSUserRowid=NurseRowid
  ..If $D(^DHCLHN(0,"PAADM",PAAdmId,OrderNo,OrderSubNo)) Do
  ...Set LHNROWID=$O(^DHCLHN(0,"PAADM",PAAdmId,OrderNo,OrderSubNo,-1))
  ...Q:LHNROWID=""
  ...Set LHNStatus=$P($G(^DHCLHN(LHNROWID)),"^",5)
  ...If LHNStatus="S" Set LHNFlag=1
  ...if (OrdStatus'="4") Set LHNFlag=1
  ...Q:LHNFlag=1
  ...Set LHNOEORDDR=$P($G(^DHCLHN(LHNROWID)),"^",4)
  ...Set StopOrdUser=StopNurseRowid
  ...If (StopOrdUser="")&(NurseRowid'="")  Set StopOrdUser=NurseRowid 
  ...If (StopOrdUser="")&(SSUserRowid'="")  Set StopOrdUser=SSUserRowid
  ...Set StopDate=$ZD(StopDate,4) 
  ...Set StopTime=$ZT(StopTime,2)
  ...Set StopStr=LHNOEORDDR_"&"_StopDate_"&"_StopTime
  ...Set StopRet=##class(web.UDHCStopOrderLook).StopOrder("","",StopStr,StopOrdUser,"")
  ...If StopRet=0 Do
  ....&sql(Update SQLUSER.DHC_LinkHisNurseOrd Set LHN_STATUS='S' Where LHN_ROWID=:LHNROWID)
  ...Set LHNFlag=1
  ..If LHNFlag=1 Set Returncode=0
  ..Q:LHNFlag=1 
  ..Set OrderingDept=$P(PreData,"^",18)
  ..Set OrdDepRowid=""
  ..Set OrdDepRowid=$O(^CTLOC(0,"Code",$ZCONVERT(OrderingDept,"U"),-1))
  ..Set ReLocRowid=$P(^PAADM(PAAdmId),"^",4)
  ..;w "ReLocRowid="_ReLocRowid_"OrdDepRowid="_OrdDepRowid_"SSUserRowid="_SSUserRowid_"NurseRowid="_NurseRowid,!
  ..Set ARCIMItemCat=$P($G(^ARCIM(+ARCIMDR,1,1)),"^",10)
  ..;Q:ARCIMItemCat=""
  ..Set OrderType=$P($G(^ARC("IC",ARCIMItemCat)),"^",7)
  ..If RepeatIndicator=1 Set Priority=5 
  ..Else  Set Priority=3
  ..Set StartDate=$ZD(StartDate,4)
  ..Set StartTime=$ZT(StartTime,2)
  ..Set DrugFormRowid=""
  ..Set DrugFormRowid=$P($G(^ARCIM(+ARCIMDR,1,1)),"^",12)
  ..Set ARCIMDR=ARCIMDR_"||"_"1"
  ..Set OrderPackQty=""
  ..Set BillTypeRowid=1
  ..Set OrderDrugFormRowid=""
  ..Set OrderDepProcNotes=""
  ..Set OrderDurRowid=63 //PHCDU_RowId 1天
  ..Set PHPrescType=""
  ..Set OrderMasterSeqNo=""
  ..Set OrderSeqNo=i
  ..Set AdmReason=57  //自费
  ..Set IcuFlag=0
  ..Set AdmDep=$P($G(^PAADM(PAAdmId)),"^",4)
  ..Set ICUListRowid=$O(^CT("LL",0,"Code","ICU",-1))
  ..If ICUListRowid'="" Do
  ...Set ICULocId=0 For  Set ICULocId=$O(^CT("LL",ICUListRowid,"LOC",ICULocId)) Q:ICULocId=""  Do
  ....Set IcuDepId=$P(^CT("LL",ICUListRowid,"LOC",ICULocId),"^",1)
  ....If IcuDepId=AdmDep Set IcuFlag=1
  ..;Q:IcuFlag=0
  ..Set DateStr=ARCIMDR_"^"_OrderType_"^"_Priority_"^"_StartDate_"^"_StartTime_"^"_OrderPackQty_"^"_""
  ..Set DateStr=DateStr_"^"_ReLocRowid_"^"_AdmReason_"^"_OrderDrugFormRowid_"^"_OrderDepProcNotes_"^"_DOSAGE
  ..Set DateStr=DateStr_"^"_DosageUomRowid_"^"_""_"^"_FreqRowid_"^"_OrderDurRowid_"^"_PHCINRowId
  ..Set DateStr=DateStr_"^"_PHPrescType_"^"_OrderMasterSeqNo_"^"_OrderSeqNo_"^N^^N^^^^^^^N^^^^^^"
  ..Set ret=##Class(web.DHCOEOrdItem).SaveOrderItems(PAAdmId,DateStr,SSUserRowid,OrdDepRowid,"")
  ..Set i=i+1
  ..If (ret'="") Do
  ...Set OrdDr=$P(ret,"*",2)
  ...&sql(Insert into SQLUSER.DHC_LinkHisNurseOrd Set LHN_ORDER_NO=:OrderNo,LHN_ORDERSUB_NO=:OrderSubNo, LHN_OEORD_DR=:OrdDr, LHN_STATUS='V', LHN_PAADM=:PAAdmId )
  ...Set Returncode=0
  Set ^yjy(14)=Returncode
  Q 0
}

ClassMethod GetAdviceId() As %String
{
 If '$D(^AdviceIdNo) Do
 .Set ^AdviceIdNo=0
 Set AdvNo=^AdviceIdNo
 Lock +^AdviceIdNo
 Set ^AdviceIdNo=AdvNo+1
 Lock -^AdviceIdNo
 Set AdvNo=^AdviceIdNo
 Set AdvNo=$P($ZD(+$H,3),"-",1)_(AdvNo+1000000000)
 Set AdvNo=AdvNo-1000000000
 Q AdvNo
}

ClassMethod InsertErr(BaseData As %String, ErrMessage As %String)
{
  Set PAAdmId=$P(BaseData,"^",1)
  Set AdviceId=$P(BaseData,"^",2)
  Set OrderNo=$P(BaseData,"^",3)
  Set OrderSubNo=$P(BaseData,"^",4)
  Set NowDate=+$H
  Set NowTime=$P($H,",",2)
  ;&sql(Insert Into SQLUSER.DHC_NurseOrdMessage Set NurErr_AdviceId=:AdviceId,NurErr_OrderNo=:OrderNo,NurErr_OrderSubNo=:OrderSubNo,NurErr_ErrMessage=:ErrMessage,NurErr_Date=:NowDate,NurErr_time=:NowTime,NurErr_PAAdmId=:PAAdmId)
}

ClassMethod FindNOPayByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNOPayByAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindNOPayByAdmExecute(ByRef qHandle As %Binary, EpisodeID As %String, DHCANORowid As %String, UserID As %String, CTloc As %String) As %Status
{
 //d ##class(%ResultSet).RunQuery("web.DHCOperPrice","FindNOPayByAdm","20175","571","3117","312")
  Set repid=$I(^CacheTemp)
  Set ind=1
  Set num=0,m=""
  k PLIST
  s PriceCode=""
  Set ^yjy(199)=EpisodeID_"^"_DHCANORowid_"^"_UserID
  Set OEORDRowId=$O(^OEORD(0,"Adm",EpisodeID,-1))
  If ' $D(^DHCANOPArrange(DHCANORowid)) Set qHandle=$lb(0,repid,0)  quit $$$OK
  Set OPERDr=$P(^DHCANOPArrange(DHCANORowid),"^",2)
  Set AppRowid=$P(^DHCANOPArrange(DHCANORowid),"^",41)
  If OEORDRowId="" Q "-1"
  Set ChildOEORDRowId=0 For  Set ChildOEORDRowId=$O(^OEORD(OEORDRowId,"I",ChildOEORDRowId)) Q:ChildOEORDRowId=""  Do
  .Set AnaestDR=$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,4)),"^",9)
  .;b
  .q:AnaestDR'=OPERDr
  .Set ItmMast=$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",2)
  .Set OEORIItemStat=$p($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",13)
  .Set OEState=$p($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",13)
  .;b
  .Q:OEORIItemStat="4"
  .Set ItmDesc=$P(^ARCIM($P(ItmMast,"||",1),$P(ItmMast,"||",2),1),"^",2)
  .Set ItmCode=$P(^ARCIM($P(ItmMast,"||",1),$P(ItmMast,"||",2),1),"^",1)
  .Set UserDepartme=$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,7)),"^",2)
  .;Q:$G(UserDepartme)'=CTloc
  .Set AppointmentDate=$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",9)
  .Set sttdate=AppointmentDate
  .If (AppointmentDate'="") Set AppointmentDate=$ZD(AppointmentDate,3)
  .Set AppointmentTime=$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",10)
  .If AppointmentTime'="" Set AppointmentTime=$ZT(AppointmentTime,3)
  .Set TDate=$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,3)),"^",7)
  .If TDate'="" Set TDate=$ZD(TDate,3)
  .Set TTime=$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",17)
  .If TTime'="" Set TTime=$ZT(TTime,3)
  .Set AdmType=$P(^PAADM(EpisodeID),"^",2)
  .If AdmType="O" Set AdmType="门诊"
  .If AdmType="I" Set AdmType="住院"
  .If AdmType="E" Set AdmType="急诊"
  .Set AdmReason=$P($G(^PAADM(EpisodeID),1),"^",7)
  .Set CheckPrice=..CheckTar(OEORDRowId,ChildOEORDRowId,EpisodeID,ItmMast,AdmReason,"",UserID,AppRowid)
  .Set Price=##class(web.DHCDocOrderEntry).GetOrderPrice("", AdmReason, ItmMast, "", "", "", "", "") 
  .Set Price=$P(Price,"^",1)
  .Set Price=$j(Price,3,2)
  .Set QtyNum=$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",12)
  .Set PriceStatus=..CheckStatus(OEORDRowId,ChildOEORDRowId,EpisodeID)
  .;w "PriceStatus="_PriceStatus,!
  .Set SumPrice=QtyNum*Price
  .Set SumPrice=$j(SumPrice,3,2)
  .Set ChangePrice="修改"
  .Set OEORDRowid=OEORDRowId_"||"_ChildOEORDRowId
  .Set EXRowid=$O(^DHCEXDE(0,"OEORI",EpisodeID,OEORDRowid,-1))
  .;If EXRowid'="" d
  ..;Set Price=..GetPrice(EpisodeID,OEORDRowid)
  ..;Set SumPrice=Price*QtyNum
  ..;Set SumPrice=$j(SumPrice,3,2)
  .Set OEORDDr=OEORDRowId_"||"_ChildOEORDRowId
  .Set DoseUOM=$p($g(^OEORD(OEORDRowId,"I",ChildOEORDRowId,2)),"^",3)
  .if DoseUOM'="" Set CTUOMDesc=$p(^CT("UOM",DoseUOM),"^",2)  
  .Else  Set CTUOMDesc=""
  .Set ReLocRowid=$p($g(^OEORD(OEORDRowId,"I",ChildOEORDRowId,3)),"^",6)
  .Set ReLoc=$p($g(^CTLOC(ReLocRowid)),"^",2) s ReLoc=$p(ReLoc,"-",2)
  .Set OEORDDate=$p($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,11)),"^",4)
  .Set OEORDDate=$Zd(OEORDDate,3)
  .Set OEORDTime=$p($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,11)),"^",5)
  .Set OEORDTime=$ZT(OEORDTime,1)
  .Set OEORDUser=$p($g(^OEORD(OEORDRowId,"I",ChildOEORDRowId,7)),"^",1)
  .Set OEORDUserDesc=$P(^SSU("SSUSR",OEORDUser),"^",2)
  .if (PriceStatus'="")&(EXRowid'="") Do
  ..if $P($G(^DHCEXDE(EXRowid)),"^",11)'="" Set OEORDDate=$ZD($P($G(^DHCEXDE(EXRowid)),"^",11),3)
  ..if $P($G(^DHCEXDE(EXRowid)),"^",12)'="" Set OEORDTime=$ZT($P($G(^DHCEXDE(EXRowid)),"^",12),1)
  .Set PriceStatus=$P($G(^DHCEXDE(EXRowid)),"^",17)
  .if PriceStatus="" Set PriceStatus="未划价"
  .if (PriceStatus="0") Set PriceStatus="已划价"
  .if PriceStatus=1 Set PriceStatus="已收费"
  .if PriceStatus="F" Set PriceStatus="退费"
  .Q:(PriceStatus="已收费")||(PriceStatus="退费")
  .Do OutputRow
 Set qHandle=$lb(0,repid,0)
 quit $$$OK

OutputRow
 set Data=$lb(ItmDesc,ItmMast,QtyNum,Price,SumPrice,CTUOMDesc,OEORDDr,ReLoc,OEORDDate,OEORDTime,OEORDUserDesc,PriceStatus,PriceCode)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod FindNOPayByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNOPayByAdmExecute ]
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
	s qHandle=$lb(AtEnd,repid,ind) //
	Quit $$$OK
}

Query FindNOPayByAdm(EpisodeID As %String, DHCANORowid As %String, UserID As %String, CTloc As %String) As %Query(ROWSPEC = "ItmDesc:%String,ItmMast:%String,QtyNum:%String,Price:%String,SumPrice:%String,CTUOMDesc:%String,OEORDDr:%String,ReLoc:%String,OEORDDate:%String,OEORDTime:%String,OEORDUserDesc:%String,PriceStatus:%String,PriceCode:%String")
{
}

ClassMethod ChargeByOrdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ChargeByOrdExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ChargeByOrdExecute(ByRef qHandle As %Binary, EpisodeID As %String, UserID As %String, CTloc As %String, OrdStr As %String) As %Status
{
 //d ##class(%ResultSet).RunQuery("web.DHCOperPrice","ChargeByOrd","20175","3117","312","1402||43^1402||45")
  Set repid=$I(^CacheTemp)
  Set ind=1
  Set num=0,m=""
  k PLIST

  If OrdStr=""  Set qHandle=$lb(0,repid,0)  quit $$$OK
  For i=1:1:$L(OrdStr,"^") do
  .Set OrdId=$P(OrdStr,"^",i)
  .Set OEORDRowId=$P(OrdId,"||",1)
  .Set ChildOEORDRowId=$P(OrdId,"||",2)
  .Set ItmMast=$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",2)
  .Set OEORIItemStat=$p($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",13)
  .Set OEState=$p($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",13)
  .Q:OEORIItemStat="4"
  .Set ItmDesc=$P(^ARCIM($P(ItmMast,"||",1),$P(ItmMast,"||",2),1),"^",2)
  .Set ItmCode=$P(^ARCIM($P(ItmMast,"||",1),$P(ItmMast,"||",2),1),"^",1)
  .Set UserDepartme=$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,7)),"^",2)
  .Set AppointmentDate=$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",9)
  .Set sttdate=AppointmentDate
  .If (AppointmentDate'="") Set AppointmentDate=$ZD(AppointmentDate,3)
  .Set AppointmentTime=$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",10)
  .If AppointmentTime'="" Set AppointmentTime=$ZT(AppointmentTime,3)
  .Set TDate=$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,3)),"^",7)
  .If TDate'="" Set TDate=$ZD(TDate,3)
  .Set TTime=$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",17)
  .If TTime'="" Set TTime=$ZT(TTime,3)
  .Set AdmType=$P(^PAADM(EpisodeID),"^",2)
  .If AdmType="O" Set AdmType="门诊"
  .If AdmType="I" Set AdmType="住院"
  .If AdmType="E" Set AdmType="急诊"
  .Set AdmReason=$P($G(^PAADM(EpisodeID),1),"^",7)
  .Set CheckPrice=..CheckTarByOrd(OEORDRowId,ChildOEORDRowId,EpisodeID,ItmMast,"1","",UserID)
  .Set Price=##class(web.DHCDocOrderEntry).GetOrderPrice("", AdmReason, ItmMast, "", "", "", "", "") 
  .Set Price=$P(Price,"^",1)
  .Set Price=$j(Price,3,2)
  .Set QtyNum=$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",12)
  .Set PriceStatus=..CheckStatus(OEORDRowId,ChildOEORDRowId,EpisodeID)
  .;w "PriceStatus="_PriceStatus,!
  .Set SumPrice=QtyNum*Price
  .Set SumPrice=$j(SumPrice,3,2)
  .Set ChangePrice="修改"
  .Set OEORDRowid=OEORDRowId_"||"_ChildOEORDRowId
  .Set EXRowid=$O(^DHCEXDE(0,"OEORI",EpisodeID,OEORDRowid,-1))
  .If EXRowid'="" d
  ..Set Price=..GetPrice(EpisodeID,OEORDRowid)
  ..Set SumPrice=Price*QtyNum
  ..Set SumPrice=$j(SumPrice,3,2)
  .Set OEORDDr=OEORDRowId_"||"_ChildOEORDRowId
  .Set DoseUOM=$p($g(^OEORD(OEORDRowId,"I",ChildOEORDRowId,2)),"^",3)
  .if DoseUOM'="" Set CTUOMDesc=$p(^CT("UOM",DoseUOM),"^",2)  
  .Else  Set CTUOMDesc=""
  .Set ReLocRowid=$p($g(^OEORD(OEORDRowId,"I",ChildOEORDRowId,3)),"^",6)
  .Set ReLoc=$p($g(^CTLOC(ReLocRowid)),"^",2) s ReLoc=$p(ReLoc,"-",2)
  .Set OEORDDate=$p($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,11)),"^",4)
  .Set OEORDDate=$Zd(OEORDDate,3)
  .Set OEORDTime=$p($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,11)),"^",5)
  .Set OEORDTime=$ZT(OEORDTime,1)
  .Set OEORDUser=$p($g(^OEORD(OEORDRowId,"I",ChildOEORDRowId,7)),"^",1)
  .Set OEORDUserDesc=$P(^SSU("SSUSR",OEORDUser),"^",2)
  .if (PriceStatus'="")&(EXRowid'="") Do
  ..if $P($G(^DHCEXDE(EXRowid)),"^",11)'="" Set OEORDDate=$ZD($P($G(^DHCEXDE(EXRowid)),"^",11),3)
  ..if $P($G(^DHCEXDE(EXRowid)),"^",12)'="" Set OEORDTime=$ZT($P($G(^DHCEXDE(EXRowid)),"^",12),1)
  .Set PriceStatus=$P($G(^DHCEXDE(EXRowid)),"^",17)
  .if PriceStatus="" Set PriceStatus="未划价"
  .if (PriceStatus="0") Set PriceStatus="已划价"
  .if PriceStatus=1 Set PriceStatus="已收费"
  .if PriceStatus="F" Set PriceStatus="退费"
  .Set str=ItmDesc_"^"_ItmMast_"^"_QtyNum_"^"_Price_"^"_SumPrice_"^"_CTUOMDesc_"^"_OEORDDr_"^"_ReLoc_"^"_OEORDDate_"^"_OEORDTime_"^"_OEORDUserDesc_"^"_PriceStatus_"^"_$g(PriceCode)
  .Do OutputRow1
 Set qHandle=$lb(0,repid,0)
 quit $$$OK

OutputRow1
 set Data=$lb(str)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod ChargeByOrdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ChargeByOrdExecute ]
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
	s qHandle=$lb(AtEnd,repid,ind) //
	Quit $$$OK
}

Query ChargeByOrd(EpisodeID As %String, UserID As %String, CTloc As %String, OrdStr As %String) As %Query(ROWSPEC = "Retstr:%String")
{
}

ClassMethod CheckTarByOrd(OEORDRowId As %String, ChildOEORDRowId As %String, EpisodeID As %String, arcim As %String, AdmReason As %String, sttdate As %String, UserID As %String) As %String
{
  Set EXRowid=$O(^DHCEXDE(0,"OEORI",EpisodeID,OEORDRowId_"||"_ChildOEORDRowId,-1))
  Set Price=0,DiscPrice=0,InsPrice=0,PatPrice=0
  Set ExecuDate="",sttdate=+$h
  If EXRowid="" D
  .For  Set ExecuDate=$o(^DHCOLT(0,"ARCIM",arcim,"Z",ExecuDate)) q:ExecuDate=""  d
  ..q:ExecuDate>sttdate
  ..Set OLT=""
  ..For  Set OLT=$O(^DHCOLT(0,"ARCIM",arcim,"Z",ExecuDate,OLT)) q:OLT=""  d
  ...Set EndDate=$P(^DHCOLT(OLT),"^",5)
  ...If EndDate="" Set EndDate=+$H+1
  ...Quit:EndDate<sttdate
  ...Set qty0=$P(^DHCOLT(OLT),"^",3)
  ...Set Itm=$P(^DHCOLT(OLT),"^",2)
  ...Set err=##class(web.UDHCJFPRICE).GetItmPrice(Itm,sttdate,AdmReason,"","")
  ...Set Price=$P(err,"^",1)  ;*qty0
  ...Set DiscPrice=$P(err,"^",2)*qty0
  ...Set InsPrice=$P(err,"^",3)*qty0
  ...Set PatPrice=$P(err,"^",4)*qty0 
  ...Set EXCosts=Price*qty0
  ...Set EXDoctorDr =$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",11)
  ...Set EXOrdDeptDr =$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",3)  
  ...Set EXRecDeptDr =$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,3)),"^",6)   
  ...set OEORDDr=OEORDRowId_"||"_ChildOEORDRowId
  ...Set BillDate=+$h
  ...Set BillTime=$P($h,",",2)
  ...Quit:'$D(^DHCTARIi("TARI",Itm))
  ...;&sql(Insert into SQLUSER.DHC_ExamDetails Set EX_Adm_Dr=:EpisodeID,EX_Oeori_Dr=:OEORDDr,EX_Tari_Dr=:Itm,EX_Price=:Price,EX_Amount=:qty0,EX_Costs=:EXCosts,EX_Billing_Date=:BillDate,EX_Billing_Time=:BillTime,EX_User_Dr=:UserID,EX_Doctor_Dr=:EXDoctorDr,EX_OrdDept_Dr=:EXOrdDeptDr,EX_RecDept_Dr=:EXRecDeptDr)
  ...Set HVCNo=$p($g(^OEORD(OEORDRowId,"I",ChildOEORDRowId,12)),"^",61)   //高值耗材条码
  ...i HVCNo'="" Set ^DHCANHVCDetail(BillDate,BillTime,OEORDRowId_"||"_ChildOEORDRowId)=HVCNo_"^"_EpisodeID
  ...If $D(^DHCEXDEItem(AppRowid,"OEORI",OEORDDr,0)) Do
  ....Set ItemNo=^DHCEXDEItem(AppRowid,"OEORI",OEORDDr,0)+1
  ....Set ^DHCEXDEItem(AppRowid,"OEORI",OEORDDr,ItemNo)=%ROWID
  ....Set ^DHCEXDEItem(AppRowid,"OEORI",OEORDDr,0)=ItemNo
  ...If '$D(^DHCEXDEItem(AppRowid,"OEORI",OEORDDr,0)) Do
  ....Set ^DHCEXDEItem(AppRowid,"OEORI",OEORDDr,0)=1
  ....Set ^DHCEXDEItem(AppRowid,"OEORI",OEORDDr,1)=%ROWID
  q 0
}

//web.DHCOEOrdItem.SaveOrderItems

//OrdStr=GetOrderARCIMRowid+'^N^3^^^^'+GetAPrice+'^'+GetReCtloc+'^'+'1'+'^^^^'+OrderPackUOMRowid+'^'+GetOrderNum+'^^^^^^1^N^^N^^^^^^^N^^^^^^^'+OPERRowid;

//web.UDHCStopOrderLook.StopOrder

//add by ck 20101008

ClassMethod OrdSetInsert(userOrdSetname As %String, userArcAlias As %String, arcimStr As %String) As %String
{
  //w ##Class(web.DHCOperPrice).OrdSetInsert("手术室","sss","1816||1^1_$c(1)_11944||1^1_$c(1)_2487||1^1")
  //Set ^yjy(12)=userOrdSetname_","_userArcAlias_","_arcimStr
  Set NowDate=+$H,NowTime=$P($H,",",2)
  &SQL(Select Max(ARCOS_Rowid) into :MaxARCOSRowid
  From SQLUser.ARC_OrdSets)
  s MaxARCOSCode=$P(^ARCOS(MaxARCOSRowid),"^",1)
  s MaxARCOSCodeNum=$P(MaxARCOSCode,"-",2)
  i MaxARCOSCodeNum="" s MaxARCOSCodeNum=1
  e  s MaxARCOSCodeNum=MaxARCOSCodeNum+1
  ;s ARCOSCode=UserID_"-"_MaxARCOSCodeNum
  s MaxARCOSCode=MaxARCOSCode+2
  &SQL(insert into sqluser.ARC_OrdSets (ARCOS_Code,ARCOS_Desc,ARCOS_OrdCat_DR,ARCOS_OrdSubCat_DR,ARCOS_EffDateFrom)
	 Values (:MaxARCOSCode,:userOrdSetname,'7','19',:NowDate))
  Set ARCOSRowid=%ROWID
  &SQL(Insert Into SQLUser.ARC_Alias (ALIAS_ARCOS_DR,ALIAS_DateFrom,ALIAS_Text,ALIAS_OrderSubCat_dr,ALIAS_Desc) Values(:ARCOSRowid,:NowDate,:userArcAlias,'19',:userOrdSetname))
  For i=1:1:$L(arcimStr,$c(1)) Do
  .Set arcimItem=$P(arcimStr,$c(1),i)
  .Set arcimRowid=$P(arcimItem,"^",1)
  .Set arcimNum=$P(arcimItem,"^",2)
  .Do ..InsertItem(ARCOSRowid,arcimRowid,arcimNum)
  Q 0
}

ClassMethod GetOrderSetDate(ARCOSRowid As %String) As %String
{

	s DATE=$g(DATE) s:'DATE DATE=+$h
	s ord=+$g(ARCOSRowid) q:'ARCOSRowid 0 
	s dfrom=$o(^ARCOS(ARCOSRowid,"DATE",0,"DateFrom",.1+DATE),-1) q:'dfrom 0
	s drow=$o(^ARCOS(ARCOSRowid,"DATE",0,"DateFrom",dfrom,"")) q:'drow 0
	s dto=$p($g(^ARCOS(ARCOSRowid,"DATE",drow)),"^",2) i dto,dto<DATE q 0
	q ARCOSRowid_"||"_drow
}

ClassMethod InsertItem(ARCOSRowid As %String, ARCIMRowid As %String, ItemQty As %String) As %String
{
	S ARCOSDateRowid=..GetOrderSetDate(ARCOSRowid)
	i ((ARCOSDateRowid="")!(ARCOSDateRowid="0")) s ARCOSDateRowid=..InsertOrderSetDate(ARCOSRowid)
	&SQL(insert into sqluser.ARC_OrdSetDateItem (ITM_ParRef,ITM_ARCIM_DR,ITM_Qty,ITM_Visible)
	 Values (:ARCOSDateRowid,:ARCIMRowid,:ItemQty,'Y'))
	Q:'SQLCODE %ROWID
	Q -1
}

ClassMethod GetArcosItem(ARCOSRowid As %String) As %String
{
  //w ##Class(web.DHCOperPrice).GetArcosItem("526")
  s ^yjy(123)=ARCOSRowid
  Set ret=""
  Set rset=##class(%ResultSet).%New("web.DHCARCOrdSets:FindOSItem")
  do rset.Execute(ARCOSRowid,"1")
  While (rset.Next()) {
	if ret="" set ret=rset.GetData(10)_"^"_rset.GetData(2)
	e  s ret=ret_$c(1)_rset.GetData(10)_"^"_rset.GetData(2)
	}
	d rset.Close()
	Q ret
}

ClassMethod InsertOrderSetDate(ARCOSRowid As %String) As %String
{
	s DateFrom=+$h
	&SQL(Insert into sqluser.ARC_OrdSetDate (DATE_ParRef,DATE_DateFrom) values (:ARCOSRowid,:DateFrom))
	Q:'SQLCODE %ROWID
	Q -1
}

ClassMethod FindOSItemBroker(itmjs As %String, ARCOSRowid As %String)
{
	s ^RP("FindOSItemBroker")=ARCOSRowid
	;1137
	;w ##class(web.DHCARCOrdSets).FindOSItemBroker("",1137)
	;Rowid:OrderName:,StartDate:SeqNo:DoseQty:DoseUOM:Priority:Status:Frequence:Instruction:Duration:PackQty:RecDep:Billed")
	Set rset=##class(%ResultSet).%New("web.DHCARCOrdSets:FindOSItem")
	do rset.Execute(ARCOSRowid,"1")
	Set columns = rset.GetColumnCount()
	While (rset.Next()) {
		For col = 1:1:columns {
			;Write rset.GetColumnName(col),":"
			if col=1 set value=rset.GetData(col)
			e  s value=value_"^"_rset.GetData(col)
		}
		s retval=itmjs_"('"_$ZCVT(value,"O","JS")_"');"
		&javascript<#(retval)#>
	}
	d rset.Close()
	Q 1
}

ClassMethod FindOSItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOSItemExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod FindOSItemExecute(ByRef qHandle As %Binary, ARCOSRowid As %String, QueryFlag As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 s ARCIMDesc="",ARCOSItemQty="",ARCOSItemBillUOM="",ARCOSItemDoseQty="",ARCOSItemUOM="",ARCOSItemFrequence="",ARCOSItemDuration="",ARCOSItemInstruction="",ARCIMRowid="",ARCOSItemUOMDR="" ,ARCOSItemFrequenceDR="",ARCOSItemDurationDR="",ARCOSItemInstructionDR="",ARCOSItemCatDR="",ARCOSItemSubCatDR="",ARCOSItemOrderType=""
 set RowCount=0
 if (QueryFlag="1") d
 .S ARCOSDateRowid=..GetOrderSetDate(ARCOSRowid) 
 .Q:'ARCOSDateRowid  
 .S item=0 f  s item=$o(^ARCOS(ARCOSRowid,"DATE",$p(ARCOSDateRowid,"||",2),"ITM",item)) q:item=""  s s=^(item) d
 ..S ARCIMRowid=$p(s,"^",1)
 ..Q:##class(web.DHCDocOrderEntry).ValARCItem(ARCIMRowid)
 ..;帐单单位
 ..	s BillUOMDR=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),8)),"^",14) ; ARCIM_BillingUOM_DR
 ..	i BillUOMDR'="" s ARCOSItemBillUOM=$p($g(^CT("UOM",BillUOMDR)),"^",2) 
 ..s ARCOSItemRowid=ARCOSDateRowid_"||"_item
 ..s ARCIMDesc=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",2)
 ..s ARCOSItemQty=$p(s,"^",2)
 ..;if ARCOSItemQty="" s ARCOSItemQty=1
 ..;疗程
 ..s ARCOSItemDuration=""
 ..s ARCOSItemDurationDR=$p(s,"^",7)
 ..i ARCOSItemDurationDR'="" s ARCOSItemDuration=$p($g(^PHCDU(ARCOSItemDurationDR)),"^",3)
 ..;频率
 ..s ARCOSItemFrequence=""
 ..s ARCOSItemFrequenceDR=$p(s,"^",8)
 ..i ARCOSItemFrequenceDR'="" s ARCOSItemFrequence=$p($g(^PHCFR(ARCOSItemFrequenceDR)),"^",3)
 ..;用法
 ..s ARCOSItemInstruction=""
 ..s ARCOSItemInstructionDR=$p(s,"^",9)
 ..i ARCOSItemInstructionDR'="" s ARCOSItemInstruction=$p($g(^PHCIN(ARCOSItemInstructionDR)),"^",2)
 ..;剂量单位
 ..s ARCOSItemUOM=""
 ..s ARCOSItemUOMDR=$p(s,"^",10)
 ..i ARCOSItemUOMDR'="" s ARCOSItemUOM=$p($g(^CT("UOM",ARCOSItemUOMDR)),"^",2)
 ..;剂量
 ..s ARCOSItemDoseQty=$p(s,"^",13)
 ..;医嘱大类?子类?类型
 ..s ARCOSItemSubCatDR="",ARCOSItemCatDR="",ARCOSItemOrderType=""
 ..s ARCOSItemSubCatDR=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
 ..i ARCOSItemSubCatDR'="" d
 ...s ARCOSItemCatDR=$p($g(^ARC("IC",ARCOSItemSubCatDR)),"^",8)
 ...s ARCOSItemOrderType=$p($g(^ARC("IC",ARCOSItemSubCatDR)),"^",7)
 ..s ARCOSItmLinkDoctor=$p(s,"^",14)
 ..Do OutputRow2 	
 else  Do
 .do ResetVariables2
 .Do OutputRow2 	
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2
 set Data=$lb(ARCIMDesc,ARCOSItemQty,ARCOSItemBillUOM,ARCOSItemDoseQty,ARCOSItemUOM,ARCOSItemFrequence,ARCOSItemDuration,ARCOSItemInstruction,ARCOSItemRowid,ARCIMRowid,ARCOSItemUOMDR ,ARCOSItemFrequenceDR,ARCOSItemDurationDR,ARCOSItemInstructionDR,ARCOSItemCatDR,ARCOSItemSubCatDR,ARCOSItemOrderType,ARCOSItmLinkDoctor)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 Quit
ResetVariables2
 Set (ARCIMDesc,ARCOSItemQty,ARCOSItemBillUOM,ARCOSItemDoseQty,ARCOSItemUOM,ARCOSItemFrequence,ARCOSItemDuration,ARCOSItemInstruction,ARCOSItemRowid,ARCIMRowid,ARCOSItemUOMDR ,ARCOSItemFrequenceDR,ARCOSItemDurationDR,ARCOSItemInstructionDR,ARCOSItemCatDR,ARCOSItemSubCatDR,ARCOSItemOrderType,ARCOSItmLinkDoctor)=""
 Quit
}

ClassMethod FindOSItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOSItemExecute ]
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

ClassMethod GetArcimName(ArcimRowid As %String, Num As %String)
{
  Set ArcimName=$P($G(^ARCIM(+ArcimRowid,1,1)),"^",2)	
  Set str=ArcimName_"^"_Num_"^"_ArcimRowid
  Set retval="ArcimList"_"('"_$ZCVT(str,"O","JS")_"');"
  &javascript<#(retval)#>
}

ClassMethod GetCatStr() As %String
{
 Set ret=""
 Set ARCICRowId=0 For  Set ARCICRowId=$O(^ARC("IC",ARCICRowId)) Q:ARCICRowId=""  Do
 .Set ARCDesc=$P(^ARC("IC",ARCICRowId),"^",2)
 .If ret="" Set ret=ARCICRowId_$c(1)_ARCDesc
 .Else  Set ret=ret_"^"_ARCICRowId_$c(1)_ARCDesc
 Q ret
}

}
