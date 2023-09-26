Class User.DHCLocPurPlanUser Extends (%Persistent, User.Abstract) [ SqlRowIdName = LPP_RowId, SqlTableName = DHC_LocPurPlanUser, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Property LPPCTLOCDR As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = LPP_CTLOC_DR ];

Property LPPSSUSRDR As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = LPP_SSUSR_DR ];

Property LPPActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = LPP_Active ];

Property LPPDefault As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = LPP_Default ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCLOCPPUSER(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="LPP_Active">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LPP_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LPP_Default">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="LPP_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCLOCPPUSER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LPP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{LPP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCLOCPPUSER</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>LPP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{LPP_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{LPP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocUser">
<Global>^DHCLOCPPUSER</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>LPP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LOCUSER"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LPP_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LPP_SSUSR_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LPP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LPP_RowId</SqlRowIdName>
<StreamLocation>^User.DHCLocPurPlanUserS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
