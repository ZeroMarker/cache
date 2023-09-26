/// DHC_BPC_SpeedUnit
Class User.DHCBPCSpeedUnit Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = BPCSU_RowId, SqlTableName = DHC_BPC_SpeedUnit, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// BPCSU_Code
Property BPCSUCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = BPCSU_Code ];

/// BPCSU_Desc
Property BPCSUDesc As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = BPCSU_Desc ];

Property BPCSUType As %String(DISPLAYLIST = ",Volume,Dose,Unit,VolumeWeight,DoseWeight,UnitWeight", MAXLEN = 12, SELECTIVITY = "14.2857%", TRUNCATE = 1, VALUELIST = ",V,D,U,VW,DW,UW") [ SqlColumnNumber = 4, SqlFieldName = BPCSU_Type ];

Property BPCSUUomDr As %String [ SqlColumnNumber = 5, SqlFieldName = BPCSU_Uom_Dr ];

Property BPCSUFactor As %Float [ SqlColumnNumber = 6, SqlFieldName = BPCSU_Factor ];

Property BPCSUByPatWeight As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = BPCSU_ByPatWeight ];

Property BPCSUBaseSpeedUnitDr As User.DHCBPCSpeedUnit [ SqlColumnNumber = 8, SqlFieldName = BPCSU_BaseSpeedUnit_Dr ];

Property BPCSUBaseUomFactor As %Float [ SqlColumnNumber = 9, SqlFieldName = BPCSU_BaseUomFactor ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCBPC("SUnit",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BPCSU_BaseSpeedUnit_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BPCSU_BaseUomFactor">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BPCSU_ByPatWeight">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BPCSU_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BPCSU_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BPCSU_Factor">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BPCSU_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BPCSU_Uom_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCBPC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>BPCSU_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SUnit"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BPCSU_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCBPCSpeedUnitS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
