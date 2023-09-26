Class web.DHCLabStatIntegrateQuery Extends %Persistent
{

/// 综合查询统计
Parameter BUILD = 60;

ClassMethod QuerySampleStatisticsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySampleStatisticsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// D ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// D ##class(%ResultSet).RunQuery("web.DHCLabStatIntegrateQuery","QuerySampleStatistics","2015-03-01","2015-03-20","demo","","","","","","","NYPOGP","0","","0","LIS01")
ClassMethod QuerySampleStatisticsExecute(ByRef qHandle As %Binary, DateS As %String, DateE As %String, User As %String, DepCode As %String, MachCode As %String, MachTG As %String, CliDep As %String, AuthosizeUserCode As %String, Doctor As %String, PatType As %String, DateType As %String, NameSpace As %String, EFlag As %String, USERCODE As %String) As %Status
{
  S repid=$I(^CacheTemp)
  I $G(ind)="" S ind=1	
  S DateS=$G(DateS),DateE=$G(DateE),User=$G(User),MachCode=$G(MachCode),MachTG=$G(MachTG),DepCode=$G(DepCode)
  S CliDep=$G(CliDep),AuthosizeUserCode=$G(AuthosizeUserCode),Doctor=$G(Doctor),PatType=$G(PatType),DateType=$G(DateType)
  S ^TMP("Inter")=$lb(DateS, DateE, User, DepCode, MachCode, MachTG, CliDep, AuthosizeUserCode, Doctor, PatType, DateType, NameSpace, EFlag, USERCODE)
  S USERCODE=$G(USERCODE)
  I '$L(USERCODE) S USERCODE="demo"
  //S USERCODE=70251
  S UserDep=""
  S HospitalCode=""
  S HospitalDesc=""
  I '$L(HospitalCode) S HospitalCode=$O(^TTABi("CC",1,""))
  I $L(HospitalCode) S HospitalDesc=$P(^TTAB("CC",HospitalCode),"\",1)
  I '$L(USERCODE)   Set qHandle=$lb(0,repid,0) Quit $$$OK
  S dep="" F  S dep=$o(^TTAB("UA",USERCODE,4,dep)) Q:dep=""  D
  .S UserDep=UserDep_dep
  I CliDep="null" S CliDep=""
  I MachCode="null" S MachCode=""
  S NameSpace=$G(NameSpace)
  I '$L(NameSpace) S NameSpace="LABDATA"
  I '$L(PatType) S PatType="N,Y,P,O,GP"
  I '$L(DateS) S DateS=$ZD(DateS,3)
  I '$L(DateE) S DateE=$ZD(DateE,3)
  S DateS=$zdh(DateS,3),DateE=$zdh(DateE,3)
  I DepCode="null" S DepCode=""
  K PLIST
  K ^mPLIST,^TMP($zn,$j)
  S ^TMP($zn,"pid",User)=$j
  ;根据用户取得访问科室 20080427
  I $L(DepCode) D
  .S ^TMP($zn,$j,"UA",DepCode)=""
  E  D
  .S Dep="" F  s Dep=$O(^TTAB("UA",User,4,Dep)) Q:Dep=""  D
  ..S ^TMP($zn,$j,"UA",Dep)=""
  S num=0,P0=0,sumPrice=0,P1=0
  F Date=DateS:1:DateE D
  .I DateType="0" D ByRecDate(Date)
  .E  D ByAuthDate(Date)
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
ByAuthDate(Date)
  S Date=$G(Date)
  S VisitNumber="" F  S VisitNumber=$O(^TEPIi("AUTHORISED",Date,VisitNumber)) Q:VisitNumber=""  D
  .//S TestsetDr="" F  S TestsetDr=$O(^TEPIi("AUTHORISED",Date,VisitNumber,TestsetDr)) Q:TestsetDr=""  D
  .//.S TestSetCounter="" F  S TestSetCounter=$O(^TEPIi("AUTHORISED",Date,VisitNumber,TestsetDr,TestSetCounter)) Q:TestSetCounter=""  D
  .//..S AuthosizeTime=$P(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",5) * 60
  .//..D SetSampleInfo(VisitNumber,TestsetDr,TestSetCounter)
  .D SetSampleInfo(VisitNumber)
  Q
ByRecDate(Date)
  S Date=$G(Date)
  F Time="" F  S Time=$O(^TDAY(10,Date,Time)) Q:Time=""  D
  .S PatientType="" F  S PatientType=$O(^TDAY(10,Date,Time,PatientType)) Q:PatientType=""  D
  ..S VisitNumber="" F  S VisitNumber=$O(^TDAY(10,Date,Time,PatientType,"N",VisitNumber)) Q:VisitNumber=""  D
  ...//S TestsetDr="" F  S TestsetDr=$O(^TDAY(10,Date,Time,PatientType,"N",VisitNumber,TestsetDr)) Q:TestsetDr=""  D
  ...//.S TestSetCounter="" F  S TestSetCounter=$O(^TDAY(10,Date,Time,PatientType,"N",VisitNumber,TestsetDr,TestSetCounter))  Q:TestSetCounter=""  D
  ...//..D SetSampleInfo(VisitNumber,TestsetDr,TestSetCounter)
  ...D SetSampleInfo(VisitNumber)
  Q
SetSampleInfo(VisitNumber)
  S VisitNumber=$G(VisitNumber)
  S TestsetDr=""
  K plTestSet
  F  S TestsetDr=$O(^TEPI(VisitNumber,1,TestsetDr)) Q:TestsetDr=""  D
  .S TestSetCounter=""
  .F  S TestSetCounter=$O(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter)) Quit:TestSetCounter=""  D
  ..S temMach=$P(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",27)
  ..I '$L(temMach) S temMach=+TestsetDr
  ..S temEpis=$P(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",12)
  ..S temMaEp=temMach_temEpis
  ..S plTestSet(temMaEp,TestsetDr)=""
  S temMaEp=""
  F  S temMaEp=$O(plTestSet(temMaEp)) Q:temMaEp=""  D
  .S TestSet="",TestName=""
  .F  S TestSet=$O(plTestSet(temMaEp,TestSet)) Q:TestSet=""  D
  ..S TestsetDr=TestSet
  ..I $D(^TTAB("TS",TestSet)) S TestName=TestName_$P(^TTAB("TS",TestSet),"\",1)_","
  .D SetSample(VisitNumber,TestsetDr,TestName)
  Q
SetSample(VisitNumber,TestsetDr,TestName)
  S TestSetCounter=$O(^TEPI(VisitNumber,1,TestsetDr,""))
  I $L($P(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",52)) Q ;标本异常处理 20080426
  S tempriordr=$P(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",10) //急诊标本处理
  I (EFlag=1),tempriordr'="U" Q
  S DebtorNumber=$P(^TEPI(VisitNumber),"\",18)
  S SurName=$P(^TEPI(VisitNumber),"\",2)
  S GenderId=$TR($P(^TEPI(VisitNumber),"\",3)," ")
  S Gender=""
  I GenderId'="" S Gender=$P(^TTAB("SP",GenderId),"\",1)
  S CliDepartCode=$P(^TEPI(VisitNumber),"\",36)
  S CliDeppartName=""
  I CliDepartCode'=""  S CliDeppartName=$P(^TTAB("USLOC",CliDepartCode),"\",1)
  I CliDeppartName["-" S CliDeppartName=$P(CliDeppartName,"-",2)
  S DoctorCode=$P(^TEPI(VisitNumber),"\",13)
  S DoctorName=""
  I DoctorCode'="" S DoctorName=$P(^TTAB("DR",DoctorCode),"\",1)
  //S Age=$P(^TEPI(VisitNumber),"\",25)
  S Age=##class(web.DHCLabCommonUse).GetPatAge(VisitNumber)
  S Age=##class(web.DHCLabCommonUse).AgeOut(Age)
  S MachineCode=$P(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",27)
  S MachineName=""
  I $L(MachineCode) S MachineName=$P($G(^TMIF(MachineCode)),"\",1)
  Q:(MachineName="")  //修改被删除掉的仪器的情况 ModI by cuilp 2010.2.11
  S Epis=$P(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",12)
  I PatType'[$P(^TEPI(VisitNumber),"\",48) Q ;GP->未上线,Y->住院,N->门诊,P->急诊
  I PatType="GP",$P(^TEPI(VisitNumber),"\",48)="P" Q
  I $L(MachCode),MachCode'=MachineCode Q
  ;caculate price-------->
  S TestSetPrice=""
  I $P(^TEPI(VisitNumber),"\",48)'="GP" D
  .S CollectDate=$P(^TEPI(VisitNumber),"\",10)
  .S TestSetRowID=VisitNumber_"||"_TestsetDr_"||"_TestSetCounter
  .S TestSetPrice=##class(web.DHCLabCommonUse).CalTestSetFee(VisitNumber,TestSetRowID,NameSpace,CollectDate)
  ;-----------------------
  S Depname=$P(^TTAB("DEP",$e(TestsetDr,1,1)),"\",1)
  ;
  S EnterUsr=$P(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",3)
  S AuthosizeUserNo=$P(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",6)
  I $L(MachTG),$L(MachCode),'$D(^TMIF(MachCode,"TG",MachTG,"TS",TestsetDr)) Q
  S CreateUserNo=$P(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",36)
  ;根据用户访问科室查询20080427
  I '$D(^TMP($zn,$j,"UA",$E(TestsetDr))) Q
  I $L(AuthosizeUserCode),AuthosizeUserCode'=AuthosizeUserNo Q
  I $L(CliDep),CliDep'=CliDepartCode Q
  I $L(Doctor),Doctor'=DoctorCode Q
  S AuthosizeDate=$P(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",4)
  S AuthosizeTime=$P(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",5) * 60
  I $L(AuthosizeDate) S AuthosizeDate=$zdt(AuthosizeDate_","_AuthosizeTime,3)
  ;I (TestsetDr[DepCode)&(AuthosizeUserNo[EnterMan)&(CliDepartCode[CliDep)&(DoctorCode[DocCode) D
  I '$L(DepCode),UserDep'[$E(TestsetDr,1) Q
  S num=num+1
  S TestSetName=TestsetDr
  //I $D(^TTAB("TS",TestsetDr)) S TestSetName=$P(^TTAB("TS",TestsetDr),"\",1)
  S TestSetName=$E(TestName,1,$L(TestName)-1)
  S StatusResult=$P(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",31)
  S StatusResult=$Select(StatusResult="":"",StatusResult="A":"审核",StatusResult="E":"录入",StatusResult="C":"登记",StatusResult="H":"复审",1:"")
  S SampleNo=$P(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",47) 
  S EnterDate=$P(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",1)
  S EnterTime=$P(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",2) * 60
  I $L(EnterDate) S EnterDate=$zdt(EnterDate_","_EnterTime,3)
  ;S AuthosizeUserNo=$P(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",6)
  S AuthosizeUser=""
  I AuthosizeUserNo'="" S AuthosizeUser=$P(^[NameSpace]SSU("SSUSR",1,AuthosizeUserNo),"^",2)
  S EnterUser=""
  I EnterUsr'="" S EnterUser=$P(^[NameSpace]SSU("SSUSR",1,EnterUsr),"^",2)
  S CreateUser=""
  I CreateUserNo'="" S CreateUser=$P(^[NameSpace]SSU("SSUSR",1,CreateUserNo),"^",2)
  S ReceiveDate=$P(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",21)
  S ReceiveTime=$P(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",22) * 60
  I $L(ReceiveDate) S ReceiveDate=$zdt(ReceiveDate_","_ReceiveTime,3)
  S CreateDate=$P(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",21)
  S PrintFlag=$P(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",28)
  I PrintFlag="Y" S PrintFlag="√"
  ///五个备用字段
  S Field1=HospitalDesc
  S Field2=""
  S Field3=""
  S Field4=""
  S Field5=""
  S CreateDate=ReceiveDate
  //接收科室
  S ReceDep=""
  S Data=$lb(Depname,DebtorNumber,SurName,Gender,Age,CliDeppartName,MachineName,Epis,VisitNumber,TestSetName,StatusResult,TestSetPrice,CreateUser,ReceiveDate,EnterUser,EnterDate,AuthosizeUser,AuthosizeDate,DoctorName,CreateDate,ReceDep,PrintFlag,Field1,Field2,Field3,Field4,Field5)
  D Output
  S sumPrice=sumPrice+TestSetPrice
  S P0=num,P1=sumPrice
  Q 
Output
	set Data=$lb(Depname,DebtorNumber,SurName,Gender,Age,CliDeppartName,MachineName,Epis,VisitNumber,TestSetName,StatusResult,TestSetPrice,CreateUser,ReceiveDate,EnterUser,EnterDate,AuthosizeUser,AuthosizeDate,DoctorName,CreateDate,ReceDep,PrintFlag,Field1,Field2,Field3,Field4,Field5)
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
/// CreatDate：    20140417
/// Description:： 综合查询
/// Table：        无
/// Input：        DateS:起始日期(格式如"2013-04-01"), DateE:结束日期(格式如"2013-05-15")，User:用户工号，DepCode：检验科室代码，MachCode：仪器代码，MachTG：仪器组代码，CliDep：申请科室代码，AuthosizeUserCode：审核用户，Doctor：医生工号，PatType：病人类型(为空默认所有病人，N:门诊,Y：住院,P：急诊,O：体检,GP：手工未上线病人),DateType：接收审核类型(0:按接收日期查询，1:按审核日期查询),NameSpace:检验组命名空间("LABDATA")
/// Output：       DepName:检验科室,DebtorNumber:登记号,SurName:姓名,Gender:标本,Age:年龄,CliDeppartName:申请科室,MachineName:检验仪器,Epis:流水号,VisitNumber:检验号,TestSetName:医嘱名称,StatusResult:结果状态,TestSetPrice:医嘱价格,CreateUser:接收用户,ReceiveDate:接收日期,EnterUser:化验用户,EnterDate:化验时间,AuthosizeUser:审核用户,AuthosizeDate:审核时间,DoctorName:医生,CreateDate:创建时间
/// Return：       无
/// Others：
/// D ##class(%ResultSet).RunQuery("web.DHCLabStatIntegrateQuery","QuerySampleStatistics","2013-04-01","2013-05-15","demo","","","","","","","","0","","0")
Query QuerySampleStatistics(DateS As %String, DateE As %String, User As %String, DepCode As %String, MachCode As %String, MachTG As %String, CliDep As %String, AuthosizeUserCode As %String, Doctor As %String, PatType As %String, DateType As %String, NameSpace As %String, EFlag As %String, USERCODE As %String) As %Query(ROWSPEC = "DepName:%String,DebtorNumber:%String,SurName:%String,Gender:%String,Age:%String,CliDeppartName:%String,MachineName:%String,Epis:%String,VisitNumber:%String,TestSetName:%String,StatusResult:%String,TestSetPrice:%String,CreateUser:%String,ReceiveDate:%String,EnterUser:%String,EnterDate:%String,AuthosizeUser:%String,AuthosizeDate:%String,DoctorName:%String,CreateDate:%String,ReceDep:%String,PrintFlag:%String,Field1:%String,Field2:%String,Field3:%String,Field4:%String,Field5:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCLabStatIntegrateQueryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCLabStatIntegrateQueryD</DataLocation>
<DefaultData>DHCLabStatIntegrateQueryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCLabStatIntegrateQueryD</IdLocation>
<IndexLocation>^web.DHCLabStatIntegrateQueryI</IndexLocation>
<StreamLocation>^web.DHCLabStatIntegrateQueryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
