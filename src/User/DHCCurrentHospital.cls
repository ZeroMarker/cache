Class User.DHCCurrentHospital Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCHOSP_RowID, SqlTableName = DHC_CurrentHospital, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// Code
Property DHCHOSPCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DHCHOSP_Code ];

/// Desc
Property DHCHOSPDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DHCHOSP_Desc ];

/// ct_hospital
Property DHCHOSPHOSPDR As User.CTHospital [ SqlColumnNumber = 4, SqlFieldName = DHCHOSP_HOSP_DR ];

/// CurrentFlag
Property DHCHOSPCurrentFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = DHCHOSP_CurrentFlag ];

/// DHCHOSP_DepositPrtFlag
Property DHCHOSPDepositPrtFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = DHCHOSP_DepositPrtFlag ];

/// DHCHOSP_ReceiptPrtFlag
Property DHCHOSPReceiptPrtFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = DHCHOSP_ReceiptPrtFlag ];

/// DHCHOSP_ReceiptPrtCate
Property DHCHOSPReceiptPrtCate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DHCHOSP_ReceiptPrtCate ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCURRENTHOSPITAL)</SqlIdExpression>
<SQLMap name="MasterDHCCURRENTHOSPITAL">
<Data name="DHCHOSP_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCHOSP_CurrentFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCHOSP_DepositPrtFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCHOSP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCHOSP_HOSP_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCHOSP_ReceiptPrtCate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHCHOSP_ReceiptPrtFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCCURRENTHOSPITAL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCHOSP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHCHOSP_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCCurrentHospitalS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
