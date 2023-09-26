/// 手术状态业务类
Class CIS.AN.BL.OperStatus Extends %RegisteredObject
{

/// Creator：        陈长青
/// CreatDate：      2017-03-13
/// Description：    根据代码获取手术状态的ID
/// Table：          DHCAN.OperStatus
/// Input：          statusCode:手术状态代码
/// Return：         手术状态ID
/// Debug:          w ##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Application")
ClassMethod GetStatusIDByCode(statusCode As %String) As %String
{
    set result=""
    set query=##class(%ResultSet).%New("CIS.AN.BL.CodeQueries:FindOperStatus")
    set sc=query.Execute(statusCode)
    while(query.%Next())
    {
        set result=query.Get("RowId")   
    }
    quit result
}

/// w ##class(CIS.AN.BL.OperStatus).GetInstance("Application")
ClassMethod GetInstance(statusCode As %String) As CT.AN.OperStatus
{
	set rowId=$O(^CT.AN.OperStatusI("ICode"," "_$ZCVT(statusCode,"U"),""))
	if ##class(CT.AN.OperStatus).%ExistsId(rowId) quit ##class(CT.AN.OperStatus).%OpenId(rowId)
	
	quit ""
}

/// w ##class(CIS.AN.BL.OperStatus).ExistsInstance("Application")
ClassMethod ExistsInstance(statusCode As %String) As %Boolean
{
	set rowId=$O(^CT.AN.OperStatusI("ICode"," "_$ZCVT(statusCode,"U"),""))
	if ##class(CT.AN.OperStatus).%ExistsId(rowId) quit 1
	
	quit 0
}

}
