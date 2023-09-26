Class web.DHCLabCommon Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 根据报告ID得到申请医生
ClassMethod GetReqDoctor(TestSetRow As %String) As %String
{
  s labno=$p(TestSetRow,"||",1)
  i '$l(labno) q ""
  s DoctorCode=$p(^TEPI(labno),"\",13)
  s DoctorName=""
  i $l(DoctorCode),$d(^TTAB("DR",DoctorCode)){
	  s DoctorName=$p(^TTAB("DR",DoctorCode),"\",1)
  }
  Quit DoctorName
}

/// 根据检验号得到病人姓名
ClassMethod GetPatName(LabNo As %String) As %String
{
 
	n (LabNo)
  	s LabNo=$g(LabNo)
  	i '$l(LabNo) q ""
  	s (RetValue,sname,gname)=""
  	i $d(^TEPI(LabNo)) s sname=$p(^TEPI(LabNo),"\",1),gname=$p(^TEPI(LabNo),"\",2)
  	i sname=gname s RetValue=sname
  	i sname'=gname s RetValue=sname_gname
  	q RetValue
}

/// 根据检验号得到病人性别
ClassMethod GetSpecies(LabNo As %String) As %String
{
	n (LabNo)
  	s LabNo=$g(LabNo)
  	i '$l(LabNo) q ""
  	s RetValue=""
  	s SpecCode=$p(^TEPI(LabNo),"\",3)
  	i SpecCode'="",$d(^TTAB("SP",SpecCode)) s RetValue=$p(^TTAB("SP",SpecCode),"\",1)
  	q RetValue
}

/// 根据报告ID或医嘱ID得到病人年龄
ClassMethod GetPatAge(TestSetRow As %String, OrderID As %String) As %String
{
  s TestSetRow=$g(TestSetRow),OrderID=$g(OrderID)
  i '$l(TestSetRow),'$l(OrderID) q ""
  i '$l(TestSetRow) {
  	s TestSetRow=$p(^OEORD(+OrderID,"I",$p(OrderID,"||",2),3),"^",35)	
  }
  i '$l(TestSetRow) q ""
  s labno=$p(TestSetRow,"||",1)
  i '$l(labno) q ""
  i '$d(^TEPI(labno)) q ""
  s InAge=$$GetAge(labno)
  s RetValue=""
  s PatAge=$p(InAge,$c(1),1),AgeType=$p(InAge,$c(1),2)
  i $l(PatAge),$p(PatAge,".",1)="" s PatAge="0"_PatAge
  i '$l(PatAge) q RetValue
  i AgeType="0" s RetValue=PatAge_"岁"
  i AgeType="1" s RetValue=PatAge_"月"
  i AgeType="2" s RetValue=PatAge_"天"
  i AgeType="3" s RetValue=PatAge_"小时"
  q RetValue
GetAge(labno) n (labno)
  s labno=$g(labno)
  //年龄不空
  s age=$p(^TEPI(labno),"\",25)
  s dob=$p(^TEPI(labno),"\",4)
  i age="0" s age=""
  s temageunit=""
  //年龄单位  6.3->6.4
  //i $d(^TEPI(labno)) s temageunit=$p(^TEPI(labno),"\",52)      ;6.3
  i $d(^TEPI(labno,8)) s temageunit=$p(^TEPI(labno,8),"\",17)   ;6.4
  s (ret1,ret2)=""
  i $l(temageunit) d
  .i temageunit="0" s ret1=age
  .i temageunit="1",$l(age) s ret1=(age*1000)/30
  .i temageunit="2",$l(age) s ret1=age*1000
  .i temageunit="3",$l(age) s ret1=age*100000
  .s ret2=temageunit
  e  d
  .i $l(age) d
  ..i age'<1 d
  ...s ret1=age
  ...s ret2="0"
  ..e  d
  ...s ret1=age*1000
  ...i ret1'<1  d
  ....s ret2="2"
  ...e  d
  ....s ret1=ret1*100
  ....s ret2="3"
  s InAge=""
  i $l(ret1) s InAge=ret1_$c(1)_ret2
  i $l(InAge) q InAge
  ;i '$l(labno) 
  s curdate=+$h
  s temage="",ageunit=0
  i dob d
  .s temstr=$$CalAge(dob,curdate)
  .s temage=$p(temstr,"|",12),temmon=$p(temstr,"|",13),temday=$p(temstr,"|",14)
  .i temage s EPA25=temage q
  .i temmon s EPA25=temmon*30/1000,ageunit="1" q
  .i temday s EPA25=temday/1000,ageunit="2" 
  q temage_$c(1)_ageunit 
   ;calculate patient age day:14,month:13,year:12
CalAge(IBirth,IToday,EstMth,EstYr,EstStamp) 
 ; pass in date of birth in internal format
 ;
 n XBirth,XToday,AgeDay,AgeMth,AgeYear,CurrMth,CurrYear,AgeYr,UseDOB
 ;
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

/// 根据ADM号得到登记号
ClassMethod GetRegNobyEpisodeID(EpisodeID)
{
 n (EpisodeID)
 q:$g(EpisodeID)="" ""
 q:'$d(^PAADM(EpisodeID)) ""
 s PaitentID=$p(^PAADM(EpisodeID),"^",1)
 q ..GetRegNo(PaitentID)
}

ClassMethod GetRegNo(PaitentID)
{
 n (PaitentID)
 q:$g(PaitentID)="" ""
 q:'$D(^PAPER(PaitentID,"PAT",1)) ""
 s IP=$p(^PAPER(PaitentID,"PAT",1),"^",1)
 s OP=$p(^PAPER(PaitentID,"PAT",1),"^",2)
 s PAPMINo=$S($G(XFUNC("CLASS"))="OP":OP,1:IP)
 q PAPMINo
}

/// 得到危急提示
/// w ##Class(web.DHCLabCommon).GetWarnComment("181389","H006","1")
ClassMethod GetWarnComment(LabNo As %String, TS As %String, TSCnt As %String) As %String
{
	New (LabNo,TS,TSCnt)
	S Config=##Class(websys.Configuration).%OpenId(1)
 	S LabNS=Config.LabDataNamespace
	S:'$l(LabNS) LabNS="LABDATA"
 		
	If '$l(LabNo) Quit ""
	If '$l(TS) Quit ""
	i '$d(^[LabNS]TEPI(LabNo,1,TS,TSCnt)) Quit ""
	Set ResStus=$p(^[LabNS]TEPI(LabNo,1,TS,TSCnt),"\",31)
	s res=""
	i ResStus'="A" Quit ""
	;;<---------------------20131209 优先从新的里面去取危急值提示
	I $D(^[LabNS]DHCPanicReport(1,LabNo)) D
	.S ID="" F  S ID=$O(^[LabNS]DHCPanicReport(1,LabNo,ID)) Q:ID=""  D
	..S TC="" F  S TC=$O(^[LabNS]DHCPanicReport(1,LabNo,ID,"TC",TC)) Q:TC=""  D
	...s Status=$P(^[LabNS]DHCPanicReport(1,LabNo,ID,"TC",TC),"\",4)
	...S Data=$G(^[LabNS]DHCPanicReport(1,LabNo,ID))
	...s res=""
	...;;;警戒报告
	...i Status="PNC" s res=$P(Data,"\",8)
	...;;;荒诞报告
	...i Status="RU" s res=$P(Data,"\",8)
    ...s TransMemoDr=$p($p(res,"{",2),"}",1)
    ...i $L(TransMemoDr),$d(^[LabNS]DHCTSTransComment(TransMemoDr)) s res=$p(^[LabNS]DHCTSTransComment(TransMemoDr),"\",1)
	I $L(res) Q res
	;;<---------------------------------------
	s TransDate=$o(^[LabNS]DHCTSTrans(LabNo,TS,TSCnt,""),-1)
	i '$l(TransDate) Quit ""
	s TransTime=$o(^[LabNS]DHCTSTrans(LabNo,TS,TSCnt,TransDate,""),-1)
	i '$l(TransTime) Quit ""
	s TransStr=$g(^[LabNS]DHCTSTrans(LabNo,TS,TSCnt,TransDate,TransTime))
	i '$l(TransStr) Quit ""
	s RetValue=""
	s Status=$p(TransStr,"\",2)
	//警戒报告
	//i Status="PNC" s RetValue=0
	//荒诞报告
	//i Status="RU" s RetValue=0
	i (Status="PNC")!(Status="RU"){
		//报告说明
		s TransMemoDr=$p(TransStr,"\",4)
		if $e(TransMemoDr,1)'="{"{
			s RetValue=TransMemoDr
		}
		else{
			s TransMemoDr=$p($p(TransMemoDr,"{",2),"}",1)
			i $L(TransMemoDr),$d(^[LabNS]DHCTSTransComment(TransMemoDr)){
				 s RetValue=$p(^[LabNS]DHCTSTransComment(TransMemoDr),"\",1)
			}
		}
	}
	Quit RetValue
}

//获取标本采样信息

//liuzf 20150129

ClassMethod GetSpecCollDatetime(oeoriId As %String)
{
	 q:oeoriId="" ""
	 s (ret,specCollUser,specCollDate,specCollTime)=""
	 s oeordId=+oeoriId,oeoriSub=$p(oeoriId,"||",2),oeoreSub=$p(oeoriId,"||",3)
	 i oeoreSub'="" d                            //7.0
	 .s specCollUser=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"NUR")),"^",10)
	 .s specCollDate=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"NUR")),"^",11)
	 .s specCollTime=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"NUR")),"^",12)
	 e  d
	 .s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",0))
	 .q:oeoreSub=""
	 .s specCollUser=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"NUR")),"^",10)
	 .s specCollDate=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"NUR")),"^",11)
	 .s specCollTime=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"NUR")),"^",12)
	 s:(specCollUser'="")&(specCollDate'="")&(specCollTime'="") ret=specCollUser_"^"_specCollDate_"^"_specCollTime
	 i ret="" d                ////6.9
	 .s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",0)) 
	 .q:oeoreSub=""
	 .s dhcoreId=$o(^DHCOrdExec(0,"OEOREDR",oeordId_"||"_oeoriSub_"||"_oeoreSub,0))
     .q:dhcoreId=""
     .&sql(select DHCORE_SpecCollUser,DHCORE_SpecCollDate,DHCORE_SpecCollTime into :specCollUser,:specCollDate,:specCollTime from SQLUSER.DHC_OE_OrdExec  where DHCORE_RowId=:dhcoreId)
	 .s:(specCollUser'="")&(specCollDate'="")&(specCollTime'="") ret=specCollUser_"^"_specCollDate_"^"_specCollTime
	q ret
}

}
