Class User.DHCPHSysTask Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHSTK_RowId, SqlTableName = DHC_PHSysTask, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHSTK_Date
Property PHSTKDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = PHSTK_Date ];

/// PHSTK_Time
Property PHSTKTime As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = PHSTK_Time ];

/// PHSTK_User
Property PHSTKUser As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = PHSTK_User ];

/// PHSTK_Xecute
Property PHSTKXecute As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PHSTK_Xecute ];

/// PHSTK_Active
Property PHSTKActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = PHSTK_Active ];

/// PHSTK_PCNTSNo
Property PHSTKPCNTSNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PHSTK_PCNTSNo ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHSYSTASK)</SqlIdExpression>
<SQLMap name="IndexDate">
<Global>^DHCPHSYSTASK</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHSTK_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHSTK_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHSTK_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PHSTK_Active">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHSTK_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHSTK_PCNTSNo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHSTK_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHSTK_User">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHSTK_Xecute">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPHSYSTASK</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHSTK_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHSTK_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHSysTaskS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
