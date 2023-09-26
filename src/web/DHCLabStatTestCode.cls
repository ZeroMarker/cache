Class web.DHCLabStatTestCode Extends %Persistent
{

/// 医嘱数量统计
Parameter BUILD = 60;

ClassMethod QueryTestStatisticsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryTestStatisticsExecute ]
{
	S repid=$LIST(qHandle,2)
 	K ^CacheTemp(repid)
	Q $$$OK
}

/// Query的执行方法
/// D ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// D ##class(%ResultSet).RunQuery("web.DHCLabStatTestCode","QueryTestStatistics","2013-04-01","2013-05-15","demo","","","",0,"")
ClassMethod QueryTestStatisticsExecute(ByRef qHandle As %Binary, DateS As %String, DateE As %String, User As %String, DepCode As %String, MachCode As %String, MachTG As %String, DateType As %String, PatientType As %String, USERCODE As %String) As %Status
{
  S repid=$I(^CacheTemp)
  I $G(ind)="" S ind=1
  S NameSpace="LABDATA"
  I '$L(NameSpace) S NameSpace="LABDATA"	
  S DateS=$G(DateS),DateE=$G(DateE),User=$G(User)
  I '$L(DateS) S DateS=$ZD(DateS,3)
  I '$L(DateE) S DateE=$ZD(DateE,3)
  S DateS=$zdh(DateS,3),DateE=$zdh(DateE,3),DepCode=$G(DepCode)
  S DateType=$G(DateType),PatientType=$G(PatientType)
  S USERCODE=$G(USERCODE)
  I '$L(USERCODE) S USERCODE="demo"
  //S USERCODE=70251
  S UserDep=""
  I '$L(USERCODE)   Set qHandle=$lb(0,repid,0) Quit $$$OK
  S dep="" F  S dep=$o(^TTAB("UA",USERCODE,4,dep)) Q:dep=""  D
  .S UserDep=UserDep_dep
  S ^TMP("Sam2")=DateS_"^"_DateE_"^"_User_"^"_DepCode_"^"_MachCode_"^"_MachTG_"^"_DateType_"^"_PatientType
  I '$L(PatientType) S PatientType="N,Y,P,O,GP"
  S MachTG=$G(MachTG)
  S MachCode=$G(MachCode)
  I DepCode="null" S DepCode=""
  I MachCode="null" S MachCode="" 
  S (StartDate,StartTime,EndDate,EndTime)=""
  K PLIST,^TMP($zn,$j)
  ;根据用户访问的科室统计 20080427
  S Dep="" F  S Dep=$O(^TTAB("UA",User,4,Dep)) Q:Dep=""  D
  .S ^TMP($zn,$j,"UA",Dep)=""
  ;
  S P0=0,Num=0
  F Date=DateS:1:DateE D
  .I DateType="0" D ByRecDateTC(Date)
  .E  D ByAuthDateTC(Date)
  b ;1
  S TestCode="" F  S TestCode=$O(^TMP($zn,$j,"TCList",TestCode))  Q:TestCode=""  D
  .S Num=Num+1
  .S TestName=$P(^TTAB("TC",TestCode),"\",1)
  .S Type=$P(^TTAB("TC",TestCode),"\",3)
  .I Type["N" S Type="数值型"
  .I Type["V" S Type="微生物"
  .I Type["B" S Type="血型组"
  .I Type["S" S Type="标准备注"
  .I Type["X" S Type="自由文本"
  .S Number=^TMP($zn,$j,"TCList",TestCode)
  .S Data=$lb(TestCode,TestName,Type,Number)
  .D Output
  S P0=Num
  S qHandle=$lb(0,repid,0)
  Q $$$OK
ByAuthDateTC(Date)
  S Date=$G(Date)
  S VisitNumber="" F  S VisitNumber=$O(^TEPIi("AUTHORISED",Date,VisitNumber)) Q:VisitNumber=""  D
  .S TestsetDr="" F  S TestsetDr=$O(^TEPIi("AUTHORISED",Date,VisitNumber,TestsetDr)) Q:TestsetDr=""  D
  ..S TestSetCounter="" F  S TestSetCounter=$O(^TEPIi("AUTHORISED",Date,VisitNumber,TestsetDr,TestSetCounter)) Q:TestSetCounter=""  D
  ...I $l(DepCode),TestsetDr'[DepCode Q
  ...I PatientType'[$P(^TEPI(VisitNumber),"\",48) Q ;GP->未上线,Y->住院,N->门诊
  ...I PatientType="GP",$P(^TEPI(VisitNumber),"\",48)="P" Q
  ...D TestCodeSum(VisitNumber,TestsetDr,TestSetCounter)
  Q
ByRecDateTC(Date)
  S Date=$G(Date)
  F Time="" F  S Time=$O(^TDAY(10,Date,Time)) Q:Time=""  D
  .S PatType="" F  S PatType=$O(^TDAY(10,Date,Time,PatType)) Q:PatType=""  D
  ..S VisitNumber="" F  S VisitNumber=$O(^TDAY(10,Date,Time,PatType,"N",VisitNumber)) Q:VisitNumber=""  D
  ...S TestsetDr="" F  S TestsetDr=$O(^TDAY(10,Date,Time,PatType,"N",VisitNumber,TestsetDr)) Q:TestsetDr=""  D
  ....S TestSetCounter="" F  S TestSetCounter=$O(^TDAY(10,Date,Time,PatType,"N",VisitNumber,TestsetDr,TestSetCounter))  Q:TestSetCounter=""  D
  .....I $l(DepCode),TestsetDr'[DepCode Q
  .....I PatientType'[$P(^TEPI(VisitNumber),"\",48) Q ;GP->未上线,Y->住院,N->门诊
  .....I PatientType="GP",$P(^TEPI(VisitNumber),"\",48)="P" Q
  .....D TestCodeSum(VisitNumber,TestsetDr,TestSetCounter)
  .....//b ;1
  Q
TestCodeSum(VisitNumber,TestsetDr,TestSetCounter)   
  ;根据用户访问的科室统计 20080427
  I '$D(^TMP($zn,$j,"UA",$E(TestsetDr))) Q
  ;
  I $l($P(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",52)) Q ;标本异常处理 20080426 
  S Seq="" F  S Seq=$O(^TTAB("TS",TestsetDr,0,Seq))  Q:Seq=""  D 
  .S TestCode=$P(^TTAB("TS",TestsetDr,0,Seq),"\",8)
  .I '$l(TestCode) Q ;20080425
  .I $E(TestCode,2,5)="9999" Q ;20080427 去掉备注
  .S TestName=$P(^TTAB("TC",TestCode),"\",1)
  .S Type=$P(^TTAB("TC",TestCode),"\",3)
  .S MachineC=$P(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",27)
  .I $l(MachCode),MachCode'=MachineC Q
  .I '$L(DepCode),UserDep'[$E(TestsetDr,1) Q
  .I $l(MachTG),$l(MachCode),'$D(^TMIF(MachCode,"TG",MachTG,"TS",TestsetDr)) Q
  .S ResComm=""
  .S ResultStr=$$GetResult(VisitNumber,TestsetDr,TestSetCounter,TestCode,Type)
  .S Result=$P(ResultStr,"||",1)
  .S ResComm=$P(ResultStr,"||",2)
  .I Result="" Q ;结果为空时不统计
  .I $D(^TMP($zn,$j,"TCList",TestCode)) D
  ..S ^TMP($zn,$j,"TCList",TestCode)=^TMP($zn,$j,"TCList",TestCode)+1
  .E  D
  ..S ^TMP($zn,$j,"TCList",TestCode)=1

GetResult(VisitNumber,TestSetDR,TestSetCounter,TestCode,Type)
  I $l($P(^TEPI(VisitNumber,1,TestSetDR,TestSetCounter),"\",52)) Q ;标本异常处理 20080426
  S VisitNumber=$G(VisitNumber),TestSetDR=$G(TestSetDR),TestSetCounter=$G(TestSetCounter),TestCode=$G(TestCode),type=$G(type)
  S Res="",Comm=""
  I (Type["N")!(Type="X") D
  .I $D(^TEPI(VisitNumber,1,TestSetDR,TestSetCounter,"DATA",TestCode)) D
  ..S Res=$P(^TEPI(VisitNumber,1,TestSetDR,TestSetCounter,"DATA",TestCode),"\",1)
  I type="S" D
  .I $D(^TEPI(VisitNumber,1,TestSetDR,TestSetCounter,"DATA",TestCode)) D 
  ..S Comm=$P(^TEPI(VisitNumber,1,TestSetDR,TestSetCounter,"DATA",TestCode),"\",1)
  ..S Res=Comm
  ..I $D(^TTAB("TC",TestCode,2,Comm,0)) D 
  ...S Res=^TTAB("TC",TestCode,2,Comm,^[NameSpace]TTAB("TC",TestCode,2,Comm,0))
  Q Res_"||"_Comm  

Output
	Set Data=$Lb(TestCode,TestName,Type,Number)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QueryTestStatisticsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryTestStatisticsExecute ]
{
 	S AtEnd=$LIST(qHandle,1)
 	S repid=$LIST(qHandle,2)
 	S ind=$LIST(qHandle,3)
 	S ind=$O(^CacheTemp(repid,ind))
 	If ind="" 
 	{				// if there are no more rows, finish fetching
 		S AtEnd=1
 		S Row=""
 	}
 	Else      
 	{	// fetch row
 		S Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      Qiuxianfu
/// CreatDate：    20140331
/// Description:： 化验项目统计
/// Table：        无
/// Input：        DateS:起始时间(格式："2013-04-01")，DateE：结束时间(格式："2013-04-01"),User:检验科用户(必填只检索该用户所分配科室权限的数据),DepCode:检验科科室代码(为空将检索所有科室),MachCode:仪器代码为空取全部仪器,MachTG:仪器组代码为空取全部仪器分组，DateType：接收审核类型(0:按接收日期查询，1:按审核日期查询)，PatientType：病人类型为空默认检索全部类型(N:门诊,Y：住院,P：急诊,O：体检,GP：手工未上线病人")
/// Output：       TestCode:项目代码，TestName：项目名称，Type：项目类型，Number：项目数量
/// Return：       无
/// Others：       无
/// D ##class(%ResultSet).RunQuery("web.DHCLabStatTestCode","QueryTestStatistics","2013-04-01","2013-05-15","demo","","","",0,"")
Query QueryTestStatistics(DateS As %String, DateE As %String, User As %String, DepCode As %String, MachCode As %String, MachTG As %String, DateType As %String, PatientType As %String, USERCODE As %String) As %Query(ROWSPEC = "TestCode:%String,TestName:%String,Type:%String,Number:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCLabStatTestCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCLabStatTestCodeD</DataLocation>
<DefaultData>DHCLabStatTestCodeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCLabStatTestCodeD</IdLocation>
<IndexLocation>^web.DHCLabStatTestCodeI</IndexLocation>
<StreamLocation>^web.DHCLabStatTestCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
