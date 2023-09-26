/// DHCWL_ComplexRpt.StatItem
/// d ##class(DHCWL.ComplexRpt.StatItem).%BuildIndices()
/// 统计项或统计内容表
Class DHCWL.ComplexRpt.StatItem Extends %Persistent [ ClassType = persistent, SqlTableName = StatItem ]
{

/// 代码
Property StCode As %String(MAXLEN = 100) [ SqlColumnNumber = 2, SqlFieldName = St_Code ];

/// 描述
Property StDesc As %String(MAXLEN = 150) [ SqlColumnNumber = 3, SqlFieldName = St_Desc ];

/// 类型
Property StType As %String(MAXLEN = 2) [ SqlColumnNumber = 4, SqlFieldName = St_Type ];

/// 关联维度
Property StDimDr As DHCWL.MKPI.MKPIDimType [ SqlColumnNumber = 5, SqlFieldName = St_DimDr ];

/// WL字段值
Property StWorkLoad As %String [ SqlColumnNumber = 6, SqlFieldName = St_WorkLoad ];

/// 执行代码
Property StExcCode As %String(MAXLEN = 250) [ SqlColumnNumber = 7, SqlFieldName = St_ExcCode ];

/// 有效标识
Property StFlag As %String(MAXLEN = 2) [ SqlColumnNumber = 8, SqlFieldName = St_Flag ];

/// 更新时间
Property StUpdateDate As %String [ SqlColumnNumber = 9, SqlFieldName = St_UpdateDate ];

/// 分类标识
Property StStatisFlag As %String(MAXLEN = 100) [ SqlColumnNumber = 10, SqlFieldName = St_StatisListFlag ];

/// 备注
Property StRemark As %String [ SqlColumnNumber = 11, SqlFieldName = St_Remark ];

Index StCode On StCode;

Index StType On StType;

Index StFlag On StFlag;

Index StStatisFlag On StStatisFlag;

//As AlphaUp;

Index StDimDr On StDimDr;

Storage Default
{
<Data name="StatItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StCode</Value>
</Value>
<Value name="3">
<Value>StDesc</Value>
</Value>
<Value name="4">
<Value>StType</Value>
</Value>
<Value name="5">
<Value>StDimDr</Value>
</Value>
<Value name="6">
<Value>StWorkLoad</Value>
</Value>
<Value name="7">
<Value>StExcCode</Value>
</Value>
<Value name="8">
<Value>StFlag</Value>
</Value>
<Value name="9">
<Value>StUpdateDate</Value>
</Value>
<Value name="10">
<Value>StStatisFlag</Value>
</Value>
<Value name="11">
<Value>StRemark</Value>
</Value>
</Data>
<DataLocation>^DHCWL.ComplexRpt.StatItemD</DataLocation>
<DefaultData>StatItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.ComplexRpt.StatItemD</IdLocation>
<IndexLocation>^DHCWL.ComplexRpt.StatItemI</IndexLocation>
<StreamLocation>^DHCWL.ComplexRpt.StatItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
