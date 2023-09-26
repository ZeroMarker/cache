/// DHC_ICUC_SpeedUnit
Class User.DHCICUCSpeedUnit Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ICUCSU_RowId, SqlTableName = DHC_ICUC_SpeedUnit, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ICUCSU_Code
Property ICUCSUCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ICUCSU_Code ];

/// ICUCSU_Desc
Property ICUCSUDesc As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ICUCSU_Desc ];

Property ICUCSUType As %String(DISPLAYLIST = ",Volume,Dose,Unit,VolumeWeight,DoseWeight,UnitWeight", MAXLEN = 12, SELECTIVITY = "14.2857%", TRUNCATE = 1, VALUELIST = ",V,D,U,VW,DW,UW") [ SqlColumnNumber = 4, SqlFieldName = ICUCSU_Type ];

Property ICUCSUUomDr As %String [ SqlColumnNumber = 5, SqlFieldName = ICUCSU_Uom_Dr ];

Property ICUCSUFactor As %Float [ SqlColumnNumber = 6, SqlFieldName = ICUCSU_Factor ];

Property ICUCSUByPatWeight As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = ICUCSU_ByPatWeight ];

Property ICUCSUBaseSpeedUnitDr As User.DHCICUCSpeedUnit [ SqlColumnNumber = 8, SqlFieldName = ICUCSU_BaseSpeedUnit_Dr ];

Property ICUCSUBaseUomFactor As %Float [ SqlColumnNumber = 9, SqlFieldName = ICUCSU_BaseUomFactor ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCICUC("SUnit",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ICUCSU_BaseSpeedUnit_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ICUCSU_BaseUomFactor">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ICUCSU_ByPatWeight">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ICUCSU_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ICUCSU_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ICUCSU_Factor">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ICUCSU_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ICUCSU_Uom_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCICUC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ICUCSU_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SUnit"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ICUCSU_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCICUCSpeedUnitS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
