Class User.DHCIPMealInvprt Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCMI_RowID, SqlTableName = DHC_IPMealInvprt, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DHCMI_PrtDate
Property DHCMIPrtDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = DHCMI_PrtDate ];

/// DHCMI_Adm
Property DHCMIAdm As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DHCMI_Adm ];

/// DHCMI_Acount
Property DHCMIAcount As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = DHCMI_Acount ];

/// DHCMI_User
Property DHCMIUser As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DHCMI_User ];

/// DHCMI_Flag
Property DHCMIFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DHCMI_Flag ];

/// DHCMI_PatType
Property DHCMIPatType As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = DHCMI_PatType ];

/// DHCMI_Deposit
Property DHCMIDeposit As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = DHCMI_Deposit ];

/// DHCMI_Remain
Property DHCMIRemain As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = DHCMI_Remain ];

/// DHCMI_InitInv_Dr
Property DHCMIInitInvDr As User.DHCIPMealInvprt [ SqlColumnNumber = 10, SqlFieldName = DHCMI_InitInv_Dr ];

/// DHCMI_Handin
Property DHCMIHandin As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = DHCMI_Handin ];

/// DHCMI_HandinDate
Property DHCMIHandinDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = DHCMI_HandinDate ];

/// DHCMI_HandinTime
Property DHCMIHandinTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = DHCMI_HandinTime ];

/// DHCMI_Bill_Dr
Property DHCMIBillDr As User.DHCIPMealBill [ SqlColumnNumber = 14, SqlFieldName = DHCMI_Bill_Dr ];

/// DHCMI_InvNo
Property DHCMIInvNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = DHCMI_InvNo ];

/// DHCMI_InvNo
Property DHCMIPrtTime As %Library.Time [ SqlColumnNumber = 16, SqlFieldName = DHCMI_PrtTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCIPMEALINVPRT)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DHCMI_Acount">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCMI_Adm">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCMI_Bill_Dr">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DHCMI_Deposit">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHCMI_Flag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCMI_Handin">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DHCMI_HandinDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DHCMI_HandinTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DHCMI_InitInv_Dr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DHCMI_InvNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCMI_PatType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHCMI_PrtDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCMI_PrtTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DHCMI_Remain">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DHCMI_User">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCIPMEALINVPRT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCMI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHCMI_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^DHCIPMEALINVPRT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCMI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCMI_Adm}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCMI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPrtDate">
<Global>^DHCIPMEALINVPRT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCMI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PrtDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCMI_PrtDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCMI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCIPMealInvprtS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
