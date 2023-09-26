/// Creator:
/// Descriptions:公共代码维护
/// Date:2017-07-27
/// 
Class DHCNMG.DB.MgSetCode Extends %Persistent
{

Relationship ChildSub As DHCNMG.DB.MgSetCodeSub [ Cardinality = children, Inverse = Parref ];

/// 代码
Property SetCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = Set_Code ];

/// 描述
Property SetDesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = Set_Desc ];

/// 说明
Property SetRemark As %String(MAXLEN = 10000) [ SqlColumnNumber = 4, SqlFieldName = Set_Remark ];

/// 启用状态
Property SetStatus As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = Set_Status ];

Index Code On SetCode [ Unique ];

Storage Default
{
<Data name="MgSetCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SetCode</Value>
</Value>
<Value name="3">
<Value>SetDesc</Value>
</Value>
<Value name="4">
<Value>SetRemark</Value>
</Value>
<Value name="5">
<Value>SetStatus</Value>
</Value>
<Value name="6">
<Value>SetMould</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgSetCodeD</DataLocation>
<DefaultData>MgSetCodeDefaultData</DefaultData>
<IdLocation>^DHCNMG.DB.MgSetCodeD</IdLocation>
<IndexLocation>^DHCNMG.DB.MgSetCodeI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgSetCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
