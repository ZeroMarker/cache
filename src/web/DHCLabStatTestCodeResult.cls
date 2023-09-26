Class web.DHCLabStatTestCodeResult Extends %Persistent
{

/// 化验项目结果统计
Parameter BUILD = 60;

ClassMethod QueryTestCodeResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryTestCodeResultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// D ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// D ##class(%ResultSet).RunQuery("web.DHCLabStatTestCodeResult","QueryTestCodeResult","2015-03-02","2015-03-17","","","","","","1","LIS01")
ClassMethod QueryTestCodeResultExecute(ByRef qHandle As %Binary, DateS As %String, DateE As %String, DepCode As %String, MachCode As %String, MachTG As %String, TestCode As %String, CliDepCode As %String, DateType As %String, USERCODE As %String) As %Status
{
  S repid=$I(^CacheTemp)
  I $G(ind)="" S ind=1	
  S DateS=$G(DateS),DateE=$G(DateE),MachCode=$G(MachCode),MachTG=$G(MachTG),DepCode=$G(DepCode)
  S CliDepCode=$G(CliDepCode)
  S USERCODE=$G(USERCODE)
  I '$L(DateS) S DateS=+$H-1,DateS=$ZD(DateS,3)
  I '$L(DateE) S DateE=+$H,DateE=$ZD(DateE,3)
  S ^TMP("Qxf")=$lb(DateS, DateE, DepCode, MachCode, MachTG, TestCode, CliDepCode, DateType, USERCODE)
  I '$L(USERCODE) S USERCODE="demo"
  //S USERCODE=70251
  S UserDep=""
  I '$L(USERCODE)   Set qHandle=$lb(0,repid,0) Quit $$$OK
  S dep="" F  S dep=$o(^TTAB("UA",USERCODE,4,dep)) Q:dep=""  D
  .S UserDep=UserDep_dep
  I CliDepCode="null" S CliDepCode=""
  I MachCode="null" S MachCode=""
  I DepCode="null" S DepCode=""
  S DateS=$zdh(DateS,3),DateE=$zdh(DateE,3)
  s DateType=$g(DateType)
  K PLIST
  K ^smPLIST($j),^TMP($zn,$j)
  K ^SumResult($j)
  S StandMemo=""
  S SumRes=0
  S P0=0,P9=0
  S TCType=""
  I $L(TestCode) S TCType=$P(^TTAB("TC",TestCode),"\",3)
  F Date=DateS:1:DateE D
  .I DateType="0" D ByRecDateResults(Date,DepCode,TestCode,MachCode)
  .I DateType="1" D ByAuthDateResults(Date,DepCode,TestCode,MachCode)
  S num=0
  S VisitNumber="" F  S VisitNumber=$O(^TMP($zn,$j,"All",VisitNumber)) Q:VisitNumber=""  D
  .S TestsetDr="" F  S TestsetDr=$O(^TMP($zn,$j,"All",VisitNumber,TestsetDr)) Q:TestsetDr=""  D
  ..S TestSetCounter="" F  S TestSetCounter=$O(^TMP($zn,$j,"All",VisitNumber,TestsetDr,TestSetCounter)) Q:TestSetCounter=""  D
  ...S Seq=""
  ...F  S Seq=$O(^TTAB("TS",TestsetDr,0,Seq)) Q:Seq=""  D
  ....S TCCode=$P(^TTAB("TS",TestsetDr,0,Seq),"\",8)
  ....I $L(TestCode),TestCode'=TCCode Q
  ....d ResultsInfo(VisitNumber,TestsetDr,TestSetCounter,TCCode,MachCode,CliDepCode)
  I TCType="S" D
  .S ResCommNo="" F  S ResCommNo=$O(^smPLIST($j,ResCommNo)) Q:ResCommNo=""  D
  ..S StandMemo=StandMemo_" "_^smPLIST($j,ResCommNo)
  I $D(^SumResult($j)) S SumRes=^SumResult($j)
  S P0=num
  S P9=SumRes
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
ByAuthDateResults(Date,DepCode,TestCode,MachCode) 
  //New (num,Date,DepCode,TestCode,DepCode,MachineCode)
  S Date=$G(Date)
  S VisitNumber="" F  S VisitNumber=$O(^TEPIi("AUTHORISED",Date,VisitNumber)) Q:VisitNumber=""  D
  .S TestsetDr="" F  S TestsetDr=$O(^TEPIi("AUTHORISED",Date,VisitNumber,TestsetDr)) Q:TestsetDr=""  D
  ..I $L(DepCode),$E(TestsetDr)'=DepCode Q 
  ..//I $L(TestCode),'$D(^TTAB("TC",TestCode,1,TestsetDr)) Q
  ..S TestSetCounter="" F  S TestSetCounter=$O(^TEPIi("AUTHORISED",Date,VisitNumber,TestsetDr,TestSetCounter)) Q:TestSetCounter=""  D
  ...;I PatientType'[$P(^TEPI(VisitNumber),"\",48) Q   ;GP->未上线,Y->住院,N->门诊
  ...S ^TMP($zn,$j,"All",VisitNumber,TestsetDr,TestSetCounter)=""
  Q
ByRecDateResults(Date,DepCode,TestCode,MachCode) 
  //n (num,Date,TimeeFlag,startTimee,endtime,DepCode,TestCode,MachineCode)
  S Date=$G(Date)
  F Time="" F  S Time=$O(^TDAY(10,Date,Time)) Q:Time=""  D
  .S PatType="" F  S PatType=$O(^TDAY(10,Date,Time,PatType)) Q:PatType=""  D
  ..S VisitNumber="" F  S VisitNumber=$O(^TDAY(10,Date,Time,PatType,"N",VisitNumber)) Q:VisitNumber=""  D
  ...S TestsetDr="" F  S TestsetDr=$O(^TDAY(10,Date,Time,PatType,"N",VisitNumber,TestsetDr)) Q:TestsetDr=""  D
  ....I $L(DepCode),$e(TestsetDr)'=DepCode Q 
  ....//I $L(TestCode),'$D(^TTAB("TC",TestCode,1,TestsetDr)) Q
  ....S TestSetCounter="" F  S TestSetCounter=$O(^TDAY(10,Date,Time,PatType,"N",VisitNumber,TestsetDr,TestSetCounter))  Q:TestSetCounter=""  D
  .....;I PatientType'[$P(^TEPI(VisitNumber),"\",48) Q   ;GP->未上线,Y->住院,N->门诊
  .....S ^TMP($zn,$j,"All",VisitNumber,TestsetDr,TestSetCounter)=""
  .....;d ResultsInfo(VisitNumber,TestsetDr,TestSetCounter,TestCode,MachineCode)
  Q
ResultsInfo(VisitNumber,TestsetDr,TestSetCounter,TCCode,MachineCode,CliDepCode) 
  //n (num,Date,VisitNumber,TestsetDr,TestSetCounter,TCCode,MachineCode,MachineGPCode,ReqLoc)
  I $L($P(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",52)) Q ;标本异常处理 20080426
  ///
  S LocDr=$P(^TEPI(VisitNumber),"\",36)
  I $L(CliDepCode),CliDepCode'=LocDr Q
  I '$L(DepCode),UserDep'[$E(TestsetDr,1) Q
  S MachineCode=$P(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",27)
  S ReceiveDate=$P(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",21)
  S ReceiveDate=$zd(ReceiveDate,3)
  I $L(MachTG),MachTG'=MachineCode Q
  I $L(MachTG),$L(MachCode),'$D(^TMIF(MachCode,"TG",MachTG,"TS",TestsetDr)) Q
  S ResComm=""
  S TCType=$P(^TTAB("TC",TCCode),"\",3)
  S resu=$$GetResult(VisitNumber,TestsetDr,TestSetCounter,TCCode,TCType)
  S Result=$P(resu,"||",1)
  S ResComm=$P(resu,"||",2)
  I $L(ResComm),TCType="S" D
  .I $D(^smPLIST($j,ResComm)) D
  ..S $P(^smPLIST($j,ResComm),":",2)=$P(^smPLIST($j,ResComm),":",2)+1
  .E  D
  ..S ^smPLIST($j,ResComm)=Result_":"_1
  I Result="" Q
  S num=num+1
  S ranges=""
  S SpecDr=$P(^TEPI(VisitNumber),"\",3)
  S Age=$P(^TEPI(VisitNumber),"\",25)
  I TCType["N" D
  .S CurNameSpace=$ZU(5)
  .ZN "LABDATA"
  .S rangStr=$$ranges^LVBVIS1(TCCode,Age,SpecDr,"","0","","")
  .ZN CurNameSpace
  .S ranges="("_$P(rangStr,$c(1),1)_"-"_$P(rangStr,$c(1),2)_")"
  .///20120201 huhm 显示带大于或小于号的结果
  .S Res=$tr(Result,"<>")
  .///
  .//S Result=+Result
  .I $D(^SumResult($j)) D
  ..S ^SumResult($j)=^SumResult($j)+Res //Result
  .E  D
  ..S ^SumResult($j)=Res //Result
  S Gender=""
  I SpecDr'="" S Gender=$P(^TTAB("SP",SpecDr),"\",1)
  S SurName=$P(^TEPI(VisitNumber),"\",1)
  S CliDepartCode=$P(^TEPI(VisitNumber),"\",36)
  S CliDeppartName=""
  I CliDepartCode'=""  S CliDeppartName=$P(^TTAB("USLOC",CliDepartCode),"\",1)
  I CliDeppartName["-" S CliDeppartName=$P(CliDeppartName,"-",2)
  S Depname=$P(^TTAB("DEP",$e(TestsetDr,1,1)),"\",1)
  S TestSetName=$P(^TTAB("TS",TestsetDr),"\",1)
  S TestCodeName=$tr($P(^TTAB("TC",TCCode),"\",1)," ")
  //S ReceiveDate=$zd(Date,3)
  //b ;11
  S Data=$lb(ReceiveDate,VisitNumber,TestSetName,TestCodeName,Result,ranges,SurName,Gender,Age,Depname,CliDeppartName)
  D Output
  Q
GetResult(VisitNumber,TestSetDR,TestSetCounter,TestCode,TCType)
  I $L($P(^TEPI(VisitNumber,1,TestSetDR,TestSetCounter),"\",52)) Q ;标本异常处理 20080426
  S VisitNumber=$G(VisitNumber),TestSetDR=$G(TestSetDR),TestSetCounter=$G(TestSetCounter),TestCode=$G(TestCode),TCType=$G(TCType)
  S Res="",Comm=""
  I (TCType["N")!(TCType="X") D
  .I $D(^TEPI(VisitNumber,1,TestSetDR,TestSetCounter,"DATA",TestCode)) D
  ..S Res=$P(^TEPI(VisitNumber,1,TestSetDR,TestSetCounter,"DATA",TestCode),"\",1)
  I TCType="S" D
  .I $d(^TEPI(VisitNumber,1,TestSetDR,TestSetCounter,"DATA",TestCode)) D 
  ..S Comm=$P(^TEPI(VisitNumber,1,TestSetDR,TestSetCounter,"DATA",TestCode),"\",1)
  ..S Res=Comm
  ..I $d(^TTAB("TC",TestCode,2,Comm,0)) D 
  ...S Res=^TTAB("TC",TestCode,2,Comm,^TTAB("TC",TestCode,2,Comm,0))
  Q Res_"||"_Comm 
Output
	//set Data=$lb(ReceiveDate,VisitNumber,TestSetName,TestCodeName,Result,ranges,SurName,Gender,Age,Depname,CliDeppartName,ResComm)
 	S Data=$lb(ReceiveDate,VisitNumber,TestSetName,TestCodeName,Result,ranges,SurName,Gender,Age,Depname,CliDeppartName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QueryTestCodeResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryTestCodeResultExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
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
/// Description:： 医嘱化验项目结果明细
/// Table：        
/// Input：        DateS:起始日期(格式如"2013-04-01"), DateE:结束日期(格式如"2013-04-01"), DepCode：检验科室代码(必填), MachCode：仪器代码, MachTG仪器组代码, TestCode：化验项目代码(必填), CliDepCode：申请科室代码, DateType：日期类型(0:按接收日期，1：按审核日期) 
/// Output：       ReceiveDate:核收日期,VisitNumber:检验号,TestSetName:医嘱名称,TestCodeName:项目名称,Result:项目结果,ranges:参考范围,SurName:患者姓名,Gender:性别,Age:年龄,DepName:检验科室名称,CliDeppartName:申请科室名称
/// Return：       无
/// Others：
/// D ##class(%ResultSet).RunQuery("web.DHCLabStatTestCodeResult","QueryTestCodeResult","2013-04-01","2013-05-15","A","","","A0010","","0")
Query QueryTestCodeResult(DateS As %String, DateE As %String, DepCode As %String, MachCode As %String, MachTG As %String, TestCode As %String, CliDepCode As %String, DateType As %String, USERCODE As %String) As %Query(ROWSPEC = "ReceiveDate:%String,VisitNumber:%String,TestSetName:%String,TestCodeName:%String,Result:%String,ranges:%String,SurName:%String,Gender:%String,Age:%String,Depname:%String,CliDeppartName:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCLabStatTestCodeResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCLabStatTestCodeResultD</DataLocation>
<DefaultData>DHCLabStatTestCodeResultDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCLabStatTestCodeResultD</IdLocation>
<IndexLocation>^web.DHCLabStatTestCodeResultI</IndexLocation>
<StreamLocation>^web.DHCLabStatTestCodeResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
