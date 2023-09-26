Class User.DHCEmPreHosReg Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = EM_RowID, SqlTableName = DHC_EmPreHosReg, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCEmPreHosRegItem As User.DHCEmPreHosRegItem [ Cardinality = children, Inverse = EWParRefDr ];

/// 就诊ID   EM_Adm_Dr
Property EMAdmDr As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = EM_Adm_Dr ];

/// 登记日期  EM_RDate
Property EMRDate As %Library.Date [ SqlColumnNumber = 3, SqlFieldName = EM_RDate ];

/// 登记时间  EM_RTime
Property EMRTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = EM_RTime ];

/// 登记人  EM_RUser_Dr
Property EMRUserDr As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = EM_RUser_Dr ];

/// 关联派车ID EM_ParRef_Dr
Property EMParRefDr As User.DHCEmDisAmbMan [ SqlColumnNumber = 6, SqlFieldName = EM_ParRef_Dr ];

/// d ##class(User.DHCEmPreHosReg).%BuildIndices()
Storage SQLStorage
{
<Description>
<![CDATA[d ##class(User.DHCEmPreHosReg).%BuildIndices()]]></Description>
<SqlIdExpression>$i(^DHCEMPHR)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EM_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EM_ParRef_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EM_RDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EM_RTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EM_RUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEMPHR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{EM_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDisAmb">
<Global>^DHCEMPHR</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DISAMB"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EM_ParRef_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmPreHosRegS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
