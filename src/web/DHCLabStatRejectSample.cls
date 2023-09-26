Class web.DHCLabStatRejectSample Extends %Persistent
{

/// 拒收标本查询
Parameter BUILD = 60;

ClassMethod QuerySampleStatisticsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySampleStatisticsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// D ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// D ##class(%ResultSet).RunQuery("web.DHCLabStatRejectSample","QuerySampleStatistics","2013-04-01","2013-05-15","","","","","","")
ClassMethod QuerySampleStatisticsExecute(ByRef qHandle As %Binary, DateS As %String, DateE As %String, Debtor As %String, RejType As %String, USERCODE As %String) As %Status
{
  S repid=$I(^CacheTemp)
  I $G(ind)="" S ind=1
  S sLabNameSpace="LABDATA"	
  S sMedNameSpace="DHC-DATA"	
  I '$L(sLabNameSpace) S sLabNameSpace="LABDATA"
  I '$L(sMedNameSpace) S sMedNameSpace="DHC-DATA"
  S HospCode=$O(^TTABi("CC",1,""))
  S ^TMP("DHCLabStatRejectSample")=$lb(DateS,DateE,Debtor,RejType,USERCODE)
  Set DateS=$g(DateS),DateE=$g(DateE),Debtor=$g(Debtor),DepCodeDR=$g(DepCodeDR)
  I '$L(DateS) S DateS=$ZD(DateS,3)
  I '$L(DateE) S DateE=$ZD(DateE,3)
  S USERCODE=$G(USERCODE)
  I '$L(USERCODE) S USERCODE="demo"
  //S USERCODE=70251
  S UserDep=""
  I '$L(USERCODE)   Set qHandle=$lb(0,repid,0) Quit $$$OK
  S dep="" F  S dep=$o(^TTAB("UA",USERCODE,4,dep)) Q:dep=""  D
  .S UserDep=UserDep_dep
  Set CurrentWardDR=$g(CurrentWardDR),sLabNameSpace=$g(sLabNameSpace),sMedNameSpace=$g(sMedNameSpace)
  S RejType=$g(RejType),HospCode=$g(HospCode)
  I RejType="null" S RejType=""
  S ^TMP("DHCLabStatRejectSample")=DateS_","_DateE_","_Debtor_","_RejType
  s RejUsr=""
  s LabDep=""
  s fPatName=""
  ;命名空间初始化
  //Set OldNameSpace=$ZNSPACE
  Set:sLabNameSpace="" sLabNameSpace="labdata"
  Set:sMedNameSpace="" sMedNameSpace="Meddata"
 
  ;时间转换，默认查询所有,DateS,DateE传入格式为yyyy-MM-dd
  Do FormatInputDate
  Set sum=0
  Set (VisitNumber,PatName,PatGender,PatAge,PatLocation,PatBirthday)="" ;病人基本信息
  Set (DoctorCode,DoctorName,OrderDateS,OrderStTime,TestCode,TestSetName,TestItemDes)="" ;医嘱基本信息
  Set (CollectorName,CollectionDate,CollectionTime)=""            ;采集基本信息
  Set (UserRejectName,RejectDate,RejectTime,RejectComment)=""	  ;拒收基本信息
  Set (PatDepCode,PatCurrentWard,OEOrdItemRowID,OEORDRowId,OEOrdItemSub)=""
  Set (TestSetDR,TestSetCount,DebtorCode,UserRejectDR,CollectedByDR,TestSetRowId,CurrentWardDesc)=""
  Kill PLIST,^TMP($zn,$j)
  
  Set ReDelimiter=$C(2) ;记录内字段间的分隔符
 
  ;异常捕获，如发生异常则返回原来的命名空间
  ;NEW $ETRAP
  ;SET $ETRAP="Set $ZNSPACE=OldNameSpace  w ""Error:"",$STACK "
  
  ;转换命名空间到labdata
  //Set $ZNSPACE=sLabNameSpace
  Kill ^TMP($zn,$j)
  For  Set VisitNumber=$Order(^[sLabNameSpace]DHCRSi(1,0,VisitNumber)) Quit:VisitNumber=""  Do 
  .//y医院判断 
  .Set CurHospCode=$p($g(^TEPI(VisitNumber)),"\",26) 
  .;If $Length(HospCode),HospCode'=CurHospCode Quit
  .For  Set TestSetDR=$Order(^[sLabNameSpace]DHCRSi(1,0,VisitNumber,TestSetDR)) Quit:TestSetDR=""  Do
  ..For  Set TestSetCount=$Order(^[sLabNameSpace]DHCRSi(1,0,VisitNumber,TestSetDR,TestSetCount)) Quit:TestSetCount=""  Do
  ...Set RejectDate=$P(^[sLabNameSpace]DHCRS(VisitNumber,TestSetDR,TestSetCount),"\",4)   ;拒收日期
  ...;--------------------------------------------查询条件验证-日期
  ...Quit:(RejectDate<DateS)!(RejectDate>DateE) 
  ...;--------------------------------------------查询条件验证-拒收原因
  ...Set RejType1=$P($P(^[sLabNameSpace]DHCRS(VisitNumber,TestSetDR,TestSetCount),"\",11),"|",1)
  ...Quit:$l(RejType)&&(RejType'=RejType1)  
  ...;-------------------------------------------------------------
  ...
  ...Set DebtorCode=$P(^[sLabNameSpace]DHCRS(VisitNumber,TestSetDR,TestSetCount),"\",1)    ;病人登记号
  ...
  ...;--------------------------------------------查询条件验证-登记号
  ...If $l(Debtor) Quit:$$CheckDebtorNumBer(DebtorCode,Debtor)=0
  ...;---------------------------------------------------------------
  ...
  ...Set PatName=$P(^[sLabNameSpace]DHCRS(VisitNumber,TestSetDR,TestSetCount),"\",2)        ;病人姓名 
  ...Set RejectTime=$P(^[sLabNameSpace]DHCRS(VisitNumber,TestSetDR,TestSetCount),"\",5)     ;拒收时间
  ...Set UserRejectDR=$P(^[sLabNameSpace]DHCRS(VisitNumber,TestSetDR,TestSetCount),"\",6)   ;拒收者代码
  ...;b ;2
  ...Set:$d(^[sLabNameSpace]SSU("SSUSR",1,UserRejectDR)) UserRejectName=$P(^[sLabNameSpace]SSU("SSUSR",1,UserRejectDR),"^",2)
  ...Set:$d(^[sLabNameSpace]DHCTMPUSER(UserRejectDR)) UserRejectName=$p(^[sLabNameSpace]DHCTMPUSER(UserRejectDR),"\",2)
  ...Set RejectComment=$P(^[sLabNameSpace]DHCRS(VisitNumber,TestSetDR,TestSetCount),"\",11) ;拒收原因
  ...if $l(fPatName),PatName'[fPatName quit
  ...if $l(RejUsr),RejUsr'=UserRejectDR  quit
  ...if $l(LabDep),LabDep'=$E(TestSetDR) quit 
  ...I '$L(LabDep),UserDep'[$E(TestSetDR,1) Q
  ...;获取标本接收信息
  ...Set (ReceiveDate,ReceiveTime,ReceiveDateTime,ReceiveUserID,ReceiveName)=""
  ...If $Data(^TEPI(VisitNumber)) Do
  ....Set ReceiveDate=$P(^TEPI(VisitNumber),"\",32)
  ....Set ReceiveTime=$P(^TEPI(VisitNumber),"\",33)
  ....Set ReceiveDateTime=$zdt(ReceiveDate_","_ReceiveTime,3)
  ....Set ReceiveUserID=$P(^TEPI(VisitNumber),"\",30)
  ....Set:ReceiveUserID'="" ReceiveName=$P(^[sLabNameSpace]SSU("SSUSR",1,ReceiveUserID),"^",2)
  ...;获取检验套名称
  ...Set TestSetName=$$GetTestSetName(TestSetDR)
  ...
  ...;转换命名空间到meddata
  ...//Set $ZNSPACE=sMedNameSpace
  ...
  ...;根据检验号获得外部代码为TestSetDR的医嘱项目RowID
  ...Set OEOrdItemRowID=$$GetOEOrdItemRowID(VisitNumber,TestSetDR)
  ...
  ...;获得病人基本信息，病区，就诊科室，开医嘱医生等
  ...Do GetPatientInfo
  ...;获得标本采集人信息
  ...Do GetCollectorInfo
  ...
  ...;转换命名空间到labdata
  ...//Set $ZNSPACE=sLabNameSpace
  ...;保存一条记录
  ...Set sum=sum+1
  ...Do SaveResult
  ;保存所有结果到PLIST
  Do SaveResToPLIST

  ;PLIST结果按照拒收时间排序
  Do OrderPLISTByRejDate
  S Seq=0
  S Num1=$O(PLIST(""),-1)
  F i=1:1:Num1 
  { 
      S Seq=Seq+1
      S strText=PLIST(i)
	  //S Seq=""
	  S RejectDate=$P(strText,$C(2),1)
	  S RejectReason=$P(strText,$C(2),2)
	  S RejectUser=$P(strText,$C(2),3)
	  S PatDebtor=$P(strText,$C(2),4)
	  S PatName=$P(strText,$C(2),5)
	  S PatSex=$P(strText,$C(2),6)
	  S PatAge=$P(strText,$C(2),7)
	  S PatLabno=$P(strText,$C(2),8)
	  S TestSetDesc=$P(strText,$C(2),9)
	  S ReqTSDate=$P(strText,$C(2),10)
	  S ReqLoc=$P(strText,$C(2),11)
	  S ReqWard=$P(strText,$C(2),12)
	  S ReqDoctor=$P(strText,$C(2),13)
	  S BloodSampleDate=$P(strText,$C(2),14)
	  S BloodUser=$P(strText,$C(2),15)
	  S ReceiveUser=$P(strText,$C(2),15)
	  S ReceiveDate=$P(strText,$C(2),15)
	  S NurseName=$P(strText,$C(2),15)
	  S Field1=$P(strText,$C(2),15)
	  S Field2=$P(strText,$C(2),15)
	  S Field3=$P(strText,$C(2),15)
	  S Field4=$P(strText,$C(2),15)
	  S Field5=$P(strText,$C(2),15)
	  b ;2
	  S Data=$lb(Seq,RejectDate,RejectReason,RejectUser,PatDebtor,PatName,PatSex,PatAge,PatLabno,TestSetDesc,ReqTSDate,ReqLoc,ReqWard,ReqDoctor,BloodSampleDate,BloodUser,ReceiveUser,ReceiveDate,NurseName,Field1,Field2,Field3,Field4,Field5)
	  D Output
  }
  //Do OutputPlist
  Kill ^TMP($zn,$j)
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
  
FormatInputDate
  If DateS?4N1P1.2N1P1.2N 
  {
  	Set DateS=$zdh(DateS,3)
  }
  else
  {
 	 Set DateS=""
  }
  If DateE?4N1P1.2N1P1.2N
  {
  	Set DateE=$zdh(DateE,3)
  }
  else
  {
  	Set DateE=$p($h,",",1)
  }
 Quit
CheckDebtorNumBer(sDebtorNumber,dDebtorNumber)
  Set sDebtorNumber=$g(sDebtorNumber),dDebtorNumber=$g(dDebtorNumber)
  Set sDebtorNumber=$ZSTRIP(sDebtorNumber,"*W") ;替换所有的空白字符
  Set dDebtorNumber=$ZSTRIP(dDebtorNumber,"*W")
  Set sDebNumberLen=$l(sDebtorNumber),dDebNumberLen=$l(dDebtorNumber)
  Set Flag=sDebNumberLen-dDebNumberLen
  
  If Flag<0 Do
  .For k=1:1:(-Flag) Do
  ..Set sDebtorNumber="0"_sDebtorNumber
  
  If Flag>0 Do
  .For k=1:1:Flag Do
  ..Set dDebtorNumber="0"_dDebtorNumber
 
  if sDebtorNumber=dDebtorNumber Quit 1
  
  Quit 0
GetTestSetName(TestSetDR)
  Set TestSetCode=$g(TestSetDR)
  Quit:($Data(^TTAB("TS",TestSetCode))'=11)&($Data(^TTAB("TS",TestSetCode))'=1) ""
  Set TestSetData=^TTAB("TS",TestSetCode)
  Set TestSetName=$P(TestSetData,"\",1)
  Quit TestSetName
GetOEOrdItemRowID(VisitNumber,TestSetDR)
  Set VisitNumber=$g(VisitNumber),TestSetDR=$g(TestSetDR)
  Set OEORDRowId="",IsFindFlag=0,OEOrdItemRowID=""
  For  Set OEORDRowId=$Order(^OEORD(0,"EpisNo",VisitNumber,OEORDRowId)) Quit:(OEORDRowId="")!(IsFindFlag=1)  Do
  .Set OEOrdItemSub=""
  .For  Set OEOrdItemSub=$Order(^OEORD(0,"EpisNo",VisitNumber,OEORDRowId,OEOrdItemSub)) Quit:(OEOrdItemSub="")!(IsFindFlag=1)  Do
  ..Set OEOrdItemData1=^OEORD(OEORDRowId,"I",OEOrdItemSub,1)
  ..Set ARCIMRowId=$P(OEOrdItemData1,"^",2)
  ..
  ..;外部代码比较
  ..If $$CheckExtCode(ARCIMRowId,TestSetDR) Do  Quit
  ...Set IsFindFlag=1
  ...Set OEOrdItemRowID=OEORDRowId_"||"_OEOrdItemSub
 
 Quit OEOrdItemRowID
 
 ;检查Meddata中医嘱的外部代码是否与拒收的医嘱代码相同
 ;相同返回：1，不同则返回：0
CheckExtCode(ARCIMRowId,TestSetDR)
  Set ARCIMRowId=$g(ARCIMRowId),TestSetDR=$g(TestSetDR)
  Set ArcimSub="",ArcimVer="",ExtChildSub="",ExtCode="",isFindFlag=0
  Set ArcimSub=$P(ARCIMRowId,"||",1)
  Set ArcimVer=$P(ARCIMRowId,"||",2)
  For  Set ExtChildSub=$Order(^ARCIM(ArcimSub,ArcimVer,"EXT",ExtChildSub)) Quit:(ExtChildSub="")!(isFindFlag=1)  Do
  .Set DataFlag=$Data(^ARCIM(ArcimSub,ArcimVer,"EXT",ExtChildSub))
  .Quit:(DataFlag'=1)&(DataFlag'=11)
  .Set ExtCode=$P(^ARCIM(ArcimSub,ArcimVer,"EXT",ExtChildSub),"^",4)
  .Set:ExtCode=TestSetDR isFindFlag=1
  
  If $l(TestSetDR) Quit 1
  Quit 0 
GetPatientInfo
  Set OEOrdItemRowID=$g(OEOrdItemRowID)
  Quit:OEOrdItemRowID=""
  Quit:OEOrdItemRowID'["||" ""
  Set (OEORDRowId,OEOrdItemSub)=""
  Set OEORDRowId=$P(OEOrdItemRowID,"||",1)
  Set OEOrdItemSub=$P(OEOrdItemRowID,"||",2)
  
  Set OEOrdData=^OEORD(OEORDRowId)
  Set AdmDR=$p(OEOrdData,"^",1)
  Set AdmData=^PAADM(AdmDR)
  
  ;病人就诊科室
  Set PatDepCode=$P(AdmData,"^",4)
  Set PatLocation=$P(^CTLOC(PatDepCode),"^",2)   ;就诊部门信息，例如：NYMZ-内一门诊
   
  ;病人基本信息
  Set PAPMIDR=$P(AdmData,"^",1)
  Set PatData=^PAPER(PAPMIDR,"ALL")
  Set PatName=$P(PatData,"^",1)
  Set SexDR=$P(PatData,"^",7)
  Set PatGender=$P(^CT("SEX",SexDR),"^",2)
  Set PatBirthday=$P(PatData,"^",6)
  Set OEORIUserAdd=""
  ;开医嘱医生信息
  Set OEOrdItemData1=^OEORD(OEORDRowId,"I",OEOrdItemSub,1)
  Set OEOrdItemData3=^OEORD(OEORDRowId,"I",OEOrdItemSub,3)
  Set OEOrdItemData7=^OEORD(OEORDRowId,"I",OEOrdItemSub,7)
  Set OEORIUserAddDR=$P(OEOrdItemData7,"^",1)        ;开医嘱医生代码
  Set OEORIUserAddData=^SSU("SSUSR",OEORIUserAddDR)
  Set CareProvDR=$P(OEORIUserAddData,"^",14)
  
  Set DoctorName=$P(OEORIUserAddData,"^",2)          ;开医嘱医生姓名
  ;需要判断是否是医生
  //Set:$$doc^SSLAB3(CareProvDR)'=1 DoctorName=""      ;如果不是医生则医生名为空
  Set OrderDateS=$P(OEOrdItemData3,"^",7)           ;开医嘱日期
  Set OrderStTime=$P(OEOrdItemData1,"^",17)          ;开医嘱时间
  
  ;病区
  Set PatCurrentWard=$P(AdmData,"^",70)
  Quit:PatCurrentWard=""
  Quit:($Data(^PAWARD(PatCurrentWard))'=1)&($Data(^PAWARD(PatCurrentWard))'=11)
  Set CurrentWardDesc=$p(^PAWARD(PatCurrentWard),"^",2) ;病区描述信息，例如：NEBF-内二病房
  
 Quit
 
 
 ;获得标本采集人信息
GetCollectorInfo
  Quit:OEOrdItemRowID=""
  S (DhcOrdExeRowId,SpecCollectionData,OEOREChildSub)=""
  /*
  Set OEOREChildSub=""
  For  Set OEOREChildSub=$Order(^OEORD(OEORDRowId,"I",OEOrdItemSub,"X",OEOREChildSub)) Quit:OEOREChildSub=""  Do
  .Set DhcOrdExeRowId=""
  .Set DhcOrdExeRowId=$Order(^DHCOrdExec(0,"OEOREDR",OEORDRowId_"||"_OEOrdItemSub_"||"_OEOREChildSub,DhcOrdExeRowId))
  .Quit:DhcOrdExeRowId=""
  .Quit:$Data(^DHCOrdExec(DhcOrdExeRowId))'=1
  .Set SpecCollectionData=^DHCOrdExec(DhcOrdExeRowId)
  .Set CollectedByDR=$P(SpecCollectionData,"^",12)         ;采集人代码
  .Quit:CollectedByDR=""
  .Quit:'$d(^SSU("SSUSR",CollectedByDR))
  .Set CollectorName=$P(^SSU("SSUSR",CollectedByDR),"^",2) ;采集人姓名
  .Set CollectionDate=$P(SpecCollectionData,"^",13)        ;采集日期
  .Set CollectionTime=$P(SpecCollectionData,"^",14)        ;采集时间
  */
  S BloodSpecInfo=##class(web.DHCNurSpecerNo).GetspecCollDatetime(OEORDRowId_"||"_OEOrdItemSub)
  S CollectorName=""
  S CollectorID=$P(BloodSpecInfo,"^",1)
  I $L(CollectorID) Set CollectorName=$P(^SSU("SSUSR",CollectorID),"^",2) ;采集人姓名
  Set CollectionDate=$P(BloodSpecInfo,"^",2)        ;采集日期
  //I $L(CollectionDate) S CollectionDate=$ZD(CollectionDate,3)
  Set CollectionTime=$P(BloodSpecInfo,"^",3)        ;采集时间
  //I $L(CollectionTime) S CollectionTime=$ZT(CollectionTime,2)

  Quit
SaveResult
  ;日期时间拼接
  Set OrderDateSTime=$zdt(OrderDateS_","_OrderStTime,3)
  Set:OrderDateS="" OrderDateSTime=""
  Set CollectionDateTime=$zdt(CollectionDate_","_CollectionTime,3)
  Set:CollectionDate="" CollectionDateTime=""
  Set RejectDateTime=$zdt(RejectDate_","_RejectTime,3)
  Set:RejectDate="" RejectDateTime=""
 
  ;格式化科室和病区
  Set:PatLocation["-" PatLocation=$P(PatLocation,"-",2)
  Set:CurrentWardDesc["-" CurrentWardDesc=$P(CurrentWardDesc,"-",2)
  Set PatAge=$$CalAgeByBirthDay(PatBirthday)
  //执行护士
  S NurseId=""
  S NurseName=CollectorName
  S Field1=""
  S Field2=""
  S Field3=""
  S Field4=""
  S Field5=""
  ;记录结果拼接
  ;Set Record=""
  Set Record=RejectDateTime_ReDelimiter_RejectComment_ReDelimiter_UserRejectName_ReDelimiter
  Set Record=Record_DebtorCode_ReDelimiter_PatName_ReDelimiter_PatGender_ReDelimiter_PatAge_ReDelimiter
  Set Record=Record_VisitNumber_ReDelimiter_TestSetName_ReDelimiter_OrderDateSTime_ReDelimiter_PatLocation_ReDelimiter_CurrentWardDesc_ReDelimiter
  Set Record=Record_DoctorName_ReDelimiter_CollectionDateTime_ReDelimiter_CollectorName_ReDelimiter
  Set Record=Record_ReceiveDateTime_ReDelimiter_ReceiveName_ReDelimiter_NurseName_ReDelimiter
  Set Record=Record_Field1_ReDelimiter_Field2_ReDelimiter_Field3_ReDelimiter_Field4_ReDelimiter_Field5_ReDelimiter
  ;科室和病区过滤
  If (DepCodeDR'="")&(CurrentWardDR'="")
  {
	  If (DepCodeDR=PatDepCode)&(CurrentWardDR=PatCurrentWard)
	  {
	  ;Set ^TMP($zn,$j,"RES",VisitNumber_"|"_TestSetDR_"|"_TestSetCount)=Record
	  Set ^TMP($zn,$j,"RES",sum)=Record
	  }
  }
  elseif (DepCodeDR="")&(CurrentWardDR'="")&(CurrentWardDR=PatCurrentWard)
  {
      ;Set ^TMP($zn,$j,"RES",VisitNumber_"|"_TestSetDR_"|"_TestSetCount)=Record
      Set ^TMP($zn,$j,"RES",sum)=Record
  }
  elseif (DepCodeDR'="")&(CurrentWardDR="")&(DepCodeDR=PatDepCode)
  {
	  ;Set ^TMP($zn,$j,"RES",VisitNumber_"|"_TestSetDR_"|"_TestSetCount)=Record
	  Set ^TMP($zn,$j,"RES",sum)=Record
  }
  elseif (DepCodeDR="")&(CurrentWardDR="")
  {
      ;Set ^TMP($zn,$j,"RES",VisitNumber_"|"_TestSetDR_"|"_TestSetCount)=Record
      Set ^TMP($zn,$j,"RES",sum)=Record
  }
 Quit 
SaveResToPLIST
  Set ChildNode="",Num=1
  For  Set ChildNode=$Order(^TMP($zn,$j,"RES",ChildNode)) Quit:ChildNode=""  Do
  .Set PLIST(Num)=^TMP($zn,$j,"RES",ChildNode)
  .Set Num=Num+1  
  Set PLIST=$Order(PLIST(""),-1)
 Quit
OrderPLISTByRejDate
  S (i,j,RejectDTPos)=""
  Set RejectDTPos=1
  For i=1:1:PLIST do
  .For j=1:1:PLIST-i Do
  ..Set (RejectDatej1,RejectTimej1,RejectDatej2,RejectTimej2)=""
  ..Set RejectDateTimeData1=$p(PLIST(j),$C(2),RejectDTPos)
  ..Set RejectDateTimeData2=$p(PLIST(j+1),$C(2),RejectDTPos)
  ..Quit:(RejectDateTimeData1="")!(RejectDateTimeData2="")
  ..Set RejectDatej1=$P($zdth(RejectDateTimeData1,3),",",1)
  ..Set RejectTimej1=$P($zdth(RejectDateTimeData1,3),",",2)
  ..Set RejectDatej2=$P($zdth(RejectDateTimeData2,3),",",1)
  ..Set RejectTimej2=$P($zdth(RejectDateTimeData2,3),",",2)
  ..If RejectDatej1<RejectDatej2 Do  Quit
  ...Set tempPLISTstr=PLIST(j+1)
  ...Set PLIST(j+1)=PLIST(j)
  ...Set PLIST(j)=tempPLISTstr
  ..If RejectDatej1=RejectDatej2 Do  Quit
  ...If RejectTimej1<RejectTimej2 Do  Quit
  ....Set tempPLISTstr=PLIST(j+1)
  ....Set PLIST(j+1)=PLIST(j)
  ....Set PLIST(j)=tempPLISTstr
 Quit
CalAgeByBirthDay(Birthday)
  Set Birthday=$g(Birthday)
  Set (Age,AgeYear,AgeMonth,AgeDay)=""
  Set AgeData=$$CalAge(Birthday,+$H)
  Set AgeYear=$p(AgeData,"|",12),AgeMonth=$p(AgeData,"|",13),AgeDay=$p(AgeData,"|",14)
  Set Age=$Select($l(AgeYear)&(AgeYear'=0):AgeYear_"岁",$l(AgeMonth)&(AgeMonth'=0):AgeMonth_"个月",$l(AgeDay)&(AgeDay'=""):AgeDay_"天",1:"未知")
  Quit Age
CalAge(IBirth,IToday,EstMth,EstYr,EstStamp) 
 ; pass in date of birth in internal format
 ;
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
Output
    S Data=$lb(Seq,RejectDate,RejectReason,RejectUser,PatDebtor,PatName,PatSex,PatAge,PatLabno,TestSetDesc,ReqTSDate,ReqLoc,ReqWard,ReqDoctor,BloodSampleDate,BloodUser,ReceiveUser,ReceiveDate,NurseName,Field1,Field2,Field3,Field4,Field5)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QuerySampleStatisticsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySampleStatisticsExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$O(^CacheTemp(repid,ind))
 	If ind="" 
 	{				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      
 	{	// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      Qiuxianfu
/// CreatDate：    20140331
/// Description:： 样本数统计
/// Table：        
/// Input：        DateS:起始日期,DateE:结束日期，DepCode：检验科科室代码,MachCode仪器代码为空全部检索，MachTG：仪器组代码为空全部检索，CliCode：医生申请科室代码为空全部检索，DocCode:医生工号为空全部检索，PatientType：病人类型为空默认检索全部类型(N:门诊,Y：住院,P：急诊,O：体检,GP：手工未上线病人")
/// Output：       Debtor:登记号,PatName：病人姓名,SpeName：性别,PatAge：年龄,CliDepName：申请科室,Labno：检验号,TestName：医嘱名称,ColectDateTime:采集时间,RecevieDateTime:接收时间,AuthorDateTime:审核时间
/// Return：       无
/// Others：
/// D ##class(%ResultSet).RunQuery("web.DHCLabStatRejectSample","QuerySampleStatistics","2014-09-24","2014-09-24","","")
Query QuerySampleStatistics(DateS As %String, DateE As %String, Debtor As %String, RejType As %String, USERCODE As %String) As %Query(ROWSPEC = "Seq:%String,RejectDate:%String,RejectReason:%String,RejectUser:%String,PatDebtor:%String,PatName:%String,PatSex:%String,PatAge:%String,PatLabno:%String,TestSetDesc:%String,ReqTSDate:%String,ReqLoc:%String,ReqWard:%String,ReqDoctor:%String,BloodSampleDate:%String,BloodUser:%String,ReceiveUser:%String,ReceiveDate:%String,NurseName:%String,Field1:%String,Field2:%String,Field3:%String,Field4:%String,Field5:%String") [ SqlProc ]
{
}

/// W ##Class(web.DHCLabStatRejectSample).GetLabno()
ClassMethod GetLabno(OrdRowId As %String) As %String
{
	S OrdItem=""
	F
	{
		S OrdItem=$O(^DHCOrdExec(0,"OEOREDR",OrdItem))
		Q:OrdItem=""
		S OrdRowID=$P(OrdItem,"||",1)
		S OrdRowIDSub=$P(OrdItem,"||",2)
		S Labno=$P(^OEORD(OrdRowID,"I",OrdRowIDSub,3),"^",20)
		Continue:Labno=""
		W Labno,!
	} 
	Q 0
}

Storage Default
{
<Data name="DHCLabStatRejectSampleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCLabStatRejectSampleD</DataLocation>
<DefaultData>DHCLabStatRejectSampleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCLabStatRejectSampleD</IdLocation>
<IndexLocation>^web.DHCLabStatRejectSampleI</IndexLocation>
<StreamLocation>^web.DHCLabStatRejectSampleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
