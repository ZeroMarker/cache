Class User.DHCBillCheckBusiData Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCBCBD_Rowid, SqlTableName = DHC_BillCheckBusiData, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DHCBCBD_Type
Property DHCBCBDType As %Library.String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DHCBCBD_Type ];

/// DHCBCBD_Node
Property DHCBCBDNode As %Library.String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DHCBCBD_Node ];

/// DHCBCBD_SubType
Property DHCBCBDSubType As %Library.String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DHCBCBD_SubType ];

/// DHCBCBD_Text
Property DHCBCBDText As %Library.String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DHCBCBD_Text ];

/// DHCBCBD_Adm_Dr
Property DHCBCBDAdmDr As %Library.String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DHCBCBD_Adm_Dr ];

/// DHCBCBD_OEORI_Dr
Property DHCBCBDOEORIDr As %Library.String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DHCBCBD_OEORI_Dr ];

/// DHCBCBD_OEORE_Dr
Property DHCBCBDOEOREDr As %Library.String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DHCBCBD_OEORE_Dr ];

/// DHCBCBD_PB_Dr
Property DHCBCBDPBDr As %Library.String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DHCBCBD_PB_Dr ];

/// DHCBCBD_Data
Property DHCBCBDData As %String(MAXLEN = "") [ SqlColumnNumber = 10, SqlFieldName = DHCBCBD_Data ];

/// DHCBCBD_CreateDate
Property DHCBCBDCreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = DHCBCBD_CreateDate ];

/// DHCBCBD_CreateTime
Property DHCBCBDCreateTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = DHCBCBD_CreateTime ];

/// DHCBCBD_Accm_Dr
Property DHCBCBDAccmDr As %Library.String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = DHCBCBD_Accm_Dr ];

/// DHCBCBD_Prt_Dr
Property DHCBCBDPrtDr As %Library.String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = DHCBCBD_Prt_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCBILLCHECKBUSIDATA)</SqlIdExpression>
<SQLMap name="IndexAccm">
<Global>^DHCBILLCHECKBUSIDATA</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCBCBD_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AccM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCBCBD_Accm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCBCBD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^DHCBILLCHECKBUSIDATA</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCBCBD_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCBCBD_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCBCBD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBDSubType">
<Global>^DHCBILLCHECKBUSIDATA</Global>
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
<Global>^DHCBILLCHECKBUSIDATA</Global>
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
<SQLMap name="IndexCreateDate">
<Global>^DHCBILLCHECKBUSIDATA</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCBCBD_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CreateDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCBCBD_CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCBCBD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNode">
<Global>^DHCBILLCHECKBUSIDATA</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCBCBD_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Node"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCBCBD_Node}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCBCBD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOEORE">
<Global>^DHCBILLCHECKBUSIDATA</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCBCBD_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OEORE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCBCBD_OEORE_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCBCBD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOEORI">
<Global>^DHCBILLCHECKBUSIDATA</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCBCBD_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OEORI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCBCBD_OEORI_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCBCBD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPB">
<Global>^DHCBILLCHECKBUSIDATA</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCBCBD_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PB"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCBCBD_PB_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCBCBD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPrtDr">
<Global>^DHCBILLCHECKBUSIDATA</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCBCBD_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Prt"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCBCBD_Prt_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCBCBD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="DHCBCBD_Accm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DHCBCBD_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCBCBD_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DHCBCBD_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DHCBCBD_Data">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DHCBCBD_Node">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCBCBD_OEORE_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHCBCBD_OEORI_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCBCBD_PB_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHCBCBD_Prt_Dr">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DHCBCBD_SubType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCBCBD_Text">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCBCBD_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCBILLCHECKBUSIDATA</Global>
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
<StreamLocation>^User.DHCBillCheckBusiDataS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
