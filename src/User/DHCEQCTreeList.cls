Class User.DHCEQCTreeList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = TL_RowID, SqlTableName = DHC_EQCTreeList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// TL_TreeDR
Property TLTreeDR As User.DHCEQCTree [ SqlColumnNumber = 2, SqlFieldName = TL_TreeDR ];

/// TL_ProductDesc
Property TLProductDesc As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = TL_ProductDesc ];

/// TL_PurPoseDesc
Property TLPurPoseDesc As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = TL_PurPoseDesc ];

/// TL_ProductNames
Property TLProductNames As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = TL_ProductNames ];

/// TL_ManageLevel
Property TLManageLevel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = TL_ManageLevel ];

/// TL_Hold1
Property TLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = TL_Hold1 ];

/// TL_Hold2
Property TLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = TL_Hold2 ];

/// TL_Hold3
Property TLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = TL_Hold3 ];

/// TL_Hold4
Property TLHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = TL_Hold4 ];

/// TL_Hold5
Property TLHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = TL_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCTreeList",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="TL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="TL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="TL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="TL_ManageLevel">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TL_ProductDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TL_ProductNames">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TL_PurPoseDesc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TL_TreeDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>TL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"DHCEQCTreeList"</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>{TL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTreeDR">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCTreeList"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"TreeDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TL_TreeDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCTreeLists</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
