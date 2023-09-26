/// DHC_ANC_SpeedUnit
Class User.DHCANCSpeedUnit Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ANCSU_RowId, SqlTableName = DHC_ANC_SpeedUnit, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ANCSU_Code
Property ANCSUCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ANCSU_Code ];

/// ANCSU_Desc
Property ANCSUDesc As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ANCSU_Desc ];

/// 20141011new
Property ANCSUType As %String(DISPLAYLIST = ",V,D,U,VW,DW,UW", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",V,D,U,VW,DW,UW") [ SqlColumnNumber = 4, SqlFieldName = ANCSU_Type ];

Property ANCSUUomDr As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = ANCSU_Uom_Dr ];

Property ANCSUFactor As %Float [ SqlColumnNumber = 6, SqlFieldName = ANCSU_Factor ];

Property ANCSUByPatWeight As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = ANCSU_ByPatWeight ];

Property ANCSUBaseSpeedUnitDr As DHCANCSpeedUnit [ SqlColumnNumber = 8, SqlFieldName = ANCSU_BaseSpeedUnit_Dr ];

Property ANCSUBaseUomFactor As %Float [ SqlColumnNumber = 9, SqlFieldName = ANCSU_BaseUomFactor ];

Index ANCSUCodeUnqIdx1 On ANCSUCode [ Unique ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCANC("SUnit",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ANCSU_BaseSpeedUnit_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ANCSU_BaseUomFactor">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ANCSU_ByPatWeight">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ANCSU_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ANCSU_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ANCSU_Factor">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ANCSU_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ANCSU_Uom_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCANC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ANCSU_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SUnit"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ANCSU_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCANCSpeedUnitS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
