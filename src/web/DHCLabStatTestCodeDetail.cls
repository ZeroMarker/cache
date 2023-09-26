Class web.DHCLabStatTestCodeDetail Extends %Persistent
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
/// D ##class(%ResultSet).RunQuery("web.DHCLabStatTestCodeDetail","QuerySampleStatistics","2013-04-01","2013-05-15","","","","","","")
ClassMethod QuerySampleStatisticsExecute(ByRef qHandle As %Binary, DateS As %String, DateE As %String, DepCode As %String, MachCode As %String, EpisS As %String, EpisE As %String, USERCODE As %String) As %Status
{
  S repid=$I(^CacheTemp)
  I $G(ind)="" S ind=1
  S sLabNameSpace="LABDATA"	
  S sMedNameSpace="DHC-DATA"	
  I '$L(sLabNameSpace) S sLabNameSpace="LABDATA"
  I '$L(sMedNameSpace) S sMedNameSpace="DHC-DATA"
  S HospCode=$O(^TTABi("CC",1,""))
  S sLabNameSpace=$G(sLabNameSpace),sMedNameSpace=$G(sMedNameSpace)
  S DateS=$G(DateS),DateE=$G(DateE),DepCode=$G(DepCode),MachCode=$G(MachCode),HospCode=$G(HospCode)
  S EpisS=$G(EpisS),EpisE=$G(EpisE),lan=$G(lan)
  S ^TMP("DHCLabStatRejectSample")=$lb(DateS, DateE, DepCode, MachCode, EpisS, EpisE, USERCODE)
  I '$L(DateS) S DateS=$ZD(DateS,3)
  I '$L(DateE) S DateE=$ZD(DateE,3)
  S DateS=$zdh(DateS,3),DateE=$zdh(DateE,3)
  S USERCODE=$G(USERCODE)
  I '$L(USERCODE) S USERCODE="demo"
  //S USERCODE=70251
  S UserDep=""
  I '$L(USERCODE)   Set qHandle=$lb(0,repid,0) Quit $$$OK
  S dep="" F  S dep=$o(^TTAB("UA",USERCODE,4,dep)) Q:dep=""  D
  .S UserDep=UserDep_dep
  K ^TMP($zn)
  S num=1
  F dd=DateS:1:DateE D
  .S labno="" F  S labno=$O(^TEPIi("AUTHORISED",dd,labno)) Q:labno=""  D
  ..//判断医院代码---------------------------
  ..S CurHospCode=$P(^TEPI(labno),"\",26)
  ..I $L(HospCode),$L(CurHospCode),CurHospCode'=HospCode Q
  ..I $L(HospCode),'$L(CurHospCode),'$D(^TTABi("CC",1,HospCode)) Q
  ..//---------------------------------------
  ..S ts="" F  S ts=$O(^TEPIi("AUTHORISED",dd,labno,ts)) Q:ts=""  D
  ...I $E(ts)'=DepCode q
  ...S tscnt="" F  S tscnt=$O(^TEPIi("AUTHORISED",dd,labno,ts,tscnt)) Q:tscnt=""  D
  ....S patname=##class(web.DHCLabCommonUse).GetPatName(labno)
  ....S debtor=$P(^TEPI(labno),"\",18) ;登记号
  ....//判断医院代码---------------------------
  ....S CurHospCode=$P(^TEPI(labno),"\",26)
  ....I $L(HospCode),$L(CurHospCode),CurHospCode'=HospCode Q
  ....I $L(HospCode),'$L(CurHospCode),'$D(^TTABi("CC",1,HospCode)) Q
  ....//---------------------------------------
  ....S Sexname=""				;性别
  ....S spcode=$P(^TEPI(labno),"\",3)
  ....I spcode'="",$D(^TTAB("SP",spcode)) S Sexname=$P(^TTAB("SP",spcode),"\",1)
  ....//科室
  ....S patloc=""					   
  ....S loccode=$P(^TEPI(labno),"\",36) 
  ....I loccode'="",$D(^TTAB("USLOC",loccode)) S patloc=$P($G(^TTAB("USLOC",loccode)),"\",1)
  ....S patloc1=$P(patloc,"-",1),patloc2=$P(patloc,"-",2)
  ....I $L(patloc2)  Do
  .....S patloc=patloc2
  ....E  D
  .....S patloc=patloc1 
  ....S temres="",epis=""
  ....S temmach=$P(^TEPI(labno,1,ts,tscnt),"\",27)
  ....I $L(MachCode),MachCode'=temmach Q
  ....I '$L(DepCode),UserDep'[$E(TestsetDr,1) Q
  ....S temres=""
  ....S epis=$P(^TEPI(labno,1,ts,tscnt),"\",12)
  ....S specode=$P(^TEPI(labno,1,ts,tscnt),"\",46) ;标本类型
  ....S SpName=""
  ....I specode'="",$D(^TTAB("SPEC",specode)) S SpName=$P(^TTAB("SPEC",specode),"\",1)
  ....I epis'="" S epis=+epis
  ....I (epis'=0)&$L(EpisS)&(epis<EpisS) Q
  ....I (epis'=0)&$L(EpisE)&(epis>EpisE) Q
  ....//查询结果?
  ....S tc="" F  S tc=$O(^TEPI(labno,1,ts,tscnt,"DATA",tc)) Q:tc=""  D
  .....S temstr=^(tc)
  .....S AntStr=""
  .....I $E(tc,2,5)="9999" Q
  .....S tcname=$P(^TTAB("TC",tc),"\",12)
  .....I '$L(tcname) S tcname=$P(^TTAB("TC",tc),"\",1)
  .....I $L(tc) S tcType=$P(^TTAB("TC",tc),"\",3)
  .....S tcResult=$P(temstr,"\",1)
  .....I tcType["S" S tcResult=^TTAB("TC",tc,2,tcResult,1)	
  .....I tcType["N" D
  ......S:tcResult?.N.1".".N tcResult=$FNUMBER(tcResult,",",$E(tcType,2,2))   //wwh 2011-10-13
  .....I tcType["V" S tcResult=$P(^TTAB("BUG",tcResult),"\",1)
  .....I tcType["V" D
  ......S AntCode="" F  S AntCode=$O(^TEPI(labno,1,ts,tscnt,"DATA",tc,"ANT",AntCode)) Q:AntCode=""  Do
  .......S AntResult=$P(^TEPI(labno,1,ts,tscnt,"DATA",tc,"ANT",AntCode),"\",1)
  .......S AntMic=$P(^TEPI(labno,1,ts,tscnt,"DATA",tc,"ANT",AntCode),"\",3)
  .......S AntMM=$P(^TEPI(labno,1,ts,tscnt,"DATA",tc,"ANT",AntCode),"\",4)
  .......S AntStr=AntStr_" "_AntCode_":"_AntResult
  .......I $L(AntMic)  S AntStr=AntStr_" MIC:"_AntMic
  .......I $L(AntMM)  S AntStr=AntStr_" MM:"_AntMM
  .....S tcResult=tcResult_" "_AntStr
  .....S temres=temres_tcname_" "_tcResult_","
  ....S temres=$P(temres,",",1,$L(temres,",")-1)
  ....S temres=$TR($TR(temres,$C(13,10)),"-")
  ....S TestSetCode=$P(^TTAB("TS",ts),"\",1)
  ....I labno=100129 S ^DHCTMP("qq")=temres
  ....S ^TMP($zn,$j,num)=epis_$c(2)_patname_$c(2)_debtor_$C(2)_Sexname_$C(2)_SpName_$C(2)_patloc_$c(2)_TestSetCode_$C(2)_labno_$c(2)_temres_$c(2)_labno_"||"_ts_"||"_tscnt
  ....S TSRowID=labno_"||"_ts_"||"_tscnt
  ....S Field1=""
  ....S Field2=""
  ....S Field3=""
  ....S Field4=""
  ....S Field5=""
  ....S temres=$TR(temres,$C(13,10))
  ....S Data=$lb(epis,patname,debtor,Sexname,SpName,patloc,TestSetCode,labno,temres,TSRowID,Field1,Field2,Field3,Field4,Field5)
  ....S num=num+1
  ....D Output
  S qHandle=$lb(0,repid,0)
  Q $$$OK
Output
    S Data=$lb(epis,patname,debtor,Sexname,SpName,patloc,TestSetCode,labno,temres,TSRowID,Field1,Field2,Field3,Field4,Field5)
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
/// D ##class(%ResultSet).RunQuery("web.DHCLabStatTestCodeDetail","QuerySampleStatistics","2013-4-01","2013-5-14","A","","","")
Query QuerySampleStatistics(DateS As %String, DateE As %String, DepCode As %String, MachCode As %String, EpisS As %String, EpisE As %String, USERCODE As %String) As %Query(ROWSPEC = "epis:%String,patname:%String,debtor:%String,Sexname:%String,SpName:%String,patloc:%String,TestSetCode:%String,labno:%String,temres:%String,TSRowID:%String,Field1:%String,Field2:%String,Field3:%String,Field4:%String,Field5:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCLabStatTestCodeDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCLabStatTestCodeDetailD</DataLocation>
<DefaultData>DHCLabStatTestCodeDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCLabStatTestCodeDetailD</IdLocation>
<IndexLocation>^web.DHCLabStatTestCodeDetailI</IndexLocation>
<StreamLocation>^web.DHCLabStatTestCodeDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
