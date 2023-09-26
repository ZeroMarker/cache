/// JinSuanPan
Class User.INSUDivideSubDue Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INDSD_Rowid, SqlTableName = INSU_DivideSubDue, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// INDSD_DivideDr
Property INDSDDivideDr As User.INSUDividePre [ SqlColumnNumber = 2, SqlFieldName = INDSD_DivideDr ];

/// INDSD_Childsub
Property INDSDChildsub As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = INDSD_Childsub ];

/// INDSD_PatInsuNO
Property INDSDPatInsuNO As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = INDSD_PatInsuNO ];

/// INDSD_PatName
Property INDSDPatName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = INDSD_PatName ];

/// INDSD_BackDate
Property INDSDBackDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = INDSD_BackDate ];

/// INDSD_BackAmount
Property INDSDBackAmount As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = INDSD_BackAmount ];

/// INDSD_District
Property INDSDDistrict As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = INDSD_District ];

/// INDSD_Flag
Property INDSDFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = INDSD_Flag ];

/// INDSD_InsertDate
Property INDSDInsertDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = INDSD_InsertDate ];

/// INDSD_BillDate
Property INDSDBillDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = INDSD_BillDate ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINDSD)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="INDSD_BackAmount">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INDSD_BackDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INDSD_BillDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INDSD_Childsub">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INDSD_District">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INDSD_DivideDr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INDSD_Flag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INDSD_InsertDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INDSD_PatInsuNO">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INDSD_PatName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCINDSD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INDSD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INDSD_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOfInsertDate">
<Global>^DHCINDSD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INDSD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"InsertDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INDSD_InsertDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INDSD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofBillDate">
<Global>^DHCINDSD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INDSD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"BillDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INDSD_BillDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INDSD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofCQ">
<Global>^DHCINDSD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INDSD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"CQ"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INDSD_District}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INDSD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofDate">
<Global>^DHCINDSD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INDSD_Rowid</Field>
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
<Expression>{INDSD_BackDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INDSD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofDivideDr">
<Global>^DHCINDSD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INDSD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DivideDr"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INDSD_DivideDr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INDSD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofName3">
<Global>^DHCINDSD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INDSD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Name3"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INDSD_PatInsuNO}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INDSD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.INSUDivideSubDueS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
