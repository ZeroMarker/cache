/// 床位附加费用类型
/// E:诊查费,H:取暖费,AC:空调费,A:附加费
Class User.DHCPACBedFeeType Extends %Persistent [ SqlRowIdName = FT_RowId, SqlTableName = DHC_PACBed_FeeType, StorageStrategy = SQLStorage ]
{

Property FTCode As %String(COLLATION = "AlphaUp", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = FT_Code ];

Property FTDesc As %String(COLLATION = "AlphaUp", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = FT_Desc ];

Property FTStartDate As %Date [ SqlColumnNumber = 4, SqlFieldName = FT_StartDate ];

Property FTEndDate As %Date [ SqlColumnNumber = 5, SqlFieldName = FT_EndDate ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("FEETP",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="FT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="FT_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="FT_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>FT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"FEETP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{FT_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>FT_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPACBedFeeTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
