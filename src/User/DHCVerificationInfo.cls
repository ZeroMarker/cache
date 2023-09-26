Class User.DHCVerificationInfo Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DHC_VerificationInfo, StorageStrategy = SQLStorage ]
{

/// 类型
Property VFType As %String [ SqlColumnNumber = 2, SqlFieldName = VF_Type ];

/// 患者id
Property VFPatId As User.PAPatMas [ SqlColumnNumber = 3, SqlFieldName = VF_PatId ];

/// 发送验证码的电话
Property VFTel As %String [ SqlColumnNumber = 4, SqlFieldName = VF_Tel ];

/// 流水号
Property VFTradeCode As %String [ SqlColumnNumber = 5, SqlFieldName = VF_TradeCode ];

/// 验证码
Property VFCode As %String [ SqlColumnNumber = 6, SqlFieldName = VF_Code ];

/// 发送短信内容
Property VFSendMsg As %String [ SqlColumnNumber = 7, SqlFieldName = VF_SendMsg ];

/// 日期
Property VFDate As %Date [ SqlColumnNumber = 8, SqlFieldName = VF_Date ];

/// 时间
Property VFTime As %Time [ SqlColumnNumber = 9, SqlFieldName = VF_Time ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCVF(0))</SqlIdExpression>
<SQLMap name="TradeCodeIndex">
<Global>^DHCVFi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VF_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TradeCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VF_TradeCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="VFDateIndex">
<Global>^DHCVFi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VF_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VF_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="VFMap">
<Data name="VF_Code">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="VF_Date">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="VF_PatId">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="VF_SendMsg">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="VF_Tel">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="VF_Time">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="VF_TradeCode">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="VF_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCVF</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>VF_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{VF_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>VF_RowID</SqlRowIdName>
<StreamLocation>^User.DHCVerificationInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
