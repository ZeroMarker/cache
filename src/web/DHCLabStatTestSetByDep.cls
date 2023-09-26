Class web.DHCLabStatTestSetByDep Extends %Persistent
{

/// 检验科室医嘱统计汇总
Parameter BUILD = 60;

ClassMethod QueryTSStatisticsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryTSStatisticsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// D ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// D ##class(%ResultSet).RunQuery("web.DHCLabStatTestSetByDep","QueryTSStatistics","2013-04-01","2013-05-15","demo","LABDATA","","",0,"","")
ClassMethod QueryTSStatisticsExecute(ByRef qHandle As %Binary, DateS As %String, DateE As %String, User As %String, NameSpace As %String, MachCode As %String, MachTG As %String, DateType As %String, PatientType As %String, DepCode As %String, USERCODE As %String) As %Status
{
  S repid=$I(^CacheTemp)
  I $G(ind)="" S ind=1
  S Config=##Class(websys.Configuration).%OpenId(1)
  S NameSpace=Config.LabDataNamespace
  I '$L(NameSpace) S NameSpace="LABDATA"
  I '$L(DateS) S DateS=$ZD(DateS,3)
  I '$L(DateE) S DateE=$ZD(DateE,3)
  S DateS=$ZDH(DateS,3),DateE=$ZDH(DateE,3)
  I DepCode="null" S DepCode=""
  I MachCode="null" S MachCode=""
  S ^TMP("Sam1")=$lb(DateS, DateE, User, NameSpace, MachCode, MachTG, DateType, PatientType, DepCode, USERCODE)
  S USERCODE=$G(USERCODE)
  I '$L(USERCODE) S USERCODE="demo"
  //S USERCODE=70251
  S UserDep=""
  I '$L(USERCODE) S USERCODE="demo"
  I '$L(USERCODE)   Set qHandle=$lb(0,repid,0) Quit $$$OK
  S dep="" F  S dep=$o(^TTAB("UA",USERCODE,4,dep)) Q:dep=""  D
  .S UserDep=UserDep_dep
  S PatientType=$g(PatientType)
  I '$L(PatientType) S PatientType="N,Y,P,O,GP"
  S MachTG=$G(MachTG)
  S MachCode=$G(MachCode)
  I DepCode="null" S DepCode=""
  I MachCode="null" S MachCode=""
  I '$L(User) S User="demo"
  S User=$G(User)
  S Count=0
  S UserType=$G(UserType)
  S (StartDate,StartTime,EndDate,EndTime)=""
  S P0=0,Num=0
  K PLIST,plDep,plDepFee,^TMP($zn,$j)
  I Count=0 K ^DHCStatis($j)
  ;根据用户访问的科室统计 20080427
  S Dep="" F  S Dep=$O(^TTAB("UA",User,4,Dep)) Q:Dep=""  D
  .I $L(DepCode),DepCode'=Dep Q
  .S Num=Num+1
  .S ^TMP($zn,$j,"UA",Dep)=Num
  .S plDep(Num)=Dep
  .S plDepName(Num)=$P(^TTAB("DEP",Dep),"\",1)
  .S plDepFee(Num)=0
  .S plDepSum(Num)=0
  S Sum=0,Count=$G(Count)
  F Date=DateS:1:DateE D 
  .I DateType="0" D ByRecDateDep(Date)
  .E  D ByAuthDateDep(Date)
  M ^DHCStatis($j)=^TMP($zn,$j) K ^TMP($zn,$j)
  I Sum>0 D
  .F Sum=1:1:Num D 
  ..S DepartCode=plDep(Sum)
  ..S DepName=plDepName(Sum)
  ..S TSNumber=plDepSum(Sum)
  ..S TSSumPrice=plDepFee(Sum)
  ..S Data=$lb(DepartCode,DepName,TSNumber,TSSumPrice)
  ..Do Output
  S P0=Sum,P1=Count 
  K plDep,plDepName,plDepSum,plDepFee
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
  
  	
ByAuthDateDep(Date)
  S Date=$G(Date)
  S VisitNumber="" F  S VisitNumber=$O(^TEPIi("AUTHORISED",Date,VisitNumber)) Q:VisitNumber=""  D
  .S TestsetDr="" F  S TestsetDr=$O(^TEPIi("AUTHORISED",Date,VisitNumber,TestsetDr)) Q:TestsetDr=""  D
  ..S TestSetCounter="" F  S TestSetCounter=$O(^TEPIi("AUTHORISED",Date,VisitNumber,TestsetDr,TestSetCounter)) Q:TestSetCounter=""  D
  ...I PatientType'[$P(^TEPI(VisitNumber),"\",48) Q ;GP->未上线,Y->住院,N->门诊
  ...I PatientType="GP",$P(^TEPI(VisitNumber),"\",48)="P" Q
  ...D DepStatSum(VisitNumber,TestsetDr,TestSetCounter)
  Q
  
ByRecDateDep(Date)
  S Date=$G(Date)
  S Time="" F  S Time=$O(^TDAY(10,Date,Time)) Q:Time=""  D
  .S PatType="" F  S PatType=$O(^TDAY(10,Date,Time,PatType)) Q:PatType=""  D
  ..S VisitNumber="" F  S VisitNumber=$O(^TDAY(10,Date,Time,PatType,"N",VisitNumber)) Q:VisitNumber=""  D
  ...S TestsetDr="" F  S TestsetDr=$O(^TDAY(10,Date,Time,PatType,"N",VisitNumber,TestsetDr)) Q:TestsetDr=""  D
  ....S TestSetCounter="" F  S TestSetCounter=$O(^TDAY(10,Date,Time,PatType,"N",VisitNumber,TestsetDr,TestSetCounter))  Q:TestSetCounter=""  D
  .....I '$D(^TEPI(VisitNumber)) Q
  .....I PatientType'[$P(^TEPI(VisitNumber),"\",48) Q ;GP->未上线,Y->住院,N->门诊
  .....I PatientType="GP",$P(^TEPI(VisitNumber),"\",48)="P" Q
  .....D DepStatSum(VisitNumber,TestsetDr,TestSetCounter)
  Q
  
DepStatSum(VisitNumber,TestsetDr,TestSetCounter)
  I '$D(^TEPI(VisitNumber,1,TestsetDr)) Q
  I $L($P(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",52)) Q ;标本异常处理 20080426
  S MachineC=$P(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",27)
  I $L(MachCode),MachCode'=MachineC Q
  I $L(MachTG),$L(MachTG),'$D(^TMIF(MachCode,"TG",MachTG,"TS",TestsetDr)) Q
  S CliDepartCode=$P(^TEPI(VisitNumber),"\",36)
  //I $L(CliDepCode),CliDepCode'=CliDepartCode Q
  I $L(DepCode),DepCode'=$E(TestsetDr,1) Q
  //S ^DHCTMP("DepCode",DepCode)=TestsetDr
  I UserDep'[$E(TestsetDr,1) Q
  ;根据访问科室访问 20080427
  S DepNo=""
  I '$D(^TMP($zn,$j,"UA",$e(TestsetDr))) Q  
  S DepNo=$G(^TMP($zn,$j,"UA",$e(TestsetDr)))
  I '$L(DepNo) Q
  S Price=0
  I $P(^TEPI(VisitNumber),"\",48)'="GP" D
  .S CollectDate=$P(^TEPI(VisitNumber),"\",10)
  .S TestSetRowID=VisitNumber_"||"_TestsetDr_"||"_TestSetCounter
  .S Price=##class(web.DHCLabCommonUse).CalTestSetFee(VisitNumber,TestSetRowID,NameSpace,CollectDate)
  S Sum=Sum+1,Count=Count+1
  S plDepSum(DepNo)=plDepSum(DepNo)+1
  S plDepFee(DepNo)=plDepFee(DepNo)+Price
  S ^AA102(TestsetDr,TestSetCounter,VisitNumber)=Price
  S ^TMP($zn,$j,plDep(DepNo),Count)=TestsetDr_"^"_Price
  Q  

Output
	S Data=$lb(DepartCode,DepName,TSNumber,TSSumPrice)
 	S ^CacheTemp(repid,ind)=Data
 	S ind=ind+1
	Q
}

ClassMethod QueryTSStatisticsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryTSStatisticsExecute ]
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
 	S qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      Qiuxianfu
/// CreatDate：    20140331
/// Description:： 按检验科室查询医嘱统计
/// Table：        
/// Input：        DateS(格式如："2013-04-01"),DateE(格式如："2013-05-15"),User:检验科用户(必填，只检索用户所分配权限的科室数据),NameSpace:命名空间(格式："LABDATA"),,MachCode:仪器代码为空取全部仪器 ,MachTG:仪器组代码,为空全部仪器分组，DateType：接收审核类型(0:按接收日期查询，1:按审核日期查询)，PatientType：病人类型为空默认检索全部类型(N:门诊,Y：住院,P：急诊,O：体检,GP：手工未上线病人")，CliDepCode：医生所在科室(为空默认取全部科室)
/// Output：       检验科科室代码，科室名称，医嘱数量，医嘱总价
/// Return：       无
/// Others：
/// D ##class(%ResultSet).RunQuery("web.DHCLabStatTestSetByDep","QueryTSStatistics","2013-04-01","2013-05-15","demo","LABDATA","","",0,"","")
Query QueryTSStatistics(DateS As %String, DateE As %String, User As %String, NameSpace As %String, MachCode As %String, MachTG As %String, DateType As %String, PatientType As %String, DepCode As %String, USERCODE As %String) As %Query(ROWSPEC = "DepartCode:%String,DepName:%String,TSNumber:%String,TSSumPrice:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCLabStatTestSetByDepDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCLabStatTestSetByDepD</DataLocation>
<DefaultData>DHCLabStatTestSetByDepDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCLabStatTestSetByDepD</IdLocation>
<IndexLocation>^web.DHCLabStatTestSetByDepI</IndexLocation>
<StreamLocation>^web.DHCLabStatTestSetByDepS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
