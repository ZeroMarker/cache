Class web.DHCWLXG.XGReports Extends %RegisteredObject
{

// 新冠监测阳性接口(每个项目提供的接口可能不一致，单独提出)

ClassMethod GetXGKYFlagByOeori(oeori, flag)
{
	q ##class(LabService.TSResult).GetSCodeResultByOrderId(oeori,"2019-nCoV")
}

// 新冠监测阳性接口(每个项目提供的接口可能不一致，单独提出)  //1：阳性 0：阴性  3：没有做核酸检测

ClassMethod GetXGKYFlagByAdm(admId)
{
	s kyFlag="3",swFlag=0
	s oeMainId=0 f  s oeMainId=$o(^OEORD(0,"Adm",admId,oeMainId)) q:oeMainId=""  d
	.s oeSubId=0 f  s oeSubId=$o(^OEORD(oeMainId,"I",oeSubId)) q:oeSubId=""  d
	..s arcimDr=$p(^OEORD(oeMainId,"I",oeSubId,1),"^",2)
	..s arcimDesc=$$GetARCIMName^DHCWLBuildDimDataARCIM(arcimDr)
	..i arcimDesc["死亡" s swFlag=1
	..q:arcimDesc'["新冠肺炎核酸检测"
	..s oeori=oeMainId_"||"_oeSubId
	..s kyFlag=##class(LabService.TSResult).GetSCodeResultByOrderId(oeori,"2019-nCoV")   //1：阳性 0：阴性
	q kyFlag_"^"_swFlag
}

// w ##class(web.DHCWLXG.XGReports).GetWeek($zdh("2023-01-10",3))

ClassMethod GetWeek(date)
{
	s dateDesc=$zd(date,3)
	s year=$p(dateDesc,"-",1)
	s yearFirstDay=year_"-01-01"
	s yearFirstDayM=$zdh(yearFirstDay,3)
	s days=date-yearFirstDayM+1
	s weekNum=days/7
	s weekNum=$p(weekNum,".",1)+1
	q "第"_weekNum_"周"
}

// 获取患者的所有诊断

ClassMethod GetAllDiagByAdm(admId)
{
	s ret=""
	q:$g(admId)="" "Null"
 	q:'$d(^PAADM(admId)) "Null"
 	s admMainDR=$p(^PAADM(admId),"^",61)
 	q:$g(admMainDR)="" "Null"
 	q:'$d(^MR(admMainDR,"DIA")) "Null"

 	s mrdiaSub=0 f  s mrdiaSub=$o(^MR(admMainDR,"DIA",mrdiaSub)) q:(mrdiaSub="")  d
 	.s typSub=0  f  s typSub=$o(^MR(admMainDR,"DIA",mrdiaSub,"TYP",typSub)) q:typSub=""  d
 	..s typDiagDr=$p(^MR(admMainDR,"DIA",mrdiaSub,"TYP",typSub),"^")
 	..q:typDiagDr=""
 	..s dtypCode=$p(^MRC("DTYP",typDiagDr),"^")

 	..s mrdiaIcdCode=$p(^MR(admMainDR,"DIA",mrdiaSub),"^")
 	..s reMark=$g(^MR(admMainDR,"DIA",mrdiaSub,"DES",1))
 	..i mrdiaIcdCode'=""  d
 	...i $d(^MRC("ID",mrdiaIcdCode))  d
 	....s mrcidDesc=$p($g(^MRC("ID",mrdiaIcdCode)),"^",2)
 	..e  s mrcidDesc=reMark
 	..i ret="" s ret=mrcidDesc
 	..e  s ret=ret_"^"_mrcidDesc
 	q $g(ret)
}

ClassMethod GetICUFlag(admId)
{
	s icuFlag=0
	s tranId=0 f  s tranId=$o(^PAADM(admId,"TRANS",tranId)) q:tranId=""  d
	.s locId=$p(^PAADM(admId,"TRANS",tranId),"^",6)	
	.s locDesc=$p(^CTLOC(locId),"^",2)
	.i locDesc["ICU" s icuFlag=1
	.e  s icuFlag=0
	q icuFlag
}

/// 	门急诊ILI病例每日新冠检测情况统计表
/// Creator?      chenyi
/// CreatDate?    2023-01-10
/// d ##class(%ResultSet).RunQuery("web.DHCWLXG.XGReports","QueryMJZXGYXRS","2023-01-01","2023-01-10") 
Query QueryMJZXGYXRS(startDate As %String, endDate As %String, depId As %String) As %Query(ROWSPEC = "depDesc,week,dateDesc,kyFlag,nums0t5:%Float,nums5t15:%Float,nums15t50:%Float,nums50t65:%Float,nums65t:%Float") [ SqlProc ]
{
}

ClassMethod QueryMJZXGYXRSExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, depId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	s startDate=$zdh(startDate,3)
 	s endDate=$zdh(endDate,3)
 	
 	f date=startDate:1:endDate d
	.s admId=0 f  s admId=$o(^PAADMi("PAADM_AdmDate",date,admId)) q:admId=""  d
	..s admType=$p(^PAADM(admId),"^",2)
	..q:(admType="I")||(admType="H")
	..s kyFlag=..GetXGKYFlagByAdm(admId)
	..s kyFlag=$p(kyFlag,"^",1)
	..q:kyFlag'="3"  //没有新冠监测的不统计
	..s week=..GetWeek(date)
	..s dateDesc=$zd(date,3)
	..s papmi=$p(^PAADM(admId),"^",1)
	..s ageDesc=##class(web.DHCBillInterface).GetPapmiAge(papmi,admId)
	..i ageDesc["岁" s age=+ageDesc
	..i (ageDesc["天")||(ageDesc["周") s age=0
	..s nums0t5=0,nums5t15=0,nums15t50=0,nums50t65=0,nums65t=0
	..i age<5 s nums0t5=1
	..i (age>=5)&&(age<15) s nums5t15=1
	..i (age>=15)&&(age<50) s nums15t50=1
	..i (age>=50)&&(age<65) s nums50t65=1
	..i (age>=65) s nums65t=1
	..s depDr=$p(^PAADM(admId),"^",4)
	..s depDesc=$p(^CTLOC(depDr),"^",2)
	..s:depDesc["-" depDesc=$p(depDesc,"-",2)
	..d outputRow
  
	Quit $$$OK
	
outputRow
 s row=$listbuild(depDesc,week,dateDesc,kyFlag,nums0t5,nums5t15,nums15t50,nums50t65,nums65t)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod QueryMJZXGYXRSClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMJZXGYXRSExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod QueryMJZXGYXRSFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMJZXGYXRSExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 每日新入院病人数和SARI病例数统计表
/// Creator?      chenyi
/// CreatDate?    2023-01-10
/// d ##class(%ResultSet).RunQuery("web.DHCWLXG.XGReports","QueryZYXGYXRS","2023-01-01","2023-01-05") 
Query QueryZYXGYXRS(startDate As %String, endDate As %String, depId As %String) As %Query(ROWSPEC = "depDesc,week,dateDesc,SARIFlag,nums0t5:%Float,nums5t15:%Float,nums15t50:%Float,nums50t65:%Float,nums65t:%Float") [ SqlProc ]
{
}

ClassMethod QueryZYXGYXRSExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, depId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	k ^||TEMPDHCWL($J)
 	s startDate=$zdh(startDate,3)
 	s endDate=$zdh(endDate,3)
 	
 	f date=startDate:1:endDate d
	.s admId=0 f  s admId=$o(^PAADMi("PAADM_AdmDate",date,admId)) q:admId=""  d
	..s admType=$p(^PAADM(admId),"^",2)
	..q:(admType'="I")
	..s diag=..GetAllDiagByAdm(admId)
	..i (diag["急性咽喉炎")||(diag["急性支气管炎")||(diag["上呼吸道感染")||(diag["流感") s SARIFlag=1
	..e  s SARIFlag=0
	..s week=..GetWeek(date)
	..s dateDesc=$zd(date,3)
	..s papmi=$p(^PAADM(admId),"^",1)
	..s ageDesc=##class(web.DHCBillInterface).GetPapmiAge(papmi,admId)
	..i ageDesc["岁" s age=+ageDesc
	..i (ageDesc["天")||(ageDesc["周") s age=0
	..s nums0t5=0,nums5t15=0,nums15t50=0,nums50t65=0,nums65t=0
	..i age<5 s nums0t5=1
	..i (age>=5)&&(age<15) s nums5t15=1
	..i (age>=15)&&(age<50) s nums15t50=1
	..i (age>=50)&&(age<65) s nums50t65=1
	..i (age>=65) s nums65t=1
	..s depDr=$p(^PAADM(admId,"DHC"),"^",33)
	..s depDesc=$p(^CTLOC(depDr),"^",2)
	..s:depDesc["-" depDesc=$p(depDesc,"-",2)
	..d outputRow
  	
    k ^||TEMPDHCWL($j)
	Quit $$$OK
	
outputRow
 s row=$listbuild(depDesc,week,dateDesc,SARIFlag,nums0t5,nums5t15,nums15t50,nums50t65,nums65t)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod QueryZYXGYXRSClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryZYXGYXRSExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod QueryZYXGYXRSFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryZYXGYXRSExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 住院SARI病例每日新冠检测情况统计表
/// Creator?      chenyi
/// CreatDate?    2023-01-10
/// d ##class(%ResultSet).RunQuery("web.DHCWLXG.XGReports","QueryZYSARIXGYXRS","2023-01-01","2023-01-05") 
Query QueryZYSARIXGYXRS(startDate As %String, endDate As %String, depId As %String) As %Query(ROWSPEC = "depDesc,week,dateDesc,kyFlag,nums0t5:%Float,nums5t15:%Float,nums15t50:%Float,nums50t65:%Float,nums65t:%Float") [ SqlProc ]
{
}

ClassMethod QueryZYSARIXGYXRSExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, depId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	k ^||TEMPDHCWL($J)
 	s startDate=$zdh(startDate,3)
 	s endDate=$zdh(endDate,3)
 	
 	f date=startDate:1:endDate d
	.s admId=0 f  s admId=$o(^PAADMi("PAADM_AdmDate",date,admId)) q:admId=""  d
	..s admType=$p(^PAADM(admId),"^",2)
	..q:(admType'="I")
	..s diag=..GetAllDiagByAdm(admId)
	..i (diag["急性咽喉炎")||(diag["急性支气管炎")||(diag["上呼吸道感染")||(diag["流感") s SARIFlag=1
	..e  s SARIFlag=0
	..q:SARIFlag=0
	..s kyFlag=..GetXGKYFlagByAdm(admId)
	..s kyFlag=$p(kyFlag,"^",1)
	..q:kyFlag'="3"  //没有新冠监测的不统计
	..s week=..GetWeek(date)
	..s dateDesc=$zd(date,3)
	..s papmi=$p(^PAADM(admId),"^",1)
	..s ageDesc=##class(web.DHCBillInterface).GetPapmiAge(papmi,admId)
	..i ageDesc["岁" s age=+ageDesc
	..i (ageDesc["天")||(ageDesc["周") s age=0
	..s nums0t5=0,nums5t15=0,nums15t50=0,nums50t65=0,nums65t=0
	..i age<5 s nums0t5=1
	..i (age>=5)&&(age<15) s nums5t15=1
	..i (age>=15)&&(age<50) s nums15t50=1
	..i (age>=50)&&(age<65) s nums50t65=1
	..i (age>=65) s nums65t=1
	..s depDr=$p(^PAADM(admId,"DHC"),"^",33)
	..s depDesc=$p(^CTLOC(depDr),"^",2)
	..s:depDesc["-" depDesc=$p(depDesc,"-",2)
	..d outputRow
  	
    k ^||TEMPDHCWL($j)
	Quit $$$OK
	
outputRow
 s row=$listbuild(depDesc,week,dateDesc,kyFlag,nums0t5,nums5t15,nums15t50,nums50t65,nums65t)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod QueryZYSARIXGYXRSClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryZYSARIXGYXRSExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod QueryZYSARIXGYXRSFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryZYSARIXGYXRSExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 新冠检测阳性2的SARI病例中每日ICU新收治数、死亡情况统计表
/// Creator?      chenyi
/// CreatDate?    2023-01-10
/// d ##class(%ResultSet).RunQuery("web.DHCWLXG.XGReports","QueryICUAndSW","2019-02-27","2019-04-27") 
Query QueryICUAndSW(startDate As %String, endDate As %String, depId As %String) As %Query(ROWSPEC = "week,dateDesc,type,nums0t5:%Float,nums5t15:%Float,nums15t50:%Float,nums50t65:%Float,nums65t:%Float") [ SqlProc ]
{
}

ClassMethod QueryICUAndSWExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, depId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	k ^||TEMPDHCWL($J)
 	s startDate=$zdh(startDate,3)
 	s endDate=$zdh(endDate,3)
 	
 	//ICU
 	f date=startDate:1:endDate d
	.s admId=0 f  s admId=$o(^PAADMi("PAADM_AdmDate",date,admId)) q:admId=""  d
	..s admType=$p(^PAADM(admId),"^",2)
	..q:(admType'="I")
	..s diag=..GetAllDiagByAdm(admId)
	..i (diag["急性咽喉炎")||(diag["急性支气管炎")||(diag["上呼吸道感染")||(diag["流感") s SARIFlag=1
	..e  s SARIFlag=0
	..q:SARIFlag=0
	..s oeoriFlag=..GetXGKYFlagByAdm(admId)
	..s kyFlag=$p(oeoriFlag,"^",1)
	..q:kyFlag'=1
	..s icuFlag=..GetICUFlag(admId)
	..q:icuFlag'="1"  //没有去过icu的不统计
	..s type="ICU"
	..s week=..GetWeek(date)
	..s dateDesc=$zd(date,3)
	..s papmi=$p(^PAADM(admId),"^",1)
	..s ageDesc=##class(web.DHCBillInterface).GetPapmiAge(papmi,admId)
	..i ageDesc["岁" s age=+ageDesc
	..i (ageDesc["天")||(ageDesc["周") s age=0
	..s nums0t5=0,nums5t15=0,nums15t50=0,nums50t65=0,nums65t=0
	..i age<5 s nums0t5=1
	..i (age>=5)&&(age<15) s nums5t15=1
	..i (age>=15)&&(age<50) s nums15t50=1
	..i (age>=50)&&(age<65) s nums50t65=1
	..i (age>=65) s nums65t=1
	..d outputRow
	
	//死亡
	f date=startDate:1:endDate d
	.s admId=0 f  s admId=$o(^PAADMi("DischargeDateExt",date,admId)) q:admId=""  d
	..s admType=$p(^PAADM(admId),"^",2)
	..q:(admType'="I")
	..s diag=..GetAllDiagByAdm(admId)
	..i (diag["急性咽喉炎")||(diag["急性支气管炎")||(diag["上呼吸道感染")||(diag["流感") s SARIFlag=1
	..e  s SARIFlag=0
	..q:SARIFlag=0
	..s oeoriFlag=..GetXGKYFlagByAdm(admId)
	..s kyFlag=$p(oeoriFlag,"^",1)
	..q:kyFlag'=1
	..s swFlag=$p(oeoriFlag,"^",2)
	..q:swFlag'="1"  //没有去过icu的不统计
	..s type="SW"
	..s week=..GetWeek(date)
	..s dateDesc=$zd(date,3)
	..s papmi=$p(^PAADM(admId),"^",1)
	..s ageDesc=##class(web.DHCBillInterface).GetPapmiAge(papmi,admId)
	..i ageDesc["岁" s age=+ageDesc
	..i (ageDesc["天")||(ageDesc["周") s age=0
	..s nums0t5=0,nums5t15=0,nums15t50=0,nums50t65=0,nums65t=0
	..i age<5 s nums0t5=1
	..i (age>=5)&&(age<15) s nums5t15=1
	..i (age>=15)&&(age<50) s nums15t50=1
	..i (age>=50)&&(age<65) s nums50t65=1
	..i (age>=65) s nums65t=1
	..d outputRow
  	
    k ^||TEMPDHCWL($j)
	Quit $$$OK
	
outputRow
 s row=$listbuild(week,dateDesc,type,nums0t5,nums5t15,nums15t50,nums50t65,nums65t)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod QueryICUAndSWClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryICUAndSWExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod QueryICUAndSWFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryICUAndSWExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
