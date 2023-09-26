/// Creator:gzj
/// Date:2018-10-29
/// Descriptions：进修相关公共类
Class web.NurMgTrainComm Extends %RegisteredObject
{

/// Creator:gzj
/// Description:检查唯一性
/// Date：2018-10-30
ClassMethod IsExsitInTrain(parr As %String) As %String
{
	s flag=0
	s tmp=""
	s a=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s perNo=$zcvt($tr($g(tmp("PerNo"))," ",""),"U")
	s rowID=$tr($g(tmp("RowID"))," ","")
	s cardID=$tr($g(tmp("PerCardId"))," ","")
	s ID=$O(^DHCNMG.HR.MgPersonsI("card"," "_cardID,""))
	i ((ID'="")&&(ID'=rowID)) q -1
	s rw=$O(^DHCNMG.HR.MgPersonsI("Info"," S"," "_perNo,""))
	i rw="" s flag=0
	e  d
	.i rowID'="" d
	..i rowID=rw s flag=0
	..e  i rowID'=rw s flag=1
	.e  i rowID="" d
	..i rw'="" s flag=1
	q flag
}

/// Creator:gzj
/// Description:保存来院进修护士信息
/// Date:2018-10-30
ClassMethod SaveInTrain(parr As %String) As %String
{
	s tmp=""
	s a=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCNMG.HR.MgPersons).%New()
	e  s obj=##class(DHCNMG.HR.MgPersons).%OpenId(id)
	s obj.PerName=$zcvt($tr($g(tmp("PerName"))," ",""),"U")
	s obj.PerNo=$zcvt($tr($g(tmp("PerNo"))," ",""),"U")
	s obj.PerSexDR=$tr($g(tmp("PerSexDR"))," ","")
	s obj.PerCardId=$tr($g(tmp("PerCardId"))," ","")
	s obj.PerDepDR=$tr($g(tmp("PerDepDR"))," ","")
	i $g(tmp("PerTrainStDate"))'="" d
	.s obj.PerDepDate=$zdh($g(tmp("PerTrainStDate")),3)
	.s obj.PerTrainStDate=$zdh($g(tmp("PerTrainStDate")),3)
	e  d
	.s obj.PerTrainStDate=""
	i $g(tmp("PerTrainEndDate"))'="" s obj.PerTrainEndDate=$zdh($g(tmp("PerTrainEndDate")),3)
	e  s obj.PerTrainEndDate=""
	s obj.PerTrainFee=$tr($g(tmp("PerTrainFee"))," ","")
	s obj.PerCurrentAcade=$tr($g(tmp("PerCurrentAcade"))," ","")
	s obj.PerHireJob=$tr($g(tmp("PerHireJob"))," ","")
	s obj.PerUnit=$tr($g(tmp("PerUnit"))," ","")
	s obj.PerPhone=$tr($g(tmp("PerPhone"))," ","")
	s obj.PerRemark=$tr($g(tmp("PerRemark"))," ","")
	s obj.PerTypeDR="S"
	s sc=obj.%Save()
	s flag=$$$ISOK(sc)
	i flag=1
	{
		s transRowID=$O(^DHCNMG.HR.MgTransDepI("Current"," Y"," "_obj.%Id(),""))
		i transRowID="" d
		.i obj.PerDepDate="" s perdepdate=$zd(obj.PerTrainStDate,3) ;s perdepdate=$zd(+$h,3)
		.e  s perdepdate=$zd(obj.PerDepDate,3)
		.s TransFlag=##class(web.NurMgPersonComm).SaveTransData("^"_obj.%Id()_"^"_obj.PerDepDR_"^"_perdepdate_"^"_$zt($P($H,",",2),1)_"^Y^^^L")	
	}
	q 0
}

