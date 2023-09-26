Class User.DHCMRICDCateDetails Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ICDCD_RowId, SqlTableName = DHCMR_ICDCateDetails, StorageStrategy = SQLStorage ]
{

/// d ##class(User.DHCMRICDCateDetails).%BuildIndices()
Parameter EXTENTSIZE = 250;

/// 描述
Property ICDCDDesc As %Library.String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ICDCD_Desc ];

/// ICD值
Property ICDCDICDList As %Library.String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ICDCD_ICDList ];

/// Sort顺序
Property ICDCDSort As %Integer [ SqlColumnNumber = 4, SqlFieldName = ICDCD_Sort ];

/// User.DHCMRICDCate
Property ICDCateDr As User.DHCMRICDCate [ SqlColumnNumber = 5, SqlFieldName = ICDCateDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMRICDCateDetails(0))</SqlIdExpression>
<SQLMap name="IndexICDCDr">
<Global>^DHCMRICDCateDetails</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>{ICDCD_RowId}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ICDCDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ICDCateDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ICDCD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexICDCDrSort">
<Global>^DHCMRICDCateDetails</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>{ICDCD_RowId}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ICDCDrSort"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ICDCateDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ICDCD_Sort}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ICDCD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MapData">
<Data name="ICDCD_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ICDCD_ICDList">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ICDCD_Sort">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ICDCateDr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCMRICDCateDetails</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>{ICDCD_RowId}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ICDCD_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMRICDCateDetailsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
