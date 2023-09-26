/// 工作台&portal接口方法
Class web.INMWorkbenchComm Extends %RegisteredObject
{

/// Creator:
/// Createdate:
/// Description:JSON封装方法
/// Input:
/// Output:
/// Other:
ClassMethod ReturnJson(resultCode, msg, total, data) As %String
{
	q "{""status"":"_resultCode_",""errMSG"":"""_msg_",""total"":"_total_",""data"":"_data_"}"
}

/// Creator:
/// Createdate:
/// Description:获人员信息
/// Input:CTLocID,空则获取全部
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMWorkbenchComm","FindPersonList",337)
Query FindPersonList(wardId As %String = "") As %Query(ROWSPEC = "name:%String,userCode:%String,sex:%String,birthday:%String,title:%String,education:%String,level:%String,admissionTime:%String")
{
}

ClassMethod FindPersonListExecute(ByRef qHandle As %Binary, wardId As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1,ret=""
	if wardId'="" {
		s wardId=$O(^CF.DHCINM.DB.MgWardI("CTLoc",$tr(wardId," ",""),""))
		if wardId="" {
			Set qHandle=$lb(0,repid,0)
			Quit $$$OK
		}
	}
#;	if wardId=""{
#;		Set qHandle=$lb(0,repid,0)
#;		Quit $$$OK
#;	}
	s perDep="" f  s perDep=$O(^CF.DHCINM.HR.PersonsI("DepID",perDep)) q:perDep=""  d
	.q:((wardId'="")&&($tr(perDep," ","")'=wardId))
	.s rowId="" f  s rowId=$O(^CF.DHCINM.HR.PersonsI("DepID",perDep,rowId)) q:rowId=""  d
	..s obj=##class(CF.DHCINM.HR.Persons).%OpenId(rowId)
	..q:(obj.PerTypeDR'="N")
	..q:##class(web.INMHRComm).IsFormalWorkNur(rowId,+$h,"")'=1
	..s name=obj.PerName
	..s userCode=obj.HISNO
	..s sex=""
	..i obj.PerSexDR'="" s sex=##class(web.INMPersonComm).GetCommCode(obj.PerSexDR)
	..s birthday=obj.PerBirthday
	..s:birthday'="" birthday=$zd(birthday,3)
	..s HireDuty=##class(web.INMHRComm).GetNurseHireDuty(rowId,+$h) //职称
	..s title=$p(HireDuty,"^",2)
	..s Acade=##class(web.INMHRComm).GetNurseEdu(rowId,+$h) //当前学历
	..s education=$p(Acade,"^",2)
	..s PerLevel=##class(web.INMHRComm).GetNurseLevel(rowId,+$h) //层级 
	..s level=$p(PerLevel,"^",2)
	..s admissionTime=obj.PerDepDate
	..s:admissionTime'="" admissionTime=$zd(admissionTime,3)
	..d OutPutRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRowData
	set Data=$lb(name,userCode,sex,birthday,title,education,level,admissionTime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPersonListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPersonListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonListExecute ]
{
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

/// Creator:
/// Createdate:
/// Description:获年资统计
/// Input:CTLocID,空则获取全部
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMWorkbenchComm","GetNurseYearList",337)
Query GetNurseYearList(wardId As %String = "") As %Query(ROWSPEC = "year:%String,type:%String,number:%String")
{
}

ClassMethod GetNurseYearListExecute(ByRef qHandle As %Binary, wardId As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1,ret=""
	if wardId'="" {
		s wardId=$O(^CF.DHCINM.DB.MgWardI("CTLoc",$tr(wardId," ",""),""))
		if wardId="" {
			Set qHandle=$lb(0,repid,0)
			Quit $$$OK
		}
	}
#;	if wardId=""{
#;		Set qHandle=$lb(0,repid,0)
#;		Quit $$$OK
#;	}
	s tmp=""
	s yearDual=$LB("0「1「<1年资","1「2「1<=y<2年资","2「5「2<=y<5年资","5「10「5<=y<10年资","10「20「10<=y<20年资","20「「>=20年资")
	s perDep="" f  s perDep=$O(^CF.DHCINM.HR.PersonsI("DepID",perDep)) q:perDep=""  d
	.q:((wardId'="")&&($tr(perDep," ","")'=wardId))
	.s rowId="" f  s rowId=$O(^CF.DHCINM.HR.PersonsI("DepID",perDep,rowId)) q:rowId=""  d
	..s obj=##class(CF.DHCINM.HR.Persons).%OpenId(rowId)
	..q:(obj.PerTypeDR'="N")
	..q:##class(web.INMHRComm).IsFormalWorkNur(rowId,+$h,"")'=1
	..s WorkDate=obj.PerWorkDate
	..s:WorkDate="" WorkDate=obj.PerComeDate
	..q:WorkDate=""
	..s workYear=##class(web.INMVueComm).CalAge($zd(WorkDate,3),$zd(+$H,3))
	..s PerWorkYear=$p(workYear,"Y",1)
	..s tmp(PerWorkYear)=$G(tmp(PerWorkYear))+1
	f i=1:1:$LL(yearDual) d
	.s key=$LG(yearDual,i)
	.q:key=""
	.s start=$P(key,"「",1),end=$P(key,"「",2),year=$P(key,"「",3),type=start_"「"_end
	.s number=0
	.s perYear=start-1 f  s perYear=$O(tmp(perYear)) q:((perYear="")||((end'="")&&(perYear>=end)))  d
	..s number=number+$g(tmp(perYear))
	.d OutPutRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRowData
	set Data=$lb(year,type,number)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GetNurseYearListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNurseYearListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetNurseYearListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNurseYearListExecute ]
{
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

/// Creator:
/// Createdate:
/// Description:获年资统计明细
/// Input:CTLocID,空则获取全部,type
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMWorkbenchComm","FindNurseYearDetailList",337,"20「")
Query FindNurseYearDetailList(wardId As %String = "", type As %String = "") As %Query(ROWSPEC = "userCode:%String,nurse:%String,year:%String,ward:%String")
{
}

ClassMethod FindNurseYearDetailListExecute(ByRef qHandle As %Binary, wardId As %String = "", type As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1,ret=""
	if wardId'="" {
		s wardId=$O(^CF.DHCINM.DB.MgWardI("CTLoc",$tr(wardId," ",""),""))
		if wardId="" {
			Set qHandle=$lb(0,repid,0)
			Quit $$$OK
		}
	}
	if type=""{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s start=$P(type,"「",1)
	s end=$P(type,"「",2)
#;	if wardId=""{
#;		Set qHandle=$lb(0,repid,0)
#;		Quit $$$OK
#;	}
	s perDep="" f  s perDep=$O(^CF.DHCINM.HR.PersonsI("DepID",perDep)) q:perDep=""  d
	.q:((wardId'="")&&($tr(perDep," ","")'=wardId))
	.s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId($tr(perDep," ",""))
	.q:'$IsObject(wardObj)
	.s ward=wardObj.WardDesc
	.s rowId="" f  s rowId=$O(^CF.DHCINM.HR.PersonsI("DepID",perDep,rowId)) q:rowId=""  d
	..s obj=##class(CF.DHCINM.HR.Persons).%OpenId(rowId)
	..q:(obj.PerTypeDR'="N")
	..q:##class(web.INMHRComm).IsFormalWorkNur(rowId,+$h,"")'=1
	..s WorkDate=obj.PerWorkDate
	..s:WorkDate="" WorkDate=obj.PerComeDate
	..q:WorkDate=""
	..s nurse=obj.PerName
	..s userCode=obj.HISNO
	..s workYear=##class(web.INMVueComm).CalAge($zd(WorkDate,3),$zd(+$H,3))
	..s year=$p(workYear,"Y",1)
	..q:((start'="")&&(year<start))
	..q:((end'="")&&(year>=end))
	..d OutPutRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRowData
	set Data=$lb(userCode,nurse,year,ward)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurseYearDetailListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurseYearDetailListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindNurseYearDetailListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurseYearDetailListExecute ]
{
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

/// Creator:
/// Createdate:
/// Description:获职称统计
/// Input:CTLocID,空则获取全部
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMWorkbenchComm","FindHireDutyList",337)
Query FindHireDutyList(wardId As %String = "") As %Query(ROWSPEC = "title:%String,type:%String,number:%String")
{
}

ClassMethod FindHireDutyListExecute(ByRef qHandle As %Binary, wardId As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1,ret=""
	if wardId'="" {
		s wardId=$O(^CF.DHCINM.DB.MgWardI("CTLoc",$tr(wardId," ",""),""))
		if wardId="" {
			Set qHandle=$lb(0,repid,0)
			Quit $$$OK
		}
	}
#;	if wardId=""{
#;		Set qHandle=$lb(0,repid,0)
#;		Quit $$$OK
#;	}
	s tmp="",nowDate=+$H
	s perDep="" f  s perDep=$O(^CF.DHCINM.HR.PersonsI("DepID",perDep)) q:perDep=""  d
	.q:((wardId'="")&&($tr(perDep," ","")'=wardId))
	.s rowId="" f  s rowId=$O(^CF.DHCINM.HR.PersonsI("DepID",perDep,rowId)) q:rowId=""  d
	..s obj=##class(CF.DHCINM.HR.Persons).%OpenId(rowId)
	..q:(obj.PerTypeDR'="N")
	..q:##class(web.INMHRComm).IsFormalWorkNur(rowId,+$h,"")'=1
	..s hiredate=$O(^CF.DHCINM.HR.HireDutyI("HireA",rowId," A",nowDate+1),-1)
	..q:hiredate=""
	..s id=$O(^CF.DHCINM.HR.HireDutyI("HireA",rowId," A",hiredate,""))
	..q:id=""
	..s enddate=$lg(^CF.DHCINM.HR.HireDutyD(id),5)
	..q:(enddate'="")&&(enddate<nowDate)
	..s hireduty=$lg(^CF.DHCINM.HR.HireDutyD(id),3)
	..q:hireduty=""
	..s tmp(hireduty)=$g(tmp(hireduty))+1
	s codeId=$O(^CT.DHCINM.DB.MgSetCodeI("Code"," 聘任职称",""))
	if codeId=""{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s codeSubId="" f  s codeSubId=$O(^CT.DHCINM.DB.MgSetCodeSubD(codeId,codeSubId)) q:codeSubId=""  d
	.s type=codeId_"||"_codeSubId
	.s codeObj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(type)
	.q:'$IsObject(codeObj)
	.s title=codeObj.SubDesc
	.s number=$g(tmp(type))
	.s:number="" number=0
	.d OutPutRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRowData
	set Data=$lb(title,type,number)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindHireDutyListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindHireDutyListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindHireDutyListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindHireDutyListExecute ]
{
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

/// Creator:
/// Createdate:
/// Description:获职称统计明细
/// Input:CTLocID,空则获取全部,type
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMWorkbenchComm","FindHireDutyDetailList",337,"12||6")
Query FindHireDutyDetailList(wardId As %String = "", type As %String = "") As %Query(ROWSPEC = "userCode:%String,nurse:%String,title:%String,employStartTime:%String,employEndTime:%String,ward:%String")
{
}

ClassMethod FindHireDutyDetailListExecute(ByRef qHandle As %Binary, wardId As %String = "", type As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1,ret=""
	if wardId'="" {
		s wardId=$O(^CF.DHCINM.DB.MgWardI("CTLoc",$tr(wardId," ",""),""))
		if wardId="" {
			Set qHandle=$lb(0,repid,0)
			Quit $$$OK
		}
	}
	if type=""{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
#;	if wardId=""{
#;		Set qHandle=$lb(0,repid,0)
#;		Quit $$$OK
#;	}
	s nowDate=+$H
	s perDep="" f  s perDep=$O(^CF.DHCINM.HR.PersonsI("DepID",perDep)) q:perDep=""  d
	.q:((wardId'="")&&($tr(perDep," ","")'=wardId))
	.s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId($tr(perDep," ",""))
	.q:'$IsObject(wardObj)
	.s ward=wardObj.WardDesc
	.s rowId="" f  s rowId=$O(^CF.DHCINM.HR.PersonsI("DepID",perDep,rowId)) q:rowId=""  d
	..s obj=##class(CF.DHCINM.HR.Persons).%OpenId(rowId)
	..q:(obj.PerTypeDR'="N")
	..q:##class(web.INMHRComm).IsFormalWorkNur(rowId,+$h,"")'=1
	..s hiredate=$O(^CF.DHCINM.HR.HireDutyI("HireA",rowId," A",nowDate+1),-1)
	..q:hiredate=""
	..s id=$O(^CF.DHCINM.HR.HireDutyI("HireA",rowId," A",hiredate,""))
	..q:id=""
	..s enddate=$lg(^CF.DHCINM.HR.HireDutyD(id),5)
	..q:(enddate'="")&&(enddate<nowDate)
	..s hireduty=$lg(^CF.DHCINM.HR.HireDutyD(id),3)
	..q:hireduty=""
	..q:hireduty'=type
	..s userCode=obj.HISNO
	..s nurse=obj.PerName
	..s title=##class(web.INMPersonComm).GetCommCode(hireduty)
	..s employStartTime=$zd(hiredate,3)
	..s employEndTime=""
	..s:enddate'="" employEndTime=$zd(enddate,3)
	..
	..d OutPutRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRowData
	set Data=$lb(userCode,nurse,title,employStartTime,employEndTime,ward)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindHireDutyDetailListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindHireDutyDetailListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindHireDutyDetailListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindHireDutyDetailListExecute ]
{
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

/// Creator:
/// Createdate:
/// Description:获学历统计
/// Input:CTLocID,空则获取全部
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMWorkbenchComm","FindNurseEduList",337)
Query FindNurseEduList(wardId As %String = "") As %Query(ROWSPEC = "education:%String,type:%String,number:%String")
{
}

ClassMethod FindNurseEduListExecute(ByRef qHandle As %Binary, wardId As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1,ret=""
	if wardId'="" {
		s wardId=$O(^CF.DHCINM.DB.MgWardI("CTLoc",$tr(wardId," ",""),""))
		if wardId="" {
			Set qHandle=$lb(0,repid,0)
			Quit $$$OK
		}
	}
#;	if wardId=""{
#;		Set qHandle=$lb(0,repid,0)
#;		Quit $$$OK
#;	}
	s tmp="",nowDate=+$H
	s perDep="" f  s perDep=$O(^CF.DHCINM.HR.PersonsI("DepID",perDep)) q:perDep=""  d
	.q:((wardId'="")&&($tr(perDep," ","")'=wardId))
	.s rowId="" f  s rowId=$O(^CF.DHCINM.HR.PersonsI("DepID",perDep,rowId)) q:rowId=""  d
	..s obj=##class(CF.DHCINM.HR.Persons).%OpenId(rowId)
	..q:(obj.PerTypeDR'="N")
	..q:##class(web.INMHRComm).IsFormalWorkNur(rowId,+$h,"")'=1
	..s EduDate=$O(^CF.DHCINM.HR.EducateI("flagA",rowId," A",nowDate+1),-1)
	..q:EduDate=""
	..s EduRowID=$O(^CF.DHCINM.HR.EducateI("flagA",rowId," A",EduDate,""))
	..q:EduRowID=""
	..s enddate=$lg(^CF.DHCINM.HR.EducateD(EduRowID),4)
	..s academic=$lg(^CF.DHCINM.HR.EducateD(EduRowID),6)
	..s tmp(academic)=$g(tmp(academic))+1
	s codeId=$O(^CT.DHCINM.DB.MgSetCodeI("Code"," 学历",""))
	if codeId=""{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s codeSubId="" f  s codeSubId=$O(^CT.DHCINM.DB.MgSetCodeSubD(codeId,codeSubId)) q:codeSubId=""  d
	.s type=codeId_"||"_codeSubId
	.s codeObj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(type)
	.q:'$IsObject(codeObj)
	.s education=codeObj.SubDesc
	.s number=$g(tmp(type))
	.s:number="" number=0
	.d OutPutRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRowData
	set Data=$lb(education,type,number)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurseEduListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurseEduListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindNurseEduListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurseEduListExecute ]
{
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

/// Creator:
/// Createdate:
/// Description:获学历统计明细
/// Input:CTLocID,空则获取全部,type
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMWorkbenchComm","FindNurseEduDetailList",337,"3||4")
Query FindNurseEduDetailList(wardId As %String = "", type As %String = "") As %Query(ROWSPEC = "userCode:%String,nurse:%String,school:%String,education:%String,degree:%String,degreeTime:%String,ward:%String")
{
}

ClassMethod FindNurseEduDetailListExecute(ByRef qHandle As %Binary, wardId As %String = "", type As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1,ret=""
	if wardId'="" {
		s wardId=$O(^CF.DHCINM.DB.MgWardI("CTLoc",$tr(wardId," ",""),""))
		if wardId="" {
			Set qHandle=$lb(0,repid,0)
			Quit $$$OK
		}
	}
	if type=""{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
#;	if wardId=""{
#;		Set qHandle=$lb(0,repid,0)
#;		Quit $$$OK
#;	}
	s nowDate=+$H
	s perDep="" f  s perDep=$O(^CF.DHCINM.HR.PersonsI("DepID",perDep)) q:perDep=""  d
	.q:((wardId'="")&&($tr(perDep," ","")'=wardId))
	.s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId($tr(perDep," ",""))
	.q:'$IsObject(wardObj)
	.s ward=wardObj.WardDesc
	.s rowId="" f  s rowId=$O(^CF.DHCINM.HR.PersonsI("DepID",perDep,rowId)) q:rowId=""  d
	..s obj=##class(CF.DHCINM.HR.Persons).%OpenId(rowId)
	..q:(obj.PerTypeDR'="N")
	..q:##class(web.INMHRComm).IsFormalWorkNur(rowId,+$h,"")'=1
	..s EduDate=$O(^CF.DHCINM.HR.EducateI("flagA",rowId," A",nowDate+1),-1)
	..q:EduDate=""
	..s EduRowID=$O(^CF.DHCINM.HR.EducateI("flagA",rowId," A",EduDate,""))
	..q:EduRowID=""
	..s enddate=$lg(^CF.DHCINM.HR.EducateD(EduRowID),4)
	..s academic=$lg(^CF.DHCINM.HR.EducateD(EduRowID),6)
	..q:academic'=type
	..s userCode=obj.HISNO
	..s nurse=obj.PerName
	..s education=##class(web.INMPersonComm).GetCommCode(academic)
	..s degreeTime=""
	..s EduDegreeDate=$lg(^CF.DHCINM.HR.EducateD(EduRowID),11)
	..s:EduDegreeDate'="" degreeTime=$zd(EduDegreeDate,3)
	..s eduDegree=$lg(^CF.DHCINM.HR.EducateD(EduRowID),7)
	..s degree=##class(web.INMPersonComm).GetCommCode(eduDegree)
	..s eduSchool=$lg(^CF.DHCINM.HR.EducateD(EduRowID),5)
	..s school=##class(web.INMPersonComm).GetCommCode(eduSchool)
	..d OutPutRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRowData
	set Data=$lb(userCode,nurse,school,education,degree,degreeTime,ward)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurseEduDetailListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurseEduDetailListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindNurseEduDetailListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurseEduDetailListExecute ]
{
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

/// Creator:
/// Createdate:
/// Description:获层级统计
/// Input:CTLocID,空则获取全部
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMWorkbenchComm","FindNurseLevelList",337)
Query FindNurseLevelList(wardId As %String = "") As %Query(ROWSPEC = "level:%String,type:%String,number:%String")
{
}

ClassMethod FindNurseLevelListExecute(ByRef qHandle As %Binary, wardId As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1,ret=""
	if wardId'="" {
		s wardId=$O(^CF.DHCINM.DB.MgWardI("CTLoc",$tr(wardId," ",""),""))
		if wardId="" {
			Set qHandle=$lb(0,repid,0)
			Quit $$$OK
		}
	}
#;	if wardId=""{
#;		Set qHandle=$lb(0,repid,0)
#;		Quit $$$OK
#;	}
	s tmp="",nowDate=+$H
	s perDep="" f  s perDep=$O(^CF.DHCINM.HR.PersonsI("DepID",perDep)) q:perDep=""  d
	.q:((wardId'="")&&($tr(perDep," ","")'=wardId))
	.s rowId="" f  s rowId=$O(^CF.DHCINM.HR.PersonsI("DepID",perDep,rowId)) q:rowId=""  d
	..s obj=##class(CF.DHCINM.HR.Persons).%OpenId(rowId)
	..q:(obj.PerTypeDR'="N")
	..q:##class(web.INMHRComm).IsFormalWorkNur(rowId,+$h,"")'=1
	..s level="",LevelId=""
	..s LevelDate=nowDate+1 f  s LevelDate=$O(^CF.DHCINM.HR.MgLevelI("levelA",rowId," A",LevelDate),-1) q:((LevelDate="")||(level'=""))  d
	...s LevelId=""  f  s LevelId=$o(^CF.DHCINM.HR.MgLevelI("levelA",rowId," A",LevelDate,LevelId)) q:((LevelId="")||(level'=""))  d
	....s level=$lg(^CF.DHCINM.HR.MgLevelD(LevelId),3)
	..q:level=""
	..s tmp(level)=$g(tmp(level))+1
	s codeId=$O(^CT.DHCINM.DB.MgSetCodeI("Code"," 护士层级",""))
	if codeId=""{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s codeSubId="" f  s codeSubId=$O(^CT.DHCINM.DB.MgSetCodeSubD(codeId,codeSubId)) q:codeSubId=""  d
	.s type=codeId_"||"_codeSubId
	.s codeObj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(type)
	.q:'$IsObject(codeObj)
	.s level=codeObj.SubDesc
	.s number=$g(tmp(type))
	.s:number="" number=0
	.d OutPutRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRowData
	set Data=$lb(level,type,number)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurseLevelListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurseLevelListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindNurseLevelListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurseLevelListExecute ]
{
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

/// Creator:
/// Createdate:
/// Description:获层级统计明细
/// Input:CTLocID,空则获取全部,type
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMWorkbenchComm","FindNurseLevelDetailList",337,"19||5")
Query FindNurseLevelDetailList(wardId As %String = "", type As %String = "") As %Query(ROWSPEC = "userCode:%String,nurse:%String,level:%String,promotionDate:%String,ward:%String")
{
}

ClassMethod FindNurseLevelDetailListExecute(ByRef qHandle As %Binary, wardId As %String = "", type As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1,ret=""
	if wardId'="" {
		s wardId=$O(^CF.DHCINM.DB.MgWardI("CTLoc",$tr(wardId," ",""),""))
		if wardId="" {
			Set qHandle=$lb(0,repid,0)
			Quit $$$OK
		}
	}
	if type=""{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
#;	if wardId=""{
#;		Set qHandle=$lb(0,repid,0)
#;		Quit $$$OK
#;	}
	s nowDate=+$H
	s perDep="" f  s perDep=$O(^CF.DHCINM.HR.PersonsI("DepID",perDep)) q:perDep=""  d
	.q:((wardId'="")&&($tr(perDep," ","")'=wardId))
	.s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId($tr(perDep," ",""))
	.q:'$IsObject(wardObj)
	.s ward=wardObj.WardDesc
	.s rowId="" f  s rowId=$O(^CF.DHCINM.HR.PersonsI("DepID",perDep,rowId)) q:rowId=""  d
	..s obj=##class(CF.DHCINM.HR.Persons).%OpenId(rowId)
	..q:(obj.PerTypeDR'="N")
	..q:##class(web.INMHRComm).IsFormalWorkNur(rowId,+$h,"")'=1
	..s level="",LevelId="",promotionDate=""
	..s LevelDate=nowDate+1 f  s LevelDate=$O(^CF.DHCINM.HR.MgLevelI("levelA",rowId," A",LevelDate),-1) q:((LevelDate="")||(level'=""))  d
	...s promotionDate=LevelDate
	...s LevelId=""  f  s LevelId=$o(^CF.DHCINM.HR.MgLevelI("levelA",rowId," A",LevelDate,LevelId)) q:((LevelId="")||(level'=""))  d
	....s level=$lg(^CF.DHCINM.HR.MgLevelD(LevelId),3)
	..q:level=""
	..q:level'=type
	..s userCode=obj.HISNO
	..s nurse=obj.PerName
	..s level=##class(web.INMPersonComm).GetCommCode(level)
	..s:promotionDate'="" promotionDate=$zd(promotionDate,3)
	..d OutPutRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRowData
	set Data=$lb(userCode,nurse,level,promotionDate,ward)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurseLevelDetailListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurseLevelDetailListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindNurseLevelDetailListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurseLevelDetailListExecute ]
{
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

/// Description：查询排班次数
/// Date:
/// Creator:
/// Table:
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMWorkbenchComm","FindArgCountList",337)
Query FindArgCountList(wardId As %String = "") As %Query(ROWSPEC = "typeName:%String,number:%String")
{
}

ClassMethod FindArgCountListExecute(ByRef qHandle As %Binary, wardId As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if wardId'="" {
		s wardId=$O(^CF.DHCINM.DB.MgWardI("CTLoc",$tr(wardId," ",""),""))
		if wardId="" {
			Set qHandle=$lb(0,repid,0)
			Quit $$$OK
		}
	}
	s tmp=""
	s tWardId="" f  s tWardId=$O(^CF.DHCINM.DB.MgWardD(tWardId)) q:tWardId=""  d
	.q:((wardId'="")&&(tWardId'=wardId))
	.s ArgDate=+$H
	.s argSubId="" f  s argSubId=$O(^DHCINM.Arg.MgArrangeSubI("WardDate",tWardId,ArgDate,argSubId)) q:argSubId=""  d
	..s obj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(argSubId)
	..q:'$IsObject(obj)
	..q:'$IsObject(obj.ArrangeDR)
	..q:((obj.ArrangeDR.ArgStatus'="R")&&(obj.ArrangeDR.ArgStatus'="A"))
	..q:'$IsObject(obj.ArgPostDR)
	..q:'$IsObject(obj.ArgPostDR.PostDR)
	..s postId=obj.ArgPostDR.PostDR.%Id()
	..s tmp(postId)=$g(tmp(obj.ArgPostDR.PostDR.%Id()))+1
	s postId="" f  s postId=$O(tmp(postId)) q:postId=""  d
	.s postObj=##class(CF.DHCINM.DB.MgArgPost).%OpenId(postId)
	.q:'$IsObject(postObj)
	.s typeName=postObj.PostDesc
	.s number=$g(tmp(postId))
	.d OutCountList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCountList
	set Data=$lb(typeName,number)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindArgCountListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArgCountListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindArgCountListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArgCountListExecute ]
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

ClassMethod GetResigeterNurseNum(date, tmpNurse) As %String
{
	q:date="" ""
	f i=1:1:$L(date,",")  d
	.s realDate=$P(date,",",i)
	.q:realDate=""
	.s dataKey="" f  s dataKey=$O(^DHCNS.Config.NsAutoMgDataI("key",realDate,dataKey)) q:dataKey=""  d
	..s id="" f  s id=$O(^DHCNS.Config.NsAutoMgDataI("key",realDate,dataKey,id)) q:id=""  d
	...s obj=##class(DHCNS.Config.NsAutoMgData).%OpenId(id)
	...q:'$IsObject(obj)
	...s IsRegister=obj.IsRegister
	...s:IsRegister="" IsRegister="Y"
	...q:IsRegister'="Y"
	...s ctLocId=obj.CTLocDR
	...q:ctLocId=""
	...s tmpNurse(realDate,ctLocId)=$g(tmpNurse(realDate,ctLocId))+1
	q 1
}

ClassMethod GetRealBedNum(date, tmpRealBed) As %String
{
	q:date="" ""
	s tEleId=""
	s eleId="" f  s eleId=$O(^CT.DHCNS.Config.NsElementI("AutoType"," Z",eleId)) q:(eleId="")||(tEleId'="")  d
	.s eleObj=##class(CT.DHCNS.Config.NsElement).%OpenId(eleId)
	.s className=eleObj.ClassName
	.s methodName=eleObj.MethodName
	.s param=eleObj.MethodParam
	.i (className="web.NurSensDHCCHISComm")&&(methodName="GetWardBedData")  d
	..s tEleId=eleId
	
	f i=1:1:$L(date,",")  d
	.s realDate=$P(date,",",i)
	.s wardId="" f  s wardId=$O(^DHCNS.Config.NsAutoDataI("Index",eleId,wardId)) q:wardId=""  d
	..s autoId="" f  s autoId=$O(^DHCNS.Config.NsAutoDataI("Index",eleId,wardId,realDate,autoId)) q:autoId=""  d
	...s obj=##class(DHCNS.Config.NsAutoData).%OpenId(autoId)
	...q:'$IsObject(obj)
	...s tmpRealBed(realDate,wardId)=$g(tmpRealBed(realDate,wardId))+obj.Value
	q 1
}

/// Creator:
/// Createdate:
/// Description:获床护比
/// Input:date--yyyy-MM-dd
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMWorkbenchComm","FindBedNurList",$zd(+$H-4,3))
Query FindBedNurList(date As %String = "") As %Query(ROWSPEC = "ward:%String,bedNum:%String,nurseNum:%String,BedNurseRatio:%String,BedNurseRatioY:%String,BedNurseRatioM:%String,yearToYearValueIn:%String,monthToMonthValueIn:%String")
{
}

ClassMethod FindBedNurListExecute(ByRef qHandle As %Binary, date As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1,ret=""
	s ward="",bedNum="",nurseNum="",BedNurseRatio="",BedNurseRatioY="",BedNurseRatioM="",yearToYearValueIn=0,monthToMonthValueIn=0
	i date["-" s date=$zdh(date,3)
	e  s date=""
	if date="" {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s dateM=date-1
	s dateY=date-7
	k tmpNurse,tmpRealBed
	s tmpNurse="",tmpRealBed=""
	s dateRange=date_","_dateM_","_dateY
	d ..GetResigeterNurseNum(dateRange,.tmpNurse) ;ctlocid
	d ..GetRealBedNum(dateRange,.tmpRealBed) ;--wardid
	s wardId="" f  s wardId=$O(^CF.DHCINM.DB.MgWardD(wardId)) q:wardId=""  d
	.s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(wardId)
	.q:'$IsObject(wardObj)
	.s ctlocId=""
	.s:$IsObject(wardObj.CTLocDR) ctlocId=wardObj.CTLocDR.%Id()
	.s ward=wardObj.WardDesc

	.;上周同天--同比
	.s tDate=dateY
	.s bedNum=$g(tmpRealBed(tDate,wardId))
	.s nurseNum=""
	.s:ctlocId'="" nurseNum=$g(tmpNurse(tDate,ctlocId))
	.s XY=""
	.s:((+bedNum'=0)&&(+nurseNum'=0)) XY=nurseNum/bedNum
	.;前一天--环比
	.s tDate=dateM
	.s bedNum=$g(tmpRealBed(tDate,wardId))
	.s nurseNum=""
	.s:ctlocId'="" nurseNum=$g(tmpNurse(tDate,ctlocId))
	.s XM=""
	.s:((+bedNum'=0)&&(+nurseNum'=0)) XM=nurseNum/bedNum
	.;当天
	.s tDate=date
	.s bedNum=$g(tmpRealBed(tDate,wardId))
	.s nurseNum=""
	.s:ctlocId'="" nurseNum=$g(tmpNurse(tDate,ctlocId))
	.s X=""
	.s:((+bedNum'=0)&&(+nurseNum'=0)) X=nurseNum/bedNum
	.;1:X1/1:X2
	.s BedNurseRatioY="",BedNurseRatioM="",yearToYearValueIn=0,monthToMonthValueIn=0
	.i ((+X'=0)&&(+XY'=0))  d
	..;s BedNurseRatioY=$fn(((XY-X)/(X*XY*XY)),"",2)*100_"%"  --率的计算
	..s BedNurseRatioY=$fn((XY/X),"",2)*100_"%"
	..i X'=XY d
	...i (X<XY)  s yearToYearValueIn=1
	...e  s yearToYearValueIn=-1
	.;环比
	.i ((+X'=0)&&(+XM'=0))  d ;
	..;s BedNurseRatioM=$fn(((XM-X)/(X*XM*XM)),"",2)*100_"%"  --率的计算
	..s BedNurseRatioM=$fn((XM/X),"",2)*100_"%"
	..i X'=XM d
	...i (X<XM)  s monthToMonthValueIn=1
	...e  s monthToMonthValueIn=-1
	.s BedNurseRatio=""
	.s:X'="" BedNurseRatio="1:"_$fn(X,"",2)
	.d OutPutRowData
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRowData
	set Data=$lb(ward,bedNum,nurseNum,BedNurseRatio,BedNurseRatioY,BedNurseRatioM,yearToYearValueIn,monthToMonthValueIn)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindBedNurListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBedNurListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindBedNurListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBedNurListExecute ]
{
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

ClassMethod GetNurseWorkNum(date, tmpWorkNum, IsDuty) As %String
{
	q:date="" ""
	f i=1:1:$L(date,",")  d
	.s realDate=$P(date,",",i)
	.q:realDate=""
	.s dataKey="" f  s dataKey=$O(^DHCNS.Config.NsAutoMgDataI("key",realDate,dataKey)) q:dataKey=""  d
	..s id="" f  s id=$O(^DHCNS.Config.NsAutoMgDataI("key",realDate,dataKey,id)) q:id=""  d
	...s obj=##class(DHCNS.Config.NsAutoMgData).%OpenId(id)
	...q:'$IsObject(obj)
	...s ctLocId=obj.CTLocDR
	...q:ctLocId=""
	...s DayCountDuty=obj.DayCount
	...s NightCountDuty=obj.NightCount
	...s countDuty=obj.AllDayCount
	...i IsDuty=1 d
	....s DayCountDuty=obj.DayCountDuty
	....s NightCountDuty=obj.NightCountDuty
	....s countDuty=obj.AllDayCountDuty
	...s tmpWorkNum(ctLocId,"N",realDate)=$g(tmpWorkNum(ctLocId,"N",realDate))+NightCountDuty
	...s tmpWorkNum(ctLocId,"D",realDate)=$g(tmpWorkNum(ctLocId,"D",realDate))+DayCountDuty
	...s tmpWorkNum(ctLocId,"0",realDate)=$g(tmpWorkNum(ctLocId,"0",realDate))+countDuty
	q 1
}

ClassMethod GetPatNum(date, tmpPatNum) As %String
{
	q:date="" ""
	s indexLB=$LB("0","D","N")
	s indexLBTwo=$LB("","N","T")
	f z=1:1:$L(date,",")  d
	.s realDate=$P(date,",",z)
	.q:realDate=""
	.f i=1:1:$LL(indexLB) d
	..s realIndex=$LG(indexLB,i)
	..q:realIndex=""
	..f j=1:1:$LL(indexLBTwo)  d
	...s selectIndex=realIndex_$LG(indexLBTwo,j)
	...s wardId="" f  s wardId=$O(^DHCNS.Config.NsAutoPatI("Index"," "_selectIndex,wardId)) q:wardId=""  d
	....s id="" f  s id=$O(^DHCNS.Config.NsAutoPatI("Index"," "_selectIndex,wardId,realDate,id)) q:id=""  d
	.....s obj=##class(DHCNS.Config.NsAutoPat).%OpenId(id)
	.....q:'$IsObject(obj)
	.....s tmpPatNum(wardId,realIndex,realDate)=$g(tmpPatNum(wardId,realIndex,realDate))+obj.Value
	q 1
}

/// Creator:
/// Createdate:
/// Description:获护患比
/// Input:date--yyyy-MM-dd
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMWorkbenchComm","FindNurPathList",$zd(+$H-4,3))
Query FindNurPathList(date As %String = "") As %Query(ROWSPEC = "ward:%String,patientNum:%String,nurseNum:%String,patientNurseRatio:%String,patientNurseRatioDay:%String,patientNurseRatioNight:%String")
{
}

ClassMethod FindNurPathListExecute(ByRef qHandle As %Binary, date As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1,ret=""
	
	i date["-" s date=$zdh(date,3)
	e  s date=""
	if date="" {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	k tmpWorkNum,tmpPatNum
	s tmpWorkNum="",tmpPatNum=""
	d ..GetNurseWorkNum(date,.tmpWorkNum,1) ;ctlocid
	d ..GetPatNum(date,.tmpPatNum) ;--wardid
	s wardId="" f  s wardId=$O(^CF.DHCINM.DB.MgWardD(wardId)) q:wardId=""  d
	.s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(wardId)
	.q:'$IsObject(wardObj)
	.s ctlocId=""
	.s:$IsObject(wardObj.CTLocDR) ctlocId=wardObj.CTLocDR.%Id()
	.s ward=wardObj.WardDesc
	.s patientNum=$g(tmpPatNum(wardId,"0",date))
	.s patientNumDay=$g(tmpPatNum(wardId,"D",date))
	.s patientNumNight=$g(tmpPatNum(wardId,"N",date))
	.;s patientNum=patientNum*3,patientNumDay=patientNumDay*3,patientNumNight=patientNumNight*3 ;标准应该*3
	.s workNum="",workNumDay="",workNumNight=""
	.i ctlocId'=""  d
	..s workNum=$g(tmpWorkNum(ctlocId,"0",date))
	..s workNumDay=$g(tmpWorkNum(ctlocId,"D",date))
	..s workNumNight=$g(tmpWorkNum(ctlocId,"N",date))
	.s nurseNum=""
	.s:+workNum'=0 nurseNum=$fn(workNum/8,"",0)
	.s patientNurseRatio="",patientNurseRatioDay="",patientNurseRatioNight=""
	.i ((+workNum'=0)&&(+patientNum'=0)) d
	..s patientNurseRatio="1:"_$fn((patientNum/workNum*8),"",2) ;责任护士=责班工作小时/8
	.i ((+workNumDay'=0)&&(+patientNumDay'=0)) d
	..s patientNurseRatioDay="1:"_$fn((patientNumDay/workNumDay*8),"",2) ;责任护士=责班工作小时/8
	.i ((+workNumNight'=0)&&(+patientNumNight'=0)) d
	..s patientNurseRatioNight="1:"_$fn((patientNumNight/workNum*8),"",2) ;责任护士=责班工作小时/8
	.d OutPutRowData
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRowData
	set Data=$lb(ward,patientNum,nurseNum,patientNurseRatio,patientNurseRatioDay,patientNurseRatioNight)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurPathListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurPathListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindNurPathListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurPathListExecute ]
{
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

/// Creator:
/// Createdate:
/// Description:24小时护理时数
/// Input:date--yyyy-MM-dd
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMWorkbenchComm","FindNurHourList",$zd(+$H-4,3))
Query FindNurHourList(date As %String = "") As %Query(ROWSPEC = "ward:%String,bedOccupancyDays:%String,workingHours:%String,nursingHours:%String,yearToYearValue:%String,monthToMonthValue:%String,yearToYearValueIn:%String,monthToMonthValueIn:%String")
{
}

ClassMethod FindNurHourListExecute(ByRef qHandle As %Binary, date As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1,ret=""
	s ward="",bedNum="",nurseNum="",BedNurseRatio="",BedNurseRatioY="",BedNurseRatioM="",yearToYearValueIn=0,monthToMonthValueIn=0
	i date["-" s date=$zdh(date,3)
	e  s date=""
	if date="" {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s dateM=date-1
	s dateY=date-7
	k tmpPatNum,tmpWorkNum
	s tmpPatNum="",tmpWorkNum=""
	s dateRange=date_","_dateM_","_dateY
	d ..GetNurseWorkNum(dateRange,.tmpWorkNum,0) ;ctlocid
	d ..GetPatNum(dateRange,.tmpPatNum) ;--wardid
	s wardId="" f  s wardId=$O(^CF.DHCINM.DB.MgWardD(wardId)) q:wardId=""  d
	.s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(wardId)
	.q:'$IsObject(wardObj)
	.s ctlocId=""
	.s:$IsObject(wardObj.CTLocDR) ctlocId=wardObj.CTLocDR.%Id()
	.s ward=wardObj.WardDesc
	.s tDate=date
	.s patNum=$g(tmpPatNum(wardId,"0",tDate))
	.s bedOccupancyDays=patNum
	.s workNum=""
	.s:ctlocId'="" workNum=$g(tmpWorkNum(ctlocId,"0",tDate))
	.s workingHours=workNum
	.s X=""
	.s:((+patNum'=0)&&(+workNum'=0)) X=workNum/patNum
	.;上周同天--同比
	.s tDate=dateY
	.s patNum=$g(tmpPatNum(wardId,"0",tDate))
	.s workNum=""
	.s:ctlocId'="" workNum=$g(tmpWorkNum(ctlocId,"0",tDate))
	.s XY=""
	.s:((+patNum'=0)&&(+workNum'=0)) XY=workNum/patNum
	.;前一天--环比
	.s tDate=dateM
	.s patNum=$g(tmpPatNum(wardId,"0",tDate))
	.s workNum=""
	.s:ctlocId'="" workNum=$g(tmpWorkNum(ctlocId,"0",tDate))
	.s XM=""
	.s:((+patNum'=0)&&(+workNum'=0)) XM=workNum/patNum
	.;同比环比计算率
	.s yearToYearValue="",monthToMonthValue="",yearToYearValueIn=0,monthToMonthValueIn=0
	.i ((+X'=0)&&(+XY'=0))  d
	..s yearToYearValue=$zabs($fn(((X-XY)/(XY)),"",4))*100_"%"
	..i X'=XY d
	...i (X>XY)  s yearToYearValueIn=1
	...e  s yearToYearValueIn=-1
	.i ((+X'=0)&&(+XM'=0))  d
	..s monthToMonthValue=$zabs($fn(((X-XM)/(XM)),"",4))*100_"%"
	..i X'=XM d
	...i (X>XM)  s yearToYearValueIn=1
	...e  s yearToYearValueIn=-1
	.s nursingHours=""
	.s:X'="" nursingHours=$fn(X,"",2)
	.d OutPutRowData
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRowData
	set Data=$lb(ward,bedOccupancyDays,workingHours,nursingHours,yearToYearValue,monthToMonthValue,yearToYearValueIn,monthToMonthValueIn)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurHourListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurHourListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindNurHourListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurHourListExecute ]
{
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

/// Creator:
/// Createdate:
/// Description:事件发生率
/// Input:year,eventType:同敏感指标中指标设置的名称对应,wardId:(ctLocId)
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMWorkbenchComm","FindEventRateList",2020,"身体约束率","")
Query FindEventRateList(year As %String = "", eventType As %String = "", wardId As %String = "") As %Query(ROWSPEC = "month:%String,monthStr:%String,number:%String,yearOnYearValue:%String,monthOnMonthValue:%String")
{
}

ClassMethod FindEventRateListExecute(ByRef qHandle As %Binary, year As %String = "", eventType As %String = "", wardId As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1,ret=""
	if ((year="")||(eventType="")) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s year=+year
	s indexId=""
	s indexCalN="",indexCalD="" ;分子、坟墓公式
	s tmpMinEle="",indexObj="",tmpMinEleValue=""
	s indexSubType=$LB("N","NR","D","DR")
	s isNurMgFlag=0 ;是否涉及护管数据
	s id="" f  s id=$O(^CT.DHCNS.Config.NsIndexD(id)) q:((id="")||(indexId'=""))  d
	.s indexObj=##class(CT.DHCNS.Config.NsIndex).%OpenId(id)
	.q:'$IsObject(indexObj)
	.q:indexObj.IndexDesc'=eventType
	.f i=1:1:$LL(indexSubType)  d
	..s type=$LG(indexSubType,i)
	..q:type=""
	..s subId="" f  s subId=$O(^CT.DHCNS.Config.NsIndexSubI("Type",id," "_type,subId)) q:subId=""  d
	...s subObj=##class(CT.DHCNS.Config.NsIndexSub).%OpenId(id_"||"_subId)
	...q:'$IsObject(subObj)
	...q:'$IsObject(subObj.SubProp)
	...s:subObj.SubProp.AutoType="A" isNurMgFlag=1
	...s eleId=subObj.SubProp.%Id()
	...i subObj.SubProp.DataMode'="C" d
	....s tmpMinEle(eleId)=""
	....s tmpMinEleValue(eleId)=""
	....s:type="N" indexCalN=indexCalN_"「+"_eleId
	....s:type="NR" indexCalN=indexCalN_"「-"_eleId
	....s:type="D" indexCalD=indexCalD_"「+"_eleId
	....s:type="DR" indexCalD=indexCalD_"「-"_eleId
	...e  d
	....s eleSubId=""  f  s eleSubId=$O(^CT.DHCNS.Config.NsElementSubD(eleId,eleSubId)) q:eleSubId=""  d
	.....s eleSubObj=##class(CT.DHCNS.Config.NsElementSub).%OpenId(eleId_"||"_eleSubId)
	.....q:'$IsObject(eleSubObj)
	.....q:'$IsObject(eleSubObj.EndEleDR)
	.....s subEleid=eleSubObj.EndEleDR.%Id()
	.....s tmpMinEle(subEleid)=""
	.....s tmpMinEleValue(subEleid)=""
	.....i eleSubObj.Type="N" d
	......s:type="N" indexCalN=indexCalN_"「-"_subEleid
	......s:type="NR" indexCalN=indexCalN_"「+"_subEleid
	......s:type="D" indexCalD=indexCalD_"「-"_subEleid
	......s:type="DR" indexCalD=indexCalD_"「+"_subEleid
	.....e  d
	......s:type="N" indexCalN=indexCalN_"「+"_subEleid
	......s:type="NR" indexCalN=indexCalN_"「-"_subEleid
	......s:type="D" indexCalD=indexCalD_"「+"_subEleid
	......s:type="DR" indexCalD=indexCalD_"「-"_subEleid
	.s indexId=id
	if (indexId="") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s tmpMonth=""
	f i=1:1:2  d
	.s tYear=year
	.s:i=1 tYear=year-1
	.f j=1:1:12 d
	..s month=j
	..s:month<10 month="0"_month
	..s dateTime=tYear_"-"_month
	..s rowStDate=$zdh(dateTime_"-01",3)
	..s rowEndDate=$zdh(dateTime_"-"_##class(web.NurSensUtilComm).GetMonthDay(rowStDate),3)
	..s tmpMonth((i-1)*12+j)=dateTime_"^"_rowStDate_"^"_rowEndDate
	s month="" 
	f  s month=$O(tmpMonth(month)) q:month=""  d
	.s monthValue=$g(tmpMonth(month)) 
	.q:monthValue=""
	.s rowStDate=$P(monthValue,"^",2)
	.s rowEndDate=$P(monthValue,"^",3)
	.s tWardId="" f  s tWardId=$O(^CF.DHCINM.DB.MgWardD(tWardId)) q:tWardId=""  d
	..s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(tWardId)
	..q:'$IsObject(wardObj)
	..q:(wardObj.CTLocDR="")
	..q:((wardId'="")&&(wardObj.CTLocDR.%Id()'=wardId))
	..q:((wardObj.WardStDate'="")&&(wardObj.WardStDate>$H))
	..q:((wardObj.WardEndDate'="")&&(wardObj.WardEndDate<=$H))
	..s eleId="" f  s eleId=$O(tmpMinEle(eleId)) q:eleId=""  d
	...s tmpMinEle(eleId)=""
	..d ##Class(web.NurSensConfigComm).GetMinData(tWardId, rowStDate, rowEndDate,.tmpMinEle,isNurMgFlag)
	..s eleId="" f  s eleId=$O(tmpMinEle(eleId)) q:eleId=""  d
	...s tmpMinEleValue(month,eleId)=$g(tmpMinEleValue(month,eleId))+$g(tmpMinEle(eleId))
	
	s monthIndex=12 f  s monthIndex=$O(tmpMonth(monthIndex)) q:monthIndex=""  d
	.s monthValue=$g(tmpMonth(monthIndex)) 
	.q:monthValue=""
	.s month=$P(monthValue,"^",1)
	.s monthStr=$P(month,"-",2)
	.s NValue=0,NValueY=0,NValueM=0 ;分子
	.f i=1:1:$L(indexCalN,"「") d
	..s eleId=$P(indexCalN,"「",i)
	..q:eleId=""
	..s calType=$e(eleId,1,1)
	..s realEleId=$E(eleId,2,*)
	..i calType="+" d
	...s NValue=NValue+$g(tmpMinEleValue(monthIndex,realEleId))
	...s NValueM=NValueM+$g(tmpMinEleValue(monthIndex-1,realEleId))
	...s NValueY=NValueY+$g(tmpMinEleValue(monthIndex-12,realEleId))
	..e  d
	...s NValue=NValue-$g(tmpMinEleValue(monthIndex,realEleId))
	...s NValueM=NValueM-$g(tmpMinEleValue(monthIndex-1,realEleId))
	...s NValueY=NValueY-$g(tmpMinEleValue(monthIndex-12,realEleId))
	.s DValue=0,DValueY=0,DValueM=0 ;分母
	.f i=1:1:$L(indexCalD,"「") d
	..s eleId=$P(indexCalD,"「",i)
	..q:eleId=""
	..s calType=$e(eleId,1,1)
	..s realEleId=$E(eleId,2,*)
	..i calType="+" d
	...s DValue=DValue+$g(tmpMinEleValue(monthIndex,realEleId))
	...s DValueM=DValueM+$g(tmpMinEleValue(monthIndex-1,realEleId))
	...s DValueY=DValueY+$g(tmpMinEleValue(monthIndex-12,realEleId))
	..e  d
	...s DValue=DValue-$g(tmpMinEleValue(monthIndex,realEleId))
	...s DValueM=DValueM-$g(tmpMinEleValue(monthIndex-1,realEleId))
	...s DValueY=DValueY-$g(tmpMinEleValue(monthIndex-12,realEleId))
	.s NumOther=##class(web.NurSensConfigComm).GetOtherNum(indexId)
	.s unit=indexObj.Unit,Decimals=indexObj.Decimals
	.s number="",yearOnYearValue="",monthOnMonthValue="",numberM="",numberY=""
	.s unitRate=1
	.s:unit="T" unitRate=1000
	.s:unit="P" unitRate=100
	.s:NValue=0 number=""
	.i DValue'=0  d
	..s number=$fn(((NValue/DValue)*NumOther*unitRate),"",Decimals)
	.s:NValueM=0 numberM="" ;环比
	.i DValueM'=0  d
	..s numberM=$fn(((NValueM/DValueM)*NumOther*unitRate),"",Decimals)
	.s:NValueY=0 numberY="" ;同比
	.i DValueY'=0  d
	..s numberY=$fn(((NValueY/DValueY)*NumOther*unitRate),"",Decimals)
	.i ((number'="")&&(numberM'="")) d
	..s monthOnMonthValue=$FN(((number-numberM)/numberM),"",3)
	.i ((number'="")&&(numberY'="")) d
	..s yearOnYearValue=$FN(((number-numberY)/numberY),"",3)
	.d OutPutRowData
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRowData
	set Data=$lb(month,monthStr,number,yearOnYearValue,monthOnMonthValue)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindEventRateListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindEventRateListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindEventRateListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindEventRateListExecute ]
{
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

/// Creator:
/// Createdate:
/// Description:床护比
/// Input:wardId:(ctLocId)，date:yyyy-MM-dd
/// Output:床护比、同比、环比
/// Other:w ##class(web.INMWorkbenchComm).GetBedNurData(356,$zd((+$H-6),3))
ClassMethod GetBedNurData(wardId As %String = "", date As %String = "") As %String
{
	i date["-" s date=$zdh(date,3)
	e  s date=""
	q:((date="")||(wardId="")) ""
	s dateM=date-1
	s dateY=date-7
	k tmpNurse,tmpRealBed
	s tmpNurse="",tmpRealBed=""
	s dateRange=date_","_dateM_","_dateY
	d ..GetResigeterNurseNum(dateRange,.tmpNurse) ;ctlocid
	d ..GetRealBedNum(dateRange,.tmpRealBed) ;--wardid
	s tWardId=$O(^CF.DHCINM.DB.MgWardI("CTLoc",wardId,""))
	s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(tWardId)
	q:'$IsObject(wardObj) ""
	s ward=wardObj.WardDesc
	s tDate=date
	s bedNum=$g(tmpRealBed(tDate,tWardId))
	s nurseNum=""
	s:wardId'="" nurseNum=$g(tmpNurse(tDate,wardId))
	s X=""
	s:((+bedNum'=0)&&(+nurseNum'=0)) X=nurseNum/bedNum
	;上周同天--同比
	s tDate=dateY
	s bedNum=$g(tmpRealBed(tDate,wardId))
	s nurseNum=""
	s:wardId'="" nurseNum=$g(tmpNurse(tDate,wardId))
	s XY=""
	s:((+bedNum'=0)&&(+nurseNum'=0)) XY=nurseNum/bedNum
	;前一天--环比
	s tDate=dateM
	s bedNum=$g(tmpRealBed(tDate,wardId))
	s nurseNum=""
	s:wardId'="" nurseNum=$g(tmpNurse(tDate,wardId))
	s XM=""
	s:((+bedNum'=0)&&(+nurseNum'=0)) XM=nurseNum/bedNum
	;1:X1/1:X2
	s BedNurseRatioY="",BedNurseRatioM="",yearToYearValueIn=0,monthToMonthValueIn=0
	i ((+X'=0)&&(+XY'=0))  d
	.;s BedNurseRatioY=$fn(((XY-X)/(X*XY*XY)),"",2)*100_"%"  --率的计算
	.s BedNurseRatioY=$fn((XY/X),"",2)*100_"%"
	.i X'=XY d
	..i (X<XY)  s yearToYearValueIn=1
	..e  s yearToYearValueIn=-1
	;环比
	i ((+X'=0)&&(+XM'=0))  d ;
	.;s BedNurseRatioM=$fn(((XM-X)/(X*XM*XM)),"",2)*100_"%"  --率的计算
	.s BedNurseRatioM=$fn((XM/X),"",2)*100_"%"
	.i X'=XM d
	..i (X<XM)  s monthToMonthValueIn=1
	..e  s monthToMonthValueIn=-1
	s BedNurseRatio=""
	s:X'="" BedNurseRatio="1:"_$fn(X,"",2)
	q BedNurseRatio_"^"_BedNurseRatioY_"^"_BedNurseRatioM_"^"_yearToYearValueIn_"^"_monthToMonthValueIn
}

/// Creator:
/// Createdate:
/// Description:护患比
/// Input:wardId:(ctLocId)，date:yyyy-MM-dd
/// Output:床护比、同比、环比、同比增长状态、环比增长状态
/// Other:w ##class(web.INMWorkbenchComm).GetNurPatData(356,$zd((+$H-6),3))
ClassMethod GetNurPatData(wardId As %String = "", date As %String = "") As %String
{
	i date["-" s date=$zdh(date,3)
	e  s date=""
	q:((date="")||(wardId="")) ""
	s dateM=date-1
	s dateY=date-7
	k tmpNurse,tmpRealBed
	s tmpNurse="",tmpRealBed=""
	s dateRange=date_","_dateM_","_dateY
	d ..GetNurseWorkNum(dateRange,.tmpWorkNum,1) ;ctlocid
	d ..GetPatNum(dateRange,.tmpPatNum) ;--wardid
	s tWardId=$O(^CF.DHCINM.DB.MgWardI("CTLoc",wardId,""))
	s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(tWardId)
	q:'$IsObject(wardObj) ""
	s patientNum=$g(tmpPatNum(tWardId,"0",date))
	s workNum="",patientNurseRatio=""
	s workNum=$g(tmpWorkNum(wardId,"0",date))
	i ((+workNum'=0)&&(+patientNum'=0)) d
	.s patientNurseRatio=patientNum/workNum*8 ;责任护士=责班工作小时/8
	s patientNum=$g(tmpPatNum(tWardId,"0",dateM))
	s workNum="",patientNurseRatioM=""
	s workNum=$g(tmpWorkNum(wardId,"0",dateM))
	i ((+workNum'=0)&&(+patientNum'=0)) d
	.s patientNurseRatioM=patientNum/workNum*8 ;责任护士=责班工作小时/8
	s patientNum=$g(tmpPatNum(tWardId,"0",dateY))
	s workNum="",patientNurseRatioY=""
	s workNum=$g(tmpWorkNum(wardId,"0",dateY))
	i ((+workNum'=0)&&(+patientNum'=0)) d
	.s patientNurseRatioY=patientNum/workNum*8 ;责任护士=责班工作小时/8
	s mRate="",yRate="",mIn=0,yIn=0
	i ((+patientNurseRatio'=0)&&(+patientNurseRatioY'=0)) d
	.s yRate=$fn($zabs((patientNurseRatio-patientNurseRatioY)/patientNurseRatioY*100),"",2)_"%"
	.i patientNurseRatio>patientNurseRatioY s yIn=1
	.e  s yIn=-1
	i ((+patientNurseRatio'=0)&&(+patientNurseRatioM'=0)) d
	.s mRate=$fn($zabs((patientNurseRatio-patientNurseRatioM)/patientNurseRatioM*100),"",2)_"%"
	.i patientNurseRatio>patientNurseRatioM s mIn=1
	.e  s mIn=-1
	s patientNurseRatio="1:"_$fn(patientNurseRatio,"",2)
	q patientNurseRatio_"^"_yRate_"^"_mRate_"^"_yIn_"^"_mIn
}

}
