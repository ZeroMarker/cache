Class User.DHCDocProduce Extends %Persistent [ Not ProcedureBlock, SqlRowIdName = RowID, SqlTableName = DHCDocProduce, StorageStrategy = DHCDocProduce ]
{

/// 产品线代码
Property DocProduceCode As %Library.String [ SqlColumnNumber = 2, SqlFieldName = DocProduceCode ];

/// 产品线描述
Property DocProduceDesc As %Library.String [ SqlColumnNumber = 3, SqlFieldName = DocProduceDesc ];

/// 是否激活
Property DocProduceActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = DocProduceActive ];

/// 产品线展示代码
Property DocProcduceShowCode As %Library.String [ SqlColumnNumber = 5, SqlFieldName = DocProcduceShowCode ];

Storage DHCDocProduce
{
<SqlIdExpression>$i(^DHCDocProduce(0))</SqlIdExpression>
<SQLMap name="mastermap">
<Data name="DocProcduceShowCode">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DocProduceActive">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DocProduceCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DocProduceDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCDocProduce</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>RowID</SqlRowIdName>
<StreamLocation>^User.DHCDocProduceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
