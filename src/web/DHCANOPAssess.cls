/// 麻醉评估
Class web.DHCANOPAssess Extends %RegisteredObject
{

/// Creator：      	雍阳
/// CreatDate：    	2019-08-21
/// Description： 	自动预评估
/// Table：        	
/// Input:			opaId:手术ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCANOPAssess","AutoAssessGoldman")
Query AutoAssessGoldman(opaId As %String) As %Query(ROWSPEC = "Age,Emergency") [ SqlProc ]
{
}

ClassMethod AutoAssessGoldmanExecute(ByRef qHandle As %Binary, opaId As %String) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	kill assess
	if ##class(User.DHCANOPArrange).%ExistsId(opaId)
	{
		set admId=$P(^DHCANOPArrange(opaId),"^",1)
		set papmiId=$p($g(^PAADM(admId)),"^",1)
		set birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
		set age=##class(web.DHCClinicCom).CalAge(birth,+$h,0,"Y")
		if age>70 set assess("Age")="Y"
		
		set chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
		set sourceType=$P(^OR(admId,"ANA",chl),"^",32)
		if sourceType="E" set assess("Emergency")="Y"
	}
	
	if $d(assess) do OutputRow
	
	s qHandle=$lb(0,repid,0)
	q $$$OK	

OutputRow
	s ^CacheTemp(repid,ind)=$lb($g(assess("Age")),$g(assess("Emergency")))
	s ind=ind+1
	q
}

ClassMethod AutoAssessGoldmanFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AutoAssessGoldmanExecute ]
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

ClassMethod AutoAssessGoldmanClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AutoAssessGoldmanExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator：      	雍阳
/// CreatDate：    	2019-08-23
/// Description： 	查询Goldman心脏高危评分
/// Table：        	
/// Input:			opaId:手术计划ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCANOPAssess","FindGoldmanAssess","1")
Query FindGoldmanAssess(opaId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT *
	from SQLUser.DHC_AN_GoldmanAssess where OPArrange=:opaId
}

/// Creator：      	雍阳
/// CreatDate：    	2019-08-21
/// Description： 	自动预评估
/// Table：        	
/// Input:			opaId:手术ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCANOPAssess","AutoAssessGoldman")
Query AutoAssessChildPugh(opaId As %String) As %Query(ROWSPEC = "TBIL,ALB,PTCondition") [ SqlProc ]
{
}

ClassMethod AutoAssessChildPughExecute(ByRef qHandle As %Binary, opaId As %String) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	kill assess
	if ##class(User.DHCANOPArrange).%ExistsId(opaId)
	{
		set admId=$P(^DHCANOPArrange(opaId),"^",1)
		set papmiId=$p($g(^PAADM(admId)),"^",1)
	}
	
	if $d(assess) do OutputRow
	
	s qHandle=$lb(0,repid,0)
	q $$$OK	

OutputRow
	s ^CacheTemp(repid,ind)=$lb($g(assess("TBIL")),$g(assess("ALB")),"")
	s ind=ind+1
	q
}

ClassMethod AutoAssessChildPughFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AutoAssessChildPughExecute ]
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

ClassMethod AutoAssessChildPughClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AutoAssessChildPughExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator：      	雍阳
/// CreatDate：    	2019-08-23
/// Description： 	查询Child-Pugh肝脏疾病患者手术危险性评分
/// Table：        	
/// Input:			opaId:手术计划ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCANOPAssess","FindChildPughAssess","1")
Query FindChildPughAssess(opaId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT *
	from SQLUser.DHC_AN_ChildPughAssess where OPArrange=:opaId
}

/// Creator：      	雍阳
/// CreatDate：    	2019-08-21
/// Description： 	查询手术排班信息
/// Table：        	
/// Input:			opaId:手术ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCANOPAssess","FindArrange")
Query FindArrange(opaId As %String) As %Query(ROWSPEC = "RowId,PatName,PatAge,PatGender,Patient,MedcareNo,RegNo,CardNo,EpisodeID,WardBed,PrevAnaMethodDesc,OperInfo,AdmReason,SourceType,ActualOperTime,OperStatusCode") [ SqlProc ]
{
}

ClassMethod FindArrangeExecute(ByRef qHandle As %Binary, opaId As %String) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	if ##class(User.DHCANOPArrange).%ExistsId(opaId) do OutputRow
	
	s qHandle=$lb(0,repid,0)
	q $$$OK	

OutputRow
	s ^CacheTemp(repid,ind)=..GetOperInfo(opaId)
	s ind=ind+1
	q
}

ClassMethod FindArrangeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArrangeExecute ]
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

