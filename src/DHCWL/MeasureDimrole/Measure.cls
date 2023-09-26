/// 表名：DHCWL_MeasureDimrole.DHCWLMeasure 
/// global:^DHCWL.MeasureDimrole.MeasureD    ^DHCWL.MeasureDimrole.MeasureI
/// 维度角色
Class DHCWL.MeasureDimrole.Measure Extends %Persistent [ SqlTableName = DHCWLMeasure ]
{

/// 编码
Property MeaCode As %String [ SqlColumnNumber = 2, SqlFieldName = Mea_Code ];

/// 描述
Property MeaDesc As %String [ SqlColumnNumber = 3, SqlFieldName = Mea_Desc ];

/// 数据源
Property MeaDataSource As %String [ SqlColumnNumber = 4, SqlFieldName = Mea_DataSource ];

/// 计算项
Property MeasureCalItem As %String(MAXLEN = 100) [ SqlColumnNumber = 5, SqlFieldName = Measure_CalItem ];

/// 统计口径
Property MeaStaCal As %String [ SqlColumnNumber = 6, SqlFieldName = Mea_StaCal ];

/// 创建/修改时间
Property MeaCreateDate As %Date [ SqlColumnNumber = 7, SqlFieldName = Mea_CreateDate ];

/// 创建人
Property MeaCreateUse As %String [ SqlColumnNumber = 8, SqlFieldName = Mea_CreateUse ];

/// 是否作废
Property MeaVoidFlag As %String [ SqlColumnNumber = 9, SqlFieldName = Mea_VoidFlag ];

/// 数据源包名
Property MeaPackName As %String [ SqlColumnNumber = 10, SqlFieldName = Mea_PackName ];

/// 数据源描述
Property MeaDsDesc As %String [ SqlColumnNumber = 11, SqlFieldName = Mea_DsDesc ];

/// 统计口径描述
Property MeaStaDesc As %String [ SqlColumnNumber = 12, SqlFieldName = Mea_StaDesc ];

/// 计算项描述
Property MeaCalDesc As %String [ SqlColumnNumber = 13, SqlFieldName = Mea_CalDesc ];

Index DataSource On MeaDataSource;

Index Code On MeaCode;

Storage Default
{
<Data name="MeasureDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MeaCode</Value>
</Value>
<Value name="3">
<Value>MeaDesc</Value>
</Value>
<Value name="4">
<Value>MeaDataSource</Value>
</Value>
<Value name="5">
<Value>MeasureCalItem</Value>
</Value>
<Value name="6">
<Value>MeaStaCal</Value>
</Value>
<Value name="7">
<Value>MeaCreateDate</Value>
</Value>
<Value name="8">
<Value>MeaCreateUse</Value>
</Value>
<Value name="9">
<Value>MeaVoidFlag</Value>
</Value>
<Value name="10">
<Value>MeaPackName</Value>
</Value>
<Value name="11">
<Value>MeaDsDesc</Value>
</Value>
<Value name="12">
<Value>MeaStaDesc</Value>
</Value>
<Value name="13">
<Value>MeaCalDesc</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MeasureDimrole.MeasureD</DataLocation>
<DefaultData>MeasureDefaultData</DefaultData>
<IdLocation>^DHCWL.MeasureDimrole.MeasureD</IdLocation>
<IndexLocation>^DHCWL.MeasureDimrole.MeasureI</IndexLocation>
<StreamLocation>^DHCWL.MeasureDimrole.MeasureS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
