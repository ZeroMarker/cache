/// Creator:
/// Descriptions:系统参数子表
/// Date:
Class CT.DHCINM.Set.MgSysParamSub Extends %Persistent
{

Relationship Parref As CT.DHCINM.Set.MgSysParam [ Cardinality = parent, Inverse = ChildSub ];

/// 代码
Property SubCode As %String [ SqlColumnNumber = 2, SqlFieldName = Sub_Code ];

/// 描述
Property SubDesc As %String [ SqlColumnNumber = 3, SqlFieldName = Sub_Desc ];

/// 值
Property SubValue As %String [ SqlColumnNumber = 4, SqlFieldName = Sub_Value ];

/// 符号
Property SubSymbol As %String [ SqlColumnNumber = 5, SqlFieldName = Sub_Symbol ];

/// 颜色
Property SubColor As %String [ SqlColumnNumber = 6, SqlFieldName = Sub_Color ];

/// 备注
Property SubRemark As %String [ SqlColumnNumber = 7, SqlFieldName = Sub_Remark ];

/// 启用日期
Property SubStDate As %Date [ SqlColumnNumber = 8, SqlFieldName = Sub_StDate ];

/// 停用日期
Property SubEndDate As %Date [ SqlColumnNumber = 9, SqlFieldName = Sub_EndDate ];

/// 序号
Property SubSort As %Integer [ SqlColumnNumber = 10, SqlFieldName = Sub_Sort ];

Index Code On SubCode;

Index Sort On (Parref, SubSort);

Storage Default
{
<Data name="MgSysParamSubDefaultData">
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
<Value>SubValue</Value>
</Value>
<Value name="5">
<Value>SubSymbol</Value>
</Value>
<Value name="6">
<Value>SubColor</Value>
</Value>
<Value name="7">
<Value>SubRemark</Value>
</Value>
<Value name="8">
<Value>SubStDate</Value>
</Value>
<Value name="9">
<Value>SubEndDate</Value>
</Value>
<Value name="10">
<Value>SubSort</Value>
</Value>
</Data>
<DataLocation>^CT.DHCINM.Set.MgSysParamSubD</DataLocation>
<DefaultData>MgSysParamSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^CT.DHCINM.Set.MgSysParamSubI</IndexLocation>
<StreamLocation>^CT.DHCINM.Set.MgSysParamSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
