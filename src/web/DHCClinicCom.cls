Class web.DHCClinicCom Extends %RegisteredObject
{

/// /类方法通用执行函数
Query FindMethodValue(className As %String, methodName As %String, paraStr As %String) As %Query(ROWSPEC = "result:%String") [ SqlProc ]
{
}

ClassMethod FindMethodValueExecute(ByRef qHandle As %Binary, className As %String, methodName As %String, paraStr As %String) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	s methodValue=..GetMethodValue(className,methodName,paraStr,"")
	d OutputRow2
	s qHandle=$lb(0,repid,0)
	q $$$OK

OutputRow2
	s Data=$lb(methodValue)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindMethodValueFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMethodValueExecute ]
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

ClassMethod FindMethodValueClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMethodValueExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

ClassMethod GetMethodValue(className As %String, methodName As %String, paraStr As %String(MAXLEN=65535), Output retVal As %String(MAXLEN=65535)) As %String [ SqlProc ]
{
	//w ##class(web.DHCClinicCom).GetMethodValue("web.DHCICUCom","GetEditStat",8,.retValue)
	//w ##class(web.DHCClinicCom).GetMethodValue("web.DHCICUCom","GetWardInDateTime",""""",8,"""","""","" """,.retValue)
	s ^DHCCLTmp("GetMethodValue")=$g(className)_"/"_$g(methodName)_"/"_$g(paraStr)_"/"_$g(retVal)
	//s paraStr=$p(paraStr,",",1,$l(paraStr,",")-1)
	s retVal=""
	q:className="" -1
	q:methodName="" -2
	k ^DHCCLMethod("Value",$i)
	s inDirectStr=""
	i (paraStr="")!(paraStr=$c(0)) s inDirectStr="^DHCCLMethod(""Value"",$i)=##class("_className_")."_methodName_"()"
	e  s inDirectStr="^DHCCLMethod(""Value"",$i)=##class("_className_")."_methodName_"("_paraStr_")"
	w inDirectStr,!
	s @inDirectStr
	s retVal=$g(^DHCCLMethod("Value",$i))
	k ^DHCCLMethod("Value",$i)
	q retVal
}

/// 类方法分为通用、科室、病人、医嘱、检验五组
/// 第一组：通用
ClassMethod ConvertToDateH(dateStr As %String, defaultVal As %String = "$H") As %String
{
	q:((dateStr="")!(dateStr<0))&(defaultVal="") ""
	q:(dateStr="")!(dateStr<0) +$h
	s $zt="ERROR"
	i ($l(dateStr,"/")>2)&(dateStr>1900) s dateStr=$tr(dateStr,"/","-")
	i $l(dateStr,"/")>2 q $zdh(dateStr,4)
	i $l(dateStr,"-")>2 q $zdh(dateStr,3)

	q +dateStr
ERROR	; 
	q:(defaultVal="") ""
	q +$h
}

ClassMethod ConvertToTimeH(timeStr As %String, defaultVal As %String = "$H") As %String
{
	//q:timeStr="" $p($h,",",2)
	//i $l(timeStr,":")>1 q $zth(timeStr,3)
	//q +timeStr
	q:((timeStr="")!(timeStr<0)!(timeStr>86399))&(defaultVal="") ""
	q:((timeStr="")!(timeStr<0)!(timeStr>86399))&(defaultVal="0") 0
	q:((timeStr="")!(timeStr<0)!(timeStr>86399)) $p($h,",",2)
	i $l(timeStr,":")>1 d
		.s tmpHour=+$p(timeStr,":")
		.s tmpHour=$p(tmpHour,".")
		.q:(tmpHour<0)!(tmpHour>23)
		.s $p(timeStr,":")=tmpHour
		.s tmpMinute=+$p(timeStr,":",2)
		.s tmpMinute=$p(tmpMinute,".")
		.q:(tmpMinute<0)!(tmpMinute>59)
		.s $p(timeStr,":",2)=tmpMinute
		.s tmpSecond=+$p(timeStr,":",3)
		.s tmpSecond=$p(tmpSecond,".")
		.q:(tmpSecond<0)!(tmpSecond>59)
		.
		.s timeStr=$ZTH(tmpHour_":"_tmpMinute_":"_tmpSecond,3)
	q +timeStr
}

// 20170302+dyl

ClassMethod ConvertToDate(dateVal As %String, defaultStr As %String = "$H") As %String
{
	s dateformatnum=##class(websys.Conversions).DateFormat()
	q:((+dateVal=0)!(dateVal<0)!(dateVal>2980013))&(defaultStr="") ""
	q:(+dateVal=0)!(dateVal<0)!(dateVal>2980013) $zd($h,dateformatnum)
	q $zd(dateVal,dateformatnum)
}

// 20170302+dyl

ClassMethod ConvertToTime(dateVal As %String, defaultStr As %String = "$H") As %String
{
	//s timeformat=##class(websys.Conversion).TimeFormat()
	s timeformat=2
	q:(+dateVal=0) $zt(dateVal)
	q:((+dateVal=0)!(dateVal>86399)!(dateVal<0))&(defaultStr="") ""
	q:(+dateVal=0)!(dateVal>86399)!(dateVal<0) $zt($p($h,",",2),timeformat)
	q $zt(dateVal,timeformat)
}

ClassMethod ConvertToDateTime(dateVal As %String, timeVal As %String, defaultStr As %String = "$H") As %String
{
	quit:(+dateVal<=0)!(timeVal="") ""
	q (..ConvertToDate(dateVal,defaultStr))_" "_(..ConvertToTime(timeVal, defaultStr))
}

/// 数值时间比较，source晚于target返回1，小于返回-1，相等返回0
ClassMethod CompareDateTime(sourceDate, sourceTime, targetDate, targetTime) As %String
{
	i sourceTime="" s sourceTime=-1
	i targetTime="" s targetTime=86400
	s sourceDateTime=sourceDate+(sourceTime/100000)
	s targetDateTime=targetDate+(targetTime/100000)
	q:sourceDateTime>targetDateTime 1
	q:sourceDateTime<targetDateTime -1
	q 0
}

/// 时间差计算，返回类型type取日期"D",小时"H",分"M",秒"S"
ClassMethod CalculateDuration(sourceDate, sourceTime, targetDate, targetTime, type = "S") As %String
{
	i sourceTime="" s sourceTime=-1
	i targetTime="" s targetTime=86400
	s durationDay=targetDate-sourceDate
	i targetTime<sourceTime s durationDay=durationDay-1,targetTime=targetTime+86400
	q:type="D" durationDay
	q:type="H" durationDay*24+((targetTime-sourceTime)\3600)
	q:type="M" durationDay*1440+((targetTime-sourceTime)\60)
	q:type="S" durationDay*86400+(targetTime-sourceTime)
	q 0
}

/// 时间差调整，入参：日期值，时间值。返回：日期值^时间值
ClassMethod DateTimeAdd(date, time, addSecond) As %String
{
	q:date="" ""
	s adjDay=addSecond\86400
	s date=date+adjDay
	s addSecond=addSecond-(adjDay*86400)
	s time=time+addSecond
	i time>86399 s date=date+1,time=time-86400
	i time<0 s date=date-1,time=time+86400
	q date_"^"_time
}

ClassMethod GetSystemConfiguration() As %String
{
	// w ##class(web.DHCClinicCom).GetSysInfo()
	s str=$g(^websys.ConfigurationD(1))
	s DataNamespace=$lg(str,12)
	s LayoutManager=$lg(str,16)
	s LabDataNamespace=$lg(str,21)
	q DataNamespace_"^"_LayoutManager_"^"_LabDataNamespace_"^"
}

ClassMethod GetComDescByCode(type, code)
{
	q:(type="")!(code="") ""
	s codeId=0,desc=""
	f  s codeId=$o(^DHCCLComCode(type,codeId)) q:codeId=""  d
		.s ifActive=$p(^DHCCLComCode(type,codeId),"^",3)
		.q:(ifActive'="Y")&(ifActive'="")
		.q:code'=$p(^DHCCLComCode(type,codeId),"^",1)
		.s desc=$p(^DHCCLComCode(type,codeId),"^",2)
	q desc
}

ClassMethod GetVolumeCtuomId() As %String
{
	q $o(^CT("UOM",0,"Code","ML",""))
}

ClassMethod GetLiterVolumeCtuomId() As %String
{
	q $o(^CT("UOM",0,"Code","L",""))
}

ClassMethod GetVolume(oeoriId) As %String
{
	q:oeoriId="" 0

	s volumeCtuomId=..GetVolumeCtuomId()
	q:volumeCtuomId="" 0

	s oeordId=$p(oeoriId,"||",1),oeoriSub=$p(oeoriId,"||",2)
	q:oeoriSub="" 0
	s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
	q:arcimId="" 0

	s phOrdQty=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",12)
	s arcicOrderType=..GetOrdSubCatType(oeoriId)
	q:arcicOrderType'="R" 0

	s phcdfId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",12)
	q:phcdfId="" 0
	s phcdId=+phcdfId,phcdfSub=$p(phcdfId,"||",2)
	s baseUomId=$p($g(^PHCD(phcdId,"DF",phcdfSub,2)),"^",4)

	s doseQty=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",1)
	q:doseQty="" 0
	s unitUomId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",3)
	q:unitUomId="" 0
	q:unitUomId=volumeCtuomId doseQty

	s eqId=0,volumeEqQty=0
	f  s eqId=$o(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)) q:eqId=""  d
		.s eqUomId=+^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)
		.i eqUomId=volumeCtuomId s volumeEqQty=$p(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId),"^",2)
	q:volumeEqQty=0 0

	s baseVolume=doseQty*volumeEqQty
	q:unitUomId=baseUomId baseVolume

	s eqId=0,baseEqQty=0
	f  s eqId=$o(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)) q:eqId=""  d
		.s eqUomId=+^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)
		.i eqUomId=unitUomId s baseEqQty=$p(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId),"^",2)
	q:baseEqQty=0 0
	q baseVolume/baseEqQty
}

ClassMethod Replace(str As %String, subStr As %String, value As %String) As %String
{
	// eg. w ##class(web.DHCClinicCom).Replace("Value:{0}","{0}","Test")
	s i=$find(str,subStr)
	while(i>0)
	{
	s begin=i-$L(subStr)-1	
	s str=$E(str,1,begin)_value_$E(str,i,$L(str))
	s i=$find(str,subStr,begin+$L(value))
	}
	q str
}

ClassMethod SubStr(str As %String, from As %String, to As %String) As %String
{
	// eg. w ##class(web.DHCClinicCom).SubStr("持续注射泵(多巴胺)","(",")")
	// w ##class(web.DHCClinicCom).SubStr("xxx(aaa)","(",")")
	s startIndex=$find(str,from)
	s endIndex=$find(str,to)-2
	i endIndex<=0 s endIndex=$L(str)
	w startIndex," ",endIndex,!
	s str=$E(str,startIndex,endIndex)
	q str
}

ClassMethod GetCtcptType(userId As %String) As %String
{
	q:userId="" ""
	s ctctId=$p(^SSU("SSUSR",userId),"^",14)
	q:ctctId="" ""
	s ctcptId=$P(^CTPCP(ctctId,1),"^",4)
	q:ctcptId="" ""
	s ctcptType=$P(^CT("CPT",ctcptId),"^",4)
	q ctcptType
}

// 常用码表查找

Query LookUpComCode(type) As %Query(ROWSPEC = "tCode:%String,tDesc:%String") [ SqlProc ]
{
}

ClassMethod LookUpComCodeExecute(ByRef qHandle As %Binary, type) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	i type="" s type="Default"
	s codeId=0
	f  s codeId=$o(^DHCCLComCode(type,codeId)) q:codeId=""  d
		.s ifActive=$p(^DHCCLComCode(type,codeId),"^",3)
		.q:(ifActive'="Y")&(ifActive'="")
		.s tCode=$p(^DHCCLComCode(type,codeId),"^",1)
		.s tDesc=$p(^DHCCLComCode(type,codeId),"^",2)
		.d OutputRow2
	s qHandle=$lb(0,repid,0)
	q $$$OK

OutputRow2
	s Data=$lb(tCode,tDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod LookUpComCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpComCodeExecute ]
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

ClassMethod LookUpComCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpComCodeExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// 第二组：科室
ClassMethod GetLinkLocId(locId) As %String
{
	q:locId="" ""
	s linkSub=0,ctlocIdStr=""
	f  s linkSub=$o(^CTLOC(locId,"LINK",linkSub)) q:linkSub=""  d
		.i ctlocIdStr'="" s ctlocIdStr=ctlocIdStr_"^"
		.s ctlocIdStr=ctlocIdStr_^CTLOC(locId,"LINK",linkSub)
	q ctlocIdStr
}

/// Creator: CCQ
/// CreatDate: 2014-08-26
/// Description: 根据科室类型取科室  
/// Table：CT_Loc
/// Input：locTypeStr:科室类型代码字符串，以"^"连接
/// 		   W病区，E执行，D药房，OP手术，EM急诊，CL临床
/// Return：返回所查询科室ID:Id,科室名:Desc,科室代码:Code,
Query FindLocListByType(locTypeStr As %String = "W^E^D^OP^EM^CL") As %Query(ROWSPEC = "Id:%String,Code:%String,Desc:%String,Hospital:%String") [ SqlProc ]
{
}

