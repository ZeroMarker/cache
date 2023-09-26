Class User.DHCDisRequestCode Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = RC_RowId, SqlTableName = DHC_DisRequestCode, StorageStrategy = SQLStorage ]
{

/// 类型/RC_ReqType
Property RCReqType As %Text(MAXLEN = 30) [ SqlColumnNumber = 2, SqlFieldName = RC_ReqType ];

/// 陪送/配送id RC_Pointer
Property RCPointer As %Text(MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = RC_Pointer ];

/// 代码
Property RCCode As %Text(MAXLEN = 30) [ SqlColumnNumber = 4, SqlFieldName = RC_Code ];

/// 创建日期 RC_CreateDate
Property RCCreateDate As %Date [ SqlColumnNumber = 5, SqlFieldName = RC_CreateDate ];

/// 创建时间 RC_CreateTime
Property RCCreateTime As %Time [ SqlColumnNumber = 6, SqlFieldName = RC_CreateTime ];

/// 创建人 RC_CreateUser
Property RCCreateUser As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = RC_CreateUser ];

/// 是否可用  RC_ActiveFlag
Property RCActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 4, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = RC_ActiveFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCDISRC)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RC_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RC_Code">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RC_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RC_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RC_CreateUser">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RC_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RC_ReqType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCDISRC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{RC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="PointorIndex">
<Global>^DHCDISRC</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypePointer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RC_ReqType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RC_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDisRequestCodeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
