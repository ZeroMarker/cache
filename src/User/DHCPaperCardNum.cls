Class User.DHCPaperCardNum Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCPCN_ROWID, SqlTableName = DHC_PaperCardNum, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DHCPCN_Papmi_DR
Property DHCPCNPapmiDR As User.PAPerson [ SqlColumnNumber = 2, SqlFieldName = DHCPCN_Papmi_DR ];

/// DHCPCN_CardType_DR
Property DHCPCNCardTypeDR As User.PACCardType [ SqlColumnNumber = 3, SqlFieldName = DHCPCN_CardType_DR ];

/// DHCPCN_CardNo
Property DHCPCNCardNo As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DHCPCN_CardNo ];

/// DHCPCN_Memo
Property DHCPCNMemo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DHCPCN_Memo ];

/// DHCPCN_Date
Property DHCPCNDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = DHCPCN_Date ];

/// DHCPCN_Time
Property DHCPCNTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = DHCPCN_Time ];

/// DHCPCN_User_DR
Property DHCPCNUserDR As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = DHCPCN_User_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPCN)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="DHCPCN_CardNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCPCN_CardType_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCPCN_Date">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCPCN_Memo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCPCN_Papmi_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCPCN_ROWID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCPCN_Time">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHCPCN_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCPCN</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCPCN_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHCPCN_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOfPapmiDR">
<Global>^DHCPCNi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCPCN_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"PAPMI"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{DHCPCN_Papmi_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHCPCN_CardType_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHCPCN_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPaperCardNumS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
