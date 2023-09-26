Class CIS.AN.BL.UserDefDataItem Extends %RegisteredObject
{

/// Creator：      	雍阳
/// CreatDate：    	2018-09-19
/// Description： 	保存自定义项目
/// Table：        	CIS_AN.ParaItem
/// Input:			recordSheetID:表单ID,dataCategoryID:数据分类ID,userDefinedItemID:自定义项目ID
/// Return：       	"S^"成功，"E^"错误
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).SaveUserDefDataItem(1,"2020-12-08")
ClassMethod SaveExpireDate(rowId As %String, expireDate As %String) As %String
{
	quit:(##class(CF.AN.UserDefDataItem).%ExistsId(rowId)=0) "E^自定义项目不存在！"
	
	tstart
	kill savingObj
	set savingObj("ClassName")="CF.AN.UserDefDataItem"
	set savingObj("RowId")=rowId
	set savingObj("ExpireDate")=expireDate
	
	set saveResult=##class(CIS.AN.COM.DataService).SaveData(.savingObj)
	
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	tcommit
	quit "S^"
}

}
