Class User.NewClass126 Extends %RegisteredObject [ SqlRowIdName = Log_RowId, SqlTableName = PA_TestLog, StorageStrategy = NewStorage1 ]
{

/// 病人RowId
Property LogPersonDr As %String [ SqlColumnNumber = 2, SqlFieldName = Log_Person_Dr ];

/// 值变化字段名
Property LogFiled As %String [ SqlColumnNumber = 3, SqlFieldName = Log_Filed ];

/// 旧值
Property LogOldValue As %String [ SqlFieldName = Log_OldValue ];

/// 新值
Property LogNewValue As %String [ SqlFieldName = Log_NewValue ];

}
