Class User.DHCIPBillReceive Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IPRec_RowId, SqlTableName = DHC_IPBillReceive, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 280;

/// IPRec_Date
Property IPRecDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = IPRec_Date ];

/// IPRec_Time
Property IPRecTime As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = IPRec_Time ];

/// IPRec_User_DR
Property IPRecUserDR As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = IPRec_User_DR ];

/// IPRec_StDate
Property IPRecStDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = IPRec_StDate ];

/// IPRec_EndDate
Property IPRecEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = IPRec_EndDate ];

Storage SQLStorage
{
<ExtentSize>280</ExtentSize>
<SqlIdExpression>$i(^DHCIPBILLRECEIVE)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="IPRec_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IPRec_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IPRec_StDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IPRec_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IPRec_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCIPBILLRECEIVE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IPRec_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{IPRec_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCIPBILLRECEIVEi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IPRec_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPRec_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IPRec_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUserDR">
<Global>^DHCIPBILLRECEIVEi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IPRec_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"USERDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPRec_User_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IPRec_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCIPBillReceiveS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
