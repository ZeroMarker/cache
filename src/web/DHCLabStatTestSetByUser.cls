Class web.DHCLabStatTestSetByUser Extends %Persistent
{

/// 检验科用户医嘱统计汇总
Parameter BUILD = 60;

ClassMethod QueryTSStatisticsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryTSStatisticsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// D ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// D ##class(%ResultSet).RunQuery("web.DHCLabStatTestSetByUser","QueryTSStatistics","2013-04-01","2013-05-15","demo","LABDATA","","",0,"","")
ClassMethod QueryTSStatisticsExecute(ByRef qHandle As %Binary, DateS As %String, DateE As %String, User As %String, NameSpace As %String, MachCode As %String, MachTG As %String, DateType As %String, PatientType As %String, CliDepCode As %String, USERCODE As %String) As %Status
{
  S repid=$I(^CacheTemp)
  I $G(ind)="" S ind=1
  S NameSpace="LABDATA"	
  I '$L(NameSpace) S NameSpace="LABDATA"
  I '$L(DateS) S DateS=$ZD(+$H,3)
  I '$L(DateE) S DateE=$ZD(+$H,3)
  S ^TMP("Samp2")=$lb(DateS, DateE, User, NameSpace, MachCode, MachTG, DateType, PatientType, CliDepCode, USERCODE)
  S DateS=$ZDH(DateS,3),DateE=$ZDH(DateE,3)
  S USERCODE=$G(USERCODE)
  I '$L(USERCODE) S USERCODE="demo"
  //S USERCODE=70251
  S UserDep=""
  I '$L(USERCODE)   Set qHandle=$lb(0,repid,0) Quit $$$OK
  S dep="" F  S dep=$o(^TTAB("UA",USERCODE,4,dep)) Q:dep=""  D
  .S UserDep=UserDep_dep
  S PatientType=$g(PatientType)
  I '$L(PatientType) S PatientType="NYPOGP"
  S MachTG=$G(MachTG)
  S MachCode=$G(MachCode)
  I CliDepCode="null" S CliDepCode=""
  I MachCode="null" S MachCode=""
  I User="null" S User=""
  //S User="demo"
  S User=$G(User)
  //I '$L(User) S qHandle=$lb(0,repid,0) Q $$$OK 
  S count=0
  S UserType=$G(UserType)
  S (startDate,startTime,endDate,endTime)=""
  I count=0 k ^DHCStatis($j)
  K PLIST,^TMP($zn,$j),plUser,plTestSetFee,plSum
  S num=0,sum=0,TestSetSum=0,tsSum=$G(count)
  ;根据用户访问的科室统计 20080427
  S UserID=""
  I User="" S User="demo",UserID=1
  S Dep="" F  S Dep=$O(^TTAB("UA",User,4,Dep)) Q:Dep=""  D
  .S ^TMP($zn,$j,"UA",Dep)=""
  //I User="demo" S User=""
  S UserNo="" F  S UserNo=$O(^[NameSpace]SSU("SSUSR",1,UserNo)) Q:UserNo=""  D
  .I $L(User),User'=UserNo,UserID'=1 Q
  .S flag=0
  .S Dep="" F  S Dep=$O(^TMP($zn,$j,"UA",Dep)) Q:Dep=""!(flag=1)  D
  ..I $D(^TTAB("UA",UserNo,4,Dep)) s flag=1
  .I flag=0 Q
  .S num=num+1
  .S plUser(num)=UserNo_"^"_$P(^[NameSpace]SSU("SSUSR",1,UserNo),"^",2)
  .S plTestSetFee(num)=0,plSum(num)=0
  ;
  S TestSetSum=num
  F Date=DateS:1:DateE D 
  .I DateType="0" D ByRecDateUser(Date)
  .E  d ByAuthDateUser(Date)
  M ^DHCStatis($j)=^TMP($zn,$j) K ^TMP($zn,$j)
  S num=0
  F i=1:1:TestSetSum D
  .I plSum(i)>0 D
  ..S UserCode=$P(plUser(i),"^",1)
  ..S UserName=$P(plUser(i),"^",2)
  ..S TSNumber=plSum(i)
  ..S TSSumPrice=plTestSetFee(i)
  ..S num=num+1
  ..S Data=$lb(UserCode,UserName,TSNumber,TSSumPrice)
  ..D Output
  K plUser,plTestSetFee,plSum
  S PLIST=num
  S P0=num
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
  
  	
ByAuthDateUser(Date)
  S Date=$G(Date)
  S VisitNumber="" F  S VisitNumber=$O(^TEPIi("AUTHORISED",Date,VisitNumber)) Q:VisitNumber=""  D
  .S TestsetDr="" F  S TestsetDr=$O(^TEPIi("AUTHORISED",Date,VisitNumber,TestsetDr)) Q:TestsetDr=""  D
  ..S TestSetCounter="" F  S TestSetCounter=$O(^TEPIi("AUTHORISED",Date,VisitNumber,TestsetDr,TestSetCounter)) Q:TestSetCounter=""  D
  ...I PatientType'[$P(^TEPI(VisitNumber),"\",48) Q ;GP->未上线,Y->住院,N->门诊
  ...I PatientType="GP",$P(^TEPI(VisitNumber),"\",48)="P" Q
  ...S AuthosizeTime=$P(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",5) * 60
  ...//I (timeFlag="Y"),(Date=startDate),(AuthosizeTime<startTime) Q
  ...//I (timeFlag="Y"),(Date=endDate),(AuthosizeTime>endTimee) Q
  ...D UserStatSum(VisitNumber,TestsetDr,TestSetCounter)
  Q
ByRecDateUser(Date)
  S Date=$G(Date)
  F Time="" F  S Time=$O(^TDAY(10,Date,Time)) Q:Time=""  D
  .S ptype="" F  S ptype=$O(^TDAY(10,Date,Time,ptype)) Q:ptype=""  D
  ..S VisitNumber="" F  S VisitNumber=$O(^TDAY(10,Date,Time,ptype,"N",VisitNumber)) Q:VisitNumber=""  D
  ...S TestsetDr="" F  S TestsetDr=$O(^TDAY(10,Date,Time,ptype,"N",VisitNumber,TestsetDr)) Q:TestsetDr=""  D
  ....S TestSetCounter="" F  S TestSetCounter=$O(^TDAY(10,Date,Time,ptype,"N",VisitNumber,TestsetDr,TestSetCounter))  Q:TestSetCounter=""  D
  .....I '$D(^TEPI(VisitNumber)) Q
  .....I PatientType'[$P(^TEPI(VisitNumber),"\",48) Q ;GP->未上线,Y->住院,N->门诊
  .....I PatientType="GP",$P(^TEPI(VisitNumber),"\",48)="P" Q
  .....D UserStatSum(VisitNumber,TestsetDr,TestSetCounter)
  Q
UserStatSum(VisitNumber,TestsetDr,TestSetCounter)
  I '$D(^TEPI(VisitNumber,1,TestsetDr)) Q
  I $l($P(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",52)) Q ;标本异常处理 20080426
  S MachineC=$P(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",27)
  I $l(MachCode),MachCode'=MachineC Q
  I $l(MachTG),$l(MachCode),'$D(^TMIF(MachCode,"TG",MachTG,"TS",TestsetDr)) Q
  S CliDepartCode=$P(^TEPI(VisitNumber),"\",36)
  I $l(CliDepCode),CliDepCode'=CliDepartCode Q
  I UserDep'[$E(TestsetDr,1) Q
  S UsrDr=$P(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",3)
  I '$l(UsrDr) Q
  S tflag=0
  S cnt="" F  S cnt=$O(plUser(cnt)) Q:(cnt="")!(tflag=1)  D
  .I UsrDr=$P(plUser(cnt),"^",1) D
  ..S tflag=1
  ..S sum=sum+1
  ..S plSum(cnt)=plSum(cnt)+1
  ..S Price=0
  ..I $P(^TEPI(VisitNumber),"\",48)'="GP" D
  ...S cDate=$P(^TEPI(VisitNumber),"\",10)
  ...S TestSetRowID=VisitNumber_"||"_TestsetDr_"||"_TestSetCounter
  ...S Price=##class(web.DHCLabCommonUse).CalTestSetFee(VisitNumber,TestSetRowID,NameSpace,cDate)
  ..S plTestSetFee(cnt)=plTestSetFee(cnt)+Price
  ..S tsSum=tsSum+1
  ..S ^TMP($zn,$j,UsrDr,tsSum)=TestsetDr_"^"_Price
  Q 

Output
	S Data=$lb(UserCode,UserName,TSNumber,TSSumPrice)
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
/// Description:： 按检验用户查询医嘱统计
/// Table：        
/// Input：        DateS(格式如："2013-04-01"),DateE(格式如："2013-05-15"),User:检验科用户(必填，只检索用户所分配权限的科室数据),NameSpace:命名空间(格式："LABDATA"),,MachCode:仪器代码为空取全部仪器 ,MachineTG:仪器组代码,为空全部仪器分组，DateType：接收审核类型(0:按接收日期查询，1:按审核日期查询)，PatientType：病人类型为空默认检索全部类型(N:门诊,Y：住院,P：急诊,O：体检,GP：手工未上线病人")，CliDepCode：医生所在科室(为空默认取全部科室)
/// Output：       检验科用户工号，用户姓名，医嘱数量，医嘱总价
/// Return：       无
/// Others：
/// D ##class(%ResultSet).RunQuery("web.DHCLabStatTestSetByUser","QueryTSStatistics","2013-04-01","2013-05-15","demo","LABDATA","","",0,"","")
Query QueryTSStatistics(DateS As %String, DateE As %String, User As %String, NameSpace As %String, MachCode As %String, MachTG As %String, DateType As %String, PatientType As %String, CliDepCode As %String, USERCODE As %String) As %Query(ROWSPEC = "PatDebno:%String,PatName:%String,TSNumber:%String,TSSumPrice:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCLabStatTestSetByUserDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCLabStatTestSetByUserD</DataLocation>
<DefaultData>DHCLabStatTestSetByUserDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCLabStatTestSetByUserD</IdLocation>
<IndexLocation>^web.DHCLabStatTestSetByUserI</IndexLocation>
<StreamLocation>^web.DHCLabStatTestSetByUserS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
