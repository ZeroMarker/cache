/// Description: HISUI DataGrid表格 列配置
/// FileName: User.DHCPEDataGridColsSet
/// Creator: wangguoying
/// Date: 2022-07-11
Class User.DHCPEDataGridColsSet Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_DataGridColsSet ]
{

Parameter ClassName = "User.DHCPEDataGridSet";

Relationship DGSCParRef As User.DHCPEDataGridSet [ Cardinality = parent, Inverse = DGSCols ];

/// 列Field
Property DGSCField As %String [ Required, SqlColumnNumber = 2, SqlFieldName = DGSC_Field ];

/// 列名称
Property DGSCName As %String [ SqlColumnNumber = 3, SqlFieldName = DGSC_Name ];

/// 显示 序号
Property DGSCSort As %Integer [ Required, SqlColumnNumber = 4, SqlFieldName = DGSC_Sort ];

/// 宽度
Property DGSCWidth As %Integer [ SqlColumnNumber = 5, SqlFieldName = DGSC_Width ];

/// 是否显示
Property DGSCVisible As %String(VALUELIST = ",Y,N") [ InitialExpression = "Y", Required, SqlColumnNumber = 6, SqlFieldName = DGSC_Visible ];

/// 冻结列
Property DGSCForzen As %String(VALUELIST = ",Y,N") [ InitialExpression = "N", Required, SqlColumnNumber = 7, SqlFieldName = DGSC_Forzen ];

/// Formatter 格式化函数名称
Property DGSCFormatterFunc As %String [ SqlColumnNumber = 8, SqlFieldName = DGSC_FormatterFunc ];

Index IndOfField On (DGSCParRef, DGSCField) [ Unique ];

Index IndOfSort On (DGSCParRef, DGSCSort);

Storage Default
{
<Data name="DHCPEDataGridColsSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DGSCField</Value>
</Value>
<Value name="3">
<Value>DGSCName</Value>
</Value>
<Value name="4">
<Value>DGSCSort</Value>
</Value>
<Value name="5">
<Value>DGSCWidth</Value>
</Value>
<Value name="6">
<Value>DGSCVisible</Value>
</Value>
<Value name="7">
<Value>DGSCForzen</Value>
</Value>
<Value name="8">
<Value>DGSCFormatterFunc</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("DGSCols")</DataLocation>
<DefaultData>DHCPEDataGridColsSetDefaultData</DefaultData>
<IdLocation>^User.DHCPEDataGridSetC("DGSCols")</IdLocation>
<IndexLocation>^User.DHCPEDataGridColsSetI</IndexLocation>
<StreamLocation>^User.DHCPEDataGridColsSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
