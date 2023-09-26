Class web.DHCLabStatSortSample Extends %Persistent
{

/// 标本运送
Parameter BUILD = 60;

ClassMethod QuerySampleStatisticsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySampleStatisticsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// D ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// D ##class(%ResultSet).RunQuery("web.DHCLabStatLocOutSample","QuerySampleStatistics","2013-04-01","2013-05-15","","","","","","")
ClassMethod QuerySampleStatisticsExecute(ByRef qHandle As %Binary, DateS As %String, DateE As %String, CliDepCode As %String, Ward As %String, TransmitNo As %String, TransUserId As %String, SpCode As %String, ReportStutus As %String, USERCODE As %String) As %Status
{
  S repid=$I(^CacheTemp)
  I $G(ind)="" S ind=1
  S DateS=$G(DateS),DateE=$G(DateE),CliDepCode=$G(CliDepCode),TransmitNo=$G(TransmitNo),SpCode=$G(SpCode)
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
  I CliDepCode="null" S CliDepCode=""
  s ^TMP("Sample")=DateS_","_DateE_","_CliDepCode_","_Ward_","_TransmitNo_","_TransUserId_","_SpCode_","_ReportStutus
  S Num=0
  F Date=DateS:1:DateE 
  {
	  I '$D(^DHCSpecTransi("Date",Date)) CONTINUE
	  S Time=$O(^DHCSpecTransi("Date",Date,""))
	  S TransNo=$O(^DHCSpecTransi("Date",Date,Time,""))
	  I $L(TransmitNo),TransmitNo'=TransNo CONTINUE
	  S RowId=$O(^DHCSpecTransi("Date",Date,Time,TransNo,""))
	  S LocDr=$P(^DHCSpecTrans(RowId),"^",6)
	  S WARDLocationDR=""
	  I $L(Ward) S WARDLocationDR=$P(^PAWARD(Ward),"^",5)
	  I $L(WARDLocationDR),WARDLocationDR'=LocDr CONTINUE
	  S (userName,LocDesc)=""
	  I $L(LocDr) S LocDesc=$P(^CTLOC(LocDr),"^",2)
	  S DepOutDate=$P(^DHCSpecTrans(RowId),"^",14)
	  I $L(DepOutDate) S DepOutDate=$ZD(DepOutDate,3)
	  S DepOutTime=$P(^DHCSpecTrans(RowId),"^",15)
	  I $L(DepOutTime) S DepOutTime=$ZT(DepOutTime,2)
	  S userCode=$P(^DHCSpecTrans(RowId),"^",3)
      I $L(userCode) S userName=$P(^SSU("SSUSR",userCode),"^",2) 
      S TransUser=$P(^DHCSpecTrans(RowId),"^",8)
      I $L(TransUserId)
      S RecieveUser=$P(^DHCSpecTrans(RowId),"^",11)
	  S SubRowId=""
	  F  S SubRowId=$O(^DHCSpecTrans(RowId,SubRowId)) Q:SubRowId=""  D
	  .S Labno=$P(^DHCSpecTrans(RowId,SubRowId),"^",1)
	  .I '$D(^OEORD(0,"EpisNo",Labno)) Q
	  .S OrdId=$O(^OEORD(0,"EpisNo",Labno,""))	
	  .S OrdSubId=$O(^OEORD(0,"EpisNo",Labno,OrdId,""))	
	  .S patID=$Piece(^OEORD(OrdId,"I",OrdSubId,3),"^",9)
	  .S (Adm,TSName)=""
	  .S SpecCollDate=$P($G(^OEORD(OrdId,"I",OrdSubId,"X",1,"NUR")),"^",2)
      .S SpecCollTime=$P($G(^OEORD(OrdId,"I",OrdSubId,"X",1,"NUR")),"^",3)
      .I $L(SpecCollDate),$L(SpecCollTime) D
      ..S ColDate=$ZD($G(SpecCollDate),3)
      ..S ColTime=$ZD($G(SpecCollTime),2)
      .S RecieveDate=$P(^DHCSpecTrans(RowId),"^",9)
      .S RecieveTime=$P(^DHCSpecTrans(RowId),"^",10)
      .I $L(RecieveDate),$L(RecieveTime) D
      ..S RecieveDate=$ZD(RecieveDate,3)
      ..S RecieveTime=$ZT(RecieveTime,2)
	  .I $L(patID) S Adm=$O(^PAPERi("PAPMI_PatNo",patID,""))
	  .I $L(Adm) S PatName=$P(^PAPER(Adm,"ALL"),"^",1)
	  .S GenderDr=$P(^PAPER(Adm,"ALL"),"^",7)
	  .S Gender=$P(^CT("SEX",GenderDr),"^",2)
	  .S Age=$P((+$H-$P(^PAPER(Adm,"ALL"),"^",6))/365,".",1)
	  .S TSCode=$P(^OEORD(OrdId,"I",OrdSubId,1),"^",2)
      .I $L(TSCode) S TSName=$P(^ARCIM($P(TSCode,"||",1),$P(TSCode,"||",2),1),"^",2)
      .S (SpecCode,SpecName,EXTLabCode)=""
      .I $L(TSCode) S Code1=$P(TSCode,"||",1),Code2=$P(TSCode,"||",2)
	  .F i=1:1:10  D
	  ..I $D(^ARCIM(Code1,Code2,"EXT",i)) S EXTLabCode=$P(^ARCIM(Code1,Code2,"EXT",i),"^",4)
      .I $D(^TTAB("TS",EXTLabCode,1)) S SpecCode=$O(^TTAB("TS",EXTLabCode,1,""))
      .S ReportAuth=""
      .I $D(^TEPI(Labno,1,EXTLabCode,1)) S ReportAuth=$P(^TEPI(Labno,1,EXTLabCode,1),"\",31)
      .I ReportStutus'="B",ReportStutus'="C",$L(ReportStutus),ReportAuth'=ReportStutus Q
      .I ReportStutus="C",ReportAuth="A" Q
      .I $L(SpCode),SpCode'=SpecCode Q
      .I $L(SpecCode) S SpecName=$P(^TTAB("SPEC",SpecCode),"\",1)
      .S FinshState=$P(^DHCSpecTrans(RowId,SubRowId),"^",3)
      .I $L(FinshState) S FinshState=$S(FinshState="C||未完成":"未完成",FinshState="F||完成":"完成")
      .I ReportAuth="A" S FinshState="已审核"
      .S RecieveUser=$P(^DHCSpecTrans(RowId),"^",11)
      .S ContainerNo=$P(^DHCSpecTrans(RowId,SubRowId),"^",6)
      .I $L(ContainerNo) S ContainerNo=$P(^TTAB("CON",ContainerNo),"\",1)
      .S Num=Num+1
      .S Data=$lb(Num,PatName,Gender,Age,Labno,Adm,SpecCollDate,SpecCollTime,DepOutDate,DepOutTime,LocDesc,userName,TransUser,TransNo,RecieveDate,RecieveTime,FinshState,Remark,TSName,RecieveUser,SpecName,ContainerNo)
      .D Output
  }
  S qHandle=$lb(0,repid,0)
  Q $$$OK

Output
	S Data=$lb(Num,PatName,Gender,Age,Labno,Adm,SpecCollDate,SpecCollTime,DepOutDate,DepOutTime,LocDesc,userName,TransUser,TransNo,RecieveDate,RecieveTime,FinshState,Remark,TSName,RecieveUser,SpecName,ContainerNo)
 	S ^CacheTemp(repid,ind)=Data
 	S ind=ind+1
	Q
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
/// CreatDate：    20140603
/// Description:： 出科标本汇总
/// Table：        
/// Input：        DateS:起始日期,DateE:结束日期，DepCode：检验科科室代码,MachCode仪器代码为空全部检索，MachTG：仪器组代码为空全部检索，CliCode：医生申请科室代码为空全部检索，DocCode:医生工号为空全部检索，PatientType：病人类型为空默认检索全部类型(N:门诊,Y：住院,P：急诊,O：体检,GP：手工未上线病人")
/// Output：       Debtor:登记号,PatName：病人姓名,SpeName：性别,PatAge：年龄,CliDepName：申请科室,Labno：检验号,TestName：医嘱名称,ColectDateTime:采集时间,RecevieDateTime:接收时间,AuthorDateTime:审核时间,ReportStutus:C未审核，A已审核，B所有标本
/// Return：       无
/// Others：
/// D ##class(%ResultSet).RunQuery("web.DHCLabStatSortSample","QuerySampleStatistics","2014-04-01","2014-06-04","","","","","","")
Query QuerySampleStatistics(DateS As %String, DateE As %String, CliDepCode As %String, Ward As %String, TransmitNo As %String, TransUserId As %String, SpCode As %String, ReportStutus As %String, USERCODE As %String) As %Query(ROWSPEC = "Num:%String,PatName:%String,Gender:%String,Age:%String,Labno:%String,Adm:%String,SpecCollDate:%String,SpecCollTime:%String,DepOutDate:%String,DepOutTime:%String,LocDesc:%String,userName:%String,TransUser:%String,TransNo:%String,RecieveDate:%String,RecieveTime:%String,FinshState:%String,Remark:%String,TSName:%String,RecieveUser:%String,SpecName:%String,ContainerNo:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCLabStatSortSampleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCLabStatSortSampleD</DataLocation>
<DefaultData>DHCLabStatSortSampleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCLabStatSortSampleD</IdLocation>
<IndexLocation>^web.DHCLabStatSortSampleI</IndexLocation>
<StreamLocation>^web.DHCLabStatSortSampleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
