/// 基础数据-导管置入位置
Class User.DHCICUCCatheterPos Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = DHC_ICUC_CatheterPos ]
{

/// 代码
Property Code As %String [ Required, SqlColumnNumber = 2 ];

/// 描述
Property Description As %String [ Required, SqlColumnNumber = 3 ];

Storage Default
{
<Data name="DHCICUCCatheterPosDefaultData">
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
<DataLocation>^User.DHCICUCCatheterPosD</DataLocation>
<DefaultData>DHCICUCCatheterPosDefaultData</DefaultData>
<IdLocation>^User.DHCICUCCatheterPosD</IdLocation>
<IndexLocation>^User.DHCICUCCatheterPosI</IndexLocation>
<StreamLocation>^User.DHCICUCCatheterPosS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
