Class web.DHCWLCheckMRIPLoadData Extends %RegisteredObject
{

/// Creator：		陈乙
/// CreatDate：		2022-05-01
/// Description：	入院人数查询核对
/// Table：			dhcmripday,pa_adm,pa_admext
/// Input：			startDate，endDate
/// Output：		
/// Return： 		无 , tarId As %String="", resDepId As %String="", recDepId As %String
/// Others： 		无
/// d ##class(%ResultSet).RunQuery("web.DHCWLCheckMRIPLoadData","QueryCheckAdmDate","2019-02-01","2019-04-01")
Query QueryCheckAdmDate(startDate As %String, endDate As %String) As %Query(ROWSPEC = "adm:%String,djh:%String,zyh:%String,patName:%String,disDateFromAdm:%String,disDateFromCRZ:%String") [ SqlProc ]
{
}

ClassMethod QueryCheckAdmDateExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String) As %Status
{

 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	i ($g(startDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK
	i ($g(endDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK	
		
	K ^||TEMPDHCWL
	s startDate=$zdh(startDate,3)
	s endDate=$zdh(endDate,3)
	
	
	i $g(^DHCDishChargeSet("Disch","ifGetAdmDateTimeByBed"))="Y"  s dateNod="AdminDateExt"
 	e  s dateNod="PAADM_AdmDate"
 	
	f date=startDate:1:endDate d
	.s admId=0 f  s admId=$o(^PAADMi(dateNod,date,admId)) q:admId=""  d
	..s motherDr=$p(^PAADM(admId),"^",75)
	..q:$g(motherDr)'=""		;小孩不算
	..s admType=$p(^PAADM(admId),"^",2)
	..q:admType'="I"
	..q:($p(^PAADM(admId),"^",20)="C")&&(update=date)   //入院当天退院的患者不统计
	..s update=$p(^PAADM(admId,1),"^",42)	
	..s ^||TEMPDHCWL(admId,"ADM")=date
	
	f date=startDate:1:endDate d
	.s mripId=0 
	.f  s mripId=$o(^MRIPdaily("MRIP_DATE",date,mripId)) q:mripId=""  d
	..s locDr=$p(^MRIPdaily(mripId),"^",7)
	..q:$g(locDr)=""
	..s admId=0 f  s admId=$o(^DHCMRIPDetail(0,"IPDayDr",mripId,"Type","RYRS","Paadm",admId)) q:admId=""  d
	...s ^||TEMPDHCWL(admId,"CRZ")=date
	
	//病人信息和各出院时间输出
	s adm=""
	f  s adm=$o(^||TEMPDHCWL(adm)) q:adm=""  D
	.k disDateFromAdm,disDateFromCRZ,disDateFromMR
	.s papmi=$p($g(^PAADM(adm)),"^",1)
	.s patName=$$GetPapmiName^DHCWLCommon(papmi)	;病人姓名
	.s djh=$$GetPapmiNo^DHCWLCommon(papmi)			;登记号
	.s zyh=##class(web.DHCWLStatisticsInterface).GetMedNoByAdm(adm) ;$$GetPapmiMedtare^DHCWLCommon(papmi)	;住院号
	.s disDateFromAdm=$g(^||TEMPDHCWL(adm,"ADM")) 	;就诊表出院日期
	.s disDateFromCRZ=$g(^||TEMPDHCWL(adm,"CRZ")) 	;出入转出院日期
	.q:(disDateFromAdm=disDateFromCRZ)  //日期相同的表示没问题，不输出。
	.i disDateFromAdm'="" s disDateFromAdm=$zd(disDateFromAdm,3)
	.i disDateFromCRZ'="" s disDateFromCRZ=$zd(disDateFromCRZ,3)
	.d OutRow
	
	K ^||TEMPDHCWL
	
 	Quit $$$OK

	
OutRow
	s Data=$lb(adm,djh,zyh,patName,disDateFromAdm,disDateFromCRZ)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QueryCheckAdmDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCheckAdmDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryCheckAdmDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCheckAdmDateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：		陈乙
/// CreatDate：		2017-01-11
/// Description：	出院人数查询核对
/// Table：			dhcmripday,pa_adm,pa_admext,dhcmrinfo
/// Input：			startDate，endDate
/// Output：		
/// Return： 		无 , tarId As %String="", resDepId As %String="", recDepId As %String
/// Others： 		无
/// d ##class(%ResultSet).RunQuery("web.DHCWLCheckMRIPLoadData","QueryCheckDisDate","2019-02-01","2019-04-01","AdmCrz")
Query QueryCheckDisDate(startDate As %String, endDate As %String, type As %String) As %Query(ROWSPEC = "adm:%String,djh:%String,zyh:%String,patName:%String,disDateFromAdm:%String,disDateFromCRZ:%String,disDateFromMR:%String") [ SqlProc ]
{
}

ClassMethod QueryCheckDisDateExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, type As %String) As %Status
{

 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	i ($g(startDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK
	i ($g(endDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK	
		
	K ^||TEMPDHCWL
	s startDate=$zdh(startDate,3)
	s endDate=$zdh(endDate,3)
	
	
	i $g(^DHCDishChargeSet("Disch","ifGetDischgDateTimeByDoc"))="Y" s dateNode="DischargeDateExt"
	e  s dateNode="DischDate"   //DischDate  EstDisch  老项目根据情况自己调整下  ;护士结算时间做出院时间
	f date=startDate:1:endDate d
	.s admId=0 f  s admId=$o(^PAADMi(dateNode,date,admId)) q:admId=""  d
	..s motherDr=$p(^PAADM(admId),"^",75)
	..q:$g(motherDr)'=""		;小孩不算
	..s admType=$p(^PAADM(admId),"^",2)
	..q:admType'="I"
	..q:$p(^PAADM(admId),"^",20)="C"	
	..s ^||TEMPDHCWL(admId,"ADM")=date
	
	f date=startDate:1:endDate d
	.s mripId=0 
	.f  s mripId=$o(^MRIPdaily("MRIP_DATE",date,mripId)) q:mripId=""  d
	..s locDr=$p(^MRIPdaily(mripId),"^",7)
	..q:$g(locDr)=""
	..s admId=0 f  s admId=$o(^DHCMRIPDetail(0,"IPDayDr",mripId,"Type","CYRS","Paadm",admId)) q:admId=""  d
	...s ^||TEMPDHCWL(admId,"CRZ")=date
	
	f date=startDate:1:endDate d
	.s mrinfoId=0 f  s mrinfoId=$o(^DHCMRInfo(0,"MR_DIS_DATE",date,mrinfoId)) q:mrinfoId=""  d
	..s admId=$p(^DHCMRInfo(mrinfoId),"^",6)
	..s ^||TEMPDHCWL(admId,"MR")=date

	//病人信息和各出院时间输出
	s adm=""
	f  s adm=$o(^||TEMPDHCWL(adm)) q:adm=""  D
	.k disDateFromAdm,disDateFromCRZ,disDateFromMR
	.s papmi=$p($g(^PAADM(adm)),"^",1)
	.s patName=$$GetPapmiName^DHCWLCommon(papmi)	;病人姓名
	.s djh=$$GetPapmiNo^DHCWLCommon(papmi)			;登记号
	.s zyh=##class(web.DHCWLStatisticsInterface).GetMedNoByAdm(adm)  ;$$GetPapmiMedtare^DHCWLCommon(papmi)	;住院号
	.s disDateFromAdm=$g(^||TEMPDHCWL(adm,"ADM")) 	;就诊表出院日期
	.s disDateFromCRZ=$g(^||TEMPDHCWL(adm,"CRZ")) 	;出入转出院日期
	.s disDateFromMR=$g(^||TEMPDHCWL(adm,"MR")) 	;病案出院日期
	.q:(type="AdmCrz")&&(disDateFromAdm=disDateFromCRZ)  //日期相同的表示没问题，不输出。
	.q:(type="AdmCrzMr")&&(disDateFromAdm=disDateFromCRZ)&&(disDateFromAdm=disDateFromMR)  //日期相同的表示没问题，不输出。
	.i disDateFromAdm'="" s disDateFromAdm=$zd(disDateFromAdm,3)
	.i disDateFromCRZ'="" s disDateFromCRZ=$zd(disDateFromCRZ,3)
	.i disDateFromMR'="" s disDateFromMR=$zd(disDateFromMR,3)
	.d OutRow
	
	K ^||TEMPDHCWL
	
 	Quit $$$OK

	
OutRow
	s Data=$lb(adm,djh,zyh,patName,disDateFromAdm,disDateFromCRZ,disDateFromMR)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QueryCheckDisDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCheckDisDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryCheckDisDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCheckDisDateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：		陈乙
/// CreatDate：		2016-01-20
/// Description：	出入转任务数据报错明细展示
/// Table：			DHCMRIPDay，DHC_MRIPDetail
/// Input：			startDate，endDate
/// Output：
/// Return： 		无
/// Others： 		思路：计算今天的现有人数：将昨天的在院人数+今天入院+今天转入-今天转出-今天退院-今天出院
/// 						  出入转记录的今天的现有人数；
/// 						  比较这两列的不同，不同的人数为可能问题数据
/// d ##class(%ResultSet).RunQuery("web.DHCWLCheckMRIPLoadData","QueryErrorDataPatInfo","2019-05-01","2019-05-01")
Query QueryErrorDataPatInfo(startDate As %String, endDate As %String) As %Query(ROWSPEC = "typeDesc:%String,locWardDesc:%String,adm:%String,dateDesc:%String") [ SqlProc ]
{
}

ClassMethod QueryErrorDataPatInfoExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String) As %Status
{

 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s ind=1
	//k ^TEMPDHCWL($j)
 	i ($g(startDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK  
	i ($g(endDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK		

	s startDate=$zdh(startDate,3)						
	s endDate=$zdh(endDate,3)
	
	//检查报错的科室或病区
	f mDate=startDate:1:endDate d
	.d CheckProcess(mDate,mDate)	//每天输出一次

    
    Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutRow
	s Data=$lb(typeDesc,locWardDesc,adm,dateDesc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	//该方法每天检查一次，不支持多天
CheckProcess(sDate,eDate)
	k ^||TEMPDHCWL
	//检查报错的科室或病区
	f mDate=sDate:1:eDate d
	.i '$d(^MRIPdaily("MRIP_DATE",mDate)) d
	..s typeDesc=$zd(mDate,3)_"无数据！",locWardDesc="",adm="",dateDesc=""
	..d OutRow
	.s mrId=0
	.f  s mrId=$o(^MRIPdaily("MRIP_DATE",mDate,mrId)) q:$g(mrId)=""  d
	..s mLocDr=$p($g(^MRIPdaily(mrId)),"^",7)
	..s mWardDr=$p($g(^MRIPdaily(mrId)),"^",19)
	..s mXYRS=$p($g(^MRIPdaily(mrId)),"^",18)
	..s mDetailSum=0
	..s mSubId=0
	..f  s mSubId=$o(^DHCMRIPDetail(0,"IPType",mrId,"ZYRS",mSubId)) q:$g(mSubId)=""  d
	...s mDetailSum=$g(mDetailSum)+1
	..i +$g(mXYRS)'=$g(mDetailSum) d
	...i $g(mLocDr)'="" s ^||TEMPDHCWL("DEP",mLocDr)=+$g(mXYRS)_"||"_$g(mDetailSum)
	...i $g(mWardDr)'="" s ^||TEMPDHCWL("WARD",mWardDr)=+$g(mXYRS)_"||"_$g(mDetailSum)

   	f day=sDate:1:eDate  d
   	.s preDay=day-1
   	.s mripId=0
   	.f  s mripId=$o(^MRIPdaily("MRIP_DATE",preDay,mripId)) q:mripId=""  d
   	..s locDr=$p(^MRIPdaily(mripId),"^",7)
   	..s wardDr=$p(^MRIPdaily(mripId),"^",19)
   	..q:(locDr'="")&&('$d(^||TEMPDHCWL("DEP",locDr)))  		//科室没有错误，则直接退出
   	..q:(wardDr'="")&&('$d(^||TEMPDHCWL("WARD",wardDr)))  	//病区没有错误，则直接退出
   	..;原有人数
   	..s adm=0
   	..f  s adm=$o(^DHCMRIPDetail(0,"IPDayDr",mripId,"Type","ZYRS","Paadm",adm)) q:adm=""  d
   	...s rowId=0
   	...f  s rowId=$o(^DHCMRIPDetail(0,"IPDayDr",mripId,"Type","ZYRS","Paadm",adm,rowId)) q:rowId=""  d
   	....i $g(locDr)'="" s ^||TEMPDHCWL("ADM","LOC",locDr,adm,"JSZYRS")=1+$g(^||TEMPDHCWL("ADM","LOC",locDr,adm,"JSZYRS"))			//科室计算的在院人数
   	....i $g(wardDr)'="" s ^||TEMPDHCWL("ADM","WARD",wardDr,adm,"JSZYRS")=1+$g(^||TEMPDHCWL("ADM","WARD",wardDr,adm,"JSZYRS"))			//病区计算的在院人数
   	.s mripId=0
   	.f  s mripId=$o(^MRIPdaily("MRIP_DATE",day,mripId)) q:mripId=""  d
   	..s locDr=$p(^MRIPdaily(mripId),"^",7)
   	..s wardDr=$p(^MRIPdaily(mripId),"^",19)
   	..q:(locDr'="")&&('$d(^||TEMPDHCWL("DEP",locDr)))  		//科室没有错误，则直接退出
   	..q:(wardDr'="")&&('$d(^||TEMPDHCWL("WARD",wardDr)))  	//病区没有错误，则直接退出
   	..s adm=0
   	..f  s adm=$o(^DHCMRIPDetail(0,"IPDayDr",mripId,"Type","ZYRS","Paadm",adm)) q:adm=""  d
    ...s rowId=0
   	...f  s rowId=$o(^DHCMRIPDetail(0,"IPDayDr",mripId,"Type","ZYRS","Paadm",adm,rowId)) q:rowId=""  d
   	....i $g(locDr)'="" s ^||TEMPDHCWL("ADM","LOC",locDr,adm,"JLZYRS")=1+$g(^||TEMPDHCWL("ADM","LOC",locDr,adm,"JLZYRS"))			//科室记录的在院人数
   	....i $g(wardDr)'="" s ^||TEMPDHCWL("ADM","WARD",wardDr,adm,"JLZYRS")=1+$g(^||TEMPDHCWL("ADM","WARD",wardDr,adm,"JLZYRS"))		//病区记录的在院人数
   	..
   	..//入院人数
   	..s adm=0
   	..f  s adm=$o(^DHCMRIPDetail(0,"IPDayDr",mripId,"Type","RYRS","Paadm",adm)) q:adm=""  d
   	...s rowId=0
   	...f  s rowId=$o(^DHCMRIPDetail(0,"IPDayDr",mripId,"Type","RYRS","Paadm",adm,rowId)) q:rowId=""  d
   	....i $g(locDr)'="" s ^||TEMPDHCWL("ADM","LOC",locDr,adm,"JSZYRS")=1+$g(^||TEMPDHCWL("ADM","LOC",locDr,adm,"JSZYRS"))			//科室记录的在院人数
   	....i $g(wardDr)'="" s ^||TEMPDHCWL("ADM","WARD",wardDr,adm,"JSZYRS")=1+$g(^||TEMPDHCWL("ADM","WARD",wardDr,adm,"JSZYRS"))			//科室记录的在院人数
	..//转入人数
   	..s adm=0
   	..f  s adm=$o(^DHCMRIPDetail(0,"IPDayDr",mripId,"Type","ZRKS","Paadm",adm)) q:adm=""  d
   	...s rowId=0
   	...f  s rowId=$o(^DHCMRIPDetail(0,"IPDayDr",mripId,"Type","ZRKS","Paadm",adm,rowId)) q:rowId=""  d
   	....i $g(locDr)'="" s ^||TEMPDHCWL("ADM","LOC",locDr,adm,"JSZYRS")=1+$g(^||TEMPDHCWL("ADM","LOC",locDr,adm,"JSZYRS"))			//科室记录的在院人数
   	....i $g(wardDr)'="" s ^||TEMPDHCWL("ADM","WARD",wardDr,adm,"JSZYRS")=1+$g(^||TEMPDHCWL("ADM","WARD",wardDr,adm,"JSZYRS"))
   	..//转出人数
   	..s adm=0
   	..f  s adm=$o(^DHCMRIPDetail(0,"IPDayDr",mripId,"Type","ZCKS","Paadm",adm)) q:adm=""  d
   	...s rowId=0
   	...f  s rowId=$o(^DHCMRIPDetail(0,"IPDayDr",mripId,"Type","ZCKS","Paadm",adm,rowId)) q:rowId=""  d
   	....i $g(locDr)'="" s ^||TEMPDHCWL("ADM","LOC",locDr,adm,"JSZYRS")=$g(^||TEMPDHCWL("ADM","LOC",locDr,adm,"JSZYRS"))-1			//科室记录的在院人数
   	....i $g(wardDr)'="" s ^||TEMPDHCWL("ADM","WARD",wardDr,adm,"JSZYRS")=$g(^||TEMPDHCWL("ADM","WARD",wardDr,adm,"JSZYRS"))-1
	..//出院人数
   	..s adm=0
   	..f  s adm=$o(^DHCMRIPDetail(0,"IPDayDr",mripId,"Type","CYRS","Paadm",adm)) q:adm=""  d
   	...s rowId=0
   	...f  s rowId=$o(^DHCMRIPDetail(0,"IPDayDr",mripId,"Type","CYRS","Paadm",adm,rowId)) q:rowId=""  d
   	....i $g(locDr)'="" s ^||TEMPDHCWL("ADM","LOC",locDr,adm,"JSZYRS")=$g(^||TEMPDHCWL("ADM","LOC",locDr,adm,"JSZYRS"))-1			//科室记录的在院人数
   	....i $g(wardDr)'="" s ^||TEMPDHCWL("ADM","WARD",wardDr,adm,"JSZYRS")=$g(^||TEMPDHCWL("ADM","WARD",wardDr,adm,"JSZYRS"))-1
   	..//退院人数
   	..s adm=0
   	..f  s adm=$o(^DHCMRIPDetail(0,"IPDayDr",mripId,"Type","TYRS","Paadm",adm)) q:adm=""  d
   	...s rowId=0
   	...f  s rowId=$o(^DHCMRIPDetail(0,"IPDayDr",mripId,"Type","TYRS","Paadm",adm,rowId)) q:rowId=""  d
   	....i $g(locDr)'="" s ^||TEMPDHCWL("ADM","LOC",locDr,adm,"JSZYRS")=$g(^||TEMPDHCWL("ADM","LOC",locDr,adm,"JSZYRS"))-1			//科室记录的在院人数
   	....i $g(wardDr)'="" s ^||TEMPDHCWL("ADM","WARD",wardDr,adm,"JSZYRS")=$g(^||TEMPDHCWL("ADM","WARD",wardDr,adm,"JSZYRS"))-1
	
	s type=""
	f  s type=$o(^||TEMPDHCWL("ADM",type)) q:type=""  d
	.s locWardDr=0
	.f  s locWardDr=$o(^||TEMPDHCWL("ADM",type,locWardDr)) q:locWardDr=""  d
	..s adm=0
	..f  s adm=$o(^||TEMPDHCWL("ADM",type,locWardDr,adm)) q:adm=""  d
	...s jsNum=+$g(^||TEMPDHCWL("ADM",type,locWardDr,adm,"JSZYRS"))
	...s jlNum=+$g(^||TEMPDHCWL("ADM",type,locWardDr,adm,"JLZYRS"))
	...s errorNum=jsNum-jlNum
	...q:errorNum=0						//相减等于0 表示正常病人数据
	...i type="LOC" d
	....s locWardDesc=$p(^CTLOC(locWardDr),"^",2)
	....s typeDesc="科室"
	...e  d
	....s locWardDesc=$p(^PAWARD(locWardDr),"^",2)
	....s typeDesc="病区"
	...i locWardDesc["-" s locWardDesc=$p(locWardDesc,"-",2)
	...s dateDesc=$zd(day,3)
	...d OutRow
	;zw ^||TEMPDHCWL("ADM")
}

ClassMethod QueryErrorDataPatInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryErrorDataPatInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryErrorDataPatInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryErrorDataPatInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
