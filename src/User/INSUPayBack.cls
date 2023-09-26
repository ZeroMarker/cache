Class User.INSUPayBack Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INPAB_RowID, SqlTableName = INSU_PayBack, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// INPAB_DivideDr
Property INPABDivideDr As User.INSUDividePre [ SqlColumnNumber = 2, SqlFieldName = INPAB_DivideDr ];

/// INPAB_PatName
Property INPABPatName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = INPAB_PatName ];

/// INPAB_Name3
Property INPABName3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = INPAB_Name3 ];

/// INPAB_District
Property INPABDistrict As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = INPAB_District ];

/// INPAB_InsuFootDate
Property INPABInsuFootDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = INPAB_InsuFootDate ];

/// INPAB_TotalAmount
Property INPABTotalAmount As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = INPAB_TotalAmount ];

/// INPAB_TCAmount
Property INPABTCAmount As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = INPAB_TCAmount ];

/// INPAB_DEAmount
Property INPABDEAmount As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = INPAB_DEAmount ];

/// INPAB_RefuseAmount
Property INPABRefuseAmount As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = INPAB_RefuseAmount ];

/// INPAB_RefuseDesc
Property INPABRefuseDesc As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = INPAB_RefuseDesc ];

/// INPAB_BackDate
Property INPABBackDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = INPAB_BackDate ];

/// INPAB_Flag
Property INPABFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = INPAB_Flag ];

/// INPAB_IDate
Property INPABIDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = INPAB_IDate ];

/// INPAB_ITime
Property INPABITime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = INPAB_ITime ];

/// INPAB_BillDate
Property INPABBillDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = INPAB_BillDate ];

/// INPAB_BillDate1
Property INPABBillDate1 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = INPAB_BillDate1 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINPAB)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="INPAB_BackDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INPAB_BillDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INPAB_BillDate1">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INPAB_DEAmount">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INPAB_District">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INPAB_DivideDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INPAB_Flag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INPAB_IDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INPAB_ITime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INPAB_InsuFootDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INPAB_Name3">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INPAB_PatName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INPAB_RefuseAmount">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INPAB_RefuseDesc">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INPAB_TCAmount">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INPAB_TotalAmount">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCINPAB</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INPAB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INPAB_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofBackDate">
<Global>^DHCINPAB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INPAB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"BackDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INPAB_BackDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INPAB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofDistrict">
<Global>^DHCINPAB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INPAB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"District"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INPAB_District}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INPAB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofDivideDr">
<Global>^DHCINPAB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INPAB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DivideDr"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INPAB_DivideDr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INPAB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofIDate">
<Global>^DHCINPAB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INPAB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"IDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INPAB_IDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INPAB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofName3">
<Global>^DHCINPAB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INPAB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Name3"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INPAB_Name3}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INPAB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofPatName">
<Global>^DHCINPAB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INPAB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PatName"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INPAB_PatName}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INPAB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.INSUPayBackS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
