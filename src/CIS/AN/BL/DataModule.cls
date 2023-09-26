/// 数据模块业务类
Class CIS.AN.BL.DataModule Extends %RegisteredObject
{

/// w ##class(CIS.AN.BL.DataModule).GetDataModuleID("AN_OPS_001")
ClassMethod GetDataModuleID(dataModuleCode As %String) As %String
{
	set ret=$o(^CT.AN.DataModuleI("ICode"," "_$System.SQL.UPPER(dataModuleCode),0))
	quit ret
}

ClassMethod GetModuleIDByArchiveCode(archiveCode As %String) As %String
{
	set moduleID=""
	&sql(select RowId into :moduleID from CT_AN.DataModule where ArchiveCode=:archiveCode)
	quit moduleID
}

}
