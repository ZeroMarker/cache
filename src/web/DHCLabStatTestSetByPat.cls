Class web.DHCLabStatTestSetByPat Extends %Persistent
{

/// 病人医嘱医嘱统计汇总
Parameter BUILD = 60;

ClassMethod QueryTSStatisticsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryTSStatisticsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// D ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// D ##class(%ResultSet).RunQuery("web.DHCLabStatTestSetByPat","QueryTSStatistics","2013-04-01","2013-05-15","demo","LABDATA","","",0,"","")
ClassMethod QueryTSStatisticsExecute(ByRef qHandle As %Binary, DateS As %String, DateE As %String, User As %String, NameSpace As %String, MachCode As %String, MachTG As %String, DateType As %String, PatientType As %String, CliDepCode As %String) As %Status
{
  S repid=$I(^CacheTemp)
  I $G(ind)="" S ind=1
  S NameSpace="LABDATA"	
  I '$L(NameSpace) S NameSpace="LABDATA"
  I '$L(DateS) S DateS=$ZD(DateS,3)
  I '$L(DateE) S DateE=$ZD(DateE,3)
  S DateS=$ZDH(DateS,3),DateE=$ZDH(DateE,3)
  S PatientType=$g(PatientType)
  I '$L(PatientType) S PatientType="N,Y,P,O,GP"
  S MachTG=$G(MachTG)
  S MachCode=$G(MachCode)
  I CliDepCode="null" S CliDepCode=""
  I MachCode="null" S MachCode=""
  //S User="demo"
  S User=$G(User)
  S ^TMP("Sam1")=DateS_"^"_DateE_"^"_User_"^"_NameSpace_"^"_MachCode_"^"_MachTG_"^"_DateType_"^"_PatientType_"^"_CliDepCode 
  S Count=0
  S UserType=$G(UserType)
  S (StartDate,StartTime,EndDate,EndTime)=""
  I Count=0 K ^DHCStatis($j)
  K plDetor,plPatName,plSum,PLIST,plFee,^TMP($zn,$j)
  S Num=0,Cnt=0,P0=0  
  S Sum=0,Count=$G(Count)  ;sum记录病人数?count记录所有医嘱数
  ;根据用户访问的科室统计 20080427a
  S Dep="" F  S Dep=$o(^TTAB("UA",User,4,Dep)) Q:Dep=""  D
  .S ^TMP($zn,$j,"UA",Dep)=""
  F Date=DateS:1:DateE D 
  .I DateType="0" D ByRecDateDebtor(Date)
  .E  d ByAuthDateDebtor(Date)
  M ^DHCStatis($j)=^TMP($zn,$j)
  S Num=0
  S Index="" F  S Index=$O(plDetor(Index)) Q:Index=""  D
  .S Num=Num+1
  .S PatDebno=plDetor(Index)
  .S PatName=plPatName(Index)
  .S TestSetNumber=plSum(Index)
  .S TestSetSumPrice=plFee(Index)
  .S Data=$lb(PatDebno,PatName,TestSetNumber,TestSetSumPrice)
  .D Output
  S P0=Sum,P1=Count  
  S PLIST=Num
  K plDetor,plSum ,plPatName,plFee,^TMP($zn,$j)
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
  
  	
ByAuthDateDebtor(Date)
  S Date=$G(Date)
  S VisitNumber="" F  S VisitNumber=$O(^TEPIi("AUTHORISED",Date,VisitNumber)) Q:VisitNumber=""  D
  .S TestsetDr="" F  S TestsetDr=$O(^TEPIi("AUTHORISED",Date,VisitNumber,TestsetDr)) Q:TestsetDr=""  D
  ..;根据用户访问的科室统计 20080427
  ..I '$D(^TMP($zn,$j,"UA",$e(TestsetDr))) Q
  ..;
  ..S TestSetCounter="" F  S TestSetCounter=$O(^TEPIi("AUTHORISED",Date,VisitNumber,TestsetDr,TestSetCounter)) Q:TestSetCounter=""  d
  ...I PatientType'[$P(^TEPI(VisitNumber),"\",48) Q ;GP->未上线,Y->住院,N->门诊
  ...I PatientType="GP",$P(^TEPI(VisitNumber),"\",48)="P" Q
  ...D DebtorStatSum(VisitNumber,TestsetDr,TestSetCounter)
  Q 
ByRecDateDebtor(Date)
  S Date=$G(Date)
  S Time="" F  S Time=$O(^TDAY(10,Date,Time)) Q:Time=""  D
  .S PatType="" F  S PatType=$O(^TDAY(10,Date,Time,PatType)) Q:PatType=""  D
  ..S VisitNumber="" F  S VisitNumber=$O(^TDAY(10,Date,Time,PatType,"N",VisitNumber)) Q:VisitNumber=""  D
  ...S TestsetDr="" F  S TestsetDr=$O(^TDAY(10,Date,Time,PatType,"N",VisitNumber,TestsetDr)) Q:TestsetDr=""  D
  ....;根据用户访问的科室统计 20080427
  ....I '$D(^TMP($zn,$j,"UA",$E(TestsetDr))) Q
  ....;
  ....S TestSetCounter="" F  S TestSetCounter=$O(^TDAY(10,Date,Time,PatType,"N",VisitNumber,TestsetDr,TestSetCounter))  Q:TestSetCounter=""  D
  .....I PatientType'[$P(^TEPI(VisitNumber),"\",48) Q ;GP->未上线,Y->住院,N->门诊
  .....I PatientType="GP",$P(^TEPI(VisitNumber),"\",48)="P" Q
  .....D DebtorStatSum(VisitNumber,TestsetDr,TestSetCounter)
  Q
  
DebtorStatSum(VisitNumber,TestsetDr,TestSetCounter)
  I $L($P(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",52)) Q ;标本异常处理 20080426 
  S MachineCode=$P(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",27)
  I $L(MachCode),MachCode'=MachineCode Q
  I $L(MachTG),$L(MachCode),'$D(^TMIF(MachCode,"TG",MachTG,"TS",TestsetDr)) Q
  S CliDepartCode=$P(^TEPI(VisitNumber),"\",36)
  //I $L(CliDepCode),CliDepCode'=CliDepartCode Q
  I $l(CliDepCode),CliDepCode'=$E(TestsetDr,1) Q 
  S tflag=0,tsFee=0,tsSum=0
  S Index="" F  S Index=$O(plDetor(Index)) Q:Index=""!(tflag=1)  D
  .I $P(^TEPI(VisitNumber),"\",18)=plDetor(Index) D
  ..S tflag=1
  ..S Num=Index
  I tflag=0 D  ;第一次找到
  .S Sum=Sum+1,Num=Sum ;记录人数
  .S plSum(Sum)=0,plFee(Sum)=0
  .S PatName=""
  .I $P(^TEPI(VisitNumber),"\",2)'="" S PatName=$P(^TEPI(VisitNumber),"\",2)
  .I $P(^TEPI(VisitNumber),"\",1)'="" S PatName=$P(^TEPI(VisitNumber),"\",1)
  .S plDetor(Sum)=$P(^TEPI(VisitNumber),"\",18)
  .S plPatName(Sum)=PatName  ;记录姓名
  S Price=0
  I $P(^TEPI(VisitNumber),"\",48)'="GP" D
  .S CollectDate=$P(^TEPI(VisitNumber),"\",10)
  .S TestSetRowID=VisitNumber_"||"_TestsetDr_"||"_TestSetCounter
  .S Price=##class(web.DHCLabCommonUse).CalTestSetFee(VisitNumber,TestSetRowID,NameSpace,CollectDate)
  S Debtor=$P(^TEPI(VisitNumber),"\",18)
  S Count=Count+1
  S ^TMP($zn,$j,Debtor,Count)=TestsetDr_"^"_Price
  S plFee(Num)=plFee(Num)+Price
  S plSum(Num)=plSum(Num)+1 ;记录医嘱数
  Q	

Output
	S Data=$lb(PatDebno,PatName,TestSetNumber,TestSetSumPrice)
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
/// Input：        DateS(格式如："2013-04-01"),DateE(格式如："2013-05-15"),TimeS(格式如："00:00:00"),TimeE(格式如："11:25:20"),User:检验科用户(必填，只检索用户所分配权限的科室数据),NameSpace:命名空间(格式："LABDATA"),,MachCode:仪器代码为空取全部仪器 ,MachineTG:仪器组代码,为空全部仪器分组，DateType：接收审核类型(0:按接收日期查询，1:按审核日期查询)，PatientType：病人类型为空默认检索全部类型(N:门诊,Y：住院,P：急诊,O：体检,GP：手工未上线病人")，CliDepCode：医生所在科室(为空默认取全部科室)
/// Output：       病人登记号，病人姓名，医嘱数量，医嘱总价
/// Return：       无
/// Others：
/// D ##class(%ResultSet).RunQuery("web.DHCLabStatTestSetByPat","QueryTSStatistics","2013-04-01","2013-05-15","demo","LABDATA","","",0,"","")
Query QueryTSStatistics(DateS As %String, DateE As %String, User As %String, NameSpace As %String, MachCode As %String, MachineTG As %String, DateType As %String, PatientType As %String, CliDepCode As %String) As %Query(ROWSPEC = "PatDebno:%String,PatName:%String,TSNumber:%String,TSSumPrice:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCLabStatTestSetByPatDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCLabStatTestSetByPatD</DataLocation>
<DefaultData>DHCLabStatTestSetByPatDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCLabStatTestSetByPatD</IdLocation>
<IndexLocation>^web.DHCLabStatTestSetByPatI</IndexLocation>
<StreamLocation>^web.DHCLabStatTestSetByPatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
