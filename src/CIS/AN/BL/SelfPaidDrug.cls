Class CIS.AN.BL.SelfPaidDrug Extends %RegisteredObject
{

/// Creator：      	雍阳
/// CreatDate：    	2018-8-24
/// Description： 	添加自费药品
/// Table：        	CF.AN.SelfPaidDrug, CIS.AN.SelfPaidDrugData
/// Input:			opsId:手术ID，data:数据，deptId:科室ID，userId:用户ID
/// Return：       	保存成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.SelfPaidDrug).AddSelfPaidDrug("2","","63","1")
ClassMethod AddSelfPaidDrug(recordSheetId As %String, data As %String, deptId As %String, userId As %String) As %String
{
	quit:'##class(CIS.AN.RecordSheet).%ExistsId(recordSheetId) "E^表单不存在"
	quit:deptId="" "E^科室ID不能为空"
	
	set $zt="Error",saveResult=""
	tstart
	set sc=##class(CIS.AN.COM.String).ToArray(data,.array)
	kill selfPaidDrug
	merge selfPaidDrug=array(1)
	
	set isWrongClass=(selfPaidDrug("ClassName")'="CF.AN.SelfPaidDrug")
	if (isWrongClass>0)
	{
		trollback
		quit "E^实体类与数据不对应"
	}
	
	set drugDesc=selfPaidDrug("Description")
	set foundRowId=$o(^CF.AN.SelfPaidDrugI("DeptDesc",deptId,drugDesc,""))
	if (foundRowId>0)
	{
		trollback
		quit "E^已存在自费药品："_drugDesc_"，不能重复添加！"
	}
	
	set saveResult=##class(CIS.AN.COM.DataService).SaveData(.selfPaidDrug)
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	set selfPaidDrugRowId=+$piece(saveResult,"^",2)
	
	kill drugData
	set drugData("ClassName")="CIS.AN.SelfPaidDrugData"
	set drugData("RowId")=""
	set drugData("RecordSheet")=recordSheetId
	set drugData("SelfPaidDrug")=selfPaidDrugRowId
	set drugData("Specification")=selfPaidDrug("Specification")
	set drugData("Price")=selfPaidDrug("Price")
	set drugData("Qty")=selfPaidDrug("Qty")
	set drugData("Note")=selfPaidDrug("Note")
	set drugData("UpdateUserID")=userId
	set saveResult=##class(CIS.AN.COM.DataService).SaveData(.drugData)
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	
	tcommit
	quit "S^"
Error
	trollback
	quit "E^"_$ze
}

}
