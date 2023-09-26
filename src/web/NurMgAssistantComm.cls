/// 
/// 
/// 学员助护公共类
Class web.NurMgAssistantComm Extends %RegisteredObject
{

/// Creator:gzj
/// Date:2018-11-17
/// Description:保存学员及助护信息
/// Table:
/// Input:
/// Output:
/// Return:
/// Other:
ClassMethod SaveAssistantData(parr As %String) As %String
{
		s tmp=""
		d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
		s id=$g(tmp("RowID"))
		s cardId=$zcvt($tr($g(tmp("PerCardId"))," ",""),"U")
		s rw=$o(^DHCNMG.HR.MgPersonsI("card"," "_cardId,""))
		q:((rw'="")&&(id="")) "身份证号已经存在"
		s PerNo=$zcvt($tr($g(tmp("PerNo"))," ",""),"U")
		s Row=$o(^DHCNMG.HR.MgPersonsI("PerNo"," "_PerNo,""))
		q:((Row'="")&&(id="")) "编号已经存在"
		i id="" s obj=##class(DHCNMG.HR.MgPersons).%New()
		e  s obj=##class(DHCNMG.HR.MgPersons).%OpenId(id)
		s obj.PerName=$zcvt($tr($g(tmp("PerName"))," ",""),"U")
		s obj.PerSexDR=$zcvt($tr($g(tmp("PerSexDR"))," ",""),"U")
		s obj.PerTypeDR=$zcvt($tr($g(tmp("PerType"))," ",""),"U")
		s obj.PerNo=$zcvt($tr($g(tmp("PerNo"))," ",""),"U")
		s obj.PerCardId=$zcvt($tr($g(tmp("PerCardId"))," ",""),"U")
		s birtday=$E($zcvt($tr($g(tmp("PerCardId"))," ",""),"U"),7,10)_"-"_$E($zcvt($tr($g(tmp("PerCardId"))," ",""),"U"),11,12)_"-"_$E($zcvt($tr($g(tmp("PerCardId"))," ",""),"U"),13,14)
		i $l(birtday,"-")=3 s obj.PerBirthday=$zdh(birtday,3)
		i $tr($g(tmp("PerComeDate"))," ","")'="" s obj.PerComeDate=$zdh($tr($g(tmp("PerComeDate"))," ",""),3)
		s obj.PerNation=$tr($g(tmp("PerNation"))," ","")
		s obj.PerNativePlace=$tr($g(tmp("PerNativePlace"))," ","")
		s obj.PerPolitical=$tr($g(tmp("PerPolitical"))," ","")
		s obj.PerMarriage=$tr($g(tmp("PerMarriage"))," ","")
		s obj.PerHeight=$tr($g(tmp("PerHeight"))," ","")
		s obj.PerWeight=$tr($g(tmp("PerWeight"))," ","")
		s obj.PerContact=$tr($g(tmp("PerContact"))," ","")
		s obj.PerPhone=$tr($g(tmp("PerPhone"))," ","")
		s obj.PerAddress=$tr($g(tmp("PerAddress"))," ","")
		s obj.PerEspecially=$tr($g(tmp("PerEspecially"))," ","")
		i $g(tmp("PerEspecially"))'="" s obj.PerIsEspecially=1
		e  s obj.PerIsEspecially=""
		s obj.PerCareType="N"
		s obj.PerPassword="UUUUUU&&&&&&"
		s obj.PerStatus="17||1"
		s obj.PerYear=$p($g(tmp("PerComeDate")),"-",1)
		s obj.PerDepDR=$tr($g(tmp("PerDepDR"))," ","")
		i $tr($g(tmp("PerDepDate"))," ","")'="" s obj.PerDepDate=$zdh($tr($g(tmp("PerDepDate"))," ",""),3)
		s obj.PerContactPhone=$tr($g(tmp("PerContactPhone"))," ","")
		s sc=obj.%Save()
		i sc=1
		{
			s transRowID=$O(^DHCNMG.HR.MgTransDepI("Current"," Y"," "_obj.%Id(),""))
			i transRowID="" d
			.i obj.PerDepDate="" s perdepdate=$zd(obj.PerComeDate,3) ;s perdepdate=$zd(+$h,3)
			.s TransFlag=##class(web.NurMgPersonComm).SaveTransData("^"_obj.%Id()_"^"_obj.PerDepDR_"^"_$zd(obj.PerDepDate,3)_"^"_$zt($P($H,",",2),1)_"^Y^^^L")	
		}
		q $$$ISOK(sc)
}

/// Creator:
/// Description:查询学员、助护信息列表
/// Date:2018-11-18
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgAssistantComm","FindAssistantList","T","")
Query FindAssistantList(type As %String, parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindAssistantListExecute(ByRef qHandle As %Binary, type As %String, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s stDate=$p(parr,"^",1)
	s endDate=$p(parr,"^",2)
	i stDate'="" s stDate=$zdh(stDate,3)
	i endDate'="" s endDate=$zdh(endDate,3)
	s ward=$p(parr,"^",3)
	s nurse=$p(parr,"^",4)
	s RowID="" f  s RowID=$o(^DHCNMG.HR.MgPersonsI("type"," "_type,RowID)) q:RowID=""  d
	.s obj=##class(DHCNMG.HR.MgPersons).%OpenId(RowID)
	.q:'$IsObject(obj)
	.q:((ward'="")&&(obj.PerDepDR'=ward))
	.s PerName=obj.PerName
	.q:((nurse'="")&&((obj.PerName_obj.PerNo)'[$zcvt($tr(nurse," ",""),"U")))
    .s PerSexDR=""
    .i obj.PerSexDR'="" s PerSexDR=##class(web.NurMgPersonComm).GetCommCode(obj.PerSexDR)
    .s PerType=obj.PerTypeDR
    .s PerTypeDesc=""
    .i PerType="T" s PerTypeDesc="学员"
    .e  i PerType="A" s PerTypeDesc="助护"
    .s PerNo=obj.PerNo
    .s PerCardId=obj.PerCardId
    .s PerComeDate=""
    .i obj.PerComeDate'="" s PerComeDate=$zd(obj.PerComeDate,3)
    .q:((stDate'="")&&(obj.PerComeDate'="")&&(obj.PerComeDate<stDate))
    .q:((endDate'="")&&(obj.PerComeDate'="")&&(obj.PerComeDate>endDate))
    .s PerNation=""
    .i obj.PerNation'="" s PerNation=##class(web.NurMgPersonComm).GetCommCode(obj.PerNation)
    .s PerNativePlace=obj.PerNativePlace
    .s PerPolitical=""
    .i obj.PerPolitical'="" s PerPolitical=##class(web.NurMgPersonComm).GetCommCode(obj.PerPolitical)
    .s PerMarriage=""
    .i obj.PerMarriage'="" s PerMarriage=##class(web.NurMgPersonComm).GetCommCode(obj.PerMarriage)
    .s PerHeight=obj.PerHeight
    .s PerWeight=obj.PerWeight
    .s PerContact=obj.PerContact
    .s PerPhone=obj.PerPhone
    .s PerAddress=obj.PerAddress
    .s PerEspecially=obj.PerEspecially
    .q:obj.PerStatus'="17||1"
    .s PerDep="",PerDepDR=""
    .i obj.PerDepDR'="" d
    ..s PerDepDR=obj.PerDepDR
    ..s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(obj.PerDepDR)
    ..q:'$IsObject(wardObj)
    ..s PerDep=wardObj.WardDesc
    .s PerDepDate=""
    .i obj.PerDepDate'="" s PerDepDate=$zd(obj.PerDepDate,3)
    .s PerContactPhone=obj.PerContactPhone
    .s ret="PerName|"_PerName_"^PerSexDR|"_PerSexDR_"^PerType|"_PerType_"^PerNo|"_PerNo_"^PerCardId|"_PerCardId_"^PerComeDate|"_PerComeDate_"^PerNation|"_PerNation_"^PerNativePlace|"_PerNativePlace_"^PerPolitical|"_PerPolitical_"^PerMarriage|"_PerMarriage_"^PerHeight|"_PerHeight_"^PerWeight|"_PerWeight_"^PerContact|"_PerContact_"^PerPhone|"_PerPhone_"^PerAddress|"_PerAddress_"^PerEspecially|"_PerEspecially_"^RowID|"_RowID_"^PerDep|"_PerDep_"^PerDepDR|"_PerDepDR_"^PerDepDate|"_PerDepDate_"^PerTypeDesc|"_PerTypeDesc_"^PerContactPhone|"_PerContactPhone
	.do OutputAssistant
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputAssistant
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAssistantListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAssistantListExecute ]
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

ClassMethod FindAssistantListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAssistantListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Date:2018-11-18
/// Description:获取学员助护个人记录
/// 
ClassMethod GetAssistantData(id As %String) As %String
{
	q:id="" ""
	s ret=""
	s obj=##class(DHCNMG.HR.MgPersons).%OpenId(id)
	q:'$IsObject(obj) ""
	s PerName=obj.PerName
    s PerSexDR=obj.PerSexDR
    s PerType=obj.PerTypeDR
    s PerNo=obj.PerNo
    s PerCardId=obj.PerCardId
    s PerComeDate=""
    i obj.PerComeDate'="" s PerComeDate=$zd(obj.PerComeDate,3)
    s PerNation=obj.PerNation
    s PerNativePlace=obj.PerNativePlace
    s PerPolitical=obj.PerPolitical
    s PerMarriage=obj.PerMarriage
    s PerHeight=obj.PerHeight
    s PerWeight=obj.PerWeight
    s PerContact=obj.PerContact
    s PerPhone=obj.PerPhone
    s PerAddress=obj.PerAddress
    s PerEspecially=obj.PerEspecially
    s PerDepDR=obj.PerDepDR
    s PerDepDate=""
    i obj.PerDepDate'="" s PerDepDate=$zd(obj.PerDepDate,3)
    s PerContactPhone=obj.PerContactPhone
    s ret="PerName|"_PerName_"^PerSexDR|"_PerSexDR_"^PerType|"_PerType_"^PerNo|"_PerNo
    _"^PerCardId|"_PerCardId_"^PerComeDate|"_PerComeDate_"^PerNation|"_PerNation
    _"^PerNativePlace|"_PerNativePlace_"^PerPolitical|"_PerPolitical_"^PerMarriage|"_PerMarriage
    _"^PerHeight|"_PerHeight_"^PerWeight|"_PerWeight_"^PerContact|"_PerContact_"^PerPhone|"_PerPhone
    _"^PerAddress|"_PerAddress_"^PerEspecially|"_PerEspecially_"^PerDepDR|"_PerDepDR_"^PerDepDate|"_PerDepDate_"^RowID|"_id_"^PerContactPhone|"_PerContactPhone
    q ret
}

ClassMethod SaveAssistantTrans(parr As %String, nurses As %String, type As %String, user As %String) As %String
{
	q:((parr="")!(nurses="")) 0
	s id=$tr($p(parr,"^",3)," ","")
	s flag=1
	ts
	i id="" s obj=##class(DHCNMG.Train.MgNurTransPlan).%New()
	e  s obj=##class(DHCNMG.Train.MgNurTransPlan).%OpenId(id)
	s obj.TransType=$tr($p(parr,"^",4)," ","")
	i $tr($p(parr,"^",1)," ","")'="" s obj.TransDate=$zdh($tr($p(parr,"^",1)," ",""),3)
	s obj.TransFlag=$tr(type," ","")
	s obj.TransWard=$tr($p(parr,"^",2)," ","")
	s obj.CreateUser=$tr(user," ","")
	s sc=obj.%Save()
	s flag=($$$ISOK(sc)&&flag)
	
	i (flag=1)
	{
		s len=$l(nurses,"!")
		s delRw="" f  s delRw=$o(^DHCNMG.Train.MgNurTransPlanSubD(obj.%Id(),delRw)) q:delRw=""  d
		.s delObj=##class(DHCNMG.Train.MgNurTransPlanSub).%OpenId(obj.%Id()_"||"_delRw)
		.q:'$IsObject(delObj)
		.s delsc=delObj.%DeleteId(obj.%Id()_"||"_delRw)
		.s flag=($$$ISOK(delsc)&&flag)
		f i=1:1:len
		{
			s itm=$p(nurses,"!",i)
			i itm="" continue
			s nurse=$p(itm,"^",1)
			s ward=$p(itm,"^",2)
			i ((nurse="")!(ward="")) continue
			s rw=$o(^DHCNMG.Train.MgNurTransPlanSubI("nurse",obj.%Id()," "_nurse,""))
			i rw="" d
			.s SubObj=##class(DHCNMG.Train.MgNurTransPlanSub).%New()
			.s SubObj.Parref=##class(DHCNMG.Train.MgNurTransPlan).%OpenId(obj.%Id())
			e  s SubObj=##class(DHCNMG.Train.MgNurTransPlanSub).%OpenId(obj.%Id()_"||"_rw)
			s SubObj.TransDepDR=ward
			s SubObj.TransNurse=nurse
			s SubSc=SubObj.%Save()
			s flag=($$$ISOK(SubSc)&&flag)
		}
		i flag=1 tc
		e  tro
	}
	else
	{
		tro
	}
	q flag
}

/// 
/// Date:2019-08-05
/// Description:检查助护学员转科日期之后是否有排班
ClassMethod CheckNurseArg(ids As %String, date As %String) As %String
{
	i date="" s date=+$h
	e  s date=$zdh(date,3)
	s len=$l(ids,"^")
	s ret=""
	f i=1:1:len
	{
		s id=$p(ids,"^",i)
		i id="" continue
		s stdate=date-1 f  s stdate=$o(^DHCNMG.Arg.MgArrangeSubI("PerDate",id,stdate)) q:stdate=""  d
		.s rw="" f  s rw=$o(^DHCNMG.Arg.MgArrangeSubI("PerDate",id,stdate,rw)) q:rw=""  d
		..s obj=##class(DHCNMG.HR.MgPersons).%OpenId(id)
		..q:'$IsObject(obj)
		..i ret="" s ret=obj.PerName
		..e  s ret=ret_","_obj.PerName
	}
	q ret
}

/// Creator:
/// Description:查询学员、助护转科列表
/// Date:2018-11-20
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgAssistantComm","FindAssTranList","T","")
Query FindAssTranList(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindAssTranListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s type=$p(parr,"^",1)
	s stDate=$p(parr,"^",2)
	i stDate'="" s stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",3)
	i endDate'="" s endDate=$zdh(endDate,3)
	i ((type="")!(stDate="")!(endDate="")) Set qHandle=$lb(0,repid,0) Quit $$$OK
	f date=endDate:-1:stDate
	{
		
		s ward="" f  s ward=$o(^DHCNMG.Train.MgNurTransPlanI("Type"," "_type,date,ward)) q:ward=""  d
		.s RowID="" f  s RowID=$o(^DHCNMG.Train.MgNurTransPlanI("Type"," "_type,date,ward,RowID)) q:RowID=""  d
		..s obj=##class(DHCNMG.Train.MgNurTransPlan).%OpenId(RowID)
		..s TransWard="" //转入病区
		..i obj.TransWard'="" d
		...s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(obj.TransWard)
		...q:'$IsObject(wardObj)
		...s TransWard=wardObj.WardDesc
		..i obj.TransDate'="" s TransDate=$zd(obj.TransDate,3)
		..e  s TransDate=""
		..s FlagCode=obj.TransFlag
		..i obj.TransFlag="N" s TransFlag="保存"
		..e  i obj.TransFlag="Y" s TransFlag="提交"
		..e  i obj.TransFlag="A" s TransFlag="审核"
		..e  i obj.TransFlag="B" s TransFlag="驳回"
		..i obj.CreateDate'="" s CreateDate=$zd(obj.CreateDate,3)
		..e  s CreateDate=""
		..s CreateUser="",CreateUserID=""
		..s CreateUserID=obj.CreateUser
		..i obj.CreateUser=0 s CreateUser="管理员"
		..e  i obj.CreateUser'=0 d
		...s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.CreateUser)
		...q:'$IsObject(perObj)
		...s CreateUser=perObj.PerName
		..s nurse=""
		..s subRw="" f  s subRw=$o(^DHCNMG.Train.MgNurTransPlanSubD(RowID,subRw)) q:subRw=""  d
		...s subObj=##class(DHCNMG.Train.MgNurTransPlanSub).%OpenId(RowID_"||"_subRw)
		...q:'$IsObject(subObj)
		...s NurseID=subObj.TransNurse
		...s NurseName=""
		...i NurseID'="" d
		....s nurObj=##class(DHCNMG.HR.MgPersons).%OpenId(NurseID)
		....q:'$IsObject(nurObj)
		....s NurseName=nurObj.PerName
		....s NurseWard=""
		...s DepDR=subObj.TransDepDR
		...i DepDR'="" d
		....s depObj=##class(DHCNMG.DB.MgWard).%OpenId(DepDR)
		....q:'$IsObject(depObj)
		....s NurseWard=depObj.WardDesc
		....i nurse="" s nurse=NurseWard_"!"_NurseName
		....e  s nurse=nurse_","_NurseWard_"!"_NurseName
		..s ret="TransWard|"_TransWard_"^TransDate|"_TransDate_"^TransFlag|"_TransFlag_"^CreateDate|"_CreateDate_"^CreateUserID|"_CreateUserID_"^CreateUser|"_CreateUser_"^Nurses|"_nurse_"^RowID|"_RowID_"^FlagCode|"_FlagCode
		..do OutputTranList
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputTranList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAssTranListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAssTranListExecute ]
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

ClassMethod FindAssTranListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAssTranListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Date:2018-11-20
/// Description:获取转科记录
ClassMethod GetAssTranData(id As %String) As %String
{
	s obj=##class(DHCNMG.Train.MgNurTransPlan).%OpenId(id)
	q:'$IsObject(obj) "[]"
	w "["
	s TransDate="" 
	i obj.TransDate'="" s TransDate=$zd(obj.TransDate,3)
	s TransWard=obj.TransWard
	w "{""TransDate"":"""_TransDate_""",""TransWard"":"""_TransWard_""",""RowID"":"""_id_""",""Children"":["
	s count=1
	s rw="" f  s rw=$o(^DHCNMG.Train.MgNurTransPlanSubD(id,rw)) q:rw=""  d
	.s subObj=##class(DHCNMG.Train.MgNurTransPlanSub).%OpenId(id_"||"_rw)
	.q:'$IsObject(subObj)
	.s TransNurse=subObj.TransNurse //人员ID
	.s PerName="",PerNo=""
	.i TransNurse'="" d
	..s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(TransNurse)
	..q:'$IsObject(perObj)
	..s PerName=perObj.PerName
	..s PerNo=perObj.PerNo
	.s PerDep="",PerDepDR=""
	.i subObj.TransDepDR'="" d
	..s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(subObj.TransDepDR)
	..q:'$IsObject(wardObj)
	..s PerDep=wardObj.WardDesc
	..s PerDepDR=subObj.TransDepDR
	.i count=1 w "{""PerNo"":"""_PerNo_""",""PerName"":"""_PerName_""",""PerDep"":"""_PerDep_""",""PerDepDR"":"""_PerDepDR_""",""RowID"":"""_TransNurse_"""}"
	.e  w ",{""PerNo"":"""_PerNo_""",""PerName"":"""_PerName_""",""PerDep"":"""_PerDep_""",""PerDepDR"":"""_PerDepDR_""",""RowID"":"""_TransNurse_"""}"
	.s count=count+1
	w "]}]"
	q ""
}

/// Creator:gzj
/// Date:2018-11-20
/// Description:删除转科记录
/// Table:
/// Input:
/// Output:
/// Return:
/// Other:
ClassMethod DeleteTransRec(id As %String) As %String
{
	q:id="" 0
	s flag=1
	s obj=##class(DHCNMG.Train.MgNurTransPlan).%OpenId(id)
	q:'$IsObject(obj) 0
	ts
	s subRw="" f  s subRw=$o(^DHCNMG.Train.MgNurTransPlanSubD(id,subRw)) q:subRw=""  d
	.s subObj=##class(DHCNMG.Train.MgNurTransPlanSub).%OpenId(id_"||"_subRw)
	.q:'$IsObject(subObj)
	.s sub=subObj.%DeleteId(id_"||"_subRw)
	.s flag=($$$ISOK(sub)&&flag)
	s sc=obj.%DeleteId(id)
	s flag=($$$ISOK(sc)&&flag)
	i flag=1
	{
		tc
	}
	else
	{
		tro
	}
	q flag
}

ClassMethod AuditTransRec(parr As %String, Opinion As %String, type As %String) As %String
{
	q:parr="" 0
	s len=$l(parr,",")
	
	f i=1:1:len
	{
		s id=$p(parr,",",i)
		i id="" continue
		s obj=##class(DHCNMG.Train.MgNurTransPlan).%OpenId(id)
		q:'$IsObject(obj)
		s flag=1
		s obj.TransFlag=type
		s obj.AuditOpinion=$tr(Opinion," ","")
		s obj.AuditDate=+$h
		TS
		s sc=obj.%Save()
		s flag=($$$ISOK(sc)&&flag)
		i ((flag=1)&&(type="A"))
		{
			s rw="" f  s rw=$o(^DHCNMG.Train.MgNurTransPlanSubD(id,rw)) q:rw=""  d
			.s subobj=##class(DHCNMG.Train.MgNurTransPlanSub).%OpenId(id_"||"_rw)
			.q:'$IsObject(subobj)
			.i obj.TransDate<=(+$H) d
			..s parm="^"_subobj.TransNurse_"^"_obj.TransWard_"^"_$zd(obj.TransDate,3)_"^0^Y^^^L"
			..;d ##class(web.NurMgPersonComm).SaveTransData(parm)
			..;d ##class(web.NurMgSysTaskComm).ChangePerDepInfo(subobj.TransNurse,obj.TransWard,obj.TransDate)
			..s transRw=$o(^DHCNMG.HR.MgTransDepI("Current"," Y"," "_subobj.TransNurse,""))
			..i transRw="" d
			...s TransObj=##class(DHCNMG.HR.MgTransDep).%New()
			...s TransObj.PerDr=subobj.TransNurse
			...s TransObj.PerDepart=obj.TransWard
			...s TransObj.PerTranStDate=obj.TransDate
			...s TransObj.PerTranStTime=$zth("00:00:00",1)
			...s TransObj.PerTranCurrent="Y"
			...s TransObj.PerTransType="L"
		 	...s TransSc=TransObj.%Save()
		 	...s flag=(flag&&$$$ISOK(TransSc))
		 	...i flag=1 d
		 	....s PerObj=##class(DHCNMG.HR.MgPersons).%OpenId(subobj.TransNurse)
			....s PerObj.PerDepDR=obj.TransWard
			....s PerObj.PerDepDate=obj.TransDate
			....s PerSc=PerObj.%Save()
			....s flag=(flag&&$$$ISOK(PerSc))
			..e  d
			...s OldTransObj=##class(DHCNMG.HR.MgTransDep).%OpenId(transRw)
			...s OldTransObj.PerTranEndDate=obj.TransDate
			...s OldTransObj.PerTranEndTime=$zth("00:00:00",1)
			...s OldTransObj.PerTranCurrent="N"
			...s OldTransObj.PerTransType="L"
			...s OldTransSc=OldTransObj.%Save()
			...s flag=flag&&$$$ISOK(OldTransSc)
			...i flag=1 d
			....s NewTransObj=##class(DHCNMG.HR.MgTransDep).%New()
			....s NewTransObj.PerDr=subobj.TransNurse
			....s NewTransObj.PerDepart=obj.TransWard
			....s NewTransObj.PerTranStDate=obj.TransDate
			....s NewTransObj.PerTranStTime=$p($H,",",2)
			....s NewTransObj.PerTranCurrent="Y"
			....s NewTransObj.PerTransType="L"
			....s NewTransSc=NewTransObj.%Save()
			....s flag=(flag&&$$$ISOK(NewTransSc))
			....i flag=1 d
			.....s PerObj=##class(DHCNMG.HR.MgPersons).%OpenId(subobj.TransNurse)
			.....s PerObj.PerDepDR=obj.TransWard
			.....s PerObj.PerDepDate=obj.TransDate
			.....s PerSc=PerObj.%Save()
			.....s flag=(flag&&$$$ISOK(PerSc))
			.e  d
			..s parm="^"_subobj.TransNurse_"^"_obj.TransWard_"^"_$zd(obj.TransDate,3)_"^0^P^^^L"
			..s objNew=##class(DHCNMG.HR.MgTransDep).%New()
			..s objNew.PerDr=subobj.TransNurse
			..s objNew.PerDepart=obj.TransWard
			..s objNew.PerTranStDate=obj.TransDate
			..s objNew.PerTranStTime=$zth("08:00:00",2)
			..s objNew.PerTranCurrent="P"
			..s objNew.PerTransType="L"
			..d objNew.%Save()
		}
		
		i flag=1 tc
		e  tro
	}
	q flag
}

ClassMethod ImportAssistant(parr As %String) As %String
{
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s PerCardId=$zcvt($tr($g(tmp("PerCardId"))," ",""),"U") //取得身份证号码
	q:PerCardId="" ""
	s rowid=$O(^DHCNMG.HR.MgPersonsI("card"," "_PerCardId,""))
	s saveIndex=$tr($g(tmp("saveIndex"))," ","")
	i rowid="" s obj=##class(DHCNMG.HR.MgPersons).%New()
	e  s obj=##class(DHCNMG.HR.MgPersons).%OpenId(rowid)
	q:((rowid'="")&&((obj.PerTypeDR'="T")&&(obj.PerTypeDR'="A"))) saveIndex
	s obj.PerName=$tr($g(tmp("PerName"))," ","")
	i ($tr($g(tmp("PerType"))," ","")'="")&&($tr($g(tmp("PerType"))," ","")="学员") s obj.PerTypeDR="T"
	e  i ($tr($g(tmp("PerType"))," ","")'="")&&($tr($g(tmp("PerType"))," ","")="助护") s obj.PerTypeDR="A"
	s obj.PerNo=$zcvt($tr($g(tmp("PerNo"))," ",""),"U")
	s obj.PerCardId=PerCardId
	i $g(tmp("PerDepDR"))'="" d
	.s warddr=##class(web.NurMgImportDBData).GetDBWard($zcvt($tr($g(tmp("PerDepDR"))," ",""),"U")) //病区
	.i warddr'="" s obj.PerDepDR=warddr
	.e  s obj.PerDepDR=""
	i (($g(tmp("PerDepDate"))'="")&&($l($g(tmp("PerDepDate")),"-")=3)) s obj.PerDepDate=$zdh($tr($g(tmp("PerDepDate"))," ",""),3)
	e  s obj.PerDepDate="" //进科日期
	i (($tr($g(tmp("PerComeDate"))," ","")'="")&&($l($tr($g(tmp("PerComeDate"))," ",""),"-")=3)) s obj.PerComeDate=$zdh($tr($g(tmp("PerComeDate"))," ",""),3)
	e  s obj.PerComeDate="" //来院日期
	i $g(tmp("PerNation"))'="" d
	.s nativeId=##class(web.NurMgImportDBData).GetSetCode("民族",$zcvt($tr($g(tmp("PerNation"))," ",""),"U"))
	.i nativeId'="" s obj.PerNation=nativeId
	.e  s obj.PerNation=""
	e  s obj.PerNation=""
	i $tr($g(tmp("PerNativePlace"))," ","")'="" s obj.PerNativePlace=$tr($g(tmp("PerNativePlace"))," ","")
	e  s obj.PerNativePlace=""
	i $tr($g(tmp("PerPolitical"))," ","")'="" d
	.s politicaldr=##class(web.NurMgImportDBData).GetSetCode("政治面貌",$zcvt($tr($g(tmp("PerPolitical"))," ",""),"U")) //政治面貌
	.i politicaldr'="" s obj.PerPolitical=politicaldr
	.e  s obj.PerPolitical=""
	e  s obj.PerPolitical=""
	i $tr($g(tmp("PerMarriage"))," ","")'="" d
	.s marriagedr=##class(web.NurMgImportDBData).GetSetCode("婚姻",$zcvt($tr($g(tmp("PerMarriage"))," ",""),"U")) //婚姻
	.i marriagedr'="" s obj.PerMarriage=marriagedr
	.e  s obj.PerMarriage=""
	s obj.PerHeight=$tr($g(tmp("PerHeight"))," ","")
	s obj.PerWeight=$tr($g(tmp("PerWeight"))," ","")
	s obj.PerPhone=$tr($g(tmp("PerPhone"))," ","")
	s obj.PerAddress=$tr($g(tmp("PerAddress"))," ","")
	s obj.PerContact=$tr($g(tmp("PerContact"))," ","")
	s obj.PerContactPhone=$tr($g(tmp("PerContactPhone"))," ","")
	;s obj.PerHobby=$tr($g(tmp("PerHobby"))," ","")
	s obj.PerEspecially=$tr($g(tmp("PerEspecially"))," ","")
	i $tr($g(tmp("PerEspecially"))," ","")'="" s obj.PerIsEspecially=1
	e  s obj.PerIsEspecially=""
	s obj.PerStatus="17||1"
	s obj.PerCareType="N"
	i $l(PerCardId)=18 d
	.s obj.PerBirthday=$zdh($E(PerCardId,7,10)_"-"_$E(PerCardId,11,12)_"-"_$e(PerCardId,13,14),3)
	.i $e(PerCardId,17,17)#2=0 s obj.PerSexDR="6||2"
	.e  i $e(PerCardId,17,17)#2=1 s obj.PerSexDR="6||1"
	i (($tr($g(tmp("PerComeDate"))," ","")'="")&&$l(($tr($g(tmp("PerComeDate"))," ","")),"-")=3) s obj.PerYear=$p($tr($g(tmp("PerComeDate"))," ",""),"-")
	s obj.PerPassword="UUUUUU&&&&&&"
	s sc=obj.%Save()
	i $$$ISOK(sc)=1
	{
		s parm="^"_obj.%Id()_"^"_obj.PerDepDR_"^"_$zd(obj.PerDepDate,3)_"^0^Y^^^L"
		s transRowID=$O(^DHCNMG.HR.MgTransDepI("Current"," Y"," "_obj.%Id(),""))
		i transRowID="" d
		.d ##class(web.NurMgPersonComm).SaveTransData(parm)
	}
	q saveIndex
}

/// Creator:gzj
/// Date:
/// Description:学员助护转正
/// 
ClassMethod ConvertType(parr As %String) As %String
{
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("id"))
	q:id="" "操作失败"
	s OperateType=$tr($g(tmp("OperateType"))," ","")
	q:OperateType="" "请选择转正类型"
	s OperateNo=$tr($g(tmp("OperateNo"))," ","")
	q:OperateNo="" "请填写编号"
	s TurnDate=$tr($g(tmp("TurnDate"))," ","")
	q:TurnDate="" "请填写转正日期"
	s obj=##class(DHCNMG.HR.MgPersons).%OpenId(id)
	q:'$IsObject(obj) "操作失败"
	s flag=1
	i OperateType'="N" d
	.s rw=$o(^DHCNMG.HR.MgPersonsI("Info"," "_OperateType," "_OperateNo,""))
	.s:rw'="" flag="编号已经存在"
	.q:rw'=""
	.s obj.PerTypeDR=OperateType
	.i OperateType="A" s obj.PerStuToAss=$zdh(TurnDate,3) //学员 转成助护的日期
	.i OperateType="T" s obj.PerAssToStu=$zdh(TurnDate,3) //助护转 学员 日期
	.s obj.PerNo=OperateNo
	.s sc=obj.%Save()
	.s flag=$$$ISOK(sc)
	e  d
	.s rw=$o(^DHCNMG.HR.MgPersonsI("PerID"," "_OperateNo,""))
	.s:rw'="" flag="工号已经存在"
	.q:rw'=""
	.s obj.PerTypeDR=OperateType
	.s NurseType=obj.PerTypeDR
	.i NurseType="A" s obj.PerAssToNurse=$zdh(TurnDate,3) //助护转正式
	.e  i NurseType="T" s obj.PerStuToNurse=$zdh(TurnDate,3) //学员转正式
	.s obj.PerID=OperateNo
	.s obj.PerComeDate=$zdh(TurnDate,3)
	.s obj.HISNO=OperateNo
	.TS
	.s sc=obj.%Save()
	.s flag=(flag&&$$$ISOK(sc))
	.i flag=1 d
	..s RoleObj=##class(DHCNMG.Set.MgRoleNurse).%New()
	..s RoleObj.Parref=##class(DHCNMG.Set.MgRoles).%OpenId(8)
	..s RoleObj.RoleNurse=id
	..s RoleObj.RoleStDate=$zdh(TurnDate,3)
	..s RoleSc=RoleObj.%Save()
	..s flag=(flag&&$$$ISOK(RoleSc))
	..i flag=1 d
	...s date="" f  s date=$o(^DHCNMG.HR.MgNurRoleI("date",$g(tmp("id")),date)) q:((date="")||(flag'=1))  d
	....s rowid="" f  s rowid=$O(^DHCNMG.HR.MgNurRoleI("date",$g(tmp("id")),date," 8",rowid)) q:((rowid="")||(flag'=1))  d
	.....s NurseObj=##class(DHCNMG.HR.MgNurRole).%OpenId(rowid)
	.....q:NurseObj.RoleEndDate'=""
	.....s NurseObj.RoleEndDate=$zdh(TurnDate,3)
	.....s NurseObjSc=NurseObj.%Save()
	.....s flag=(flag&&$$$ISOK(NurseObjSc))
	...s nurobj=##class(DHCNMG.HR.MgNurRole).%New()
	...s nurobj.RolePerDR=##class(DHCNMG.HR.MgPersons).%OpenId(id)
	...s nurobj.RoleID="8"
	...s nurobj.RoleStDate=$zdh(TurnDate,3)
	...s nurobjSc=nurobj.%Save()
	...s flag=(flag&&$$$ISOK(nurobjSc))
	.i flag=1 TC
	.e  tro
	
	q flag
}

/// Creator:
/// Description:查询学员、助护名单列表 离职的过滤掉
/// Date:2019-05-30
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgAssistantComm","FindAssistantNurse","T","")
Query FindAssistantNurse(type As %String, parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindAssistantNurseExecute(ByRef qHandle As %Binary, type As %String, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s nurse=$p(parr,"^",1)
	s RowID="" f  s RowID=$o(^DHCNMG.HR.MgPersonsI("type"," "_type,RowID)) q:RowID=""  d
	.s obj=##class(DHCNMG.HR.MgPersons).%OpenId(RowID)
	.q:'$IsObject(obj)
	.q:obj.PerStatus'="17||1"
	.s PerName=obj.PerName
	.q:((nurse'="")&&((obj.PerName_obj.PerNo)'[$zcvt($tr(nurse," ",""),"U")))
    .s PerSexDR=""
    .i obj.PerSexDR'="" s PerSexDR=##class(web.NurMgPersonComm).GetCommCode(obj.PerSexDR)
    .s PerType=obj.PerTypeDR
    .s PerTypeDesc=""
    .i PerType="T" s PerTypeDesc="学员"
    .e  i PerType="A" s PerTypeDesc="助护"
    .s PerNo=obj.PerNo
    .s PerDep=obj.PerDepDR
    .s PerDepDesc=""
    .i PerDep'="" d
    ..s WardObj=##class(DHCNMG.DB.MgWard).%OpenId(PerDep)
    ..q:'$IsObject(WardObj)
    ..s PerDepDesc=WardObj.WardDesc
    .s ret="PerName|"_PerName_"^PerNo|"_PerNo_"^PerSexDR|"_PerSexDR_"^PerTypeDesc|"_PerTypeDesc_"^PerType|"_PerType_"^RowID|"_RowID_"^PerDep|"_PerDep_"^PerDepDesc|"_PerDepDesc
    .
    .do AssistantNurse
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
AssistantNurse
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAssistantNurseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAssistantNurseExecute ]
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

ClassMethod FindAssistantNurseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAssistantNurseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Date:2019-06-05
/// Description:保存学员助护的离职信息
ClassMethod SaveAssistantLeave(parr As %String, user As %String) As %String
{
	s len=$l(parr,"^")
	s flag=1
	f i=1:1:len
	{
		s itm=$p(parr,"^",i)
		i itm="" continue
		s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(itm)
		i '$IsObject(perObj) continue
		s Rw=$o(^DHCNMG.HR.MgNurseResignI("ssid",itm,""))
		i Rw="" 
		{
			s obj=##class(DHCNMG.HR.MgNurseResign).%New()
			s obj.ResignName=##class(DHCNMG.HR.MgPersons).%OpenId(itm)
		}
		else  
		{
			s obj=##class(DHCNMG.HR.MgNurseResign).%OpenId(Rw)
		}
		s obj.ResignStatus="Y"
		s obj.ResignReStatus="E"
		s obj.ResignType=perObj.PerTypeDR
		s obj.ResignWard=perObj.PerDepDR
		s obj.ResignCreater=user
		s obj.CreateDate=+$h
		s sc=obj.%Save()
		s flag=($$$ISOK(sc)&&flag)	
	}
	q flag
}

/// 
/// 
/// Description:审核离职记录
ClassMethod AuditResign(id As %String, type As %String, status As %String, parr As %String) As %String
{
	q:id="" 0
	s flag=1
	s obj=##class(DHCNMG.HR.MgNurseResign).%OpenId(id)
	q:'$IsObject(obj) 0
	s obj.ResignStatus=status
	s obj.UpdateUser=$p(parr,"^",2)
	i (($p(parr,"^",3)'="")&&(status="A")) s obj.ResignDate=$zdh($p(parr,"^",3),3)
	s obj.ResignUpdate=+$H
	Ts
	s sc=obj.%Save()
	s flag=(flag&&$$$ISOK(sc))
	i status="A"
	{
		s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.ResignName.%Id())
		i $IsObject(perObj)
		{
			s perObj.PerStatus="17||3"
			s perObj.PerStateDate=obj.ResignDate
			s perSc=perObj.%Save()
			s flag=flag&&$$$ISOK(perSc)
		}
	}
	i flag=1 tc
	e  tro
	q flag
}

ClassMethod GetRowStatus(row As %String) As %String
{
	q:row="" 0
	s flag=0
	s obj=##class(DHCNMG.HR.MgNurseResign).%OpenId(row)
	q:'$IsObject(obj) 0
	s flag=obj.ResignStatus
	q flag
}

}
