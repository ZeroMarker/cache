/// 设备使用记录业务类
Class CIS.AN.BL.EquipRecord Extends %RegisteredObject
{

/// Creator：      	陈长青
/// CreatDate：    	2018-05-27
/// Description： 	保存设备使用记录
/// Table：        	CIS_AN.EquipRecord
/// Input:			recordSheetId:手术麻醉记录表单ID，equipCode:设备代码，userId:用户ID
/// Return：       	保存成功返回"S^ID"，失败返回"E^错误原因"
/// w ##class(CIS.AN.BL.EquipRecord).SaveEquipRecord("76","CSD01","6463")
ClassMethod SaveEquipRecord(recordSheetId As %String, equipCode As %String, userId As %String, duration As %String) As %String
{
	set $zt="Error"
	set equipID=$o(^CF.AN.DeptEquipI("ICode"," "_$System.SQL.ALPHAUP(equipCode),0))
	quit:(##class(CF.AN.DeptEquip).%ExistsId(equipID)=0) "E^不存在编号为"_equipCode_"的设备。"
	set equipRecord=##class(CIS.AN.EquipRecord).%New()
	set equipRecord.RecordSheet=##class(CIS.AN.RecordSheet).%OpenId(recordSheetId)
	set equipRecord.Equip=##class(CF.AN.DeptEquip).%OpenId(equipID)
	set equipRecord.Equip.Location=equipRecord.RecordSheet.OperSchedule.OperRoom
	set today=+$h,now=$p($h,",",2)
	set equipRecord.StartDate=today
	set equipRecord.EndDate=today
	set equipRecord.StartTime=now
	set equipRecord.EndTime=now
	set equipRecord.UpdateUser=userId
	set equipRecord.UpdateDate=today
	set equipRecord.UpdateTime=now
	set equipRecord.Duration=duration
	set sc=equipRecord.%Save()
	if ($System.Status.IsError(sc))
	{
		quit "E^"_$System.Status.GetErrorText(sc)	
	}	
	quit "S^"_equipRecord.%Id()
Error
	quit "E^"_$ze
}

/// Creator：      	陈长青
/// CreatDate：    	2018-05-27
/// Description： 	查询设备使用记录
/// Table：        	CIS_AN.EquipRecord
/// Input:			sheetId:手术麻醉记录表单ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.EquipRecord","FindEquipRecords","48")
Query FindEquipRecords(sheetId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
	   RecordSheet,
	   CIS_AN_COM.DateTime_ConvertToDateTime(StartDate,StartTime,'') As StartDT,
	   CIS_AN_COM.DateTime_ConvertToDateTime(EndDate,EndTime,'') As EndDT,
	   UpdateUser,
	   CIS_AN_COM.String_GetDescByID('User.SSUser','SSUSRName',UpdateUser) As UpdateUserDesc,
	   Equip,
	   Equip->EquipCode As EquipCode,
	   Equip->EquipDesc As EquipDesc,
	   Equip->Location->Description As OperRoomDesc,
	   Duration
	   From CIS_AN.EquipRecord
	   where RecordSheet=:sheetId
}

ClassMethod SaveDuration(rowId, duration)
{
	set equipRecord=##class(CIS.AN.EquipRecord).%OpenId(rowId)
	set equipRecord.Duration=duration
	do equipRecord.%Save()
	quit "S^"
}

}
