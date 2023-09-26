/// 清点合格率主表
Class User.CSSDUsedPrdo Extends (%Persistent, User.Abstract) [ SqlTableName = CSSD_UsedPredo ]
{

Property CSSDUPNo As %String(COLLATION = "Exact") [ SqlColumnNumber = 2, SqlFieldName = CSSDUP_No ];

Property CSSDUPLoc As CTLoc [ SqlColumnNumber = 3, SqlFieldName = CSSDUP_Loc ];

Property CSSDUPDt As %TimeStamp [ SqlColumnNumber = 4, SqlFieldName = CSSDUP_Dt ];

Property CSSDUPRegister As SSUser [ SqlColumnNumber = 5, SqlFieldName = CSSDUP_Register ];

/// 单据状态：0-未确认 、1-确认
Property CSSDSPStatus As %String(COLLATION = "Exact") [ SqlColumnNumber = 6, SqlFieldName = CSSDUP_Status ];

/// 清洗批号
Property CSSDUPCleanNo As %String(COLLATION = "Exact") [ SqlColumnNumber = 7, SqlFieldName = CSSDUP_CleanNo ];

/// 不合格日期
Property CSSDUPDate As %Library.Date [ SqlColumnNumber = 8, SqlFieldName = CSSDUP_Date ];

/// 不合格时间
Property CSSDUPTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = CSSDUP_Time ];

/// 清洗单ID
Property CSSDUPCleanDr As User.CSSDClean [ SqlColumnNumber = 10, SqlFieldName = CSSDUP_Clean_Dr ];

Index IndexCSSDUPCleanNo On CSSDUPCleanNo As Exact;

Index CSSDUPDateIndex On CSSDUPDate As Exact;

Index IndexClean On CSSDUPCleanDr As Exact;

Index IndexStatusClean On (CSSDSPStatus As Exact, CSSDUPCleanDr As Exact);

Index IndexCleanStatus On (CSSDUPCleanDr As Exact, CSSDSPStatus As Exact);

Storage Default
{
<Data name="CSSDUsedPrdoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDUPNo</Value>
</Value>
<Value name="3">
<Value>CSSDUPLoc</Value>
</Value>
<Value name="4">
<Value>CSSDUPDt</Value>
</Value>
<Value name="5">
<Value>CSSDUPRegister</Value>
</Value>
<Value name="6">
<Value>CSSDSPStatus</Value>
</Value>
<Value name="7">
<Value>CSSDUPCleanNo</Value>
</Value>
<Value name="8">
<Value>CSSDUPDate</Value>
</Value>
<Value name="9">
<Value>CSSDUPTime</Value>
</Value>
<Value name="10">
<Value>CSSDUPCleanDr</Value>
</Value>
</Data>
<DataLocation>^User.CSSDUsedPrdoD</DataLocation>
<DefaultData>CSSDUsedPrdoDefaultData</DefaultData>
<IdLocation>^User.CSSDUsedPrdoD</IdLocation>
<IndexLocation>^User.CSSDUsedPrdoI</IndexLocation>
<StreamLocation>^User.CSSDUsedPrdoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
