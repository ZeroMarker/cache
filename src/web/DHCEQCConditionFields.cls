Class web.DHCEQCConditionFields Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// modified by sjh SJH0036 2020-20-13 输出列标题修改
Query GetConditionFields() As %SQLQuery(ROWSPEC = "Hidden:%String,TName:%String:字段,TTableName:%String:表名,TType:%String:字段类型")
{
SELECT CF_RowID TRowID,
	   CF_Name TName,	
	   CF_TableName TTableName,
	   CF_Type TType
	   
FROM sqluser.DHC_EQCConditionFields
}

}
