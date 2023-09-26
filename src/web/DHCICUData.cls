Class web.DHCICUData Extends %RegisteredObject
{

/// w ##class(web.DHCICUData).GetSheetIdByDataModule(1,5,4667)
ClassMethod GetSheetIdByDataModule(moduleId As %String, icuaId As %String, userId As %String = "") As %String
{
	set sheetId=""
	&sql(select RowId into :sheetId from SQLUser.DHC_ICU_Sheet where ICUArrange=:icuaId and ICUCModule=:moduleId)
	if ('##class(User.DHCICUSheet).%ExistsId(sheetId))
	{
		set sheetObj=##class(User.DHCICUSheet).%New()
		set sheetObj.ICUArrange=##class(User.DHCICUArrange).%OpenId(icuaId)
		set sheetObj.UpdateDate=+$h
		set sheetObj.UpdateTime=$piece($h,",",2)
		set sheetObj.Status="N"
		set sheetObj.CreateUser=userId
		set sheetObj.CreateDate=+$h
		set sheetObj.CreateTime=$piece($h,",",2)
		set sheetObj.ICUCModule=##class(User.DHCICUCModule).%OpenId(moduleId)
		set status=sheetObj.%Save()
		set sheetId=sheetObj.%Id()
	}
	
	quit sheetId
}

/// d ##class(%ResultSet).RunQuery("web.DHCICUData","FindICUDataBySheetId",1)
Query FindICUDataBySheetId(sheetId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
	   ICUSheet,
	   ItemCode As DataItem,
	   ItemDesc,
	   ItemValue As DataValue,
	   %ODBCOUT(ItemDate) As ItemDate,
	   %ODBCOUT(ItemTime) As ItemTime,
	   UpdateUser,
	   %ODBCOUT(UpdateDate) As UpdateDate,
	   %ODBCOUT(UpdateTime) As UpdateTime,
	   Note As DataNote
	   From SQLUser.DHC_ICU_Data
	   where ICUSheet=:sheetId
}

/// w ##class(web.DHCICUData).SaveICUDatas(^tmpSaveICUDatas)
ClassMethod SaveICUDatas(dataPara As %String) As %String
{
	set ^tmpSaveICUDatas=dataPara
	set $zt="Error"
	set sc=##class(CIS.AN.COM.String).ToArray(dataPara,.array)

	tstart
	set dataIndex=0,saveResult="S^"
	for
	{
		set dataIndex=$order(array(dataIndex))
		quit:(dataIndex="")
		m ICUData=array(dataIndex)
		
		set RowId=ICUData("RowId")
		set ICUSheet=ICUData("ICUSheet")
		set ItemCode=ICUData("ItemCode")
		set ItemDesc=ICUData("ItemDesc")
		set ItemValue=ICUData("ItemValue")
		set UpdateUser=ICUData("UpdateUser")
		set Note=ICUData("Note")
		set obj=##class(User.DHCICUData).%New()
		if (##class(User.DHCICUData).%ExistsId(RowId))
		{
			set obj=##class(User.DHCICUData).%OpenId(RowId)
		}
		else
		{
			set obj.ItemDate=+$h
			set obj.ItemTime=$piece($h,",",2)
		}
		if ('##class(User.DHCICUSheet).%ExistsId(ICUSheet)){
			set saveResult="E^ICUSheet不对!"
			break
		}
		set obj.ICUSheet=##class(User.DHCICUSheet).%OpenId(ICUSheet)
		set obj.ItemCode=ItemCode
		set obj.ItemDesc=ItemDesc
		set obj.ItemValue=ItemValue
		set obj.UpdateUser=UpdateUser
		set obj.UpdateDate=+$h
		set obj.UpdateTime=$piece($h,",",2)
		set obj.Note=Note
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
	
	tcommit
	quit "S^"
Error
	set $zt=""
	quit "E^"_$ze
}

}
