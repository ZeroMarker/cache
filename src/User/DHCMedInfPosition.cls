Class User.DHCMedInfPosition Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MPOS_Rowid, SqlTableName = DHC_MedInfPosition, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCMedInfPosSubDIA As User.DHCMedInfPosSubDIA [ Cardinality = children, Inverse = MPOSDParRef ];

/// MPOS_Code
Property MPOSCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MPOS_Code ];

/// MPOS_InfPosition
Property MPOSInfPosition As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MPOS_InfPosition ];

/// MPOS_Active
Property MPOSActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = MPOS_Active ];

/// MPOS_Demo
Property MPOSDemo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MPOS_Demo ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMPOS)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="MPOS_Active">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MPOS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MPOS_Demo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MPOS_InfPosition">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCMPOS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MPOS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MPOS_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMedInfPositionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
