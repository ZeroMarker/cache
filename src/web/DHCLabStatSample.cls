Class web.DHCLabStatSample Extends %Persistent
{

/// 样本数量统计
Parameter BUILD = 60;

ClassMethod QuerySampleStatisticsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySampleStatisticsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// D ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// D ##class(%ResultSet).RunQuery("web.DHCLabStatSample","QuerySampleStatistics","2013-04-01","2013-05-15","","","","","","")
ClassMethod QuerySampleStatisticsExecute(ByRef qHandle As %Binary, DateS As %String, DateE As %String, DepCode As %String, MachCode As %String, MachTG As %String, CliCode As %String, DocCode As %String, PatType As %String, TestSetGroup As %String, USERCODE As %String) As %Status
{
  S repid=$I(^CacheTemp)
  I $G(ind)="" S ind=1
  S NameSpace="LABDATA"	
  I '$L(NameSpace) S NameSpace="LABDATA"
  S DateS=$G(DateS),DateE=$G(DateE),MachCode=$G(MachCode),MachTG=$G(MachTG)
  S USERCODE=$G(USERCODE)
  I '$L(USERCODE) S USERCODE="demo"
  //S USERCODE=70251
  S UserDep=""
  I '$L(USERCODE)   Set qHandle=$lb(0,repid,0) Quit $$$OK
  S dep="" F  S dep=$o(^TTAB("UA",USERCODE,4,dep)) Q:dep=""  D
  .S UserDep=UserDep_dep
  S CliCode=$G(CliCode),DocCode=$G(DocCode),TestSetGroup=$G(TestSetGroup)
  I CliCode="null" S CliCode=""
  I MachCode="null" S MachCode=""
  S RecUserCode=$G(RecUserCode),DepCode=$G(DepCode),flag=$G(flag),infostr=$G(infostr)
  S ^TMP("Samp2")=DateS_","_DateE_","_DepCode_","_MachCode_","_MachTG_","_CliCode_","_DocCode_","_PatType_","_TestSetGroup_","_USERCODE
  I '$L(DateS) S DateS=$ZD(DateS,3)
  I '$L(DateE) S DateE=$ZD(DateE,3)
  S DateS=$ZDH(DateS,3),DateE=$ZDH(DateE,3)
  S PatType=$G(PatType)
  S TestSetGroup=TestSetGroup_","
  K ^TMP($zn,$j)
  F Date=DateS:1:DateE D
  .S Time="" F  S Time=$O(^TDAY(10,Date,Time)) Q:Time=""  D
  ..I $L(PatType) D WorkList1(Date,Time,PatType,DepCode)
  ..I '$L(PatType) D WorkList2(Date,Time,DepCode)
  S Num=1
  S (CollectDT,CollectDate,CollectTime,ReceiveDT,ReceiveDate,ReceiveTime,AuthorDT,AuthorDate,AuthorTime)=""
  S Labno=""  F  S Labno=$O(^TMP($zn,$j,"ts",Labno)) Q:Labno=""  D
  .S TestName="",MachName="",temMachCode="",MachEpis=""
  .S TestSet=""  F  S TestSet=$O(^TMP($zn,$j,"ts",Labno,TestSet)) Q:TestSet=""  D
  ..S TestSetCounter=""  F  S TestSetCounter=$O(^TMP($zn,$j,"ts",Labno,TestSet,TestSetCounter)) Q:TestSetCounter=""  D
  ...;machine
  ...S temMach=$P(^TEPI(Labno,1,TestSet,TestSetCounter),"\",27)
  ...I $L(TestSetGroup)>2,TestSetGroup'[TestSet_"," Q 
  ...I MachCode'="",MachCode'=temMach Q
  ...I $l(DepCode),DepCode'=$E(TestSet,1) Q 
  ...I '$L(DepCode),UserDep'[$E(TestSet,1) Q
  ...;是否在仪器测试组中^TMIF("BH7600","TG","H7600","TS","B001")=
  ...I $L(MachCode),$L(MachTG),'$D(^TMIF(MachCode,"TG",MachTG,"TS",TestSet)) Q
  ...;receive user
  ...S temUser=""
  ...S CollectDate=""
  ...S CollectTime=""
  ...S CollectDateTime=""
  ...I $D(^OEORD(0,"EpisNo",Labno)) D
  ....S OrdId=$O(^OEORD(0,"EpisNo",Labno,""))
  ....S OrdSubId=$O(^OEORD(0,"EpisNo",Labno,OrdId,""))
  ....S SpecCollDT=##class(web.DHCNurSpecerNo).GetspecCollDatetime(OrdId_"||"_OrdSubId)
  ....S temUser=$P(SpecCollDT,"^",1)
  ....S CollectDate=$P(SpecCollDT,"^",2)
  ....S CollectTime=$P(SpecCollDT,"^",3)
  ...//I '$L(CollectDate) D
  ...//.S temUser=$P(^TEPI(Labno,1,TestSet,TestSetCounter),"\",36)
  ...//.S CollectDate=$P(^TEPI(Labno,1,TestSet,TestSetCounter),"\",44)
  ...//.S CollectTime=$P(^TEPI(Labno,1,TestSet,TestSetCounter),"\",45)
  ...I $L(CollectDate),$L(CollectTime) D
  ....S CollectDate=$ZD(CollectDate,3)
  ....S CollectTime=$ZT(CollectTime,2)
  ....S CollectDateTime=CollectDate_" "_CollectTime
  ...S ReceiveDate=$P(^TEPI(Labno,1,TestSet,TestSetCounter),"\",21)
  ...S ReceiveTime=$P(^TEPI(Labno,1,TestSet,TestSetCounter),"\",22)
  ...I $L(ReceiveDate),$L(ReceiveTime) D
  ....S ReceiveDate=$ZD(ReceiveDate,3)
  ....S ReceiveTime=$ZT(ReceiveTime*60,2)
  ....S ReceiveDateTime=ReceiveDate_" "_ReceiveTime
  ...S AuthorDate=$P(^TEPI(Labno,1,TestSet,TestSetCounter),"\",4)
  ...S AuthorTime=$P(^TEPI(Labno,1,TestSet,TestSetCounter),"\",5)
  ...I $L(AuthorDate),$L(AuthorTime) D
  ....S AuthorDate=$ZD(AuthorDate,3)
  ....S AuthorTime=$ZT(AuthorTime*60,2)
  ....S AuthorDateTime=AuthorDate_" "_AuthorTime
  ...I $L(RecUserCode),RecUserCode'=temUser Q
  ...;输出结果:检验号?医嘱?临床科室?患者?流水号?仪器?接收日期?接收时间?接收者
  ...I '$L(TestName) D
  ....S TestName=$P(^TTAB("TS",TestSet),"\",2)
  ...E  D
  ....S TestName=TestName_","_$P(^TTAB("TS",TestSet),"\",2)
  ...;
  ...I $L(temMach),'$L(temMachCode)  D
  ....S temMachcode=temMach
  ....I $D(^TMIF(temMach)) S MachName=$P(^TMIF(temMach),"\",1)
  ...I $L(temMach),$L(temMachCode)  D
  ....S temStr1=","_temMachCode_",",temStr2=","_temMach_","
  ....I temStr1[temStr2 Q
  ....S temMachCode=temMachCode_","_temMach
  ....S MachName=MachName_","_$P(^TMIF(temMach),"\",1)
  ...;receive date time user
  ...S RecDate=$P(^TEPI(Labno,1,TestSet,TestSetCounter),"\",21)
  ...I $L(RecDate) S RecDate=$zd(RecDate,3)
  ...S RecTime=$P(^TEPI(Labno,1,TestSet,TestSetCounter),"\",22)
  ...I $L(RecTime) S RecTime=$zt(RecTime*60,2)
  ...S RecUserName=""
  ...I $L(temUser),$D(^[NameSpace]SSU("SSUSR",1,temUser)) s RecUserName=$P(^[NameSpace]SSU("SSUSR",1,temUser),"^",2)
  .I '$L(TestName) Q
  .;patname
  .S PatName=##class(web.DHCLabCommonUse).GetPatName(Labno)
  .;
  .S CliDepCode=$P(^TEPI(Labno),"\",36)
  .//I $L(CliCode),CliCode'=$E(TestSet,1,1) q
  .I $L(CliCode),CliCode'=CliDepCode q
  .S CliDepName=""
  .I $L(CliDepCode),$D(^TTAB("USLOC",CliDepCode)) s CliDepName=$P(^TTAB("USLOC",CliDepCode),"\",1)
  .S (temName1,temName2)=""
  .I $L(CliDepName) S temName1=$P(CliDepName,"-",1),temName2=$P(CliDepName,"-",2)
  .I $L(temName2) S CliDepName=temName2
  .;
  .S temDocdr=$P(^TEPI(Labno),"\",13)
  .I $L(DocCode),DocCode'=temDocdr Q
  .;get second no and position 20061116
  .S SecondLabno=##class(web.DHCLabCommonUse).GetSndLabNo(Labno,NameSpace)
  .S Position=""
  .I $D(^[NameSpace]DHCSndLabNo(Labno)) S Position=$P(^[NameSpace]DHCSndLabNo(Labno),"\",2)
  .;20070903
  .;debto
  .I $P(^TEPI(Labno),"\",48)="GP" D
  ..S Debtor=##class(web.DHCLabCommonUse).GetHospnoByDebno($P(^TEPI(Labno),"\",18))
  .E  D
  ..S Debtor=$P(^TEPI(Labno),"\",18)
  .;hosptial
  .S HospName=""
  .S HospCode=$P(^TEPI(Labno),"\",20)
  .I $L(HospCode),$D(^TTAB("RH",HospCode)) S HospName=$P(^TTAB("RH",HospCode),"\",1)
  .;bed no
  .S Bed=$P(^TEPI(Labno,0),"\",29)
  .S SpeName=""				;性别
  .S SpeCode=$P(^TEPI(Labno),"\",3)
  .I SpeCode'="",$D(^TTAB("SP",SpeCode)) S SpeName=$P(^TTAB("SP",SpeCode),"\",1)
  .S PatAge=##class(web.DHCLabCommonUse).AgeOut(##class(web.DHCLabCommonUse).GetPatAge(Labno))
  .S temstr=Labno_$c(2)_TestName_$c(2)_CliDepName_$c(2)_PatName_$c(2)_SpeName_$c(2)_PatAge
  .S temstr=temstr_$c(2)_MachName_$c(2)_RecDate_$c(2)_RecTime_$c(2)_RecUserName
  .S temstr=temstr_$c(2)_SecondLabno_$c(2)_Position_$c(2)_Debtor_$c(2)_HospName_$c(2)_Bed
  .S ^TMP($zn,$j,"record",Num)=temstr
  .S Num=Num+1
  .I Labno=10001529 b ;212
  .S Data=$lb(Debtor,PatName,SpeName,PatAge,CliDepName,Labno,TestName,CollectDateTime,ReceiveDateTime,AuthorDateTime)
  .D Output
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
  
WorkList1(Date,Time,PatType,DepCode) 
  s Labno="" F  S Labno=$O(^TDAY(10,Date,Time,PatType,"N",Labno)) Q:Labno=""  D
  .S TestSet=""  F  S TestSet=$O(^TDAY(10,Date,Time,PatType,"N",Labno,TestSet)) Q:TestSet=""  D
  ..;department
  ..I $l(DepCode),$E(TestSet)'=DepCode q
  ..S TestSetCounter=""  F  S TestSetCounter=$O(^TDAY(10,Date,Time,PatType,"N",Labno,TestSet,TestSetCounter)) Q:TestSetCounter=""  D
  ...S ^TMP($zn,$j,"ts",Labno,TestSet,TestSetCounter)=""
  q
WorkList2(Date,Time,DepCode) 
  s PatientType="" F  S PatientType=$O(^TDAY(10,Date,Time,PatientType)) Q:PatientType=""  D
  .;i ptype="GP" q
  .S Labno="" F  S Labno=$O(^TDAY(10,Date,Time,PatientType,"N",Labno)) Q:Labno=""  D
  ..S TestSet=""  F  S TestSet=$O(^TDAY(10,Date,Time,PatientType,"N",Labno,TestSet)) Q:TestSet=""  D
  ...;department
  ...I $l(DepCode),$E(TestSet)'=DepCode Q
  ...S TestSetCounter=""  F  S TestSetCounter=$O(^TDAY(10,Date,Time,PatientType,"N",Labno,TestSet,TestSetCounter)) Q:TestSetCounter=""  D
  ....S ^TMP($zn,$j,"ts",Labno,TestSet,TestSetCounter)=""
  q

Output
	set Data=$lb(Debtor,PatName,SpeName,PatAge,CliDepName,Labno,TestName,CollectDateTime,ReceiveDateTime,AuthorDateTime)
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
/// D ##class(%ResultSet).RunQuery("web.DHCLabStatSample","QuerySampleStatistics","2013-04-01","2013-05-15","","","","","","")
Query QuerySampleStatistics(DateS As %String, DateE As %String, DepCode As %String, MachCode As %String, MachTG As %String, CliCode As %String, DocCode As %String, PatType As %String, TestSetGroup As %String, USERCODE As %String) As %Query(ROWSPEC = "Debtor:%String,PatName:%String,SpeName:%String,PatAge:%String,CliDepName:%String,Labno:%String,TestName,CollectDateTime:%String,ReceiveDateTime:%String,AuthorDateTime:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCLabStatSampleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCLabStatSampleD</DataLocation>
<DefaultData>DHCLabStatSampleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCLabStatSampleD</IdLocation>
<IndexLocation>^web.DHCLabStatSampleI</IndexLocation>
<StreamLocation>^web.DHCLabStatSampleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
