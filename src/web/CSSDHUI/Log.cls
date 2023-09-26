Import sqluser

/// Descript:	数据修改日志记录
/// Creator:	lxt
/// CreateDate:	20220530
Class web.CSSDHUI.Log Extends (%RegisteredObject, CSSDType) [ ProcedureBlock ]
{

/// 参数和##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther保持一致
/// 入参说明:OperateType为"A"(新增)-NewValue、OldValue均不需要传递; OperateType为"D"(删除)、"U"(更新)-OldValue不需要传递; 
/// w ##class(web.CSSDHUI.Log).SaveLog("","","","","","","","")
ClassMethod SaveLog(TableName As %String, ClassName As %String, ClassNameDesc As %String, ObjectReference As %String, ObjectDesc As %String, OperateType As %String, NewValue As %String = "", OldValue As %String = "") As RtnObj
{
	s RtnObj=##class(RtnObj).%New()
	i (NewValue="")&&(ObjectReference'="")&&(OperateType'="D") d
	.s NewValue=##class(web.CSSDHUI.Common.JsonObj).GetValue(TableName,ObjectReference)
	s Table=..GetTableName(ClassName)
	s:Table="" Table=TableName
	s LevelStart=$TLEVEL
	
	try{
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther(Table,ClassName,ClassNameDesc,ObjectReference,ObjectDesc,OperateType,NewValue,OldValue)
	}catch{}
	
	s LevelEnd=$TLEVEL
	i LevelStart'=LevelEnd d RtnObj.Err(-1,"","记录基础数据日志失败！")
	q RtnObj
}

/// Descript:根据User类名获取表名TableName
/// Creator:lxt
/// CreateDate:20220530
/// w ##class(web.CSSDHUI.Log).GetTableName("User.PHManufacturer")
ClassMethod GetTableName(ClassName As %String) As %String
{
	q:ClassName="" ""
	s TableName=""
	try{
		s obj=##class(%Dictionary.ClassDefinition).%OpenId(ClassName)
		s TableName=obj.SqlTableName
	}catch{}
	q TableName
}

}