ClassMethod FindArrangeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArrangeExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator：      	雍阳
/// CreatDate：    	2019-08-23
/// Description： 	获取手术信息（病人信息栏）
/// Table：        	
/// Input:			opaId:手术计划ID
/// Return：       	
/// d ##class(web.DHCANOPAssess).GetOperInfo("1")
ClassMethod GetOperInfo(opaId) As %String
{
	set admId=$P(^DHCANOPArrange(opaId),"^",1)
	set papmiId=$p($g(^PAADM(admId)),"^",1)
	set paadmtype=$p($g(^PAADM(admId)),"^",2)
	set regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	//set medCareNo= ##Class(web.DHCWMRService).IGetMrNoByEpisodeID(admId , .ErrMsg)
	set medCareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(admId,paadmtype,.ErrMsg)
	set patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	set birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	set age=##class(web.DHCBillInterface).GetPapmiAge(papmiId,admId)
	set sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	set patient=patName_" ("_age_" "_sex_")"
	set admLocId=$p($g(^PAADM(admId)),"^",4)
	set bedCode="",inPatNo="",admreason=""
	set bedSub=$p($p($g(^PAADM(admId)),"^",73),"||",2)
	set curWardId=$p($g(^PAADM(admId)),"^",70)  
	if curWardId'="" s wardDesc=$P(^PAWARD(curWardId),"^",1)
	set:(bedSub'="")&(curWardId'="") bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
	set inPatNo=$p($g(^PAADM(admId)),"^",29)
	set admreasondr=$p($g(^PAADM(admId,1)),"^",7)
	if admreasondr'="" set admreason=$p(^PAC("ADMREA",admreasondr),"^",2)
	
	set chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
	set anmethod=""
	set anmthdr=$P(^OR(admId,"ANA",chl),"^",5)
	set anmthdr=$tr(anmthdr,"|",",")
	if anmthdr'=""
	{
		set anmetNum=$l(anmthdr,",")
		for i=1:1:anmetNum
		{
			set anmetId=$p(anmthdr,",",i)
			quit:anmetId=""
			set anmetDesc=$p($g(^ORC("ANMET",anmetId)),"^",2)
			if $P(anmetDesc,"-",2)'="" s anmetDesc=$P(anmetDesc,"-",2)
			if anmethod="" set anmethod=anmetDesc
			else  if (anmethod'="")&(anmethod'[anmetDesc) s anmethod=anmethod_","_anmetDesc
			else  if (anmethod'="")&(anmethod[anmetDesc) s anmethod=anmethod
		}
	}
	
	set sourceType=$P(^OR(admId,"ANA",chl),"^",32)   						//ANA_SourceType 急诊(E)/择期(B)
	
	set opdes=""
	set subchl=0
	for
	{  
		set subchl=$O(^OR(admId,"ANA",chl,"OP",subchl)) 
		quit:(subchl="")
		set opdr=$P(^OR(admId,"ANA",chl,"OP",subchl),"^",6)       		;ANAOP_Type_DR     ；手术名称
		if opdr'=""
		{
			if $P($g(^ORC("OPER",+opdr)),"^",2)'="" 
			{
				if opdes'="" set opdes=opdes_";"
				set opdes=opdes_$P($g(^ORC("OPER",+opdr)),"^",2)
			}
		}
		else
		{
			if $g(^OR(admId,"ANA",chl,"OP",subchl,"REM",2))'=""
			{
				if opdes'="" s opdes=opdes_";"
				set opdes=opdes_$G(^OR(admId,"ANA",chl,"OP",subchl,"REM",2))
			}
		}
	}
	
	set operStatus=$P(^DHCANOPArrange(opaId),"^",27)
	
	set operStatusCode=$s(operStatus="I":"RoomIn",operStatus="L":"RoomOut",operStatus="C":"Cancel",1:"")
	
	//RowId,PatName,PatAge,PatGender,Patient,
	//MedcareNo,RegNo,CardNo,EpisodeID,WardBed,
	//PrevAnaMethodDesc,OperInfo,AdmReason,SourceType,ActualOperTime,
	//OperStatusCode
	quit $lb(opaId,patName,age,sex,patient,
			medCareNo,regNo,"",admId,wardDesc,
			anmethod,opdes,"",sourceType,"",
			operStatusCode)
}

/// Creator：      	雍阳
/// CreatDate：    	2019-08-23
/// Description： 	保存Goldman心脏高危评分
/// Table：        	
/// Input:			opaId:手术计划ID
/// Return：       	
/// d ##class(web.DHCANOPAssess).GetOperInfo("1")
ClassMethod SaveGoldmanAssess(opaId As %String, para As %String) As %String
{
	quit:'##class(User.DHCANOPArrange).%ExistsId(opaId) "E^手术ID不存在"
	quit:para="" "E^保存参数为空"
	
	set ret=..ToArray(para,.array)
	merge data=array(1)
	merge ^TMPAN("Assess",1)=data
	set rowId=$o(^User.DHCANGoldmanAssessI("Arrange",opaId,""))
	if rowId="" 
	{
		set savingObject=##class(User.DHCANGoldmanAssess).%New()
		set savingObject.OPArrange=##class(User.DHCANOPArrange).%OpenId(opaId)
	}
	else  
	{
		set savingObject=##class(User.DHCANGoldmanAssess).%OpenId(rowId)
	}
	
	set savingObject.Age=$g(data("Age"))
	set savingObject.AgeScore=$g(data("AgeScore"))
	set savingObject.MedHistory=$g(data("MedHistory"))
	set savingObject.MedHistoryScore=$g(data("MedHistoryScore"))
	set savingObject.PECardiacFailure=$g(data("PECardiacFailure"))
	set savingObject.PECardiacFailureScore=$g(data("PECardiacFailureScore"))
	set savingObject.PENarrowArtery=$g(data("PENarrowArtery"))
	set savingObject.PENarrowArteryScore=$g(data("PENarrowArteryScore"))
	set savingObject.ECG=$g(data("ECG"))
	set savingObject.ECGScore=$g(data("ECGScore"))
	set savingObject.VPB=$g(data("VPB"))
	set savingObject.VPBScore=$g(data("VPBScore"))
	set savingObject.GeneralCondition=$g(data("GeneralCondition"))
	set savingObject.GeneralConditionScore=$g(data("GeneralConditionScore"))
	set savingObject.ArteryOper=$g(data("ArteryOper"))
	set savingObject.ArteryOperScore=$g(data("ArteryOperScore"))
	set savingObject.Emergency=$g(data("Emergency"))
	set savingObject.EmergencyScore=$g(data("EmergencyScore"))
	set savingObject.TotalScore=$g(data("TotalScore"))
	set savingObject.Result=$g(data("Result"))
	set savingObject.MortalityRate=$g(data("MortalityRate"))
	set savingObject.Note=$g(data("Note"))
	set savingObject.ResultDesc=$g(data("ResultDesc"))
	set savingObject.AssessUser=$g(data("AssessUser"))
	set savingObject.AssessDate=+$h
	set savingObject.AssessTime=$p($h,",",2)
	
	set sc=savingObject.%Save()
	
	if ($$$ISERR(sc)) quit "E^"_sc
	
	quit "S^"
}

/// Creator：      	雍阳
/// CreatDate：    	2019-08-23
/// Description： 	保存Child-Pugh肝脏疾病患者手术危险性评分
/// Table：        	
/// Input:			opaId:手术计划ID
/// Return：       	
/// d ##class(web.DHCANOPAssess).GetOperInfo("1")
ClassMethod SaveChildPughAssess(opaId As %String, para As %String) As %String
{
	quit:'##class(User.DHCANOPArrange).%ExistsId(opaId) "E^手术ID不存在"
	quit:para="" "E^保存参数为空"
	
	set ret=..ToArray(para,.array)
	merge data=array(1)
	set rowId=$o(^User.DHCANChildPughAssessI("Arrange",opaId,""))
	if rowId="" 
	{
		set savingObject=##class(User.DHCANChildPughAssess).%New()
		set savingObject.OPArrange=##class(User.DHCANOPArrange).%OpenId(opaId)
	}
	else  
	{
		set savingObject=##class(User.DHCANChildPughAssess).%OpenId(rowId)
	}
	
	set savingObject.LiverCondition=$g(data("LiverCondition"))
	set savingObject.LiverScore=$g(data("LiverScore"))
	set savingObject.Ascite=$g(data("Ascite"))
	set savingObject.AsciteScore=$g(data("AsciteScore"))
	set savingObject.TBIL=$g(data("TBIL"))
	set savingObject.TBILScore=$g(data("TBILScore"))
	set savingObject.ALB=$g(data("ALB"))
	set savingObject.ALBScore=$g(data("ALBScore"))
	set savingObject.PTCondition=$g(data("PTCondition"))
	set savingObject.PTScore=$g(data("PTScore"))
	set savingObject.TotalScore=$g(data("TotalScore"))
	set savingObject.Result=$g(data("Result"))
	set savingObject.ResultDesc=$g(data("ResultDesc"))
	set savingObject.Note=$g(data("Note"))
	set savingObject.AssessUser=$g(data("AssessUser"))
	set savingObject.AssessDate=+$h
	set savingObject.AssessTime=$p($h,",",2)
	
	set sc=savingObject.%Save()
	
	if ($$$ISERR(sc)) quit "E^"_sc
	
	quit "S^"
}

ClassMethod ToArray(data As %String, ByRef array As %String) As %String
{
	set result=$$$OK
	set objSplitChar=$char(2),propertySplitChar=$char(1),valueSplitChar=$char(0)
	set objCount=$length(data,objSplitChar)
		for objIndex=1:1:objCount
		{
			set objectString=$piece(data,objSplitChar,objIndex)
			set propertyCount=$length(objectString,propertySplitChar)
			for propertyIndex=1:1:propertyCount
			{
				set propertyString=$piece(objectString,propertySplitChar,propertyIndex)
				set propertyName=$piece(propertyString,valueSplitChar,1)
				set propertyValue=$piece(propertyString,valueSplitChar,2)
				set array(objIndex,propertyName)=propertyValue	
			}
		}	
	
	quit result
}

}
