Class CKB.PDSS.ExtDiction Extends (%Persistent, User.Abstract) [ SqlRowIdName = ED_RowID, SqlTableName = ExtDiction ]
{

/// D ##class(CKB.PDSS.ExtDiction).%BuildIndices()
Property EDCode As %String(MAXLEN = 100) [ SqlColumnNumber = 2, SqlFieldName = ED_Code ];

Property EDDesc As %String(MAXLEN = 100) [ SqlColumnNumber = 3, SqlFieldName = ED_Desc ];

Property EDType As %String [ SqlColumnNumber = 4, SqlFieldName = ED_Type ];

Property EDHospital As %String [ SqlColumnNumber = 5, SqlFieldName = ED_Hospital ];

/// 增加 ED_Parref_Dr qnp 2021/11/18
Property EDParrefDr As %String [ SqlColumnNumber = 6, SqlFieldName = ED_Parref_Dr ];

/// EDDesc中含有厂家,增加计算属性,用于索引
Property EDExtDesc As %String [ Calculated, SqlComputeCode = {set {ED_ExtDesc} = $p({ED_Desc},"||",1)}, SqlComputed, SqlComputeOnChange = EDDesc, SqlFieldName = ED_ExtDesc ];

Index SearchCode On EDCode As Exact;

Index CodeDesc On (EDCode As Exact, EDDesc As Exact);

Index SearchDesc On EDDesc As Exact;

Index Code On (EDHospital As Exact, EDCode As Exact);

Index Desc On (EDHospital As Exact, EDExtDesc As Exact);

Index Parref On EDParrefDr As Exact;

Index Type On (EDHospital As Exact, EDType As Exact);

Storage Default
{
<Data name="ExtDictionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EDCode</Value>
</Value>
<Value name="3">
<Value>EDDesc</Value>
</Value>
<Value name="4">
<Value>EDType</Value>
</Value>
<Value name="5">
<Value>EDHospital</Value>
</Value>
<Value name="6">
<Value>EDParrefDr</Value>
</Value>
<Value name="7">
<Value>EDExtDesc</Value>
</Value>
</Data>
<DataLocation>^CKB.PDSS.ExtDictionD</DataLocation>
<DefaultData>ExtDictionDefaultData</DefaultData>
<IdLocation>^CKB.PDSS.ExtDictionD</IdLocation>
<IndexLocation>^CKB.PDSS.ExtDictionI</IndexLocation>
<StreamLocation>^CKB.PDSS.ExtDictionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
