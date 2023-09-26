/// 基础数据类型
Class User.CSSDBaseDataType Extends (%Persistent, User.Abstract) [ SqlTableName = CSSD_BaseDataType ]
{

Property CSSDBDTCode As %String(COLLATION = "Exact") [ SqlColumnNumber = 2, SqlFieldName = CSSDBDT_Code ];

Property CSSDBDTName As %String(COLLATION = "Exact") [ SqlColumnNumber = 3, SqlFieldName = CSSDBDT_Name ];

/// Y-基础数据, C-应用模块(用于参数)
Property CSSDBDTRemark As %String(COLLATION = "Exact") [ SqlColumnNumber = 4, SqlFieldName = CSSDBDT_Remark ];

Index IndexCode On (CSSDBDTRemark As Exact, CSSDBDTCode As Exact);

Index Code On CSSDBDTCode As Exact;

Storage Default
{
<Data name="CSSDBaseDataTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDBDTCode</Value>
</Value>
<Value name="3">
<Value>CSSDBDTName</Value>
</Value>
<Value name="4">
<Value>CSSDBDTRemark</Value>
</Value>
</Data>
<DataLocation>^User.CSSDBaseDataTypeD</DataLocation>
<DefaultData>CSSDBaseDataTypeDefaultData</DefaultData>
<IdLocation>^User.CSSDBaseDataTypeD</IdLocation>
<IndexLocation>^User.CSSDBaseDataTypeI</IndexLocation>
<StreamLocation>^User.CSSDBaseDataTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
