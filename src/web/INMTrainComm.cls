/// Creator:gzj
/// Date:2018-10-29
/// Descriptions：进修相关公共类
Class web.INMTrainComm Extends %RegisteredObject
{

/// Creator:wangcc
/// Description:检查唯一性
/// Date：2018-10-30
ClassMethod IsExsitInTrain(parr As %String) As %String
{
	s flag=0
	s tmp=""
	s a=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s perNo=$zcvt($tr($g(tmp("PerNo"))," ",""),"U")
	s rowID=$tr($g(tmp("RowID"))," ","")
	
	s rw=$O(^CF.DHCINM.HR.PersonsI("Info"," S"," "_perNo,""))
	i rw="" s flag=0
	e  d
	.i rowID'="" d
	..i rowID=rw s flag=0
	..e  i rowID'=rw s flag=1
	.e  i rowID="" d
	..i rw'="" s flag=1
	q:flag=1 "进修编号已存在"
	s PerCardId=$zcvt($tr($g(tmp("PerCardId"))," ",""),"U") //取得身份证号码
	s rowid=$O(^CF.DHCINM.HR.PersonsI("card"," "_PerCardId,""))
	q:((rowid'="")&&(rowID'="")&&(rowid'=rowID)) "身份证号已存在"
	q:((rowid'="")&&(rowID="")) "身份证号已存在"
	q flag
}

/// 
/// Date:2019-08-05
/// Description:检查助护学员转科日期之后是否有排班
ClassMethod CheckNurseArg(parr As %String) As %String
{
	s ^TMP("CheckNurseArg")=parr
	f i=1:1:$l(parr,"「") d
	.s item=$p(parr,"「",i)
	.k tmp
	.d ##class(web.INMVueComm).SplitStr(item,"^","|",.tmp)
	.s date=$zdh(tmp("TransStDate"),3)
	.s id=tmp("NurseId")
	.s ret=""
	.s stdate=date-1 f  s stdate=$o(^DHCNMG.Arg.MgArrangeSubI("PerDate",id,stdate)) q:(stdate="")||(ret'="")  d
	..s rw="" f  s rw=$o(^DHCNMG.Arg.MgArrangeSubI("PerDate",id,stdate,rw)) q:(rw="")||(ret'="")  d
	...s obj=##class(CF.DHCINM.HR.Persons).%OpenId(id)
	...q:'$IsObject(obj)
	...s ret=obj.PerName_"存在"_$zd(stdate,3)_"之后的排班，请删除排班后再操作"
	q ret
}

/// Creator:wangcc
/// Description:删除来院进修护士调科信息
/// Date:2020-07-31
ClassMethod DeleteTransData(parr As %String) As %String
{
	q:parr="" 0
	f i=1:1:$l(parr,"^")  d
	.s depId=$p(parr,"^",i)
	.d ##class(DHCINM.Trans.MgInTrainDep).%DeleteId(depId)
	q 1
}

/// Creator:wangcc
/// Description:保存来院进修护士信息
/// Date:2018-10-30
ClassMethod SaveInTrain(parr As %String) As %String
{
	s ^TMP("SaveInTrain")=parr
	s tmp=""
	s a=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(CF.DHCINM.HR.Persons).%New()
	e  s obj=##class(CF.DHCINM.HR.Persons).%OpenId(id)
	s obj.PerName=$zcvt($tr($g(tmp("PerName"))," ",""),"U")
	s obj.PerNo=$zcvt($tr($g(tmp("PerNo"))," ",""),"U")
	s obj.PerSexDR=$tr($g(tmp("PerSexDR"))," ","")
	s obj.PerCardId=$tr($g(tmp("PerCardId"))," ","")
	s obj.PerBirthday=$zdh($g(tmp("PerBirthday")),3)
	i $g(tmp("PerTrainStDate"))'="" d
	.s obj.PerDepDate=$zdh($g(tmp("PerTrainStDate")),3)
	.s obj.PerTrainStDate=$zdh($g(tmp("PerTrainStDate")),3)
	e  d
	.s obj.PerTrainStDate=""
	i $g(tmp("PerTrainEndDate"))'="" s obj.PerTrainEndDate=$zdh($g(tmp("PerTrainEndDate")),3)
	e  s obj.PerTrainEndDate=""
	s obj.PerTrainFee=$tr($g(tmp("PerTrainFee"))," ","")
	s obj.InTrainCurrentAcade=$tr($g(tmp("PerCurrentAcade"))," ","")
	s obj.PerHireJob=$tr($g(tmp("PerHireJob"))," ","")
	s obj.PerUnit=$tr($g(tmp("PerUnit"))," ","")
	s obj.PerPhone=$tr($g(tmp("PerPhone"))," ","")
	s obj.PerRemark=$tr($g(tmp("PerRemark"))," ","")
	s obj.PerTypeDR="S"
	s obj.PerDepDR=$g(tmp("PerDepDR"))
	TS
	s sc=obj.%Save()
	s flag=$$$ISOK(sc)
	i flag=1
	{
		s transRowID=$O(^CF.DHCINM.Trans.TransDepI("Current"," Y"," "_obj.%Id(),""))
		i transRowID="" d
		.i obj.PerDepDate="" s perdepdate=$zd(obj.PerTrainStDate,3)
		.e  s perdepdate=$zd(obj.PerDepDate,3)
		.d ##class(web.INMPersonComm).SaveTransData("^"_obj.%Id()_"^"_obj.PerDepDR_"^"_perdepdate_"^"_$zt($P($H,",",2),1)_"^Y^^^L")	
	}else{
		q "保存失败"
		TRO	
	}
	TC
	q obj.%Id()
}

/// Creator:wangcc
/// Description:进修人员列表
/// Date:2018-10-29
/// Table:CF.DHCINM.HR.Persons
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.INMTrainComm","FindInTrainList","^^^2020-07-11^2020-08-06",0)
Query FindInTrainList(parr As %String = "", nurseid) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindInTrainListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ^TMP("FindInTrainList")=parr
	s ret=""
	s nurseNo=$p(parr,"^",1)
	s nurseWard=$p(parr,"^",2)
	s status=$p(parr,"^",3)
	s stdate=$p(parr,"^",4)
	s enddate=$p(parr,"^",5)
	s:stdate'="" stdate=$zdh(stdate,3)
	s:enddate'="" enddate=$zdh(enddate,3)
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s RowID="" f  s RowID=$o(^CF.DHCINM.HR.PersonsI("type"," S",RowID)) q:RowID=""  d
	.s obj=##class(CF.DHCINM.HR.Persons).%OpenId(RowID)
	.q:(isAll=0)&&((obj.PerDepDR'="")&&('$d(tmpWard(obj.PerDepDR))))
	.q:((nurseWard'="")&&(obj.PerDepDR'=nurseWard))
	.s perNo=obj.PerNo
	.s perName=obj.PerName
	.s perCardId=obj.PerCardId
	.q:(nurseNo'="")&&((perNo_perName)'[$zcvt($tr(nurseNo," ",""),"U"))
	.q:((stdate'="")&&(obj.PerTrainEndDate'="")&&(obj.PerTrainEndDate<stdate))||((enddate'="")&&(obj.PerTrainStDate'="")&&(obj.PerTrainStDate>enddate))
	.q:(status="N")&&(obj.PerTrainStDate<=+$h)
	.q:(status="Y")&&'((obj.PerTrainStDate<=+$h)&&(obj.PerTrainEndDate>+$h))
	.q:(status="E")&&(obj.PerTrainEndDate>=+$h)
	.s perWard=""
	.i obj.PerDepDR'="" d
	..s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(obj.PerDepDR)
	..q:'$IsObject(wardObj)
	..s perWard=wardObj.WardDesc
	.s perSex=""
	.i obj.PerSexDR'="" s perSex=##class(web.INMPersonComm).GetCommCode(obj.PerSexDR)
	.s perAcade=""
	.i obj.InTrainCurrentAcade'="" s perAcade=##class(web.INMPersonComm).GetCommCode(obj.InTrainCurrentAcade)
	.s perAge=""
	.s perHireJob=""
	.i obj.PerHireJob'="" s perHireJob=##class(web.INMPersonComm).GetCommCode(obj.PerHireJob)
	.s perTrainStDate=""
	.i obj.PerTrainStDate'="" s perTrainStDate=##class(web.INMHISComm).DateLogicalToHtml(obj.PerTrainStDate)
	.s perTrainEndDate=""
	.i obj.PerTrainEndDate'="" s perTrainEndDate=##class(web.INMHISComm).DateLogicalToHtml(obj.PerTrainEndDate)
	.s TrainStatus=""
	.if (obj.PerTrainStDate>+$h) s TrainStatus="待进修"
	.i (obj.PerTrainStDate<=+$h)&&(obj.PerTrainEndDate>+$h) s TrainStatus="进修中"
	.i (obj.PerTrainEndDate<+$h)  s TrainStatus="进修结束"
	.s perTrainFee=""
	.i obj.PerTrainFee'="" s perTrainFee=obj.PerTrainFee
	.s perUnit=""
	.i obj.PerUnit'="" s perUnit=obj.PerUnit
	.s perPhone=obj.PerPhone
	.s perRemark=obj.PerRemark
	.s ret="perNo|"_perNo_"^perName|"_perName_"^perCardId|"_perCardId_"^perSex|"_perSex_"^perAcade|"_perAcade_"^perAge|"_perAge_"^perHireJob|"_perHireJob_"^perTrainStDate|"_perTrainStDate_"^perTrainEndDate|"_perTrainEndDate_"^perTrainFee|"_perTrainFee_"^RowID|"_RowID_"^perUnit|"_perUnit_"^perWard|"_perWard_"^perPhone|"_perPhone_"^perRemark|"_perRemark
	.s ret=ret_"^perStatus|"_TrainStatus_"^PerDepDR|"_obj.PerDepDR
	.d OutputInTrain
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputInTrain
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindInTrainListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInTrainListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindInTrainListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInTrainListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Descriptions:获取来院进修护士信息
/// Date:2018-10-30
/// Input:
/// Output:
/// Return:
/// Other： ///w ##class(web.INMTrainComm).GetTrainData(28)
ClassMethod GetTrainData(id As %String) As %String
{
	q:id="" ""
	s obj=##class(CF.DHCINM.HR.Persons).%OpenId(id)
	q:'$IsObject(obj) ""
	s PerName=obj.PerName
    s PerNo=obj.PerNo
    s PerSexDR=obj.PerSexDR
    s PerCardId=obj.PerCardId
    s InTrainCurrentAcade=obj.InTrainCurrentAcade
    s PerHireJob=obj.PerHireJob
    s PerDepDR=obj.PerDepDR
    s PerUnit=obj.PerUnit
    s PerAge=""
    i obj.PerBirthday'="" d
	.s age=##class(web.INMVueComm).CalAge($zd(obj.PerBirthday,3),$zd(+$H,3))
	.s PerAge=$p(age,"Y",1)
	i obj.PerBirthday'="" s PerBirthday=##class(web.INMHISComm).DateLogicalToHtml(obj.PerBirthday)
	e  s PerBirthday=""
    i obj.PerTrainStDate'="" s PerTrainStDate=##class(web.INMHISComm).DateLogicalToHtml(obj.PerTrainStDate)
    e  s PerTrainStDate=""
    i obj.PerTrainEndDate'="" s PerTrainEndDate=##class(web.INMHISComm).DateLogicalToHtml(obj.PerTrainEndDate)
    e  s PerTrainEndDate=""
    s PerTrainFee=obj.PerTrainFee
    s PerPhone=obj.PerPhone
    s PerRemark=obj.PerRemark
    w "[{""PerName"":"""_PerName_""",""PerNo"":"""_PerNo_""",""PerBirthday"":"""_PerBirthday_""",""PerAge"":"""_PerAge
    _""",""PerSexDR"":"""_PerSexDR_""",""PerCardId"":"""_PerCardId_""",""PerCurrentAcade"":"""_InTrainCurrentAcade
    _""",""PerHireJob"":"""_PerHireJob_""",""PerDepDR"":"""_PerDepDR_""",""PerUnit"":"""_PerUnit_""",""PerTrainStDate"":"""_PerTrainStDate_""",""PerTrainEndDate"":"""_PerTrainEndDate_""",""PerTrainFee"":"""_PerTrainFee_""",""PerPhone"":"""_PerPhone_""",""PerRemark"":"""_PerRemark_""",""RowID"":"""_id_"""}]"
    q ""
}

/// 
/// Creator:gzj
/// Description:按照病区查询进修人员
/// Date:2018-10-29
/// Table:CF.DHCINM.HR.Persons
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.INMTrainComm","FindTransForWard","")
Query FindTransForWard(ward As %String, parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindTransForWardExecute(ByRef qHandle As %Binary, ward As %String, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ^TMP("FindTransForWard")=ward_"%"_parr
	s ret=""
	s perNo="" f  s perNo=$o(^CF.DHCINM.HR.PersonsI("Info"," S",perNo)) q:perNo=""  d
	.s RowID="" f  s RowID=$o(^CF.DHCINM.HR.PersonsI("Info"," S",perNo,RowID)) q:RowID=""  d
	..s obj=##class(CF.DHCINM.HR.Persons).%OpenId(RowID)
	..s NurseWard=obj.PerDepDR
	..q:((ward'="")&&(NurseWard'=ward))
	..;q:(obj.PerTrainEndDate<+$H)
	..i obj.PerTrainStDate'="" s NurseStDate=##class(web.INMHISComm).DateLogicalToHtml(obj.PerTrainStDate)
	..e  s NurseStDate=""
	..s NurseName=obj.PerName_"("_obj.PerNo_")"
	..q:((parr'="")&&(NurseName'[parr))
	..s ret="NurseName|"_NurseName_"^RowID|"_RowID
	..d OutputTrainList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputTrainList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindTransForWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTransForWardExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindTransForWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTransForWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// create:wangcc
/// desc:保存来院进修调科信息
/// w ##class(web.INMTrainComm).SaveInTransData("InWard|4^InTrainDep|^WardId|1^NurseId|521^TransStDate|2021-04-15^TransEndDate|2021-04-23^Teacher|「InWard|6^InTrainDep|^WardId|1^NurseId|521^TransStDate|2021-04-29^TransEndDate|2021-05-08^Teacher|","N")
ClassMethod SaveInTransData(parr As %String, flag) As %String
{
	s ret=..CheckNurseArg(parr)
	q:ret'="" ret
	s sc=0
	ts
	f i=1:1:$l(parr,"「") q:sc=1  d
	.s item=$p(parr,"「",i)
	.k tmp
	.d ##class(web.INMVueComm).SplitStr(item,"^","|",.tmp)
	.s id=$g(tmp("InTrainDep"))
	.s:id="" traindep=##class(DHCINM.Trans.MgInTrainDep).%New()
	.s:id'="" traindep=##class(DHCINM.Trans.MgInTrainDep).%OpenId(id)
	.s traindep.InWard=$g(tmp("InWard"))
	.s traindep.NurseId=$g(tmp("NurseId"))
	.s traindep.Teacher=$g(tmp("Teacher"))
	.s traindep.TransStDate=$zdh($g(tmp("TransStDate")),3)
	.s:$g(tmp("TransEndDate"))["-" traindep.TransEndDate=$zdh($g(tmp("TransEndDate")),3)
	.s traindep.TransStatus=flag
	.s depSc=traindep.%Save()
	.s:'$$$ISOK(depSc) sc=1
	.i (flag="Y") d
	..s flag1=##class(web.INMPersonComm).SaveTransDep(item,"","","","")
	..s:flag1=0 sc=1
	if (sc=1)
	{
		tro
		q "保存失败"
	}
	tc
	q 1
}

/// Creator:wangcc
/// Description:查询进修人员调科记录
/// Date:2018-11-01
/// w ##class(%ResultSet).RunQuery("web.INMTrainComm","FindInTransList","28")
Query FindInTransList(nurseid As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindInTransListExecute(ByRef qHandle As %Binary, nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s depId="" f  s depId=$o(^DHCINM.Trans.MgInTrainDepI("ssdr"," "_nurseid,depId))  q:depId=""  d
	.s depObj=##class(DHCINM.Trans.MgInTrainDep).%OpenId(depId)
	.q:'$IsObject(depObj)
	.s disable="false"
	.s:depObj.TransStatus="Y" disable="true"
	.s ward=depObj.InWard
	.s stdate=$zd(depObj.TransStDate,3)
	.s enddate=$zd(depObj.TransEndDate,3)
	.s teacher=depObj.Teacher
	.s ret="Ward|"_ward_"^TransStDate|"_stdate_"^TransEndDate|"_enddate_"^Teacher|"_teacher_"^disable|"_disable_"^RowID|"_depId_"^TransStatus|"_depObj.TransStatus
	.d OutputTrainList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputTrainList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindInTransListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInTransListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindInTransListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInTransListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Description:按照病区查询正式护士人员列表
/// Date:2018-11-01
/// d ##class(%ResultSet).RunQuery("web.INMTrainComm","FindNurseList",4，"")
Query FindNurseList(ward As %String, parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindNurseListExecute(ByRef qHandle As %Binary, ward As %String, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ^TMP("FindNurseList")=ward_"%"_parr
	s nurWard="" f  s nurWard=$o(^CF.DHCINM.HR.PersonsI("DepID",nurWard)) q:nurWard=""  d
	.s RowID="" f  s RowID=$o(^CF.DHCINM.HR.PersonsI("DepID",nurWard,RowID)) q:RowID=""  d
	..s obj=##class(CF.DHCINM.HR.Persons).%OpenId(RowID)
	..q:((ward'="")&&(obj.PerDepDR'=ward))
	..q:'$IsObject(obj)
	..q:##class(web.INMHRComm).IsFormalWorkNur(RowID,+$H,"")=0
	..q:obj.PerTrainFlag="Y"
	..s nurseName=obj.PerName
	..s nurseID=obj.PerID
	..s nurseWard=""
	..i obj.PerDepDR'="" d
	...s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(obj.PerDepDR)
	...q:'$IsObject(wardObj)
	...s nurseWard=wardObj.WardDesc
	..s nurseBirth=""
	..i obj.PerBirthday'="" s nurseBirth=##class(web.INMHISComm).DateLogicalToHtml(obj.PerBirthday)
	..s PerAge=""
    ..i obj.PerBirthday'="" d
	...s age=##class(web.INMVueComm).CalAge($zd(obj.PerBirthday,3),$zd(+$H,3))
	...s PerAge=$p(age,"Y",1)
	..s hiredutydesc="",postdutydesc="",educatedesc=""
	..s hireduty=##class(web.INMHRComm).GetNurseHireDuty(RowID,+$h)
	..s:hireduty'="" hiredutydesc=$p(hireduty,"^",2)
	..s postduty=##class(web.INMHRComm).GetNurseDuty(RowID,+$h)
	..s:postduty'="" postdutydesc=$p(postduty,"^",2)
	..s educate=##class(web.INMHRComm).GetNurseEdu(RowID,+$h)
	..s:educate'="" educatedesc=$p(educate,"^",2)
	..s ret="nurseName|"_nurseName_"^nurseID|"_nurseID_"^nurseWard|"_nurseWard_"^nurseBirth|"_nurseBirth_"^RowID|"_RowID
	..s ret=ret_"^nurseAge|"_PerAge_"^nurseHireDuty|"_hiredutydesc_"^nursePostDuty|"_postdutydesc_"^nurseEduca|"_educatedesc
	..d OutputNurseList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputNurseList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurseListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurseListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindNurseListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurseListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Descrption:保存外派人员数据
/// Date：2018-11-02
/// Table:
/// Input:
/// Output:
/// Return:
/// Other:
ClassMethod SaveOutTrainData(parr As %String, create As %String, special As %String) As %String
{
	s ^TMP("SaveOutTranData")=parr
	//41^171^514^170
	q:parr="" ""
	s len=$l(parr,"^")
	f i=1:1:len
	{
		s itm=$p(parr,"^",i)
		i itm="" continue
		ts
		s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(itm)
		q:'$IsObject(perObj)
		s ward=perObj.PerDepDR
		s nurseId=perObj.PerID
		s year=$p($zd(+$H,3),"-",1)
		s rw=$o(^DHCINM.HR.MgOutTrainI("Date",year," "_ward,nurseId,""))
		i rw="" s obj=##class(DHCINM.HR.MgOutTrain).%New()
		e  s obj=##class(DHCINM.HR.MgOutTrain).%OpenId(rw)
		s obj.NurseID=##class(CF.DHCINM.HR.Persons).%OpenId(itm)
		s obj.TrainYear=year
		s educa=##class(web.INMHRComm).GetNurseEdu(itm,+$h)
		s TrainAcade=""
		s:educa'="" TrainAcade=$p(educa,"^",1)
		s obj.TrainAcade=TrainAcade
		s obj.TrainDep=perObj.PerDepDR
		s obj.TrainSubject=special
		s hiredutyid="",postdutyid=""
		s hireduty=##class(web.INMHRComm).GetNurseHireDuty(itm,+$h)
		s:hireduty'="" hiredutyid=$p(hireduty,"^",1)
		s postduty=##class(web.INMHRComm).GetNurseDuty(itm,+$h)
		s:postduty'="" postdutyid=$p(postduty,"^",1)
		s obj.TrainHireDuty=hiredutyid
		s obj.TrainPostDuty=postdutyid
		s sc=obj.%Save()
		i $$$ISOK(sc)=1
		{
			s perObj.PerTrainFlag="Y"
			s sc1=perObj.%Save()
			i $$$ISOK(sc1)=1
			{
				tc
			}
			else
			{
				tro
			}
		}
		else
		{
			tro
		}
	}
	q 0
}

/// Creator:gzj
/// Date:2018-12-12
/// Decriptions:删除外派进修记录
/// 
ClassMethod DelOutTrainData(id As %String) As %String
{
	s ^TMP("DelOutTrainData")=id
	s flag=0
	s obj=##class(DHCINM.HR.MgOutTrain).%OpenId(id)
	q:'$IsObject(obj) flag
	q:obj.NurseID="" flag
	s per=##class(CF.DHCINM.HR.Persons).%OpenId(obj.NurseID.%Id())
	q:'$IsObject(per) flag
	ts
	s per.PerTrainFlag="N"
	s sc=per.%Save()
	i $$$ISOK(sc)=1 d
	.s sc1=##class(DHCINM.HR.MgOutTrain).%DeleteId(id)
	.i $$$ISOK(sc1)=1 d
	..tc
	..s flag=1
	.e  d
	..tro
	e  d
	.tro
	q flag
}

/// Creator:wangcc
/// Description:按照病区查询外派进修人员列表
/// Date:2018-11-02
/// d ##class(%ResultSet).RunQuery("web.INMTrainComm","FindOutTrainList","","2020-09-01^2020-10-03^^")
Query FindOutTrainList(ward As %String, parr As %String = "", loginID As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindOutTrainListExecute(ByRef qHandle As %Binary, ward As %String, parr As %String = "", loginID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ^TMP("FindOutTrainList")=ward_"%"_parr
	s stDate=$p(parr,"^",1)
	i stDate'="" s stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",2)
	i endDate'="" s endDate=$zdh(endDate,3)
	s Status=$p(parr,"^",3)
	s Person=$p(parr,"^",4)
	s isAll=##class(web.INMLoginComm).SetLoginWard(loginID,.tmpWard)
	s year="" f  s year=$o(^DHCINM.HR.MgOutTrainI("Date",year)) q:year=""  d
	.s Ward="" f  s Ward=$o(^DHCINM.HR.MgOutTrainI("Date",year,Ward)) q:Ward=""  d
	..q:((ward'="")&&($tr(Ward," ","")'=ward))
	..s realWard=$tr(Ward," ","")
	..q:((isAll'=1)&&('$d(tmpWard(realWard))))
	..s Nurse="" f  s Nurse=$o(^DHCINM.HR.MgOutTrainI("Date",year,Ward,Nurse)) q:Nurse=""  d
	...s RowID="" f  s RowID=$o(^DHCINM.HR.MgOutTrainI("Date",year,Ward,Nurse,RowID)) q:RowID=""  d
	....s obj=##class(DHCINM.HR.MgOutTrain).%OpenId(RowID)
	....q:'$IsObject(obj)
	....s nurseName=obj.NurseID.PerName
	....s perId=obj.NurseID.PerID
	....q:(Person'="")&&((nurseName_perId)'[Person)
	....s trainDep=""
	....i obj.TrainDep'="" d
	.....s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(obj.TrainDep)
	.....q:'$IsObject(wardObj)
	.....s trainDep=wardObj.WardDesc
	....s trainStDate=obj.TrainStDate
	....q:((stDate'="")&&(trainStDate'="")&&(stDate>trainStDate))
	....q:((endDate'="")&&(trainStDate'="")&&(endDate<trainStDate))
	....i obj.TrainStDate'="" s trainStDate=##class(web.INMHISComm).DateLogicalToHtml(obj.TrainStDate)
	....s trainEndDate=""
	....i obj.TrainEndDate'="" s trainEndDate=##class(web.INMHISComm).DateLogicalToHtml(obj.TrainEndDate)
	....s internStatus="预备"
	....s realStatus="N"
	....s:((obj.TrainStDate'=""))&&(obj.TrainStDate>+$h) internStatus="预备",realStatus="N"
	....s:(obj.TrainEndDate'="")&&((obj.TrainStDate'=""))&&(obj.TrainStDate<=+$h)&&(obj.TrainEndDate>=+$h) internStatus="外派",realStatus="Y"
	....s:((obj.TrainEndDate'=""))&&(obj.TrainEndDate<+$h) internStatus="结束",realStatus="E"
	....q:((Status'="")&&(Status'=realStatus))
	....s trainSubject=""
	....i obj.TrainSubject'="" d
	.....s trainSubject=##class(web.INMPersonComm).GetCommCode(obj.TrainSubject)
	....s TrainHireDuty=""
	....i obj.TrainPostDuty'="" d
	.....s TrainHireDuty=##class(web.INMPersonComm).GetCommCode(obj.TrainHireDuty)
	....s trainHospital=obj.TrainHospital
	....s trainLoc=""
	....i obj.TrainLoc'="" d
	.....s locObj=##class(CF.DHCINM.DB.MgWardLoc).%OpenId(obj.TrainLoc)
	.....q:'$IsObject(locObj)
	.....s trainLoc=locObj.LocDesc
	....s NurseAge=""
	....s age=##class(web.INMVueComm).CalAge($zd(obj.NurseID.PerBirthday,3),$zd(obj.CreateDate,3)) //18Y 1M 1D18Y 1M 1D
	....i age'="" s NurseAge=$p(age,"Y")
	....s TrainAcade=""
	....i obj.TrainAcade'="" s TrainAcade=obj.TrainAcade
	....;s TrainLoc=""
	....;i obj.TrainLoc'="" s TrainLoc=$lg(^CF.DHCINM.DB.MgWardLocD(obj.TrainLoc),3)
	....;s TrainHos=""
	....;i obj.TrainHospital'="" s TrainHos=obj.TrainHospital
	....s ret="nurseName|"_nurseName_"^trainDep|"_trainDep_"^trainStDate|"_trainStDate_"^trainEndDate|"_trainEndDate
	....s ret=ret_"^trainSubject|"_trainSubject_"^trainHospital|"_trainHospital_"^trainLoc|"_trainLoc_"^RowID|"_RowID
	....s ret=ret_"^nurseAge|"_NurseAge_"^trainAcade|"_TrainAcade_"^trainHireDuty|"_TrainHireDuty_"^nurseID|"_perId_"^trainStatus|"_internStatus
	....;s ret=ret_"^TrainLoc|"_TrainLoc_"^TrainHospital|"_TrainHos_
	....d OutputTrainList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputTrainList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindOutTrainListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOutTrainListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindOutTrainListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOutTrainListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Description:获取病区全集
/// Date:2018-11-02
/// 
Query FindAllWards(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindAllWardsExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ^TMP("FindAllWards")=parr
	s ret=""
	s sort="" f  s sort=$o(^CF.DHCINM.DB.MgWardI("Sort",sort)) q:sort=""  d
	.s rw="" f  s rw=$o(^CF.DHCINM.DB.MgWardI("Sort",sort,rw)) q:rw=""  d
	..s obj=##class(CF.DHCINM.DB.MgWard).%OpenId(rw)
	..q:'$IsObject(obj)
	..s wardDesc=obj.WardDesc
	..s wardCode=obj.WardCode
	..s ret="WardDesc|"_wardDesc_"^WardCode|"_wardCode_"^rw|"_rw
	..d OutputWardList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputWardList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAllWardsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllWardsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindAllWardsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllWardsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Description:获取科室全集
/// Date:2018-11-02
/// d ##class(%ResultSet).RunQuery("web.INMTrainComm","FindAllLocs","")
Query FindAllLocs(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindAllLocsExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ^TMP("FindAllLocs")=parr
	s ret=""
	s code="" f  s code=$o(^CF.DHCINM.DB.MgWardLocI("Code",code)) q:code=""  d
	.s rw="" f  s rw=$o(^CF.DHCINM.DB.MgWardLocI("Code",code,rw)) q:rw=""  d
	..s obj=##class(CF.DHCINM.DB.MgWardLoc).%OpenId(rw)
	..q:'$IsObject(obj)
	..s locCode=obj.LocCode
	..s locDesc=obj.LocDesc
	..s ret="LocDesc|"_locDesc_"^LocCode|"_locCode_"^rw|"_rw
	..d OutputLocList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputLocList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAllLocsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllLocsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindAllLocsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllLocsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Description:获取进修人员的数据
/// Date:2018-11-02
/// dubug:w .GetOutTrainData(1)
ClassMethod GetOutTrainData(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCINM.HR.MgOutTrain).%OpenId(id)
	q:'$IsObject(obj) ""
	s NurseName=obj.NurseID.PerName
    s NurseSex=obj.NurseID.PerSexDR
    s NurseAge=""
    i obj.NurseID.PerBirthday'="" d
    .s Age=##class(web.INMVueComm).CalAge($zd(obj.NurseID.PerBirthday,3),$zd(+$H,3))
    .s NurseAge=$p(Age,"Y")
    s NurseWard=obj.TrainDep
    s NurseAcade=obj.TrainAcade
    s NurseHireDuty=obj.TrainHireDuty
    s NursePostDuty=obj.TrainPostDuty
    s NursePhone=obj.NurseID.PerPhone
    s TrainHospital=obj.TrainHospital
    s TrainSubject=obj.TrainSubject
    s TrainLoc=obj.TrainLoc
    s TrainTarget=obj.TrainTarget
    s TrainStDate=""
    i obj.TrainStDate'="" s TrainStDate=##class(web.INMHISComm).DateLogicalToHtml(obj.TrainStDate)
    s TrainEndDate=""
    i obj.TrainEndDate'="" s TrainEndDate=##class(web.INMHISComm).DateLogicalToHtml(obj.TrainEndDate)
	w "{""NurseName"":"""_NurseName_""",""NurseSex"":"""_NurseSex_""",""NurseAge"":"""_NurseAge_""",""NurseWard"":"""
	_NurseWard_""",""NurseAcade"":"""_NurseAcade_""",""NurseHireDuty"":"""_NurseHireDuty
	_""",""NursePostDuty"":"""_NursePostDuty_""",""NursePhone"":"""_NursePhone_""",""TrainHospital"":"""_TrainHospital
	_""",""TrainLoc"":"""_TrainLoc_""",""TrainTarget"":"""_TrainTarget_""",""TrainSubject"":"""_TrainSubject
	_""",""TrainStDate"":"""_TrainStDate_""",""TrainEndDate"":"""_TrainEndDate_""",""RowID"":"""_id_"""}"
	q ""
}

/// w ##class(web.INMTrainComm).SaveOutTrainPlan("NurseName|大大11^NurseSex|6__2^NurseAge|21^NurseWard|2^NurseAcade|3__3^NurseHireDuty|12__3^NursePostDuty|14__1^NursePhone|^TrainHospital|^TrainLoc|3^TrainSubject|26__1^TrainTarget|^TrainStDate|2020-08-02^TrainEndDate|2020-08-02^RowID|1")
ClassMethod SaveOutTrainPlan(parr As %String) As %String
{
	s ^TMP("SaveOutTrainPlan")=parr
	s tmp=""
	s a=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	//NurseName|姚嘉丽^NurseSex|6||2^NurseAge|35^NurseWard|1^NurseAcade|3||2^NurseDegree|19||2
	//^NurseHireDuty|14||2^NursePostDuty|16||5^NursePhone|13570965340^TrainHospital|进修医院
	//^TrainLoc|29^TrainSpecial|32||2^TrainTarget|目标设想手册是的是的^TrainStDate|2018-11-04^TrainEndDate|2018-11-11^RowID|2
	s id=$g(tmp("RowID"))
	q:id="" 0
	s obj=##class(DHCINM.HR.MgOutTrain).%OpenId(id)
	q:'$IsObject(obj) 0
	s obj.TrainAcade=$tr($g(tmp("NurseAcade")),"_","|")
	s obj.TrainHireDuty=$tr($g(tmp("NurseHireDuty")),"_","|")
	s obj.TrainPostDuty=$tr($g(tmp("NursePostDuty")),"_","|")
	s obj.TrainHospital=$tr($g(tmp("TrainHospital"))," ","")
	s obj.TrainLoc=$tr($g(tmp("TrainLoc"))," ","")
	s obj.TrainSubject=$tr($g(tmp("TrainSubject")),"_","|")
	i $tr($g(tmp("TrainStDate"))," ","")'="" s obj.TrainStDate=$zdh($tr($g(tmp("TrainStDate"))," ",""),3)
	i $tr($g(tmp("TrainEndDate"))," ","")'="" s obj.TrainEndDate=$zdh($tr($g(tmp("TrainEndDate"))," ",""),3)
	s TrainStDate=$g(tmp("TrainStDate"))
	s TrainEndDate=$g(tmp("TrainEndDate"))
	s:TrainStDate'="" TrainStDate=$zdh(TrainStDate,3)
	s:TrainEndDate'="" TrainEndDate=$zdh(TrainEndDate,3)
	s obj.TrainStDate=TrainStDate
	s obj.TrainEndDate=TrainEndDate
	s obj.TrainTarget=$tr($replace(tmp("TrainTarget"),$c(10),"")," ","")
	ts
	s sc=obj.%Save()
	s flag=$$$ISOK(sc)
	s argDate=TrainStDate-1 f  s argDate=$o(^DHCINM.Arg.MgArrangeSubI("PerDate",obj.NurseID.%Id(),argDate)) q:((argDate="")||(argDate>TrainEndDate)||(flag'=1))  d
	.s argId="" f  s argId=$o(^DHCINM.Arg.MgArrangeSubI("PerDate",obj.NurseID.%Id(),argDate,argId)) q:((argId="")||(flag'=1))  d
	..s sc=##class(DHCINM.Arg.MgArrangeSub).%DeleteId(argId)
	..s flag=$$$ISOK(sc)
	i flag'=1 tro
	e  tc
	q flag
}

}
