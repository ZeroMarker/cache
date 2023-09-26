Class dhc.ca.cache.data.TmpInData Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = TmpInData_rowid, SqlTableName = TmpInData, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// TmpInData_fDeptDr
Property TmpInDatafDeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 2, SqlFieldName = TmpInData_fDeptDr ];

/// TmpInData_tDeptDr
Property TmpInDatatDeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 3, SqlFieldName = TmpInData_tDeptDr ];

/// TmpInData_patDeptDr
Property TmpInDatapatDeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 4, SqlFieldName = TmpInData_patDeptDr ];

/// TmpInData_itemDr
Property TmpInDataitemDr As dhc.ca.cache.data.AllDataItems [ SqlColumnNumber = 5, SqlFieldName = TmpInData_itemDr ];

/// TmpInData_fee
Property TmpInDatafee As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = TmpInData_fee ];

/// TmpInData_patType
Property TmpInDatapatType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = TmpInData_patType ];

/// TmpInData_flag
Property TmpInDataflag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = TmpInData_flag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCATMPINDATA(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="TmpInData_fDeptDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TmpInData_fee">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TmpInData_flag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TmpInData_itemDr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TmpInData_patDeptDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TmpInData_patType">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TmpInData_tDeptDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCCATMPINDATA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TmpInData_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{TmpInData_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexFlag">
<Global>^DHCCATMPINDATA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TmpInData_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Flag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TmpInData_flag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TmpInData_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.TmpInDataS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
