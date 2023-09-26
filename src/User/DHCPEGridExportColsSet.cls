/// Description: HISUI DataGrid表格导出 列配置
/// FileName: User.DHCPEGridExportColsSet
/// Creator: wangguoying
/// Date: 2022-07-11
Class User.DHCPEGridExportColsSet Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_GridExportColsSet ]
{

Parameter ClassName = "User.DHCPEGridExportColsSet";

Relationship GESCParRef As User.DHCPEGridExportSet [ Cardinality = parent, Inverse = GESCols ];

/// 列Field
Property GESCField As %String [ Required, SqlColumnNumber = 2, SqlFieldName = GESC_Field ];

/// 列名称
Property GESCName As %String [ SqlColumnNumber = 3, SqlFieldName = GESC_Name ];

/// 导出 顺序号
Property GESCSort As %Integer [ Required, SqlColumnNumber = 4, SqlFieldName = GESC_Sort ];

/// 宽度
Property GESCWidth As %Integer [ SqlColumnNumber = 5, SqlFieldName = GESC_Width ];

/// 是否导出
Property GESCVisible As %String(VALUELIST = ",Y,N") [ InitialExpression = "Y", Required, SqlColumnNumber = 6, SqlFieldName = GESC_Visible ];

/// 导出列名
Property GESCExportName As %String [ SqlColumnNumber = 7, SqlFieldName = GESC_ExportName ];

/// 格式  S：文本  N：数字  D：日期
Property GESCStyle As %String(VALUELIST = ",S,N,D") [ InitialExpression = "S", Required, SqlColumnNumber = 8, SqlFieldName = GESC_Style ];

/// 垂直对齐方式  B：底部  C：中间  T：顶部
Property GESCVAlign As %String(VALUELIST = ",BOTTOM,CENTER,TOP") [ InitialExpression = "BOTTOM", Required, SqlColumnNumber = 9, SqlFieldName = GESC_VAlig ];

/// 水平对齐方式  L：左  C：中间  R：右
Property GESCHAlign As %String(VALUELIST = ",LEFT,CENTER,RIGHT") [ InitialExpression = "CENTER", Required, SqlColumnNumber = 10, SqlFieldName = GESC_HAlig ];

/// 自动换行
Property GESCAutoWrap As %String(VALUELIST = ",Y,N") [ InitialExpression = "N", Required, SqlColumnNumber = 11, SqlFieldName = GESC_AutoWrap ];

/// Formatter 格式化函数名称
Property GESCFormatterFunc As %String [ SqlColumnNumber = 12, SqlFieldName = GESC_FormatterFunc ];

Index IndOfField On (GESCParRef, GESCField) [ Unique ];

Index IndOfSort On (GESCParRef, GESCSort);

Storage Default
{
<Data name="DHCPEGridExportColsSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GESCField</Value>
</Value>
<Value name="3">
<Value>GESCName</Value>
</Value>
<Value name="4">
<Value>GESCSort</Value>
</Value>
<Value name="5">
<Value>GESCWidth</Value>
</Value>
<Value name="6">
<Value>GESCVisible</Value>
</Value>
<Value name="7">
<Value>GESCExportName</Value>
</Value>
<Value name="8">
<Value>GESCStyle</Value>
</Value>
<Value name="9">
<Value>GESCVAlign</Value>
</Value>
<Value name="10">
<Value>GESCHAlign</Value>
</Value>
<Value name="11">
<Value>GESCAutoWrap</Value>
</Value>
<Value name="12">
<Value>GESCFormatterFunc</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("GESCols")</DataLocation>
<DefaultData>DHCPEGridExportColsSetDefaultData</DefaultData>
<IdLocation>^User.DHCPEGridExportSetC("GESCols")</IdLocation>
<IndexLocation>^User.DHCPEGridExportColsSetI</IndexLocation>
<StreamLocation>^User.DHCPEGridExportColsSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
