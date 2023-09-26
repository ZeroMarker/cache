Class User.DHCMRICDCate Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ICDC_RowId, SqlTableName = DHCMR_ICDCate, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// 编码
Property ICDCType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ICDC_Type ];

/// 描述
Property ICDCDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ICDC_Desc ];

/// 分类<诊断 ,手术>
Property ICDCCateGory As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = ICDC_CateGory ];

/// 备注
Property ICDCRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = ICDC_Remark ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMRICDCate(0))</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCMRICDCate</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>{ICDC_RowId}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ICDC_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ICDC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MapData">
<Data name="ICDC_CateGory">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ICDC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ICDC_Remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ICDC_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCMRICDCate</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>{ICDC_RowId}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ICDC_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMRICDCateS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
