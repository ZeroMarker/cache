Class User.DHCICUViewParaItem Extends %Persistent [ ProcedureBlock, SqlTableName = DHC_ICU_ViewParaItem, StorageStrategy = CacheStorage ]
{

Relationship ICUVPIParref As User.DHCICUViewPara [ Cardinality = parent, Inverse = ChildDHCICUViewParaItem, SqlFieldName = ICUVPI_Parref ];

Property ICUVPICode As %String [ SqlColumnNumber = 2, SqlFieldName = ICUVPI_Code ];

Property ICUVPIDesc As %String [ SqlColumnNumber = 3, SqlFieldName = ICUVPI_Desc ];

Property ICUVPIICUCVCCode As %String [ SqlColumnNumber = 4, SqlFieldName = ICUVPI_ICUCVCCode ];

Property ICUVPIRecordItemCode As %String [ SqlColumnNumber = 5, SqlFieldName = ICUVPI_RecordItemCode ];

Property ICUVPIArcimCode As %String [ SqlColumnNumber = 6, SqlFieldName = ICUVPI_Arcim_Dr ];

Property ICUVPIStandardTestCode As %String [ SqlColumnNumber = 7, SqlFieldName = ICUVPI_StandardTestCode ];

Property ICUVPIMainViewParaItemCode As %String [ SqlColumnNumber = 8, SqlFieldName = ICUVPI_MainViewParaItemCode ];

Property ICUVPIType As %String(DISPLAYLIST = ",Drug,VitalSign,Event,Therapy,Lab", MAXLEN = 9, SELECTIVITY = "16.6667%", TRUNCATE = 1, VALUELIST = ",D,V,E,T,L") [ SqlColumnNumber = 9, SqlFieldName = ICUVPI_Type ];

Property ICUVPIYaxisInfoCode As %String [ SqlColumnNumber = 10, SqlFieldName = ICUVPI_YaxisInfoCode ];

Property ICUVPIFontCode As %String [ SqlColumnNumber = 11, SqlFieldName = ICUVPI_FontCode ];

Property ICUVPIPenWidth As %Float [ SqlColumnNumber = 12, SqlFieldName = ICUVPI_PenWidth ];

Property ICUVPIPenColor As %String [ SqlColumnNumber = 13, SqlFieldName = ICUVPI_PenColor ];

Property ICUVPIBrushColor As %String [ SqlColumnNumber = 14, SqlFieldName = ICUVPI_BrushColor ];

Property ICUVPIIsDrawLine As %Boolean [ SqlColumnNumber = 15, SqlFieldName = ICUVPI_IsDrawLine ];

Property ICUVPIIsDrawIcon As %Boolean [ SqlColumnNumber = 16, SqlFieldName = ICUVPI_IsDrawIcon ];

Property ICUVPIFillPathMode As %String(DISPLAYLIST = ",Self,BaseY,RecordItem", MAXLEN = 10, SELECTIVITY = "25.0%", TRUNCATE = 1, VALUELIST = ",S,B,R") [ SqlColumnNumber = 17, SqlFieldName = ICUVPI_FillPathMode ];

Property ICUVPIClosedRecordItemCode As %String [ SqlColumnNumber = 18, SqlFieldName = ICUVPI_ClosedRecordItemCode ];

Property ICUVPIDataDisplayMode As %String [ SqlColumnNumber = 19, SqlFieldName = ICUVPI_DataDisplayMode ];

Storage CacheStorage
{
<Data name="DHCICUViewParaItemClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCICUViewParaItemDefaultData">
<Value name="1">
<Value>ICUVPICode</Value>
</Value>
<Value name="2">
<Value>ICUVPIDesc</Value>
</Value>
<Value name="3">
<Value>ICUVPIICUCVCCode</Value>
</Value>
<Value name="4">
<Value>ICUVPIRecordItemCode</Value>
</Value>
<Value name="5">
<Value>ICUVPIArcimCode</Value>
</Value>
<Value name="6">
<Value>ICUVPIStandardTestCode</Value>
</Value>
<Value name="7">
<Value>ICUVPIMainViewParaItemCode</Value>
</Value>
<Value name="8">
<Value>ICUVPIType</Value>
</Value>
<Value name="9">
<Value>ICUVPIYaxisInfoCode</Value>
</Value>
<Value name="10">
<Value>ICUVPIFontCode</Value>
</Value>
<Value name="11">
<Value>ICUVPIPenWidth</Value>
</Value>
<Value name="12">
<Value>ICUVPIPenColor</Value>
</Value>
<Value name="13">
<Value>ICUVPIBrushColor</Value>
</Value>
<Value name="14">
<Value>ICUVPIIsDrawLine</Value>
</Value>
<Value name="15">
<Value>ICUVPIIsDrawIcon</Value>
</Value>
<Value name="16">
<Value>ICUVPIFillPathMode</Value>
</Value>
<Value name="17">
<Value>ICUVPIClosedRecordItemCode</Value>
</Value>
<Value name="18">
<Value>ICUVPIDataDisplayMode</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("I")</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("I")</IdLocation>
<IndexLocation>{%%PARENT}("I",0)</IndexLocation>
<StreamLocation>^User.DHCICUViewParaItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
