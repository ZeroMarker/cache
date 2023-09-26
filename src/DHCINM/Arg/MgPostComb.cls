/// Creater:wangpf
/// Descriptions:班次模板套
/// Date:2021-09-23
Class DHCINM.Arg.MgPostComb Extends %Persistent
{

/// 名称
Property CombDesc As %String [ SqlColumnNumber = 2, SqlFieldName = Comb_Desc ];

/// 病区
Property CombWard As CF.DHCINM.DB.MgWard [ SqlColumnNumber = 3, SqlFieldName = Comb_Ward ];

/// 班次
Property CombPost As list Of %String [ SqlColumnNumber = 4, SqlFieldName = Comb_Post ];

/// 启用日期
Property CombStDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Comb_StDate ];

/// 停用日期
Property CombEndDate As %Date [ SqlColumnNumber = 6, SqlFieldName = Comb_EndDate ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 7, SqlFieldName = Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 8, SqlFieldName = CreateDate ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 9, SqlFieldName = CreateTime ];

Index Ward On CombWard;

Storage Default
{
<Data name="MgPostCombDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CombDesc</Value>
</Value>
<Value name="3">
<Value>CombWard</Value>
</Value>
<Value name="4">
<Value>CombPost</Value>
</Value>
<Value name="5">
<Value>CombStDate</Value>
</Value>
<Value name="6">
<Value>CombEndDate</Value>
</Value>
<Value name="7">
<Value>Creator</Value>
</Value>
<Value name="8">
<Value>CreateDate</Value>
</Value>
<Value name="9">
<Value>CreateTime</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Arg.MgPostCombD</DataLocation>
<DefaultData>MgPostCombDefaultData</DefaultData>
<IdLocation>^DHCINM.Arg.MgPostCombD</IdLocation>
<IndexLocation>^DHCINM.Arg.MgPostCombI</IndexLocation>
<StreamLocation>^DHCINM.Arg.MgPostCombS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
