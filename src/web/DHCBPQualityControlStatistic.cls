/// 血透质控指标统计
Class web.DHCBPQualityControlStatistic Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("web.DHCBPQualityControlStatistic","FindBPQualityControlStat","2022-10-01","2022-10-31","NEP-D-13","")
Query FindBPQualityControlStat(startDate As %String, endDate As %String, CountId As %String, dataTitle As %String, deptID As %String) As %Query(ROWSPEC = "SeqNo,Title,Count,Total,JobCode,Rate")
{
}

ClassMethod FindBPQualityControlStatExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, CountId As %String, dataTitle As %String, deptID As %String) As %Status
{
	set repid=$i(^CacheTemp)
	if $g(ind)="" set ind=1
	k ^TMPBPQuality(CountId,$j)
	set fromDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	set toDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	
	if ((CountId="")||(fromDate>toDate))
	{
		set qHandle=$lb(0,repid,0)
		quit $$$OK
	}
	set QualityControlPara=##class(web.DHCBPQualityControlStatistic).GetQualityControlPara(CountId)
	
	set needBpprStatus =$p(QualityControlPara,"&",1), patType=$p(QualityControlPara,"&",2), LabTestCode=$p(QualityControlPara,"&",3), isAll=$p(QualityControlPara,"&",4), timeType=$p(QualityControlPara,"&",5), maxValue=$p(QualityControlPara,"&",6), minValue=$p(QualityControlPara,"&",7), specialLab=$p(QualityControlPara,"&",8)
	set totalPat="",patnamestr="",countPat="",papmiIdList="",bpprIdList="",bpprId="",sort=0,totalSort=0
	set Title=CountId
	b
	if 'isAll   
	{
	  if needBpprStatus="D" do
	  .for  set bpprId=$o(^DHCBPPatRegister(0,"Status",needBpprStatus,bpprId)) quit:bpprId=""  do
	  ..set itemstr=""
	  ..do GetRegister()
	  else  do
	  .for curDate=toDate:-1:fromDate do
	  ..set bpprId=""
	  ..for  set bpprId=$o(^DHCBPPatRegister(0,"Date",curDate,bpprId),-1) quit:bpprId=""  do
	  ...set itemstr=""
	  ...do GetRegister()
	}
	else  
	{
	   set bpprId=""
	   for  set bpprId=$o(^DHCBPPatRegister(bpprId),-1) quit:(bpprId="")!(bpprId=0)  do
	   .set itemstr=""
	   .do GetRegister()
	}
	
	set Rate="0.00%"
	if (+totalPat>0) set Rate=$fn(countPat/totalPat*100, "", 2)_"%"
	if (countPat="")&&(totalPat="") set Rate=""
	b
	do OutputRow171
	
	Set qHandle=$lb(0,repid,0)	
	Quit $$$OK
GetRegister()
	set ret =0
	quit:bpprId="" 0
	set papmiId=$lg(^DHCBPPatRegister(bpprId),1)
	quit:papmiId="" 0
	quit:'$d(^PAPER(papmiId,"PAT",1)) 0
	quit:$lg(^DHCBPPatRegister(bpprId),34)'=deptID 0
	
	set regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	
	set bpprStatus=$lg(^DHCBPPatRegister(bpprId),14)
	quit:bpprStatus="" 0
	//w needBpprStatus_"/"_bpprStatus
	quit:(needBpprStatus'="")&&(needBpprStatus'[bpprStatus) 0
	set PatBPNo=$lg(^DHCBPPatRegister(bpprId),17)
	set patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	set patBirth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	set patSex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	set bpprPatType=$lg(^DHCBPPatRegister(bpprId),25)
	quit:(bpprPatType'=patType)&(patType'="") 0
	if bpprPatType="N" set bpprPatType="常规"
	if bpprPatType="T" set bpprPatType="临时"
	set totalPat=totalPat+1
	if specialLab'="" do
	.if specialLab=5 set ret=##class(web.DHCBPQualityControlStatistic).FitHBVLabValue(fromDate,toDate,regNo,LabTestCode)
	.if specialLab=9 set ret=##class(web.DHCBPQualityControlStatistic).FitBPItem(fromDate,toDate,bpprId,"Weight")
	.if specialLab=10 set ret=##class(web.DHCBPQualityControlStatistic).FitBPItem(fromDate,toDate,bpprId,"VascularAccess")
	.if specialLab=19 set ret=##class(web.DHCBPQualityControlStatistic).FitBPItem(fromDate,toDate,bpprId,"BloodPressure")
	.if specialLab=21 set ret=##class(web.DHCBPQualityControlStatistic).FitCKDMBDLabValue(fromDate,toDate,regNo,LabTestCode)
	else  set ret=##class(web.DHCBPQualityControlStatistic).FitLabValue(fromDate,toDate,regNo,LabTestCode,maxValue,minValue)
	set itemstr=$p(ret,"@",2)
	set countPat=countPat+$p(ret,"@",1)
	if ($p(ret,"@",1)){
		set sort=sort+1
	  	set ^TMPBPQuality(CountId,$j,"Count",sort,bpprId)=$lb(sort,PatBPNo,patName,regNo,patSex,bpprPatType,itemstr)
	}
	set totalSort=totalSort+1
	set ^TMPBPQuality(CountId,$j,"Total",totalSort,bpprId)=$lb(totalSort,PatBPNo,patName,regNo,patSex,bpprPatType,itemstr)
	quit
	
OutputRow171
	set ^CacheTemp(repid,ind)=$lb(1,Title,countPat,totalPat,$j,Rate)
	set ind=ind+1
	quit
}

ClassMethod FindBPQualityControlStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUQualityControlStatExecute ]
{
	s AtEnd=$li(qHandle,1)
	s repid=$li(qHandle,2)
	s ind=$li(qHandle,3)
	//
	s ind=$o(^CacheTemp(repid,ind))
	i ind="" {				// if there are no more rows, finish fetching
	s AtEnd=1
	s Row=""
	}
	else      {				// fetch row
	s Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindBPQualityControlStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUQualityControlStatExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCBPQualityControlStatistic","FindBPStatPatInfo","4636","AllPatientCount")
Query FindBPStatPatInfo(statCode As %String, JobId As %String, CountId As %String) As %Query(ROWSPEC = "totalSort,PatBPNo,patName,regNo,patSex,bpprPatType,itemstr")
{
}

ClassMethod FindBPStatPatInfoExecute(ByRef qHandle As %Binary, statCode As %String, JobId As %String, CountId As %String) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1

	if ((statCode="")||(JobId="")||(CountId=""))
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK
	}
	
	set sort="" for  set sort=$o(^TMPBPQuality(CountId,JobId,statCode,sort)) quit:sort=""  do
	.set bpprId="" for  set bpprId=$o(^TMPBPQuality(CountId,JobId,statCode,sort,bpprId)) quit:bpprId=""  do
	..do OutputRow

	s qHandle=$lb(0,repid,0)
	q $$$OK
	
OutputRow
	s Data=^TMPBPQuality(CountId,JobId,statCode,sort,bpprId)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindBPStatPatInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUStatPatInfoExecute ]
{
	s AtEnd=$li(qHandle,1)
	s repid=$li(qHandle,2)
	s ind=$li(qHandle,3)
	//
	s ind=$o(^CacheTemp(repid,ind))
	i ind="" {				// if there are no more rows, finish fetching
	s AtEnd=1
	s Row=""
	}
	else      {				// fetch row
	s Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindBPStatPatInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUStatPatInfoExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// 指标3 LabTestCode 217^251^340^250^244^197^245^246^247^248 isAll 0
/// w ##class(web.DHCBPQualityControl).GetQualityInfo("2021-01-01","2021-10-18","N","","217^251^340^250^244^197^245^246^247^248",0,"","","")
/// 指标4 LabTestCode(检验项目) 217^251^340^250^244^197^245^246^247^248 isAll(是否同期患者) 1  timeType(时间段) 6
/// w ##class(web.DHCBPQualityControl).GetQualityInfo("2021-01-01","2021-10-18","N","","217^251^340^250^244^197^245^246^247^248",1,"6","","")
/// d ##class(%ResultSet).RunQuery("web.DHCBPQualityControl","GetQualityInfo","2021-01-01","2021-10-18","N","","217^251^340^250^244^197^245^246^247^248",1,"6","","")
/// 指标5 LabTestCode "248^244" isAll 1 timeType 12 specialLab(特殊统计内容) 5
/// d ##class(%ResultSet).RunQuery("web.DHCBPQualityControl","GetQualityInfo","2021-01-01","2021-10-18","N","","248^244",1,12,"","",5)
/// 指标8 LabTestCode 300 isAll 1 timeType 6
/// 指标9 LabTestCode "" isAll 1 specialLab(特殊统计内容) 9
/// w ##class(web.DHCBPQualityControl).GetQualityInfo("2021-01-01","2021-10-18","N","","",1,"","","",9)
/// 指标10 LabTestCode "" isAll 1 specialLab(特殊统计内容) 10
/// d ##class(%ResultSet).RunQuery("web.DHCBPQualityControl","GetQualityInfo","2021/11/8","2021/11/8","N","","","1","","","","10")
/// w ##class(web.DHCBPQualityControl).GetQualityInfo("2021-01-01","2021-10-18","N","","",1,"","","",10)
/// 指标13 LabTestCode 14^17^30^31^20^102^53^54^55 isAll 1 timeType 3
/// 指标14 LabTestCode 89^90^91^93^98^102^104^105^113^114^116 isAll 1 timeType 3
/// 指标15 LabTestCode 317 isAll 1 timeType 6
/// 指标16 LabTestCode 160^425 isAll 1 timeType 6
/// 指标17 LabTestCode 389 isAll 1 timeType 6
/// 指标18 LabTestCode 78^126^572 isAll 1 timeType 6
/// 指标19 LabTestCode "" isAll 1 specialLab(特殊统计内容) 19
/// w ##class(web.DHCBPQualityControl).GetQualityInfo("2021-01-01","2021-10-18","N","","",1,"","","",19)
/// 指标20 LabTestCode 30^218^218^219^220^221^222^223^309 isAll 1 timeType "" minValue 110
/// 指标21 LabTestCode "97^115^317" isAll 1 specialLab(特殊统计内容) 21
/// w ##class(web.DHCBPQualityControl).GetQualityInfo("2021-01-01","2021-10-18","N","","97^115^317",1,,"","",21)
/// 指标22 LabTestCode 389 isAll 1 timeType "" minValue 35
/// w ##class(web.DHCBPQualityControlStatistic).GetQualityControlPara("NEP-D-08")
/// 获取质控代码对应的过滤条件
ClassMethod GetQualityControlPara(CountId As %String) As %String
{
	quit:CountId="" ""
	set rest=""
	//needBpprStatus, patType, LabTestCode, isAll, timeType, maxValue, minValue, specialLab
	set rest=$CASE(CountId,
     	"NEP-D-03":"N"_"&"_""_"&"_"HBSAG^HCVAB^TPAB^HBsAb^HBCAB^HBSAG^HBSAB^HBEAG^HBcAb^HBEAB^HIVAB"_"&"_"0"_"&"_""_"&"_""_"&"_""_"&"_"",
     	"NEP-D-04":"N"_"&"_""_"&"_"HBSAG^HCVAB^TPAB^HBsAb^HBCAB^HBSAG^HBSAB^HBEAG^HBcAb^HBEAB^HIVAB"_"&"_"1"_"&"_"6"_"&"_""_"&"_""_"&"_"",
     	"NEP-D-05":"N"_"&"_""_"&"_"HCVAB^HBSAG"_"&"_"1"_"&"_"12"_"&"_""_"&"_""_"&"_"5",
     	"NEP-D-08":"N"_"&"_""_"&"_"β2MG"_"&"_"1"_"&"_"6"_"&"_""_"&"_""_"&"_"",
     	"NEP-D-09":"N"_"&"_""_"&"_""_"&"_"1"_"&"_""_"&"_""_"&"_""_"&"_"9",
     	"NEP-D-10":"N"_"&"_""_"&"_""_"&"_"1"_"&"_""_"&"_""_"&"_""_"&"_"10",
     	"NEP-D-13":"N"_"&"_""_"&"_"WBC^HCT^HGB^THb^HCT^LEU^RBC^MCHC^MCV^MCH^PLT"_"&"_"1"_"&"_"3"_"&"_""_"&"_""_"&"_"",
     	"NEP-D-14":"N"_"&"_""_"&"_"Malb^ALP^ALB^LDH^TG^CR^Cr^PA"_"&"_"1"_"&"_"3"_"&"_""_"&"_""_"&"_"",
     	"NEP-D-15":"N"_"&"_""_"&"_"PTH"_"&"_"1"_"&"_"6"_"&"_""_"&"_""_"&"_"",
     	"NEP-D-16":"N"_"&"_""_"&"_"FER^TRF"_"&"_"1"_"&"_"6"_"&"_""_"&"_""_"&"_"",
     	"NEP-D-17":"N"_"&"_""_"&"_"ALB^PA^Malb"_"&"_"1"_"&"_"6"_"&"_""_"&"_""_"&"_"",
     	"NEP-D-18":"N"_"&"_""_"&"_"CRP"_"&"_"1"_"&"_"6"_"&"_""_"&"_""_"&"_"",
     	"NEP-D-19":"N"_"&"_""_"&"_""_"&"_"1"_"&"_""_"&"_""_"&"_""_"&"_"19",
     	"NEP-D-20":"N"_"&"_""_"&"_"HGB"_"&"_"1"_"&"_""_"&"_""_"&"_"110"_"&"_"",
     	"NEP-D-21":"N"_"&"_""_"&"_"CA^P^PTH"_"&"_"1"_"&"_""_"&"_""_"&"_""_"&"_"21",
     	"NEP-D-22":"N"_"&"_""_"&"_"ALB^PA^Malb"_"&"_"1"_"&"_""_"&"_""_"&"_"35"_"&"_"",
     	:""
     )
	q rest
}

/// 获取检验信息
ClassMethod GetLabValue(icuaId As %String, standardCode As %String, fromDate As %String, fromTime As %String, toDate As %String, toTime As %String, type As %String = "")
{
	set EpisodeID=$p($g(^DHCICUArrange(+icuaId)),"^",1)
	quit:EpisodeID="" ""
	
	set ifSingle=0
	if type="First" set ifSingle=1
	
	set result=##class(web.DHCClinicCom).GetTestResult(EpisodeID,"","",standardCode,fromDate,fromTime,toDate,toTime,ifSingle)
	
	quit:type="First" $p(result,"\",1)
	quit result
}

/// 查找其他普通类检验项目
/// w ##class(web.DHCBPQualityControl).FitTest("2021-01-01","2021-10-18","0000418340","30^218^218^219^220^221^222^223^309","","110")
ClassMethod FitLabValue(fromDate As %String, toDate As %String, regNo As %String = "", LabTestCode As %String = "", maxValue As %String = "", minValue As %String = "") As %String
{
	//s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	//s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	set ifFind=0,reststr=""
	set standardCodeStr=LabTestCode
	for i=1:1:$l(standardCodeStr,"^") {
		set standardCode=$p(standardCodeStr,"^",i)
		quit:standardCode=""
		quit:(ifFind)
		set count=0
		set date=toDate 
		s rset=##class(%ResultSet).%New("LabService.TCResult:QryTCResultBySync")	
		s ret="",isTooLong=0
		do rset.Execute("",regNo,standardCode,$zd(fromDate,3),$zd(toDate,3))
		while (rset.Next()) {
			q:(ifFind)
			s labNo=rset.GetData(3)
			s result=rset.GetData(8)
			s unit=rset.GetData(10)
			s range=rset.GetData(11)
			s receiveDate=rset.GetData(15)
			s receiveTime=rset.GetData(16)
			i receiveDate'="" s receiveDate=$zdh(receiveDate,3)
			i receiveTime'="" s receiveTime=$zth(receiveTime,4)
			s desc=rset.GetData(6)
			i ((maxValue="") &&( minValue="")) d
			.s ifFind=1
			.i reststr="" s reststr=desc_":"_result
			.e  s reststr=reststr_","_desc_":"_result
			e  i ((maxValue'="") &&( minValue="")) d
			.i result<(maxValue+1) d
			..s ifFind=1
			..i reststr="" s reststr=desc_":"_result
			..e  s reststr=reststr_","_desc_":"_result
			e  i ((maxValue="") &&( minValue'="")) d
			.i result>(minValue-1) d
			..;b ;1
			..s ifFind=1
			..i reststr="" s reststr=desc_":"_result
			..e  s reststr=reststr_","_desc_":"_result
			e  d
			.i ((result>(minValue-1))&&(result<(maxValue+1))) d
			..s ifFind=1
			..i reststr="" s reststr=desc_":"_result
			..e  s reststr=reststr_","_desc_":"_result
		}
		d rset.Close()
		
	}
	q ifFind_"@"_reststr
}

/// 查找乙肝、丙肝检验项目
/// w ##class(web.DHCBPQualityControl).FitHBVTest("2021-01-01","2021-10-18","0000418340","248^244")
ClassMethod FitHBVLabValue(fromDate As %String, toDate As %String, regNo As %String = "", LabTestCode As %String = "") As %String
{
	//s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	//s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	set ifFind=0,reststr=""
	set standardCodeStr=LabTestCode
	for i=1:1:$l(standardCodeStr,"^") {
		set standardCode=$p(standardCodeStr,"^",i)
		quit:standardCode=""
		quit:(ifFind)
		set count=0,isNo="false"
		set date=toDate 
		s rset=##class(%ResultSet).%New("LabService.TCResult:QryTCResultBySync")	
		s ret="",isTooLong=0
		do rset.Execute("",regNo,standardCode,$zd(fromDate,3),$zd(toDate,3))
		while (rset.Next()) {
			q:(ifFind)
			s labNo=rset.GetData(3)
			s result=rset.GetData(8)
			s unit=rset.GetData(10)
			s range=rset.GetData(11)
			s receiveDate=rset.GetData(15)
			s receiveTime=rset.GetData(16)
			i receiveDate'="" s receiveDate=$zdh(receiveDate,3)
			i receiveTime'="" s receiveTime=$zth(receiveTime,4)
			s desc=rset.GetData(6)
			S minValue=$P(range,"--",2)
			i ((isNo="false")&&( result<minValue)) s isNo="true"
			i ((isNo="true")&&( result>minValue)) s ifFind=1,reststr=desc_":"_result
		}
		d rset.Close()
	}
	q ifFind_"@"_reststr
}

/// 查找KDMBD检验项目
/// w ##class(web.DHCBPQualityControl).FitCKDMBDTest("2021-01-01","2021-10-18","0000202415","97^115^317")
ClassMethod FitCKDMBDLabValue(fromDate As %String, toDate As %String, regNo As %String = "", LabTestCode As %String = "") As %String
{
	//s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	//s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	set ifFind=0,result=""
	set standardCodeStr=LabTestCode
	s isCA=0,isipth=0,isp=0,castr="",ipthstr="",pstr=""
	for i=1:1:$l(standardCodeStr,"^") {
		set standardCode=$p(standardCodeStr,"^",i)
		quit:standardCode=""
		quit:(ifFind)
		set count=0,isNo="false"
		set date=toDate 
		s rset=##class(%ResultSet).%New("LabService.TCResult:QryTCResultBySync")	
		s ret="",isTooLong=0
		do rset.Execute("",regNo,standardCode,$zd(fromDate,3),$zd(toDate,3))
		while (rset.Next()) {
			q:(ifFind)
			s labNo=rset.GetData(3)
			s result=rset.GetData(8)
			s unit=rset.GetData(10)
			s range=rset.GetData(11)
			s receiveDate=rset.GetData(15)
			s receiveTime=rset.GetData(16)
			i receiveDate'="" s receiveDate=$zdh(receiveDate,3)
			i receiveTime'="" s receiveTime=$zth(receiveTime,4)
			s desc=rset.GetData(6)
			i testCodeRowId=97 d
			.i ((result>2.1)&&(result<2.5)) d
			..;b ;1
			..s isCA=1
			..s castr=desc_":"_result
			i testCodeRowId=115 d
			.i ((result>1.13)&&(result<1.78)) d
			..;b ;2
			.. s isp=1
			..s pstr=desc_":"_result
			i testCodeRowId=317 d
			.S maxValue=$P(range,"--",2)*9
			.S minValue=$P(range,"--",1)*2
			.i ((result>minValue)&&(result<maxValue)) d
			..;b ;3
			..s isipth=1
			..s ipthstr=desc_":"_result
		}
		d rset.Close()
		i ((isCA)&&(isp)&&(isipth)) d
		.s ifFind=1
		.s result=castr_","_pstr_","_ipthstr
	}
	q ifFind_"@"_result
}

/// 查找透析记录中符合条件的项目
/// w ##class(web.DHCBPQualityControl).FitBPItem("2021-01-01","2021-10-18","163","Weight")
ClassMethod FitBPItem(fromDate As %String, toDate As %String, registerId As %String = "", itemType As %String = "") As %String
{
	s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	set ifFind=0,reststr=""
	i itemType="BloodPressure" d
	.s bpaId=""
	.f  s bpaId=$o(^DHCBPArrange(0,"PatRegister",registerId,bpaId),-1) q:((bpaId="")!(ifFind))  d
	..s bpaDate=$lg(^DHCBPArrange(bpaId),4)
	..q:bpaDate=""
	..s bpaStatus=$lg(^DHCBPArrange(bpaId),9)	
	..q:bpaStatus="" 	
	..q:bpaStatus="D"
	..s papmiId=$lg(^DHCBPPatRegister(registerId),1)
	..q:papmiId=""
	..s patBirth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	..s bpaTime=$lg(^DHCBPArrange(bpaId),5)
	..q:(bpaDate>toDate)
	..q:(bpaDate<fromDate)
	..s patAge=##class(web.DHCClinicCom).CalAge(patBirth,bpaDate)
	..s SBP=$lg(^DHCBPArrange(bpaId),64)
	..s DBP=$lg(^DHCBPArrange(bpaId),62)
	..i patAge <61 d
	...i ((SBP <140) & (DBP>90)) d
	.... s ifFind=1
	....s reststr="年龄:"_patAge_","_"舒张压:"_SBP_","_"收缩压:"_DBP
	..e  d	
	...i ((SBP <160) & (DBP>90 )) d
	....s ifFind=1
	....s reststr="年龄:"_patAge_","_"舒张压:"_SBP_","_"收缩压:"_DBP
	i itemType="VascularAccess" d
	.s VAId=""
	.f  s VAId=$o(^DHCBPVascularAccess(0,"Register",registerId,VAId),-1) q:((VAId="")!(ifFind))  d
	..s bpcVascularAccess=$lg(^DHCBPVascularAccess(VAId),2)
	..q:((bpcVascularAccess'=1)&&(bpcVascularAccess'=2))
	..s desc=$lg(^DHCBPC("VascularAccess",bpcVascularAccess),2)
	..s sDate=$lg(^DHCBPVascularAccess(VAId),6)
	..q:sDate=""
	..s eDate=$lg(^DHCBPVascularAccess(VAId),8)
	..q:eDate=""
	..s bpaStatus=$lg(^DHCBPVascularAccess(VAId),11)	
	..
	..q:bpaStatus="" 	
	..q:bpaStatus="D"
	..q:sDate>toDate
	..q:eDate<fromDate
	..i eDate=2980013 d
	...i (toDate-sDate)>730 D
	.... s ifFind=1
	....s reststr=desc_":"_(toDate-sDate)_"天"
	..e  d
	...i (eDate-sDate)>730 d
	....s ifFind=1
	....s reststr=desc_":"_(toDate-sDate)_"天"
	i itemType="Weight" d
	.s bpaId="",sWeight="",eWeight="",count=0,sum=0
	.f  s bpaId=$o(^DHCBPArrange(0,"PatRegister",registerId,bpaId)) q:(bpaId="")  d
	..s bpaDate=$lg(^DHCBPArrange(bpaId),4)
	..q:bpaDate=""
	..s bpaStatus=$lg(^DHCBPArrange(bpaId),9)	
	..q:bpaStatus="" 	
	..q:bpaStatus="D"
	..q:(bpaDate>toDate)
	..q:(bpaDate<fromDate)
	..i sWeight="" d
	...s sWeight=$lg(^DHCBPArrange(bpaId),14)
	..e  d
	...s eWeight=$lg(^DHCBPArrange(bpaId),10)
	..q:((sWeight="")||(sWeight=0))
	..q:((eWeight="")||(eWeight=0))
	..s sum=sum+((eWeight-sWeight)/sWeight)
	..s count=count+1
	..s sWeight=$lg(^DHCBPArrange(bpaId),14)
	.q:count=0
	.i (sum/count)<0.05 d
	..s ifFind=1
	..s reststr="体重:"_sum/count
	
	q ifFind_"@"_reststr
}

}
