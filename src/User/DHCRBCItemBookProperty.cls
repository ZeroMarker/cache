Class User.DHCRBCItemBookProperty Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DIBP_RowID, SqlTableName = DHCRBC_ItemBookProperty, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCRBCItemBookPropertySer As User.DHCRBCItemBookPropertySer [ Cardinality = children, Inverse = DIPSParentRef ];

/// DIBP_ARCItmMast_DR
Property DIBPARCItmMastDR As User.ARCItmMast [ SqlColumnNumber = 2, SqlFieldName = DIBP_ARCItmMast_DR ];

/// DIBP_AppointMethod_ID
Property DIBPAppointMethodID As User.DHCRBCAppointMethod [ SqlColumnNumber = 3, SqlFieldName = DIBP_AppointMethod_ID ];

/// DIBP_AutoInputFee
Property DIBPAutoInputFee As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DIBP_AutoInputFee ];

/// DIBP_IsEmpty
Property DIBPIsEmpty As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DIBP_IsEmpty ];

/// DIBP_Location
Property DIBPLocation As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DIBP_Location ];

/// DIPB_Telphone
Property DIPBTelphone As %Library.String(COLLATION = "Exact", MAXLEN = 18, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DIPB_Telphone ];

/// DIPB_AppLocation
Property DIPBAppLocation As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DIPB_AppLocation ];

/// DIPB_Exclusion
Property DIPBExclusion As %Library.String(COLLATION = "Exact", MAXLEN = 6, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DIPB_Exclusion ];

/// DIPB_Time
Property DIPBTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = DIPB_Time ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCItemBookProperty)</SqlIdExpression>
<SQLMap name="IndexArcItemMast">
<Global>^DHCRBCItemBookProperTypei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DIBP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DIBP_ARCItmMast_DR}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DIBP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DIBP_ARCItmMast_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DIBP_AppointMethod_ID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DIBP_AutoInputFee">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DIBP_IsEmpty">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DIBP_Location">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DIPB_AppLocation">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DIPB_Exclusion">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DIPB_Telphone">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DIPB_Time">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCRBCItemBookProperty</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DIBP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DIBP_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCItemBookPropertyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
