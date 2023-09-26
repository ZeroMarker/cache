Class User.DHCBillCheckBasicData Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCBCBD_Rowid, SqlTableName = DHC_BillCheckBasicData, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DHCBCBD_Type
Property DHCBCBDType As %Library.String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DHCBCBD_Type ];

/// DHCBCBD_SubType
Property DHCBCBDSubType As %Library.String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DHCBCBD_SubType ];

/// DHCBCBD_Text
Property DHCBCBDText As %Library.String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DHCBCBD_Text ];

/// DHCBCBD_ArcItm_Dr
Property DHCBCBDArcItmDr As %Library.String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DHCBCBD_ArcItm_Dr ];

/// DHCBCBD_Tari_Dr
Property DHCBCBDTariDr As %Library.String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DHCBCBD_Tari_Dr ];

/// DHCBCBD_Inci_Dr
Property DHCBCBDInciDr As %Library.String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DHCBCBD_Inci_Dr ];

/// DHCBCBD_Data
Property DHCBCBDData As %String(MAXLEN = "") [ SqlColumnNumber = 8, SqlFieldName = DHCBCBD_Data ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCBILLCHECKBASICDATA)</SqlIdExpression>
<SQLMap name="IndexBDSubType">
<Global>^DHCBILLCHECKBASICDATA</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCBCBD_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BDSubType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCBCBD_SubType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCBCBD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBDType">
<Global>^DHCBILLCHECKBASICDATA</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCBCBD_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BDType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCBCBD_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCBCBD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="DHCBCBD_ArcItm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCBCBD_Data">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHCBCBD_Inci_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCBCBD_SubType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCBCBD_Tari_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCBCBD_Text">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCBCBD_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCBILLCHECKBASICDATA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCBCBD_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHCBCBD_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCBillCheckBasicDataS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
