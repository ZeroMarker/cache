/// Create Time: 20130901
/// 健康教育评估
Class web.DHCHlthEduAss Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 插入一条健康教育评估记录
/// Input:PatientId^教育日期^教育时间^健康教育个性化^项目^教育对象^教育时机^教育方法^效果评价^教育者^备注
/// Output:无
/// w ##class(web.DHCHlthEduAss).AddHlthEduAss("76^2012-12-21^09:10:00^入院^降压药^家属^首次宣教^口述/讨论^口述理解^陆玲君^hkjashdkjash")
ClassMethod AddHlthEduAss(HEAInfo As %String)
{
	q:HEAInfo=""
	set object = ##class(DHCMGNUR.DHCHlthEduAss).%New()
	s EpisodeID = $P(HEAInfo,"^",1) //PatientId
	set PAAdmObject = ##class(User.PAAdm).%OpenId(EpisodeID)
	set object.HEAPAPMDR = PAAdmObject
	set object.HEADate = $zdh($P(HEAInfo,"^",2),3)
	set ^TempXBL=$P(HEAInfo,"^",3)
	set object.HEATime = $zth($P(HEAInfo,"^",3),1)
	set ^TempXBL(1) = object.HEATime 
	set object.HEAIdvdNd = $P(HEAInfo,"^",4)
	set object.HEAProject = $P(HEAInfo,"^",5)
	set object.HEAObject = $P(HEAInfo,"^",6)
	set object.HEAOpportunity = $P(HEAInfo,"^",7)
	set object.HEAMethod = $P(HEAInfo,"^",8)
	set object.HEAEffectAss = $P(HEAInfo,"^",9)
	set SSUSRInitials = $P(HEAInfo,"^",10)
	//s ret = ##class(web.DHCNurHlthEduComm).GetPerson(SSUSRInitials)
	//s SSUserRowId=$P(ret,"|",1)
	set SSUserRowId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(SSUSRInitials),""))
	//$O(^SSU("SSUSR",0,"SSUSR_Initials","hs001",""))
	set SSUserObj = ##class(User.SSUser).%OpenId(SSUserRowId)
	set object.HEATeacher = SSUserObj
	set object.HEARemarks = $P(HEAInfo,"^",11)
	TStart
	S sc = object.%Save()
 	I $$$ISERR(sc)  ///If ($$$ISOK(sc))
	{
		TRollBack
		Do $System.Status.DisplayError(sc)
   		q "添加失败"
	}
	else
	{
		TCommit
		q "添加成功"
	}
	//q
}

/// 删除一条记录
/// Input:HEA_RowId
/// Output:无
/// w ##class(web.DHCHlthEduAss).DeleteHlthEduAss(1)
ClassMethod DeleteHlthEduAss(parr As %String)
{
	q:parr=""
	set HEARowId=$P(parr,"^",1)
	set HEAValid=$P(parr,"^",2)
	s object = ##class(DHCMGNUR.DHCHlthEduAss).%OpenId(HEARowId)
	//q:$d(^HEDUA(HEARowId))=0
	s object.HEAValid = HEAValid
	TStart
	s sc = object.%Save()
	i $$$ISERR(sc)  ///If ($$$ISOK(sc))
	{
		TRollBack
		Do $System.Status.DisplayError(sc)
   		q "Fail"
	}
	else
	{
		TCommit
		q "Success"
	}
}

