Class User.DHCDisRequestAsse Extends %Persistent [ SqlRowIdName = RA_RowId, SqlTableName = DHC_DisRequestAsse, StorageStrategy = NewStorage1 ]
{

/// 类型  RA_ReqType (0：陪送 1:配送)
Property RAReqType As %Text(MAXLEN = 30) [ SqlColumnNumber = 2, SqlFieldName = RA_ReqType ];

/// 陪送/配送id  RA_Pointer
Property RAPointer As %Text(MAXLEN = 120) [ SqlColumnNumber = 3, SqlFieldName = RA_Pointer ];

/// 得分  RA_Nubmer
Property RANubmer As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = RA_Nubmer ];

/// 备注  RA_Remarks
Property RARemarks As %Text(MAXLEN = 1000) [ SqlColumnNumber = 5, SqlFieldName = RA_Remarks ];

/// 创建日期  RA_CreateDate
Property RACreateDate As %Date [ SqlColumnNumber = 6, SqlFieldName = RA_CreateDate ];

/// 创建时间  RA_CreateTime
Property RACreateTime As %Time [ SqlColumnNumber = 7, SqlFieldName = RA_CreateTime ];

/// 创建人  RA_CreateUser
Property RACreateUser As %Integer [ SqlColumnNumber = 8, SqlFieldName = RA_CreateUser ];

Relationship RequestAsseItem As User.DHCDisRequestAsseI [ Cardinality = children, Inverse = Parref ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCDISRA)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RA_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RA_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RA_CreateUser">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RA_Nubmer">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RA_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RA_Remarks">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RA_ReqType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCDISRA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{RA_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="Index">
<Global>^DHCDISRA</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypePointer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RA_ReqType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RA_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RA_RowId</SqlRowIdName>
<StreamLocation>^User.DHCDisRequestAsseS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
