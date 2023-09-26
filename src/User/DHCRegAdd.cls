Class User.DHCRegAdd Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RA_Rowid, SqlTableName = DHC_RegAdd, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// RAType
Property RAType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = RA_Type ];

/// RARegDate
Property RARegDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = RA_RegDate ];

/// RA_Dep
Property RADep As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = RA_Dep ];

/// RA_Doc
Property RADoc As User.CTCareProv [ SqlColumnNumber = 5, SqlFieldName = RA_Doc ];

/// RA_UserAdd_DR
Property RAQty As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = RA_Qty ];

/// RA_Date
Property RADate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = RA_Date ];

/// RA_Time
Property RATime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = RA_Time ];

/// RA_UserAdd_DR
Property RAUserAddDR As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = RA_UserAdd_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRegAdd(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RA_Date">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RA_Dep">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RA_Doc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RA_Qty">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RA_RegDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RA_Time">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RA_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RA_UserAdd_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCRegAdd</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RA_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{RA_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexRegDate">
<Global>^DHCRegAdd</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RA_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RegDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RA_RegDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RA_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCRegAddS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
