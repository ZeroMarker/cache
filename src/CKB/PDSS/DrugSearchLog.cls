Class CKB.PDSS.DrugSearchLog Extends (%Persistent, User.Abstract) [ SqlRowIdName = DSL_RowID, SqlTableName = DrugSearchLog ]
{

/// 药品
Property DSLDicID As CT.CKB.PDSS.CommonDiction [ SqlColumnNumber = 2, SqlFieldName = DSL_DicID ];

/// 操作日期  
Property DSLDate As %Library.Date [ SqlColumnNumber = 3, SqlFieldName = DSL_Date ];

/// 操作时间  
Property DSLTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = DSL_Time ];

/// 操作人
Property DSLOperator As %String(MAXLEN = 100) [ SqlColumnNumber = 5, SqlFieldName = DSL_Operator ];

/// 科室
Property DSLLoc As %String(MAXLEN = 1000) [ SqlColumnNumber = 6, SqlFieldName = DSL_Loc ];

/// 医院
Property DSLHospID As %String(MAXLEN = 100) [ SqlColumnNumber = 7, SqlFieldName = DSL_HospID ];

Index IndexHosp On (DSLDicID As Exact, DSLHospID As Exact);

Storage Default
{
<Data name="DrugSearchLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DSLDicID</Value>
</Value>
<Value name="3">
<Value>DSLDate</Value>
</Value>
<Value name="4">
<Value>DSLTime</Value>
</Value>
<Value name="5">
<Value>DSLOperator</Value>
</Value>
<Value name="6">
<Value>DSLLoc</Value>
</Value>
<Value name="7">
<Value>DSLHospID</Value>
</Value>
</Data>
<DataLocation>^CKB.PDSS.DrugSearchLogD</DataLocation>
<DefaultData>DrugSearchLogDefaultData</DefaultData>
<IdLocation>^CKB.PDSS.DrugSearchLogD</IdLocation>
<IndexLocation>^CKB.PDSS.DrugSearchLogI</IndexLocation>
<StreamLocation>^CKB.PDSS.DrugSearchLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
