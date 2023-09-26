Class User.DHCAdvRepShare Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RSH_RowID, SqlTableName = DHC_AdvRepShare, StorageStrategy = NewStorage1 ]
{

/// RSH_Type_Dr  报告类型
Property RSHTypeDr As %String [ SqlColumnNumber = 2, SqlFieldName = RSH_Type_Dr ];

/// RSH_Pointer	 分享之后重新生成的报告ID
Property RSHPointer As %String [ SqlColumnNumber = 3, SqlFieldName = RSH_Pointer ];

Property RSHCreator As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = RSH_Creator ];

Property RSHCreateDate As %Date [ SqlColumnNumber = 5, SqlFieldName = RSH_CreateDate ];

Property RSHCreateTime As %Time [ SqlColumnNumber = 6, SqlFieldName = RSH_CreateTime ];

Property RSHCompleteDate As %Date [ SqlColumnNumber = 7, SqlFieldName = RSH_CompleteDate ];

Property RSHCompleteTime As %Time [ SqlColumnNumber = 8, SqlFieldName = RSH_CompleteTime ];

/// RSH_Parent_Dr	关联表ID 分享的原报告ID
Property RSHParentDr As User.DHCAdvMaster [ SqlColumnNumber = 9, SqlFieldName = RSH_Parent_Dr ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCADVRSH)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RSH_CompleteDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RSH_CompleteTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RSH_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RSH_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RSH_Creator">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RSH_Parent_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RSH_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RSH_Type_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCADVRSH</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RSH_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{RSH_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCADVRSH</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RSH_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CreateDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RSH_CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RSH_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexShare">
<Global>^DHCADVRSH</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RSH_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypePointer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RSH_Type_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RSH_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RSH_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvRepShareS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
