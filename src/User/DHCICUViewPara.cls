Class User.DHCICUViewPara Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_ICU_ViewPara, StorageStrategy = CacheStorage ]
{

Relationship ChildDHCICUViewParaItem As User.DHCICUViewParaItem [ Cardinality = children, Inverse = ICUVPIParref ];

Index Ctloc On ICUVPCtlocDr As Exact;

Index ICUA On ICUVPICUADr As Exact;

Property ICUVPCode As %String [ SqlColumnNumber = 2, SqlFieldName = ICUVP_Code ];

Property ICUVPDesc As %String [ SqlColumnNumber = 3, SqlFieldName = ICUVP_Desc ];

Property ICUVPCtlocDr As %String [ SqlColumnNumber = 4, SqlFieldName = ICUVP_Ctloc_Dr ];

Property ICUVPICUADr As DHCICUArrange [ SqlColumnNumber = 5, SqlFieldName = ICUVP_ICUA_Dr ];

Property ICUVPICUCVSCCode As %String [ SqlColumnNumber = 6, SqlFieldName = ICUVP_ICUCVSCCode ];

Property ICUVPICUCVCCode As %String [ SqlColumnNumber = 7, SqlFieldName = ICUVP_ICUCVCCode ];

Property ICUVPChartInfo As %String [ SqlColumnNumber = 8, SqlFieldName = ICUVP_ChartInfo ];

Property ICUVPChartHeight As %Integer [ SqlColumnNumber = 9, SqlFieldName = ICUVP_ChartHeight ];

Property ICUVPTotalHeight As %Integer [ SqlColumnNumber = 10, SqlFieldName = ICUVP_TotalHeight ];

Property ICUVPBackColor As %String [ SqlColumnNumber = 11, SqlFieldName = ICUVP_BackColor ];

Storage CacheStorage
{
<Data name="DHCICUViewParaClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCICUViewParaDefaultData">
<Value name="1">
<Value>ICUVPCode</Value>
</Value>
<Value name="2">
<Value>ICUVPDesc</Value>
</Value>
<Value name="3">
<Value>ICUVPCtlocDr</Value>
</Value>
<Value name="4">
<Value>ICUVPICUADr</Value>
</Value>
<Value name="5">
<Value>ICUVPICUCVSCCode</Value>
</Value>
<Value name="6">
<Value>ICUVPICUCVCCode</Value>
</Value>
<Value name="7">
<Value>ICUVPChartInfo</Value>
</Value>
<Value name="8">
<Value>ICUVPChartHeight</Value>
</Value>
<Value name="9">
<Value>ICUVPTotalHeight</Value>
</Value>
<Value name="10">
<Value>ICUVPBackColor</Value>
</Value>
</Data>
<DataLocation>^DHCICUViewPara</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCICUViewPara</IdLocation>
<IndexLocation>^DHCICUViewPara(0)</IndexLocation>
<StreamLocation>^User.DHCICUViewParaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
