/// InterParam
Class dhc.pa.inter.InterParam Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = InterParam_rowid, SqlTableName = InterParam, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// InterParam_className
Property InterParamclassName As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = InterParam_className ];

/// InterParam_methodName
Property InterParammethodName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = InterParam_methodName ];

/// InterParam_paramName
Property InterParamparamName As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = InterParam_paramName ];

/// InterParam_globalName
Property InterParamglobalName As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = InterParam_globalName ];

/// InterParam_locSetDr
Property InterParamlocSetDr As dhc.pa.inter.InterLocSet [ SqlColumnNumber = 6, SqlFieldName = InterParam_locSetDr ];

/// InterParam_active
Property InterParamactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = InterParam_active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPAINTERPARAM(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="InterParam_active">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="InterParam_className">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="InterParam_globalName">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="InterParam_locSetDr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="InterParam_methodName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="InterParam_paramName">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCCJXPAINTERPARAM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>InterParam_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{InterParam_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexClassMethod">
<Global>^DHCCJXPAINTERPARAM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>InterParam_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ClassMethod"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InterParam_className}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InterParam_methodName}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{InterParam_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.inter.InterParamS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