/// 修改一条记录
/// Input:HEARowId^评估日期^评估时间^健康教育个性化^项目^教育对象^教育时机^教育方法^效果评价^教育者^备注
/// Output:无
/// w ##class(web.DHCHlthEduAss).UpdateHlthEduAss("2^62222^27777^出院^降压药^家属^再次宣教^口述/讨论^口述理解^陆玲君^jhasdj")
ClassMethod UpdateHlthEduAss(HEAInfo As %String)
{
	q:HEAInfo=""
	set HEARowId = $P(HEAInfo,"^",1)
	q:$d(^HEDUA(HEARowId))=0
	set object = ##class(DHCMGNUR.DHCHlthEduAss).%OpenId(HEARowId)
	set tempDate = $P(HEAInfo,"^",2)
	set object.HEADate = $zdh(tempDate,3)
	set tempTime = $P(HEAInfo,"^",3)
	set object.HEATime = $zth(tempTime,1)
	set object.HEAIdvdNd = $P(HEAInfo,"^",4)
	set object.HEAProject = $P(HEAInfo,"^",5)
	//set object.HEAProject = $P(HEAInfo,"^",5)
	set object.HEAObject = $P(HEAInfo,"^",6)
	set object.HEAOpportunity = $P(HEAInfo,"^",7)
	set object.HEAMethod = $P(HEAInfo,"^",8)
	set object.HEAEffectAss = $P(HEAInfo,"^",9)
	set SSUSRInitials = $P(HEAInfo,"^",10)
	set SSUserRowId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(SSUSRInitials),""))
	set SSUserObj = ##class(User.SSUser).%OpenId(SSUserRowId)
	set object.HEATeacher = SSUserObj
	set object.HEARemarks = $P(HEAInfo,"^",11)
	TStart
	S sc = object.%Save()
 	I $$$ISERR(sc)  ///If ($$$ISOK(sc))
	{
		TRollBack
		Do $System.Status.DisplayError(sc)
   		q "修改失败"
	}
	else
	{
		TCommit
		q "修改成功"
	}
	//q
}

/// 根据病人ID查询其健康教育评估
/// Input:PatientId
/// Output:评估日期^评估时间^健康教育个性化^项目^教育对象^教育时机^教育方法^效果评价^教育者^备注
/// do ##class(%ResultSet).RunQuery("web.DHCHlthEduAss","FindHlthEduAss","13398520")
Query FindHlthEduAss(EpisodeID As %String) As %Query(ROWSPEC = "HEADateData:%String,HEATimeData:%String,HEAIndvdNdData:%String,HEAProjectData:%String,HEAObjectData:%String,HEAOptntData:%String,HEAWayData:%String,HEAEffectData:%String,HEATeacherData:%String,HEARemarksData:%String,HEARowIDData:%String")
{
}

