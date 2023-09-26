/// DHC_ANC_VenipuncSite
Class User.DHCANCVenipuncSite Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ANCVPS_RowId, SqlTableName = DHC_ANC_VenipuncSite, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ANCVPS_Code
Property ANCVPSCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ANCVPS_Code ];

/// ANCVPS_Desc
Property ANCVPSDesc As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ANCVPS_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCANC("VPSite",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ANCVPS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ANCVPS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCANC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ANCVPS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"VPSite"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ANCVPS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCANCVenipuncSiteS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
