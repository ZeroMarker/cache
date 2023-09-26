/// 术语分类表（树形）：User.TKBTremBaseCat
Class User.TKBTremBaseCat Extends %Persistent [ SqlRowIdName = TKBTBC_RowId, SqlTableName = TKB_TremBaseCat ]
{

Property TKBTBCCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = TKBTBC_Code ];

Property TKBTBCDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = TKBTBC_Desc ];

Property TKBTBCLastLevel As User.TKBTremBaseCat [ SqlColumnNumber = 4, SqlFieldName = TKBTBC_LastLevel ];

Property TKBTBCLevel As %String [ SqlColumnNumber = 5, SqlFieldName = TKBTBC_Level ];

Property TKBTBCRemark As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = TKBTBC_Remark ];

Property TKBTBCActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = TKBTBC_ActiveFlag ];

Property TKBTBCText1 As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = TKBTBC_Text1 ];

Index CodeIndex On TKBTBCCode [ Unique ];

Index DescIndex On TKBTBCDesc [ Unique ];

Index ParCatIdx On TKBTBCLastLevel;

/// 父菜单+顺序生成的索引
Index ParSeqIdx On (TKBTBCLastLevel, TKBTBCLevel);

Storage Default
{
<Data name="TKBTremBaseCatDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TKBTBCCode</Value>
</Value>
<Value name="3">
<Value>TKBTBCDesc</Value>
</Value>
<Value name="4">
<Value>TKBTBCLastLevel</Value>
</Value>
<Value name="5">
<Value>TKBTBCLevel</Value>
</Value>
<Value name="6">
<Value>TKBTBCRemark</Value>
</Value>
<Value name="7">
<Value>TKBTBCActiveFlag</Value>
</Value>
<Value name="8">
<Value>TKBTBCText1</Value>
</Value>
</Data>
<DataLocation>^User.TKBTremBaseCatD</DataLocation>
<DefaultData>TKBTremBaseCatDefaultData</DefaultData>
<IdLocation>^User.TKBTremBaseCatD</IdLocation>
<IndexLocation>^User.TKBTremBaseCatI</IndexLocation>
<StreamLocation>^User.TKBTremBaseCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
