/// 住院证明细表，记录本住院证涉及到的明细内容
Class User.DHCDocIPBKDetail Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHCDocIPBKDetail, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 10000000;

/// 住院证ID 指向DHCDocIPBooking
Property BookID As DHCDocIPBooking [ SqlColumnNumber = 2, SqlFieldName = BookID ];

/// 明细项目ID 指向DHCDocIPBKTempItem
Property ItemID As DHCDocIPBKTempItem [ SqlColumnNumber = 3, SqlFieldName = ItemID ];

/// 项目值 字典项目存指针
Property ItemValue As %String(COLLATION = "EXACT", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = ItemValue ];

/// SQL存储过程
Storage SQLStorage
{
<Description>
<![CDATA[SQL存储过程]]></Description>
<ExtentSize>10000000</ExtentSize>
<SqlIdExpression>$i(^DHCDocIPBKD(0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="BookID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ItemID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ItemValue">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCDocIPBKD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBookItem">
<Global>^DHCDocIPBKD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"BookItem"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{BookID}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{ItemID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RowID</SqlRowIdName>
<StreamLocation>^User.DHCDocIPBKDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
