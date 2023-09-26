Class User.DHCLocSorting Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DLS_RowID, SqlTableName = DHC_LocSorting, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DLS_Code
Property DLSCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DLS_Code ];

/// DLS_Desc
Property DLSDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DLS_Desc ];

/// DLS_AddUser_DR
Property DLSAddUserDR As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = DLS_AddUser_DR ];

/// DLS_AddDate
Property DLSAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = DLS_AddDate ];

/// DLS_AddTime
Property DLSAddTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = DLS_AddTime ];

/// DLS_UpdateUser_DR
Property DLSUpdateUserDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = DLS_UpdateUser_DR ];

/// DLS_UpdateDate
Property DLSUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = DLS_UpdateDate ];

/// DLS_UpdateTime
Property DLSUpdateTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = DLS_UpdateTime ];

/// DLS_OrderType
Property DLSOrderType As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = DLS_OrderType ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCLocSorting)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCLocSorting</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DLS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DLS_Code}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DLS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCLocSorting</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DLS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DLS_Desc}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DLS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMaster">
<Data name="DLS_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DLS_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DLS_AddUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DLS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DLS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DLS_OrderType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DLS_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DLS_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DLS_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCLocSorting</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DLS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DLS_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCLocSortingS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