ClassMethod FindLocListByTypeExecute(ByRef qHandle As %Binary, locTypeStr As %String = "W^E^D^OP^EM^CL") As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	s locId=""
	f  s locId=$o(^CTLOC(locId)) q:(locId="")  d
	.s locType=$p(^CTLOC(locId),"^",13)
	.q:("^"_locTypeStr_"^"'["^"_locType_"^")
	.s code=$p(^CTLOC(locId),"^",1)
	.s desc=$p(^CTLOC(locId),"^",2)
	.s hospitalId=$p(^CTLOC(locId),"^",22)
	.s hospital=""
	.i (hospitalId'="") s hospital=$p($g(^CT("HOSP",hospitalId)),"^",2)
	.d OutputLocRow
	s qHandle=$lb(0,repid,0)
	q $$$OK

OutputLocRow
	s Data=$lb(locId,code,desc,hospital)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindLocListByTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocListByTypeExecute ]
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

ClassMethod FindLocListByTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocListByTypeExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCClinicCom","FindLocList","mzs","OUTOP^EMOP","")

/// Creator: yupeizhi
/// CreatDate: 2010-04-20
/// Description: 根据科室列表取科室  
/// 代码:"INOPDEPT"住院手术科室,"OUTOPDEPT"门诊手术科室,"EMOPDEPT"急诊手术科室,"AN"麻醉科,"OP"手术室,
/// "OUTAN"门诊麻醉科,"OUTOP"手术室,"EMAN"门诊麻醉科,"EMOP"手术室,"ICU"重症科室
/// Table：CT_Loc
/// Input：desc:手术科室描述
/// Return：返回所查询科室ID:ctlocId,科室名:ctlocDesc,科室代码:ctlocCode,
/// 2012.4.17 增加显示医院
Query FindLocList(desc As %String, locListCodeStr As %String = "", EpisodeID As %String = "", hospId As %String = "") As %Query(ROWSPEC = "ctlocId:%String,ctlocDesc:%String,ctlocCode:%String,hospital:%String") [ SqlProc ]
{
}

ClassMethod FindLocListExecute(ByRef qHandle As %Binary, desc As %String, locListCodeStr As %String = "INOPDEPT", EpisodeID As %String = "", hospId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	;转吧，汉字不方便
	s find=0
	s desc=##class(web.DHCClinicCom).GetChinaChar(desc)
	s desc=$$ALPHAUP^SSUTIL4(desc)
	s locListCodeStr=..AdjustLocListCode(locListCodeStr,EpisodeID)
	s ctlocIdList=..GetLocIdByLocListCode(locListCodeStr)
	f i=1:1:$l(ctlocIdList,"^") d
		.s ctlocId=$p(ctlocIdList,"^",i)
		.q:ctlocId=""
		.q:'$d(^CTLOC(ctlocId))
		.s ctlocDesc=$p(^CTLOC(ctlocId),"^",2)
		.q:(desc'="")&($$ALPHAUP^SSUTIL4(##class(web.DHCClinicCom).GetChinaChar(ctlocDesc))'[desc)
		.s ctlocCode=$p(^CTLOC(ctlocId),"^",1)
		.s ctlocStatDate=$p(^CTLOC(ctlocId),"^",24) //开始日期 add mfc 20201112
		.q:(ctlocStatDate'="")&&(ctlocStatDate>+$h)
		.s ctlocEndDate=$p(^CTLOC(ctlocId),"^",25) //结束日期
		.q:(ctlocEndDate'="")&&(ctlocEndDate<+$h)
		.s hospitalDR=$p(^CTLOC(ctlocId),"^",22)
		.q:(hospId'="")&(hospitalDR'="")&(hospId'=hospitalDR)
		.s find=1
		.Do OutputRow6
	i (find=0)!(ctlocIdList="") d
		.s ctlocrowid="" f  s ctlocrowid=$o(^CTLOC(ctlocrowid)) q:ctlocrowid=""  d
			..q:'$d(^CTLOC(ctlocrowid))
			..;b	;in
			..s ctlocDesc=$p(^CTLOC(ctlocrowid),"^",2)
			..;w ##class(web.DHCClinicCom).GetChinaChar(ctlocDesc)_"/"
			..q:(desc'="")&($$ALPHAUP^SSUTIL4(##class(web.DHCClinicCom).GetChinaChar(ctlocDesc))'[desc)
			..s ctlocId=ctlocrowid
			..s ctlocStatDate=$p(^CTLOC(ctlocrowid),"^",24) //开始日期add mfc 20201112
			..q:(ctlocStatDate'="")&&(ctlocStatDate>+$h)
			..s ctlocEndDate=$p(^CTLOC(ctlocrowid),"^",25) //结束日期
			..q:(ctlocEndDate'="")&&(ctlocEndDate<+$h)
			..s hospitalDR=$p(^CTLOC(ctlocrowid),"^",22)
			..q:(hospId'="")&(hospitalDR'="")&(hospId'=hospitalDR)
			..Do OutputRow6	 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow6
	set Data=$lb(ctlocId,ctlocDesc,ctlocCode,hospital)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod FindLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocListExecute ]
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

ClassMethod FindLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator: CCQ
/// CreatDate: 2014-08-28
/// Description: 根据用户ID取用户信息
/// Table：SS_User
/// Return：用户ID:Id,用户账号:Account,用户名称:Name,用户医护人员类型:CtcptType,
Query FindUserById(userId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select %ID as Id, 
		   SSUSR_Initials as Account,
		   SSUSR_Name as Name,
		   SSUSR_CareProv_DR->CTPCP_CarPrvTp_DR->CTCPT_InternalType as CtcptType,
		   SSUSR_CareProv_DR as CareprovId,
		   SSUSR_CareProv_DR->CTPCP_Desc as CareprovDesc 
		   from SQLUser.SS_User where %ID=:userId
}

// w ##class(web.DHCClinicCom).GetUserInfoByInitials(1)

ClassMethod GetUserInfoByInitials(ssusrInitials As %String) As %String
{
	set userId=..GetUserIdByInitials(ssusrInitials)
	set userInfo=""
	if (+userId>0)
	{
		set userInfo=..GetUserTypeName(userId)
	}	
	
	quit userInfo
}

/// 20120717+dyl
/// input locId:科室id；userId:用户id
/// d ##class(%ResultSet).RunQuery("web.DHCClinicCom","FindUserByLoc",15,"6536")
Query FindUserByLoc(locId, userId = "") As %Query(ROWSPEC = "CareprovId,CareprovDesc,Id,Name,Account,GroupId,CtcptType,CtcptTyDesc") [ SqlProc ]
{
}

ClassMethod FindUserByLocExecute(ByRef qHandle As %Binary, locId, userId = "") As %Status
{
	s repid=$I(^CacheTemp)	
	s ind=1
	i locId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	i userId="" s needCtcptType=""
	e  d
		.s ctpcpId=$p($g(^SSU("SSUSR",userId)),"^",14)
		.i ctpcpId'="" d
			..s ctcptId=$P($g(^CTPCP(ctpcpId,1)),"^",4)  ;CTPCP_CarPrvTp_DR
			..i ctcptId'="" d
				...s ctcptInternalType=$P($g(^CT("CPT",ctcptId)),"^",4)  ;CT_CarPrvTp:CTCPT_InternalType
				...s needCtcptType=ctcptInternalType
	i needCtcptType'="" s needCtcptType=$$ALPHAUP^SSUTIL4(needCtcptType) //将用户类型转换大写格式
	i (userId'="")&(needCtcptType="") s needCtcptType="OTHER"
	s locIdList=locId_"^"_..GetLinkLocId(locId)
	k ^tmpUserByLoc("UserId")
	f i=1:1:$l(locIdList,"^") d
		.s curLocId=$p(locIdList,"^",i)
		.q:+curLocId=0
		.s resId=""
		.f  s resId=$O(^RB("RES",0,"CTLOC",curLocId,resId))  q:resId=""  d
			..;医护人员Id
			..q:($p(^RB("RES",resId),"^",19)'="")&($p(^RB("RES",resId),"^",19)<$h)
			..s ctcpId=$P(^RB("RES",resId),"^",2)
			..q:ctcpId=""
			..s ctcptDesc=$p($g(^CTPCP(+ctcpId,1)),"^",2)
			..s ctcptTpDesc=$g(^CTPCP(ctcpId,"DHCCL")) //获取医生实际工作职称
			..;医护人员类型
			..s ctcptId=$p($g(^CTPCP(ctcpId,1)),"^",4)
			..q:ctcptId=""
			..s ctcptType=$p($g(^CT("CPT",ctcptId)),"^",4)			
			..// 2014-10-21 根据医护人员类型查找医护人员 
			..//q:((needCtcptType'="")&&(needCtcptType'="OTHER")&&(ctcptType'=""))!((needCtcptType'="")&&(needCtcptType'="DOCTOR")&&(needCtcptType'=ctcptType))!((needCtcptType'="")&&(needCtcptType'="NURSE")&&(needCtcptType'=ctcptType))
			..i ((needCtcptType="")!((needCtcptType="OTHER")&&(ctcptType=""))) s exitFlag1=0
			..e  d  s exitFlag1=1
			..i ((needCtcptType="")!((needCtcptType="DOCTOR")&&(needCtcptType=ctcptType))) s exitFlag2=0
			..e  d  s exitFlag2=1
			..i ((needCtcptType="")!((needCtcptType="NURSE")&&(needCtcptType=ctcptType))) s exitFlag3=0
			..e  d  s exitFlag3=1
			..q:(exitFlag1=1)&&(exitFlag2=1)&&(exitFlag3=1)
			..;UserId
			..s userId=$o(^SSU("SSUSR",0,"CTPCP",ctcpId,""))
			..q:userId=""
			..s userName=$p($g(^SSU("SSUSR",userId)),"^",2)
			..s userStatDate=$p($g(^SSU("SSUSR",userId)),"^",96) //20201130开始日期
			..q:(userStatDate'="")&&(userStatDate>+$h)
			..s userEndDate=$p($g(^SSU("SSUSR",userId)),"^",97) //20201130截止日期
			..q:(userEndDate'="")&&(userEndDate<+$h)
			..;登录号？
			..;s ssusrInitials=$o(^SSU("SSUSR",0,"SSUSR_Initials",ctcpId,""))
			..s ssusrInitials=$p($g(^SSU("SSUSR",userId)),"^",1)
			..;默认登录安全组Id
			..s groupId=$p($g(^SSU("SSUSR",userId)),"^",5)
			..s tmpLId=""
			..;其他登录安全组
			..f  s tmpLId=$o(^SSU("SSUSR",userId,"OTHLL",tmpLId))   q:tmpLId=""  d
				...q:$d(^SSU("SSUSR",userId,"OTHLL",tmpLId))<1
				...;登录科室Id
				...s tmpLocId=$p(^SSU("SSUSR",userId,"OTHLL",tmpLId),"^",1)
				...q:tmpLocId'=curLocId
				...;登录安全组Id
				...s tmpGroupId=$p($g(^SSU("SSUSR",userId,"OTHLL",tmpLId)),"^",2)
				...i (tmpGroupId'="")&(("^"_groupId_"^")'[("^"_tmpGroupId_"^")) d
					....i groupId'="" s groupId=groupId_"^"
					....s groupId=groupId_tmpGroupId
			..q:("^"_$g(^tmpUserByLoc("UserId"))_"^")[("^"_userId_"^") //屏蔽重复的人员
			..i $g(^tmpUserByLoc("UserId"))="" s ^tmpUserByLoc("UserId")=userId
			..e  s ^tmpUserByLoc("UserId")=$g(^tmpUserByLoc("UserId"))_"^"_userId
			..d OutputRow
		.s clcpRowId=""	//20140806添加其他医护人员	
		.f  s clcpRowId=$o(^DHCCLCPI("CtLoc",curLocId,clcpRowId)) q:clcpRowId=""  d		    
 			..s ctlocdesc=$p($g(^CTLOC(curLocId)),"^",2)
 			..s desc=$li(^DHCCLCP(clcpRowId),2)
 			..s alias=$li(^DHCCLCP(clcpRowId),3)
 			..s fdate=$li(^DHCCLCP(clcpRowId),4) 			
 			..s tdate=$li(^DHCCLCP(clcpRowId),5) 			
 			..q:(tdate'="")&&(tdate<+$h) 			
 			..s inActive=$li(^DHCCLCP(clcpRowId),6)
 			..q:(inActive'="")&&(inActive=1) 			 
 			..s ifDoc=$li(^DHCCLCP(clcpRowId),7) 		
 			..s ifDocDes=""
 			..i ifDoc=0 s ifDocDes="NURSE"
 			..e  s ifDocDes="DOCTOR"
 			..s ctcpId=alias,ctcptDesc=desc,userId=alias,userName=desc,ssusrInitials=alias,groupId="",ctcptType=ifDocDes,ctcptTpDesc=""
			..d OutputRow		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow
	set Data=$lb(ctcpId,ctcptDesc,userId,userName,ssusrInitials,groupId,ctcptType,ctcptTpDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindUserByLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindUserByLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindUserByLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindUserByLocExecute ]
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

/// Creator：      	陈长青
/// CreatDate：    	2013-11-20
/// Description： 	获取所有申请科室的医护人员集合(手术医生或麻醉医生可能取轮转的医生)
/// Table：        	
/// Input：        	needCtcpDesc：医护人员姓名筛选字符串，locListCodeStr：医护人员科室代码字符串，locDescOrId：医护人员科室名称或ID
/// 					EpisodeID：手术病人就诊ID，opaId：手术申请排班ID，ifDoctor：只查询医生，ifSurgeon：只查询主刀医生
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCClinicCom","FindCareProvider","郑","AN^OUTAN^EMAN^INOPDEPT^OUTOPDEPT^EMOPDEPT","","","","Y","")
Query FindCareProvider(needCtcpDesc As %String, locListCodeStr As %String, locDescOrId As %String = "", EpisodeID As %String = "", opaId As %String = "", ifDoctor As %String = "", ifSurgeon As %String = "") As %Query(ROWSPEC = "Id,Desc,Alias,DeptDesc") [ SqlProc ]
{
}

ClassMethod FindCareProviderExecute(ByRef qHandle As %Binary, needCtcpDesc As %String, locListCodeStr As %String, locDescOrId As %String = "", EpisodeID As %String = "", opaId As %String = "", ifDoctor As %String = "", ifSurgeon As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^TMPCTCP($j)
	i needCtcpDesc=$c(0) s needCtcpDesc=""
	s needCtcpDesc=$$ALPHAUP^SSUTIL4(needCtcpDesc)
	s ctlocIdList=""
	i locDescOrId'="" d
		.i locDescOrId=+locDescOrId s ctlocIdList=locDescOrId
		.e  d
			..s locDesc=$$ALPHAUP^SSUTIL4(locDescOrId)
			..s ctlocIdList=$o(^CTLOC(0,"Desc",locDesc,""))
	i EpisodeID="",opaId'="" s EpisodeID=$P($g(^DHCANOPArrange(opaId)),"^",1)
	s locListCodeStr=..AdjustLocListCode(locListCodeStr,EpisodeID)
	i ctlocIdList="" s ctlocIdList=..GetLocIdByLocListCode(locListCodeStr)
	i needCtcpDesc="",ctlocIdList="" s ind=1 s qHandle=$lb(0,repid,0) Quit $$$OK
	
	//查询提示已安排手术间的麻醉科医生、手术室护士
	i ((locListCodeStr_"^")["AN^")!((locListCodeStr_"^")["OP^") d
		.s opaStartDate=$p($g(^DHCANOPArrange(+opaId)),"^",14)
		.q:opaStartDate=""
    	.k ctcpList
    	.s opaId=""
    	.f  s opaId=$O(^DHCANOPArrange(0,"SDate",+opaStartDate,opaId)) q:opaId=""  d 
	    	..q:'$d(^DHCANOPArrange(opaId))
	    	..s oprId=$P($G(^DHCANOPArrange(opaId)),"^",20)
    		..q:oprId=""
    		..s oprDesc=$p($G(^DHCANC("OPRoom",oprId)),"^",2)
	    	..s anaId=$P(^DHCANOPArrange(opaId),"^",2)
	    	..s EpisodeID=+anaId
	    	..s anaSub=$p(anaId,"||",2)
	    	..i ((locListCodeStr_"^")]"AN^") d
	    		...s anaSuperCtcpId=$P(^OR(EpisodeID,"ANA",anaSub),"^",7)
	    		...d SetCtcp(anaSuperCtcpId,oprDesc)
	    		...s anaesthCtcpId=$P(^OR(EpisodeID,"ANA",anaSub),"^",6)
	    		...d SetCtcp(anaesthCtcpId,oprDesc)
	    		...s anaopSub=0 
				...f  s anaopSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:(anaopSub="")  d
		    		....i $P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",12)'="M" q
		    		....s anassSub=0
		    		....i $P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",12)'="M" q
		    		....f  s anassSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",anassSub)) q:anassSub=""  d
		        		.....s ctcpId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",anassSub),"^")
		        		.....d SetCtcp(ctcpId,oprDesc)
	    	..q:(locListCodeStr_"^")'["OP^"
	    	..s anaopSub=0 
			..f  s anaopSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:(anaopSub="")  d
		    	...i $P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",12)'="M" q
		    	...s scnSub=0
		    	...f  s scnSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",scnSub)) q:scnSub=""  d
		        	....s ctcpId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",scnSub),"^")
		        	....d SetCtcp(ctcpId,oprDesc)
		    	...s cirnSub=0
		    	...f  s cirnSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CIRN",cirnSub)) q:cirnSub=""  d
		        	....s ctcpId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CIRN",cirnSub),"^")
		        	....d SetCtcp(ctcpId,oprDesc)
	s ctcptIdStr=$g(^DHCCLSet("AnOp","OpDocTp")) //能为主刀医师的医护人员类型
	s alias=""
	f i=1:1:$l(ctlocIdList) d
		.s ctlocId=$p(ctlocIdList,"^",i)
		.q:ctlocId=""
		.s ctLocDesc=$p($g(^CTLOC(ctlocId)),"^",2)
		.s resId=""
		.f  s resId=$O(^RB("RES",0,"CTLOC",ctlocId,resId))  q:resId=""  d
			..s ctcpId=$P(^RB("RES",resId),"^",2)
			..q:ctcpId=""
			..s ctcptId=$p($g(^CTPCP(ctcpId,1)),"^",4)
			..q:ctcptId=""
			..q:(ifSurgeon="Y")&((locListCodeStr_"^")["OPDEPT^")&((ctcptIdStr'="")&(("^"_ctcptIdStr_"^")'[("^"_ctcptId_"^")))
			..s ctcptType=$p($g(^CT("CPT",ctcptId)),"^",4)
			..q:(ifDoctor'="")&(ifDoctor="Y")&(ctcptType'="DOCTOR")
			..q:(ifDoctor'="")&(ifDoctor'="Y")&(ctcptType'="NURSE")
			..//s ctcpDesc=$p($g(^CTPCP(ctcpId,1)),"^",2)
			..s ctcpDesc=..GetNameById(ctcpId)
			..s alias=##class(web.DHCClinicCom).GetChinaChar(ctcpDesc)
			..s alias=$$ALPHAUP^SSUTIL4(alias)
			..s needCtcpDesc=$$ALPHAUP^SSUTIL4(needCtcpDesc)
			..q:($p(alias,needCtcpDesc)'="")&($p(ctcpDesc,needCtcpDesc)'="")&(needCtcpDesc'="")&(##class(web.UDHCANOPArrange).MatchName(ctcpId,needCtcpDesc)=0)
			..s ctcpDesc=ctcpDesc_$g(ctcpList(ctcpId))
			..s ctcpAlias=$p($g(^CTPCP(ctcpId,3)),"^",28)
			..s ^TMPCTCP($j,1,ctcpId)=$lb(ctcpId,ctcpDesc,ctcpAlias,ctLocDesc)
			..;Do Outputcpt
		.s ctcptOtherId = ""
		.s list = ##class(web.UDHCANOPArrange).FindOtherCtcp(ctlocId,needCtcpDesc,ifDoctor) //liangqi 100906 查询外院医护人员
		.q:list.Size=""
		.f j=1:1:list.Size d
		..s str = list.GetAt(j)
		..s ctcptOtherId = "~"_$p(str,"^",1)
		..s ctcpDesc = $p(str,"^",2)_$g(ctcpList(ctcptOtherId))
		..s ctcpAlias=$p(str,"^",3)
		..s ^TMPCTCP($j,2,ctcptOtherId)=$lb(ctcptOtherId,ctcpDesc,ctcpAlias,ctLocDesc)
		..;d Outputothercpt
		s n="" 
		f  s n=$o(^TMPCTCP($j,n)) q:n=""  d
		.s ctcptId=""  f  s ctcptId=$o(^TMPCTCP($j,n,ctcptId)) q:ctcptId=""  d
		..d Outputcpt
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
SetCtcp(ctcpId,oprDesc)
	q:(ctcpId="")
	q:$g(ctcpList(ctcpId))[("("_oprDesc_")")
	s ctcpList(ctcpId)=$g(ctcpList(ctcpId))_"("_oprDesc_")"
	q

Outputcpt
 set Data=$lb(ctcpId,ctcpDesc)
 Set ^CacheTemp(repid,ind)=^TMPCTCP($j,n,ctcptId)
 Set ind=ind+1
 quit
}

ClassMethod FindCareProviderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCareProviderExecute ]
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

ClassMethod FindCareProviderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCareProviderExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod AdjustLocListCode(locListCodeStr As %String, EpisodeID As %String) As %String
{
	q:EpisodeID="" locListCodeStr
	s admType=$p($g(^PAADM(EpisodeID)),"^",2)
	q:admType="" locListCodeStr
	s admTypeStr=""
	i admType="O" s admTypeStr="OUT"
	i admType="E" s admTypeStr="EM"
	f i=1:1:$l(locListCodeStr,"^") d
		.s locListCode=$p(locListCodeStr,"^",i)
		.i admTypeStr'="",$p(locListCode,admTypeStr)'="" s $p(locListCodeStr,"^",i)=""
		.i (admTypeStr="")&($p(locListCode,"OUT")=""!($p(locListCode,"EM")="")) s $p(locListCodeStr,"^",i)=""
	q locListCodeStr
}

/// w ##class(web.DHCClinicCom).GetLocIdByLocListCode("OP^OUTOP^EMOP")
ClassMethod GetLocIdByLocListCode(locListCodeStr As %String) As %String
{
	q:locListCodeStr="" ""
	s ctlocIdList=""
	f i=1:1:$l(locListCodeStr,"^") d
		.s locListCode=$p(locListCodeStr,"^",i)
		.q:locListCode=""
		.s locListId=$o(^CT("LL",0,"Code",locListCode,""))
		.q:locListId=""
		.s locListLocId=0
		.f  s locListLocId=$o(^CT("LL",locListId,"LOC",locListLocId)) q:locListLocId=""  d
			..s ctlocId=$p(^CT("LL",locListId,"LOC",locListLocId),"^")
			..q:ctlocId=""
			..q:'$d(^CTLOC(ctlocId))
			..s LocArray(ctlocId)=ctlocId
	s CtlocId="" f  s CtlocId=$o(LocArray(CtlocId)) q:CtlocId=""  d
	.i ctlocIdList'="" s ctlocIdList=ctlocIdList_"^"
	.s ctlocIdList=ctlocIdList_CtlocId
	q ctlocIdList
}

/// 第三组：病人
/// 根据出生日计算年龄
/// 后两个参数默认返回：一月以下只返回日;一月以上三月以下返回月和日;三月到一岁以下只返回月，一岁到三岁以下只返回年和月;三岁以上只返回岁。
/// 参数ifExact为1，返回完整的年月日;retAgeType("Y"返回年,"M"返回月,"D"返回天)
ClassMethod CalAge(iBirth As %String, iDate As %String, ifExact = 0, retAgeType = "") As %String
{
	i iBirth>2980000 s iBirth=""
	i iBirth<0 s iBirth=""
	q:iBirth="" ""
	s dayDiff=iDate-iBirth
	q:dayDiff<0 ""
	q:retAgeType="D" dayDiff_"日"
	s XBirth=$ZD(iBirth)
	s XToday=$ZD(iDate)
	s ageMonth=XToday-XBirth
	s ageDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
	s currYear=$p(XToday,"/",3) s:currYear<100 currYear=currYear+1900
	s birthYear=$p(XBirth,"/",3) s:birthYear<100 birthYear=birthYear+1900
	s ageYear=currYear-birthYear
	i ageDay<0 d
		. s ageMonth=ageMonth-1
		. s ageDay=ageDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
		. q:XToday'=2
		. s:((currYear#4)=0)&(((currYear#100)'=0)!((currYear#400)=0)) ageDay=ageDay+1
	i ageMonth<0 s ageMonth=ageMonth+12,ageYear=ageYear-1
	q:retAgeType="M" (ageYear*12+ageMonth)_"月"
	q:retAgeType="Y" ageYear_"岁"
	q:ifExact ageYear_"岁"_ageMonth_"月"_ageDay_"天"
	s retAge=""
	i (ageYear>0) d
		.s retAge=ageYear_"岁"
		.i ageYear<3 s retAge=retAge_ageMonth_"月"
	e  d
		.i (ageMonth>0) d 
			..s retAge=ageMonth_"月"
			..i ageMonth<3 s retAge=retAge_ageDay_"日"
		.e  d
			..s retAge=ageDay_"日"
	q retAge
}

ClassMethod GetPatientEpisodeID(regNo, papmiId = "", fromDate = "", toDate = "", needAdmType = "I") As %String
{
	q:(regNo="")&(papmiId="") ""
	s fromDate=..ConvertToDateH(fromDate,"")
	s toDate=..ConvertToDateH(toDate,"")
	i papmiId="" s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),""))
	q:papmiId="" ""
	s EpisodeIDList=""
	i needAdmType["I" d
		.s EpisodeID=""
		.f  s EpisodeID=$o(^PAPERdr(papmiId,"ADM","I",EpisodeID),-1) q:EpisodeID=""  d
			..q:'$d(^PAADM(EpisodeID))
			..s paadmVisitStatus=$p($g(^PAADM(EpisodeID)),"^",20)
			..q:(paadmVisitStatus'="A")&(paadmVisitStatus'="D")
			..s admDate=$p($g(^PAADM(EpisodeID)),"^",6)
			..q:(fromDate'="")&(admDate<fromDate)
			..q:(toDate'="")&(admDate>toDate)
			..i EpisodeIDList'="" s EpisodeIDList=EpisodeIDList_"^"
			..s EpisodeIDList=EpisodeIDList_EpisodeID
	i needAdmType["O" d
		.s EpisodeID=""
		.f  s EpisodeID=$o(^PAPERdr(papmiId,"ADM","O",EpisodeID),-1) q:EpisodeID=""  d
			..q:'$d(^PAADM(EpisodeID))
			..s paadmVisitStatus=$p($g(^PAADM(EpisodeID)),"^",20)
			..q:(paadmVisitStatus'="A")&(paadmVisitStatus'="D")
			..s admDate=$p($g(^PAADM(EpisodeID)),"^",6)
			..q:(fromDate'="")&(admDate<fromDate)
			..q:(toDate'="")&(admDate>toDate)
			..i EpisodeIDList'="" s EpisodeIDList=EpisodeIDList_"^"
			..s EpisodeIDList=EpisodeIDList_EpisodeID
	q EpisodeIDList
}

ClassMethod GetRegNobyEpisodeID(EpisodeID)
{
	q:$g(EpisodeID)="" ""
	q:'$d(^PAADM(EpisodeID)) ""
	s PaitentID=$p(^PAADM(EpisodeID),"^",1)
	s admType=$p(^PAADM(EpisodeID),"^",2)

	q:$g(PaitentID)="" ""
	q:'$D(^PAPER(PaitentID,"PAT",1)) ""
	q:admType="I" $p(^PAPER(PaitentID,"PAT",1),"^",1)
	q $p(^PAPER(PaitentID,"PAT",1),"^",2)
}

ClassMethod GetAdmTransWardList(EpisodeID, transWardList) As %String
{
	k transWardList
	q:EpisodeID="" "就诊号为空!"
	s preWardId="",transSub=0,preDateTime=0
	f  s transSub=$O(^PAADM(EpisodeID,"TRANS",transSub)) q:transSub=""  d
		.s transWardId=$P(^PAADM(EpisodeID,"TRANS",transSub),"^",9)
		.q:(transWardId="")!(transWardId=preWardId)
		.s dateTime=^PAADM(EpisodeID,"TRANS",transSub)+($p(^PAADM(EpisodeID,"TRANS",transSub),"^",2)/100000)
		.i preDateTime>dateTime s dateTime=preDateTime+0.00001
		.s transWardList(dateTime)=transWardId
		.//w transWardList(dateTime)_"/"_dateTime,!
		.s preWardId=transWardId
		.s preDateTime=dateTime
	q 0
}

/// 按时间找当前病区的最早转入时间
ClassMethod GetWardInDateTime(EpisodeID, date = "", time = "", delimiter = "^") As %String
{
	q:(EpisodeID="") "^"
	s needWardId=""
	i date="" d
		.s date=+$h,time=$p($h,",",2)
	s dateTime=date+(time/100000)

	s transDate="",transTime="",startDate="",startTime=""
	s transSub="",exitMark=0
	f  s transSub=$O(^PAADM(EpisodeID,"TRANS",transSub),-1) q:(+transSub=0)!(exitMark)  d
		.s transWardId=$P(^PAADM(EpisodeID,"TRANS",transSub),"^",9)
		.q:(transWardId="")
		.s transDate=$p(^PAADM(EpisodeID,"TRANS",transSub),"^",1)
		.s transTime=$p(^PAADM(EpisodeID,"TRANS",transSub),"^",2)
		.s transDateTime=transDate+(transTime/100000)
		.q:dateTime<transDateTime
		.i needWardId="" s needWardId=transWardId
		.i transWardId'=needWardId s exitMark=1 q
		.s startDate=transDate,startTime=transTime
	//q:(startDate="")!(startTime="") "该病人转病区信息有误!"
	q ..ConvertToDate(startDate,"")_delimiter_..ConvertToTime(startTime,"")
}

/// 返回病人第指定时间科室、病区、房间、床位
ClassMethod GetTransInfoByTime(EpisodeID, date = "", time = "") As %String
{
	s date=..ConvertToDateH(date)
	s time=..ConvertToTimeH(time)
	s curCtlocId=""
	s curWardId=""
	s curRoomId=$p(^PAADM(EpisodeID),"^",69)
	s curBedId=$p($g(^PAADM(EpisodeID)),"^",73)
	s needDateTime=date+(time/100000)
	s i=0
	s preCtlocId="",preWardId=""
	s stdate=$P(^PAADM(EpisodeID),"^",6)
	s transSub=0,quitMark=0
	f  s transSub=$O(^PAADM(EpisodeID,"TRANS",transSub)) q:(transSub="")!(quitMark)  d
		.s startDate=$P(^PAADM(EpisodeID,"TRANS",transSub),"^",1)
		.s startTime=$P(^PAADM(EpisodeID,"TRANS",transSub),"^",2)
		.s startDateTime=startDate+(startTime/100000)
		.i startDateTime>needDateTime s quitMark=1 q
		.
		.s transLocId=$P(^PAADM(EpisodeID,"TRANS",transSub),"^",6)
		.i transLocId'="" d
			..q:curCtlocId=transLocId
			..s preCtlocId=curCtlocId
			..s curCtlocId=transLocId
		.s transWardId=$P(^PAADM(EpisodeID,"TRANS",transSub),"^",9)
		.i transWardId'="" d
			..q:curWardId=transWardId
			..s preWardId=curWardId
			..s curWardId=transWardId
		.s transBedId=$P(^PAADM(EpisodeID,"TRANS",transSub),"^",8)
		.i transBedId'="" s curBedId=transBedId
		.s transRoomId=$P(^PAADM(EpisodeID,"TRANS",transSub),"^",7)
		.i transRoomId'="" s curRoomId=transRoomId
	i curCtlocId="" s curCtlocId=$p(^PAADM(EpisodeID),"^",4)
	i curWardId="" s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)
	q curCtlocId_"^"_curWardId_"^"_curRoomId_"^"_curBedId_"^"_preCtlocId_"^"_preWardId
}

/// Creator: wangxinlei
/// CreatDate: 2009-08-18
/// Description: 取血型
/// Table：CTBB_BloodGroup
/// Input：regNo: 病人登记号
/// Return：返回血型与Rh阴阳性
ClassMethod GetBloodType(regNo As %String) As %String
{
	q:regNo="" ""
	s bldGpId=""
	i $d(^TDEB(regNo)) d
		.s bldGpId=$p($G(^TDEB(regNo)),"\",4)
		.i '$l(bldGpId) d
			..s bldGpId=$p($g(^TDEB(regNo)),"\",10)
	s BG="",Rh=""
	i $l(bldGpId) d
		.s BG=$p(^TTAB("BB-BG",bldGpId),"\",2)_"型"
		.;i $p(^TTAB("BB-BG",bldGpId),"\",3)="P" s Rh="阳性(+)"
		.;i $p(^TTAB("BB-BG",bldGpId),"\",3)="N" s Rh="阴性(-)"
	s BGRh=BG_Rh
	q BGRh
}

ClassMethod GetMedicareNo(papmiId, EpisodeID) As %String
{
	q:(papmiId="")&(EpisodeID="") ""
	i papmiId="" s papmiId=+$g(^PAADM(+EpisodeID))
	q:papmiId="" ""
	//s medicareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	i EpisodeID="" &sql(select PAADM_RowID into :EpisodeID from sqlUser.PA_Adm WHERE PAADM_PAPMI_DR=:papmiId)
	q:EpisodeID="" ""
	s paadmtype=$p($g(^PAADM(EpisodeID)),"^",2)
	s medicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,paadmtype,.ErrMsg)
	//s tmpMedicareNo=##Class(web.DHCWMRService).IGetMrNoByEpisodeID(EpisodeID) //2010用
	//i tmpMedicareNo'<0 medicareNo=tmpMedicareNo //2010用
	q medicareNo
}

ClassMethod PatInfo(curId, transLocNum = "", date = "", time = "") As %String
{
	//取病人第transLocNum次转科的基本信息;
	//入参:1. "^"分隔第二部分为admId，第一个分隔部分为登记号或OEORI_ROWID
	//2. 如果admId为空,按登记号或OEORI_ROWID取
	//3. 登记号根据最后一个ADM取信息；
	//n (curId,transLocNum)
	q:curId="" ""
	s admId=$p(curId,"^",2)
	s curId=$p(curId,"^")
	q:(curId="")&(admId="")
	i admId="" d
		.s oriSub=$p(curId,"||",2)
		.i oriSub'="" d //医嘱项
			..s oeordId=$p(curId,"||",1)
			..s admId=$p($g(^OEORD(oeordId)),"^",1)
		.e  d  ;登记号
			..s papmiId=""
			..s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(curId),"")) 
			..i papmiId="" s admId="" q
			..
			..s admType="",preAdm=""
			..f  s admType=$o(^PAPERdr(papmiId,"ADM",admType),-1) q:admType=""  d
				...s admId="" f  s admId=$o(^PAPERdr(papmiId,"ADM",admType,admId),-1) q:(admId="")  d
					....s pavisit=$p($g(^PAADM(admId)),"^",20)
					....q:(pavisit'="A")&(pavisit'="D")
					....s preAdm=admId
					....s admId=0,admType=0
			..s admId=preAdm  //重置admId
	q:admId="" ""  //ypz 060516

	s papmiId=+$g(^PAADM(+admId))
	q:papmiId=0 ""
	s secAlias="",patLevel="",recLevStr=""	//20150123
	s recLevStr=##class(web.DHCClinicCom).GetPatLevelByPapmiId(admId)
	i recLevStr'="" s secAlias=$p($g(recLevStr),"^",4),patLevel=$p(recLevStr,"^",2)
	s ctlocId=$p(^PAADM(+admId),"^",4)
	q:+ctlocId=0 ""
	s wardId=$p($g(^PAADM(admId)),"^",70)
	s bedId=$p($g(^PAADM(admId)),"^",73)
	s roomId=$p(^PAADM(admId),"^",69)
	s transInfo=$$GetTransInfo(admId,transLocNum,date,time) //ypz 080709
	i $p(transInfo,"^")'="" d
		.s ctlocId=$p(transInfo,"^") //ypz 080709
		.s wardId=$p(transInfo,"^",2) //ypz 080709
		.s roomId=$p(transInfo,"^",3) //ypz 080709
		.s bedId=$p(transInfo,"^",4) //ypz 080709
	s ctlocDesc=$p(^CTLOC(+ctlocId),"^",2)	
	i $p(ctlocDesc,"-",2)'="" s ctlocDesc=$p(ctlocDesc,"-",2)
	s wardDesc=$p($g(^PAWARD(+wardId)),"^",2)
	i $p(wardDesc,"-",2)'="" s wardDesc=$P(wardDesc,"-",2)
	s bedSub=$p(bedId,"||",2)
	s bedCode=""
	i bedSub'="" s bedCode=$p($g(^PAWARD(wardId,"BED",bedSub)),"^",1)
	s room=$p($g(^PAROOM(+roomId)),"^",2)	
	s doc=$p(^PAADM(admId),"^",9)
	i doc'="" s DocDes=$P($g(^CTPCP(doc,1)),"^",2)
	s regNo=..GetRegNobyEpisodeID(admId)
	s medicareNo=..GetMedicareNo(papmiId,admId)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	i $d(^PAPER(papmiId,"PAT",3)) s safetyNetCardNo=$p(^PAPER(papmiId,"PAT",3),"^",4) ;病案号
	e  s safetyNetCardNo=""
	s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	S homeAddres=$g(^PAPER(papmiId,"PER","ADD",1))     // 住址
	s homeTel=$p($g(^PAPER(papmiId,"PER",1)),"^",11)   //家庭电话
	s workTel=$p($g(^PAPER(papmiId,"PER",1)),"^",9)    //工作电话
	s handtel=$p($g(^PAPER(papmiId,"PER",4)),"^",21)   //手机
	s NationDr=$p($g(^PAPER(papmiId,"PER",2)),"^",1)
	i NationDr'="" d
		.s Nation=$P(^CT("NAT",NationDr),"^",2)
	e  d
		.s Nation=""                                       //民族
	s paersonLX=$p($g(^PAPER(papmiId,"PER",2)),"^",13) //联系人
	s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	s age=..CalAge(birth,+$h)
	i $p(ctlocDesc,"-",2)'="" s ctlocDesc=$p(ctlocDesc,"-",2)
	s MRDiagnos=""
	s mradmId=$P(^PAADM(admId),"^",61)
	;无id可修改
	i mradmId'="" d
		.s diagInfoStr=##class(web.DHCANAdaptor).GetDiagInfoByAdmId(mradmId)
		.s digStrLength=$l(diagInfoStr,"^")
		.f dnum=1:1:digStrLength d
			..s curDiagStr=$p(diagInfoStr,"^",dnum)
			..s curDigDesc=$p(curDiagStr,"&&",1)
			..s curDigId=$p(curDiagStr,"&&",2)
			..s curDigNote=$p(curDiagStr,"&&",3)
			..s curPreFix=$p(curDiagStr,"&&",4)
			..s curDigType=$p(curDiagStr,"&&",5)
			..s curDigMainFlag=$p(curDiagStr,"&&",6)
			..q:curDigType'="出院诊断"
			..s newDiagStr=curPreFix_curDigDesc_curDigNote
			..i MRDiagnos'="" s MRDiagnos=MRDiagnos_","_newDiagStr
			..e  s MRDiagnos=newDiagStr

	/*
	s mrdiaSub=0
	f  s mrdiaSub=$O(^MR(mradmId,"DIA",mrdiaSub)) q:(mrdiaSub="")  d
		.s diagDate=$p(^MR(mradmId,"DIA",mrdiaSub),"^",7)
		.q:(date'="")&(date<diagDate)	;诊断日期大于打印日期不显示
		.
		.s typSub=0  f  s typSub=$O(^MR(mradmId,"DIA",mrdiaSub,"TYP",typSub)) q:(typSub="")   d
			..s dtypId=$P(^MR(mradmId,"DIA",mrdiaSub,"TYP",typSub),"^",1)
			..q:dtypId=""
			..s TypCode=$p($G(^MRC("DTYP",dtypId)),"^",1)
			..q:TypCode'="OUT"
			..s MRDIAICDCodeDR=$p($G(^MR(mradmId,"DIA",mrdiaSub)),"^",1)
			..q:MRDIAICDCodeDR=""
			..i MRDiagnos="" d
				...s MRDiagnos=$p($G(^MRC("ID",MRDIAICDCodeDR)),"^",2)
			..e  d
				...s MRDiagnos=MRDiagnos_","_$p($G(^MRC("ID",MRDIAICDCodeDR)),"^",2)
	*/
	s DrugCell=""
	s DrugCell=$p($G(^PAPER(papmiId,"DHC")),"^",5)  //药柜号
	s birthDate=$p($g(^PAPER(papmiId,"ALL")),"^",6) //出生日期
	i birthDate'="" s birthDate=$zd(birthDate,3)
	s patWorkUnit=$p($G(^PAPER(papmiId,"PER",4)),"^",18)  //工作单位
	s PersonID=$p($G(^PAPER(papmiId,"ALL")),"^",9)  //身份证
	s BloodType=..GetBloodType(regNo) //取血型
	s AdmReason=$P($g(^PAADM(admId,1)),"^",7)
	i AdmReason'="" s PAAdmReasonDesc=$P($g(^PAC("ADMREA",AdmReason)),"^",2)
	e  s PAAdmReasonDesc=""                     //病人身份
	s AdmDocID=$P($g(^PAADM(admId)),"^",79)
	i AdmDocID'="" s AdmDoc=$P($g(^CTPCP(AdmDocID,1)),"^",2)
	e  s AdmDoc=""                              //办理出院医生
	s DHCAdmId=$o(^DHCPAAdm(0,"PAAdm",admId,"")) 			//主管护士
	i DHCAdmId'="" d
		.s MainNurseDr=$p(^DHCPAAdm(DHCAdmId),"^",2)
		.i MainNurseDr'="" d
			..s MainNurse=$P($g(^CTPCP(MainNurseDr,1)),"^",2)
		.e  d
			..s MainNurse=""
	e  s MainNurse="" 
	s AdmDate=$P(^PAADM(admId),"^",6) 						//入院日期
	i AdmDate'="" d
		.s admStayDay=$P($h,"^",1)-AdmDate+1
		.s admStayDay=admStayDay_"天"
	e  d
		.s admStayDay=""
	s retStr=regNo_"^"_ctlocDesc_"^"_$g(room)_"^"_$g(sex)_"^"_$g(patName)_"^"_$g(safetyNetCardNo)_"^"_$g(bedCode)_"^"_$g(age)_"^"_$g(wardDesc)_"^"_homeAddres
	s retStr=retStr_"^"_homeTel_"  "_workTel_"  "_handtel_"^"_$G(DocDes)_"^"_medicareNo_"^"_MRDiagnos_"^"_Nation_"^"_paersonLX_"^"_DrugCell_"^"_$G(birthDate)_"^"_$G(patWorkUnit)_"^"_$G(PersonID)
	s retStr=retStr_"^"_BloodType_"^"_PAAdmReasonDesc_"^"_AdmDoc_"^"_MainNurse_"^"_admStayDay_"^"_secAlias_"^"_patLevel
	q retStr
GetTransInfo(EpisodeID,transLocNum,date,time)  //返回病人第transLocNum次转科的科室、病区、房间、床位
	//n (EpisodeID,transLocNum)
	s curCtlocId="",curWardId="",curRoomId="",curBedId=""
	s retStr=curCtlocId_"^"_curWardId_"^"_curRoomId_"^"_curBedId
	i (+transLocNum=0)&(date="")&(time="") q retStr
	s i=0
	s dateTime=date+(time/100000)
	s preLocId=""
	s stdate=$P(^PAADM(EpisodeID),"^",6)
	s transSub=0 f  s transSub=$O(^PAADM(EpisodeID,"TRANS",transSub)) q:transSub=""  d
		.s transLocId=$P(^PAADM(EpisodeID,"TRANS",transSub),"^",6)
		.i (transLocId'="")&(transLocId'=preLocId) d
			..s i=i+1
			..s preLocId=transLocId
			..i i=transLocNum s curCtlocId=transLocId
	s i=0,preLocId=""
	s transSub=0 f  s transSub=$O(^PAADM(EpisodeID,"TRANS",transSub)) q:transSub=""  d
		.s transLocId=$P(^PAADM(EpisodeID,"TRANS",transSub),"^",6)
		.i (transLocId'="")&(transLocId'=preLocId) d
			..s i=i+1
			..s preLocId=transLocId
		.//w "transSub="_transSub_"/i="_i_"/num="_transLocNum_"/ctlocId="_curCtlocId,!
		.i (i'>transLocNum)&(transLocNum>0) d
			..s transWardId=$P(^PAADM(EpisodeID,"TRANS",transSub),"^",9)
			..i transWardId'="" d
				...s transWardLocId=$p($g(^PAWARD(transWardId)),"^",5)
				...i (+curCtlocId'=0)&('$d(^CTLOC(transWardLocId,"LINK",0,"Loc",+curCtlocId))) s transWardId="" q
				...s curWardId=transWardId
			..//w "transSub="_transSub_"/i="_i_"/num="_transLocNum_"/ctlocId="_curCtlocId_" curWardId="_curWardId,"/"_transWardId,!
			..q:transWardId=""
			..s transBedId=$P(^PAADM(EpisodeID,"TRANS",transSub),"^",8)
			..i transWardId'=+transBedId q
			..i transBedId'="" s curBedId=transBedId
			..s transRoomId=$P(^PAADM(EpisodeID,"TRANS",transSub),"^",7)
			..i transRoomId'="" s curRoomId=transRoomId
			..//w "transSub="_transSub_"/wardid="_curWardId_"/curRoomId="_curRoomId,!
		.i (+transLocNum=0)&(date'="")&(time'="") d
			..i $P(^PAADM(EpisodeID,"TRANS",transSub),"^",6)'="",curCtlocId="" s curCtlocId=$P(^PAADM(EpisodeID,"TRANS",transSub),"^",6)
			..i $P(^PAADM(EpisodeID,"TRANS",transSub),"^",9)'="",curWardId="" s curWardId=$P(^PAADM(EpisodeID,"TRANS",transSub),"^",9)
			..s transDate=$p(^PAADM(EpisodeID,"TRANS",transSub),"^",1)
			..s transTime=$p(^PAADM(EpisodeID,"TRANS",transSub),"^",2)
			..s transDateTime=transDate+(transTime/100000)
			..i transDateTime<dateTime d
				...i $P(^PAADM(EpisodeID,"TRANS",transSub),"^",6)'="" s curCtlocId=$P(^PAADM(EpisodeID,"TRANS",transSub),"^",6)
				...i $P(^PAADM(EpisodeID,"TRANS",transSub),"^",9)'="" s curWardId=$P(^PAADM(EpisodeID,"TRANS",transSub),"^",9)
				...//i $P(^PAADM(EpisodeID,"TRANS",transSub),"^",7)'="" s curRoomId=$P(^PAADM(EpisodeID,"TRANS",transSub),"^",7)
				...i $P(^PAADM(EpisodeID,"TRANS",transSub),"^",8)'="" s curBedId=$P(^PAADM(EpisodeID,"TRANS",transSub),"^",8)
				...i +curBedId'=curWardId s curBedId="",curRoomId=""
				...i curBedId'="" s curRoomId=$p(^PAWARD(+curBedId,"BED",$p(curBedId,"||",2)),"^",3)
	i curCtlocId="" s curCtlocId=$p(^PAADM(EpisodeID),"^",4)
	//i curRoomId="" s curRoomId=$p(^PAADM(EpisodeID),"^",69)
	i curWardId="" s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)
	//i curBedId="" s curBedId=$p($g(^PAADM(EpisodeID)),"^",73)

	s retStr=curCtlocId_"^"_curWardId_"^"_curRoomId_"^"_curBedId
	q retStr
}

/// Creator：      	ypz
/// CreatDate：    	2010-03-12
/// Description： 	查找病区病人:有wardId直接找病人,无则根据ctlocId则找病人:是病区直接找病人,是科室找关联病区的病人
/// Table：        	PA_Adm,PA_Patmas,PAC_Ward,PAC_Bed
/// Input：        	wardId病区ID,ctlocId医生/护士科室ID
/// Output：       
/// Return：       	返回以"^"分割的病人信息串，病人信息:就诊号EpisodeID_"|"_床位bedCode_"|"_病人姓名patName
ClassMethod FindWardPatient(wardId As %String = "", ctlocId As %String = "") As %String
{
	s retStr=""
	q:(wardId="")&(ctlocId="") retStr
	
	s wardIdList=wardId
	i wardId="" d
	    .s ctlocType=$p($g(^CTLOC(ctlocId)),"^",13)
		.i ctlocType="W" d
			..s wardIdList=$o(^PAWARD(0,"WARD_LocationDR",ctlocId,0))
		.e  d
			..i ctlocType="E" d  
			..s linksub=0
			..f  s linksub=$o(^CTLOC(ctlocId,"LINK",linksub)) q:linksub=""  d
				...s linkCtlocId=$p($g(^CTLOC(ctlocId,"LINK",linksub)),"^",1)
				...i linkCtlocId'="" d
					....s linkCtlocType=$p($g(^CTLOC(linkCtlocId)),"^",13)
					....i linkCtlocType="W" d 
						.....i wardIdList'="" s wardIdList=wardIdList_"^"
						.....s wardIdList=wardIdList_$o(^PAWARD(0,"WARD_LocationDR",linkCtlocId,0))
	q:wardIdList="" retStr
	
	f i=1:1:$l(wardIdList,"^") d
	    .s wardId=$p(wardIdList,"^",i)
	    .i ctlocId="" s ctlocId=$p(^PAWARD(+wardId),"^",5)
	    .s roomId=0
	    .f  s roomId=$o(^PAADMi("CurrWard",wardId,roomId)) q:roomId=""  d
    		..s EpisodeID=0
    		..f  s EpisodeID=$o(^PAADMi("CurrWard",wardId,roomId,EpisodeID)) q:EpisodeID=""  d
        		...q:'$d(^PAADM(EpisodeID))
        		...s paadmVisitStatus=$p($g(^PAADM(EpisodeID)),"^",20)
        		...i paadmVisitStatus'="A" q
        		...s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
        		...s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
       			...s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
        		...//s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
        		...s bedId=$p($g(^PAADM(EpisodeID)),"^",73)
        		...s bedSub=$p(bedId,"||",2)
        		...q:bedSub=""
        		...s bedTypeId=$p($g(^PAWARD(+bedId,"BED",+bedSub)),"^",2)
        		...s bedCode=$p($g(^PAWARD(wardId,"BED",bedSub)),"^",1)
        		...q:bedCode="" ;防止床位码表被删
        		...i retStr'="" s retStr=retStr_"^"
        		...s retStr=retStr_EpisodeID_"|"_bedCode_"|"_patName_"|" //用床位号好找
    q retStr
}

/// d ##class(%ResultSet).RunQuery("web.DHCClinicCom","FindPatient","0000000001","","","O","A",$h-10,"",5,1)
/// d ##class(%ResultSet).RunQuery("web.DHCClinicCom","FindPatient","0000000001","","","","","","63","","")
/// d ##class(%ResultSet).RunQuery("web.DHCClinicCom","FindPatient","0000000001","","","","","","","1","")
/// 查找病人：regNo登记号;papmiMedicare病案号;needPatName病人姓名，支持模糊查询;
///     needAdmType就诊类型：O门诊，I住院，E急诊，可以组合,空为全部;needAdmVisitStatus病人就诊状态：A在院，D出院;
///     startDate开始日期;endDate结束日期;wardId病区;userId用户;ifFindByDoc是否当前医生用户的病人
/// 查找优先级：登记号或病案号对应上的按单个病人查找(病人姓名模糊查询无效);有科室按当前病区病人查找;最后按时间查找。
/// 查找时间范围：病区按当前病区病人找，与时间无关;出院按出院时间找;其他按就诊时间找。
/// 		"2014/9/30"	string
Query FindPatient(regNo As %String, papmiMedicare As %String, needPatName As %String, needAdmType As %String, needAdmVisitStatus As %String, startDate As %String, endDate As %String, locId As %String = "", userId As %String = "", ifFindByDoc As %String = 0) As %Query(ROWSPEC = "AdmDate,PatName,RegNo,MedicareNo,MainDoctor,AdmReason,AdmType,WardDesc,BedNo,DeptDesc,PatientID,EpisodeID,DischargeDate,DiagnoseDesc,Gender,DOB,Age,HouseAddress,Telphone,Contacts,PersonID,SecAlias,PatLevel") [ SqlProc ]
{
}

ClassMethod FindPatientExecute(ByRef qHandle As %Binary, regNo As %String, papmiMedicare As %String, needPatName As %String, needAdmType As %String, needAdmVisitStatus As %String, startDate As %String, endDate As %String, locId As %String = "", userId As %String = "", ifFindByDoc As %String = 0) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s papmiId=""
	i regNo'="" s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),""))
	i papmiId="",papmiMedicare'="" d
		.s papmiMedicare=$$ALPHAUP^SSUTIL4(papmiMedicare)
		.s papmiId=$o(^PAPERi("Medicare1",papmiMedicare,""))
	i papmiId'="" s needPatName=""

	i needAdmVisitStatus="" s needAdmVisitStatus="A"
	s ifCheckDate=1
	i (startDate="")&(endDate="") s ifCheckDate=0
	s startDate=..ConvertToDateH(startDate)
	s endDate=..ConvertToDateH(endDate)
    s wardId=""
    s wardIdList=""
    s optLocId=""
    i locId'="" 
    {   
	  s locType=$p($g(^CTLOC(locId)),"^",13)
	  i locType="W" d
	  .s wardIdList=$o(^PAWARD(0,"WARD_LocationDR",locId,0))
	  e  d
	  .s locAdmType=..GetLocAdmType(locId)
	  .i (locAdmType'="I") s optLocId=locId
	  .q:(locAdmType'="I")
	  .s linkLocIdStr=..GetLinkLocId(locId)
	  .f i=1:1:$l(linkLocIdStr,"^") d
	  ..s linkLocId=$p(linkLocIdStr,"^",i)
	  ..q:linkLocId=""
	  ..s linkLocType=$p($g(^CTLOC(linkLocId)),"^",13)
	  ..i linkLocType="W" d 
	  ...i wardIdList'="" s wardIdList=wardIdList_"^"
	  ...s wardIdList=wardIdList_$o(^PAWARD(0,"WARD_LocationDR",linkLocId,0))
    }
	if (regNo'="")!(papmiMedicare'="")!(needPatName'="") //单个病人
	{
		i papmiId'="" d
			.s curAdmType=""
			.f  s curAdmType=$o(^PAPERdr(papmiId,"ADM",curAdmType)) q:curAdmType=""  d
				..;w curAdmType,!
				..q:(needAdmType'="")&(needAdmType'[curAdmType)
				..s EpisodeID=0
				..f  s EpisodeID=$o(^PAPERdr(papmiId,"ADM",curAdmType,EpisodeID)) q:EpisodeID=""  d
					...//w $$PatAdmInfo(0),!
					...q:$$PatAdmInfo(0)<0
					...do OutputRowPatList
		e  d
			.i needPatName'="" d
				..s papmiId=""
				..f  s papmiId=$o(^PAPERi("PAPER_PatName",$$ALPHAUP^SSUTIL4(needPatName),papmiId)) q:papmiId=""  d
					...//w papmiId
					...s curPapmiEpisodeIDList=##class(web.DHCClinicCom).GetPatientEpisodeID("",papmiId,"","","IO")
					...f i=1:1:$l(curPapmiEpisodeIDList,"^") d
						....s EpisodeID=$p(curPapmiEpisodeIDList,"^",i)
						....q:EpisodeID=""
						....q:$$PatAdmInfo(0)<0
						....do OutputRowPatList
			.
			.
	}
	else //多个病人
	{
		if (needAdmVisitStatus="D") //出院
		{
			s curDischgDate=startDate-1
			f  s curDischgDate=$o(^PAADMi("DischDate",curDischgDate)) q:(curDischgDate="")!(curDischgDate>endDate)  d
				.s EpisodeID=0
				.f  s EpisodeID=$o(^PAADMi("DischDate",curDischgDate,EpisodeID)) q:EpisodeID=""  d
					..q:(wardId'="")&($p(^PAADM(EpisodeID),"^",70)'=wardId)	
					..q:$$PatAdmInfo(0)<0
					..d OutputRowPatList
		}
		else
		{
			if (wardIdList'="")
			{
				s EpisodeID=0
				if (needAdmVisitStatus="A") //当前病区
				{
					f i=1:1:$l(wardIdList,"^") d
					.s wardId=$p(wardIdList,"^",i)
					.q:wardId=""
					.s roomId=0
					.f  s roomId=$o(^PAADMi("CurrWard",wardId,roomId)) q:roomId=""  d
					..f  s EpisodeID=$o(^PAADMi("CurrWard",wardId,roomId,EpisodeID)) q:EpisodeID=""  d  
					...q:$$PatAdmInfo(0)<0
					...d OutputRowPatList
				}
			}
			elseif optLocId'=""
			{
			  s EpisodeID=0
			  s admDate=startDate-1
			  f  s admDate=$o(^PAADMi("CurrLoc",optLocId,admDate)) q:admDate=""  d
			  .q:admDate>endDate
              .s admTime=""
              .f  s admTime=$o(^PAADMi("CurrLoc",optLocId,admDate,admTime)) q:admTime=""  d
              ..f  s EpisodeID=$o(^PAADMi("CurrLoc",optLocId,admDate,admTime,EpisodeID)) q:EpisodeID=""  d
              ...q:$$PatAdmInfo(0)<0
              ...d OutputRowPatList
			}
			else
			{
				f curDate = startDate:1:endDate //一段时间
				{
					s EpisodeID=0
					f  s EpisodeID=$o(^PAADMi("PAADM_AdmDate",curDate,EpisodeID)) q:EpisodeID=""  d
						.q:$$PatAdmInfo(1)<0
						.do OutputRowPatList
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

PatAdmInfo(ifCheckDate)
	s papmiId=$p(^PAADM(EpisodeID),"^",1)
	s secAlias="",patLevel="",recLevStr=""	//20150123
	s recLevStr=##class(web.DHCClinicCom).GetPatLevelByPapmiId(EpisodeID)
	i recLevStr'="" s secAlias=$p($g(recLevStr),"^",4),patLevel=$p(recLevStr,"^",2)

	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	q:(needPatName'="")&(patName'[needPatName) -1
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	//s papmiMedicare=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	s admType=$p($g(^PAADM(EpisodeID)),"^",2)
	s papmiMedicare=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,admType,.ErrMsg)
	q:(needAdmType'="")&(needAdmType'[admType) -2
	i admType="O" s admType="门诊"
	i admType="E" s admType="急诊"
	i admType="I" s admType="住院"
	s admVisitStatus=$p($g(^PAADM(EpisodeID)),"^",20)
	q:(needAdmVisitStatus'="")&(needAdmVisitStatus'=admVisitStatus) -3
	i admVisitStatus="D" s admType="出院"
	s ctcpId=$p(^SSU("SSUSR",+userId),"^",14)
	s admDocCtcpId=$p($g(^PAADM(EpisodeID)),"^",9) 
	s admDoc=$p($g(^CTPCP(+admDocCtcpId,1)),"^",2)
	q:(ifFindByDoc)&(admDocCtcpId'="")&(ctcpId'="")&(ctcpId'=admDocCtcpId) -4
	s admDate=$p($g(^PAADM(EpisodeID)),"^",6)
	q:(ifCheckDate)&(needAdmVisitStatus'="D")&((admDate<startDate)!(admDate>endDate)) -5
	s admTime=$p($g(^PAADM(EpisodeID)),"^",7)
	s admDateTime=""
	i admDate'="" s admDateTime=$zd(admDate,3)_" "_$zt(admTime,2)
	s admReasonId=$p($g(^PAADM(EpisodeID,1)),"^",7)
	s admReason=$p(^PAC("ADMREA",+admReasonId),"^",2)
	s admDeptId=$p($g(^PAADM(EpisodeID)),"^",4)
	q:(admDeptId'=optLocId)&&(admType'="I")&&(optLocId'="") -6
	if $l($P($g(^CTLOC(admDeptId)),"^",2),"-")>1 s admDept=$p($p($g(^CTLOC(admDeptId)),"^",2),"-",2)
	e  s admDept=$p($g(^CTLOC(admDeptId)),"^",2)
	//b ;admDept
	q:((locId'="")&&(admDeptId'="")&&($p($g(^CTLOC(locId)),"^",22)'=$p($g(^CTLOC(admDeptId)),"^",22))) -7 //病人所在医院判断
	s admDischgDate=$p($g(^PAADM(EpisodeID)),"^",17) //出院日期
	q:(ifCheckDate)&(needAdmVisitStatus="D")&((admDischgDate<startDate)!(admDischgDate>endDate)) -8
	i admDischgDate'="" s admDischgDate=$zd(admDischgDate,3)
	s admWardId=$P($g(^PAADM(EpisodeID)),"^",70)
	q:(admWardId'=wardId)&&(admType="I") -9
	s admWard=$P($g(^PAWARD(+admWardId)),"^",2)
	s bedId=$P($g(^PAADM(EpisodeID)),"^",73)
	s admBed=$P($g(^PAWARD(+bedId,"BED",+$P(bedId,"||",2))),"^",1)
	s mrAdmId=$p($g(^PAADM(EpisodeID)),"^",61)
	s mrDiagnoseDesc=..GetMRDiagnosDesc(mrAdmId,"^")
	s mrdLength=$Length(mrDiagnoseDesc,"^")
	s mrDiagnoseDesc=$P(mrDiagnoseDesc,"^",mrdLength)
	s personID=$p($G(^PAPER(papmiId,"ALL")),"^",9)  //身份证
	s patSex=$p($g(^CT("SEX",+$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	s patBirth=$p($g(^PAPER(papmiId,"ALL")),"^",6)	//出生日期
	s patAge=..CalAge(patBirth,+$h) //年龄
	i patBirth'="" s patBirth=$zd(patBirth,3)	//出生日期
	s patAddress=$g(^PAPER(papmiId,"PER","ADD",1))
	s patTelphone=$p($g(^PAPER(papmiId,"PER",4)),"^",21)   //手机
	i patTelphone="" s patTelphone=$p($g(^PAPER(papmiId,"PER",1)),"^",11)   //家庭电话
	i patTelphone="" s patTelphone=$p($g(^PAPER(papmiId,"PER",1)),"^",9)    //工作电话
	i patTelphone="" s patTelphone=$p($g(^PAPER(papmiId,"ALL")),"^",4)     //联系电话
	s patContact=$p($g(^PAPER(papmiId,"PER",2)),"^",13)  //联系人	
	q 0

OutputRowPatList
	set Data=$lb(admDateTime,patName,regNo,papmiMedicare,admDoc,admReason,admType,admWard,admBed,admDept,papmiId,EpisodeID,admDischgDate,mrDiagnoseDesc,patSex,patBirth,patAge,patAddress,patTelphone,patContact,personID,secAlias,patLevel)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod FindPatientFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPatientExecute ]
{
	// Restore QHandle
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)

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

ClassMethod FindPatientClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPatientExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetLocAdmType(locId) As %String
{
	s ret=""
	s rowId=$o(^PAC("ADMLOC",0,"AdmType","I",locId,""))
	i rowId'="" s ret="I"
	s rowId=$o(^PAC("ADMLOC",0,"AdmType","O",locId,""))
	i rowId'="" s ret="O"
	s rowId=$o(^PAC("ADMLOC",0,"AdmType","E",locId,""))
	i rowId'="" s ret="E"
	q ret
}

ClassMethod GetMRDiagnos(EpisodeID)
{
	q:EpisodeID="" ""
	s mradmId=$P(^PAADM(EpisodeID),"^",61)
	s mrdiaSub=0,mrcidDesc="",seqNo=0
	f  s mrdiaSub=$O(^MR(mradmId,"DIA",mrdiaSub)) q:(mrdiaSub="")  d
		.//q:$p(^MR(mradmId,"DIA",mrdiaSub),"^",7)>date
		.s mrcidId=$p(^MR(mradmId,"DIA",mrdiaSub),"^")
		.//q:("|"_icuaRelatedDiagDr_"|")'[("|"_mrcidId_"|")
		.i mrcidId'="" s curMrcidDesc=$p($g(^MRC("ID",+mrcidId)),"^",2)
		.e  s curMrcidDesc=$g(^MR(mradmId,"DIA",mrdiaSub,"DES",1))
		.q:curMrcidDesc=""
		.s seqNo=seqNo+1
		.s mrcidDesc=$tr(mrcidDesc,$c(13))
		.s mrcidDesc=$tr(mrcidDesc,$c(10))
		.i mrcidDesc'="" s mrcidDesc=mrcidDesc_","
		.s mrcidDesc=mrcidDesc_seqNo_"."_curMrcidDesc
	q mrcidDesc
}

/// Creator: mfc
/// CreatDate: 2020-11-20
/// Description: 获取HIS诊断结果
/// Table：MR_Diagnos
/// Return：MRDIA_DiagnosPrefix:诊断前缀,MRDIA_Desc:诊断备注
/// d ##class(%ResultSet).RunQuery("web.DHCClinicCom","Find")
Query Find(mradm As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,mradm,MRDIAICDCodeDR,MRDIAICDCodeDRDesc,MRDIAICDCodeDRCode,MRDIADate:%Date,MRDIATime:%Time,MRDIADesc:%List,MRDIAUpdateUserDRSSUSRName,MRDIADiagnosPrefix")
{
SELECT MRDIA_RowID, MRDIA_MRADM_ParRef, MRDIA_ICDCode_DR, MRDIA_ICDCode_DR->MRCID_Desc, MRDIA_ICDCode_DR->MRCID_Code, MRDIA_Date, MRDIA_Time, MRDIA_Desc, MRDIA_UpdateUser_DR->SSUSR_Name,MRDIA_DiagnosPrefix
FROM SQLUser.MR_Diagnos
WHERE MRDIA_MRADM_ParRef = :mradm
}

ClassMethod GetMRDiagnosDesc(mrAdmId As %String, delimStr As %String) As %String
{
	s retval=""
	s i=0
	//Set obj=##class(%ResultSet).%New("web.MRDiagnos:Find") //20201120 mfc
	Set obj=##class(%ResultSet).%New("web.DHCClinicCom:Find")
	d obj.Execute(mrAdmId)
	For  Quit:'obj.Next()  Do
		.s Desc=obj.Data("MRDIAICDCodeDRDesc")
		.s Prefix=obj.Data("MRDIADiagnosPrefix") //诊断前缀
		.s MRDesc=obj.Data("MRDIADesc")
		.i MRDesc'="" s MRDesc=$LIST(MRDesc,1)		
		.i Desc="" d
			..s Desc=MRDesc
			..i Prefix'="" s Desc="("_Prefix_")"_Desc
		.e  d
			..i Prefix'="" s Desc=Desc_"("_Prefix_")"
			..i MRDesc'="" s Desc=Desc_"("_MRDesc_")"
		.s i=i+1
		.s Desc=i_"."_Desc
		.i retval="" s retval=Desc
		.e  s retval=retval_delimStr_Desc
	d obj.Close()
	q $ZCVT(retval,"O","JS")
}

/// 第四组：医嘱
ClassMethod GetOrdCatId(oeoriId) As %String
{
	q:oeoriId="" ""
	s oeordId=+oeoriId
	s oeoriSub=$p(oeoriId,"||",2)
	q:'$d(^OEORD(oeordId,"I",oeoriSub,1)) ""
	s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
	//b ;2
	q:arcimId="" ""
	s arcimVersion=$p(arcimId,"||",2)
	q:'$d(^ARCIM(+arcimId,arcimVersion,1)) ""
	s arcicId=$p(^ARCIM(+arcimId,arcimVersion,1),"^",10)
	q:arcicId="" ""
	q:'$d(^ARC("IC",arcicId)) ""
	s orcatId=$p(^ARC("IC",arcicId),"^",8)
	q:orcatId="" ""
	q:'$d(^OEC("ORCAT",orcatId)) ""
	q orcatId
}

ClassMethod GetOrdStatCode(oeoriId)
{
	q:oeoriId="" ""
	s oeordId=+oeoriId,oeoriSub=$p(oeoriId,"||",2)
	s ordStatId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)  ;OEORI_ItemStat_DR
	s ordStatCode=$p($g(^OEC("OSTAT",+ordStatId)),"^")
	s xDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",34)
	s xTime=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",15)
	s curDateTimeVal=($h*100000)+$p($h,",",2)
	s xDateTimeVal=(xDate*100000)+xTime
	s EndDate=$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",9)
	s EndTime=$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",10)
	s endDateTimeVal=(EndDate*100000)+EndTime
	i ordStatCode["D",EndDate'="",curDateTimeVal<xDateTimeVal s ordStatCode="PD" //已停止预停
	i ordStatCode["V",curDateTimeVal<endDateTimeVal s ordStatCode="TPD" //未停止预停	
	q ordStatCode
}

ClassMethod GetOrdSubCatType(oeoriId, arcimId = "") As %String
{
	i arcimId="" d
		.q:oeoriId=""
		.s oeordId=+oeoriId
		.s oeoriSub=$p(oeoriId,"||",2)
		.q:'$d(^OEORD(oeordId,"I",oeoriSub,1))
		.s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
	q:arcimId="" ""
	s arcimVersion=$p(arcimId,"||",2)
	q:'$d(^ARCIM(+arcimId,arcimVersion,1)) ""
	s arcicId=$p(^ARCIM(+arcimId,arcimVersion,1),"^",10)
	q:arcicId="" ""
	q:'$d(^ARC("IC",arcicId)) ""
	s arcicOrderType=$p(^ARC("IC",arcicId),"^",7)
	q arcicOrderType
}

/// 取医嘱信息：
/// 入参：医嘱表RowId或医嘱执行表RowId
/// 返回值：用"^"分割的几部分：oecprType:Y/N/"",Y长嘱，N临嘱，""不应执行的医嘱(取药、出院带药);oecprCode:医嘱优先级代码;
///         phcinId:用法指针;phcinCode:用法代码;phcinDesc：用法描述,mainOeoriId:主医嘱RowId;subOeoriId:从医嘱RowId,
///         defPhcinId:缺省用法指针;defPhcinCode:缺省用法代码;defPhcinDesc：缺省用法描述;用"!"分割
///         oriQty:医嘱药品为剂量，非药品其它为数量;unitUomId:医嘱单位。
///         注：如果医嘱是从医嘱mainOeoriId有值，如果是主医嘱，从医嘱subOeoriId有值。
ClassMethod GetOeorditemInfo(oeoriId As %String) As %String
{
	//w ##class(web.DHCClinicCom).GetOeorditemInfo("911637||7")
	s oeoriSub=$p(oeoriId,"||",2)
	q:oeoriSub="" ""
	s oeordId=+oeoriId
	s oeoriId=oeordId_"||"_oeoriSub
	s ordStatCode=..GetOrdStatCode(oeoriId)
	q:("VED"'[ordStatCode)&("TPD"'[ordStatCode) ""
	s oecprId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",8)
	s oecprCode=""
	i oecprId>0 s oecprCode=$p($g(^OECPR(+oecprId)),"^",1)
	s oecprDesc=$p($g(^OECPR(+oecprId)),"^",2)
	s oecprType=""
	i (oecprCode="S")!(oecprCode="OMST")!(oecprCode="OMCQZT") s oecprType="Y" //长期医嘱
	i ((oecprCode="NORM")!(oecprCode="OM")!(oecprCode="STAT")!(oecprCode="PRN")) s oecprType="N" //临时医嘱
	s phcinId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7) //医嘱用法指针
	s phcinCode="",phcinDesc="" 
	i phcinId'="" s phcinCode=$p($g(^PHCIN(phcinId)),"^",1),phcinDesc=$p($g(^PHCIN(phcinId)),"^",2)
	s mainOeoriId=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)
	s subOeoriId=""
	i oeoriSub'="" d
		.s curOriSub=""
		.f  s curOriSub=$o(^OEORDi(0,"OEORI",oeordId,oeoriId,curOriSub)) q:(curOriSub="")  d
			..i subOeoriId'="" s subOeoriId=subOeoriId_"!"
			..s subOeoriId=subOeoriId_oeordId_"||"_curOriSub

	//for 第三方HIS begin
	s EpisodeID=+^OEORD(+oeoriId)
	s lhnOrderNo=$o(^DHCLHN(0,"OEORI",EpisodeID,oeoriId,""))
	i lhnOrderNo'="" d //以此为标志
		.s mainOeoriId=""
		.s subOeoriId=""
		.s mainLhnId=$o(^DHCLHN(0,"PAADM",EpisodeID,lhnOrderNo,1,""))
		.q:mainLhnId=""
		.q:'$d(^DHCLHN(mainLhnId))
		.i oeoriId'=$p(^DHCLHN(mainLhnId),"^",4) s mainOeoriId=$p(^DHCLHN(mainLhnId),"^",4)
		.q:mainOeoriId'="" //找到了主医嘱，是从医嘱
		.s lhnOrderSubNo=1
		.f  s lhnOrderSubNo=$o(^DHCLHN(0,"PAADM",EpisodeID,lhnOrderNo,lhnOrderSubNo)) q:lhnOrderSubNo=""  d
			..s lhnId=""
			..f  s lhnId=$o(^DHCLHN(0,"PAADM",EpisodeID,lhnOrderNo,lhnOrderSubNo,lhnId)) q:lhnId=""  d
				...q:'$d(^DHCLHN(lhnId)) 
				...i subOeoriId'="" s subOeoriId=subOeoriId_"!"
				...s subOeoriId=subOeoriId_$p(^DHCLHN(lhnId),"^",4)
	//w mainOeoriId_"/"_subOeoriId,!
	//for 第三方HIS end

	s arcimId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",2)
	s phcdfId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",12)
	s phcdId=+phcdfId,phcdfSub=+$p(phcdfId,"||",2)
	s defPhcinId=+$p($g(^PHCD(phcdId,"DF",phcdfSub,1)),"^",5)
	s defPhcinCode=$p($g(^PHCIN(defPhcinId)),"^",1),defPhcinDesc=$p($g(^PHCIN(defPhcinId)),"^",2)
	s phcfrId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",4)
	s prcfrDesc=$p($g(^PHCFR(+phcfrId)),"^",3)
	s phcfrFactor=$p(^PHCFR(+phcfrId),"^",2)

	s doseQty=$p($g(^OEORD(oeordId,"I",+oeoriSub,2)),"^",1)
	s unitUomId=$p($g(^OEORD(oeordId,"I",+oeoriSub,2)),"^",3)
	s phOrdQty=$p($g(^OEORD(oeordId,"I",+oeoriSub,1)),"^",12)
	i doseQty="",phOrdQty="" s unitUomId=""
	i (doseQty'="")&($p(doseQty,".")="") s doseQty="0"_doseQty
	s oriQty=doseQty
	i oriQty="" s oriQty=phOrdQty
	s oriNote=$g(^OEORD(oeordId,"I",+oeoriSub,"DEP",1))

	q oecprType_"^"_oecprCode_"^"_phcinId_"^"_phcinCode_"^"_phcinDesc_"^"_mainOeoriId_"^"_subOeoriId_"^"_defPhcinId_"^"_defPhcinCode_"^"_defPhcinDesc_"^"_oriQty_"^"_unitUomId_"^"_oecprDesc_"^"_phcfrId_"^"_prcfrDesc_"^"_phcfrFactor_"^"_oriNote
}

ClassMethod GetArcimDesc(arcimId, isAbbreviate = 0) As %String
{
	q:arcimId="" ""
	s arcimVer=$p(arcimId,"||",2)
	q:arcimVer=""
	s arcimDesc=$p($g(^ARCIM(+arcimId,arcimVer,1)),"^",2)
	//w arcimDesc,!
	i isAbbreviate d
		.s arcimAbbrev=$p($g(^ARCIM(+arcimId,arcimVer,1)),"^",3)
		.q:1[arcimAbbrev
		.s arcimDesc=arcimAbbrev
	//w "    ",arcimDesc,!
	q arcimDesc
}

/// 返回：eqUomIdStr等效剂量单位_"^"_eqDefDoseStr医嘱缺省量_"^"_baseUomId基本单位_"^"_eqQtyStr转换系数：基本单位数量*eqQty=等效剂量单位数量_"^"_volume单位代码为"ML"的转换系数,无则为""
ClassMethod GetEqUomQty(arcimId) As %String
{
	s eqUomIdStr="",eqDefDoseStr=1,baseUomId="",eqQtyStr=1,volume=1,basePrice=0
	q:arcimId="" eqUomIdStr_"^"_eqDefDoseStr_"^"_baseUomId_"^"_eqQtyStr_"^"_volume_"^"_basePrice
	s basePrice=+##CLASS(web.UDHCJFPRICE).GetOrderPrice("","",arcimId,+$h,"","","","")
	s baseUomId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),8)),"^",14)
	s eqUomIdStr=baseUomId
	s phcdfId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",12)
	q:phcdfId="" eqUomIdStr_"^"_eqDefDoseStr_"^"_baseUomId_"^"_eqQtyStr_"^"_volume_"^"_basePrice
	s phcdId=+phcdfId,phcdfSub=$p(phcdfId,"||",2)
	q:phcdfSub="" eqUomIdStr_"^"_eqDefDoseStr_"^"_baseUomId_"^"_eqQtyStr_"^"_volume_"^"_basePrice
	s baseUomId=$p($g(^PHCD(phcdId,"DF",phcdfSub,2)),"^",4)
	
	s volume=""
	s volUomId=$o(^CT("UOM",0,"Code","ML",""))
	s eqUomIdStr=baseUomId,eqQtyStr=1,eqDefDoseStr=1
	s eqId=0,haveData=0
	f  s eqId=$o(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)) q:eqId=""  d
		.s eqUomId=+^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)
		.s eqQty=$p(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId),"^",2)
		.s eqDefDose=$p(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId),"^",3)
		.i eqQty=0 s eqQty=1
		.i $p(eqQty,".",1)="" s eqQty=0_eqQty
		.i $p(eqDefDose,".",1)="" s eqDefDose=0_eqDefDose
		.//i eqDefDose<1 s eqDefDose=eqQty
		.//i eqDefDose<1 s eqDefDose=1
		.q:(eqUomId="")!(eqQty=0)
		.i +eqDefDose=0 s eqDefDose=eqQty
		.i 'haveData s eqUomIdStr="",eqQtyStr="",eqDefDoseStr=""
		.
		.i eqUomIdStr'="" s eqUomIdStr=eqUomIdStr_"|",eqQtyStr=eqQtyStr_"|",eqDefDoseStr=eqDefDoseStr_"|"
		.s eqUomIdStr=eqUomIdStr_eqUomId,eqQtyStr=eqQtyStr_eqQty,eqDefDoseStr=eqDefDoseStr_eqDefDose
		.i volUomId=eqUomId d
		    ..s volume=eqQty
		    ..i +volume=0 s volume=1
		.s haveData=1
	q eqUomIdStr_"^"_eqDefDoseStr_"^"_baseUomId_"^"_eqQtyStr_"^"_volume_"^"_basePrice
}

/// 返回日处方协定剂量(defined daily doses)：DDD值_"^"_DDD单位_"^"_WHODDD值_"^"_WHO单位
ClassMethod GetDDD(arcimId) As %String
{
	s phcdfDdd="",dddUomId="",phcdfWhoDdd="",whoDddUomId=""
	q:arcimId="" phcdfDdd_"^"_dddUomId_"^"_phcdfWhoDdd_"^"_whoDddUomId
	s phcdfId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",12)
	q:phcdfId="" phcdfDdd_"^"_dddUomId_"^"_phcdfWhoDdd_"^"_whoDddUomId
	s phcdId=+phcdfId,phcdfSub=$p(phcdfId,"||",2)
	q:phcdfSub="" phcdfDdd_"^"_dddUomId_"^"_phcdfWhoDdd_"^"_whoDddUomId
	//s dddUomId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),8)),"^",14)
	s dddUomId=$p($g(^PHCD(phcdId,"DF",phcdfSub,2)),"^",4)
	s phcdfDdd=$p($g(^PHCD(phcdId,"DF",phcdfSub,"DHC")),"^",5)
	s phcdfWhoDdd=$p($g(^PHCD(phcdId,"DF",phcdfSub,"DHC")),"^",11)
	s whoDddUomId=$p($g(^PHCD(phcdId,"DF",phcdfSub,"DHC")),"^",12)
	q phcdfDdd_"^"_dddUomId_"^"_phcdfWhoDdd_"^"_whoDddUomId
}

/// 计算整包装数量，非药品返回0
ClassMethod CaculatePackQty(arcimId, orderUomId, orderUomQty) As %String
{
	q:arcimId="" 0
	q:+orderUomId=0 0
	s phcdfId=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",12)
	q:phcdfId="" 0
	s phcdId=+phcdfId,phcdfSub=$p(phcdfId,"||",2)
	s baseUomId=$p($g(^PHCD(phcdId,"DF",phcdfSub,2)),"^",4)

	s packUomId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),8)),"^",14)
	s packDoseQty=0
	s factor=1
	i packUomId'="" d
		.i baseUomId'=packUomId d
			..s ctcfId=$o(^CT("CTCF",0,"UOM",packUomId,baseUomId,""))
			..i ctcfId'="" s factor=$p(^CT("CTCF",ctcfId),"^",3)
		.q:+factor=0
		.//s packDoseQty=qtyPackUom*factor ;;dQty/factor  ;包装单位转换
		.//i $p(packDoseQty,".",2)>0 s packDoseQty=$p(packDoseQty,".",1)+1
	i factor=0 q 0

	s eqQty=1
	i baseUomId'=orderUomId d
		.s eqId=0,eqQty=0
		.f  s eqId=$o(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)) q:eqId=""  d
			..s eqUomId=+^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)
			..i eqUomId=orderUomId s eqQty=$p(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId),"^",2)
	i eqQty=0 q 0
	s qty=orderUomQty/eqQty/factor
	i $p(qty,".",2)>0 s qty=$p(qty,".",1)+1
	q qty
}

/// Creator: YPZ
/// CreatDate: 2015-12-08
/// Description: 取药品管理分类代码
/// Table：ARC_ItmMast,PHC_DrugForm,PHC_DrgMast,PHC_Poison
/// Input：医嘱码表Id
/// Return：管理分类代码
ClassMethod GetPHCPoisonCode(arcimId) As %String
{
	q:arcimId="" ""
	s phcdfId=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",12)
	q:phcdfId="" ""
	s phcpoId=$p($P(^PHCD(+phcdfId,1),"^",4),$C(1))
	q:phcpoId="" ""
	q $p($g(^PHCPO(phcpoId)),"^",1)
}

ClassMethod GetOeoriGroupDesc(oeoriId, isAbbreviate = 0) As %String
{
	s oeordId=+oeoriId,oeoriSub=$p(oeoriId,"||",2)
	q:oeoriSub="" ""
	//q:$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)'="" ""
	s oeoriId=oeordId_"||"_oeoriSub
	s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
	s retStr=..GetArcimDesc(arcimId,isAbbreviate)
	s oeoriStr=..GetOeorditemInfo(oeoriId)
	s arcicOrderType=..GetOrdSubCatType(oeoriId)
	i arcicOrderType="R" s retStr=retStr_" "_$p(oeoriStr,"^",11)_$P($g(^CT("UOM",+$p(oeoriStr,"^",12))),"^",2)
	e  s retStr=retStr_" "_$P($g(^CT("UOM",+$p(oeoriStr,"^",12))),"^",2)
	q:retStr="" ""
	s subOrderPhcinId=$g(^DHCCLSet("ICU","SubOrderPhcinId"))
	//q:(arcicOrderType'="R") retStr
	s curOriSub=""
	f  s curOriSub=$o(^OEORDi(0,"OEORI",oeordId,oeoriId,curOriSub)) q:(curOriSub="")  d
		.s curArcimId=$p(^OEORD(oeordId,"I",curOriSub,1),"^",2)
		.s arcimDesc=..GetArcimDesc(curArcimId,isAbbreviate)
		.q:arcimDesc=""
		.s subPhcinId=$p($g(^OEORD(oeordId,"I",curOriSub,2)),"^",7)
		.q:(arcicOrderType="R")&(..GetOrdSubCatType(oeordId_"||"_curOriSub)'=arcicOrderType)&(("^"_subOrderPhcinId_"^")'[("^"_subPhcinId_"^")) //与华西不同!!!!
		.s subOeoriStr=..GetOeorditemInfo(oeordId_"||"_curOriSub)
		.s retStr=retStr_$c(13)_$c(10)_arcimDesc
		.s retStr=retStr_" "_$p(subOeoriStr,"^",11)_$p($g(^CT("UOM",+$p(subOeoriStr,"^",12))),"^",2)
	s phcinDesc=$p(oeoriStr,"^",5)
	i phcinDesc'="" d
		.i $p(phcinDesc,"-",2)'="" s phcinDesc=$p(phcinDesc,"-",2)
		.i $p(phcinDesc,"(",1)'="" s phcinDesc=$p(phcinDesc,"(",1)
		.s retStr=retStr_"("_phcinDesc_")"
	q retStr
}

ClassMethod GetArcimDescList(arcimIdStr) As %String
{
	q:arcimIdStr="" ""
	s arcimIdCount=$l(arcimIdStr,"^")
	s arcimDesc=""
	f i=1:1:arcimIdCount  d
	.s singleArcimId=$p(arcimIdStr,"^",i)
	.s singleArcimDesc=..GetArcimDesc(singleArcimId)
	.i arcimDesc'="" s arcimDesc=arcimDesc_"^"
	.s arcimDesc=arcimDesc_singleArcimDesc
	
	q arcimDesc
}

/// Creator: CCQ
/// CreatDate: 2014-09-01
/// Description: 根据医嘱项的代码字符串(多个代码以"~"连接)获取医嘱项ID字符串(多个医嘱项以"~"连接) 
/// Table：ARC_ItmMast
/// Return：医嘱项ID字符串
ClassMethod GetArcimIdStrByCode(arcimCodeStr As %String) As %String
{
	set result="",arcimCode=""
	set arcimCodeNum=$length(arcimCodeStr,"~")
	f i=1:1:arcimCodeNum  d
	.set arcimCode=$p(arcimCodeStr,"~",i)
	.set arcimId=""
	.if $data(^ARCIM(0,"Code",arcimCode))  do
	..set arcimSubScript=""
	..for  set arcimSubScript=$order(^ARCIM(0,"Code",arcimCode,arcimSubScript)) quit:(arcimSubScript="")  do
	...set arcimVersion=""
	...for  set arcimVersion=$order(^ARCIM(0,"Code",arcimCode,arcimSubScript,arcimVersion)) quit:(arcimVersion="")  do
	....set arcimId=arcimSubScript_"||"_arcimVersion
	.if (i'=1) set result=result_"~"
	.set result=result_arcimId
	
	quit result
}

/// Creator: CCQ
/// CreatDate: 2014-08-27
/// Description: 获取全部用药途径  
/// Table：PHC_Instr
/// Return：用法ID:Id,用法代码:Code,用法名称:Desc,用法别名:Alias
Query FindInstructionList() As %Query(ROWSPEC = "Id:%String,Code:%String,Desc:%String,Alias:%String") [ SqlProc ]
{
}

ClassMethod FindInstructionListExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	s instrId=""
	f  s instrId=$o(^PHCIN(instrId)) q:(instrId="")  d
	.s instrCode=$p(^PHCIN(instrId),"^",1)
	.s instrDesc=$p(^PHCIN(instrId),"^",2)
	.s instrAlias=$p(^PHCIN(instrId),"^",3)
	.d OutputInstructionRow
	s qHandle=$lb(0,repid,0)
	q $$$OK

OutputInstructionRow
	s Data=$lb(instrId,instrCode,instrDesc,instrAlias)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindInstructionListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInstructionListExecute ]
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

ClassMethod FindInstructionListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInstructionListExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator: CCQ
/// CreatDate: 2014-08-28
/// Description: 获取全部单位 
/// Table：CT_Uom
/// Return：用法ID:Id,用法代码:Code,用法名称:Desc
Query FindUomList() As %Query(ROWSPEC = "Id:%String,Code:%String,Desc:%String") [ SqlProc ]
{
}

ClassMethod FindUomListExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	s uomCode=""
	f  s uomCode=$o(^CT("UOM",0,"Code",uomCode)) q:(uomCode="")  d
	.s uomId=$o(^CT("UOM",0,"Code",uomCode,""))
	.q:(uomId="")
	.s uomDesc=$ZCVT($p($g(^CT("UOM",uomId)),"^",2),"l")
	.d OutputUomRow
	s qHandle=$lb(0,repid,0)
	q $$$OK

OutputUomRow
	s Data=$lb(uomId,uomCode,uomDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindUomListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindUomListExecute ]
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

ClassMethod FindUomListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindUomListExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator：      	陈长青
/// CreatDate：    	2014-03-12
/// Description： 	根据拼音码或名称字符串查找医嘱项
/// Table：        	
/// Input:			filterDesc：医嘱项名称或别名过滤字符串，groupId：用户安全组ID，ctLocId：用户登录位置ID，opaId：手术病人申请排班ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCClinicCom","FindArcim","amxl","153","120","43757")
Query FindArcim(filterDesc As %String, groupId As %String, ctLocId As %String, opaId As %String) As %Query(ROWSPEC = "Id,Code,Description,Alias,ItemType,ItemCatId,EqualUomId,DefaultDoseQty,BaseUomId,ConversionCoefficient,Volume,DefaultInstrId,Price,DefaultRecvLoc") [ SqlProc ]
{
}

ClassMethod FindArcimExecute(ByRef qHandle As %Binary, filterDesc As %String, groupId As %String, ctLocId As %String, opaId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s resultSet=##class(%ResultSet).%New("web.DHCDocOrderEntry:LookUpItem")
	d resultSet.Execute(filterDesc,groupId,"","","","","","","","","","","","","","")
	while(resultSet.Next())
	{		
		s arcimType=resultSet.GetData(4)
		continue:(arcimType'="ARCIM")
		s arcimId=resultSet.GetData(2)
		s arcimCode=resultSet.GetData(29)
		s arcimAlias=resultSet.GetData(5)
		s arcimMainId=+arcimId,arcimVersion=+$p(arcimId,"||",2)
		s arcimDesc=$p($g(^ARCIM(arcimMainId,arcimVersion,1)),"^",2)
		s itemCatId=$p($g(^ARCIM(arcimMainId,arcimVersion,1)),"^",10)
		s equalUomInfo=..GetEqUomQty(arcimId)
		s equalUomIdInfo=$p(equalUomInfo,"^",1)
		s defaultDoseInfo=$p(equalUomInfo,"^",2)
		s baseUomId=$p(equalUomInfo,"^",3)
		s equalQtyInfo=$p(equalUomInfo,"^",4)
		s volume=$p(equalUomInfo,"^",5)
		s defaultInstrId=""
		s instrId=$p($g(^ARCIM(arcimMainId,arcimVersion,1)),"^",12)
		s instrMainId=+instrId,instrSubId=+$p(instrId,"||",2)
		i (instrSubId'="")
		{
			s defaultInstrId=+$p($g(^PHCD(instrMainId,"DF",instrSubId,1)),"^",5)	
		}
		s itemPrice=+##Class(web.DHCDocOrderEntry).GetOrderPrice("","",arcimId,+$h,"","","","")
		s defaultRecvLoc=##class(web.DHCANCall).GetOrderItemRecloc(opaId,arcimId,"",ctLocId)
		s defaultRecvLoc=$tr(defaultRecvLoc,"^","#")
		d OutputRow
	}
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow
 	Set Data=$lb(arcimId,arcimCode,arcimDesc,arcimAlias,arcimType,itemCatId,equalUomIdInfo,defaultDoseInfo,baseUomId,equalQtyInfo,volume,defaultInstrId,itemPrice,defaultRecvLoc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindArcimFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArcimExecute ]
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

ClassMethod FindArcimClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArcimExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Creator：      	ck
/// CreatDate：    	2013-03-27
/// Description： 	根据医嘱表ID获取医嘱基本单位数量
/// Table：        	DHC_OEDispensing(P7以后)OE_Dispensing(P5以前),oe_ordItem
/// Input：        	医嘱ID
/// Return：       	基本单位数量_"^"_基本单位ID_"^"_基本单位描述_"^"_基本单位单价
/// w ##Class(web.DHCClinicCom).GetOrderItemBaseUomQty("1485681||64")
ClassMethod GetOrderItemBaseUomQty(OEORIRowId As %String) As %String
{
	q:OEORIRowId="" "0^0^^0"
	s sumQty=""
	//1 判断是否为药品
	s arcicOrderType=..GetOrdSubCatType(OEORIRowId)
	q:arcicOrderType'="R" "0^0^^0" //药品
	
	s arcimId=$p($g(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),1)),"^",2)
	s eqUomQty=..GetEqUomQty(arcimId)
	s baseUomId=$p(eqUomQty,"^",3)
	s baseUomDesc=$p(^CT("UOM",baseUomId),"^",2)
	s basePrice=+##CLASS(web.UDHCJFPRICE).GetOrderPrice("","",arcimId,+$h,"","","","")

	//2 取DHC_OEDispensing表  P7及以上版本
	s DSPId="" f  s DSPId=$o(^DHCOEDISQTY(0,"OEORI",OEORIRowId,DSPId)) q:DSPId=""  d
	.s DSPTotalQty=$p(^DHCOEDISQTY(DSPId),"^",2)
	.s DSPQty=$p(^DHCOEDISQTY(DSPId),"^",5)
	.s DSPStatus=$p(^DHCOEDISQTY(DSPId),"^",7)
	.i DSPStatus'="R" d
	..i sumQty="" s sumQty=DSPTotalQty
	..e  s sumQty=sumQty+DSPTotalQty
	.e  d
	..s sumQty=sumQty-DSPQty
	
	//3,第2步若没有取到数据则取OE_Dispensing表  P5
	i sumQty="" d
	.//OE_Order.OEORD_RowId
	.//^OEORD({OE_Order.OEORD_RowId},"I",{OE_OrdItem.OEORI_Childsub},"X",{OE_OrdExec.OEORE_Childsub},"D",{DSP_ChildSub}
	.s OEORDRowId=$p(OEORIRowId,"||",1)
	.s OEORIChildsub=$p(OEORIRowId,"||",2)
	.q:OEORDRowId=""
	.q:OEORIChildsub=""
	.s OEOREExStDate="" f  s OEOREExStDate=$o(^OEORDi(0,"OrdItem",OEORDRowId,OEORIChildsub,OEOREExStDate)) q:OEOREExStDate=""  d
	..s OEOREChildsub="" f  s OEOREChildsub=$o(^OEORDi(0,"OrdItem",OEORDRowId,OEORIChildsub,OEOREExStDate,OEOREChildsub)) q:OEOREChildsub=""  d
	...s DSPChildSub="" f  s DSPChildSub=$o(^OEORD(OEORDRowId,"I",OEORIChildsub,"X",OEOREChildsub,"D",DSPChildSub)) q:DSPChildSub=""  d
	....s DSPQty=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,"X",OEOREChildsub,"D",DSPChildSub),"^",1)
	....s DSPReturnQty=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,"X",OEOREChildsub,"D",DSPChildSub),"^",7)
	....i sumQty="" s sumQty=DSPQty
	....e  s sumQty=sumQty+DSPQty
	....i DSPReturnQty>0 s sumQty=sumQty-DSPReturnQty
	....i DSPReturnQty<0 s sumQty=sumQty+DSPReturnQty
	
	q +sumQty_"^"_baseUomId_"^"_baseUomDesc_"^"_basePrice
}

/// 多项医嘱库存满足
ClassMethod IsARCItemsQtyEnough(para As %String) As %String
{
	s mainSplitChar="^",subSplitChar=$c(3)
	s itemNum=$l(para,mainSplitChar),result=""
	f i=1:1:itemNum  d
	.s singlePara=$p(para,mainSplitChar,i)
	.i (singlePara="") s result=result_mainSplitChar
	.q:(singlePara="")
	.s arcimId=$p(singlePara,subSplitChar,1)
	.s locId=$p(singlePara,subSplitChar,2)
	.s qty=$p(singlePara,subSplitChar,3)
	.s singleResult=..IsQtyEnoughByArc(arcimId,locId,qty)
	.i result'="" s result=result_mainSplitChar
	.s result=result_singleResult
    
    q result
}

/// Descript：	开医嘱前判断实际库存是否满足
/// Creater：	zhouyg
/// CreateDate：2013-12-20
/// Input：		医嘱项ID,接收科室ID,基本单位数量
/// Return:		0-库存不满足,1-库存满足,<0表示错误
ClassMethod IsQtyEnoughByArc(Arcim As %String, LocID As %String, Qty As %String) As %String
{
 	;n (Arcim,LocID,Qty)
 	q:Arcim="" -102
 	q:LocID="" -103
 	s ArcimSub=$p(Arcim,"||",1)
 	q:ArcimSub="" -102
 	s Inci=$o(^INCI(0,"ARCIM_DR",ArcimSub,"")) 
 	q:Inci="" -104
 	s CurQty=##Class(web.DHCSTSTKQTY).IL(Inci,LocID,+$h)
 	i CurQty<Qty d
 	.s stkflag=0
 	e  d
 	.s stkflag=1
 	q stkflag
}

/// Descript：	判断库存项属性
/// Creater：	YPZ
/// CreateDate：2015-07-21
/// Input：		医嘱项ID,医嘱ID
/// Return:		D-药品,M-材料,O-其它，出错为""
ClassMethod GetStockType(arcimId As %String, oeoriId As %String = "") As %String
{
 	i arcimId="" s arcimId=$p($g(^OEORD(+oeoriId,"I",$p(oeoriId,"||",2),1)),"^",2)
 	s arcimSub=$p(arcimId,"||",1)
 	q:arcimSub="" ""
	
	s arcicCode=..GetOrdSubCatType("",arcimId)
 	s inciId=$o(^INCI(0,"ARCIM_DR",arcimSub,"")) 
 	q:inciId="" "O"
 	s stockCat=##class(web.DHCSTCOMINC).GetIncStkCatGrp(inciId)
 	s stockCatType=$p(stockCat,"^",3)
 	i stockCatType="G" s stockCatType="D"
 	i "DM"'[stockCatType s stockCatType="O"
 	q stockCatType
}

/// Creator：      	陈长青
/// CreatDate：    	2013-10-11
/// Description： 	麻醉计费时判断药品的医保适应症
/// Table：        	
/// Input：        	HIS医嘱项Id，病人费用类型Id
/// Return：       	收费项id^收费项名称^限制条件$c(3)收费项id^收费项名称^限制条件
/// w ##Class(web.DHCClinicCom).ArcimLinkTarStr("9095||1","14")
ClassMethod ArcimLinkTarStr(arcimId As %String, admReasonId As %String) As %String
{
	q ##class(web.DHCINSUPort).ArcimLinkTarStr(arcimId,admReasonId)
}

/// 第五组：检验
/// 获取最新的检验结果
/// 参数standardCodeStr可以包含多个检验项目的标准代码，以“^”分割
/// 返回结果也是按照检验项目标准代码串的顺序返回，以EOT分割
ClassMethod GetLatestTestResult(episodeID As %String, standardCodeStr As %String) As %String
{
	s EOT=$c(4)
	s standardCodeCount=$l(standardCodeStr,"^")
	s result=""
	f i=1:1:standardCodeCount  d
	.s singleStandardCode=$p(standardCodeStr,"^",i)
	.s singleResult=..GetTestResult(episodeID,"","",singleStandardCode,0,0,$h+1,0,1)
	.i i'=1 s result=result_EOT
	.s result=result_singleResult
	
	q result
}

/// 旧的获取方式，不再使用
/// 根据就诊号、登记号或科室的化验项目标准码standardCode，取检验结果,ifSingle=1取最新值
/// 返回值：多个结果以^分割,每个以"\"分割：检验值，单位，检验正常值范围
ClassMethod GetTestResultOld(needEpisodeID, regNoList, ctlocId, standardCode, startDate, startTime, endDate, endTime, ifSingle = 0, needNote = "", dataField = "") As %String
{
	k labCode
	//q:standardCode="" ""
	s testCodeStr=""
	i standardCode'="" d
		.s testCode=""
		.f  s testCode=$o(^TTABi("TC","NNL",standardCode,testCode)) q:testCode=""  d
			..i testCodeStr'="" s testCodeStr=testCodeStr_"^"
			..s testCodeStr=testCodeStr_testCode
	//w "testCodeStr="_testCodeStr,!
	q:(standardCode'="")&(testCodeStr="") ""
	s startDate=..ConvertToDateH(startDate)
	s startTime=..ConvertToTimeH(startTime)
	s endDate=..ConvertToDateH(endDate)
	s endTime=..ConvertToTimeH(endTime)
	i needEpisodeID'="" d
		.s papmiId=$p($g(^PAADM(needEpisodeID)),"^",1)
		.s regNoList=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
		.s paadmDate=$p(^PAADM(needEpisodeID),"^",6)
		.i paadmDate'="" d
			..q:(paadmDate<startDate)
			..s paadmTime=$p(^PAADM(needEpisodeID),"^",7)
			..q:(paadmDate=startDate)&(paadmTime<startTime)
			..s startDate=paadmDate,startTime=paadmTime
		.s paadmDischgDate=$p(^PAADM(needEpisodeID),"^",17)
		.i paadmDischgDate>paadmDate d
			..q:(paadmDischgDate>endDate)
			..s paadmDischgTime=$p(^PAADM(needEpisodeID),"^",18)
			..q:(paadmDischgDate=endDate)&(paadmDischgTime>endTime)
			..s endDate=paadmDischgDate,endTime=paadmDischgTime
	i regNoList="" d
		.s EpisodeIDList=..FindWardPatient("", ctlocId)
		.q:EpisodeIDList=""
		.f i=1:1:$l(EpisodeIDList,"^") d
			..s EpisodeID=+$p(EpisodeIDList,"^",i)
			..s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
			..i regNoList'="" s regNoList=regNoList_"^"
			..s regNoList=regNoList_$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	q:regNoList="" ""
	s minQty="",maxQty="",minDateTime="",maxDateTime=""
	s retStr=""
	f i=1:1:$l(regNoList,"^") d
		.s regNo=$p(regNoList,"^",i)
		.q:regNo=""
		.s testCode="",ifFind=0,count=0
		.f  s testCode=$o(^TDHCOldResult(1,regNo,testCode)) q:(testCode="")!(ifFind)  d
			..//w testCodeStr_"/"_testCode,!
			..q:(testCodeStr'="")&(("^"_testCodeStr_"^")'[("^"_testCode_"^"))
			..//w 2,!
			..s sort=-1,date=0,startDt=0,endDt=0
			..i ((dataField'="")&&((dataField="First")||(dataField="FirstDT")||(dataField="touchQty"))) d
			...s sort=1
			...s date=startDate-1
			...s endDt=endDate+11
			..e  d
			...s sort=-1
			...s endDt=startDate			
			...s date=endDate+11 //允许十天滞后
			..f  s date=$o(^TDHCOldResult(1,regNo,testCode,date),sort) q:(date="")!(ifFind)  d	
				...s time="",timeComparison=0
				...i ((dataField'="")&&((dataField="First")||(dataField="FirstDT")||(dataField="touchQty"))) d
				....i (date>endDt) d
				.....s timeComparison=1
				...e  d
				....i (date<endDt) d
				.....s timeComparison=1
				...f  s time=$o(^TDHCOldResult(1,regNo,testCode,date,time),sort) q:(time="")!(ifFind)  d
					....q:(timeComparison) //&(time*60<startTime)
					....//q:(date=endDate)&(time*60'<endTime)					
					....s labNo=""
					....f  s labNo=$o(^TDHCOldResult(1,regNo,testCode,date,time,labNo)) q:(labNo="")!(ifFind)  d
						.....s testSet=""
						.....f  s testSet=$o(^TDHCOldResult(1,regNo,testCode,date,time,labNo,testSet)) q:testSet=""  d
							......s sub=$o(^TDHCOldResult(1,regNo,testCode,date,time,labNo,testSet,""))
							......s result=$p(^TEPI(labNo,1,testSet,sub,"DATA",testCode),"\",1)
							......q:result=""							
							......s itmtype=$p(^TTAB("TC",testCode),"\",3)
							......i (itmtype="V")&&(result'="") s result=$p(^TTAB("BUG",result),"\",1) //Micro Pathogen||V 微生物鉴定					
							......s receiveDate=$p(^TEPI(labNo,1,testSet,sub),"\",4)
							......s receiveTime=$p(^TEPI(labNo,1,testSet,sub),"\",5)*60
							......q:(receiveDate=startDate)&(receiveTime<startTime)
							......q:(receiveDate>endDate)!((receiveDate=endDate)&(receiveTime>endTime))
							......s bbRowid=$p(^TEPI(labNo,1,testSet,sub),"\",46)				
							......q:(needNote'="")&&(("^"_needNote_"^")'[("^"_bbRowid_"^"))
							......s range=$g(^TEPI(labNo,1,testSet,sub,"DATA",testCode,"Ranges"))
							......s unit=$g(^TEPI(labNo,1,testSet,sub,"DATA",testCode,"Unit"))
							......
							......i ((minQty="")!(result<minQty)) d
							.......s minQty=result,minDateTime=$zd(receiveDate,3)_" "_$zt(receiveTime,2)
							......i ((maxQty="")!(result>maxQty)) d
							.......s maxQty=result,maxDateTime=$zd(receiveDate,3)_" "_$zt(receiveTime,2)
							......i (dataField="Min") d
							.......s retStr=minQty_"\"_unit_"\"_range_"\"_receiveDate_"\"_receiveTime_"\"_testSet_"\"_testCode
							......e  i (dataField="Max") d
							.......s retStr=maxQty_"\"_unit_"\"_range_"\"_receiveDate_"\"_receiveTime_"\"_testSet_"\"_testCode
							......e  i (dataField="FirstDT") d
							.......s retStr=result_" "_$zd(receiveDate,3)_" "_$zt(receiveTime,2)_"\"_unit_"\"_range_"\"_receiveDate_"\"_receiveTime_"\"_testSet_"\"_testCode
							......e  i (dataField="MinDT") d
							.......s retStr=minQty_" "_minDateTime_"\"_unit_"\"_range_"\"_receiveDate_"\"_receiveTime_"\"_testSet_"\"_testCode
							......e  i (dataField="MaxDT") d
							.......s retStr=maxQty_" "_maxDateTime_"\"_unit_"\"_range_"\"_receiveDate_"\"_receiveTime_"\"_testSet_"\"_testCode
							......e  i (dataField="First") d
							.......s retStr=result_"\"_unit_"\"_range_"\"_receiveDate_"\"_receiveTime_"\"_testSet_"\"_testCode 
							......e  i (dataField="touchQty") d
							.......i retStr'="" s retStr=retStr_"^"
							.......s retStr=retStr_result_"\"_unit_"\"_range_"\"_receiveDate_"\"_receiveTime_"\"_testSet_"\"_testCode
							......e  d
							.......i retStr'="" s retStr=retStr_"^"
							.......s retStr=retStr_result_"\"_unit_"\"_range_"\"_receiveDate_"\"_receiveTime_"\"_testSet_"\"_testCode
							......//w testSet_"/"_labNo_"/"_testCode_"/"_date_"/"_time,!
							......//q:$d(labCode(testSet,testCode))
							......//s labCode(testSet,testCode)=""
							......//w regNo_" "_$zd(date,3)_" "_$zt(time,2)_":" 
							......//w testSet_":"_$p(^TTAB("TS",testSet),"\",1)_"/"_testCode_":"_$p(^TTAB("TC",testCode),"\",1)_"/"_result_" "_unit_":"_range,!
							......;i retStr'="" s retStr=retStr_"^"
							......;s retStr=retStr_result_"\"_unit_"\"_range_"\"_receiveDate_"\"_receiveTime_"\"_testSet_"\"_testCode
							......s count=count+1
							......i ((dataField="")||(dataField="First")||(dataField="FirstDT")),ifSingle,count>0 s ifFind=1 //为空查询最近一次
	q retStr
}

/// 根据就诊号、登记号或科室的化验项目标准码standardCode，取检验结果,ifSingle=1取最新值
/// 返回值：多个结果以ETX分割,每个以STX分割：检验值，单位，检验正常值范围
/// 根据就诊号、登记号或科室的化验项目标准码standardCode，取检验结果,ifSingle=1取最新值
/// 返回值：多个结果以ETX分割,每个以STX分割：检验值，单位，检验正常值范围
ClassMethod GetTestResultOldBak(needEpisodeID, regNoList, ctlocId, standardCode, startDate, startTime, endDate, endTime, ifSingle = 0, needNote = "", dataField = "", labNoStr = "") As %String
{
	s STX=$c(2)
	s ETX=$c(3)
	s startDate=..ConvertToDateH(startDate)
	s startTime=..ConvertToTimeH(startTime)
	s endDate=..ConvertToDateH(endDate)
	s endTime=..ConvertToTimeH(endTime)
	;b //GetTestResult
	i labNoStr'=""  d
		.;i regNoList="" s regNoList=$p($g(^TEPI(labNoStr)),"\",18)
		.;q:regNoList=""
		..i regNoList="" d
        ..;s regNoList=$p($g(^TEPI(labNoStr)),"\",18)
        ..s OrdId=$o(^OEORD(0,"EpisNo",labNoStr,""))
		..s EpisodeID=$p($g(^OEORD(OrdId)),"^",1)
		..s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
		..s regNoList=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
		.q:regNoList=""
		.;b //regNoList
		.s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNoList),""))
		.s curEpisodeIDList=##class(web.DHCClinicCom).GetPatientEpisodeID("",papmiId,"","","IOE")
		.f i=1:1:$l(curEpisodeIDList,"^") d
			..s maxEpisodeID=$p(curEpisodeIDList,"^",1)
			..s minEpisodeID=$p(curEpisodeIDList,"^",$l(curEpisodeIDList,"^"))
			..s startDate=$p(^PAADM(minEpisodeID),"^",6)
			..s startTime=$p(^PAADM(minEpisodeID),"^",7)
			..i $p(^PAADM(maxEpisodeID),"^",17)>0 s endDate=$p(^PAADM(maxEpisodeID),"^",17)
			..e  s endDate=+$h
			..i $p(^PAADM(maxEpisodeID),"^",18)>0 s endTime=$p(^PAADM(maxEpisodeID),"^",18)
			..e  s endTime=$p($h,",",2)
	i needEpisodeID'="" d
		.s papmiId=$p($g(^PAADM(needEpisodeID)),"^",1)
		.s regNoList=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
		.s paadmDate=$p(^PAADM(needEpisodeID),"^",6)
		.i paadmDate'="" d
			..q:(paadmDate<startDate)
			..s paadmTime=$p(^PAADM(needEpisodeID),"^",7)
			..q:(paadmDate=startDate)&(paadmTime<startTime)
			..s startDate=paadmDate,startTime=paadmTime
		.s paadmDischgDate=$p(^PAADM(needEpisodeID),"^",17)
		.i paadmDischgDate>paadmDate d
			..q:(paadmDischgDate>endDate)
			..s paadmDischgTime=$p(^PAADM(needEpisodeID),"^",18)
			..q:(paadmDischgDate=endDate)&(paadmDischgTime>endTime)
			..s endDate=paadmDischgDate,endTime=paadmDischgTime	
	i regNoList="" d
		.s EpisodeIDList=..FindWardPatient("", ctlocId)
		.q:EpisodeIDList=""
		.f i=1:1:$l(EpisodeIDList,"^") d
			..s EpisodeID=+$p(EpisodeIDList,"^",i)
			..s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
			..i regNoList'="" s regNoList=regNoList_"^"
			..s regNoList=regNoList_$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	q:regNoList="" ""	
	s retStr=""
	f i=1:1:$l(regNoList,"^") d
		.s regNo=$p(regNoList,"^",i)
		.q:regNo=""
		.s minQty="",maxQty="",minDateTime="",minDate="",minTime="",maxDateTime="",maxDate="",maxTime=""
		.s ifFind=0,count=0
		.do Find(regNo,standardCode,startDate,endDate)
		
	q retStr
Find(regNo,standardCode,startDate,endDate)  
	s rset=##class(%ResultSet).%New("LabService.TCResult:QryTCResultBySync")	
	s ret="",isTooLong=0
	do rset.Execute("",regNo,standardCode,$zd(startDate,3),$zd(endDate,3))
	while (rset.Next()) {
		q:ifFind	
		s labNo=rset.GetData(3)		
		b ;11
		i (labNoStr="")!(labNo=labNoStr) do
		.b ;in
		.s ordItmRowID=rset.GetData(2)
		.s result=rset.GetData(8)
		.s unit=rset.GetData(10)
		.;s unit=$tr(unit,"^","E")
		.s range=rset.GetData(11)
		.s receiveDate=rset.GetData(15)
		.s receiveTime=rset.GetData(16)
		.i receiveDate'="" s receiveDate=$zdh(receiveDate,3)
		.i receiveTime'="" s receiveTime=$zth(receiveTime,4)
		.s testSet="",antibioticCode="",bbDesc="" //标本名称
		.s testCode=rset.GetData(5)
		.s itemName=rset.GetData(6)		
		.i ((minQty="")!(result<minQty)) d
		..s minQty=result,minDateTime=$zd(receiveDate,3)_" "_$zt(receiveTime,2),minDate=receiveDate,minTime=receiveTime
		.i ((maxQty="")!(result>maxQty)) d
		..s maxQty=result,maxDateTime=$zd(receiveDate,3)_" "_$zt(receiveTime,2),maxDate=receiveDate,maxTime=receiveTime
		.i (dataField="Min") d
		..s retStr=minQty_STX_unit_STX_range_STX_minDate_STX_minTime_STX_testSet_STX_testCode_STX_antibioticCode_STX_labNo_STX_bbDesc_STX_itemName_STX_ordItmRowID
		.e  i (dataField="Max") d
		..s retStr=maxQty_STX_unit_STX_range_STX_maxDate_STX_maxTime_STX_testSet_STX_testCode_STX_antibioticCode_STX_labNo_STX_bbDesc_STX_itemName_STX_ordItmRowID
		.e  i (dataField="FirstDT") d
		..s retStr=result_" "_$zd(receiveDate,3)_" "_$zt(receiveTime,2)_STX_unit_STX_range_STX_receiveDate_STX_receiveTime_STX_testSet_STX_testCode_STX_antibioticCode_STX_labNo_STX_bbDesc_STX_itemName_STX_ordItmRowID
		.e  i (dataField="MinDT") d
		..s retStr=minQty_" "_minDateTime_STX_unit_STX_range_STX_minDate_STX_minTime_STX_testSet_STX_testCode_STX_antibioticCode_STX_labNo_STX_bbDesc_STX_itemName_STX_ordItmRowID
		.e  i (dataField="MaxDT") d
		..s retStr=maxQty_" "_maxDateTime_STX_unit_STX_range_STX_maxDate_STX_maxTime_STX_testSet_STX_testCode_STX_antibioticCode_STX_labNo_STX_bbDesc_STX_itemName_STX_ordItmRowID
		.e  i (dataField="First") d
		..s retStr=result_STX_unit_STX_range_STX_receiveDate_STX_receiveTime_STX_testSet_STX_testCode_STX_antibioticCode_STX_labNo_STX_bbDesc_STX_itemName_STX_ordItmRowID 
		.e  i (dataField="touchQty") d
		..i retStr'="" s retStr=retStr_ETX
		..s retStr=retStr_result_STX_unit_STX_range_STX_receiveDate_STX_receiveTime_STX_testSet_STX_testCode_STX_antibioticCode_STX_labNo_STX_bbDesc_STX_itemName_STX_ordItmRowID
		.e  i (dataField="")&&(ifSingle=1) d
		..s retStr=result_STX_unit_STX_range_STX_receiveDate_STX_receiveTime_STX_testSet_STX_testCode_STX_antibioticCode_STX_labNo_STX_bbDesc_STX_itemName_STX_ordItmRowID		
		.e  d
		..i retStr'="" s retStr=retStr_ETX
		..s retStr=retStr_result_STX_unit_STX_range_STX_receiveDate_STX_receiveTime_STX_testSet_STX_testCode_STX_antibioticCode_STX_labNo_STX_bbDesc_STX_itemName_STX_ordItmRowID		
		.;w retStr,!
		.s count=count+1
		.i ((dataField="First")||(dataField="FirstDT")),count>0 s ifFind=1
	}	
	d rset.Close()
	q
}

/// edit mfc 20200106
/// 根据就诊号、登记号或科室的化验项目标准码standardCode，取检验结果,ifSingle=1取最新值
/// 返回值：多个结果以ETX分割,每个以STX分割：检验值，单位，检验正常值范围
/// 根据就诊号、登记号或科室的化验项目标准码standardCode，取检验结果,ifSingle=1取最新值
/// 返回值：多个结果以ETX分割,每个以STX分割：检验值，单位，检验正常值范围
/// w ##class(web.DHCClinicCom).GetTestResult(16,"","","ABO","65745","00:00","65775","00:00")
ClassMethod GetTestResult(needEpisodeID, regNoList, ctlocId, standardCode, startDate, startTime, endDate, endTime, ifSingle = 0, needNote = "", dataField = "", labNoStr = "") As %String
{
	s STX=$c(2)
	s ETX=$c(3)
	s startDate=..ConvertToDateH(startDate)
	s startTime=..ConvertToTimeH(startTime)
	s endDate=..ConvertToDateH(endDate)
	s endTime=..ConvertToTimeH(endTime)
	;b //GetTestResult
	i labNoStr'=""  d
		.;i regNoList="" s regNoList=$p($g(^TEPI(labNoStr)),"\",18)
		.;q:regNoList=""
		..i regNoList="" d
        ..;s regNoList=$p($g(^TEPI(labNoStr)),"\",18)
        ..s OrdId=$o(^OEORD(0,"EpisNo",labNoStr,""))
		..s EpisodeID=$p($g(^OEORD(OrdId)),"^",1)
		..s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
		..s regNoList=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
		.q:regNoList=""
		.;b //regNoList
		.s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNoList),""))
		.s curEpisodeIDList=##class(web.DHCClinicCom).GetPatientEpisodeID("",papmiId,"","","IOE")
		.f i=1:1:$l(curEpisodeIDList,"^") d
			..s maxEpisodeID=$p(curEpisodeIDList,"^",1)
			..s minEpisodeID=$p(curEpisodeIDList,"^",$l(curEpisodeIDList,"^"))
			..s startDate=$p(^PAADM(minEpisodeID),"^",6)
			..s startTime=$p(^PAADM(minEpisodeID),"^",7)
			..i $p(^PAADM(maxEpisodeID),"^",17)>0 s endDate=$p(^PAADM(maxEpisodeID),"^",17)
			..e  s endDate=+$h
			..i $p(^PAADM(maxEpisodeID),"^",18)>0 s endTime=$p(^PAADM(maxEpisodeID),"^",18)
			..e  s endTime=$p($h,",",2)
	i needEpisodeID'="" d
		.s papmiId=$p($g(^PAADM(needEpisodeID)),"^",1)
		.s regNoList=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
		.s paadmDate=$p(^PAADM(needEpisodeID),"^",6)
		.i paadmDate'="" d
			..q:(paadmDate<startDate)
			..s paadmTime=$p(^PAADM(needEpisodeID),"^",7)
			..q:(paadmDate=startDate)&(paadmTime<startTime)
			..s startDate=paadmDate,startTime=paadmTime
		.s paadmDischgDate=$p(^PAADM(needEpisodeID),"^",17)
		.i paadmDischgDate>paadmDate d
			..q:(paadmDischgDate>endDate)
			..s paadmDischgTime=$p(^PAADM(needEpisodeID),"^",18)
			..q:(paadmDischgDate=endDate)&(paadmDischgTime>endTime)
			..;s endDate=paadmDischgDate,endTime=paadmDischgTime	//?为何赋值
	i regNoList="" d
		.s EpisodeIDList=..FindWardPatient("", ctlocId)
		.q:EpisodeIDList=""
		.f i=1:1:$l(EpisodeIDList,"^") d
			..s EpisodeID=+$p(EpisodeIDList,"^",i)
			..s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
			..i regNoList'="" s regNoList=regNoList_"^"
			..s regNoList=regNoList_$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	q:regNoList="" ""	
	s retStr=""
	f i=1:1:$l(regNoList,"^") d
		.s regNo=$p(regNoList,"^",i)
		.q:regNo=""
		.s minQty="",maxQty="",minDateTime="",minDate="",minTime="",maxDateTime="",maxDate="",maxTime=""
		.s ifFind=0,count=0
		.do Find(regNo,standardCode,startDate,endDate)
		
	q retStr
Find(regNo,standardCode,startDate,endDate)	
	//d ##Class(%ResultSet).RunQuery("web.DHCENS.STBLL.Method.PostReportInfo","QryTCResultBySync","","0000000001","WBC","2019-1-1","2019-10-16")	
	//s ^dhcbpmfc(regNo)=standardCode_"/"_$zd(startDate,3)_"/"_$zd(endDate,3)
	s rset=##class(%ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:QryTCResultBySync")
	s ret="",isTooLong=0
	//do rset.Execute("",regNo,standardCode,$zd(startDate,3),$zd(endDate,3))
	do rset.Execute("",regNo,standardCode,startDate,endDate)
	while (rset.Next()) {
		s labNo=rset.GetData(3)
		b ;11
		i (labNoStr="")!(labNo=labNoStr) do
		.b ;in
		.s result=rset.GetData(8)
		.s unit=rset.GetData(10)
		.;s unit=$tr(unit,"^","E")
		.s range=rset.GetData(11)
		.s resultDR =rset.GetData(1)
		.s tcType=rset.GetData(12) //结果格式(N数字,X文本,S列表,A血型ABO,R血型RH,M微生物)
		.s seqnum=count+1
		.s collectDate="" //采集日期
		.s collectTime="" //采集时间
		.s receiveDate=rset.GetData(13) //接收日期
		.s receiveTime=rset.GetData(14) //接收时间		
		.s authDate=rset.GetData(15) //报告日期
		.s authTime=rset.GetData(16) //报告时间
		.i authDate'="" s authDate=$zdh(authDate,3)
		.i authTime'="" s authTime=$zth(authTime,4)
		.s testSet="",antibioticCode="",bbDesc="" //标本名称
		.s testCode=rset.GetData(5)
		.s itemName=rset.GetData(6)		
		.i ((minQty="")!(result<minQty)) d
		..s minQty=result,minDateTime=$zd(authDate,3)_" "_$zt(authTime,2),minDate=authDate,minTime=authTime
		.i ((maxQty="")!(result>maxQty)) d
		..s maxQty=result,maxDateTime=$zd(authDate,3)_" "_$zt(authTime,2),maxDate=authDate,maxTime=authTime
		.i (dataField="Min") d
		..s retStr=minQty_STX_unit_STX_range_STX_minDate_STX_minTime_STX_testSet_STX_testCode_STX_antibioticCode_STX_labNo_STX_bbDesc_STX_itemName_STX_seqnum_STX_receiveDate_STX_receiveTime_STX_collectDate_STX_collectTime
		.e  i (dataField="Max") d
		..s retStr=maxQty_STX_unit_STX_range_STX_maxDate_STX_maxTime_STX_testSet_STX_testCode_STX_antibioticCode_STX_labNo_STX_bbDesc_STX_itemName_STX_seqnum_STX_receiveDate_STX_receiveTime_STX_collectDate_STX_collectTime
		.e  i (dataField="FirstDT") d
		..s retStr=result_" "_$zd(authDate,3)_" "_$zt(authTime,2)_STX_unit_STX_range_STX_receiveDate_STX_receiveTime_STX_testSet_STX_testCode_STX_antibioticCode_STX_labNo_STX_bbDesc_STX_itemName_STX_seqnum_STX_receiveDate_STX_receiveTime_STX_collectDate_STX_collectTime
		.e  i (dataField="MinDT") d
		..s retStr=minQty_" "_minDateTime_STX_unit_STX_range_STX_minDate_STX_minTime_STX_testSet_STX_testCode_STX_antibioticCode_STX_labNo_STX_bbDesc_STX_itemName_STX_seqnum_STX_receiveDate_STX_receiveTime_STX_collectDate_STX_collectTime
		.e  i (dataField="MaxDT") d
		..s retStr=maxQty_" "_maxDateTime_STX_unit_STX_range_STX_maxDate_STX_maxTime_STX_testSet_STX_testCode_STX_antibioticCode_STX_labNo_STX_bbDesc_STX_itemName_STX_seqnum_STX_receiveDate_STX_receiveTime_STX_collectDate_STX_collectTime
		.e  i (dataField="First") d
		..s retStr=result_STX_unit_STX_range_STX_receiveDate_STX_receiveTime_STX_testSet_STX_testCode_STX_antibioticCode_STX_labNo_STX_bbDesc_STX_itemName_STX_seqnum_STX_receiveDate_STX_receiveTime_STX_collectDate_STX_collectTime 
		.e  i (dataField="touchQty") d
		..i retStr'="" s retStr=retStr_ETX
		..s retStr=retStr_result_STX_unit_STX_range_STX_authDate_STX_authTime_STX_testSet_STX_testCode_STX_antibioticCode_STX_labNo_STX_bbDesc_STX_itemName_STX_seqnum_STX_receiveDate_STX_receiveTime_STX_collectDate_STX_collectTime
		.e  i (dataField="")&&(ifSingle=1) d
		..s retStr=result_STX_unit_STX_range_STX_authDate_STX_authTime_STX_testSet_STX_testCode_STX_antibioticCode_STX_labNo_STX_bbDesc_STX_itemName_STX_seqnum_STX_receiveDate_STX_receiveTime_STX_collectDate_STX_collectTime		
		.e  d
		..i retStr'="" s retStr=retStr_ETX
		..s retStr=retStr_result_STX_unit_STX_range_STX_authDate_STX_authTime_STX_testSet_STX_testCode_STX_antibioticCode_STX_labNo_STX_bbDesc_STX_itemName_STX_seqnum_STX_receiveDate_STX_receiveTime_STX_collectDate_STX_collectTime
		.i tcType="M" d  //微生物 
		..do FindSen(resultDR,STX,ETX,unit,range,authDate,authTime,testSet,testCode,labNo,bbDesc,itemName,receiveDate,receiveTime,collectDate,collectTime)

		
		.s count=count+1
		.i ((dataField="First")||(dataField="FirstDT")),count>0 s ifFind=1
	}	
	d rset.Close()
	q
FindSen(resultDR,STX,ETX,unit,range,authDate,authTime,testSet,testCode,labNo,bbDesc,itemName,receiveDate,receiveTime,collectDate,collectTime) 
	s senSet=##class(%ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:QryReportResultSen")	
	do senSet.Execute(resultDR)
	while (senSet.Next()){
		s sequence=senSet.GetData(10) //序号
		s seqnum=sequence
		s ctsnDesc=senSet.GetData(11) //药敏结果名称
		s antibioticDesc=senSet.GetData(12) //抗生素名称
		s antibioticCode=senSet.GetData(13)	//抗生素缩写
		s senMethod=senSet.GetData(4)	//试验方法
		s SenValue=senSet.GetData(5)	//结果值
		s SenISRRange="I折点范围"_senSet.GetData(6)_"S折点范围"_senSet.GetData(7)_"R折点范围"_senSet.GetData(8)
		i retStr'="" s retStr=retStr_ETX
		s curStr=antibioticDesc_ctsnDesc_STX_unit_STX_range_STX_receiveDate_STX_receiveTime_STX_testSet_STX_testCode_STX_antibioticCode_STX_labNo_STX_bbDesc_STX_itemName_STX_seqnum_STX_receiveDate_STX_receiveTime_STX_collectDate_STX_collectTime_STX_antibioticDesc_STX_senMethod_STX_SenValue_STX_SenISRRange
		s retStr=retStr_curStr
	}
	d senSet.Close()
	q
}

/// 20170920 by wq  
/// edit mfc 20191104
/// d ##class(%ResultSet).RunQuery("web.DHCClinicCom","FindLabResultByOrderId","769||4")
/// 功能：获取检查数据
/// 入参：OeordID:医嘱id
/// 返回：ItemCode检验code,ItemDesc:检验描述,Synonym:英文缩写,ItemResult:结果,AbnorFlag:异常标记,ItemUnit:单位,ItemRanges:范围值
Query FindLabResultByOrderId(orderId) As %Query(ROWSPEC = "serialNo,itemCode,itemDesc,abbreviation,unit,result,resultValue,flagUpDown,naturalRange") [ SqlProc ]
{
}

ClassMethod FindLabResultByOrderIdExecute(ByRef qHandle As %Binary, orderId) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    i orderId=""  Quit $$$OK // "医嘱Id不能为空!" 
    s serialNo="",itemCode="",itemDesc="",abbreviation="",unit="",result="",resultValue="",flagUpDown="",naturalRange =""  
    //d ##class(%ResultSet).RunQuery("web.DHCENS.STBLL.Method.PostReportInfo","SelectLISReportByOeordID","3||220")
    s rset=##class(%ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:SelectLISReportByOeordID")
	do rset.Execute(orderId)
	while (rset.Next()) {
		s itemDesc=rset.GetData(1) //检验描述
		s abbreviation=rset.GetData(2) //英文缩写
		s resultValue=rset.GetData(3) //结果
		q:resultValue=""
		s unit=rset.GetData(4) //单位
		s flagUpDown=rset.GetData(5) //异常标记
		s naturalRange=rset.GetData(6) //范围值
		s Sequence=rset.GetData(7) //序号
		s itemCode=rset.GetData(8) //检验code	
		d OutputById
	}
	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputById
    set Data=$lb(serialNo,itemCode,itemDesc,abbreviation,unit,result,resultValue,flagUpDown,naturalRange)
     Set ^CacheTemp(repid,ind)=Data
     Set ind=ind+1
    quit
}

ClassMethod FindLabResultByOrderIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLabResultByOrderIdExecute ]
{
     Set AtEnd=$LIST(qHandle,1)
     Set repid=$LIST(qHandle,2)
     Set ind=$LIST(qHandle,3)
     Set ind=$o(^CacheTemp(repid,ind))
     If ind="" {                // if there are no more rows, finish fetching
         Set AtEnd=1
         Set Row=""
     }
     Else      {                // fetch row
         Set Row=^CacheTemp(repid,ind)
     }
     s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod FindLabResultByOrderIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLabResultByOrderIdExecute ]
{
    Set repid=$LIST(qHandle,2)
     Kill ^CacheTemp(repid)
     Quit $$$OK
}

/// 按范围查找检验数据
ClassMethod GetTestResultByScope(needEpisodeID, regNoList, ctlocId, standardCode, date, time, scope = 20, ifSingle = 0) As %String
{
	// s icuaId=2240
	// s icucriId=5330
	// s date="2014-03-01"
	// s time=22*3600
	// w ##class(web.DHCClinicCom).GetTestResultByScope(needEpisodeID,regNoList,ctlocId,standardCode,date,time,scope,ifSingle)
	s date=..ConvertToDateH(date)
	s time=..ConvertToTimeH(time)
	
	s scope=scope*60
	s dateSec=3600*24
	s startDateTime=((date*dateSec)+time)-scope
	s endDateTime=((date*dateSec)+time)+scope
	
	s fromDate=startDateTime\dateSec
	s fromTime=startDateTime#dateSec
	s toDate=endDateTime\dateSec
	s toTime=endDateTime#dateSec
	
	// w "From:",$zd(fromDate)," ",$zt(fromTime),!
	// w "To:",$zd(toDate)," ",$zt(toTime),!
	
	s retStr=..GetTestResult(needEpisodeID, regNoList, ctlocId, standardCode, fromDate, fromTime, toDate, toTime, ifSingle)
	q retStr
}

/// 通过医生 护士 ID取得姓名 若ID中有~,则到CTPCP中取值(本院人员),否则到DHC_CL_CareProv中取(进修 实习)
ClassMethod GetNameById(docdr As %String) As %String
{
	q:(docdr="")!(docdr=0) ""
	s len=$l(docdr,"~")
	q:(len'=1)&(len'=2) "用户ID不正确!"
	s docName=""
	i len=1 d
	.s docName=$tr($p($g(^CTPCP(+docdr,1)),"^",2)," ","")
	.i $l(docName,"-")>1 s docName=$p(docName,"-",1)
	i len=2 d
	.s clcpRowId=$p(docdr,"~",2)
	.i $g(^DHCCLCP(+clcpRowId))'="" s docName=$li(^DHCCLCP(+clcpRowId),2)
	.e  s docName=""
	i docName="" q "用户不存在!"
	q docName
}

ClassMethod GetMDROSResult(EpisodeID As %String, opstdate As %String, opdate As %String) As %String
{
	s MDROSValue=""
	zn "DHC-LISDATA"
	s MDROSValue=##Class(Service.LIS.MIC.DHCMICReportInfo).GetHasMultipleOrgResByAdmNo(EpisodeID,opstdate,opdate)
	zn "DHC-APP"
	q MDROSValue
}

ClassMethod GetCtlocIdByCodeOrDesc(codeOrDesc As %String, node As %String) As %String
{
	q:node="" ""
	q:codeOrDesc="" ""
	s codeOrDesc=$$ALPHAUP^SSUTIL4(codeOrDesc)
	q $o(^CTLOC(0,node,codeOrDesc,""))
}

ClassMethod GetCtcpIdByInitials(ssusrInitials As %String) As %String
{
	q:ssusrInitials="" ""
	s ssusrInitials=$$ALPHAUP^SSUTIL4(ssusrInitials)
	s userId=$o(^SSU("SSUSR",0,"SSUSR_Initials",ssusrInitials,""))
	q:userId="" ""
	q $P(^SSU("SSUSR",userId),"^",14)
}

ClassMethod GetUserIdByInitials(ssusrInitials As %String) As %String
{
	q:ssusrInitials="" ""
	s ssusrInitials=$$ALPHAUP^SSUTIL4(ssusrInitials)
	q $o(^SSU("SSUSR",0,"SSUSR_Initials",ssusrInitials,""))
}

ClassMethod GetUserTypeName(userId As %String) As %String
{

	//取用户的类别:医生还是护士
	q:userId="" "用户有误!"
	s ctpcpId=$p($g(^SSU("SSUSR",userId)),"^",14)
	i ctpcpId="" d //20140806 其他医护人员
	  	.s retstr=$$ctpcpIdNo	  			
	e  d
		.s retstr=$$ctpcpIdOk(ctpcpId)
	q retstr
ctpcpIdNo()	
		s retStr=""
		s clcpRowId=""	//添加其他医护人员	
		f  s clcpRowId=$o(^DHCCLCP(clcpRowId)) q:clcpRowId=""  d
 			.q:clcpRowId'=userId
 			.s desc=$li(^DHCCLCP(clcpRowId),2)
 			.s alias=$li(^DHCCLCP(clcpRowId),3)
 			.s fdate=$li(^DHCCLCP(clcpRowId),4) 			
 			.s tdate=$li(^DHCCLCP(clcpRowId),5) 			
 			.q:(tdate'="")&&(tdate<+$h)
 			.s inActive=$li(^DHCCLCP(clcpRowId),6)
 			.q:(inActive'="")&&(inActive=1) 			 
 			.s ifDoc=$li($g(^DHCCLCP(clcpRowId)),7) 		
 			.s ifDocDes=""
 			.i ifDoc=0 s ifDocDes="NURSE"
 			.e  s ifDocDes="DOCTOR"
 			.b
 			.s ctcptInternalType=ifDocDes,userName=desc,loadName=alias,ctpcpId=alias,ctpcpDesc=desc
 			.s retStr=ctcptInternalType_"^"_userName_"^"_loadName_"^"_ctpcpId_"^"_ctpcpDesc
		
		q retStr
ctpcpIdOk(ctpcpId)
		;b	;2
		q:ctpcpId="" "该用户未关联医护人员!"
		s ctpcpDesc=""
		i ctpcpId'="" s ctpcpDesc=$P($g(^CTPCP(ctpcpId,1)),"^",2)
		s ctcptId=$P($g(^CTPCP(ctpcpId,1)),"^",4)  ;CTPCP_CarPrvTp_DR
		q:ctcptId="" "该医护人员未定义医护类型!"
		s ctcptInternalType=""
    	i ctcptId'="" s ctcptInternalType=$P($g(^CT("CPT",ctcptId)),"^",4)  ;CT_CarPrvTp:CTCPT_InternalType
		q:ctcptInternalType="" "医护人员类型定义有误!"
		s userName=$p($g(^SSU("SSUSR",userId)),"^",2)
		s loadName=$p($g(^SSU("SSUSR",userId)),"^",1)
		q ctcptInternalType_"^"_userName_"^"_loadName_"^"_ctpcpId_"^"_ctpcpDesc
}

/// 第六组 体温单
/// 获取住院（或存在体温单）病人最近的单个体温单记录项的数据
/// w ##class(web.DHCClinicCom).GetLastestTemperData("35","506546")
ClassMethod GetLastestTemperData(temperItemId As %String, opaId As %String) As %String
{
	q:(temperItemId="") "" //体温项目ID不能为空
	q:(opaId="") "" //病人手术申请排班ID不能为空
	s temperItemId=+temperItemId
	s EpisodeID=$p($g(^DHCANOPArrange(opaId)),"^",1)
	q:(EpisodeID="") 无法获取到病人的就诊ID
	s EpisodeID=+EpisodeID
	s lastDate=(+$h)+1,lastTime=86400,temperChildSub=""
	s result=""
	f  s lastDate=$o(^MR(EpisodeID,"OBS",0,"Item",temperItemId,lastDate),-1) q:(lastDate="")!(result'="")  d
	.f  s lastTime=$o(^MR(EpisodeID,"OBS",0,"Item",temperItemId,lastDate,lastTime),-1) q:(lastTime="")!(result'="")  d
	..f  s temperChildSub=$o(^MR(EpisodeID,"OBS",0,"Item",temperItemId,lastDate,lastTime,temperChildSub)) q:(temperChildSub="")!(result'="")  d
	...s result=$p($g(^MR(EpisodeID,"OBS",temperChildSub)),"^",2)
	
	q result
}

/// 根据数据存储属性(Cache类属性)名称获取与其相关联的体温单记录项的ID
/// w ##class(web.DHCClinicCom).GetPropertyRelateTemperItemId("OPAPATemp")
ClassMethod GetPropertyRelateTemperItemId(propertyCode As %String) As %String
{
	q:(propertyCode="") "数据存储字段代码不能为空"
	s result="",relateTemperItemId=""
	f  s relateTemperItemId=$o(^DHCANC("TemperItem",relateTemperItemId)) q:(relateTemperItemId="")  d
	.s currentPropertyCode=$p($g(^DHCANC("TemperItem",relateTemperItemId)),"^",1)
	.q:(currentPropertyCode'=propertyCode)
	.s result=$p($g(^DHCANC("TemperItem",relateTemperItemId)),"^",2)
	
	q result
}

/// w ##class(web.DHCClinicCom).GetTemperValueList("Temper^RespRate","32938")
ClassMethod GetTemperValueList(propertyCodeStr As %String, opaId As %String) As %String
{
	q:(propertyCodeStr="") 数据存储字段代码不能为空	
	s result=""
	s propertyCodeCount=$l(propertyCodeStr,"^")
	f i=1:1:propertyCodeCount d
	.s propertyCode=$p(propertyCodeStr,"^",i)
	.s temperItemId=..GetPropertyRelateTemperItemId(propertyCode)
	.s singleResult=..GetLastestTemperData(temperItemId,opaId)
	.i i'=1 s result=result_"^"
	.s result=result_singleResult
	
	q result
}

/// move into web.DHCANCom
ClassMethod ChangeTheatreTime(startDate As %String, endDate As %String) As %String
{
	s opaId="",anaId=""
	s currentDate=+$h
	s startDate=..ConvertToDateH(startDate)
	s endDate=..ConvertToDateH(endDate)
	s theareInEvent="szsj001",theareOutEvent="szsj008"
	s count=0
	f i=startDate:1:endDate  d
	.f  s opaId=$o(^DHCANOPArrange(0,"SDate",i,opaId)) q:(opaId="")  d
	..s opaStatus=$p(^DHCANOPArrange(opaId),"^",27)
	..q:(opaStatus'="F")
	..s anStatus=##class(web.DHCANCom).JudgeANStatus(opaId)
	..q:(anStatus'="Y")
	..s theareIn=##class(web.DHCANOPData).GetEventInfo(opaId,theareInEvent)
	..s theareInId=$p(theareIn,"^",5)
	..s theareInDate=$p(^DHCANOrder(theareInId),"^",5)
	..s theareInTime=$p(^DHCANOrder(theareInId),"^",6)
	..s theareOut=##class(web.DHCANOPData).GetEventInfo(opaId,theareOutEvent)
	..s theareOutId=$p(theareOut,"^",5)
	..s theareOutDate=$p(^DHCANOrder(theareOutId),"^",5)
	..s theareOutTime=$p(^DHCANOrder(theareOutId),"^",6)
	..s operStartDate=$p(^DHCANOPArrange(opaId),"^",14)
	..i (theareInDate>theareOutDate)&(theareInDate>operStartDate)  d
	...s ^TMPCCQ(opaId,"OriginalTheareInDate",theareInId)=theareInDate
	...s $p(^DHCANOrder(theareInId),"^",5)=theareInDate-1
	..s count=count+1
	q count
}

ClassMethod AddParaItemIdToOrder(opaId) As %String
{
	s orderId=""
	s paraId=""
	s paraId=$o(^DHCANPara(0,opaId,paraId))
	q:(paraId="") ""
	f  s orderId=$o(^DHCANOrder(0,"OPApp",+opaId,orderId)) q:(orderId="")  d
	.s $p(^DHCANOrder(orderId),"^",36)=""
	.s recordItemId=$p(^DHCANOrder(orderId),"^",2)
	.s paraItemId="",paraItemRelateItemId="",paraItemRelateCatId=""
	.f  s paraItemId=$o(^DHCANPara(paraId,"I",paraItemId)) q:(paraItemId="")  d
	..s paraItemRelateItemId=$p(^DHCANPara(paraId,"I",paraItemId),"^",4)
	..q:(paraItemRelateItemId="")
	..q:(paraItemRelateItemId'="")&(recordItemId'=paraItemRelateItemId)
	..s $p(^DHCANOrder(orderId),"^",36)=paraId_"||"_paraItemId
	.i ($p(^DHCANOrder(orderId),"^",36)="")  d
	..s viewCatId=$p(^DHCANOrder(orderId),"^",16)
	..s paraItemId=""
	..f  s paraItemId=$o(^DHCANPara(paraId,"I",paraItemId)) q:(paraItemId="")  d
	...s paraItemRelateCatId=$p(^DHCANPara(paraId,"I",paraItemId),"^",11)
	...q:(paraItemRelateCatId="")
	...q:(paraItemRelateCatId'="")&(paraItemRelateCatId'=viewCatId)
	...s $p(^DHCANOrder(orderId),"^",36)=paraId_"||"_paraItemId
	
	q 0
}

ClassMethod GetConnectStr()
{
	&sql(select LayoutManager into :ConnectStr from websys.configuration)
	q ConnectStr
}

ClassMethod GetHospital() As %String
{
	&sql(select hosp_desc into :hospitalName from SQLUSER.ct_hospital)
	q $g(hospitalName)
}

// w ##class(web.DHCClinicCom).GetPatLevelByPapmiId(9)

ClassMethod GetPatLevelByPapmiId(AdmRowId) As %String
{
	s PAPMIRowId=+$g(^PAADM(+AdmRowId))
	q:PAPMIRowId="" ""
	s ret=""
	s flag=1	;控制是否带入密级
	i flag=1
	{
		s ret=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(PAPMIRowId,.ErrMsg)
	}
	else
	{
		s ret=""
	}
	q ret
}

// ModelName:模块名称：手术申请打印：ANOPAPPPrint，麻醉监护：ANMonitorPrint，重症监护：ICUMonitorPrint

// 血透打印：BPPrint

// Condition：查询条件：比如stDate

// , Content：内容：可以是唯一标识的,如果多个用/分割

// , SecretCode:密级,可以通过接口获取 

// Success, UserId, IP, Mac, CName, LocId:科室, GroupId：安全组Id

// d ##class(web.DHCClinicCom).InsertLog()

ClassMethod InsertLog(ModelName, Condition, Content, SecretCode, Success As %String = "Y", UserId = "", IP = "", Mac = "", CName = "", LocId = "", GroupId = "") As %String
{
	k ^TEMPWHL
	s ^TEMPWHL("InsertLog",Content)=ModelName_"@"_Condition_"@"_Content_"@"_SecretCode_"@"_Success_"@"_UserId_"@"_IP_"@"_Mac_"@"_CName_"@"_LocId_"@"_GroupId
	//retOpaStr+"/"+retEpsStr
	s retEpsStr=$p(Content,"/",1)
	s retIdStr=$p(Content,"/",2)
	//i IP="" s IP=..GetMacIp()
	s Content="{"_"EpisodeID:"_retEpsStr_","_"uniqueId:"_retIdStr_"}"
	s Condition="{"_Condition_"}"
	//s Condition="{"_"test:"_"测试"_"}"
	//s Content=""
	s ret=##class(web.DHCEventLog).EventLog(ModelName, Condition, Content, SecretCode,"Y",UserId,IP, Mac, CName,LocId,GroupId)
	s ^DYLLogtmp=ret
	q ret
}

ClassMethod GetMacIp()
{
	q $zu(67,15,$j)
}

Query GetMasterItem(needItemCatId As %String, arcimDesc As %String) As %Query(ROWSPEC = "arcimDesc:%String,arcimId:%String")
{
}

ClassMethod GetMasterItemExecute(ByRef qHandle As %Binary, needItemCatId As %String = "", needArcimDesc As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	i (needItemCatId="")&&(needArcimDesc="") Set qHandle=$lb(0,repid,0) Quit $$$OK
    i (needArcimDesc'="") s needArcimDesc=$$ALPHAUP^SSUTIL4(needArcimDesc)
 	s arcimSub=0 
 	f  s arcimSub=$o(^ARCIM(arcimSub)) q:arcimSub=""  d
	.s arcimVer=0 f  s arcimVer=$o(^ARCIM(arcimSub,arcimVer)) q:arcimVer=""  d
	..s arcimId=arcimSub_"||"_arcimVer
	..s aliasId="",aliasDesc=""
	..f  s aliasId=$O(^ARC("ALIAS",0,"ARCIM",arcimId,aliasId)) q:aliasId=""  d
	    ...i aliasDesc'="" s aliasDesc=aliasDesc_"^"
	    ...s aliasDesc=aliasDesc_$$ALPHAUP^SSUTIL4($p(^ARC("ALIAS",aliasId),"^",6))
	..q:aliasDesc=""
	..//s aliasDesc=$$ALPHAUP^SSUTIL4($p(^ARC("ALIAS",aliasId),"^",6))
	..s arcimDesc=$p(^ARCIM(arcimSub,arcimVer,1),"^",2)
	..q:(needArcimDesc'="")&(("^"_aliasDesc_"^")'[("^"_needArcimDesc))&(arcimDesc'[needArcimDesc)
	..s itemcatDR=$p(^ARCIM(arcimSub,arcimVer,1),"^",10)
	..i (+needItemCatId=0)!(+needItemCatId=itemcatDR) d OutputRow5
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow5
	set Data=$lb(arcimDesc,arcimId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetMasterItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMasterItemExecute ]
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

ClassMethod GetMasterItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMasterItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/*
ClassMethod Log(type, value, date = "", time = "")
{
	d ..LogByPId(type,"", value, date, time)
	
}

ClassMethod LogByPId(type, pId, value = "", date = "", time = "")
{
	// w ##class(web.DHCClinicCom).LogByPId(type,"", value, date, time)
	s $ZT="LogError"
	i type="" s type="undefined"
	i value="" s value=type
	i pId="" s pId="null"
	s date="" s date=##class(web.DHCClinicCom).ConvertToDate(+$h)
	s time="" s time=##class(web.DHCClinicCom).ConvertToTime($p($h,",",2))
	
	i $g(^dhccldebuglog(type,pId,date,time))'="" d
	.s index=0
	.s index=+$O(^dhccldebuglog(type,pId,date,time,index),-1)+1
	.s ^dhccldebuglog(type,pId,date,time,index)=value
 	e  d
 	.s ^dhccldebuglog(type,pId,date,time)=value
 	; 在terminal执行时输出
 	i ##class(%Library.Device).GetType()=1 w "@WRITE:"_value,!
 	q 0
LogError
	s ^dhccldebuglog("Error")=$h_" "_$ZERROR
 	q "Error"
}
*/
ClassMethod Log(type, value, date = "", time = "")
{
	d ..LogByPId(type,"", value, date, time)
	/*i type="" s type="undefined"
	s date="" s date=..ConvertToDate(+$h)
	s time="" s time=..ConvertToTime($p($h,",",2))
	
	i $g(^tmpdebug(type,date,time))'="" d
	.s index=""
	.s index=+$O(^tmpdebug(type,date,time,index),-1)+1
	.s ^tmpdebug(type,date,time,index)=value
 	e  d
 	.s ^tmpdebug(type,date,time)=value
 	*/
}

ClassMethod LogByPId(type, pId, value = "", date = "", time = "")
{
	// w ##class(web.DHCClinicCom).LogByPId(type,"", value, date, time)
	s $ZT="LogError"
	i type="" s type="undefined"
	i value="" s value=type
	i pId="" s pId="null"
	s date="" s date=##class(web.DHCClinicCom).ConvertToDate(+$h)
	s time="" s time=##class(web.DHCClinicCom).ConvertToTime($p($h,",",2))
	
	i $g(^dhccldebuglog(type,pId,date,time))'="" d
	.s index=0
	.s index=+$O(^dhccldebuglog(type,pId,date,time,index),-1)+1
	.s ^dhccldebuglog(type,pId,date,time,index)=value
 	e  d
 	.s ^dhccldebuglog(type,pId,date,time)=value
 	; 在terminal执行时输出
 	i ##class(%Library.Device).GetType()=1 w "@WRITE:"_value,!
 	q 0
LogError
	s ^dhccldebuglog("Error")=$h_" "_$ZERROR
 	q "Error"
}

ClassMethod GetPath()
{
	&sql(select pathtoreports into :reportPath from websys.configuration)
	q reportPath
}

/// 补齐登记号位数(前面自动补0)
ClassMethod GetPatCoverRegNo(RegNo As %String) As %String
{
	//w ##class(web.DHCClinicCom).GetPatCoverRegNo("381")
	s retRegNo=""
	q:RegNo="" ""
	s coverNumber=$P($g(^CF("PACTF",1,3)),"^",5)
	q:coverNumber="" RegNo	
	i ($l(RegNo)<coverNumber) d
	.f i=($l(RegNo)+1):1:coverNumber d
	..i retRegNo=""  s retRegNo="0"_RegNo
	..e  s retRegNo="0"_retRegNo
	q retRegNo
}

/// 获取汉字简拼w ##class(web.DHCClinicCom).GetChinaChar("我是中国人")
ClassMethod GetChinaChar(chines As %String) As %String
{
	q:chines="" ""
	s count=$l(chines)
	s retstr=""
	f i=1:1:count d
	  .s char=$e(chines,i)
	  .s rowId=$o(^DHCCLC("ChineseChar",char,""))
	  .i rowId'="" s alias=^DHCCLC("ChineseChar",char,rowId)
	  .i rowId="" s alias=char
 	  .s retstr=retstr_alias
    q retstr
}

// 20160914+dyl+手术列表界面病区

/// w ##class(%ResultSet).RunQuery("web.DHCClinicCom","GetWard","感染二")
Query GetWard(code As %String) As %Query(ROWSPEC = "desc:%String,rw:%String")
{
}

ClassMethod GetWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetWardExecute(ByRef qHandle As %Binary, code As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s code=##class(web.DHCClinicCom).GetChinaChar(code)
	s code=$$ALPHAUP^SSUTIL4(code)
 	s curHospId=%session.Data("LOGON.HOSPID")	;当前登陆的医院Id
 	s sub=0 f  s sub=$o(^PAWARD(sub)) q:(sub="")!(sub="BED_BedType_DR")  d
	    .q:$p(^PAWARD(sub),"^",6)'="Y"
	    .s linkCtlocId=$p(^PAWARD(sub),"^",5)
	    .s hospId=$p(^CTLOC(linkCtlocId),"^",22)
	    .q:curHospId'=hospId
	    .s desc=$p(^PAWARD(sub),"^",2)
	    .q:($$ALPHAUP^SSUTIL4(##class(web.DHCClinicCom).GetChinaChar(desc))'[code)&(code'="")
	    .i desc["-" d
			..s desc=$p(desc,"-",2)
	   	.Do OutwardRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutwardRow
	set Data=$lb(desc,sub)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWardExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

// 20170515

ClassMethod GetDateFormat() As %String
{
	s dateformat=$lg(^websys.ConfigurationD(1),10)
	s datesper=$lg(^websys.ConfigurationD(1),4)
	i (dateformat="DMY") Quit "j/n/Y"
	i (dateformat="YMD") Quit "Y-m-d"
	Quit "j/n/Y"
}

ClassMethod GetAppDateFormat() As %String
{
	s dateformat=$lg(^websys.ConfigurationD(1),10)
	s datesper=$lg(^websys.ConfigurationD(1),4)
	i (dateformat="DMY") Quit "dd/MM/yyyy"
	i (dateformat="YMD") Quit "yyyy-MM-dd"
	Quit "yyyy-MM-dd"
}

/// w ##class(web.DHCClinicCom).CheckIfAppLoc(1)
ClassMethod CheckIfAppLoc(ctlocId)
{
	s ret=0
	s ctlocliststr=..GetLocIdByLocListCode("INOPDEPT^OUTOPDEPT^EMOPDEPT")
	i ("^"_ctlocliststr_"^")[("^"_ctlocId_"^") s ret=1
	;b
	q ret
}

Query FindSurgeonLocList(desc As %String, locListCodeStr As %String = "", EpisodeID As %String = "", operId As %String = "", surgeonId As %String = "") As %Query(ROWSPEC = "ctlocId:%String,ctlocDesc:%String,ctlocCode:%String,hospital:%String") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCClinicCom","FindSurgeonLocList","zxy","INOPDEPT^OUTOPDEPT^EMOPDEPT","","","338")
ClassMethod FindSurgeonLocListExecute(ByRef qHandle As %Binary, desc As %String, locListCodeStr As %String = "INOPDEPT", EpisodeID As %String = "", operId As %String = "", surgeonId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	;转吧，汉字不方便
	s find=0
	s desc=##class(web.DHCClinicCom).GetChinaChar(desc)
	s desc=$$ALPHAUP^SSUTIL4(desc)
	/*
	if operId'="" d
		.q:$d(^DHCANC("LocOperation",0,"OperLoc",operId))<1
		.s tctlocId=""
		.f  s tctlocId=$o(^DHCANC("LocOperation",0,"OperLoc",operId,tctlocId)) q:tctlocId=""  d
			..s ctlocId=tctlocId
			..s ctlocDesc=$p(^CTLOC(ctlocId),"^",2)
			..s ctlocCode=$p(^CTLOC(ctlocId),"^",1)
			..s find=1
			..Do OutputRow6s
	i find=1 Set qHandle=$lb(0,repid,0) Quit $$$OK
	*/
	i surgeonId'="" d
		.s ctlocIdS=""
		.f  s ctlocIdS=$o(^RB("RES",0,"CTPCP",surgeonId,ctlocIdS)) q:ctlocIdS=""  d
		..q:'$d(^CTLOC(ctlocIdS))
		..s ctlocId=ctlocIdS
		..s ctlocDesc=$p(^CTLOC(ctlocId),"^",2)
		..i $l(ctlocDesc,"-")>1 s ctlocDesc=$p(ctlocDesc,"-",2)
		..q:(desc'="")&($$ALPHAUP^SSUTIL4(##class(web.DHCClinicCom).GetChinaChar(ctlocDesc))'[desc)
		..s ctlocCode=$p(^CTLOC(ctlocId),"^",1)
		..s find=1
		..Do OutputRow6s
	i find=1 Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s locListCodeStr=..AdjustLocListCode(locListCodeStr,EpisodeID)
	s ctlocIdList=..GetLocIdByLocListCode(locListCodeStr)
	f i=1:1:$l(ctlocIdList,"^") d
		.s ctlocId=$p(ctlocIdList,"^",i)
		.q:ctlocId=""
		.q:'$d(^CTLOC(ctlocId))
		.s ctlocDesc=$p(^CTLOC(ctlocId),"^",2)
		.i $l(ctlocDesc,"-")>1 s ctlocDesc=$p(ctlocDesc,"-",2)
		.q:(desc'="")&($$ALPHAUP^SSUTIL4(##class(web.DHCClinicCom).GetChinaChar(ctlocDesc))'[desc)
		.s ctlocCode=$p(^CTLOC(ctlocId),"^",1)
		.s find=1
		.Do OutputRow6s
	i (find=0)!(ctlocIdList="") d
		.s ctlocrowid="" f  s ctlocrowid=$o(^CTLOC(ctlocrowid)) q:ctlocrowid=""  d
			..q:'$d(^CTLOC(ctlocrowid))
			..;b	;in
			..s ctlocDesc=$p(^CTLOC(ctlocrowid),"^",2)
			..i $l(ctlocDesc,"-")>1 s ctlocDesc=$p(ctlocDesc,"-",2)
			..;w ##class(web.DHCClinicCom).GetChinaChar(ctlocDesc)_"/"
			..q:(desc'="")&($$ALPHAUP^SSUTIL4(##class(web.DHCClinicCom).GetChinaChar(ctlocDesc))'[desc)
			..s ctlocId=ctlocrowid
			..Do OutputRow6s	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow6s
	set Data=$lb(ctlocId,ctlocDesc,ctlocCode,hospital)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod FindSurgeonLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSurgeonLocListExecute ]
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

ClassMethod FindSurgeonLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSurgeonLocListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// 更新：mfc 2018/5/28

// 功能：根据检验号获取医嘱相关信息

// 入参：labNo检验号、arcimId医嘱码表ID

// 返回：医嘱数据

// w ##class(web.DHCClinicCom).GetOEORDStrByLabNo("","")

ClassMethod GetOEORDStrByLabNo(labNo As %String = "", arcimId As %String = "") As %String
{
	q:labNo="" "检验号空"
	s retStr=""
	s oeordId=""
	f  s oeordId=$o(^OEORD(0,"EpisNo",labNo,oeordId)) q:(oeordId="")  d
	.s oeoriSub=""
	.f  s oeoriSub=$o(^OEORD(0,"EpisNo",labNo,oeordId,oeoriSub)) q:(oeoriSub="")  d
	..q:'$d(^OEORD(oeordId,"I",oeoriSub))
	..s oearcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
	..q:(arcimId'="")&&(oearcimId'=arcimId)
	..s oeoriSttDat=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)
	..s oeoriSttTim=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)
	..s retStr=oearcimId_"^"_oeoriSttDat_"^"_oeoriSttTim
	q retStr
}

/// 更新：mfc 2019/11/1
/// 功能：根据就诊号，获取检查医嘱相关数据
/// 入参：paadmdr就诊号，startDate开始日期，enddate结束日期
/// 返回：TItemName医嘱名称，TItemDate开医嘱日期，TItemTime开医嘱时间，TOEOrderDr医嘱id，其他见段落注释
/// d ##class(%ResultSet).RunQuery("web.DHCClinicCom","FindStudyByAdm","","","")
Query FindStudyByAdm(paadmdr As %String, startDate As %String = "", enddate As %String = "") As %Query(ROWSPEC = "TStudyNo,TItemName,TItemDate,TItemStatus,TOEOrderDr,TIsIll,TLocName,TreplocDr,TImgBrowse,TOpenRpt,Mem,TMBrowse")
{
}

ClassMethod FindStudyByAdmExecute(ByRef qHandle As %Binary, paadmdr As %String, startDate As %String = "", enddate As %String = "") As %Status
{
	
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	i paadmdr="" Quit $$$OK
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s enddate=##class(web.DHCClinicCom).ConvertToDateH(enddate)
	s StudyNo=""
	s rset=##class(%ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:SelectPACSItemListByDate")
	do rset.Execute(paadmdr,startDate,enddate)
	while (rset.Next()) {
		s TItemName=rset.GetData(1) //医嘱名称
		s TItemDate=rset.GetData(2) //开医嘱日期
		s TItemTime=rset.GetData(3) //开医嘱时间
		s TOEOrderDr=rset.GetData(4) //医嘱id		
		s RptRowID=rset.GetData(5) //报告id
		s RrtDate=rset.GetData(6) //报告日期
		s RrtTime=rset.GetData(7) //报告时间
		s TOpenRpt=rset.GetData(8) //报告链接
		s TImgBrowse=rset.GetData(9) //图像链接
		s RISRSysCode=rset.GetData(10) //系统类型代码 
		s TItemStatus=rset.GetData(11) //是否发布
		s TreplocDr=rset.GetData(12) //检查科室代码
		s TLocName=rset.GetData(13) //检查科室名称
		s TIsIll=rset.GetData(14) //是否阳性
		s Memo=rset.GetData(15) //备注
		s TMBrowse=rset.GetData(16) //注意事项
		Do OutputRow1		
	}
	d rset.Close()
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow1
	set Data=$lb(StudyNo,TItemName,TItemDate,TItemStatus,TOEOrderDr,TIsIll,TLocName,TreplocDr,TImgBrowse,TOpenRpt,Memo,TMBrowse)
 	Set ^CacheTemp(repid,ind)=Data
 	//s ^TMPINV(ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindStudyByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindStudyByAdmExecute ]
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

ClassMethod FindStudyByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindStudyByAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

///  d ##class(%ResultSet).RunQuery("web.DHCClinicCom","FindRptContent","")
/// CR：mafucheng 20191031
/// 功能：获取检查记录文本结果
/// 入参：OEItemRowID:医嘱id
/// 返回：ExamDesc:检查所见,ResultDesc:诊断意见
Query FindRptContent(OEItemRowID As %String) As %Query(ROWSPEC = "ExamDesc:%String,ResultDesc:%String")
{
}

ClassMethod FindRptContentExecute(ByRef qHandle As %Binary, OEItemRowID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s rset=##class(%ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:SelectReportByOeordID")
	do rset.Execute(OEItemRowID)
	while (rset.Next()) {
		s ExamDesc=rset.GetData(1) //检查所见
		s ResultDesc=rset.GetData(2) //诊断意见
		s strOrderName=rset.GetData(3) //医嘱名称
		Do OutReport
	}
	d rset.Close()
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutReport
	set Data=$lb(ExamDesc,ResultDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	//s ^TMPINV(ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindRptContentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRptContentExecute ]
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

ClassMethod FindRptContentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRptContentExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add 20191106
/// w ##Class(web.DHCClinicCom).GetGroupDescById(100)
/// 根据安全组ID获取安全组描述
/// 入参：安全组ID
/// 返回：安全组描述
ClassMethod GetGroupDescById(GroupId) As %String
{
	q:GroupId=""
	s GroupDesc=$p($g(^SSU("SSGRP",GroupId)),"^",1)
	q GroupDesc
}

// 清空手术相关与基础数据相关数据

/// w ##class(web.DHCClinicCom).ClearOpSetInfo()
ClassMethod ClearOpSetInfo() As %String
{
	b	;清空手术配置与基础数据相关数据,请谨慎操作，已经使用的正式库严禁操作，g继续，q返回
	k ^DHCANOPLOCStock	;门诊预备手术耗材，相关：科室Id，医嘱项Id
	k ^DHCCLCPI	;其他医护人员维护，维护实习或进修人员，相关：科室Id
	;*****手术申请配置---start
	k ^DHCCLSet("AnOp","AppArcimId")	;手术申请对应的医嘱项，相关：医嘱项Id
	k ^DHCCLSet("AnOp","IPDefOpLoc")    ;住院申请默认手术室,相关：科室Id
	k ^DHCCLSet("AnOp","OPDefOpLoc")	;门诊申请默认手术室,相关：科室Id
	;*****------end
	k ^DHCANC("OPRoom")	;手术间设置，新医院需重新配置，相关：手术室Id
	k ^DHCANRoomEquip	;跟手术间相关，需重新配置
	k ^DHCANC("SPA") 	;手术部位预防用药,相关：医嘱项Id
	k ^DHCANC("IMLink")	;麻醉关联医嘱套，相关：医嘱项Id
	k ^DHCCLC("MedicalSafety") ;不良事件维护，相关：科室id
	k ^DHCANOPSET	;手术麻醉科室 ，相关：科室id
	k ^DHCANOPDocOper("DocOper")	;手术医师授权
	&sql(update sqluser.DHC_ANC_CommonOrd set ANCO_Arcim_Dr=null where ANCO_Arcim_Dr is not null)
	
	q "配置清除完毕,请到前台页面重新维护数据"
}

/// w ##class(web.DHCClinicCom).ClearOPData()
ClassMethod ClearOPData()
{
	b	;清除手术相关业务数据，请谨慎操作，已经使用的正式库严禁操作，g继续，q返回
	k ^DHCANOPArrange	;排班表
	k ^OR	;麻醉表及麻醉安排信息相关其他表
	k ^DHCANOPArrangeExtend	;扩展信息表
	k ^DHCCLLogD	//手术日志
	k ^DHCCLLogI
	k ^DHCANArr
	k ^DHCANARRAGE("Pack")
	k ^DHCANARRAGE("ch")
	k ^DHCANARRAGE("jb")
	k ^DHCANARRAGE("note")
	k ^DHCANARRAGE("opreq")
	k ^DHCANOrder	;手麻
	k ^DHCANPeriOperPeriod	;手术干预
	k ^DHCANPeriOperPeriodExtend
	k ^DHCANPara	;
	k ^DHCANRRisk	;手术风险评估
	k ^DHCANAduitAccredit	;科室主任审核授权
	k ^User.DHCANCOperAuditD ;科室自定义手术维护
    k ^User.DHCANCOperAuditI
	q "相关业务数据已清除"
}

// "PDF预览服务器配置","重症设备管理","重症设备与床关联"配置数据清除

/// w ##class(web.DHCClinicCom).ClearICUSetData()
ClassMethod ClearICUSetData()
{
	b	;重症相关配置数据，请谨慎操作，已经使用的正式库严禁操作，g继续，q返回
    &sql(delete sqluser.DHC_ANC_PDFConfig)	;PDF预览服务器配置
	&sql(delete sqluser.DHC_ICU_Device)	    ;重症设备管理
	&sql(delete sqluser.DHC_ICU_BedDevice)	;重症设备与床关联
	q "ok"
}

// 清空重症相关数据：与基础数据相关

/// w ##class(web.DHCClinicCom).ClearICUSetInfo()
ClassMethod ClearICUSetInfo() As %String
{
	b	;重症相关配置数据，请谨慎操作，已经使用的正式库严禁操作，g继续，q返回
	k ^DHCICUBedEquip ;重症监护设备维护，相关：病区Id
	k ^DHCCLSet("ICU","Oeore") ;医嘱关联用药途径,相关：用药途径Id
	&sql(delete sqluser.dhc_icuc_recorditem where ICUCRI_Arcim_Dr is not null)	;重症常用医嘱
	;重症项目汇总，相关：科室Id，建议手工修改，可以sqlupdate相关科室id:DHC_ICUC_IOItem,ICUCIOI_Ctloc_Dr字段
	k ^DHCICUC("OrdMapping")	;医嘱关联常用医嘱，相关：医嘱项Id，科室Id(选择，不是必须)
	f i=101:1:1000 d
		.k ^DHCICUPara(i)	;科室显示模板：建议手工修改，前100保持不变，需要则页面修改科室即可
	;重症统计维护：建议手工修改，需要则页面修改科室即可
	q "ok"
}

// 清重症业务数据

/// w ##class(web.DHCClinicCom).ClearICUData()
ClassMethod ClearICUData()
{
	b	;清重症业务数据，请谨慎操作，已经使用的正式库严禁操作，g继续，q返回
	f i=101:1:1000 k ^DHCICUPara(i)	;dhc_icu_para,显示模板
	k ^DHCICUPara(0,"ICUA")
	s ^DHCICUPara(0)=100
	k ^DHCICUArrange	;重症列表dhc_icu_arrange
	k ^DHCICUOrder	;重症存储数据dhc_icu_order
	k ^DHCICUInquiry
	k ^BS.ICU.DocEventD ;预警数据清除
	k ^BS.ICU.DocEventI ;预警数据清除
	
	k ^ICU.Data.OrderD
	k ^ICU.Data.OrderI
	k ^ICU.Data.OrderItemD
	k ^ICU.Data.OrderItemI
	k ^ICU.Data.ArrangeD
	k ^ICU.Data.ArrangeI
	k ^ICU.Data.InfusionD
	k ^ICU.Data.InfusionI
	k ^ICU.Data.IntubationD
	k ^ICU.Data.IntubationI
	k ^ICU.Data.OrderInstructionD
	k ^ICU.Data.OrderInstructionI
	k ^ICU.Data.OrderRawD
	k ^ICU.Data.OrderRawI
	k ^ICU.Data.OrderShiftD
	k ^ICU.Data.OrderShiftI
	k ^ICU.Data.RecordD
	k ^ICU.Data.RecordI
	k ^ICU.Data.SheetD
	k ^ICU.Data.SheetI
	k ^ICU.Data.TodoItemD
	k ^ICU.Data.TodoItemI
	
	k ^User.DHCICUCatheterChangeD
	k ^User.DHCICUCatheterChangeI
	k ^User.DHCICUCatheterDetailD
	k ^User.DHCICUCatheterDetailI
	k ^User.DHCICUCatheterDetailICUD
	k ^User.DHCICUCatheterDetailICUI
	k ^User.DHCICUCatheterRecordD
	k ^User.DHCICUCatheterRecordI
	k ^User.DHCICUCCatheterD
	k ^User.DHCICUCCatheterI
	q "相关业务数据已清除，科室显示模板请倒完科室后在前台页面修改"
}

/// 清血透业务数据
/// w ##class(web.DHCClinicCom).ClearBPData()
ClassMethod ClearBPData()
{
	b	;请谨慎操作，已经使用的正式库严禁操作，g继续，q返回
	&sql(delete sqluser.dhc_bp_arrange)		;血透安排表
	&sql(delete sqluser.DHC_BP_ArrangeScheme)	;透析方案记录
	&sql(delete sqluser.DHC_BP_ArrangeExtend)	;透析记录扩展表
	&sql(delete sqluser.DHC_BP_ArrangeAnticoagulantDrug)	;透析抗凝记录
	&sql(delete sqluser.DHC_BP_ArrangeConsumable)	;透析器材
	&sql(delete sqluser.DHC_BP_ArrangeStock)	;透析减库存记录
	&sql(delete sqluser.DHC_BP_ArrangeEquipRunPara)	;透析设备运行模式
	&sql(delete sqluser.DHC_BP_VascularAccess)	;血管通路	
	//&sql(delete sqluser.DHC_BP_Authorization)	;医护分类
	//&sql(delete sqluser.DHC_BP_AuthorizationItem)	;医护安全组
	&sql(delete sqluser.DHC_BP_Diagnos)	;诊断
	&sql(delete sqluser.DHC_BP_InquiryStat)	;统计条件（时间段比对）
	&sql(delete sqluser.DHC_BP_Message)	;检验提醒记录
	&sql(delete sqluser.DHC_BP_OrderItem)	;医嘱记录
	&sql(delete sqluser.DHC_BP_PatRegVisitStatus)	;转归记录
	&sql(delete sqluser.dhc_bp_patregister)		;血透登记表
	&sql(delete sqluser.DHC_BP_Record)	;监护记录
	&sql(delete sqluser.DHC_BP_Scheme)	;透析方案
	&sql(delete sqluser.DHC_BP_SchemeAnticoagulantDrug)	;方案抗凝记录
	&sql(delete sqluser.DHC_BP_SchemeConsumable)	;方案透析器材
	&sql(delete sqluser.DHC_BP_SchemeEquipRunPara)	;方案设备运行模式
	&sql(delete sqluser.DHC_BP_Treatment)	;治疗记录
	
	&sql(delete sqluser.DHC_BP_SendShortMessage)	;预约短信
	&sql(delete sqluser.DHC_BP_PatSetUpBedGroup)	;关联床位组
	&sql(delete sqluser.DHC_BP_SignIn)	;签到
	&sql(delete sqluser.DHC_BP_DialysisApp)	;病房制定方案(血液净化申请)
	&sql(delete sqluser.DHC_BP_DiaAppAntDrug)	;病房制定方案(血液净化申请)抗凝方式
	&sql(delete sqluser.DHC_BP_PatSurplus)	;台账
	
	&sql(delete sqluser.DHC_BP_Detection)	;质量控制检测记录
	&sql(delete sqluser.DHC_BP_DetectionUser)	;质量控制检测参与人员
	&sql(delete sqluser.DHC_BP_EquipMaintain)	;设备保养
	&sql(delete sqluser.DHC_BP_EquipMaintainUser)	;设备保养参与人员
	q "ok"
}

/// 清血透配置数据(先备份后清空)
/// w ##class(web.DHCClinicCom).ClearBPSetInfo()
ClassMethod ClearBPSetInfo() As %String
{
	;床位维护
	m ^TmpDHCBPC("Bed") = ^DHCBPC("Bed")
	&SQL(update sqluser.DHC_BPC_Bed set BPCB_DataAttribution=null where BPCB_DataAttribution is not null)
	i (SQLCODE'=0)&(SQLCODE'=100)  q SQLCODE
	;床位组维护
	m ^TmpDHCBPC("BedGroup") = ^DHCBPC("BedGroup")
	&SQL(update sqluser.DHC_BPC_BedGroup set BPCBG_Location_Dr=null where BPCBG_Location_Dr is not null)
	i (SQLCODE'=0)&(SQLCODE'=100)  q SQLCODE
	&SQL(update sqluser.DHC_BPC_BedGroup set BPCBG_DataAttribution=null where BPCBG_DataAttribution is not null)
	i (SQLCODE'=0)&(SQLCODE'=100)  q SQLCODE
	;血液净化方式配置维护
	m ^TmpDHCBP.Config.BPModeLocationD = ^DHCBP.Config.BPModeLocationD
	m ^TmpDHCBP.Config.BPModeLocationI = ^DHCBP.Config.BPModeLocationI
	k ^DHCBP.Config.BPModeLocationD
	k ^DHCBP.Config.BPModeLocationI	
	;材料码表维护(医嘱、科室、多院区)
	m ^TmpDHCBPC("Consumable") = ^DHCBPC("Consumable")	
	m ^TmpDHCBPC("ModeConsumable") = ^DHCBPC("ModeConsumable")	
	&SQL(update sqluser.DHC_BPC_Consumable set BPCC_Arcim_Dr=null where BPCC_Arcim_Dr is not null)
	i (SQLCODE'=0)&(SQLCODE'=100)  q SQLCODE
	&SQL(update sqluser.DHC_BPC_ModeConsumable set BPCMC_Ctloc_Dr=null where BPCMC_Ctloc_Dr is not null)
	i (SQLCODE'=0)&(SQLCODE'=100)  q SQLCODE
	&SQL(update sqluser.DHC_BPC_ModeConsumable set BPCMC_DataAttribution=null where BPCMC_DataAttribution is not null)
	i (SQLCODE'=0)&(SQLCODE'=100)  q SQLCODE
	;记录项目维护
	m ^TmpDHCBPC("RecordItem") = ^DHCBPC("RecordItem")
	&SQL(update sqluser.DHC_BPC_RecordItem set BPCRI_Arcim_Dr=null where BPCRI_Arcim_Dr is not null)
	i (SQLCODE'=0)&(SQLCODE'=100)  q SQLCODE
	;血管通路配置维护	
	m ^TmpDHCBP.Config.BPVALocationD = ^DHCBP.Config.BPVALocationD 
	m ^TmpDHCBP.Config.BPVALocationI = ^DHCBP.Config.BPVALocationI
	k ^DHCBP.Config.BPVALocationD
	k ^DHCBP.Config.BPVALocationI	
	;抗凝药品和抗凝方式维护
	m ^TmpDHCBPC("AnticoagulantDrug") = ^DHCBPC("AnticoagulantDrug")
	//&SQL(update sqluser.DHC_BPC_AnticoagulantDrug set BPCAD_Location_Dr=null where BPCAD_Location_Dr is not null)
	&SQL(update sqluser.DHC_BPC_AnticoagulantDrug set BPCAD_DataAttribution=null where BPCAD_DataAttribution is not null)
	i (SQLCODE'=0)&(SQLCODE'=100)  q SQLCODE
	;抗凝方式配置维护
	m ^TmpDHCBP.Config.BPAMLocationI  = ^DHCBP.Config.BPAMLocationI
	m ^TmpDHCBP.Config.BPAMLocationD  = ^DHCBP.Config.BPAMLocationD
	k ^DHCBP.Config.BPAMLocationI
	k ^DHCBP.Config.BPAMLocationD
	;血透净化统计配置
	m ^TmpDHCBPCInquiry = ^DHCBPCInquiry
	&SQL(update sqluser.DHC_BPC_Inquiry set BPCI_Ctloc_Dr=null where BPCI_Ctloc_Dr is not null)
	i (SQLCODE'=0)&(SQLCODE'=100)  q SQLCODE
	&SQL(update sqluser.DHC_BPC_Inquiry set BPCI_DataAttribution=null where BPCI_DataAttribution is not null)
	i (SQLCODE'=0)&(SQLCODE'=100)  q SQLCODE
	;诊断与分类维护
	m ^TmpDHCCLC("DiagCat") = ^DHCCLC("DiagCat")
	&SQL(update sqluser.DHC_CLC_DiagCat set CLCDC_DataAttribution=null where CLCDC_DataAttribution is not null)
	i (SQLCODE'=0)&(SQLCODE'=100)  q SQLCODE
	;诊断与分类关联维护
	m ^TmpDHCCLC("DiagCatLink") = ^DHCCLC("DiagCatLink")
	k ^DHCCLC("DiagCatLink")	
	;净化监护设备维护
	m ^TmpDHCBPBedEquip = ^DHCBPBedEquip
	&SQL(update sqluser.DHC_BP_BedEquip set BPBE_DataAttribution=null where BPBE_DataAttribution is not null)
	i (SQLCODE'=0)&(SQLCODE'=100)  q SQLCODE	
	;设备档案管理维护
	m ^TmpDHCBPC("Equip") = ^DHCBPC("Equip")
	&SQL(update sqluser.DHC_BPC_Equip set BPCE_DataAttribution=null where BPCE_DataAttribution is not null)
	i (SQLCODE'=0)&(SQLCODE'=100)  q SQLCODE
	;多院区单项数据关联医院
	m ^TmpDHCBPC("DataAttribution") = ^DHCBPC("DataAttribution")
	k ^DHCBPC("DataAttribution")

	q "血液净化相关配置数据清除成功"
}

// s str="{""a"":""b"",""xx"":1}"

// s str="{""a"":{""a"":""yyy""}}"

// w ##class(web.DHCClinicCom).JsonToArray(str,Array)

ClassMethod JsonToArray(str, Array)
{
	k Array
	s i=1
	s c=$E(str,i)
	s len=$L(str)
	if c="{" {
		// 对象
		do{
			s i=i+1
			s c=$E(str,i) 
			if c="""" {
				s name=..Between(str,"""",.i)
				s value=$$Get(i)
			    s Array(name)=value
			    b
			}
			elseif c=":" {
				s i=i+1
			}
			/*elseif c="{" {
				s subStr=$E(str,i,len)
				d ..JsonToArray(str, .SubArray)
				b
				m Array(name)=SubArray
			}
			elseif c="[" {
				s subStr=$E(str,i,len)
				d ..JsonToArray(str, .SubArray)
				m Array(name)=SubArray
			}*/
			else {
				// b // Error
				s i=i+1
			}
		}
		while((i<len)&&(i>0))
		// s name=..Between(value, split)
	}
	elseif c="[" {
		// 数据
	}
	q 0
Get(from)
   s valueStart=$Find(str,":",i)
   s valueEnd=$Find(str,",",i)
   if valueEnd<=0 s valueEnd=$Find(str,"}",i)
   if valueEnd<=0 s valueEnd=$Find(str,"]",i)
   s valueStr=$E(str,valueStart,valueEnd-2)
   
   i valueStr["""" s valueStr=..Between(valueStr,"""",1)
   q valueStr
Esc
}

//  w ##class(web.DHCClinicCom).Between("""abc""","""")

ClassMethod Between(value, split, from)
{
	s sIndex=$Find(value,split,from)
	q:sIndex=0 ""
	s eIndex=$Find(value,split,sIndex+1)-$L(split)
	
	q:eIndex<=0 ""
	s from=eIndex
	q $E(value,sIndex,eIndex-1)
}

// w ##class(web.DHCClinicCom).ToJson(.Array)

ClassMethod ToJson(Array, stream = "")
{
	//b // ToJson
	if stream="" {
	   s stream=##class(%GlobalCharacterStream).%New()
	   d stream.Rewind()
	}
	
	if ..IsArray(.Array) {
		d ProArray
	}
	else {
		s isFirst=1
		s name=""
		
		;b //
		d stream.Write("{")
		For{
			s name=$O(Array(name))
			q:name=""
			
			if (isFirst'=1){
				d stream.Write(",")
			}
			k tmpArray
			m tmpArray=Array(name)
			if (..IsArray(.tmpArray)=1)
			{
				d stream.Write(""""_name_""":")
				d ..ToJson(.tmpArray,stream)
			}
			else
			{
				if ($d(Array(name))=10){
					// 该结点不含有值,但含有子节点
					d stream.Write(""""_name_""":")
				    d ..ToJson(.tmpArray,stream)
				}
				else {
					s value=Array(name)
				    d stream.Write(""""_name_""":"""_value_"""")
				}
			}
			s isFirst=isFirst+1
		}
		d stream.Write("}")
	}
	//d stream.OutputToDevice()
	q stream
ProArray
    d stream.Write("[")
		s id=""
		s isFirst=1
		For{
			s id=$O(Array(id))
			q:id=""
			k tmpArray
			m tmpArray=Array(id)
			
			q:$d(tmpArray)=1  
			
			if isFirst'=1 d stream.Write(",")
			d ..ToJson(.tmpArray,stream)
			s isFirst=isFirst+1
		}
		d stream.Write("]")
	q
}

ClassMethod IsArray(Array)
{
	q:$d(Array)=1 0  ; 变量
    // 第一个节点全不含值
    s sub=""
    s isArray=1
    For{
	    s sub=$O(Array(sub))
	    q:((sub="")||(isArray=0))
	    s r=$d(Array(sub))
	    if r=1 {
		    s isArray=0 
	    }
	    elseif r=10 {
		    s isArray=10  // 该结点不含有值,但含有子节点
	    }
	    elseif r=11 {
		    s a=b  // 该结点含有值且含有子节点
	    }
    }
    q isArray
}

ClassMethod SetByJson(obj, jsonStr, preName = "")
{
	s jsonObj=##class(Nur.JSON).Decode(jsonStr)
	set clsName=$p(obj,"@",2)
	s cdef = ##class(%Dictionary.ClassDefinition).%OpenId(clsName)
	Set count = cdef.Properties.Count()
	s key=""
	do{
		s key=jsonObj.Next(key)
		q:key="" 
		s value=jsonObj.GetAt(key)
		For i = 1:1:count {
		     Set propertyName=cdef.Properties.GetAt(i).Name
		     s name=preName_key
		     if (propertyName=name){
			     Set type=cdef.Properties.GetAt(i).Type
			     if (type="%Date"){
				     s value=##class(web.DHCClinicCom).ConvertToDateH(value)
			     }
			     elseif (type="%Time"){
				     s value=##class(web.DHCClinicCom).ConvertToTimeH(value)
			     }
			     elseif (type["User."){
				     if value'="" {
					     s excuteStr="(objValue)s objValue=##class("_type_").%OpenId("""_value_""")"
		                 XECUTE (excuteStr,.objValue)
					     s value=objValue
				     }
			     }
			     Set $PROPERTY(obj,propertyName)=value
			 }
		  }
		
	}
	while(key)
}

ClassMethod SetByJson21016(obj, dynamical, preName = "")
{
	set iter = dynamical.%GetIterator()
	set clsName=$p(obj,"@",2)
	Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(clsName)
	Set count = cdef.Properties.Count()
	while iter.%GetNext(.key,.value) {
		  s name=preName_key
		  For i = 1:1:count {
		     Set propertyName=cdef.Properties.GetAt(i).Name
		     if (propertyName=name){
			     Set type=cdef.Properties.GetAt(i).Type
			     if (type="%Date"){
				     s value=##class(web.DHCClinicCom).ConvertToDateH(value)
			     }
			     elseif (type="%Time"){
				     s value=##class(web.DHCClinicCom).ConvertToTimeH(value)
			     }
			     elseif (type["User."){
				     if value'="" {
					     s excuteStr="(objValue)s objValue=##class("_type_").%OpenId("""_value_""")"
		                 XECUTE (excuteStr,.objValue)
					     s value=objValue
				     }
			     }
			     Set $PROPERTY(arrange,propertyName)=value
			 }
		  }
	}
	q obj
}

ClassMethod ToJSONArray(obj, Array, preName = "")
{
	set clsName=$p(obj,"@",2)
	Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(clsName)
	Set count = cdef.Properties.Count()
	For i = 1:1:count {
		Set propertyName=cdef.Properties.GetAt(i).Name
		Set value=$PROPERTY(obj,propertyName)
		s name=$p(propertyName,preName,2)
		Set type=cdef.Properties.GetAt(i).Type
		if (type="%Date"){
			s value=##class(web.DHCClinicCom).ConvertToDate(value)
			s Array(name)=value
		}
		elseif (type="%Time"){
			s value=##class(web.DHCClinicCom).ConvertToTime(value)
			s Array(name)=value
		}
		elseif (type["User."){
			s Array(name)=value
			// 设置Code和描述
			if value'="" {
				s excuteStr="(objValue)s objValue=##class("_type_").%OpenId("""_value_""")"
				XECUTE (excuteStr,.objValue)
				s value=objValue
				s Array(name_"Code")=..GetValueByPropertyName(objValue,"Code")
				s Array(name_"Desc")=..GetValueByPropertyName(objValue,"Desc")
			}
		}
	}
}

ClassMethod GetValueByPropertyName(obj, subName)
{
   set clsName=$p(obj,"@",2)
   Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(clsName)
   Set count = cdef.Properties.Count()
   s value=""
   // 获取以subName结束的值
   For j=1:1:count {
	   Set propertyName=cdef.Properties.GetAt(i).Name
	   if ((propertyName_";")[(subName_";"))
	   {
		   Set value=$PROPERTY(obj,propertyName)
		   s j=count+1
	   }
   }
   q value
}

ClassMethod ToJsonObj(jsonStr)
{
	q ##class(Nur.JSON).Decode(jsonStr)
}

// 日间手术清数据方法

ClassMethod ClearDaySurgeryData(type)
{
	i type="Set" d
	.;配置
	.k ^CF.AN.MessageTemplateD	;手机短信科室模板
	.k ^CF.AN.MessageTemplateI
	i type="Work" d
	.;业务
	.k ^CIS.AN.DaySurgeryDeclineD	;退出日间记录
	.k ^CIS.AN.DaySurgeryDeclineI
	.k ^CIS.AN.PhoneMessageD ;手机短信发送记录
	.k ^CIS.AN.PhoneMessageI
	q "ok"
}

}