/// Creator:gzj
/// Description:进修人员列表
/// Date:2018-10-29
/// Table:DHCNMG.HR.MgPersons
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgTrainComm","FindInTrainList","")
Query FindInTrainList(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindInTrainListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s nurseNo=$p(parr,"^",1)
	s nurseWard=$p(parr,"^",2)
	s RowID="" f  s RowID=$o(^DHCNMG.HR.MgPersonsI("type"," S",RowID)) q:RowID=""  d
	.s obj=##class(DHCNMG.HR.MgPersons).%OpenId(RowID)
	.s perNo=obj.PerNo
	.s perName=obj.PerName
	.s perCardId=obj.PerCardId
	.q:((nurseWard'="")&&(obj.PerDepDR'=nurseWard))
	.q:(nurseNo'="")&&((perNo_perName)'[$zcvt($tr(nurseNo," ",""),"U"))
	.s perWard=""
	.i obj.PerDepDR'="" d
	..s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(obj.PerDepDR)
	..q:'$IsObject(wardObj)
	..s perWard=wardObj.WardDesc
	.s perSex=""
	.i obj.PerSexDR'="" s perSex=##class(web.NurMgPersonComm).GetCommCode(obj.PerSexDR)
	.s perAcade=""
	.i obj.PerCurrentAcade'="" s perAcade=##class(web.NurMgPersonComm).GetCommCode(obj.PerCurrentAcade)
	.s perAge=""
	.s perHireJob=""
	.i obj.PerHireJob'="" s perHireJob=##class(web.NurMgPersonComm).GetCommCode(obj.PerHireJob)
	.s perTrainStDate=""
	.i obj.PerTrainStDate'="" s perTrainStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerTrainStDate)
	.s perTrainEndDate=""
	.i obj.PerTrainEndDate'="" s perTrainEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerTrainEndDate)
	.s perTrainFee=""
	.i obj.PerTrainFee'="" s perTrainFee=obj.PerTrainFee
	.s perUnit=""
	.i obj.PerUnit'="" s perUnit=obj.PerUnit
	.s perPhone=obj.PerPhone
	.s perRemark=obj.PerRemark
	.s ret="perNo|"_perNo_"^perName|"_perName_"^perCardId|"_perCardId_"^perSex|"_perSex_"^perAcade|"_perAcade_"^perAge|"_perAge_"^perHireJob|"_perHireJob_"^perTrainStDate|"_perTrainStDate_"^perTrainEndDate|"_perTrainEndDate_"^perTrainFee|"_perTrainFee_"^RowID|"_RowID_"^perUnit|"_perUnit_"^perWard|"_perWard_"^perPhone|"_perPhone_"^perRemark|"_perRemark
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
/// Other
ClassMethod GetTrainData(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.HR.MgPersons).%OpenId(id)
	q:'$IsObject(obj) ""
	s PerName=obj.PerName
    s PerNo=obj.PerNo
    s PerSexDR=obj.PerSexDR
    s PerCardId=obj.PerCardId
    s PerCurrentAcade=obj.PerCurrentAcade
    s PerHireJob=obj.PerHireJob
    s PerDepDR=obj.PerDepDR
    s PerUnit=obj.PerUnit
    i obj.PerTrainStDate'="" s PerTrainStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerTrainStDate)
    e  s PerTrainStDate=""
    i obj.PerTrainEndDate'="" s PerTrainEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerTrainEndDate)
    e  s PerTrainEndDate=""
    s PerTrainFee=obj.PerTrainFee
    s PerPhone=obj.PerPhone
    s PerRemark=obj.PerRemark
    w "[{""PerName"":"""_PerName_""",""PerNo"":"""_PerNo_""",""PerSexDR"":"""_PerSexDR_""",""PerCardId"":"""_PerCardId_""",""PerCurrentAcade"":"""_PerCurrentAcade_""",""PerHireJob"":"""_PerHireJob_""",""PerDepDR"":"""_PerDepDR_""",""PerUnit"":"""_PerUnit_""",""PerTrainStDate"":"""_PerTrainStDate_""",""PerTrainEndDate"":"""_PerTrainEndDate_""",""PerTrainFee"":"""_PerTrainFee_""",""PerPhone"":"""_PerPhone_""",""PerRemark"":"""_PerRemark_""",""RowID"":"""_id_"""}]"
    q ""
}

/// 
/// Creator:gzj
/// Description:按照病区查询进修人员
/// Date:2018-10-29
/// Table:DHCNMG.HR.MgPersons
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgTrainComm","FindTransForWard","")
Query FindTransForWard(ward As %String, parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindTransForWardExecute(ByRef qHandle As %Binary, ward As %String, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s perNo="" f  s perNo=$o(^DHCNMG.HR.MgPersonsI("Info"," S",perNo)) q:perNo=""  d
	.s RowID="" f  s RowID=$o(^DHCNMG.HR.MgPersonsI("Info"," S",perNo,RowID)) q:RowID=""  d
	..s obj=##class(DHCNMG.HR.MgPersons).%OpenId(RowID)
	..s NurseWard=obj.PerDepDR
	..q:((ward'="")&&(NurseWard'=ward))
	..;q:(obj.PerTrainEndDate<+$H)
	..i obj.PerTrainStDate'="" s NurseStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerTrainStDate)
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

ClassMethod SaveInTransData(parr As %String) As %String
{
	s transDate=$p(parr,"^",3)
	s nurseid=$p(parr,"^",1)
	s nursedep=$p(parr,"^",2)
	i $zdh(transDate,3)<(+$H)
	{
		s parm="^"_nurseid_"^"_nursedep_"^"_transDate_"^"_$zt($P($H,",",2),1)_"^Y^^^L"
		d ##class(web.NurMgPersonComm).SaveTransData(parm)
		d ##class(web.NurMgSysTaskComm).ChangePerDepInfo(nurseid,nursedep,$zdh(transDate,3))
	}
	else
	{
		s parm="^"_nurseid_"^"_nursedep_"^"_transDate_"^0^P^^^L"
		;d ##class(web.NurMgPersonComm).SaveTransData(parm)
		s obj=##class(DHCNMG.HR.MgTransDep).%New()
		s obj.PerDr=nurseid
		s obj.PerDepart=nursedep
		s obj.PerTranStDate=$zdh(transDate,3)
		s obj.PerTranStTime=$p($H,",",2)
		s obj.PerTranCurrent="P"
		s obj.PerTransType="L"
		d obj.%Save()
	}
		
	q 0
}

/// Creator:gzj
/// Description:查询进修人员调科记录
/// Date:2018-11-01
/// 
Query FindInTrainsList(ward As %String, parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindInTrainsListExecute(ByRef qHandle As %Binary, ward As %String, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s stDate=$p(parr,"^",1)
	i stDate'="" s stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",2)
	i endDate'="" s endDate=$zdh(endDate,3)
	
	s nurseNo="" f  s nurseNo=$o(^DHCNMG.HR.MgPersonsI("Info"," S",nurseNo)) q:nurseNo=""  d
	.s RowID="" f  s RowID=$o(^DHCNMG.HR.MgPersonsI("Info"," S",nurseNo,RowID)) q:RowID=""  d
	..s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(RowID)
	..q:((ward'="")&&(perObj.PerDepDR'=ward))
	..s tranRw="" f  s tranRw=$o(^DHCNMG.HR.MgTransDepI("ssdr"," "_RowID,tranRw)) q:tranRw=""  d
	...s obj=##class(DHCNMG.HR.MgTransDep).%OpenId(tranRw)
	...q:'$IsObject(obj)
	...s transName=perObj.PerName
	...s transNo=perObj.PerNo
	...i obj.PerTranStDate'="" s transStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerTranStDate)
	...e  s transStDate=""
	...i obj.PerTranStTime'="" s transStTime=$zt(obj.PerTranStTime,2)
	...e  s transStTime=""
	...i obj.PerTranEndDate'="" s transEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerTranEndDate)
	...e  s transEndDate=""
	...i obj.PerTranEndTime'="" s transEndTime=$zt(obj.PerTranEndTime,2)
	...e  s transEndTime=""
	...q:(((stDate'="")&&(obj.PerTranEndDate'="")&&(stDate>obj.PerTranEndDate))!((endDate'="")&&(obj.PerTranStDate'="")&&(endDate<obj.PerTranStDate)))
	...s tranCurrent=""
	...i obj.PerTranCurrent="N" s tranCurrent="No"
	...e  i obj.PerTranCurrent="Y" s tranCurrent="Yes"
	...e  i obj.PerTranCurrent="P" s tranCurrent="Pro"
	...s transDep=""
	...s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(obj.PerDepart)
	...q:'$IsObject(wardObj)
	...s transDep=wardObj.WardDesc
	...s ret="transDep|"_transDep_"^transName|"_transName_"^transNo|"_transNo_"^transStDate|"_transStDate_"^transStTime|"_transStTime_"^transEndDate|"_transEndDate_"^transEndTime|"_transEndTime_"^tranCurrent|"_tranCurrent_"^RowID|"_tranRw
	...d OutputTrainList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputTrainList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindInTrainsListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInTrainsListExecute ]
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

ClassMethod FindInTrainsListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInTrainsListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Description:按照病区查询正式护士人员列表
/// Date:2018-11-01
/// 
Query FindNurseList(ward As %String, parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindNurseListExecute(ByRef qHandle As %Binary, ward As %String, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s nurWard="" f  s nurWard=$o(^DHCNMG.HR.MgPersonsI("DepID",nurWard)) q:nurWard=""  d
	.s RowID="" f  s RowID=$o(^DHCNMG.HR.MgPersonsI("DepID",nurWard,RowID)) q:RowID=""  d
	..s obj=##class(DHCNMG.HR.MgPersons).%OpenId(RowID)
	..q:((ward'="")&&(obj.PerDepDR'=ward))
	..q:'$IsObject(obj)
	..q:obj.PerTypeDR'="N"
	..q:obj.PerCareType'="N"
	..q:obj.PerTrainFlag="Y"
	..q:obj.PerAuditFlag'="Y"
	..s nurseName=obj.PerName
	..s nurseID=obj.PerID
	..s nurseWard=""
	..i obj.PerDepDR'="" d
	...s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(obj.PerDepDR)
	...q:'$IsObject(wardObj)
	...s nurseWard=wardObj.WardDesc
	..s nurseBirth=""
	..i obj.PerBirthday'="" s nurseBirth=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerBirthday)
	..s ret="nurseName|"_nurseName_"^nurseID|"_nurseID_"^nurseWard|"_nurseWard_"^nurseBirth|"_nurseBirth_"^RowID|"_RowID
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
	q:parr="" ""
	s len=$l(parr,"^")
	f i=1:1:len
	{
		s itm=$p(parr,"^",i)
		i itm="" continue
		ts
		s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(itm)
		q:'$IsObject(perObj)
		s ward=perObj.PerDepDR
		s nurseId=perObj.PerID
		s year=$p($zd(+$H,3),"-",1)
		s rw=$o(^DHCNMG.HR.MgNurTrainingI("Date",year," "_ward,nurseId,""))
		i rw="" s obj=##class(DHCNMG.HR.MgNurTraining).%New()
		e  s obj=##class(DHCNMG.HR.MgNurTraining).%OpenId(rw)
		s obj.NurseID=##class(DHCNMG.HR.MgPersons).%OpenId(itm)
		s obj.TrainYear=year
		;s obj.TrainSchool=""
		;s obj.TrainAcade=""
		s TrainAcade=""
		s TrainSchool=""
		s TrainDegree=""
		s eduStDate=$o(^DHCNMG.HR.MgEducateI("flag",itm,""),-1)
		i eduStDate'="" d
		.s eduRw=$o(^DHCNMG.HR.MgEducateI("flag",itm,eduStDate,""))
		.i eduRw'="" d
		..s eduObj=##class(DHCNMG.HR.MgEducate).%OpenId(eduRw)
		..q:'$IsObject(eduObj)
		..s TrainAcade=eduObj.EduAcademic
		..s TrainDegree=eduObj.EduDegree
		..s TrainSchool=eduObj.EduSchool
		s obj.TrainAcade=TrainAcade
		s obj.TrainDegree=TrainDegree
		s obj.TrainSchool=TrainSchool
		s obj.TrainDep=perObj.PerDepDR
		s obj.CreateUser=create
		s obj.TrainSubject=special
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
	s flag=0
	s obj=##class(DHCNMG.HR.MgNurTraining).%OpenId(id)
	q:'$IsObject(obj) flag
	q:obj.NurseID="" flag
	s per=##class(DHCNMG.HR.MgPersons).%OpenId(obj.NurseID.%Id())
	q:'$IsObject(per) flag
	ts
	s per.PerTrainFlag="N"
	s sc=per.%Save()
	i $$$ISOK(sc)=1 d
	.s sc1=##class(DHCNMG.HR.MgNurTraining).%DeleteId(id)
	.i $$$ISOK(sc1)=1 d
	..tc
	..s flag=1
	.e  d
	..tro
	e  d
	.tro
	q flag
}

/// Creator:gzj
/// Description:按照病区查询外派进修人员列表
/// Date:2018-11-02
/// 
Query FindOutTrainList(ward As %String, parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindOutTrainListExecute(ByRef qHandle As %Binary, ward As %String, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s stDate=$p(parr,"^",1)
	i stDate'="" s stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",2)
	i endDate'="" s endDate=$zdh(endDate,3)
	s year="" f  s year=$o(^DHCNMG.HR.MgNurTrainingI("Date",year)) q:year=""  d
	.s Ward="" f  s Ward=$o(^DHCNMG.HR.MgNurTrainingI("Date",year,Ward)) q:Ward=""  d
	..q:((ward'="")&&($tr(Ward," ","")'=ward))
	..s Nurse="" f  s Nurse=$o(^DHCNMG.HR.MgNurTrainingI("Date",year,Ward,Nurse)) q:Nurse=""  d
	...s RowID="" f  s RowID=$o(^DHCNMG.HR.MgNurTrainingI("Date",year,Ward,Nurse,RowID)) q:RowID=""  d
	....s obj=##class(DHCNMG.HR.MgNurTraining).%OpenId(RowID)
	....q:'$IsObject(obj)
	....s nurseName=obj.NurseID.PerName
	....s trainDep=""
	....i obj.TrainDep'="" d
	.....s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(obj.TrainDep)
	.....q:'$IsObject(wardObj)
	.....s trainDep=wardObj.WardDesc
	....s trainStDate=""
	....;王鹏飞
	....q:(obj.TrainStDate'="")&&(stDate'="")&&(stDate>obj.TrainStDate)
	....i obj.TrainStDate'="" s trainStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.TrainStDate)
	....s trainEndDate=""
	....;王鹏飞
	....q:(obj.TrainEndDate'="")&&(endDate'="")&&(endDate<obj.TrainEndDate)
	....i obj.TrainEndDate'="" s trainEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.TrainEndDate)
	....s trainSubject=""
	....i obj.TrainSubject'="" d
	.....s trainSubject=##class(web.NurMgPersonComm).GetCommCode(obj.TrainSubject)
	....s trainHospital=obj.TrainHospital
	....s trainLoc=""
	....i obj.TrainLoc'="" d
	.....s locObj=##class(DHCNMG.DB.MgWard).%OpenId(obj.TrainLoc)
	.....q:'$IsObject(locObj)
	.....s trainLoc=locObj.WardDesc
	....s NurseAge=""
	....s age=##class(web.NurMgVueComm).CalAge($zd(obj.NurseID.PerBirthday,3),$zd(obj.CreateDate,3)) //18Y 1M 1D18Y 1M 1D
	....i age'="" s NurseAge=$p(age,"Y")
	....s TrainAcade=""
	....i obj.TrainAcade'="" s TrainAcade=##class(web.NurMgPersonComm).GetCommCode(obj.TrainAcade)
	....s TrainDegree=""
	....i obj.TrainDegree'="" s TrainDegree=##class(web.NurMgPersonComm).GetCommCode(obj.TrainDegree)
	....s TrainSchool=""
	....i obj.TrainSchool'="" s TrainSchool=##class(web.NurMgPersonComm).GetCommCode(obj.TrainSchool)
	....s ret="nurseName|"_nurseName_"^trainDep|"_trainDep_"^trainStDate|"_trainStDate_"^trainEndDate|"_trainEndDate_"^trainSubject|"_trainSubject_"^trainHospital|"_trainHospital_"^trainLoc|"_trainLoc_"^RowID|"_RowID_"^nurseAge|"_NurseAge_"^trainAcade|"_TrainAcade_"^trainDegree|"_TrainDegree_"^trainSchool|"_TrainSchool
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
	s ret=""
	s sort="" f  s sort=$o(^DHCNMG.DB.MgWardI("Sort",sort)) q:sort=""  d
	.s rw="" f  s rw=$o(^DHCNMG.DB.MgWardI("Sort",sort,rw)) q:rw=""  d
	..s obj=##class(DHCNMG.DB.MgWard).%OpenId(rw)
	..q:'$IsObject(obj)
	..s wardDesc=obj.WardDesc
	..s wardCode=obj.WardCode
	..s wardDescSpell=##class(ext.util.String).ToChineseSpell(wardDesc)
	..s ret="WardDesc|"_wardDesc_"^WardCode|"_wardCode_"^rw|"_rw_"^wardDescSpell|"_wardDescSpell
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
/// 
Query FindAllLocs(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindAllLocsExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s code="" f  s code=$o(^DHCNMG.DB.MgWardLocI("Code",code)) q:code=""  d
	.s rw="" f  s rw=$o(^DHCNMG.DB.MgWardLocI("Code",code,rw)) q:rw=""  d
	..s obj=##class(DHCNMG.DB.MgWardLoc).%OpenId(rw)
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
ClassMethod GetOutTrainData(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.HR.MgNurTraining).%OpenId(id)
	q:'$IsObject(obj) ""
	s NurseName=obj.NurseID.PerName
    s NurseSex=obj.NurseID.PerSexDR
    s NurseAge=""
    i obj.NurseID.PerBirthday'="" d
    .s Age=##class(web.NurMgVueComm).CalAge($zd(obj.NurseID.PerBirthday,3),$zd(+$H,3))
    .s NurseAge=$p(Age,"Y")
    s NurseWard=obj.TrainDep
    s NurseAcade=obj.TrainAcade
    s NurseDegree=obj.TrainDegree
    s NurseHireDuty=obj.TrainHireDuty
    s NursePostDuty=obj.TrainPostDuty
    s NursePhone=obj.NurseID.PerPhone
    s TrainHospital=obj.TrainHospital
    s TrainLoc=obj.TrainLoc
    s TrainSpecial=obj.TrainSpecial
    s TrainTarget=obj.TrainTarget
    s TrainStDate=""
    i obj.TrainStDate'="" s TrainStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.TrainStDate)
    s TrainEndDate=""
    i obj.TrainEndDate'="" s TrainEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.TrainEndDate)
	w "{""NurseName"":"""_NurseName_""",""NurseSex"":"""_NurseSex_""",""NurseAge"":"""_NurseAge_""",""NurseWard"":"""
	_NurseWard_""",""NurseAcade"":"""_NurseAcade_""",""NurseDegree"":"""_NurseDegree_""",""NurseHireDuty"":"""_NurseHireDuty
	_""",""NursePostDuty"":"""_NursePostDuty_""",""NursePhone"":"""_NursePhone_""",""TrainHospital"":"""_TrainHospital
	_""",""TrainLoc"":"""_TrainLoc_""",""TrainSpecial"":"""_TrainSpecial_""",""TrainTarget"":"""_TrainTarget
	_""",""TrainStDate"":"""_TrainStDate_""",""TrainEndDate"":"""_TrainEndDate_""",""RowID"":"""_id_"""}"
	q ""
}

ClassMethod SaveOutTrainPlan(parr As %String) As %String
{
	s tmp=""
	s a=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	q:id="" 0
	s obj=##class(DHCNMG.HR.MgNurTraining).%OpenId(id)
	q:'$IsObject(obj) 0
	s obj.TrainAcade=$tr($g(tmp("NurseAcade"))," ","")
	s obj.TrainDegree=$tr($g(tmp("NurseDegree"))," ","")
	s obj.TrainHireDuty=$tr($g(tmp("NurseHireDuty"))," ","")
	s obj.TrainPostDuty=$tr($g(tmp("NursePostDuty"))," ","")
	s obj.TrainHospital=$tr($g(tmp("TrainHospital"))," ","")
	s obj.TrainLoc=$tr($g(tmp("TrainLoc"))," ","")
	s obj.TrainSpecial=$tr($g(tmp("TrainSpecial"))," ","")
	i $tr($g(tmp("TrainStDate"))," ","")'="" s obj.TrainStDate=$zdh($tr($g(tmp("TrainStDate"))," ",""),3)
	i $tr($g(tmp("TrainEndDate"))," ","")'="" s obj.TrainEndDate=$zdh($tr($g(tmp("TrainEndDate"))," ",""),3)
	s obj.TrainTarget=$tr($replace(tmp("TrainTarget"),$c(10),"")," ","")
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

}
