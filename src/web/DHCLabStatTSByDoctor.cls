Class web.DHCLabStatTSByDoctor Extends %Persistent
{

/// 医生医嘱汇总统计
Parameter BUILD = 60;

ClassMethod QuerySampleStatisticsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySampleStatisticsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// D ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// D ##class(%ResultSet).RunQuery("web.DHCLabStatTSByDoctor","QuerySampleStatistics","2013-04-01","2013-05-15","","","","","","")
ClassMethod QuerySampleStatisticsExecute(ByRef qHandle As %Binary, DateS As %String, DateE As %String, Doctor As %String, MachCode As %String, MachTG As %String, DateType As %String, PatType As %String, NameSpace As %String, USERCODE As %String) As %Status
{
  S repid=$I(^CacheTemp)
  I $G(ind)="" S ind=1
  I '$L(DateS) S DateS=$ZD(DateS,3)
  I '$L(DateE) S DateE=$ZD(DateE,3)
  S DateS=$ZDH(DateS,3),DateE=$ZDH(DateE,3)
  S USERCODE=$G(USERCODE)
  I '$L(USERCODE) S USERCODE="demo"
  //S USERCODE=70251
  S UserDep=""
  I '$L(USERCODE)   Set qHandle=$lb(0,repid,0) Quit $$$OK
  S dep="" F  S dep=$o(^TTAB("UA",USERCODE,4,dep)) Q:dep=""  D
  .S UserDep=UserDep_dep
  S PatType=$g(PatType)
  I '$L(PatType) S PatType="NYPOGP"
  S MachTG=$G(MachTG)
  S MachCode=$G(MachCode)
  I Doctor="null" S Doctor=""
  I MachCode="null" S MachCode=""
  S NameSpace=$G(NameSpace)
  S ^TMP("Samp2")=Doctor
  S SumCount=0
  I DateType=0 D  //审核日期
  .F CurDate=DateS:1:DateE D
  ..S VisitNumber="" F  S VisitNumber=$o(^TEPIi("AUTHORISED",CurDate,VisitNumber)) Q:VisitNumber=""  D
  ...S TestsetDr="" F  S TestsetDr=$o(^TEPIi("AUTHORISED",CurDate,VisitNumber,TestsetDr)) Q:TestsetDr=""  D
  ....S TestSetCounter="" F  S TestSetCounter=$o(^TEPIi("AUTHORISED",CurDate,VisitNumber,TestsetDr,TestSetCounter)) Q:TestSetCounter=""  D
  .....I PatType'[$p(^TEPI(VisitNumber),"\",48) Q ;GP->未上线,Y->住院,N->门诊
  .....I PatType="GP",$p(^TEPI(VisitNumber),"\",48)="P" Q
  .....S AuthosizeTime=$p(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",5) * 60
  .....I $l($p(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",52)) Q ;标本异常处理 20080426
  .....S MachineC=$p(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",27)
  .....I $l(MachCode),MachCode'=MachineC Q
  .....I $l(MachTG),$l(MachCode),'$d(^TMIF(MachCode,"TG",MachTG,"TS",TestsetDr)) Q  
  .....S CliDepartCode=$p(^TEPI(VisitNumber),"\",36)
  .....//I $l(Doctor),Doctor'=CliDepartCode Q  
  .....I UserDep'[$E(TestsetDr,1) Q
  .....S Price=0
  .....S cDate=$p(^TEPI(VisitNumber),"\",10)
  .....S TestSetRowID=VisitNumber_"||"_TestsetDr_"||"_TestSetCounter
  .....S Price=##class(web.DHCLabCommonUse).CalTestSetFee(VisitNumber,TestSetRowID,NameSpace,cDate)
  .....S ^TMP($zn,$j,"AllSum",VisitNumber,TestsetDr,TestSetCounter)=Price
  .D DocStatSum
  I DateType=1 D  //接收日期
  .F CurDate=DateS:1:DateE D
  ..f tim="" F  S tim=$o(^TDAY(10,CurDate,tim)) Q:tim=""  D
  ...S ptype="" F  S ptype=$o(^TDAY(10,CurDate,tim,ptype)) Q:ptype=""  D
  ....S VisitNumber="" F  S VisitNumber=$o(^TDAY(10,CurDate,tim,ptype,"N",VisitNumber)) Q:VisitNumber=""  D
  .....S TestsetDr="" F  S TestsetDr=$o(^TDAY(10,CurDate,tim,ptype,"N",VisitNumber,TestsetDr)) Q:TestsetDr=""  D
  ......S TestSetCounter="" F  S TestSetCounter=$o(^TDAY(10,CurDate,tim,ptype,"N",VisitNumber,TestsetDr,TestSetCounter))  Q:TestSetCounter=""  D
  .......I PatType'[$p(^TEPI(VisitNumber),"\",48) Q ;GP->未上线,Y->住院,N->门诊
  .......I PatType="GP",$p(^TEPI(VisitNumber),"\",48)="P" Q
  .......I $l($p(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",52)) Q ;标本异常处理 20080426
  .......S MachineC=$p(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",27)
  .......I $l(MachCode),MachCode'=MachineC Q
  .......I $l(MachTG),$l(MachCode),'$d(^TMIF(MachCode,"TG",MachTG,"TS",TestsetDr)) Q
  .......S CliDepartCode=$p(^TEPI(VisitNumber),"\",36)
  .......//I $l(Doctor),Doctor'=CliDepartCode Q
  .......I UserDep'[$E(TestsetDr,1) Q
  .......S Price=0
  .......S cDate=$p(^TEPI(VisitNumber),"\",10)
  .......S TestSetRowID=VisitNumber_"||"_TestsetDr_"||"_TestSetCounter
  .......S Price=##class(web.DHCLabCommonUse).CalTestSetFee(VisitNumber,TestSetRowID,NameSpace,cDate)
  .......S ^TMP($zn,$j,"AllSum",VisitNumber,TestsetDr,TestSetCounter)=Price
  .D DocStatSum
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
DocStatSum
  Kill ^TMP($zn,$j,"Labno"),^TMP($j)
  s SumCount=0,SumOrders=0,SumPrice=0
  s VisitNumber="" f  s VisitNumber=$o(^TMP($zn,$j,"AllSum",VisitNumber)) q:VisitNumber=""  d
  .s SumCount=SumCount+1
  .Set Docname=""					;医生
  .Set Doccode=$p(^TEPI(VisitNumber),"\",13)
  .If Doccode'="",$d(^TTAB("DR",Doccode)) s Docname=$p(^TTAB("DR",Doccode),"\",1)
  .If Doccode="" Set Doccode="未录医生"
  .s TestsetDr="" f  s TestsetDr=$o(^TMP($zn,$j,"AllSum",VisitNumber,TestsetDr)) q:TestsetDr=""  d
  ..s TestSetCounter="" f  s TestSetCounter=$o(^TMP($zn,$j,"AllSum",VisitNumber,TestsetDr,TestSetCounter)) q:TestSetCounter=""  d
  ...i '$d(^TMP($zn,$j,"Labno",VisitNumber)) d
  ....s ^TMP($zn,$j,"Labno",VisitNumber)=""
  ....Set Doccode=""
  ....Set Doccode=$p(^TEPI(VisitNumber),"\",13)
  ....If Doccode="" Set Doccode="未录医生"
  ....I $L(Doctor),Doctor'=Doccode Q
  ....Set $p(^TMP($zn,$j,"DOC",Doccode),"^",1)=+$p($Get(^TMP($zn,$j,"DOC",Doccode)),"^",1)+1
  ...//s SumCount=SumCount+1
  ...s TSPrice=+$g(^TMP($zn,$j,"AllSum",VisitNumber,TestsetDr,TestSetCounter))
  ...s SumOrders=SumOrders+1
  ...s SumPrice=SumPrice+TSPrice
  ...//临床科室统计
  ...Set Loccode=$p(^TEPI(VisitNumber),"\",36)
  ...If Loccode="" Set Loccode="未录科室"
  ...s $p(^TMP($zn,$j,"DOC",Doccode),"^",2)=+$p($Get(^TMP($zn,$j,"DOC",Doccode)),"^",2)+1
  ...s $p(^TMP($zn,$j,"DOC",Doccode),"^",3)=+$p($Get(^TMP($zn,$j,"DOC",Doccode)),"^",3)+TSPrice
  ...//医嘱汇总
  ...s $p(^TMP($j,"Orders",Doccode,TestsetDr),"^",1)=$p($g(^TMP($j,"Orders",Doccode,TestsetDr)),"^",1)+1
  ...s $p(^TMP($j,"Orders",Doccode,TestsetDr),"^",2)=$p($g(^TMP($j,"Orders",Doccode,TestsetDr)),"^",2)+TSPrice
  k ^TMP($zn,$j,"DATA")
  s num=0
  s CurDoccode="" f  s CurDoccode=$o(^TMP($zn,$j,"DOC",CurDoccode)) q:CurDoccode=""  d
  .s num=num+1
  .Set DocName=""
  .If '$Data(^TTAB("DR",CurDoccode)) Set DocName="未录医生"
  .Else  Set DocName=$Piece($Get(^TTAB("DR",CurDoccode)),"\",1)
  .S SampleNumber=$P(^TMP($zn,$j,"DOC",CurDoccode),"^",1)
  .S TestNumber=$P(^TMP($zn,$j,"DOC",CurDoccode),"^",2)
  .S Price=$P(^TMP($zn,$j,"DOC",CurDoccode),"^",3)
  .I $L(Doctor),Doctor'=CurDoccode Q
  .S Data=$lb(DocName,SampleNumber,TestNumber,Price)
  .D Output
  k ^TMP($zn,$j,"AllSum"),^TMP($zn,$j,"UA"),^TMP($zn,$j,"Labno"),^TMP($zn,$j,"DOC")
  s P9="总计标本数:"_SumCount_"  总计医嘱数:"_SumOrders_"  总计金额:"_$fn(SumPrice,"",2)
  q num
Output
	set Data=$lb(DocName,SampleNumber,TestNumber,Price)
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
/// D ##class(%ResultSet).RunQuery("web.DHCLabStatTSByDoctor","QuerySampleStatistics","2013-04-23","2013-05-23","","","",0,"","DHC-DATA")
Query QuerySampleStatistics(DateS As %String, DateE As %String, Doctor As %String, MachCode As %String, MachTG As %String, DateType As %String, PatType As %String, NameSpace As %String, USERCODE As %String) As %Query(ROWSPEC = "DocName:%String,SampleNumber:%String,TestNumber:%String,Price:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCLabStatTSByDoctorDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCLabStatTSByDoctorD</DataLocation>
<DefaultData>DHCLabStatTSByDoctorDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCLabStatTSByDoctorD</IdLocation>
<IndexLocation>^web.DHCLabStatTSByDoctorI</IndexLocation>
<StreamLocation>^web.DHCLabStatTSByDoctorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
