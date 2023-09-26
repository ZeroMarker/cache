Class web.DHCMicStatAntIsolate Extends %Persistent
{

/// 药敏分离统计
Parameter BUILD = 60;

ClassMethod QuerySampleStatisticsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySampleStatisticsExecute ]
{
	S repid=$LIST(qHandle,2)
 	K ^CacheTemp(repid)
	Q $$$OK
}

/// Query的执行方法
/// D ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// D ##class(%ResultSet).RunQuery("web.DHCMicStatAntIsolate","QuerySampleStatistics","2013-04-01","2013-05-15","","","","","","")
ClassMethod QuerySampleStatisticsExecute(ByRef qHandle As %Binary, DateS As %String, DateE As %String, Type As %String) As %Status
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
  S Type=$G(Type)
  S RetVal=0
  K ^TMP($zn,$j)
  I Type=0 D AntAll(DepCode,DateS,DateE) 
  E  D AntGroup(DepCode,DateS,DateE,Type)
  K ^TMP($zn,$j) 
  S qHandle=$lb(0,repid,0)
  Q $$$OK 
AntAll(DepCode,DateS,DateE)  
  F Date=DateS:1:DateE D 
  .S labno="" F  S labno=$O(^TEPIi("AUTHORISED",Date,labno)) Q:labno=""  D
  ..S ts="" F  S ts=$O(^TEPIi("AUTHORISED",Date,labno,ts)) Q:ts=""  D
  ...I $L(DepCode),$e(ts)'=DepCode Q
  ...S tscnt="" F  S tscnt=$O(^TEPIi("AUTHORISED",Date,labno,ts,tscnt)) Q:tscnt=""  D
  ....I $L($P(^TEPI(labno,1,ts,tscnt),"\",52)) Q  //标本异常处理
  ....S TestCode="" F  S TestCode=$O(^TEPI(labno,1,ts,tscnt,"DATA",TestCode)) Q:TestCode=""  D
  .....S ant="" F  S ant=$O(^TEPI(labno,1,ts,tscnt,"DATA",TestCode,"ANT",ant)) Q:ant=""  D
  ......S antRSI=$P(^TEPI(labno,1,ts,tscnt,"DATA",TestCode,"ANT",ant),"\",1)
  ......I antRSI="R" D
  .......I $D(^TMP($zn,$j,"ANT",ant)) S $P(^TMP($zn,$j,"ANT",ant),"\",2)=$P(^TMP($zn,$j,"ANT",ant),"\",2)+1
  .......E  S ^TMP($zn,$j,"ANT",ant)="\1\0\0"
  ......I antRSI="S" D
  .......I $D(^TMP($zn,$j,"ANT",ant)) S $P(^TMP($zn,$j,"ANT",ant),"\",3)=$P(^TMP($zn,$j,"ANT",ant),"\",3)+1
  .......E  S ^TMP($zn,$j,"ANT",ant)="\0\1\0"
  ......I antRSI="I" D
  .......I $D(^TMP($zn,$j,"ANT",ant)) S $P(^TMP($zn,$j,"ANT",ant),"\",4)=$P(^TMP($zn,$j,"ANT",ant),"\",4)+1
  .......E  S ^TMP($zn,$j,"ANT",ant)="\0\0\1"
  S Num=0,vbTab=$C(9)
  S ant="" F  S ant=$O(^TMP($zn,$j,"ANT",ant)) Q:ant=""  D
  .S Num=Num+1
  .S antName=$P(^TTAB("ANT",ant),"\",1)
  .S resR=$P(^TMP($zn,$j,"ANT",ant),"\",2)
  .S resS=$P(^TMP($zn,$j,"ANT",ant),"\",3)
  .S resI=$P(^TMP($zn,$j,"ANT",ant),"\",4)
  .S SumRes=resR+resS+resI
  .S resRB=+$TR($FN(resR/SumRes,"",2),".")
  .S resSB=+$TR($FN(resS/SumRes,"",2),".")
  .S resIB=+$TR($FN(resI/SumRes,"",2),".")
  .S resR=resR_" ("_resRB_"%)"
  .S resS=resS_" ("_resSB_"%)"
  .S resI=resI_" ("_resIB_"%)"
  .//S ^TMP($zn,$j,Num)=Num_vbTab_vbTab_antName_vbTab_resR_" ("_resRB_"%)"_vbTab_resS_" ("_resSB_"%)"_vbTab_resI_" ("_resIB_"%)"
  .S Data=$lb(Num,bName,antName,resR,resS,resI)
  .D Output
  K ^TMP($zn,$j) 
  Q 
AntGroup(DepCode,DateS,DateE,Type) 
  f Date=DateS:1:DateE D 
  .S labno="" F  S labno=$O(^TEPIi("AUTHORISED",Date,labno)) Q:labno=""  D
  ..S ts="" F  S ts=$O(^TEPIi("AUTHORISED",Date,labno,ts)) Q:ts=""  D
  ...I $L(DepCode),$e(ts)'=DepCode Q
  ...S tscnt="" F  S tscnt=$O(^TEPIi("AUTHORISED",Date,labno,ts,tscnt)) Q:tscnt=""  D
  ....I $L($P(^TEPI(labno,1,ts,tscnt),"\",52)) Q  //标本异常处理
  ....S TestCode="" F  S TestCode=$O(^TEPI(labno,1,ts,tscnt,"DATA",TestCode)) Q:TestCode=""  D
  .....S ant="" F  S ant=$O(^TEPI(labno,1,ts,tscnt,"DATA",TestCode,"ANT",ant)) Q:ant=""  D
  ......S bug=$P(^TEPI(labno,1,ts,tscnt,"DATA",TestCode),"\",1)
  ......S bugName=$P(^TTAB("BUG",bug),"\",1)
  ......S bugGP="",bugGPName=""
  ......I $L(bug),$D(^TTAB("BUG",bug)) S bugGP=$P(^TTAB("BUG",bug),"\",7)
  ......I $L(bugGP),$D(^TTAB("BUG-GROUP",bugGP)) S bugGPName=$G(^TTAB("BUG-GROUP",bugGP))
  ......I '$L(bugGP) S bugGP=bug,bugGPName=bugName
  ......I Type=1 S bCode=bug,bName=bugName
  ......E  S bCode=bugGP,bName=bugGPName
  ......S antRSI=$P(^TEPI(labno,1,ts,tscnt,"DATA",TestCode,"ANT",ant),"\",1)
  ......I antRSI="R" D
  .......I $D(^TMP($zn,$j,"ANT",bCode,ant)) S $P(^TMP($zn,$j,"ANT",bCode,ant),"\",2)=$P(^TMP($zn,$j,"ANT",bCode,ant),"\",2)+1
  .......E  S ^TMP($zn,$j,"ANT",bCode,ant)=bName_"\1\0\0"
  ......I antRSI="S" D
  .......I $D(^TMP($zn,$j,"ANT",bCode,ant)) S $P(^TMP($zn,$j,"ANT",bCode,ant),"\",3)=$P(^TMP($zn,$j,"ANT",bCode,ant),"\",3)+1
  .......E  S ^TMP($zn,$j,"ANT",bCode,ant)=bName_"\0\1\0"
  ......I antRSI="I" D
  .......I $D(^TMP($zn,$j,"ANT",bCode,ant)) S $P(^TMP($zn,$j,"ANT",bCode,ant),"\",4)=$P(^TMP($zn,$j,"ANT",bCode,ant),"\",4)+1
  .......E  S ^TMP($zn,$j,"ANT",bCode,ant)=bName_"\0\0\1"
  S Num=0,vbTab=$c(9)
  S bug="" F  S bug=$O(^TMP($zn,$j,"ANT",bug)) Q:bug=""  D
  .S ant="" F  S ant=$O(^TMP($zn,$j,"ANT",bug,ant)) Q:ant=""  D
  ..S Num=Num+1
  ..S antName=$P(^TTAB("ANT",ant),"\",1)
  ..S bName=$P(^TMP($zn,$j,"ANT",bug,ant),"\",1)
  ..S resR=$P(^TMP($zn,$j,"ANT",bug,ant),"\",2)
  ..S resS=$P(^TMP($zn,$j,"ANT",bug,ant),"\",3)
  ..S resI=$P(^TMP($zn,$j,"ANT",bug,ant),"\",4)
  ..S SumRes=resR+resS+resI
  ..S resRB=+$TR($FN(resR/SumRes,"",2),".")
  ..S resSB=+$TR($FN(resS/SumRes,"",2),".")
  ..S resIB=+$TR($FN(resI/SumRes,"",2),".")
  ..S resR=resR_" ("_resRB_"%)"
  ..S resS=resS_" ("_resSB_"%)"
  ..S resI=resI_" ("_resIB_"%)"
  ..//S ^TMP($zn,$j,Num)=Num_vbTab_bName_vbTab_antName_vbTab_resR_" ("_resRB_"%)"_vbTab_resS_" ("_resSB_"%)"_vbTab_resI_" ("_resIB_"%)"
  ..S Data=$lb(Num,bName,antName,resR,resS,resI)
  ..D Output
  K ^TMP($zn,$j) 
  Q 
 
Output
	S Data=$lb(Num,bName,antName,resR,resS,resI)
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
/// D ##class(%ResultSet).RunQuery("web.DHCMicStatAntIsolate","QuerySampleStatistics","2014-04-01","2014-10-24",0)
Query QuerySampleStatistics(DateS As %String, DateE As %String, Type As %String) As %Query(ROWSPEC = "Num:%String,bName:%String,antName:%String,resR:%String,resS:%String,resI:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCMicStatAntIsolateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCMicStatAntIsolateD</DataLocation>
<DefaultData>DHCMicStatAntIsolateDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCMicStatAntIsolateD</IdLocation>
<IndexLocation>^web.DHCMicStatAntIsolateI</IndexLocation>
<StreamLocation>^web.DHCMicStatAntIsolateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
