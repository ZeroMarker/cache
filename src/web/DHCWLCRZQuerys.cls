Class web.DHCWLCRZQuerys Extends %RegisteredObject
{

/// Creator：		CHENYI
/// CreatDate：		2019-07-17
/// Description：	病人在科住院天数
/// Table：			dhcmripday
/// Input：			
/// Output：
/// Return： 		无
/// Others： 		无
/// d ##class(%ResultSet).RunQuery("web.DHCWLCRZQuerys","QueryDepInhosDays","2020-03-01","2020-04-05","")
Query QueryDepInhosDays(startDate As %String, endDate As %String, hosId As %String) As %Query(ROWSPEC = "zyLocDesc:%String,zyWardDesc:%String,regNo:%String,medNo:%String,patName:%String,patAge:%String,patSex:%String,num:%Float,zyDateDesc:%String") [ SqlProc ]
{
}

ClassMethod QueryDepInhosDaysExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String) As %Status
{

 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s ind=1
	
 	i ($g(startDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK  
	i ($g(endDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK	

	s startDate=$zdh(startDate,3)						
	s endDate=$zdh(endDate,3)
	k ^||TEMPDHCWL($j)
	k ErrMsg
	f date=startDate:1:endDate d
	.s mrId="" f  s mrId=$o(^MRIPdaily("MRIP_DATE",date,mrId)) q:mrId=""  d
	..s cyLocDr=$p(^MRIPdaily(mrId),"^",7)
	..q:cyLocDr=""   	//过滤掉病区数据
	..s mHosId=$$GetHospId^DHCWLBuildDimDataCTLOC(cyLocDr)
	..q:(","_hosId_",")'[(","_mHosId_",")&&($g(hosId)'="")
	..s mrDetId="" f  s mrDetId=$o(^DHCMRIPDetail(0,"IPType",mrId,"CYRS",mrDetId)) q:mrDetId=""  d
	...s adm=$p(^DHCMRIPDetail(mrDetId),"^",1)
	...s flag=$$RetAdmDateIndexNod^DHCMRIPLoad() 
	...i flag="AdminDateExt" s admDate=$p(^PAADM(adm,"DHC"),"^",31)
	...e  s admDate=$p(^PAADM(adm),"^",6)
	...s cyWardDr=+$$SelectLocWardDate^DHCMRIPLoad(date,adm)
	...i admDate=date s ^||TEMPDHCWL($j,cyLocDr,cyWardDr,adm,date)=1  //当天入院当天出院，算住院一天
	...s zyDetailDr=0 f  s zyDetailDr=$o(^DHCMRIPDetail(0,"TYPE","ZYRS","ADM",adm,zyDetailDr)) q:zyDetailDr=""  d
	....s zyMRIPDr=$p(^DHCMRIPDetail(zyDetailDr),"^",3)
	....s zyLocDr=$p(^MRIPdaily(zyMRIPDr),"^",7) 
	....q:zyLocDr=""   //过滤掉病区数据
	....s zyDate=$p(^MRIPdaily(zyMRIPDr),"^",6) 
	....s zyWardDr=+$$SelectLocWardDate^DHCMRIPLoad(zyDate,adm)
	....s ^||TEMPDHCWL($j,zyLocDr,zyWardDr,adm,zyDate)=1
	
	//output
	s zyLocDr=""
	f  s zyLocDr=$o(^||TEMPDHCWL($j,zyLocDr)) q:zyLocDr=""  d
	.s zyLocDesc=$p(^CTLOC(zyLocDr),"^",2)
	.s zyWardDr="" f  s zyWardDr=$o(^||TEMPDHCWL($j,zyLocDr,zyWardDr)) q:zyWardDr=""  d
	..s zyWardDesc=$p(^PAWARD(zyWardDr),"^",2)
	..s adm="" f  s adm=$o(^||TEMPDHCWL($j,zyLocDr,zyWardDr,adm)) q:adm=""  d
	...s papmi=$p(^PAADM(adm),"^",1)
	...s regNo=$$GetPapmiNo^DHCWLCommon(papmi)	//登记号
	...s medNo=##class(web.DHCWLStatisticsInterface).GetMedNoByAdm(adm)
	...s patName=$$GetPapmiName^DHCWLCommon(papmi)		//患者姓名
	...s patAge=##class(web.DHCBillInterface).GetPapmiAge(papmi,adm)  //改用公司年龄标准接口 ;$$GetAge^DHCWLCommon(papmi)		//患者年龄
	...s patSex=$$GetSex^DHCWLCommon(papmi)
	...s zyDate="" f  s zyDate=$o(^||TEMPDHCWL($j,zyLocDr,zyWardDr,adm,zyDate)) q:zyDate=""  d
	....s num=1
	....s zyDateDesc=$zd(zyDate,3)
	....d OutRow
	k ^||TEMPDHCWL($j)
 	Quit $$$OK
 	
OutRow
	s Data=$lb(zyLocDesc,zyWardDesc,regNo,medNo,patName,patAge,patSex,num,zyDateDesc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QueryDepInhosDaysClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDepInhosDaysExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryDepInhosDaysFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDepInhosDaysExecute ]
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

/// Creator：		CHENYI
/// CreatDate：		2017-12-17
/// Description：	病人住院天数
/// Table：			dhcmripday
/// Input：			
/// Output：
/// Return： 		无
/// Others： 		无
/// d ##class(%ResultSet).RunQuery("web.DHCWLCRZQuerys","QueryInhosDays","2018-02-07","2018-02-07",,1,"ZYRS")
Query QueryInhosDays(startDate As %String, endDate As %String, hosId As %String, days As %String, type As %String) As %Query(ROWSPEC = "adm:%String,regNo:%String,medNo:%String,patName:%String,patAge:%String,patSex:%String,ryDateDesc:%String,cyDateDesc:%String,ryLocDesc:%String,cyLocDesc:%String,inDays:%Float") [ SqlProc ]
{
}

ClassMethod QueryInhosDaysExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String, days As %String, type As %String) As %Status
{

 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s ind=1
	
 	i ($g(startDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK  
	i ($g(endDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK	

	s startDate=$zdh(startDate,3)						
	s endDate=$zdh(endDate,3)
	k ErrMsg
	f date=startDate:1:endDate d
	.s mrId="" f  s mrId=$o(^MRIPdaily("MRIP_DATE",date,mrId)) q:mrId=""  d
	..s cyLocDr=$p(^MRIPdaily(mrId),"^",7)
	..q:cyLocDr=""
	..s mHosId=$$GetHospId^DHCWLBuildDimDataCTLOC(cyLocDr)
	..s mHosId=","_mHosId_","
	..q:((","_$g(hosId)_",")'[mHosId)&&($g(hosId)'="")
	..s cyDateDesc=$zd(date,3)
	..i ($g(type)["CYRS")||($g(type)="") d
	...s mrDetId="" f  s mrDetId=$o(^DHCMRIPDetail(0,"IPType",mrId,"CYRS",mrDetId)) q:mrDetId=""  d
	....s adm=$p(^DHCMRIPDetail(mrDetId),"^",1)
	....s papmi=$p(^PAADM(adm),"^",1)
	....s regNo=$$GetPapmiNo^DHCWLCommon(papmi)	//登记号
	....s medNo=##class(web.DHCWLStatisticsInterface).GetMedNoByAdm(adm)
	....s patName=$$GetPapmiName^DHCWLCommon(papmi)		//患者姓名
	....s patAge=##class(web.DHCBillInterface).GetPapmiAge(papmi,adm)  //改用公司年龄标准接口 ;$$GetAge^DHCWLCommon(papmi)		//患者年龄
	....s patSex=$$GetSex^DHCWLCommon(papmi)		//患者年龄
	....s ryLocDr="",ryDate=""
	....s ryDetId="" f  s ryDetId=$o(^DHCMRIPDetail(0,"TYPE","RYRS","ADM",adm,ryDetId)) q:ryDetId=""  d
	.....s ryMrId=$p(^DHCMRIPDetail(ryDetId),"^",3)
	.....s admLocDr=$p(^MRIPdaily(ryMrId),"^",7)
	.....i admLocDr'="" s ryLocDr=admLocDr,ryDate=$p(^MRIPdaily(ryMrId),"^",6)
	....q:ryDate=""
	....s inDays=##class(web.DHCWLTJSCommonFunction).GetZYRSFromCRZByAdm(adm,"")
	....i inDays<=0 s inDays=1
	....q:inDays<$g(days)&&(+$g(days)'=0)
	....s ryDateDesc=$zd(ryDate,3)
	....s ryLocDesc=$$GetDepDesc^DHCWLBuildDimDataCTLOC(ryLocDr)
	....s cyLocDesc=$$GetDepDesc^DHCWLBuildDimDataCTLOC(cyLocDr)
	....d OutRow

	f date=endDate:1:endDate d
	.s mrId="" f  s mrId=$o(^MRIPdaily("MRIP_DATE",date,mrId)) q:mrId=""  d
	..s cyLocDr=$p(^MRIPdaily(mrId),"^",7)
	..q:cyLocDr=""
	..s mHosId=$$GetHospId^DHCWLBuildDimDataCTLOC(cyLocDr)
	..s mHosId=","_mHosId_","
	..q:((","_$g(hosId)_",")'[mHosId)&&($g(hosId)'="")
	..s cyDateDesc=$zd(date,3)
	..i ($g(type)["ZYRS")||($g(type)="") d
	...s mrDetId="" f  s mrDetId=$o(^DHCMRIPDetail(0,"IPType",mrId,"ZYRS",mrDetId)) q:mrDetId=""  d
	....s adm=$p(^DHCMRIPDetail(mrDetId),"^",1)
	....s papmi=$p(^PAADM(adm),"^",1)
	....s regNo=$$GetPapmiNo^DHCWLCommon(papmi)	//登记号
	....s medNo=##class(web.DHCWLStatisticsInterface).GetMedNoByAdm(adm)
	....s patName=$$GetPapmiName^DHCWLCommon(papmi)		//患者姓名
	....s patAge=##class(web.DHCBillInterface).GetPapmiAge(papmi,adm)  ;;$$GetAge^DHCWLCommon(papmi)		//患者年龄
	....s patSex=$$GetSex^DHCWLCommon(papmi)		//患者年龄
	....s ryLocDr="",ryDate=""
	....s ryDetId="" f  s ryDetId=$o(^DHCMRIPDetail(0,"TYPE","RYRS","ADM",adm,ryDetId)) q:ryDetId=""  d
	.....s ryMrId=$p(^DHCMRIPDetail(ryDetId),"^",3)
	.....s admLocDr=$p(^MRIPdaily(ryMrId),"^",7)
	.....i admLocDr'="" s ryLocDr=admLocDr,ryDate=$p(^MRIPdaily(ryMrId),"^",6)
	....q:ryDate=""
	....s inDays=##class(web.DHCWLTJSCommonFunction).GetZYRSFromCRZByAdm(adm,date)
	....q:inDays<$g(days)
	....s ryDateDesc=$zd(ryDate,3)
	....s ryLocDesc=$$GetDepDesc^DHCWLBuildDimDataCTLOC(ryLocDr)
	....s cyLocDesc=$$GetDepDesc^DHCWLBuildDimDataCTLOC(cyLocDr)
	....d OutRow
	
 	Quit $$$OK

	
OutRow
	s Data=$lb(adm,regNo,medNo,patName,patAge,patSex,ryDateDesc,cyDateDesc,ryLocDesc,cyLocDesc,inDays)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QueryInhosDaysClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryInhosDaysExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryInhosDaysFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryInhosDaysExecute ]
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

/// Creator：		CHENYI
/// CreatDate：		2017-12-17
/// Description：	患者住院信息
/// Table：			dhcmripday
/// Input：			
/// Output：
/// Return： 		无
/// Others： 		无
/// d ##class(%ResultSet).RunQuery("web.DHCWLCRZQuerys","QueryPatInhosInfo","0000001146")
Query QueryPatInhosInfo(regNo As %String) As %Query(ROWSPEC = "adm:%String,regNo:%String,medNo:%String,patName:%String,patAge:%String,patSex:%String,diagStr:%String,ryDateDesc:%String,cyDateDesc:%String,ryLocDesc:%String,cyLocDesc:%String,inDays:%Float") [ SqlProc ]
{
}

ClassMethod QueryPatInhosInfoExecute(ByRef qHandle As %Binary, regNo As %String) As %Status
{

 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	k ErrMsg
 	s regNo=$$AddFrontZero^DHCWLCommon(regNo)
	s regNo=$tr(regNo," ","")	;去掉空格
 	i ($g(regNo)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK  
	s papmi=0 f  s papmi=$o(^PAPERi("PAPMI_PatNo",$ZCVT(regNo,"U"),papmi)) q:papmi=""  d
	.s adm=0 f  s adm=$o(^PAPERdr(papmi,"ADM","I",adm)) q:adm=""  d
	..s medNo=##class(web.DHCWLStatisticsInterface).GetMedNoByAdm(adm)
	..s patName=$$GetPapmiName^DHCWLCommon(papmi)		//患者姓名
	..s patAge=##class(web.DHCBillInterface).GetPapmiAge(papmi,adm)  ;$$GetAge^DHCWLCommon(papmi)		//患者年龄
	..s patSex=$$GetSex^DHCWLCommon(papmi)		//患者年龄
	..q:'$d(^DHCMRIPDetail(0,"TYPE","RYRS","ADM",adm))
	..s ryLocDr="",ryDate=""
	..s mrDetId="" f  s mrDetId=$o(^DHCMRIPDetail(0,"TYPE","RYRS","ADM",adm,mrDetId)) q:mrDetId=""  d
	...s ryMrId=$p(^DHCMRIPDetail(mrDetId),"^",3)
	...s admLocDr=$p(^MRIPdaily(ryMrId),"^",7)
	...i admLocDr'="" s ryLocDr=admLocDr,ryDate=$p(^MRIPdaily(ryMrId),"^",6)
	..q:ryDate=""
	..s cyLocDr="",cyDate=""
	..i $d(^DHCMRIPDetail(0,"TYPE","CYRS","ADM",adm)) d
	...s mrDetId="" f  s mrDetId=$o(^DHCMRIPDetail(0,"TYPE","CYRS","ADM",adm,mrDetId)) q:mrDetId=""  d
	....s cyMrId=$p(^DHCMRIPDetail(mrDetId),"^",3)
	....s disLocDr=$p(^MRIPdaily(cyMrId),"^",7)
	....i disLocDr'="" s cyLocDr=disLocDr,cyDate=$p(^MRIPdaily(cyMrId),"^",6)
	..i cyDate="" s cyDate=+$h,cyLocDesc="",cyDateDesc=""
	..e  s cyLocDesc=$$GetDepDesc^DHCWLBuildDimDataCTLOC(cyLocDr),cyDateDesc=$zd(cyDate,3)
	..s inDays=cyDate-ryDate
	..i inDays<=0 s inDays=1
	..;q:inDays<$g(days)
	..s ryDateDesc=$zd(ryDate,3)
	..s ryLocDesc=$$GetDepDesc^DHCWLBuildDimDataCTLOC(ryLocDr)
	..s diagStr=##class(web.DHCWLStatisticsInterface).GetDiagByAdm(adm,"")
	..s diagStr=$P(diagStr,"^",1)
	..d OutRow
	
 	Quit $$$OK

	
OutRow
	s Data=$lb(adm,regNo,medNo,patName,patAge,patSex,diagStr,ryDateDesc,cyDateDesc,ryLocDesc,cyLocDesc,inDays)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QueryPatInhosInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPatInhosInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryPatInhosInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPatInhosInfoExecute ]
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

/// Creator：		CHENYI
/// CreatDate：		2017-12-30
/// Description：	患者明细查询
/// Table：			dhcmripday,dhc_mripdetail
/// Input：			
/// Output：
/// Return： 		无
/// Others： 		无
/// d ##class(%ResultSet).RunQuery("web.DHCWLCRZQuerys","QueryPatDetailForCRZ","2016-10-01","2016-11-30",,,,"CYRS","CTLOC")
Query QueryPatDetailForCRZ(startDate As %String, endDate As %String, hosId As %String, depId As %String, subDepId As %String, actionType As %String, roleType As %String) As %Query(ROWSPEC = "adm:%String,regNo:%String,medNo:%String,patName:%String,patAge:%String,patSex:%String,ryDateDesc:%String,cyDateDesc:%String,dateDesc:%String,ryLocDesc:%String,cyLocDesc:%String,inDays:%Float,zrDepDesc:%String,zcDepDesc:%String,diag:%String") [ SqlProc ]
{
}

ClassMethod QueryPatDetailForCRZExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String, depId As %String, subDepId As %String, actionType As %String, roleType As %String) As %Status
{

 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s ind=1
	k ErrMsg
 	i ($g(startDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK
 	i ($g(endDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK  
 	i ($g(roleType)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK 
 	i ($g(actionType)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK 
 	
 	
	s space=$case(roleType,"CTLOC":7,"WARD":19)
	
	s startDate=$zdh(startDate,3)						
	s endDate=$zdh(endDate,3)
	i actionType="ZYRS" s startDate=endDate
	f date=startDate:1:endDate d
	.s mrId="" f  s mrId=$o(^MRIPdaily("MRIP_DATE",date,mrId)) q:mrId=""  d
	..s locOrWardDr=$p(^MRIPdaily(mrId),"^",space)	;;科室或病区
	..q:(locOrWardDr="")&&(roleType="CTLOC")
	..q:(locOrWardDr="")&&(roleType="WARD")
	..q:((","_$g(depId)_",")'[(","_locOrWardDr_","))&&($g(depId)'="")
	..i roleType="CTLOC" d
	...s mHosId=$$GetHospId^DHCWLBuildDimDataCTLOC(locOrWardDr)
	...s subGrps=##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpByItemDr(locOrWardDr,"KSCRZ")
	...S subGrpCode=$p(subGrps,"^",2)
	..i roleType="WARD" d
	...s mHosId=$$GetHosIDByWard^DHCWLBuildDimDataWARD(locOrWardDr)
	...s subGrps=##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpByItemDr(locOrWardDr,"BQCRZ")
	...S subGrpCode=$p(subGrps,"^",2)
	..s mHosId=","_mHosId_","
	..q:((","_$g(hosId)_",")'[mHosId)&&($g(hosId)'="")
	..q:((","_$g(subDepId)_",")'[(","_subGrpCode_","))&&($g(subDepId)'="")
	..s dateDesc=$zd(date,3)
	..
	..s mrDetId="" f  s mrDetId=$o(^DHCMRIPDetail(0,"IPType",mrId,actionType,mrDetId)) q:mrDetId=""  d
	...s adm=$p(^DHCMRIPDetail(mrDetId),"^",1)
	...s papmi=$p(^PAADM(adm),"^",1)
	...s regNo=$$GetPapmiNo^DHCWLCommon(papmi)	//登记号
	...s medNo=##class(web.DHCWLStatisticsInterface).GetMedNoByAdm(adm)
	...s patName=$$GetPapmiName^DHCWLCommon(papmi)		//患者姓名
	...s patAge=##class(web.DHCBillInterface).GetPapmiAge(papmi,adm)  ;$$GetAge^DHCWLCommon(papmi)		//患者年龄
	...s patSex=$$GetSex^DHCWLCommon(papmi)		//患者年龄
	...i actionType="ZCKS" s zcDepDesc=$$GetRemarksKS^DHCWLBuildDimDataMRIPDetail(mrDetId)
	...e  s zcDepDesc=""
	...i actionType="ZRKS" s zrDepDesc=$$GetRemarksKS^DHCWLBuildDimDataMRIPDetail(mrDetId)
	...e  s zrDepDesc=""
	...
	...s ryLocDr="",ryDate=""
	...s ryrsDetId="" f  s ryrsDetId=$o(^DHCMRIPDetail(0,"TYPE","RYRS","ADM",adm,ryrsDetId)) q:ryrsDetId=""  d
	....s ryMrId=$p(^DHCMRIPDetail(ryrsDetId),"^",3)
	....s admLocDr=$p(^MRIPdaily(ryMrId),"^",space)
	....i admLocDr'="" s ryLocDr=admLocDr,ryDate=$p(^MRIPdaily(ryMrId),"^",6)
	...q:ryDate=""
	...s cyLocDr="",cyDate=""
	...i $d(^DHCMRIPDetail(0,"TYPE","CYRS","ADM")) d
	....s cyrsDetId="" f  s cyrsDetId=$o(^DHCMRIPDetail(0,"TYPE","CYRS","ADM",adm,cyrsDetId)) q:cyrsDetId=""  d
	.....s cyMrId=$p(^DHCMRIPDetail(cyrsDetId),"^",3)
	.....s disLocDr=$p(^MRIPdaily(cyMrId),"^",space)
	.....i disLocDr'="" s cyLocDr=disLocDr,cyDate=$p(^MRIPdaily(cyMrId),"^",6),disDate=cyDate
	...
	...i cyDate="" s cyDate=endDate,cyLocDesc=""
	...e  d
	....i roleType="CTLOC" s cyLocDesc=$$GetDepDesc^DHCWLBuildDimDataCTLOC(cyLocDr)
	....i roleType="WARD" s cyLocDesc=$$GetWardDesc^DHCWLBuildDimDataWARD(cyLocDr)
	...i actionType="TYRS" s cyDate=date
	...s inDays=cyDate-ryDate
	...i inDays<=0 s inDays=1
	...s ryDateDesc=$zd(ryDate,3)
	...i roleType="CTLOC" s ryLocDesc=$$GetDepDesc^DHCWLBuildDimDataCTLOC(ryLocDr)
	...i roleType="WARD" s ryLocDesc=$$GetWardDesc^DHCWLBuildDimDataWARD(ryLocDr)
	...i $g(disDate)'="" s cyDateDesc=$zd(disDate,3)
	...e  s cyDateDesc=""
	...s diag=##class(web.DHCWLStatisticsInterface).GetDiagByAdm(adm,"")
	...s diag=$p(diag,"^",1)
	...d OutRow
	
	
 	Quit $$$OK

	
OutRow
	s Data=$lb(adm,regNo,medNo,patName,patAge,patSex,ryDateDesc,cyDateDesc,dateDesc,ryLocDesc,cyLocDesc,inDays,zrDepDesc,zcDepDesc,diag)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QueryPatDetailForCRZClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPatDetailForCRZExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryPatDetailForCRZFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPatDetailForCRZExecute ]
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