ClassMethod FindHlthEduAssExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	i EpisodeID=""
	.Set qHandle=$lb(0,repid,0)
	.q:$$$OK
	s HEARowId = ""
	f  s HEARowId=$O(^HEDUA(EpisodeID,"HEAPAPM",HEARowId))  q:HEARowId=""  do
	.q:$d(^HEDUA(HEARowId))=0
	.set HEADate = $P(^HEDUA(HEARowId),"^",2)
	.set HEATime = $P(^HEDUA(HEARowId),"^",3)
	.set HEAIdvdNd = $P(^HEDUA(HEARowId),"^",4)
	.set HEAPItemRowIds = $P(^HEDUA(HEARowId),"^",5)
	.set HEAProject=""
	.set HEAPItem1Arr = ""
	.for i=1:1:$L(HEAPItemRowIds,",") do
	..set HEAPItemRowId = $P(HEAPItemRowIds,",",i)
	..set HEAPItem1 = $P(HEAPItemRowId,"||",1)
	..set HEAPItem2 = $P(HEAPItemRowId,"||",2)
	..set HEAPItem3 = $P(HEAPItemRowId,"||",3)
	..b ;01
	..;set HEAPItem1Decs = $P(^HEDUAP(HEAPItem1),"^",1)
	..if HEAPItem3="" set HEAPItem2Desc = $P($g(^HEDUAPI(HEAPItem2)),"^",2)
	..else  do 
	...set HEAPIIObj = ##class(DHCMGNUR.DHCNurHEAPIItem).%OpenId(HEAPItem3) 
	...set HEAPItem2Desc = HEAPIIObj.Item3
	..b ;02
	..set Flag=0
	..for k=1:1:$L(HEAPItem1Arr,",") do
	...set HEAPItem1t = $P(HEAPItem1Arr,",",k)
	...if HEAPItem1=HEAPItem1t set Flag=1
	..if (Flag=0) do
	...if (HEAPItem1Arr'="") set HEAPItem1Arr = HEAPItem1Arr_","_HEAPItem1
	...else  set HEAPItem1Arr = HEAPItem1
	..if $g(HEAPItem2Arr(HEAPItem1))'="" set HEAPItem2Arr(HEAPItem1) = HEAPItem2Arr(HEAPItem1)_"；"_HEAPItem2Desc
	..else  set HEAPItem2Arr(HEAPItem1) = HEAPItem2Desc
	.for j=1:1:$L(HEAPItem1Arr,",") do
	..set HEAPItem11 = $P(HEAPItem1Arr,",",j)
	..set HEAPItem1Decs = $P(^HEDUAP(HEAPItem11),"^",1)
	..set HEAProject = HEAProject_HEAPItem1Decs_"："_HEAPItem2Arr(HEAPItem11)_"。"
	..set HEAPItem2Arr(HEAPItem11)=""
	.set HEAObject = $P(^HEDUA(HEARowId),"^",6)
	.set HEAOpportunity = $P(^HEDUA(HEARowId),"^",7)
	.set HEAMethod = $P(^HEDUA(HEARowId),"^",8)
	.set HEAEffectAss = $P(^HEDUA(HEARowId),"^",9)
	.set SSUserRowId = $P(^HEDUA(HEARowId),"^",10)
	.if SSUserRowId'="" set HEATeacher  = $P(^SSU("SSUSR",SSUserRowId),"^",2)
	.else  set HEATeacher=""
	.set HEARemarks = $P(^HEDUA(HEARowId),"^",11)
	.set HEAValid=$P(^HEDUA(HEARowId),"^",12)
	.if HEAValid'="N" Do OutputRow3
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow3     
	set Data=$lb($zd(HEADate,3),$zt(HEATime,1),HEAIdvdNd,HEAProject,HEAObject,HEAOpportunity,HEAMethod,HEAEffectAss,HEATeacher,HEARemarks,HEARowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindHlthEduAssFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindHlthEduAssExecute ]
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

ClassMethod FindHlthEduAssClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindHlthEduAssExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// do ##class(%ResultSet).RunQuery("web.DHCHlthEduAss","PrintHlthEduAss","14227303")
ClassMethod PrintHlthEduAssClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PrintHlthEduAssExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod PrintHlthEduAssExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s EpisodeID = $P(parr,"!",1)
	i EpisodeID=""
	{
		Set qHandle=$lb(0,repid,0)
		q:$$$OK
	}
	s ^TempHEAData("CESHI") = EpisodeID
	s HEARowId = ""
	f  s HEARowId=$O(^HEDUA(EpisodeID,"HEAPAPM",HEARowId))  q:HEARowId=""  do
	.q:$d(^HEDUA(HEARowId))=0
	.set HEADate = $P(^HEDUA(HEARowId),"^",2)
	.set HEATime = $P(^HEDUA(HEARowId),"^",3)
	.set HEAIdvdNd = $P(^HEDUA(HEARowId),"^",4)
	.set HEAPItemRowIds = $P(^HEDUA(HEARowId),"^",5)
	.set HEAProject=""
	.set HEAPItem1Arr = ""
	.for i=1:1:$L(HEAPItemRowIds,",") do
	..set HEAPItemRowId = $P(HEAPItemRowIds,",",i)
	..set HEAPItem1 = $P(HEAPItemRowId,"||",1)
	..set HEAPItem2 = $P(HEAPItemRowId,"||",2)
	..set HEAPItem3 = $P(HEAPItemRowId,"||",3)
	..;b ;01
	..;set HEAPItem1Decs = $P(^HEDUAP(HEAPItem1),"^",1)
	..if HEAPItem3="" set HEAPItem2Desc = $P($g(^HEDUAPI(HEAPItem2)),"^",2)
	..else  do 
	...set HEAPIIObj = ##class(DHCMGNUR.DHCNurHEAPIItem).%OpenId(HEAPItem3) 
	...set HEAPItem2Desc = HEAPIIObj.Item3
	..;b ;02
	..set Flag=0
	..for k=1:1:$L(HEAPItem1Arr,",") do
	...set HEAPItem1t = $P(HEAPItem1Arr,",",k)
	...if HEAPItem1=HEAPItem1t set Flag=1
	..if (Flag=0) do
	...if (HEAPItem1Arr'="") set HEAPItem1Arr = HEAPItem1Arr_","_HEAPItem1
	...else  set HEAPItem1Arr = HEAPItem1
	..if $g(HEAPItem2Arr(HEAPItem1))'="" set HEAPItem2Arr(HEAPItem1) = HEAPItem2Arr(HEAPItem1)_"；"_HEAPItem2Desc
	..else  set HEAPItem2Arr(HEAPItem1) = HEAPItem2Desc
	.for j=1:1:$L(HEAPItem1Arr,",") do
	..set HEAPItem11 = $P(HEAPItem1Arr,",",j)
	..set HEAPItem1Decs = $P(^HEDUAP(HEAPItem11),"^",1)
	..set HEAProject = HEAProject_HEAPItem1Decs_"："_HEAPItem2Arr(HEAPItem11)_"。"
	..set HEAPItem2Arr(HEAPItem11)=""
	.set HEAObject = $P(^HEDUA(HEARowId),"^",6)
	.set HEAOpportunity = $P(^HEDUA(HEARowId),"^",7)
	.set HEAMethod = $P(^HEDUA(HEARowId),"^",8)
	.set HEAEffectAss = $P(^HEDUA(HEARowId),"^",9)
	.set SSUserRowId = $P(^HEDUA(HEARowId),"^",10)
	.if SSUserRowId'="" set HEATeacher  = $P(^SSU("SSUSR",SSUserRowId),"^",2)
	.else  set HEATeacher=""
	.set HEARemarks = $P(^HEDUA(HEARowId),"^",11)
	.set HEAValid=$P(^HEDUA(HEARowId),"^",12)
	.if HEAValid'="N" do
	..;HEADate,HEATime,HEAIndvdNd,HEAProject,HEAObject,HEAOptnt,HEAWay,HEAEffect,HEATeacher
	..set aa = "CareDateTim|"_$zd(HEADate,3)_"^HEATime|"_$zt(HEATime,1)_"^HEAIndvdNd|"_HEAIdvdNd
	..set aa = aa_"^HEAProject|"_HEAProject_"^HEAObject|"_HEAObject_"^HEAOptnt|"_HEAOpportunity
	..set aa = aa_"^HEAWay|"_HEAMethod_"^HEAEffect|"_HEAEffectAss_"^HEATeacher|"_HEATeacher
	..Do OutputRow
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow     
	;set Data=$lb($zd(HEADate,3),$zt(HEATime,1),HEAIdvdNd,HEAProject,HEAObject,HEAOpportunity,HEAMethod,HEAEffectAss,HEATeacher,HEARemarks,HEARowId)
 	Set Data = $lb(aa)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod PrintHlthEduAssFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PrintHlthEduAssExecute ]
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

/// HEADate,HEATime,HEAIndvdNd,HEAProject,HEAObject,HEAOptnt,HEAWay,HEAEffect,HEATeacher,HEARemarks,HEARowId
Query PrintHlthEduAss(EpisodeID As %String) As %Query(ROWSPEC = "aa")
{
}

/// 根据条件查询其健康教育评估
/// Input:parr
/// Output:评估日期^评估时间^健康教育个性化^项目^教育对象^教育时机^教育方法^效果评价^教育者^备注
/// do ##class(%ResultSet).RunQuery("web.DHCHlthEduAss","FindHEAByFactor","76^^^介入^")
Query FindHEAByFactor(parr As %String) As %Query(ROWSPEC = "HEADateData:%String,HEATimeData:%String,HEAIndvdNdData:%String,HEAProjectData:%String,HEAObjectData:%String,HEAOptntData:%String,HEAWayData:%String,HEAEffectData:%String,HEATeacherData:%String,HEARemarksData:%String,HEARowIDData:%String")
{
}

ClassMethod FindHEAByFactorExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	i parr=""
	{
		Set qHandle=$lb(0,repid,0)
		q:$$$OK
	}
	set EpisodeID = $P(parr,"^",1)
	set StDate = $P(parr,"^",2)
	set EndDate = $P(parr,"^",3)
	set IndvdNeeds = $P(parr,"^",4)
	set Teacher = $$ALPHAUP^SSUTIL4($P(parr,"^",5))
	if StDate'="" 
	{
		s StDate = $ZDH(StDate,3)
	}
	else
	{
		set StDate = 0
	}
	if EndDate'="" 
	{
		s EndDate = $ZDH(EndDate,3)
	}
	else  
	{
		set EndDate = $P($H,",",1)
	}
	set HEARowId = ""
	for i=1:1
	{
		//$O(^HEDUA(76,"HEAPAPM","") 
		set HEARowId=$O(^HEDUA(EpisodeID,"HEAPAPM",HEARowId))
		i HEARowId=""
		{
			Set qHandle=$lb(0,repid,0)
			q:$$$OK
		}
		q:$d(^HEDUA(HEARowId))=0
		set HEADate = $P(^HEDUA(HEARowId),"^",2)
		if (StDate <= HEADate) && (HEADate <= EndDate)
		{
			set HEATime = $P(^HEDUA(HEARowId),"^",3)
			set HEAIdvdNd = $P(^HEDUA(HEARowId),"^",4)
			set HEAPItemRowIds = $P(^HEDUA(HEARowId),"^",5)
			set HEAProject=""
			set HEAPItem1Arr = ""
			for i=1:1:$L(HEAPItemRowIds,",")
			{
				set HEAPItemRowId = $P(HEAPItemRowIds,",",i)
				set HEAPItem1 = $P(HEAPItemRowId,"||",1)
				set HEAPItem2 = $P(HEAPItemRowId,"||",2)
				set HEAPItem3 = $P(HEAPItemRowId,"||",3)
				;set HEAPItem1Decs = $P(^HEDUAP(HEAPItem1),"^",1)
				if HEAPItem3="" 
				{
					set HEAPItem2Desc = $P($g(^HEDUAPI(HEAPItem2)),"^",2)
				}else{ 
					set a = ##class(DHCMGNUR.DHCNurHEAPIItem).%OpenId(HEAPItem3) 
					set HEAPItem2Desc = a.Item3
				}
				set Flag=0
				for k=1:1:$L(HEAPItem1Arr,",")
				{
					set HEAPItem1t = $P(HEAPItem1Arr,",",k)
					if HEAPItem1=HEAPItem1t set Flag=1
					if (Flag=0)
					{
						if (HEAPItem1Arr'="") set HEAPItem1Arr = HEAPItem1Arr_","_HEAPItem1
						else  set HEAPItem1Arr = HEAPItem1
					}
				}
				if $g(HEAPItem2Arr(HEAPItem1))'="" set HEAPItem2Arr(HEAPItem1) = HEAPItem2Arr(HEAPItem1)_"；"_HEAPItem2Desc
				else  set HEAPItem2Arr(HEAPItem1) = HEAPItem2Desc
			}
			for j=1:1:$L(HEAPItem1Arr,",")
			{
				set HEAPItem11 = $P(HEAPItem1Arr,",",j)
				set HEAPItem1Decs = $P(^HEDUAP(HEAPItem11),"^",1)
				set HEAProject = HEAProject_HEAPItem1Decs_"："_HEAPItem2Arr(HEAPItem11)_"。"
				set HEAPItem2Arr(HEAPItem11)=""
			}
			set HEAObject = $P(^HEDUA(HEARowId),"^",6)
			set HEAOpportunity = $P(^HEDUA(HEARowId),"^",7)
			set HEAMethod = $P(^HEDUA(HEARowId),"^",8)
			set HEAEffectAss = $P(^HEDUA(HEARowId),"^",9)
			set SSUserRowId = $P(^HEDUA(HEARowId),"^",10)
			if SSUserRowId'="" set HEATeacher  = $P(^SSU("SSUSR",SSUserRowId),"^",2)
			else  set HEATeacher=""
			set HEARemarks = $P(^HEDUA(HEARowId),"^",11)
			set HEAValid = $P(^HEDUA(HEARowId),"^",12)
			if HEAValid="N" q
			if (IndvdNeeds="")&&(Teacher="")
			{
				Do OutputRow1
			}
			else
			{
				if ($g(Teacher)'="") && ($g(IndvdNeeds)="")
				{
					set SSURowId=$O(^SSU("SSUSR",0,"SSUSR_Initials",Teacher,""))
					if SSURowId=SSUserRowId
					{
						Do OutputRow1
					}
				}
				else
				{			
					set flag=0
					//write !,IndvdNeeds,HEAIdvdNd
					for i=1:1:$L(IndvdNeeds,",")
					{
						set IndvdNeed = $P(IndvdNeeds,",",i)
						//write !,IndvdNeed,HEAIdvdNd
						//w !,IndvdNeed]HEAIdvdNd
						if $F(HEAIdvdNd,IndvdNeed)>=1
						{
							//w !,i_":"_IndvdNeed
							s flag=1
						}
						else  
						{
							s flag=0 
							s i=$L(IndvdNeeds,",")+1
						}
					}
					//w !,flag
					if flag=1
					{
						Do OutputRow1
					}
				}
			}
		}
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1     
	set Data=$lb($zd(HEADate,3),$zt(HEATime,1),HEAIdvdNd,HEAProject,HEAObject,HEAOpportunity,HEAMethod,HEAEffectAss,HEATeacher,HEARemarks,HEARowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindHEAByFactorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindHEAByFactorExecute ]
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

ClassMethod FindHEAByFactorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindHEAByFactorExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 通过RowId获取记录信息
ClassMethod FindHEAByRowId(parr As %String) As %String
{
	q:parr=""
	s HEARowId=parr
	q:$d(^HEDUA(HEARowId))=0
	set HEADate = $P(^HEDUA(HEARowId),"^",2)
	set HEATime = $P(^HEDUA(HEARowId),"^",3)
	set HEAIdvdNd = $P(^HEDUA(HEARowId),"^",4)
	set HEAProject = $P(^HEDUA(HEARowId),"^",5)
	;set HEAPItem1 = $P(HEAPItemRowId,"||",1)
	;set HEAPItem2 = $P(HEAPItemRowId,"||",2)
	;set HEAPItem1Decs = $P(^HEDUAP(HEAPItem1),"^",1)
	;set HEAPItem2Desc = $P(^HEDUAPI(HEAPItem2),"^",2)
	;set HEAProject = HEAPItem1Decs_"/"_HEAPItem2Desc
	set HEAObject = $P(^HEDUA(HEARowId),"^",6)
	set HEAOpportunity = $P(^HEDUA(HEARowId),"^",7)
	set HEAMethod = $P(^HEDUA(HEARowId),"^",8)
	set HEAEffectAss = $P(^HEDUA(HEARowId),"^",9)
	set HEATeacher = $P(^HEDUA(HEARowId),"^",10)
	if HEATeacher'="" set SSUSRInitials = $P(^SSU("SSUSR",HEATeacher),"^",1)
	else  s SSUSRInitials=""
	set HEARemarks = $P(^HEDUA(HEARowId),"^",11)
	set ret = $zd(HEADate,3)_"^"_$zt(HEATime,1)_"^"_HEAIdvdNd_"^"_HEAProject_"^"_HEAObject_"^"_HEAOpportunity_"^"_HEAMethod_"^"_HEAEffectAss_"^"_SSUSRInitials_"^"_HEARemarks
	q ret
}

/// do ##class(%ResultSet).RunQuery("web.DHCHlthEduAss","FindHEAData","^^^")
Query FindHEAData(parr As %String) As %Query(ROWSPEC = "PAPMIName,PAPMIPatNo,CTSexDesc,PAPersonAge,CTLocDesc,PAADMAdmDate,PAADMAdmTime,AdmDate,HEATime,HEAIdvdNd,HEAProject,HEAObject,HEAOpportunity,HEAMethod,HEAEffectAss,HEATeacher,HEARemarks,HEARowId")
{
}

ClassMethod FindHEADataExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	i parr=""
	{
		Set qHandle=$lb(0,repid,0)
		q:$$$OK
	}
	set StDate = $P(parr,"^",1)
	set EndDate = $P(parr,"^",2)
	set IndvdNeeds = $P(parr,"^",3)
	set ItemOneDR = $P(parr,"^",4)
	if EndDate'="" 
	{
		s EndDate = $ZDH(EndDate,3)
	}
	else  
	{
		set EndDate = $P($H,",",1)
	}
	if StDate'="" 
	{
		s StDate = $ZDH(StDate,3)
	}
	else
	{
		s stDate= 0
	}
	for AdmDate = StDate:1:EndDate
	{
		set HEARowId = ""
		for i=1:1
		{
			//w !,AdmDate
			set HEARowId=$O(^HEDUA(AdmDate,"HEADATE",HEARowId))
			//w !,HEARowId
			q:HEARowId=""
			q:$D(^HEDUA(HEARowId))=0
			set HEAIdvdNd = $P(^HEDUA(HEARowId),"^",4)
			set HEAPItemRowIds = $P(^HEDUA(HEARowId),"^",5)
			set HEAValid = $P(^HEDUA(HEARowId),"^",12)
			if HEAValid="N" q 
			for i=1:1:$L(HEAPItemRowIds,",")
			{
				set HEAPItemRowId = $P(HEAPItemRowIds,",",i)
				set HEAPItem1 = $P(HEAPItemRowId,"||",1)
				set HEAPItem2 = $P(HEAPItemRowId,"||",2)
				if (IndvdNeeds="")&&(ItemOneDR="")
				{
					Do OutputRow2
					q
				}	
				else
				{
					if ($g(ItemOneDR)'="") && ($g(IndvdNeeds)="")
					{
						if HEAPItem1=ItemOneDR
						{
							Do OutputRow2
							q
						}
					}
					else
					{			
						set flag=0
						//write !,IndvdNeeds,HEAIdvdNd
						for i=1:1:$L(IndvdNeeds,",")
						{
							set IndvdNeed = $P(IndvdNeeds,",",i)
							//write !,IndvdNeed,HEAIdvdNd
							//w !,IndvdNeed]HEAIdvdNd
							if $F(HEAIdvdNd,IndvdNeed)>=1
							{
								//w !,i_":"_IndvdNeed
								s flag=1
							}
							else  
							{
								s flag=0 
								s i=$L(IndvdNeeds,",")+1
							}
						}
						//w !,flag
						if flag=1
						{
							Do OutputRow2
							q
						}
					}
				}
			}
		}
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	//w !,HEARowId
	set HEAPAPMDR=$P(^HEDUA(HEARowId),"^",1)
	set PAADMPAPMIDR = $P(^PAADM(HEAPAPMDR),"^",1)
	set PAADMDepCodeDR = $P(^PAADM(HEAPAPMDR),"^",4)
	set CTLocDesc = $P(^CTLOC(PAADMDepCodeDR),"^",2)
	set PAADMAdmDate = $P(^PAADM(HEAPAPMDR),"^",6)
	set PAADMAdmTime = $P(^PAADM(HEAPAPMDR),"^",7)
	set PAPMIName = $P(^PAPER(PAADMPAPMIDR,"ALL"),"^",1)
	set PAPMISexDR = $P(^PAPER(PAADMPAPMIDR,"ALL"),"^",7)
	set CTSexDesc = $P(^CT("SEX",PAPMISexDR),"^",2)
	set PAPMIPatNo = $P(^PAPER(PAADMPAPMIDR,"PAT",1),"^",1)
	s PAPersonDR  = PAADMPAPMIDR
	s PAPersonDob = $P(^PAPER(PAPersonDR,"ALL"),"^",6)
	S PAPersonYear = $P($ZD(PAPersonDob,3),"-",1)
	s NowYear = $P($zd($P($H,",",1),3),"-",1)
	s PAPersonAge=(NowYear-PAPersonYear)
	set HEATime = $P(^HEDUA(HEARowId),"^",3)
	set HEAProject=""
	set HEAPItem1Arr = ""
	for i=1:1:$L(HEAPItemRowIds,",")
	{
		set HEAPItemRowId = $P(HEAPItemRowIds,",",i)
		set HEAPItem1 = $P(HEAPItemRowId,"||",1)
		set HEAPItem2 = $P(HEAPItemRowId,"||",2)
		set HEAPItem3 = $P(HEAPItemRowId,"||",3)
		;set HEAPItem1Decs = $P(^HEDUAP(HEAPItem1),"^",1)
		if HEAPItem3="" 
		{
			set HEAPItem2Desc = $P($g(^HEDUAPI(HEAPItem2)),"^",2)
		}else{ 
			set a = ##class(DHCMGNUR.DHCNurHEAPIItem).%OpenId(HEAPItem3) 
			set HEAPItem2Desc = a.Item3
		}
		set Flag=0
		for k=1:1:$L(HEAPItem1Arr,",")
		{
			set HEAPItem1t = $P(HEAPItem1Arr,",",k)
			if HEAPItem1=HEAPItem1t set Flag=1
			if (Flag=0)
			{
				if (HEAPItem1Arr'="") set HEAPItem1Arr = HEAPItem1Arr_","_HEAPItem1
				else  set HEAPItem1Arr = HEAPItem1
			}
		}
		if $g(HEAPItem2Arr(HEAPItem1))'="" set HEAPItem2Arr(HEAPItem1) = HEAPItem2Arr(HEAPItem1)_"；"_HEAPItem2Desc
		else  set HEAPItem2Arr(HEAPItem1) = HEAPItem2Desc
	}
	for j=1:1:$L(HEAPItem1Arr,",")
	{
		set HEAPItem11 = $P(HEAPItem1Arr,",",j)
		set HEAPItem1Decs = $P(^HEDUAP(HEAPItem11),"^",1)
		set HEAProject = HEAProject_HEAPItem1Decs_"："_HEAPItem2Arr(HEAPItem11)_"。"
		set HEAPItem2Arr(HEAPItem11)=""
	}
	set HEAObject = $P(^HEDUA(HEARowId),"^",6)
	set HEAOpportunity = $P(^HEDUA(HEARowId),"^",7)
	set HEAMethod = $P(^HEDUA(HEARowId),"^",8)
	set HEAEffectAss = $P(^HEDUA(HEARowId),"^",9)
	set SSUserRowId = $P(^HEDUA(HEARowId),"^",10)
	if SSUserRowId'="" set HEATeacher  = $P(^SSU("SSUSR",SSUserRowId),"^",2)
	else  set HEATeacher  = ""
	set HEARemarks = $P(^HEDUA(HEARowId),"^",11)
	set Data=$lb(PAPMIName,PAPMIPatNo,CTSexDesc,PAPersonAge,CTLocDesc,$zd(PAADMAdmDate,3),$zt(PAADMAdmTime,1),$zd(AdmDate,3),$zt(HEATime,1),HEAIdvdNd,HEAProject,HEAObject,HEAOpportunity,HEAMethod,HEAEffectAss,HEATeacher,HEARemarks,HEARowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindHEADataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindHEADataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindHEADataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindHEADataExecute ]
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

}
