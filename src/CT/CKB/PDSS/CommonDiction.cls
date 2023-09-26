Class CT.CKB.PDSS.CommonDiction Extends %Persistent [ SqlRowIdName = CD_RowID, SqlTableName = CommonDiction ]
{

/// D ##class(CT.CKB.PDSS.CommonDiction).%BuildIndices()
Property CDCode As %String(MAXLEN = 200) [ SqlColumnNumber = 2, SqlFieldName = CD_Code ];

Property CDDesc As %String(MAXLEN = 200) [ SqlColumnNumber = 3, SqlFieldName = CD_Desc ];

Property CDParrefDr As CT.CKB.PDSS.CommonDiction [ SqlColumnNumber = 4, SqlFieldName = CD_Parref_Dr ];

Property CDLinkDr As CT.CKB.PDSS.CommonDiction [ SqlColumnNumber = 5, SqlFieldName = CD_Link_Dr ];

Storage Default
{
<Data name="CommonDictionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CDCode</Value>
</Value>
<Value name="3">
<Value>CDDesc</Value>
</Value>
<Value name="4">
<Value>CDParrefDr</Value>
</Value>
<Value name="5">
<Value>CDLinkDr</Value>
</Value>
</Data>
<DataLocation>^CT.CKB.PDSS.CommonDictionD</DataLocation>
<DefaultData>CommonDictionDefaultData</DefaultData>
<IdLocation>^CT.CKB.PDSS.CommonDictionD</IdLocation>
<IndexLocation>^CT.CKB.PDSS.CommonDictionI</IndexLocation>
<StreamLocation>^CT.CKB.PDSS.CommonDictionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

Index Code On CDCode As AlphaUp;

Index CodeDesc On (CDCode As AlphaUp, CDDesc As AlphaUp);

Index Desc On CDDesc As AlphaUp;

Index Link On CDLinkDr As Exact;

Index LinkParrefDr On (CDLinkDr As Exact, CDParrefDr As Exact);

Index Parref On CDParrefDr As Exact;

Index ParrefLinkDr On (CDParrefDr As Exact, CDLinkDr As Exact);

}
