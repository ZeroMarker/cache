Class web.DHCMicStatBugIsolate Extends %Persistent
{

/// 细菌分离统计
Parameter BUILD = 60;

ClassMethod QuerySampleStatisticsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySampleStatisticsExecute ]
{
	S repid=$LIST(qHandle,2)
 	K ^CacheTemp(repid)
	Q $$$OK
}

/// Query的执行方法
/// D ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// D ##class(%ResultSet).RunQuery("web.DHCMicStatBugIsolate","QuerySampleStatistics","2013-04-01","2013-05-15","","","","","","")
ClassMethod QuerySampleStatisticsExecute(ByRef qHandle As %Binary, DateS As %String, DateE As %String) As %Status
{
  S repid=$I(^CacheTemp)
  I $G(ind)="" S ind=1
  S sLabNameSpace="LABDATA"	
  S sMedNameSpace="DHC-DATA"	
  I '$L(sLabNameSpace) S sLabNameSpace="LABDATA"
  I '$L(sMedNameSpace) S sMedNameSpace="DHC-DATA"
  S HospCode=$O(^TTABi("CC",1,""))
  S DateS=$G(DateS),DateE=$G(DateE)
  S DateS=$ZDH(DateS,3),DateE=$ZDH(DateE,3)
  S DepCode=""
  I $D(^TTABi("DEP",60)) S DepCode=$O(^TTABi("DEP",60,""))
  //K ^TMP($zn,$j)
  S Num=0
  F Date=DateS:1:DateE D 
  .D ByAuthDate(Date)
  //K ^TMP($zn,$j)
  S qHandle=$lb(0,repid,0)
  Q $$$OK
ByAuthDate(Date)
  S Date=$G(Date)
  S labno="" F  S labno=$O(^TEPIi("AUTHORISED",Date,labno)) Q:labno=""  D
  .S ts="" F  S ts=$O(^TEPIi("AUTHORISED",Date,labno,ts)) Q:ts=""  D
  ..I $L(DepCode),$e(ts)'=DepCode Q
  ..S tscnt="" F  S tscnt=$O(^TEPIi("AUTHORISED",Date,labno,ts,tscnt)) Q:tscnt=""  D
  ...I $L($P(^TEPI(labno,1,ts,tscnt),"\",52)) Q  //标本异常处理
  ...S TestCode="" F  S TestCode=$O(^TEPI(labno,1,ts,tscnt,"DATA",TestCode)) Q:TestCode=""  D
  ....I $D(^TTAB("TC",TestCode)),$P(^TTAB("TC",TestCode),"\",3)'="V" Q  //只查细菌类型
  ....D SetSampleInfo(labno,ts,tscnt,TestCode)
  Q
SetSampleInfo(labno,ts,tscnt,TestCode)
  S labno=$G(labno),ts=$G(ts),tscnt=$G(tscnt)
  S SampleNo=$P(^TEPI(labno,1,ts,tscnt),"\",47)
  S SurName=$P(^TEPI(labno),"\",2)
  S SpeciesNo=$TR($P(^TEPI(labno),"\",3)," ")
  S SpeciesName=""
  I SpeciesNo'="" S SpeciesName=$P(^TTAB("SP",SpeciesNo),"\",1)
  S Age=$P(^TEPI(labno),"\",25)
  S Debtor=$P(^TEPI(labno),"\",18)
  S HospNo=""
  I Debtor'="" S HospNo=##class(web.DHCLabCommonUse).GetHospnoByDebno(Debtor) ;$O(^TDEBi(debtor,"HOSPITAL",""),-1)
  S PatLoc=""					   ;科室
  S LocCode=$P(^TEPI(labno),"\",36) 
  I LocCode'="",$D(^TTAB("USLOC",LocCode)) S PatLoc=$P($G(^TTAB("USLOC",LocCode)),"\",1)
  I PatLoc["-" S PatLoc=$P(PatLoc,"-",2)
  S patWardname=""
  S tempatwarddr=$P(^TEPI(labno),"\",20)
  I $L(tempatwarddr),$D(^TTAB("RH",tempatwarddr)) S patWardname=$P(^TTAB("RH",tempatwarddr),"\",1)
  I $L(patWardname,"-")>1 S patWardname=$P(patWardname,"-",2)
  S Bed=""
  I $D(^TEPI(labno,0)) S Bed=$P(^TEPI(labno,0),"\",29)	 //床号    
  S SpeName=""
  S SpeCode=$P(^TEPI(labno,1,ts,tscnt),"\",46)   //标本类型
  I SpeCode'="",$D(^TTAB("SPEC",SpeCode)) S SpeName=$P(^TTAB("SPEC",SpeCode),"\",1)
  ;细菌
  S BugsName=""
  S BugsType=""
  S BugCode=$P(^TEPI(labno,1,ts,tscnt,"DATA",TestCode),"\",1)
  I $L(BugCode),$D(^TTAB("BUG",BugCode)) D
  .S BugsName=$P(^TTAB("BUG",BugCode),"\",1)
  .S BugsType=$P(^TTAB("BUG",BugCode),"\",2)
  S authDate=$P(^TEPI(labno,1,ts,tscnt),"\",4)
  I authDate'="" S authDate=$ZD(authDate,3)    //核实日期
  S Num=Num+1
  S vbTab=$C(9)
  //S tmpStr=Num_vbTab_labno_vbTab_SampleNo_vbTab_SurName_vbTab_SpeciesName_vbTab_Age_vbTab_Debtor_vbTab_HospNo_vbTab_PatLoc
  //S tmpStr=tmpStr_vbTab_patWardname_vbTab_Bed_vbTab_SpeName_vbTab_BugsName_vbTab_BugsType_vbTab_authDate
  //S ^TMP($zn,$j,Num)=tmpStr
  S Data=$lb(Num,labno,SampleNo,SurName,SpeciesName,Age,Debtor,HospNo,PatLoc,patWardname,Bed,SpeName,BugsName,BugsType,authDate)
  D Output
  Q
 
Output
    S Data=$lb(Num,labno,SampleNo,SurName,SpeciesName,Age,Debtor,HospNo,PatLoc,patWardname,Bed,SpeName,BugsName,BugsType,authDate)
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
 	{				// if there are no more rows, finish fetching
 		S AtEnd=1
 		S Row=""
 	}
 	Else      
 	{	// fetch row
 		S Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	S qHandle=$lb(AtEnd,repid,ind)
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
/// D ##class(%ResultSet).RunQuery("web.DHCMicStatBugIsolate","QuerySampleStatistics","2014-09-24","2014-10-24")
Query QuerySampleStatistics(DateS As %String, DateE As %String) As %Query(ROWSPEC = "Num:%String,labno:%String,SampleNo:%String,SurName:%String,SpeciesName:%String,Age:%String,Debtor:%String,HospNo:%String,PatLoc:%String,patWardname:%String,Bed:%String,SpeName:%String,BugsName:%String,BugsType:%String,authDate:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCMicStatBugIsolateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCMicStatBugIsolateD</DataLocation>
<DefaultData>DHCMicStatBugIsolateDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCMicStatBugIsolateD</IdLocation>
<IndexLocation>^web.DHCMicStatBugIsolateI</IndexLocation>
<StreamLocation>^web.DHCMicStatBugIsolateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
