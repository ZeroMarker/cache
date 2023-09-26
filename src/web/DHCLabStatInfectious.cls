Class web.DHCLabStatInfectious Extends %Persistent
{

/// 传染病结果查询
Parameter BUILD = 60;

ClassMethod QuerySampleStatisticsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySampleStatisticsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Q $$$OK
}

/// Query的执行方法
/// D ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// D ##class(%ResultSet).RunQuery("web.DHCLabStatInfectious","QuerySampleStatistics","2013-04-01","2013-05-15","","","","","","")
ClassMethod QuerySampleStatisticsExecute(ByRef qHandle As %Binary, DateS As %String, DateE As %String, Labno As %String, Debtor As %String, HospNo As %String, DepCode As %String, PatName As %String, MachCode As %String, PatType As %String, USERCODE As %String) As %Status
{
 S repid=$I(^CacheTemp)
 I $G(ind)="" S ind=1
 S sLabNameSpace="LABDATA"	
 S sMedNameSpace="DHC-DATA"	
 S sAppNameSpace="DHC-APP"
 I '$L(sLabNameSpace) S sLabNameSpace="LABDATA"
 I '$L(sMedNameSpace) S sMedNameSpace="LABDATA"
 I '$L(sAppNameSpace) S sAppNameSpace="DHC-APP"
 S HospCode=$O(^TTABi("CC",1,""))
 S Labno=$G(Labno),DateS=$G(DateS),DateE=$G(DateE),Debtor=$G(Debtor),HospNo=$G(HospNo)
 S DepCode=$G(DepCode),PatName=$G(PatName),PatType=$G(PatType),MachCode=$G(MachCode)
 S ^TMP("Para")=DateS_","_DateE_","_Labno_","_Debtor_","_HospNo_","_DepCode_","_PatName_","_PatType_","_MachCode
 S USERCODE=$G(USERCODE)
 I '$L(USERCODE) S USERCODE="demo"
 //S USERCODE=70251
 S UserDep=""
 I '$L(USERCODE)   Set qHandle=$lb(0,repid,0) Quit $$$OK
 S dep="" F  S dep=$o(^TTAB("UA",USERCODE,4,dep)) Q:dep=""  D
 .S UserDep=UserDep_dep
 ;ResultStat(DateS,DateE,TestCode,Opertion，QueryResult，TCListAnd,DepCode,flag,CliDepCode,WardCode)
 ;S TCListOr="^M0480|乙肝表面抗原\[\阳性\Or"
 ;S TCListOr="^A0020|红细胞计数\>\11\Or"
 S DateS=$zdh(DateS,3),DateE=$zdh(DateE,3),TCListOr=$G(TCListOr),DepCode=$G(DepCode),flag=$G(flag)
 S CliDepCode=$G(CliDepCode),WardCode=$G(WardCode)
 k ^TMP($zn,$j)
 S itmstr1="",j=0
 F i=2:1:$L(TCListOr,"^") D
 .S ItemList=$P(TCListOr,"^",i)
 .S TestCode=$P($P(ItemList,"\",1),"|",1)
 .S Opertion=$P(ItemList,"\",2)
 .I Opertion="<>" S Opertion="'="
 .S QueryResult=$P(ItemList,"\",3)
 .S itmstr1=itmstr1_TestCode_","
 .S j=j+1
 .S OR(j)=TestCode_"^"_Opertion_"^"_QueryResult
 S itmstr2="",j=0
 F i=2:1:$L(TCListAnd,"^") D
 .S ItemList=$P(TCListAnd,"^",i)
 .S TestCode=$P($P(ItemList,"\",1),"|",1)
 .S Opertion=$P(ItemList,"\",2)
 .I Opertion="<>" S Opertion="'="
 .S QueryResult=$P(ItemList,"\",3)
 .S itmstr2=itmstr2_TestCode_","
 .S j=j+1 
 .S AND(j)=TestCode_"^"_Opertion_"^"_QueryResult
 D stat(DateS,DateE,itmstr1,itmstr2)
 S Debort="" F  S Debort=$O(^TMP($zn,$j,"DEBORT",Debort)) Q:Debort=""  D
 .S r=0
 .S j="" F  S j=$O(AND(j)) Q:(j="")!(r=1)  D
 ..S tc=$P(AND(j),"^",1)
 ..I '$D(^TMP($zn,$j,"DEBORT",Debort,tc)) S r=1 Q
 ..S temres=$P(^TMP($zn,$j,"DEBORT",Debort,tc),"^",5)
 ..S TCLIST(tc)=$TR($TR(temres,$c(13,10)),"<>") //20091222去掉<>
 .S j="" F  S j=$O(OR(j)) Q:(j="")  D
 ..S tc=$P(OR(j),"^",1)
 ..I '$D(^TMP($zn,$j,"DEBORT",Debort,tc)) S r=1 Q
 ..S temres=$P(^TMP($zn,$j,"DEBORT",Debort,tc),"^",5)
 ..S TCLIST(tc)=$TR($TR(temres,$c(13,10)),"<>") //20091222去掉<>
 .I r=1 k ^TMP($zn,$j,"DEBORT",Debort) Q
 .S r=$$compare()
 .I r=1 k ^TMP($zn,$j,"DEBORT",Debort)
 ;处理数据
 S k=0
 S Debort="" F  S Debort=$O(^TMP($zn,$j,"DEBORT",Debort)) Q:Debort=""  D
 .S tc="" F  S tc=$O(^TMP($zn,$j,"DEBORT",Debort,tc)) Q:tc=""  D
 ..S k=k+1
 ..S ^TMP($zn,$j,"DATA",k)=$G(^TMP($zn,$j,"DEBORT",Debort,tc))
 ..D Output
 ..S Data=$lb(TSRowID,DebtorNumber,Name,SpeciesName,Age,VisitNumber,TestSetName,specmen,TransMemo,AuditDate,AuditTime,ReadFlag,Doctor,DocDate,OrderId,patloc,bed,authusr,episode)
 Q k
 
compare() ;(TCLIST,AND,OR)
 S ret=0
 ;b 300
 S j="" F  S j=$O(AND(j)) Q:(j="")!(ret=1)  D
 .S tc=$P(AND(j),"^",1)
 .I '$D(TCLIST(tc)) S ret=1 Q
 .S err=0
 .I $P(AND(j),"^",2)["-" D
 ..S QueryRes1=$P($P(AND(j),"^",3),"-",1)
 ..S QueryRes2=$P($P(AND(j),"^",3),"-",2)
 ..I $P(AND(j),"^",2)="-" S formula="S err=("""_TCLIST(tc)_""""_">="_""""_QueryRes1_""""_")&("_""""_TCLIST(tc)_""""_"<="_""""_QueryRes2_""")"
 ..E  S formula="S err=("""_TCLIST(tc)_""""_"<"_""""_QueryRes1_""""_")!("_""""_TCLIST(tc)_""""_">"_""""_QueryRes2_""")"
 .E  S formula="S err="""_TCLIST(tc)_""""_$P(AND(j),"^",2)_""""_$P(AND(j),"^",3)_""""
 .X formula
 .I 'err S ret=1 Q
 Q:ret ret
 S ORformula=""
 S j="" F  S j=$O(OR(j)) Q:(j="")!(ret=1)  D
 .S tc=$P(OR(j),"^",1)
 .I '$D(TCLIST(tc)) S ret=1 Q
 .S err=0
 .I $P(OR(j),"^",2)["-" D
 ..S QueryRes1=$P($P(OR(j),"^",3),"-",1)
 ..S QueryRes2=$P($P(OR(j),"^",3),"-",2)
 ..I $P(OR(j),"^",2)="-" S formula="S err=("""_TCLIST(tc)_""""_">="_""""_QueryRes1_""""_")&("_""""_TCLIST(tc)_""""_"<="_""""_QueryRes2_""")"
 ..E  S formula="S err=("""_TCLIST(tc)_""""_"<"_""""_QueryRes1_""""_")!("_""""_TCLIST(tc)_""""_">"_""""_QueryRes2_""")"
 .E  S formula="S err="""_TCLIST(tc)_""""_$P(OR(j),"^",2)_""""_$P(OR(j),"^",3)_""""
 .X formula
 .S ORformula=ORformula_"!"_err
 Q:ret ret
 S ORformula=$P(ORformula,"!",2,$L(ORformula,"!"))
 I $L(ORformula) S ORformula="S ret='("_ORformula_")"
 X ORformula
 Q ret 
stat(DateS,DateE,itmstr1,itmstr2)
 K ^TMP($zn,$j)
 S itmstr=itmstr1_itmstr2
 F dd=DateS:1:DateE D
 .S labno="" F  S labno=$O(^TEPIi("AUTHORISED",dd,labno)) Q:labno=""  D
 ..S ts="" F  S ts=$O(^TEPI(labno,1,ts)) Q:ts=""  D
 ...S tscnt="" F  S tscnt=$O(^TEPI(labno,1,ts,tscnt)) Q:tscnt=""  D
 ....S TestCode="" F  S TestCode=$O(^TEPI(labno,1,ts,tscnt,"DATA",TestCode)) Q:TestCode=""  D
 .....I itmstr'[TestCode Q
 .....S type=$P(^TTAB("TC",TestCode),"\",3)
 .....S VisitNumber=labno,TestSetDR=ts
 .....S ResComm=""
 .....S resu=$$GetResult(VisitNumber,TestSetDR,tscnt,TestCode,type)
 .....S Result=$P(resu,"||",1)
 .....S ResComm=$P(resu,"||",2)
 .....S Debort=$P(^TEPI(VisitNumber),"\",18)
 .....S ranges=""
 .....S SpecDr=$P(^TEPI(VisitNumber),"\",3)
 .....///修改年龄显示20091222
 .....//S age=$P(^TEPI(VisitNumber),"\",25)
 .....S Age=##class(web.DHCLabCommonUse).GetPatAge(VisitNumber)
 .....S Age=##class(web.DHCLabCommonUse).AgeOut(Age) 
 .....///
 .....I type["N" D
 ......ZN sLabNameSpace
 ......S ran=$$ranges^LVBVIS1(TestCode,age,SpecDr,"","0","","")
 ......ZN sAppNameSpace
 ......S ranges="("_$P(ran,$c(1),1)_"-"_$P(ran,$c(1),2)_")"
 .....S SpecName=""
 .....I SpecDr'="" S SpecName=$P(^TTAB("SP",SpecDr),"\",1)
 .....S SurName=$P(^TEPI(VisitNumber),"\",1)
 .....;临床科室
 .....S CliDepartCode=$P(^TEPI(VisitNumber),"\",36)
 .....I $L(CliDepCode),CliDepCode'=CliDepartCode Q
 .....S CliDeppartName=""
 .....I CliDepartCode'="" S CliDeppartName=$P(^TTAB("USLOC",CliDepartCode),"\",1)
 .....I CliDeppartName["-" S CliDeppartName=$P(CliDeppartName,"-",2)
 .....;病区20070522
 .....S patWardname=""
 .....S tempatwarddr=$P(^TEPI(VisitNumber),"\",20)
 .....I $L(WardCode),WardCode'=tempatwarddr Q
 .....I $L(tempatwarddr),$D(^TTAB("RH",tempatwarddr)) S patWardname=$P(^TTAB("RH",tempatwarddr),"\",1)
 .....I patWardname['"-" S patWardname=$P(patWardname,"-",2)
 .....S Depname=$P(^TTAB("DEP",$E(TestSetDR,1,1)),"\",1)
 .....S TestSetName=$P(^TTAB("TS",TestSetDR),"\",1)
 .....S TestCodeName=$TR($P(^TTAB("TC",TestCode),"\",1)," ")
 .....///审核日期改为核收日期20091222
 .....S RecDate=$P(^TEPI(VisitNumber,1,TestSetDR,tscnt),"\",21)
 .....I $L(RecDate) S RecDate=$zd(RecDate,3)
 .....///
 .....S str1=RecDate_"^"_VisitNumber_"^"_TestSetName_"^"_TestCodeName_"^"_Result_"^"_ranges
 .....S str2=Debort_"^"_SurName_"^"_SpecName_"^"_age_"^"_Depname_"^"_CliDeppartName_"^"_patWardname_"^"_ResComm_"^"     ;_VisitNumber_"||"_TestSetDR_"||"_tscnt
 .....;医嘱备注
 .....S memo=""
 .....S Episode=$P(^TEPI(VisitNumber,1,TestSetDR,tscnt),"\",12)
 .....S ^TMP($zn,$j,"DEBORT",Debort,TestCode)=str1_"^"_str2_"^"_memo_"^"_Episode
 Q 0
GetResult(VisitNumber,TestSetDR,TestSetCounter,TestCode,type)
 S VisitNumber=$G(VisitNumber),TestSetDR=$G(TestSetDR),TestSetCounter=$G(TestSetCounter),TestCode=$G(TestCode),type=$G(type)
 S Res="",Comm=""
 I (type["N")!(type="X")!(type="V") D
 .I $D(^TEPI(VisitNumber,1,TestSetDR,TestSetCounter,"DATA",TestCode)) D
 ..S Res=$P(^TEPI(VisitNumber,1,TestSetDR,TestSetCounter,"DATA",TestCode),"\",1)
 I type="S" D
 .I $D(^TEPI(VisitNumber,1,TestSetDR,TestSetCounter,"DATA",TestCode)) D 
 ..S Comm=$P(^TEPI(VisitNumber,1,TestSetDR,TestSetCounter,"DATA",TestCode),"\",1)
 ..S Res=Comm
 ..I $D(^TTAB("TC",TestCode,2,Comm,0)) D 
 ...S Res=^TTAB("TC",TestCode,2,Comm,^TTAB("TC",TestCode,2,Comm,0))
 I type="B2" D
 .I '$D(^TEPI(VisitNumber,1,TestSetDR,TestSetCounter,"DATA",TestCode)) Q
 .S Comm=$P(^TEPI(VisitNumber,1,TestSetDR,TestSetCounter,"DATA",TestCode),"\",1)
 .S Res=Comm
 .I $D(^TTAB("BB-BG",Res)) S Res=$P(^TTAB("BB-BG",Res),"\",1)
 Q Res_"||"_Comm 
Output
 S Data=$lb(TSRowID,DebtorNumber,Name,SpeciesName,Age,VisitNumber,TestSetName,specmen,TransMemo,AuditDate,AuditTime,ReadFlag,Doctor,DocDate,OrderId,patloc,bed,authusr,episode)
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
 	S qHandle=$Lb(AtEnd,repid,ind)
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
/// D ##class(%ResultSet).RunQuery("web.DHCLabStatInfectious","QuerySampleStatistics","2014-09-28","2014-09-28","","","","","","","")
Query QuerySampleStatistics(DateS As %String, DateE As %String, Labno As %String, Debtor As %String, HospNo As %String, DepCode As %String, PatName As %String, MachCode As %String, PatType As %String, USERCODE As %String) As %Query(ROWSPEC = "TSRowID:%String,DebtorNumber:%String,Name:%String,SpeciesName:%String,Age:%String,VisitNumber:%String,TestSetName:%String,specmen:%String,TransMemo:%String,AuditDate:%String,AuditTime:%String,ReadFlag:%String,Doctor:%String,DocDate:%String,OrderId:%String,patloc:%String,bed:%String,authusr:%String,episode:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCLabStatInfectiousDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCLabStatInfectiousD</DataLocation>
<DefaultData>DHCLabStatInfectiousDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCLabStatInfectiousD</IdLocation>
<IndexLocation>^web.DHCLabStatInfectiousI</IndexLocation>
<StreamLocation>^web.DHCLabStatInfectiousS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
