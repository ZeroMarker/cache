/// 麻醉评估
Class CIS.AN.BL.AnaestAssess Extends %RegisteredObject
{

/// Creator：      	雍阳
/// CreatDate：    	2019-08-21
/// Description： 	自动预评估
/// Table：        	
/// Input:			opaId:手术ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaestAssess","AutoAssessGoldman")
Query AutoAssessGoldman(opsId As %String) As %Query(ROWSPEC = "Age,Emergency") [ SqlProc ]
{
}

ClassMethod AutoAssessGoldmanExecute(ByRef qHandle As %Binary, opsId As %String) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	kill assess
	if ##class(CIS.AN.OperSchedule).%ExistsId(opsId)
	{
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		set admId=operSchedule.EpisodeID
		set papmiId=$p($g(^PAADM(admId)),"^",1)
		set birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
		set age=##class(CIS.AN.COM.DateTime).CalAge(birth,+$h,0,"Y")
		if age>70 set assess("Age")="Y"
		
		set sourceType=operSchedule.SourceType
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
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaestAssess","FindGoldmanAssess","1")
Query FindGoldmanAssess(opsId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT *
	from CIS_AN.GoldmanAssess where OperSchedule=:opsId
}

/// Creator：      	雍阳
/// CreatDate：    	2019-08-21
/// Description： 	自动预评估
/// Table：        	
/// Input:			opaId:手术ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaestAssess","AutoAssessGoldman")
Query AutoAssessChildPugh(opsId As %String) As %Query(ROWSPEC = "TBIL,ALB,PTCondition") [ SqlProc ]
{
}

ClassMethod AutoAssessChildPughExecute(ByRef qHandle As %Binary, opsId As %String) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	kill assess
	if ##class(CIS.AN.OperSchedule).%ExistsId(opsId)
	{
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		set admId=operSchedule.EpisodeID
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
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaestAssess","FindChildPughAssess","1")
Query FindChildPughAssess(opsId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT *
	from CIS_AN.ChildPughAssess where OperSchedule=:opsId
}

/// Creator：      	雍阳
/// CreatDate：    	2019-08-23
/// Description： 	保存Goldman心脏高危评分
/// Table：        	
/// Input:			opaId:手术计划ID
/// Return：       	
/// d ##class(CIS.AN.BL.AnaestAssess).SaveGoldmanAssess("1")
ClassMethod SaveGoldmanAssess(opsId As %String, para As %String) As %String
{
	quit:'##class(CIS.AN.OperSchedule).%ExistsId(opsId) "E^手术计划ID不存在"
	quit:para="" "E^保存参数为空"
	
	set ret=..ToArray(para,.array)
	merge data=array(1)
	set rowId=$o(^CIS.AN.GoldmanAssessI("IOPS",opsId,""))
	if rowId="" 
	{
		set savingObject=##class(CIS.AN.GoldmanAssess).%New()
		set savingObject.OperSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	}
	else  
	{
		set savingObject=##class(CIS.AN.GoldmanAssess).%OpenId(rowId)
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
/// d ##class(CIS.AN.BL.AnaestAssess).SaveChildPughAssess("1")
ClassMethod SaveChildPughAssess(opsId As %String, para As %String) As %String
{
	quit:'##class(CIS.AN.OperSchedule).%ExistsId(opsId) "E^手术计划ID不存在"
	quit:para="" "E^保存参数为空"
	
	set ret=..ToArray(para,.array)
	merge data=array(1)
	set rowId=$o(^CIS.AN.ChildPughAssessI("IOPS",opsId,""))
	if rowId="" 
	{
		set savingObject=##class(CIS.AN.ChildPughAssess).%New()
		set savingObject.OperSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	}
	else  
	{
		set savingObject=##class(CIS.AN.ChildPughAssess).%OpenId(rowId)
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
