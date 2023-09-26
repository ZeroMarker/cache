Class User.DHCDisRequestSta Extends %Persistent [ ProcedureBlock, SqlRowIdName = RS_RowID, SqlTableName = DHC_DisRequestSta, StorageStrategy = NewStorage1 ]
{

// Index RowIDBasedIDKeyIndex On RSChildSub [ IdKey, PrimaryKey, Unique ];

// Relationship RSParRefDr As User.DHCDisRequest [ Cardinality = parent, Inverse = ChildDHCDisRequestSta ];

// 子表sub REQ_ChildSub	

// Property RSChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = RS_ChildSub ];

/// 类型 RS_ReqType
Property RSReqType As %Text(MAXLEN = 30) [ SqlColumnNumber = 2, SqlFieldName = RS_ReqType ];

/// 陪送/配送id RS_Pointer
Property RSPointer As %Text(MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = RS_Pointer ];

/// 当前状态 RS_CurStatus
Property RSCurStatus As %Text(MAXLEN = 30) [ SqlColumnNumber = 4, SqlFieldName = RS_CurStatus ];

/// 创建日期 RS_CreateDate
Property RSCreateDate As %Date [ SqlColumnNumber = 5, SqlFieldName = RS_CreateDate ];

/// 创建时间 RS_CreateTime
Property RSCreateTime As %Time [ SqlColumnNumber = 6, SqlFieldName = RS_CreateTime ];

/// 创建人 RS_CreateUser
Property RSCreateUser As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = RS_CreateUser ];

/// 原因 RS_Reason_Dr
Property RSReasonDr As User.DHCDisFailReason [ SqlColumnNumber = 8, SqlFieldName = RS_Reason_Dr ];

/// 申请单位置  REQ_Loction	
Property RSLoction As %Text(MAXLEN = 30) [ SqlColumnNumber = 9, SqlFieldName = RS_Loction ];

/// 申请单位置标识  REQ_LoctionFlag	
Property RSLoctionFlag As %Text(MAXLEN = 30) [ SqlColumnNumber = 10, SqlFieldName = RS_LoctionFlag ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCDISRS)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RS_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RS_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RS_CreateUser">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RS_CurStatus">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RS_Loction">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RS_LoctionFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="RS_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RS_Reason_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RS_ReqType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCDISRS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{RS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="Index">
<Global>^DHCDISRS</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypePointer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RS_ReqType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RS_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCDISRS</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypeDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RS_ReqType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RS_CreateDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDisRequestStaS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
