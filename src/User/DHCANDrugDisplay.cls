Class User.DHCANDrugDisplay Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ANDG_RowId, SqlTableName = DHC_AN_DrugDisplay, StorageStrategy = CacheStorage ]
{

Property ANDGCode As %String [ SqlColumnNumber = 2, SqlFieldName = ANDG_Code ];

Property ANDGDesc As %String [ SqlColumnNumber = 3, SqlFieldName = ANDG_Desc ];

Property ANDGOPADr As DHCANOPArrange [ SqlColumnNumber = 4, SqlFieldName = ANDG_OPA_Dr ];

Property ANDGUseFlag As %String(DISPLAYLIST = ",Yes,No", SELECTIVITY = "33.33330%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = ANDG_UseFlag ];

Property ANDGDefult As %String(DISPLAYLIST = ",Yes,No", SELECTIVITY = "33.33330%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = ANDG_Defult ];

Property ANDGDoseQty As %String(DISPLAYLIST = ",Yes,No", SELECTIVITY = "33.33330%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = ANDG_DoseQty ];

Property ANDGDoseUom As %String(DISPLAYLIST = ",Yes,No", SELECTIVITY = "33.33330%", VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = ANDG_DoseUom ];

Property ANDGSpeed As %String(DISPLAYLIST = ",Yes,No", SELECTIVITY = "33.33330%", VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = ANDG_Speed ];

Property ANDGSpeedUom As %String(DISPLAYLIST = ",Yes,No", SELECTIVITY = "33.33330%", VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = ANDG_SpeedUom ];

Property ANDGInstructor As %String(DISPLAYLIST = ",Yes,No", SELECTIVITY = "33.33330%", VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = ANDG_Instructor ];

Property ANDGDensity As %String(DISPLAYLIST = ",Yes,No", SELECTIVITY = "33.33330%", VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = ANDG_Density ];

Property ANDGAdminSite As %String(DISPLAYLIST = ",Yes,No", SELECTIVITY = "33.33330%", VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = ANDG_AdminSite ];

Property ANDGDrugReason As %String(DISPLAYLIST = ",Yes,No", SELECTIVITY = "33.33330%", VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = ANDG_DrugReason ];

Property ANDGDisplayType As %String(DISPLAYLIST = ",Category,SubCategory,Drug", SELECTIVITY = "25.00000%", VALUELIST = ",C,S,D") [ SqlColumnNumber = 15, SqlFieldName = ANDG_DisplayType ];

Property ANDGDrugDesc As %String(DISPLAYLIST = ",Yes,No", SELECTIVITY = "33.33330%", VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = ANDG_DrugDesc ];

Index Code On ANDGCode As Exact;

Storage CacheStorage
{
<Data name="DHCANDrugDisplayClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCANDrugDisplayDefaultData">
<Value name="1">
<Value>ANDGCode</Value>
</Value>
<Value name="2">
<Value>ANDGDesc</Value>
</Value>
<Value name="3">
<Value>ANDGOPADr</Value>
</Value>
<Value name="4">
<Value>ANDGUseFlag</Value>
</Value>
<Value name="5">
<Value>ANDGDefult</Value>
</Value>
<Value name="6">
<Value>ANDGDoseQty</Value>
</Value>
<Value name="7">
<Value>ANDGDoseUom</Value>
</Value>
<Value name="8">
<Value>ANDGSpeed</Value>
</Value>
<Value name="9">
<Value>ANDGSpeedUom</Value>
</Value>
<Value name="10">
<Value>ANDGInstructor</Value>
</Value>
<Value name="11">
<Value>ANDGDensity</Value>
</Value>
<Value name="12">
<Value>ANDGAdminSite</Value>
</Value>
<Value name="13">
<Value>ANDGDrugReason</Value>
</Value>
<Value name="14">
<Value>ANDGDisplayType</Value>
</Value>
<Value name="15">
<Value>ANDGDrugDesc</Value>
</Value>
</Data>
<DataLocation>^DHCANDrugDisplay</DataLocation>
<DefaultData>DHCANDrugDisplayDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCANDrugDisplay</IdLocation>
<IndexLocation>^DHCANDrugDisplay(0)</IndexLocation>
<StreamLocation>^User.DHCANDrugDisplayS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
