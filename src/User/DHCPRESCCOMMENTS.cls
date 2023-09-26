Class User.DHCPRESCCOMMENTS Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHC_PrescComments_RowID, SqlTableName = DHC_PrescComments, StorageStrategy = SQLStorage ]
{

Property PCPrescNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlFieldName = PC_PrescNo ];

Property PCOEORIDate As %Library.Date [ SqlFieldName = PC_OEORIDate ];

Property PCCommentsDate As %Library.Date [ SqlFieldName = PC_CommentsDate ];

Property PCCommentsTime As %Library.Time [ SqlFieldName = PC_CommentsTime ];

Property PCCommentsPerson As %Library.String [ SqlFieldName = PC_CommentsPerson ];

Property PCCommentsResult As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlFieldName = PC_CommentsResult ];

Property PCCommentsReasonDR As User.DHCCOMMENTSREASON [ SqlFieldName = PC_CommentsReason_DR ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPRESCC)</SqlIdExpression>
<SQLMap name="DHCPrescCommentsMaster">
<Data name="PC_CommentsDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PC_CommentsPerson">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PC_CommentsReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PC_CommentsResult">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PC_CommentsTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PC_OEORIDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PC_PrescNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPRESCC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PrescComments_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_PrescComments_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="INDEXPCOEORIDate">
<Global>^DHCPRESCC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_PrescComments_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PRESC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>"OEORIDATE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PC_OEORIDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_PrescComments_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXPCPrescNo">
<Global>^DHCPRESCC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_PrescComments_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PRESC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>"PRESCNO"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PC_PrescNo}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_PrescComments_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPRESCCOMMENTSS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
