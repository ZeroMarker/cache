/// 重症病人身高体重头围信息业务类
Class web.DHCICUPatWeightInfo Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("web.DHCICUPatWeightInfo","FindICUPatWeightInfo",5)
Query FindICUPatWeightInfo(icuaId As %String, status As %String = "N") As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
	   ICUArrange As icuaId,
	   %ODBCOUT(StartDate) As StartDate,
	   %ODBCOUT(StartTime) As StartTime,
	   %ODBCOUT(StartDate)_" "_%ODBCOUT(StartTime) As StartDatetime,
	   Weight,
	   Height,
	   HeadCircumference,
	   UpdateUser As UpdateUserID,
	   CIS_AN_COM.String_GetDescByID('User.SSUser','SSUSRName',UpdateUser) As UpdateUserDesc,
	   Status,
	   %EXTERNAL(Status) As StatusDesc
	   From SQLUser.DHC_ICU_PatWeightInfo
	   where ICUArrange=:icuaId
	   and (Status=:status or :status is null)
	   order by StartDate,StartTime
}

ClassMethod SaveICUPatWeightInfo(rowid, icuaid, startDatetime, Weight, Height, HeadCircumference, userId) As %String
{
	quit:'##class(User.DHCICUArrange).%ExistsId(icuaid) "E^icuaId错误"
	quit:startDatetime="" "E^日期时间不能为空"
	
	set startDate=$piece(startDatetime," ",1)
	set startTime=$piece(startDatetime," ",2)
	
	set saveResult="S^"
	set obj=##class(User.DHCICUPatWeightInfo).%New()
	if (##class(User.DHCICUPatWeightInfo).%ExistsId(rowid))
	{
		set obj=##class(User.DHCICUPatWeightInfo).%OpenId(rowid)
	}
	
	set obj.ICUArrange=##class(User.DHCICUArrange).%OpenId(icuaid)
	set obj.StartDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	set obj.StartTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	set obj.Weight=Weight
	set obj.Height=Height
	set obj.HeadCircumference=HeadCircumference
	set obj.UpdateUser=userId
	set obj.UpdateDate=+$h
	set obj.UpdateTime=$p($h,",",2)
	set obj.Status="N"
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

ClassMethod DeleteICUPatWeightInfo(rowId As %String) As %String
{
	quit:'##class(User.DHCICUPatWeightInfo).%ExistsId(rowId) "E^rowId错误"
	
	set saveResult="S^"
	set obj=##class(User.DHCICUPatWeightInfo).%OpenId(rowId)
	set obj.Status="D"
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

}
