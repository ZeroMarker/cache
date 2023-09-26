Class web.DHCLabStatPanicResult Extends %Persistent
{

/// 拒收标本查询
Parameter BUILD = 60;

ClassMethod QuerySampleStatisticsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySampleStatisticsExecute ]
{
	S repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Q $$$OK
}

/// Query的执行方法
/// D ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// D ##class(%ResultSet).RunQuery("web.DHCLabStatPanicResult","QuerySampleStatistics","2015-03-01","2015-03-20","","","6","","","","LIS01")
ClassMethod QuerySampleStatisticsExecute(ByRef qHandle As %Binary, DateS As %String, DateE As %String, Labno As %String, Debtor As %String, HospNo As %String, DepCode As %String, MachCode As %String, TC As %String, USERCODE As %String) As %Status
{
	S repid=$I(^CacheTemp)
	I $G(ind)="" S ind=1
	S sLabNameSpace="LABDATA"	
	S sMedNameSpace="DHC-DATA"	
	I '$L(sLabNameSpace) S sLabNameSpace="LABDATA"
	I '$L(sMedNameSpace) S sMedNameSpace="DHC-DATA"
	S HospCode=$O(^TTABi("CC",1,""))
	S sLabNameSpace=$G(sLabNameSpace),sMedNameSpace=$G(sMedNameSpace)
	S ^DHCTMP("Xq")=$lb(DateS, DateE, Labno, Debtor, HospNo, DepCode, MachCode, TC, USERCODE)
	S DateS=$G(DateS),DateE=$G(DateE),DepCode=$G(DepCode),MachCode=$G(MachCode),HospCode=$G(HospCode)
	S USERCODE=$G(USERCODE)
	I '$L(USERCODE) S USERCODE="demo"
	S UserDep=""
	I '$L(USERCODE)   Set qHandle=$lb(0,repid,0) Quit $$$OK
	S dep="" F  S dep=$o(^TTAB("UA",USERCODE,4,dep)) Q:dep=""  D
	.S UserDep=UserDep_dep
	S ^TMP("DHCLabStatRejectSample")=DateS_","_DateE_","_DepCode_","_MachCode_","_TC
	I '$L(DateS) S DateS=$ZD(DateS,3)
    I '$L(DateE) S DateE=$ZD(DateE,3)
	S DateS=$zdh(DateS,3),DateE=$zdh(DateE,3)
	I DepCode="null" S DepCode=""
	I MachCode="null" S MachCode=""
	I TC="null" S TC=""
	K ^TMP($zn)
	S num=1
	//I $L(HospNo),'$D(^TDEBj("HOSPITAL",HospNo)) Set qHandle=$lb(0,repid,0) Quit $$$OK
    S RetValue=100
    S GetDepCode=""
    I Labno'="" S (DateS,DateE)="" D GetByLabno(Labno,DateS,DateE,Debtor)
	I (Labno="")&((Debtor'="")!(HospNo'="")) D
	.I '$L(Debtor),$L(HospNo) S Debtor=##class(web.DHCLabCommonUse).GetDebnoByHospno(HospNo) I '$L(Debtor) S Debtor=##class(web.DHCLabCommonUse).GetDebnoByHospnoHIS(HospNo)
	.I '$D(^TDEBi(Debtor)) Q
	.S cdate="" F  S cdate=$O(^TDEBi(Debtor,"DATE",cdate)) Q:cdate=""  D
    ..S ctime="" F  S ctime=$O(^TDEBi(Debtor,"DATE",cdate,ctime)) Q:ctime=""  D
    ...S labno="" F  S labno=$O(^TDEBi(Debtor,"DATE",cdate,ctime,labno)) Q:labno=""  D
    ....D GetByLabno(labno,DateS,DateE,Debtor)
	I RetValue=0 S qHandle=$lb(0,repid,0) Q $$$OK
	I ($L(Debtor)!$L(HospNo)) S qHandle=$lb(0,repid,0) Q $$$OK
    F Date=DateS:1:DateE D
    .S LabNo="" F  S LabNo=$O(^TEPIi("AUTHORISED",Date,LabNo)) Q:LabNo=""  D
    ..S TS="" F  S TS=$O(^TEPIi("AUTHORISED",Date,LabNo,TS)) Q:TS=""  D
    ...S TSCnt="" F  S TSCnt=$O(^TEPIi("AUTHORISED",Date,LabNo,TS,TSCnt)) Q:TSCnt=""  D
    ....D GetFlag(LabNo,TS,TSCnt,DepCode)
    ....I RetValue=0 D GetPlist(LabNo,TS,TSCnt,DepCode,MachCode)  
    S qHandle=$lb(0,repid,0)
    Q $$$OK

GetFlag(LabNo,TS,TSCnt,DepCode)
    S RetValue=100
    S (Status,TransDate,TransTime,TransStr)=""
    I $L(DepCode)&($E(TS,1)'=DepCode) Q 100
    S Order=$O(^[sLabNameSpace]DHCPanicReport(1,LabNo,""))
    I '$L(Order) Q 100
    S TransDate=$P(^[sLabNameSpace]DHCPanicReport(1,LabNo,Order),"\",1)
    //S TransDate=$O(^[sLabNameSpace]DHCTSTrans(LabNo,TS,TSCnt,""),-1)
	I '$L(TransDate) Q 100
	S TransTime=$P(^[sLabNameSpace]DHCPanicReport(1,LabNo,Order),"\",2)
	//S TransTime=$O(^[sLabNameSpace]DHCTSTrans(LabNo,TS,TSCnt,TransDate,""),-1)
	//I '$L(TransTime) Q 100
	//S TransStr=$G(^[sLabNameSpace]DHCTSTrans(LabNo,TS,TSCnt,TransDate,TransTime))
	S TransStr=$G(^[sLabNameSpace]DHCPanicReport(1,LabNo,Order))
	I '$L(TransStr) Q 100
	//S Status=$P(TransStr,"\",2)
	S Status="PNC"
	//警戒报告
	I Status="PNC" S RetValue=0
	//荒诞报告
	I Status="RU" S RetValue=0
	
	//报告说明
	S TransMemoDr=$TR($P(TransStr,"\",8),$C(13,10))
	I TransMemoDr["}" D
	.S TransDr=$TR($TR(TransMemoDr,"{"),"}")
	.I $D(^[sLabNameSpace]DHCTSTransComment(TransDr)) S TransMemoDr=$P(^[sLabNameSpace]DHCTSTransComment(TransDr),"\",1)
	//S MemoDr=$P($P(TransMemoDr,"{",2),"}",1)
	S TransMemo=""
	//I $L(MemoDr),$D(^[sLabNameSpace]DHCTSTransComment(MemoDr)) S TransMemo=$P(^[sLabNameSpace]DHCTSTransComment(MemoDr),"\",1)
	//I '$L(MemoDr) S TransMemo=TransMemoDr
    I $L(TransMemoDr) S TransMemo=TransMemoDr
	Q RetValue
	
GetByLabno(Labno,DateS,DateE,Debtor)
    S ts="" F  S ts=$O(^TEPI(Labno,1,ts)) Q:ts=""  D
    .S tscnt="" F  S tscnt=$O(^TEPI(Labno,1,ts,tscnt)) Q:tscnt=""  D
    ..S AuthDate=$P($G(^TEPI(Labno,1,ts,tscnt)),"\",4)
    ..I $L(Debtor) D
    ...S RetStr=$$GetFlag(Labno,ts,tscnt,DepCode)
    ...I RetStr=0 D GetPlist(Labno,ts,tscnt,DepCode,MachCode)
    ..E  D
    ...S RetStr=$$GetFlag(Labno,ts,tscnt,DepCode)
    ...I RetStr=0 D GetPlist(Labno,ts,tscnt,DepCode,MachCode)
	Q 0

		
GetPlist(VisitNumber,TestsetDr,TSCnt,DepCode,MachCode)
    //登记号、姓名、性别、年龄、检验医嘱、标本、报告说明、报告日期、是否阅读、阅读人、阅读日期
    S (aa,OrderIdsub,DebtorNumber,FirstName,SurName,Name,SpeciesNo,SpeciesName,Age,specode,specmen,ReadFlag,Doctor,DocDate)=""
    S (temCDep,patloc,patloc1,patloc2,temPType)=""
    I DepCode'="",TestsetDr'[DepCode Q 
    S DebtorNumber=$P(^TEPI(VisitNumber),"\",18)              //登记号
    S FirstName=$P(^TEPI(VisitNumber),"\",2)
    S SurName=$P(^TEPI(VisitNumber),"\",2),Name=SurName
    I FirstName'=SurName S Name=FirstName_SurName 
    S SpeciesNo=$TR($P(^TEPI(VisitNumber),"\",3)," ")         //性别
    S SpeciesName=""
    I SpeciesNo'="" S SpeciesName=$P(^TTAB("SP",SpeciesNo),"\",1)
    S Age=##class(web.DHCLabCommonUse).GetPatAge(VisitNumber)
    S Age=##class(web.DHCLabCommonUse).AgeOut(Age) 
    I $D(^TTAB("TS",TestsetDr)) S TestSetName=$P(^TTAB("TS",TestsetDr),"\",1)  //检验医嘱
    //增加危机值显示。
    S TCResult=""
    I $D(^[sLabNameSpace]DHCTSTrans(VisitNumber,TestsetDr)) D
    .S TCCount="" F  S TCCount=$O(^[sLabNameSpace]DHCTSTrans(VisitNumber,TestsetDr,TCCount)) Q:TCCount=""  D
    ..S TCDate="" F  S TCDate=$O(^[sLabNameSpace]DHCTSTrans(VisitNumber,TestsetDr,TCCount,TCDate)) Q:TCDate=""  D
    ...S TCTime="" F  S TCTime=$O(^[sLabNameSpace]DHCTSTrans(VisitNumber,TestsetDr,TCCount,TCDate,TCTime)) Q:TCTime=""  Do
    ....S TCStr=$G(^[sLabNameSpace]DHCTSTrans(VisitNumber,TestsetDr,TCCount,TCDate,TCTime))
    ....S TCResult1=$P(TCStr,"\",5)
    ....F TCi=1:1:$L(TCResult1,",") D
    .....S TCResult1=$P(TCResult1,",",TCi)
    .....I TCResult1="" Q
    .....S TCResultName=$P($G(^TTAB("TC",$P(TCResult1,":",1))),"\",1)
    .....S TCResult=TCResult_" "_TCResultName_":"_$P(TCResult1,":",2)
    I $D(^[sLabNameSpace]DHCPanicReport(1,VisitNumber)) D
    .S Order=$O(^[sLabNameSpace]DHCPanicReport(1,VisitNumber,""))
    .S TCCode=""
    .S TestName=""
    .F  S TCCode=$O(^[sLabNameSpace]DHCPanicReport(1,VisitNumber,Order,"TC",TCCode)) Q:TCCode=""  D
    ..S TCName=$P(^TTAB("TC",TCCode),"\",1)
    ..I $L(TC),TC'=TCCode Q
    ..//S TestName=TestName_TCName_":"
    ..//S TestSetName=$E(TestName,1,$L(TestName)-1)
    ..S result=$P(^TEPI(VisitNumber,1,TestsetDr,TSCnt,"DATA",TCCode),"\",1)
    ..//Set TestSetName=TCResult
    ..S temCDep=$P(^TEPI(VisitNumber),"\",36)  //申请科室
    ..S temWard=$P(^TEPI(VisitNumber),"\",54)  //申请科室
    ..S Ward=""
    ..I $L(temCDep) D
    ...S patloc=""
    ...I $L(temCDep),$D(^TTAB("USLOC",temCDep)) S patloc=$P(^TTAB("USLOC",temCDep),"\",1)
    ...S patloc1=$P(patloc,"-",1),patloc2=$P(patloc,"-",2)
    ...I $L(patloc2)  D
    ....S patloc=patloc2
    ...E  D
    ....S patloc=patloc1
    ..I $L(temWard) D
    ...S Ward=$P(^TTAB("RH",temWard),"\",1)
    ...I $L(Ward,"-")=2 S Ward=$P(Ward,"-",2)
    ..S ReqDoctorCode=$P(^TEPI(VisitNumber),"\",13)
    ..S ReqDoctorName=""
    ..I ReqDoctorCode'="" S ReqDoctorName=$P(^TTAB("DR",ReqDoctorCode),"\",1)
    ..S (room,bed,BG)=""
    ..I $D(^TEPI(VisitNumber,0)) D
    ...S patPhoneHome=$P(^TEPI(VisitNumber,0),"\",12)
    ...S patAddress1=$P(^TEPI(VisitNumber,0),"\",1)
    ...S room=$P(^TEPI(VisitNumber,0),"\",28)  ;房间号
    ...S bed=$P(^TEPI(VisitNumber,0),"\",29)	 ;床号
    ..S specode=$P(^TEPI(VisitNumber,1,TestsetDr,TSCnt),"\",46)
    ..S authusr=""
    ..S authusr1=$P(^TEPI(VisitNumber,1,TestsetDr,TSCnt),"\",6) 
    ..I authusr1'="",$D(^[sLabNameSpace]SSU("SSUSR",1,authusr1)) S authusr=$P(^[sLabNameSpace]SSU("SSUSR",1,authusr1),"^",2)
    ..//仪器代码
    ..S machdr=$P(^TEPI(VisitNumber,1,TestsetDr,TSCnt),"\",27)
    ..I $L(MachCode),MachCode'=machdr Q
    ..I '$L(DepCode),UserDep'[$E(TestsetDr,1) Q
    ..I specode'="",$D(^TTAB("SPEC",specode)) S specmen=$P(^TTAB("SPEC",specode),"\",1)  //标本
    ..S temPType=$P(^TEPI(VisitNumber),"\",48)
    ..S AuditDate1=$P(^TEPI(VisitNumber,1,TestsetDr,TSCnt),"\",1)    //审核日期
    ..I $L(AuditDate1) S AuditDate=$zd(AuditDate1,3)
    ..S AuditTime1=$P(^TEPI(VisitNumber,1,TestsetDr,TSCnt),"\",2)    //审核日期
    ..I $L(AuditTime1) S AuditTime=$zt(AuditTime1*60)
    ..//判断日期时间
    ..S episode=$P(^TEPI(VisitNumber,1,TestsetDr,TSCnt),"\",12)	
    ..S aa=VisitNumber_"||"_TestsetDr_"||"_TSCnt
    ..//到websys.Log取得是否阅读了报告等信息
    ..S (OrdItmId,OrderIdsub,OrderId,ReadFlag)=""
    ..S adm=""
    ..I $D(^OEORD(0,"EpisNo",VisitNumber)) D
    ...S OrdItmId=$O(^OEORD(0,"EpisNo",VisitNumber,""))
    ...S OrderIdsub=$O(^OEORDi(0,"LabTS",OrdItmId,aa,OrderIdsub))
    ...S OrderId=OrdItmId_"||"_OrderIdsub
    ...//LogonLocation:报告是否被阅读；UserDR：阅读人；AuditDate：阅读日期
    ...//d GetDocMeg^DHCLtkCritical(OrderId)
    ...S ReadFlag=##Class(web.DHCLabReportControl).ReportViewLog(OrderId)
    ...S ReadDoctor=##Class(web.DHCLabReportControl).ReportDoctor(OrderId)
    ...S Doctor=$P(ReadDoctor,"^",1)
    ...S DocDate=$P(ReadDoctor,"^",2)
    ...I ReadFlag="100" S ReadFlag="否"
    ...E  S ReadFlag="是"
    ..S num=num+1
    ..S TSRowID=VisitNumber_"||"_TestsetDr_"||"_TSCnt
    ..S PatBasicInfo=patloc_" "_bed
    ..S str=VisitNumber_"||"_TestsetDr_"||"_TSCnt_$c(2)_DebtorNumber_$c(2)_Name_$c(2)_SpeciesName_$c(2)_Age_$c(2)_VisitNumber_$c(2)_TestSetName_$c(2)_specmen_$c(2)_TransMemo_$c(2)_AuditDate_$c(2)_AuditTime_$c(2)_ReadFlag_$c(2)_ReqDoctorName_$c(2)_DocDate_$c(2)_OrderId_$c(2)_patloc_" "_bed_$C(2)_authusr_$C(2)_episode
    ..S ^TMP($zn,$j,num)=str
    ..S hospNo=##class(web.DHCLabCommonUse).GetHospnoByDebno(DebtorNumber)
    ..I $L(HospNo),HospNo'=hospNo Q
    ..///五个备用字段
    ..S Field1=""
    ..S Field2=""
    ..S Field3=""
    ..S Field4=""
    ..S Field5=""
    ..S Data=$lb(VisitNumber,TCName,result,TSRowID,hospNo,DebtorNumber,Name,SpeciesName,Age,VisitNumber,TestSetName,specmen,TransMemo,AuditDate,AuditTime,ReadFlag,DoctorName,Doctor,DocDate,OrderId,patloc,Ward,bed,authusr,episode,Field1,Field2,Field3,Field4,Field5)
    ..D Output
    Q

Output
    S Data=$lb(VisitNumber,TCName,result,TSRowID,hospNo,DebtorNumber,Name,SpeciesName,Age,VisitNumber,TestSetName,specmen,TransMemo,AuditDate,AuditTime,ReadFlag,DoctorName,Doctor,DocDate,OrderId,patloc,Ward,bed,authusr,episode,Field1,Field2,Field3,Field4,Field5)
 	S ^CacheTemp(repid,ind)=Data
 	S ind=ind+1
	Q
}

ClassMethod QuerySampleStatisticsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySampleStatisticsExecute ]
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
 	s qHandle=$lb(AtEnd,repid,ind)
	Q $$$OK
}

/// Creator：      Qiuxianfu
/// CreatDate：    20140331
/// Description:： 样本数统计
/// Table：        
/// Input：        DateS:起始日期,DateE:结束日期，DepCode：检验科科室代码,MachCode仪器代码为空全部检索，MachTG：仪器组代码为空全部检索，CliCode：医生申请科室代码为空全部检索，DocCode:医生工号为空全部检索，PatientType：病人类型为空默认检索全部类型(N:门诊,Y：住院,P：急诊,O：体检,GP：手工未上线病人")
/// Output：       Debtor:登记号,PatName：病人姓名,SpeName：性别,PatAge：年龄,CliDepName：申请科室,Labno：检验号,TestName：医嘱名称,ColectDateTime:采集时间,RecevieDateTime:接收时间,AuthorDateTime:审核时间
/// Return：       无
/// Others：
/// D ##class(%ResultSet).RunQuery("web.DHCLabStatPanicResult","QuerySampleStatistics","2013-4-01","2013-5-14","A","","","")
Query QuerySampleStatistics(DateS As %String, DateE As %String, Labno As %String, Debtor As %String, HospNo As %String, DepCode As %String, MachCode As %String, TC As %String, USERCODE As %String) As %Query(ROWSPEC = "VisitNumber:%String,TCName:%String,result:%String,TSRowID:%String,hospNo:%String,DebtorNumber:%String,Name:%String,SpeciesName:%String,Age:%String,VisitNumber:%String,TestSetName:%String,specmen:%String,TransMemo:%String,AuditDate:%String,AuditTime:%String,ReadFlag:%String,DoctorName:%String,Doctor:%String,DocDate:%String,OrderId:%String,patloc:%String,Ward:%String,bed:%String,authusr:%String,episode:%String,Field1:%String,Field2:%String,Field3:%String,Field4:%String,Field5:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCLabStatPanicResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCLabStatPanicResultD</DataLocation>
<DefaultData>DHCLabStatPanicResultDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCLabStatPanicResultD</IdLocation>
<IndexLocation>^web.DHCLabStatPanicResultI</IndexLocation>
<StreamLocation>^web.DHCLabStatPanicResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
