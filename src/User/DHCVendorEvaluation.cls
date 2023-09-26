Class User.DHCVendorEvaluation Extends (%Persistent, User.Abstract) [ SqlRowIdName = VE_RowId, SqlTableName = DHC_VendorEvaluation, StorageStrategy = SQLStorage ]
{

/// 供应商Rowid
Property VEAPCVMDR As User.APCVendor [ SqlColumnNumber = 2, SqlFieldName = VE_APCVM_DR ];

/// 供应商评价指标Rowid
Property VEVEIDR As User.DHCVendorEvaluationIndex [ SqlColumnNumber = 3, SqlFieldName = VE_VEI_DR ];

/// 分数
Property VEScore As %Float [ SqlColumnNumber = 4, SqlFieldName = VE_Score ];

/// 备注
Property VERemarks As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = VE_Remarks ];

/// 评价日期
Property VEDate As %Date [ SqlColumnNumber = 6, SqlFieldName = VE_Date ];

/// 指向表ID
Property VEPointer As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = VE_Pointer ];

/// 业务类型
Property VEType As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = VE_Type ];

/// 是否提交
Property VESubmitFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = VE_SubmitFlag ];

/// 扣分项ID
Property VEReasonDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = VE_Reason_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCVE)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="VE_APCVM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="VE_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="VE_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="VE_Reason_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="VE_Remarks">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="VE_Score">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="VE_SubmitFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="VE_Type">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="VE_VEI_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCVE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>VE_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{VE_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTypePointer">
<Global>^DHCVE</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>VE_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypePointer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VE_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VE_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{VE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexVendor">
<Global>^DHCVE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VE_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Vendor"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VE_APCVM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>VE_RowId</SqlRowIdName>
<StreamLocation>^User.DHCVendorEvaluationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCVE)
	s oldI = +$g(^mdata("DHCVENEVALUE"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCVE = maxI
	s ^mdata("DHCVENEVALUE") = maxI
}

Parameter EXTENTSIZE = 250;

}
