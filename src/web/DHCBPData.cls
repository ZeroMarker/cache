Class web.DHCBPData Extends %RegisteredObject
{

/// w ##class(web.DHCBPData).GetSheetIdByDataModule("3","1","","24516")
ClassMethod GetSheetIdByDataModule(moduleId As %String, bpprId As %String, bpaId As %String, userId As %String = "") As %String
{
	set sheetId=""
	quit:('##class(User.DHCBPPatRegister).%ExistsId(bpprId)) ""
	i bpprId'="" &sql(select RowId into :sheetId from SQLUser.DHC_BP_Sheet where BPPatRegister=:bpprId and BPCModule=:moduleId)
	i bpaId'="" &sql(select RowId into :sheetId from SQLUser.DHC_BP_Sheet where BPArrange=:bpaId and BPCModule=:moduleId)
	if ('##class(User.DHCBPSheet).%ExistsId(sheetId))
	{
		//b ;;001
		set sheetObj=##class(User.DHCBPSheet).%New()
		if (##class(User.DHCBPArrange).%ExistsId(bpaId))
		{
			set sheetObj.BPArrange=##class(User.DHCBPArrange).%OpenId(bpaId)
		}
		set sheetObj.BPPatRegister=##class(User.DHCBPPatRegister).%OpenId(bpprId)
		set sheetObj.UpdateDate=+$h
		set sheetObj.UpdateTime=$piece($h,",",2)
		set sheetObj.Status="N"
		set sheetObj.CreateUser=userId
		set sheetObj.CreateDate=+$h
		set sheetObj.CreateTime=$piece($h,",",2)
		set sheetObj.BPCModule=##class(User.DHCBPCModule).%OpenId(moduleId)
		set status=sheetObj.%Save()
		//w "E^"_$System.Status.GetErrorText(status)
		set sheetId=sheetObj.%Id()
	}
	
	quit sheetId
}

/// d ##class(%ResultSet).RunQuery("web.DHCBPData","FindBPDataBySheetId",1)
Query FindBPDataBySheetId(sheetId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
	   BPSheet,
	   ItemCode As DataItem,
	   ItemDesc,
	   ItemValue As DataValue,
	   %ODBCOUT(ItemDate) As ItemDate,
	   %ODBCOUT(ItemTime) As ItemTime,
	   UpdateUser,
	   %ODBCOUT(UpdateDate) As UpdateDate,
	   %ODBCOUT(UpdateTime) As UpdateTime,
	   Note As DataNote
	   From SQLUser.DHC_BP_Data
	   where BPSheet=:sheetId
}

/// w ##class(web.DHCBPData).SaveBPDatas(^tmpSaveBPDatas)
ClassMethod SaveBPDatas(dataPara As %String) As %String
{
	set ^tmpSaveBPDatas=dataPara
	set $zt="Error"
	set sc=##class(CIS.AN.COM.String).ToArray(dataPara,.array)

	tstart
	set dataIndex=0,saveResult="S^"
	for
	{
		set dataIndex=$order(array(dataIndex))
		quit:(dataIndex="")
		m BPData=array(dataIndex)
		
		set RowId=BPData("RowId")
		set BPSheet=BPData("BPSheet")
		set ItemCode=BPData("ItemCode")
		set ItemDesc=BPData("ItemDesc")
		set ItemValue=BPData("ItemValue")
		set UpdateUser=BPData("UpdateUser")
		set Note=BPData("Note")
		set obj=##class(User.DHCBPData).%New()
		if (##class(User.DHCBPData).%ExistsId(RowId))
		{
			set obj=##class(User.DHCBPData).%OpenId(RowId)
		}
		else
		{
			set obj.ItemDate=+$h
			set obj.ItemTime=$piece($h,",",2)
		}
		if ('##class(User.DHCBPSheet).%ExistsId(BPSheet)){
			set saveResult="E^BPSheet不对!"
			break
		}
		set obj.BPSheet=##class(User.DHCBPSheet).%OpenId(BPSheet)
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
