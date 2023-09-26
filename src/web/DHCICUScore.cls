/// 重症评分业务类
Class web.DHCICUScore Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("web.DHCICUScore","FindICUScore",5,1)
Query FindICUScore(icuaId As %String, moduleId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
       ICUArrange,
	   UpdateUser As UpdateUserId,
	   %ODBCOUT(UpdateDate) As UpdateDate,
	   %ODBCOUT(UpdateTime) As UpdateTime,
	   %ODBCOUT(UpdateDate)_" "_%ODBCOUT(UpdateTime) As UpdateDT,
	   Status,
	   %EXTERNAL(Status) As StatusDesc,
	   CreateUser,
	   %ODBCOUT(CreateDate) As CreateDate,
	   %ODBCOUT(CreateTime) As CreateTime,
	   SubmitUser As SubmitUserId,
	   CIS_AN_COM.String_GetDescByID('User.SSUser','SSUSRName',SubmitUser) As SubmitUserDesc,
	   %ODBCOUT(SubmitDate) As SubmitDate,
	   %ODBCOUT(SubmitTime) As SubmitTime,
	   %ODBCOUT(SubmitDate)_" "_%ODBCOUT(SubmitTime) As SubmitDT,
	   ArchiveUser,
	   ArchiveDate,
	   ArchiveTime,
	   ArchivePath,
	   ICUCModule,
	   TotalScore
	   From SQLUser.DHC_ICU_Score
	   where ICUArrange=:icuaId and ICUCModule=:moduleId
	   and Active="Y"
	   order by SubmitDate,SubmitTime
}

ClassMethod CreateScore(icuaId As %String, moduleId As %String, userId As %String) As %String
{
	quit:'##class(User.DHCICUArrange).%ExistsId(icuaId) "E^icuaId不对"
	quit:'##class(User.DHCICUCModule).%ExistsId(moduleId) "E^moduleId不对"
	
	set saveResult="S^"
	set obj=##class(User.DHCICUScore).%New()
	set obj.ICUArrange=##class(User.DHCICUArrange).%OpenId(icuaId)
	set obj.UpdateUser=userId
	set obj.UpdateDate=+$h
	set obj.UpdateTime=$piece($h,",",2)
	set obj.Status="N"
	set obj.CreateUser=userId
	set obj.CreateDate=+$h
	set obj.CreateTime=$piece($h,",",2)
	set obj.SubmitUser=userId
	set obj.SubmitDate=+$h
	set obj.SubmitTime=$piece($h,",",2)
	set obj.ICUCModule=##class(User.DHCICUCModule).%OpenId(moduleId)
	set obj.Active="Y"
	set sc=obj.%Save()
	if ($System.Status.IsOK(sc))
	{
		set saveResult="S^"_obj.%Id()
	}
	else
	{
		set saveResult="E^"_$System.Status.GetErrorText(sc)
	}
	quit saveResult
}

ClassMethod DeleteScore(scoreId As %String) As %String
{
	quit:'##class(User.DHCICUScore).%ExistsId(scoreId) "E^scoreId不对"
	
	set saveResult="S^"
	set obj=##class(User.DHCICUScore).%OpenId(scoreId)
	set obj.Active="N"
	set sc=obj.%Save()
	if ($System.Status.IsOK(sc))
	{
		set saveResult="S^"_obj.%Id()
	}
	else
	{
		set saveResult="E^"_$System.Status.GetErrorText(sc)
	}
	quit saveResult
}

/// d ##class(%ResultSet).RunQuery("web.DHCICUScore","FindICUScoreData",3)
Query FindICUScoreData(scoreId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
       ICUScore,
	   ItemCode,
	   ItemDesc,
	   ItemValue,
	   %ODBCOUT(ItemDate) As ItemDate,
	   %ODBCOUT(ItemTime) As ItemTime,
	   %ODBCOUT(ItemDate)_" "_%ODBCOUT(ItemTime) As ItemDT,
	   UpdateUser As UpdateUserId,
	   %ODBCOUT(UpdateDate) As UpdateDate,
	   %ODBCOUT(UpdateTime) As UpdateTime,
	   ItemNote
	   From SQLUser.DHC_ICU_ScoreData
	   where ICUScore=:scoreId
}

/// w ##class(web.DHCICUScore).SaveICUScoreDatas(^tmpSaveICUScoreDatas)
ClassMethod SaveICUScoreDatas(dataPara As %String) As %String
{
	set $zt="Error"
	set sc=##class(CIS.AN.COM.String).ToArray(dataPara,.array)

	set totalScore="", scoreId="", assessDateTime=""
	tstart
	set dataIndex=0,saveResult=""
	for
	{
		set dataIndex=$order(array(dataIndex))
		quit:(dataIndex="")
		m ICUData=array(dataIndex)
		
		set RowId=ICUData("RowId")
		set ICUScore=ICUData("ICUScore")
		set ItemCode=ICUData("ItemCode")
		set ItemDesc=ICUData("ItemDesc")
		set ItemValue=ICUData("ItemValue")
		set UpdateUser=ICUData("UpdateUser")
		set ItemNote=ICUData("ItemNote")
		if ((ItemCode="TotalScore") && (ItemValue'="")) set totalScore=+ItemValue
		if ((ItemCode="AssessDateTime") && (ItemValue'="")) set assessDateTime=ItemValue
		quit:'##class(User.DHCICUScore).%ExistsId(ICUScore)
		set scoreId=ICUScore
		
		
		set obj=##class(User.DHCICUScoreData).%New()
		if (##class(User.DHCICUScoreData).%ExistsId(RowId))
		{
			set obj=##class(User.DHCICUScoreData).%OpenId(RowId)
		}
		else
		{
			set obj.ItemDate=+$h
			set obj.ItemTime=$piece($h,",",2)
		}
		set obj.ICUScore=##class(User.DHCICUScore).%OpenId(ICUScore)
		set obj.ItemCode=ItemCode
		set obj.ItemDesc=ItemDesc
		set obj.ItemValue=ItemValue
		set obj.UpdateUser=UpdateUser
		set obj.UpdateDate=+$h
		set obj.UpdateTime=$piece($h,",",2)
		set obj.ItemNote=ItemNote
		set sc=obj.%Save()
		if ($System.Status.IsOK(sc))
		{
			set saveResult="S^"_obj.%Id()
		}
		else
		{
			set saveResult="E^"_$System.Status.GetErrorText(sc)
		}
		
		quit:($piece(saveResult,"^",1)'="S")
	}
	
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	
	if (##class(User.DHCICUScore).%ExistsId(scoreId) && totalScore'="")
	{
		set submitDate=+$h,submitTime=$piece($h,",",2)
		if (assessDateTime'="") 
		{
			set assessDate=$piece(assessDateTime," ",1),assessTime=$piece(assessDateTime," ",2)
			set submitDate=##class(web.DHCClinicCom).ConvertToDateH(assessDate)
			set submitTime=##class(web.DHCClinicCom).ConvertToTimeH(assessTime)
		}
		set scoreObj=##class(User.DHCICUScore).%OpenId(scoreId)
		set scoreObj.Status="S"
		set scoreObj.TotalScore=totalScore
		set scoreObj.SubmitDate=submitDate
		set scoreObj.SubmitTime=submitTime
		set sc=scoreObj.%Save()
		if ($System.Status.IsOK(sc)) set saveResult="S^"_scoreObj.%Id()
		else  set saveResult="E^"_$System.Status.GetErrorText(sc)
	}
	
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}

	tcommit
	quit "S^"
Error
	set $zt=""
	quit "E^"_$ze
}

}
