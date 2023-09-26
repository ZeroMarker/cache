/// Creator:
/// Descriptions:公共代码子表
/// Date:
Class CT.DHCINM.DB.MgSetCodeSub Extends %Persistent
{

/// 父表
Relationship Parref As CT.DHCINM.DB.MgSetCode [ Cardinality = parent, Inverse = ChildSub ];

/// 代码
Property SubCode As %String [ SqlColumnNumber = 2, SqlFieldName = Sub_Code ];

/// 描述
Property SubDesc As %String(MAXLEN = 1000) [ SqlColumnNumber = 3, SqlFieldName = Sub_Desc ];

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

/// 附属标识[人员一览表中过滤不显示的]
Property subFiterSymbol As %String [ SqlColumnNumber = 9, SqlFieldName = sub_FiterSymbol ];

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
<Value>SubStDate</Value>
</Value>
<Value name="6">
<Value>SubEndDate</Value>
</Value>
<Value name="7">
<Value>SubSymbol</Value>
</Value>
<Value name="8">
<Value>SubSort</Value>
</Value>
<Value name="9">
<Value>subFiterSymbol</Value>
</Value>
</Data>
<DataLocation>^CT.DHCINM.DB.MgSetCodeSubD</DataLocation>
<DefaultData>MgSetCodeSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^CT.DHCINM.DB.MgSetCodeSubI</IndexLocation>
<StreamLocation>^CT.DHCINM.DB.MgSetCodeSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
