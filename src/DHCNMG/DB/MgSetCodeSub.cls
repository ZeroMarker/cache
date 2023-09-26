/// Creator:
/// Descriptions:公共代码子项维护
/// Date:2017-07-27
/// 
Class DHCNMG.DB.MgSetCodeSub Extends %Persistent
{

/// 父表
Relationship Parref As DHCNMG.DB.MgSetCode [ Cardinality = parent, Inverse = ChildSub ];

/// 代码
Property SubCode As %String [ SqlColumnNumber = 2, SqlFieldName = Sub_Code ];

/// 描述
Property SubDesc As %String [ SqlColumnNumber = 3, SqlFieldName = Sub_Desc ];

/// 颜色
Property SubRemark As %String [ SqlColumnNumber = 4, SqlFieldName = Sub_Remark ];

/// 启用日期
Property SubStDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Sub_StDate ];

/// 停用日期
Property SubEndDate As %Date [ SqlColumnNumber = 6, SqlFieldName = Sub_EndDate ];

/// 标识符号
Property SubSymbol As %String [ SqlColumnNumber = 7, SqlFieldName = Sub_Symbol ];

/// 序号
Property SubSort As %Integer [ SqlColumnNumber = 8, SqlFieldName = Sub_Sort ];

Index Code On (Parref, SubCode);

Index Sort On (Parref, SubSort);

Storage Default
{
<Data name="MgSetCodeSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SubCode</Value>
</Value>
<Value name="3">
<Value>SubDesc</Value>
</Value>
<Value name="4">
<Value>SubRemark</Value>
</Value>
<Value name="5">
<Value>SubStatus</Value>
</Value>
<Value name="6">
<Value>SubStDate</Value>
</Value>
<Value name="7">
<Value>SubEndDate</Value>
</Value>
<Value name="8">
<Value>SubSymbol</Value>
</Value>
<Value name="9">
<Value>SubSort</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgSetCodeSubD</DataLocation>
<DefaultData>MgSetCodeSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCNMG.DB.MgSetCodeSubI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgSetCodeSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
