/// Creator:
/// Descriptions:公共代码主表
/// Date:
Class CT.DHCINM.DB.MgSetCode Extends %Persistent
{

Relationship ChildSub As CT.DHCINM.DB.MgSetCodeSub [ Cardinality = children, Inverse = Parref ];

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
</Data>
<DataLocation>^CT.DHCINM.DB.MgSetCodeD</DataLocation>
<DefaultData>MgSetCodeDefaultData</DefaultData>
<IdLocation>^CT.DHCINM.DB.MgSetCodeD</IdLocation>
<IndexLocation>^CT.DHCINM.DB.MgSetCodeI</IndexLocation>
<StreamLocation>^CT.DHCINM.DB.MgSetCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
