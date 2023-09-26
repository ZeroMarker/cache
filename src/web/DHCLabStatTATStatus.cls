Class web.DHCLabStatTATStatus Extends %Persistent
{

/// TAT标本状态明细统计
Parameter BUILD = 60;

ClassMethod QueryTATStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryTATStatusExecute ]
{
	S repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Q $$$OK
}

/// Query的执行方法
/// D ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
ClassMethod QueryTATStatusExecute(ByRef qHandle As %Binary, DateS As %String, DateE As %String, DepCode As %String, DateType As %String, PatientType As %String, Labno As %String, Debtor As %String, PatName As %String, Doctor As %String, CliDepCode, USERCODE As %String) As %Status
{
  S repid=$I(^CacheTemp)
  I $G(ind)="" S ind=1
  Kill PLIST
  S ^TMP("Samp2")=DateS_","_DateE_","_DepCode_","_DateType_","_PatientType_","_Labno_","_Debtor_","_PatName_","_Doctor_","_CliDepCode
  S DateS=$G(DateS), DateE=$G(DateE),DepCode=$G(DepCode), DateType=$G(DateType),PatientType=$G(PatientType)
  S Labno=$G(Labno),Debtor=$G(Debtor),PatName=$G(PatName),Doctor=$G(Doctor),CliDepCode=$G(CliDepCode)
  I CliDepCode="null" S CliDepCode=""
  I DepCode="null" s DepCode=""
  I '$L(DateS) S DateS=$ZD(DateS,3)
  I '$L(DateE) S DateE=$ZD(DateE,3)
  S DateS=$ZDH(DateS,3)
  S DateE=$ZDH(DateE,3)
  ;,开医嘱日期?时间?????开单医生?费用?医嘱名称?医嘱状态?临床科室?执行科室
  S (RowId,TSStartDate,TSEndDate,itmDr,doctorDr,itemStat,price,locDep,billed,CliDep,totalAmount,episodeNo)=""
  S j=0
  ;医嘱执行日期,医嘱打印标志,执行人科室,执行人病区,查询条件代码,医嘱执行时间,执行人,打印人,打印日期,打印时间
  S (oeoreDate,oeorePrint,ctLocDr,wardDr,queryCode,oeoreTime,ssUserDr,printUser,printDate,printTime)=""
  ;取出标本确认的接收日期,时间?发送的日期,时间?
  S (sampAccDate,sampAccTime,sampSendDate,sampSendTime)=""
  S (patientData,labTestSet)=""
  S num=0,P0=0,isum=0,SQLCODE=-100
  K ^TMP($zn,$j,0)
  ///标本号直接查询
  I $L(Labno) S DateType="" D BySampleCode(Labno) 
  ;对查询日期类型的处理,对开单日期和执行日期字段进行处理,此处SQL不认
  I DateType ="1" D OeoriStartDate()    ;1:开单日期
  I DateType ="2" D OeoriEndDate()        ;2:执行日期及采样时间
  I DateType ="3" D						;3:接收日期
  .S Date="" 
  .F Date=DateS:1:DateE D
  ..D ByAcceptDate(Date)
  I DateType ="4" D                     ;4:发送日期
  .S Date="" F Date=DateS:1:DateE D 
  ..D BySendDate(Date)
  S qHandle=$lb(0,repid,0)
  Q $$$OK

BySampleCode(SampleCode)   S SampleCode=$G(SampleCode)
   I $l(SampleCode) D
   .S ordId="" F  S ordId=$O(^OEORD(0,"EpisNo",SampleCode,ordId)) Q:ordId=""  D
   ..S ordSubId="" F  S ordSubId=$O(^OEORD(0,"EpisNo",SampleCode,ordId,ordSubId)) Q:ordSubId=""  D
   ...S labepis=$P(^OEORD(ordId,"I",ordSubId,3),"^",20)
   ...I labepis="" Q
   ...//ordinfo
   ...S itmMastDr=$P(^OEORD(ordId,"I",ordSubId,1),"^",2)
   ...//增加病历号
   ...S (patID,patRowId,Name)=""
   ...S patID=$P(^OEORD(ordId,"I",ordSubId,3),"^",9)
   ...I $L(Debtor)&&(Debtor'=patID) Q
   ...//通过病案号取姓名等信息
   ...I $L(patID) S patRowId=$O(^PAPERi("PAPMI_PatNo",patID,"")) 
   ...I $L(patRowId) S Name=$P(^PAPER(patRowId,"ALL"),"^",1)
   ...I $L(PatName)&(Name'[PatName) Q
   ...S LabNo=$P(labepis,"||",1)
   ...//条码号判断?取零判断
   ...I $L(SampleCode)&&(SampleCode'=LabNo) Q
   ...S itmName=""
   ...S extCode=""
   ...I $L(itmMastDr) D
   ....S itmName=$P(^ARCIM($P(itmMastDr,"||",1),$P(itmMastDr,"||",2),1),"^",2)
   ....S ord=$O(^ARCIM($P(itmMastDr,"||",1),$P(itmMastDr,"||",2),"EXT",""),-1)
   ....I $L(ord) S extCode=$P(^ARCIM($P(itmMastDr,"||",1),$P(itmMastDr,"||",2),"EXT",ord),"^",4)
   ...I $l(DepCode),$e(extCode)'=DepCode q
   ...S itmStatDr=$P(^OEORD(ordId,"I",ordSubId,1),"^",13)
   ...S itemStat=""
   ...I $l(itmStatDr),$D(^OEC("OSTAT",itmStatDr)) S itmStat=$P(^OEC("OSTAT",itmStatDr),"^",2)
   ...S reqUser=$P(^OEORD(ordId,"I",ordSubId,7),"^",1)
   ...//控制医生代码????
   ...I $L(Doctor)&&(Doctor'=reqUser) Q
   ...I $L(reqUser),$D(^SSU("SSUSR",reqUser)) S reqUser=$P(^SSU("SSUSR",reqUser),"^",2)
   ...S execSub=$O(^OEORD(ordId,"I",ordSubId,"X",""),-1)
   ...S billed=""
   ...I $L(execSub) S billed=$P(^OEORD(ordId,"I",ordSubId,"X",execSub),"^",6)
   ...S ordDepDr=$P(^OEORD(ordId,"I",ordSubId,1),"^",3)
   ...S ordDepCode=""
   ...I $L(ordDepDr),$D(^CTLOC(ordDepDr)) D
   ....S ordDep=$P(^CTLOC(ordDepDr),"^",2)
   ....S ordDepCode=$P(^CTLOC(ordDepDr),"^",1)
   ...//执行科室
   ...I $L(CliDepCode)&&(CliDepCode'=ordDepCode) Q
   ...S labTestRow=$P(^OEORD(ordId,"I",ordSubId,3),"^",35)
   ...S ordDate=$ZD($P(^OEORD(ordId,"I",ordSubId,3),"^",7),3)
   ...S ordTime=$P(^OEORD(ordId,"I",ordSubId,1),"^",17)
   ...I $L(ordTime) S ordTime=$ZT(ordTime,2)
   ...S recDepDr=$P(^OEORD(ordId,"I",ordSubId,3),"^",6)
   ...S recDep=""
   ...I $L(recDepDr),$D(^CTLOC(recDepDr)) S recDep=$P(^CTLOC(recDepDr),"^",2)
   ...//S ordinfo1=ordDate_"^"_ordTime_"^"_docdr
   ...//S ordinfo2=""
   ...//SpecInfo
   ...S rowid=ordId_"||"_ordSubId
   ...S temstr=..GetSpecInfo(rowid)
   ...S collDate=$P(temstr,",",1)
   ...S collTime=$P(temstr,",",2)
   ...I $L(collTime) S collTime=$ZT(collTime,2)
   ...S collUser=$P(temstr,",",3)
   ...I $L(collDate) S collDate=$ZD(collDate,3)
   ...S specInfo=collDate_" "_collTime_"^"_collUser
   ...///
   ...S temstr=..GetLabTSInfo(labTestRow)
   ...S recDate=$P(temstr,$C(2),1)
   ...S recUser=$P(temstr,$C(2),2)
   ...S entryDate=$P(temstr,$C(2),3)
   ...S entryUser=$P(temstr,$C(2),4)
   ...S authDate=$P(temstr,$C(2),5)
   ...S authUser=$P(temstr,$C(2),6)
   ...S resStus=$P(temstr,$C(2),7)
   ...S resStus=$P(temstr,$C(2),8)
   ...S ResultTime=$P(temstr,$C(2),9)
   ...S totalAmount=+totalAmount
   ...S (wardDr,queryCode,oeoreTime,ssUserDr,printUser,printDate,printTime,locDep)=""
   ...S num=num+1
   ...//需要增加病案号?姓名?条码号?开单科室?
   ...S Data=$lb(num,patID,Name,labepis,ordDate,ordTime,collDate,collTime,itmStat,ordDep,wardDr,resStus,oeoreTime,ssUserDr,printUser,printDate,printTime,itmName,recDep,reqUser,billed,ordDep,totalAmount,recDate,authDate,ResultTime)
   ...D Output
   S P0=num
   Q num
  //得到标本信息  
OeoriStartDate()  
   F Date=DateS:1:DateE D
   .S ordId="" F  S ordId=$O(^OEORDi(0,"ItemDate",Date,ordId)) Q:ordId=""  D
   ..S ordSubId="" F  S ordSubId=$O(^OEORDi(0,"ItemDate",Date,ordId,ordSubId)) Q:ordSubId=""  D
   ...S labepis=$P(^OEORD(ordId,"I",ordSubId,3),"^",20)
   ...I labepis="" Q
   ...//ordinfo
   ...S itmMastDr=$P(^OEORD(ordId,"I",ordSubId,1),"^",2)
   ...//增加病历号
   ...S (patID,patRowId,Name)=""
   ...S patID=$P(^OEORD(ordId,"I",ordSubId,3),"^",9)
   ...I $L(Debtor)&&(Debtor'=patID) Q
   ...//通过病案号取姓名等信息
   ...I $L(patID) S patRowId=$O(^PAPERi("PAPMI_PatNo",patID,"")) 
   ...I $L(patRowId) S Name=$P(^PAPER(patRowId,"ALL"),"^",1)
   ...I $L(PatName)&(Name'[PatName) Q
   ...S LabNo=$P(labepis,"||",1)
   ...//条码号判断?取零判断
   ...I $L(Labno)&&(Labno'=LabNo) Q
   ...S itmName=""
   ...S extCode=""
   ...I $L(itmMastDr) D
   ....S itmName=$P(^ARCIM($P(itmMastDr,"||",1),$P(itmMastDr,"||",2),1),"^",2)
   ....S ord=$O(^ARCIM($P(itmMastDr,"||",1),$P(itmMastDr,"||",2),"EXT",""),-1)
   ....I $L(ord) S extCode=$P(^ARCIM($P(itmMastDr,"||",1),$P(itmMastDr,"||",2),"EXT",ord),"^",4)
   ...I $L(DepCode),$e(extCode)'=DepCode Q
   ...S itmStatDr=$P(^OEORD(ordId,"I",ordSubId,1),"^",13)
   ...S itemStat=""
   ...I $L(itmStatDr),$D(^OEC("OSTAT",itmStatDr)) S itmStat=$P(^OEC("OSTAT",itmStatDr),"^",2)
   ...S reqUser=$P(^OEORD(ordId,"I",ordSubId,7),"^",1)
   ...//控制医生代码????
   ...I $L(Doctor)&&(Doctor'=reqUser) Q
   ...I $L(reqUser),$D(^SSU("SSUSR",reqUser)) S reqUser=$P(^SSU("SSUSR",reqUser),"^",2)
   ...S execSub=$O(^OEORD(ordId,"I",ordSubId,"X",""),-1)
   ...S billed=""
   ...I $L(execSub) S billed=$P(^OEORD(ordId,"I",ordSubId,"X",execSub),"^",6)
   ...S ordDepDr=$P(^OEORD(ordId,"I",ordSubId,1),"^",3)
   ...S ordDepCode=""
   ...I $L(ordDepDr),$D(^CTLOC(ordDepDr)) D
   ....S ordDep=$P(^CTLOC(ordDepDr),"^",2)
   ....S ordDepCode=$P(^CTLOC(ordDepDr),"^",1)
   ...//执行科室
   ...I $L(CliDepCode)&&(CliDepCode'=ordDepCode) Q
   ...S labTestRow=$P(^OEORD(ordId,"I",ordSubId,3),"^",35)
   ...S ordDate=$ZD(Date,3)
   ...S ordTime=$P(^OEORD(ordId,"I",ordSubId,1),"^",17)
   ...I $L(ordTime) S ordTime=$ZT(ordTime,2)
   ...S recDepDr=$P(^OEORD(ordId,"I",ordSubId,3),"^",6)
   ...S recDep=""
   ...I $L(recDepDr),$D(^CTLOC(recDepDr)) S recDep=$P(^CTLOC(recDepDr),"^",2)
   ...S rowid=ordId_"||"_ordSubId
   ...S ItmMastDr=$P(^OEORD(ordId,"I",ordSubId,1),"^",2)
   ...I $L(ItmMastDr),'(..isLabTS(ItmMastDr)) Q
   ...S temstr=..GetSpecInfo(rowid)
   ...S collDate=$P(temstr,",",1)
   ...S collTime=$P(temstr,",",2)
   ...I $L(collTime) S collTime=$ZT(collTime,2)
   ...S collUser=$P(temstr,",",3)
   ...I $L(collDate) S collDate=$ZD(collDate,3)
   ...S specInfo=collDate_" "_collTime_"^"_collUser
   ...///
   ...S temstr=..GetLabTSInfo(labTestRow)
   ...S recDate=$P(temstr,$C(2),1)
   ...S recUser=$P(temstr,$C(2),2)
   ...S entryDate=$P(temstr,$C(2),3)
   ...S entryUser=$P(temstr,$C(2),4)
   ...S authDate=$P(temstr,$C(2),5)
   ...S authUser=$P(temstr,$C(2),6)
   ...S resStus=$P(temstr,$C(2),7)
   ...I resStus="" S resStus="未送检"
   ...S totalAmount=$P(temstr,$C(2),8)
   ...S ResultTime=$P(temstr,$C(2),9)
   ...//&sql(select pbo_totalAmount into :totalAmount from user.DHC_PatBillOrder where pbo_oeori_dr=:rowid)
   ...S totalAmount=+totalAmount
   ...S (wardDr,queryCode,oeoreTime,ssUserDr,printUser,printDate,printTime,locDep)=""
   ...S num=num+1
   ...//需要增加病案号?姓名?条码号?开单科室?
   ...S Data=$lb(num,patID,Name,labepis,ordDate,ordTime,collDate,collTime,itmStat,ordDep,wardDr,resStus,oeoreTime,ssUserDr,printUser,printDate,printTime,itmName,recDep,reqUser,billed,ordDep,totalAmount,recDate,authDate,ResultTime)
   ...D Output
   S P0=num
   Q num 
OeoriEndDate()
 For Date=DateS:1:DateE Do
 .S rid="" F  S rid=$O(^DHCOrdExec(0,"Date",Date,rid)) Q:rid=""  Do
 ..S temstr=$G(^DHCOrdExec(rid))
 ..S stEndDate=$P(temstr,"^",13)
 ..S stEndTime=$P(temstr,"^",14)
 ..I '$L(stEndDate) Q
 ..I '$L(stEndTime) Q
 ..S oeoreDate=$P(temstr,"^",2)
 ..S oeorePrint=$P(temstr,"^",3)
 ..S ctLocDr=$P(temstr,"^",4)
 ..S wardDr=$P(temstr,"^",5)
 ..S queryCode=$P(temstr,"^",6)
 ..S oeoreTime=$P(temstr,"^",9)
 ..S ssUserDr=$P(temstr,"^",12)
 ..S printUser=$P(temstr,"^",15)
 ..S printDate=$P(temstr,"^",16)
 ..S printTime=$P(temstr,"^",17)
 ..S rowid=$P($P(^DHCOrdExec(rid),"^",1),"||",1,2)
 ..b ;1
 ..S arcim=$P(^OEORD($P(rowid,"||",1),"I",$P(rowid,"||",2),1),"^",2) Q:'$L(rowid)
 ..S itmcat=$P(^ARCIM($P(arcim,"||",1),$P(arcim,"||",2),1),"^",10) Q:'$L(itmcat)
 ..//增加病历号
 ..S (patID,patRowId,Name)=""
 ..S patID=$P(^OEORD($P(rowid,"||",1),"I",$P(rowid,"||",2),3),"^",9)
 ..I $L(Debtor)&&(Debtor'=patID) Q
 ..//通过病案号取姓名等信息
 ..I $L(patID) S patRowId=$O(^PAPERi("PAPMI_PatNo",patID,"")) 
 ..I $L(patRowId) S Name=$P(^PAPER(patRowId,"ALL"),"^",1)
 ..I $L(PatName)&(Name'[PatName) Q
 ..//取条码号?
 ..S labepis=$P(^OEORD($P(rowid,"||",1),"I",$P(rowid,"||",2),3),"^",20)
 ..I labepis="" Q
 ..S LabNo=$P(labepis,"||",1)
 ..I $P(^ARC("IC",itmcat),"^",7)'="L" Q
 ..S totalAmount=+$G(totalAmount)
 ..S stStartDate=""
 ..S execSub=$O(^OEORD($P(rowid,"||",1),"I",$P(rowid,"||",2),"X",""),-1)
 ..S billed=""
 ..I $L(execSub) S billed=$P(^OEORD($P(rowid,"||",1),"I",$P(rowid,"||",2),"X",execSub),"^",6)
 ..I $L(sttDate) S stStartDate=$ZD(sttDate,3)
 ..I $L(stEndDate) S stEndDate=$ZD(stEndDate,3)
 ..I $L(sttTime) S stStartTime=$ZT(sttTime)
 ..I $L(stEndTime) S stEndTime=$ZT(stEndTime)
 ..S totalAmount=+$G(totalAmount)
 ..;对日期查询进行判断?
 ..I ($P(TimeFlag,"^",1)="1")&&($ZDH(stEndDate,5)=DateS)&&($ZTH($P(TimeFlag,"^",2))>$ZTH(stEndTime)) q
 ..I ($P(TimeFlag,"^",1)="1")&&($ZDH(stEndDate,5)=DateE)&&($ZTH($P(TimeFlag,"^",3))<$ZTH(stEndTime)) q
 ..S printData=oeoreDate_"^"_oeorePrint_"^"_ctLocDr_"^"_wardDr_"^"_queryCode_"^"_oeoreTime_"^"_ssUserDr_"^"_printUser_"^"_printDate_"^"_printTime
 ..I itmDr="停止" S totalAmount=0
 ..S oeoreData=stStartDate_"^"_stStartTime_"^"_stEndDate_"^"_stEndTime_"^"_itmDr_"^"_itemStat_"^"_doctordr_"^"_locDep_"^"_billed_"^"_CliDep_"^"_totalAmount
 ..S episodeNo=$G(episodeNo)
 ..S labTestSet=$G(labTestSet)
 ..S patientData=""
 ..I episodeNo'="",labTestSet'="" D
 ...S patientData=$G(^TEPI($P(labTestSet,"||",1),1,$P(labTestSet,"||",2),$P(labTestSet,"||",3)))
 ..S sampAccDate=$P(patientData,"\",21)
 ..S sampAccTime=$P(patientData,"\",22)
 ..S sampSendDate=$P(patientData,"\",4)
 ..S sampSendTime=$P(patientData,"\",5)
 ..S:$L(sampAccDate) sampAccDate=$ZD(sampAccDate,3)
 ..S:$L(sampAccTime) sampAccTime=$ZT(sampAccTime*60)
 ..S:$L(sampSendDate) sampSendDate=$ZD(sampSendDate,3)
 ..S:$L(sampSendTime) sampSendTime=$ZT(sampSendTime*60)
 ..S num=num+1
 ..S Data=$lb(num,patID,Name,labepis,ordDate,ordTime,collDate,collTime,itmStat,ordDep,wardDr,resStus,oeoreTime,ssUserDr,printUser,printDate,printTime,itmName,recDep,reqUser,billed,ordDep,totalAmount,recDate,authDate,ResultTime)
 ..D Output
 ..S P0=num
 Q SQLCODE
   
   ;对接收到的所有标本取出其值?
ByAcceptDate(Date)
  ;取出接收发送时间?????
  S Date=$G(Date)
  S rectime="" F  S rectime=$O(^TDAY(10,Date,rectime)) Q:rectime=""  D
  .S PatType="" F  S PatType=$O(^TDAY(10,Date,rectime,PatType)) Q:PatType=""  D
  ..S XMMatch="" F  S XMMatch=$O(^TDAY(10,Date,rectime,PatType,XMMatch)) Q:XMMatch=""  D
  ...S VisitNumber="" F  S VisitNumber=$O(^TDAY(10,Date,rectime,PatType,XMMatch,VisitNumber)) Q:VisitNumber=""  D
  ....S TestsetDr="" F  S TestsetDr=$O(^TDAY(10,Date,rectime,PatType,XMMatch,VisitNumber,TestsetDr)) Q:TestsetDr=""  D
  .....S TestSetCounter="" F  S TestSetCounter=$O(^TDAY(10,Date,rectime,PatType,XMMatch,VisitNumber,TestsetDr,TestSetCounter)) Q:TestSetCounter=""  D
  ......;取出记录的所有信息,从AuthosizeTime中可以取出接收日期时间?发送日期时间?
  ......S AuthosizeTime=^TEPI(VisitNumber,1,TestsetDr,TestSetCounter)
  ......S sampAccDate=$P(AuthosizeTime,"\",21)
  ......S sampAccTime=$P(AuthosizeTime,"\",22)
  ......S sampSendDate=$P(AuthosizeTime,"\",4)
  ......S sampSendTime=$P(AuthosizeTime,"\",5)
  ......;获取标本接收,打印的时间信息?
  ......S:$L(sampAccDate) sampAccDate=$ZD(sampAccDate,3)
  ......S:$L(sampAccTime) sampAccTime=$ZT(sampAccTime*60)
  ......S:$L(sampSendDate) sampSendDate=$ZD(sampSendDate,3)
  ......S:$L(sampSendTime) sampSendTime=$ZT(sampSendTime*60)
  ......S sampDateTime=sampAccDate_" "_sampAccTime_"^"_sampSendDate_" "_sampSendTime_"^"_episodeNo
  ......;获取MEDDATA的信息?
  ......S temrowid=VisitNumber_"||"_TestsetDr_"||"_TestSetCounter
  ......S oeordId="" F  S oeordId=$O(^OEORD(0,"EpisNo",VisitNumber,oeordId)) Q:oeordId=""  D ;,4)=
  .......S temoeord=""
  .......S oeordSubId="" F  S oeordSubId=$O(^OEORD(0,"EpisNo",VisitNumber,oeordId,oeordSubId)) Q:(oeordSubId="")!$L(temoeord)  D
  ........S temstr=$G(^OEORD(oeordId,"I",oeordSubId,3))
  ........I $P(temstr,"^",35)'=temrowid Q
  ........S temoeord=oeordId_"||"_oeordSubId
  ........//增加病历号
  ........S (patID,patRowId,Name)=""
  ........S patID=$P(^OEORD(oeordId,"I",oeordSubId,3),"^",9)
  ........I $L(Debtor)&&(Debtor'=patID) Q
  ........//通过病案号取姓名等信息
  ........I $L(patID) S patRowId=$O(^PAPERi("PAPMI_PatNo",patID,"")) 
  ........I $L(patRowId) S Name=$P(^PAPER(patRowId,"ALL"),"^",1)
  ........I $L(PatName)&(Name'[PatName) Q
  ........//取条码号?
  ........S labepis=$P(^OEORD(oeordId,"I",oeordSubId,3),"^",20)
  ........I labepis="" Q
  ........S LabNo=$P(labepis,"||",1)
  ........I '$L(temoeord) Q
  ........S rowid=oeordId_"||"_oeordSubId
  ........S sttDate=$P(^OEORD(oeordId,"I",oeordSubId,1),"^",9)
  ........S sttTime=$P(^OEORD(oeordId,"I",oeordSubId,1),"^",10)
  ........S itmDr=$P(^OEORD(oeordId,"I",oeordSubId,1),"^",2)
  ........S itmStat=$P(^ARCIM($P(itmDr,"||",1),$P(itmDr,"||",2),1),"^",2)
  ........S DoctorDr=$P(^OEORD(oeordId,"I",oeordSubId,1),"^",11)
  ........S (DoctorDesc,LocDesc,CliDepDesc,recDep,ordDep)=""
  ........I $L(DoctorDr) S DoctorDesc=$P(^CTPCP(DoctorDr,1),"^",2)
  ........S LocDr=$P(^OEORD(oeordId,"I",oeordSubId,3),"^",6)
  ........I $L(LocDr) S recDep=$P(^CTLOC(LocDr),"^",2)
  ........S billed=$P(^OEORD(oeordId,"I",oeordSubId,3),"^",5)
  ........S CliDepDr=$P(^OEORD(oeordId,"I",oeordSubId,1),"^",3)
  ........I $L(CliDepDr) S ordDep=$P(^CTLOC(CliDepDr),"^",2)
  ........S episodeNo=$P(^OEORD(oeordId,"I",oeordSubId,3),"^",20)
  ........S labTestSet=$P(^OEORD(oeordId,"I",oeordSubId,3),"^",35)
  ........S PBORowid=$O(^DHCPBi(0,"OEORI",rowid,""))
  ........S PBOSubRowid=$O(^DHCPBi(0,"OEORI",rowid,PBORowid,""))
  ........S totalamount=$P(^DHCPB(PBORowid,"O",PBOSubRowid),"^",8)
  ........S (oeoreDate,oeorePrint,ctLocDr,wardDr,queryCode,oeoreTime,ssUserDr,printUser,printDate,printTime)=""
  ........S (stEndDate,stEndTime)=""
  ........S execSub=$O(^OEORD(oeordId,"I",oeordSubId,"X",""),-1)
  ........S billed=""
  ........I $L(execSub) S billed=$P(^OEORD(oeordId,"I",oeordSubId,"X",execSub),"^",6)
  ........S rid=$O(^DHCOrdExec(0,"OEOREDR",rowid_"||1",""))
  ........I $L(rid) D
  .........S temstr=$G(^DHCOrdExec(rid))
  .........S oeoreDate=$P(temstr,"^",2)
  .........S oeorePrint=$P(temstr,"^",3)
  .........//S ordDep=$P(temstr,"^",4)
  .........S wardDr=$P(temstr,"^",5)
  .........S resStus=$P(temstr,"^",6)
  .........S oeoreTime=$P(temstr,"^",9)
  .........S ssUserDr=$P(temstr,"^",12)
  .........S stEndDate=$P(temstr,"^",13)
  .........S stEndTime=$P(temstr,"^",14)
  .........S printUser=$P(temstr,"^",15)
  .........S printDate=$P(temstr,"^",16)
  .........S printTime=$P(temstr,"^",17)
  ........S stStartDate=""
  ........I $L(sttDate) S stStartDate=$ZD(sttDate,3)
  ........I $L(stEndDate) S stEndDate=$ZD(stEndDate,3)
  ........I '$L(stEndDate) S stEndTime=""
  ........I $L(sttTime) S stStartTime=$ZT(sttTime)
  ........I $L(stEndTime) S stEndTime=$ZT(stEndTime)
  ........I $L(oeoreDate) S oeoreDate=$ZD(oeoreDate,3)
  ........I $L(oeoreTime) S oeoreTime=$ZT(oeoreTime,2)
  ........I $L(printDate) S printDate=$ZD(printDate,3)
  ........I $L(printTime) S printTime=$ZT(printTime,2) 
  ........S totalAmount=+$G(totalAmount)
  ........S num=num+1
  ........S Data=$lb(num,patID,Name,labepis,ordDate,ordTime,collDate,collTime,itmStat,ordDep,wardDr,resStus,oeoreTime,ssUserDr,printUser,printDate,printTime,itmName,recDep,reqUser,billed,ordDep,totalAmount,recDate,authDate,ResultTime)
  ........D Output
  S P0=num
  Q 0
    
BySendDate(Date)
  S Date=$G(Date)
  ;^TEPIi("AUTHORISED",{VISTS_DateOfAuthorisation},{EP_VisitNumber.EPVIS_VisitNumber},{VISTS_TestSet_DR},{VISTS_TestSetCounter})
  S VisitNumber="" F  S VisitNumber=$O(^TEPIi("AUTHORISED",Date,VisitNumber)) Q:VisitNumber=""  D
  .S TestsetDr="" F  S TestsetDr=$O(^TEPIi("AUTHORISED",Date,VisitNumber,TestsetDr)) Q:TestsetDr=""  D
  ..S TestSetCounter="" F  S TestSetCounter=$O(^TEPIi("AUTHORISED",Date,VisitNumber,TestsetDr,TestSetCounter))  Q:TestSetCounter=""  D
  ...;获取MEDDATA的信息?
  ...D SetOrdInfo(VisitNumber,TestsetDr,TestSetCounter)
  Q 
SetOrdInfo(VisitNumber,TestsetDr,TestSetCounter) 
	S AuthosizeTime=^TEPI(VisitNumber,1,TestsetDr,TestSetCounter)
	S sampAccDate=$P(AuthosizeTime,"\",21)
	S sampAccTime=$P(AuthosizeTime,"\",22)
	S sampSendDate=$P(AuthosizeTime,"\",4)
	S sampSendTime=$P(AuthosizeTime,"\",5)
	;获取标本接收,打印的时间信息?
	S:$L(sampAccDate) sampAccDate=$ZD(sampAccDate,3)
	S:$L(sampAccTime) sampAccTime=$ZT(sampAccTime*60)
	S:$L(sampSendDate) sampSendDate=$ZD(sampSendDate,3)
	S:$L(sampSendTime) sampSendTime=$ZT(sampSendTime*60)
	S sampDateTime=sampAccDate_" "_sampAccTime_"^"_sampSendDate_" "_sampSendTime_"^"_episodeNo
	;获取MEDDATA的信息?
	S temrowid=VisitNumber_"||"_TestsetDr_"||"_TestSetCounter
	S oeordId="" F  S oeordId=$O(^OEORD(0,"EpisNo",VisitNumber,oeordId)) Q:oeordId=""  D ;,4)=
	.S temoeord=""
	.S oeordSubId="" F  S oeordSubId=$O(^OEORD(0,"EpisNo",VisitNumber,oeordId,oeordSubId)) Q:(oeordSubId="")!$L(temoeord)  D
	..S temstr=$G(^OEORD(oeordId,"I",oeordSubId,3))
	..I $P(temstr,"^",35)'=temrowid Q
	..S temoeord=oeordId_"||"_oeordSubId
	..//增加病历号
	..S (patID,patRowId,Name)=""
	..S patID=$P(^OEORD(oeordId,"I",oeordSubId,3),"^",9)
	..I $L(Debtor)&&(Debtor'=patID) Q
	..//通过病案号取姓名等信息
	..I $L(patID) S patRowId=$O(^PAPERi("PAPMI_PatNo",patID,"")) 
	..I $L(patRowId) S Name=$P(^PAPER(patRowId,"ALL"),"^",1)
	..I $L(PatName)&(Name'[PatName) Q
	..//取条码号?
	..S labepis=$P(^OEORD(oeordId,"I",oeordSubId,3),"^",20)
	..I labepis="" Q
	..S LabNo=$P(labepis,"||",1)
	..I '$L(temoeord) Q
	..S rowid=oeordId_"||"_oeordSubId
	..S sttDate=$P(^OEORD(oeordId,"I",oeordSubId,1),"^",9)
	..S sttTime=$P(^OEORD(oeordId,"I",oeordSubId,1),"^",10)
	..S itmDr=$P(^OEORD(oeordId,"I",oeordSubId,1),"^",2)
	..S itmStat=$P(^ARCIM($P(itmDr,"||",1),$P(itmDr,"||",2),1),"^",2)
	..S DoctorDr=$P(^OEORD(oeordId,"I",oeordSubId,1),"^",11)
	..S (DoctorDesc,LocDesc,CliDepDesc,recDep,ordDep)=""
	..I $L(DoctorDr) S DoctorDesc=$P(^CTPCP(DoctorDr,1),"^",2)
	..S LocDr=$P(^OEORD(oeordId,"I",oeordSubId,3),"^",6)
	..I $L(LocDr) S recDep=$P(^CTLOC(LocDr),"^",2)
	..S billed=$P(^OEORD(oeordId,"I",oeordSubId,3),"^",5)
	..S CliDepDr=$P(^OEORD(oeordId,"I",oeordSubId,1),"^",3)
	..I $L(CliDepDr) S ordDep=$P(^CTLOC(CliDepDr),"^",2)
	..S episodeNo=$P(^OEORD(oeordId,"I",oeordSubId,3),"^",20)
	..S labTestSet=$P(^OEORD(oeordId,"I",oeordSubId,3),"^",35)
	..S PBORowid=$O(^DHCPBi(0,"OEORI",rowid,""))
	..S PBOSubRowid=$O(^DHCPBi(0,"OEORI",rowid,PBORowid,""))
	..S totalamount=$P(^DHCPB(PBORowid,"O",PBOSubRowid),"^",8)
	..S (oeoreDate,oeorePrint,ctLocDr,wardDr,queryCode,oeoreTime,ssUserDr,printUser,printDate,printTime)=""
	..S (stEndDate,stEndTime)=""
	..S execSub=$O(^OEORD(oeordId,"I",oeordSubId,"X",""),-1)
	..S billed=""
	..I $L(execSub) S billed=$P(^OEORD(oeordId,"I",oeordSubId,"X",execSub),"^",6)
	..S rid=$O(^DHCOrdExec(0,"OEOREDR",rowid_"||1",""))
	..I $L(rid) D
	...S temstr=$G(^DHCOrdExec(rid))
	...S oeoreDate=$P(temstr,"^",2)
	...S oeorePrint=$P(temstr,"^",3)
	...//S ordDep=$P(temstr,"^",4)
	...S wardDr=$P(temstr,"^",5)
	...S resStus=$P(temstr,"^",6)
	...S oeoreTime=$P(temstr,"^",9)
	...S ssUserDr=$P(temstr,"^",12)
	...S stEndDate=$P(temstr,"^",13)
	...S stEndTime=$P(temstr,"^",14)
	...S printUser=$P(temstr,"^",15)
	...S printDate=$P(temstr,"^",16)
	...S printTime=$P(temstr,"^",17)
	..S stStartDate=""
	..I $L(sttDate) S stStartDate=$ZD(sttDate,3)
	..I $L(stEndDate) S stEndDate=$ZD(stEndDate,3)
	..I '$L(stEndDate) S stEndTime=""
	..I $L(sttTime) S stStartTime=$ZT(sttTime)
	..I $L(stEndTime) S stEndTime=$ZT(stEndTime)
	..I $L(oeoreDate) S oeoreDate=$ZD(oeoreDate,3)
	..I $L(oeoreTime) S oeoreTime=$ZT(oeoreTime,2)
	..I $L(printDate) S printDate=$ZD(printDate,3)
	..I $L(printTime) S printTime=$ZT(printTime,2) 
	..S totalAmount=+$G(totalAmount)
	..S num=num+1
	..S Data=$lb(num,patID,Name,labepis,ordDate,ordTime,collDate,collTime,itmStat,ordDep,wardDr,resStus,oeoreTime,ssUserDr,printUser,printDate,printTime,itmName,recDep,reqUser,billed,ordDep,totalAmount,recDate,authDate,ResultTime)
	..D Output
  S P0=num
  Q 0 

Output
	S Data=$lb(num,patID,Name,labepis,ordDate,ordTime,collDate,collTime,itmStat,ordDep,wardDr,resStus,oeoreTime,ssUserDr,printUser,printDate,printTime,itmName,recDep,reqUser,billed,ordDep,totalAmount,recDate,authDate,ResultTime)
 	S ^CacheTemp(repid,ind)=Data
 	S ind=ind+1
	Q
}

ClassMethod QueryTATStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryTATStatusExecute ]
{
 	S AtEnd=$LIST(qHandle,1)
 	S repid=$LIST(qHandle,2)
 	S ind=$LIST(qHandle,3)
 	S ind=$O(^CacheTemp(repid,ind))
 	I ind="" 
 	{				// I there are no more rows, finish fetching
 		S AtEnd=1
 		S Row=""
 	}
 	Else      
 	{	// fetch row
 		S Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	S qHandle=$lb(AtEnd,repid,ind)
	Q $$$OK
}

/// Creator：      Qiuxianfu
/// CreatDate：    20140331
/// Description:： 化验项目统计
/// Table：        无
/// Input：        DateS:起始时间(格式："2013-04-01")，DateE：结束时间(格式："2013-04-01"),User:检验科用户(必填只检索该用户所分配科室权限的数据),DepCode:检验科科室代码(为空将检索所有科室),MachCode:仪器代码为空取全部仪器,MachTG:仪器组代码为空取全部仪器分组，DateType：接收审核类型(0:按接收日期查询，1:按审核日期查询)，PatientType：病人类型为空默认检索全部类型(N:门诊,Y：住院,P：急诊,O：体检,GP：手工未上线病人")
/// Output：       TestCode:项目代码，TestName：项目名称，Type：项目类型，Number：项目数量
/// Return：       无
/// Others：       无
/// D ##class(%ResultSet).RunQuery("web.DHCLabStatTATStatus","QueryTATStatus","2013-05-14","2013-05-14","","1","","","","","","")
Query QueryTATStatus(DateS As %String, DateE As %String, DepCode As %String, DateType As %String, PatientType As %String, Labno As %String, Debtor As %String, PatName As %String, Doctor As %String, CliDepCode As %String, USERCODE As %String) As %Query(ROWSPEC = "num:%String,patID:%String,Name:%String,labepis:%String,ordDate:%String,ordTime:%String,collDate:%String,collTime:%String,itmStat:%String,ordDep:%String,wardDr:%String,resStus:%String,oeoreTime:%String,ssUserDr:%String,printUser:%String,printDate:%String,printTime:%String,itmName:%String,recDep:%String,reqUser:%String,billed:%String,ordDep:%String,totalAmount:%String,recDate:%String,authDate:%String,ResultTime:%String") [ SqlProc ]
{
}

ClassMethod GetSpecInfo(RowId As %String) As %String
{
   S rid=$O(^DHCOrdExec(0,"OEOREDR",RowId_"||1",""))
   S (collDate,collTime,collUser)=""
   I $L(rid) D
   .S temstr=$G(^DHCOrdExec(rid))
   .S collUser=$P(temstr,"^",12)
   .S collDate=$P(temstr,"^",13)
   .S collTime=$P(temstr,"^",14)
   Q collDate_","_collTime_","_collUser
}

ClassMethod GetLabTSInfo(RowId As %String) As %String
{
   I $L(RowId)<5 Q ""
   S labno=$P(RowId,"||",1)
   S ts=$P(RowId,"||",2)
   S tscnt=$P(RowId,"||",3)
   S sLabNameSpace="LABDATA"
   I '$D(^TEPI(labno,1,ts,tscnt)) Q $C(2,2,2,2,2,2,2,2)
   S temstr=$G(^TEPI(labno,1,ts,tscnt))
   S tsprice=0
   I $D(^[sLabNameSpace]DHCTestSetDetails(labno,ts)) D
   .S tsprice=+$P(^[sLabNameSpace]DHCTestSetDetails(labno,ts),"\",2)
   .S ^aa(2,RowId)=tsprice
   S recDate=$P(temstr,"\",21)
   I $L(recDate) S recDate=$ZD(recDate,3)
   S recTime=$P(temstr,"\",22)
   I $L(recTime) S recTime=$ZT(recTime*60,2)
   S recUser=$P(temstr,"\",36)
   S entryDate=$P(temstr,"\",1)
   I $L(entryDate) S entryDate=$ZD(entryDate,3)
   S entryTime=$P(temstr,"\",2)
   I $L(entryTime) S entryTime=$ZT(entryTime*60,2)
   S entryUser=$P(temstr,"\",3)
   S authDate=$P(temstr,"\",4)
   I $L(authDate) S authDate=$ZD(authDate,3)
   S authTime=$P(temstr,"\",5)
   I $L(authTime) S authTime=$ZT(authTime*60,2)
   S authUser=$P(temstr,"\",6)
   S resStusCode=$P(temstr,"\",31)
   S resStus="未审核"
   I resStusCode="A" s resStus="已审核"
   S ResultTime=""
   I $L(recDate),$L(authDate) D
   .I ($P(temstr,"\",5)*60)-($P(temstr,"\",22)*60)>=0 D
   ..S ResultDate=($P(temstr,"\",4)-$P(temstr,"\",21))
   ..S ResultDate=ResultDate_"天"
   ..S ResultTime=($P(temstr,"\",5)*60)-($P(temstr,"\",22)*60)
   ..S ResultTime=$ZT(ResultTime,1)
   ..S ResultTime=ResultDate_"  "_ResultTime
   .E  D
   ..S ResultDate=($P(temstr,"\",4)-$P(temstr,"\",21))-1
   ..S ResultDate=ResultDate_"天"
   ..S ResultTime=($P(temstr,"\",5)*60)-($P(temstr,"\",22)*60)+86399
   ..S ResultTime=$ZT(ResultTime,1)
   ..S ResultTime=ResultDate_"  "_ResultTime
   Q recDate_" "_recTime_$C(2)_recUser_$C(2)_entryDate_" "_entryTime_$C(2)_entryUser_$C(2)_authDate_" "_authTime_$C(2)_authUser_$C(2)_resStus_$C(2)_tsprice_$C(2)_ResultTime
}

ClassMethod QueryOeordInfo(OERowdId As %String) As %String
{
	S OERowdId=$G(OERowdId)
	S (itemStat,statDesc)=""
	S OrdId=$P(OERowdId,"||",1)
	S OrdSubId=$P(OERowdId,"||",2)
	S RowId=OERowdId
	S sttDate=$P(^OEORD(OrdId,I,OrdSubId,1),"^",9)
	S sttTime=$P(^OEORD(OrdId,I,OrdSubId,1),"^",10)
	S itemStat=$P(^OEORD(OrdId,I,OrdSubId,1),"^",13)
	I $L(itemStat) S statDesc=$P(^OEC("OSTAT",itemStat),"^",2)
	S itmDr=$P(^OEORD(OrdId,I,OrdSubId,1),"^",2)
	S itmDesc=$P(^ARCIM($P(itmDr,"||",1),$P(itmDr,"||",2),1),"^",2)
	S doctorDr=$P(^OEORD(OrdId,I,OrdSubId,1),"^",11)
	S locDep=""
	S billed=""
	S CliDep=""
	S episodeNo=""
	S labTestSet=""
}

/// 检查医嘱项目是否是否检验医嘱
ClassMethod isLabTS(ItemMast As %String) As %String
{
	s ItemMast=$g(ItemMast)
	s RtnValue="0"
	s ItmCat=$p(^ARCIM(+ItemMast,$p(ItemMast,"||",2),1),"^",10)
	i $l(ItmCat),$d(^ARC("IC",ItmCat)){
		i $p(^ARC("IC",ItmCat),"^",7)="L" s RtnValue="1"
	}
	Quit RtnValue
}

Storage Default
{
<Data name="DHCLabStatTATStatusDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCLabStatTATStatusD</DataLocation>
<DefaultData>DHCLabStatTATStatusDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCLabStatTATStatusD</IdLocation>
<IndexLocation>^web.DHCLabStatTATStatusI</IndexLocation>
<StreamLocation>^web.DHCLabStatTATStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
