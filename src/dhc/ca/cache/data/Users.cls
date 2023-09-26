Class dhc.ca.cache.data.Users Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Users_rowid, SqlTableName = Users, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildURoles As dhc.ca.cache.data.URoles [ Cardinality = children, Inverse = URolesparRef ];

/// Users_order
Property Usersorder As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = Users_order ];

/// Users_loginName
Property UsersloginName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = Users_loginName ];

/// Users_password
Property Userspassword As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = Users_password ];

/// Users_unitPersonDr
Property UsersunitPersonDr As dhc.ca.cache.data.UnitPersons [ SqlColumnNumber = 5, SqlFieldName = Users_unitPersonDr ];

/// Users_remark
Property Usersremark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = Users_remark ];

/// Users_active
Property Usersactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = Users_active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCAUSERS(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="Users_active">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="Users_loginName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Users_order">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Users_password">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Users_remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="Users_unitPersonDr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCCAUSERS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Users_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{Users_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexActive">
<Global>^DHCCAUSERS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Users_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Active"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Users_active}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Users_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLoginname">
<Global>^DHCCAUSERS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Users_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Loginname"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Users_loginName}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Users_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrder">
<Global>^DHCCAUSERS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Users_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Order"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Users_order}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Users_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPerson">
<Global>^DHCCAUSERS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Users_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Person"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Users_unitPersonDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Users_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.UsersS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
