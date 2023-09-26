/// 基础数据-导管类型
Class User.DHCICUCCatheterCategory Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = DHC_ICUC_CatheterCategory ]
{

/// 代码
Property Code As %String [ Required, SqlColumnNumber = 2 ];

/// 描述
Property Description As %String [ Required, SqlColumnNumber = 3 ];

Storage Default
{
<Data name="DHCICUCCatheterCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^User.DHCICUCCatheterCategoryD</DataLocation>
<DefaultData>DHCICUCCatheterCategoryDefaultData</DefaultData>
<IdLocation>^User.DHCICUCCatheterCategoryD</IdLocation>
<IndexLocation>^User.DHCICUCCatheterCategoryI</IndexLocation>
<StreamLocation>^User.DHCICUCCatheterCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
