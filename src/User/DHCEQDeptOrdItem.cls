Class User.DHCEQDeptOrdItem Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DOI_RowID, SqlTableName = DHC_EQDeptOrdItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Property DOIDeptID As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DOI_DeptID ];

Property DOIOrderItemID As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DOI_OrderItemID ];

Property DOIOrderCatID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DOI_OrderCatID ];

Property DOIOrderItemCatID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DOI_OrderItemCatID ];

Property DOIDept As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DOI_Dept ];

Property DOIOrderItem As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DOI_OrderItem ];

Property DOIOrderCat As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DOI_OrderCat ];

Property DOIOrderItemCat As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DOI_OrderItemCat ];

Property DOIHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = DOI_Hold1 ];

Property DOIHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = DOI_Hold2 ];

Property DOIHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = DOI_Hold3 ];

Property DOIHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = DOI_Hold4 ];

Property DOIHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = DOI_Hold5 ];

///      D_Remark
Storage SQLStorage
{
<Description>
<![CDATA[     D_Remark]]></Description>
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQDeptOrdItem("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DOI_Dept">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DOI_DeptID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DOI_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DOI_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DOI_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DOI_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DOI_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DOI_OrderCat">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DOI_OrderCatID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DOI_OrderItem">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DOI_OrderItemCat">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DOI_OrderItemCatID">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DOI_OrderItemID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQDeptOrdItem</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DOI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DOI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDept">
<Global>^DHCEQDeptOrdItem</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DOI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Dept"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DOI_DeptID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DOI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDeptOrdItem">
<Global>^DHCEQDeptOrdItem</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DOI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DeptOrdItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DOI_DeptID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DOI_OrderItemID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DOI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDepteOrdCatItem">
<Global>^DHCEQDeptOrdItem</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DOI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DeptOrdCatItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DOI_DeptID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DOI_OrderCatID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DOI_OrderItemCatID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DOI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdCat">
<Global>^DHCEQDeptOrdItem</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DOI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdCat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DOI_OrderCatID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DOI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdCatItem">
<Global>^DHCEQDeptOrdItem</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DOI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdCatItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DOI_OrderCatID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DOI_OrderItemCatID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DOI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQDeptOrdItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
