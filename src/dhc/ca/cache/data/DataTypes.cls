Class dhc.ca.cache.data.DataTypes Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DataTypes_rowid, SqlTableName = DataTypes, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DataTypes_code
Property DataTypescode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DataTypes_code ];

/// DataTypes_name
Property DataTypesname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DataTypes_name ];

/// DataTypes_desc
Property DataTypesdesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DataTypes_desc ];

/// DataTypes_inFlag
Property DataTypesinFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = DataTypes_inFlag ];

/// DataTypes_outFlag
Property DataTypesoutFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = DataTypes_outFlag ];

/// DataTypes_paramFlag
Property DataTypesparamFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = DataTypes_paramFlag ];

/// DataTypes_active
Property DataTypesactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = DataTypes_active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCADATATYPES(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="DataTypes_active">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DataTypes_code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DataTypes_desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DataTypes_inFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DataTypes_name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DataTypes_outFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DataTypes_paramFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCCADATATYPES</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DataTypes_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DataTypes_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexActive">
<Global>^DHCCADATATYPES</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DataTypes_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Active"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DataTypes_active}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DataTypes_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCADATATYPES</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DataTypes_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DataTypes_code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DataTypes_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCCADATATYPES</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DataTypes_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DataTypes_desc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DataTypes_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInFlag">
<Global>^DHCCADATATYPES</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DataTypes_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DataTypes_inFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DataTypes_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCCADATATYPES</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DataTypes_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DataTypes_name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DataTypes_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOutFlag">
<Global>^DHCCADATATYPES</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DataTypes_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OutFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DataTypes_outFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DataTypes_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexParamFlag">
<Global>^DHCCADATATYPES</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DataTypes_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ParamFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DataTypes_paramFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DataTypes_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.DataTypesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
