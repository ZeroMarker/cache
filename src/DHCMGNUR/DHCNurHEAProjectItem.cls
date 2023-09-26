Class DHCMGNUR.DHCNurHEAProjectItem Extends %Persistent [ ClassType = persistent, ProcedureBlock, StorageStrategy = SQLStorage ]
{

/// 项目二
Property Item2 As %String(TRUNCATE = 1) [ Required, SqlFieldName = HEAPI_Item2 ];

/// 项目一指针
Property Item1DR As DHCMGNUR.DHCNurHEAProject [ SqlFieldName = HEAPI_Item1DR ];

/// 项目二描述
Property Describe As %String(MAXLEN = 1000, TRUNCATE = 1) [ SqlFieldName = HEAPI_Describe ];

/// 有效
Property Item2Valid As %String(TRUNCATE = 1) [ SqlFieldName = HEAPI_Item2Valid ];

Parameter EXTENTSIZE = 1000000;

Storage SQLStorage
{
<ExtentSize>1000000</ExtentSize>
<SqlIdExpression>$i(^HEDUAPI(0))</SqlIdExpression>
<SQLMap name="HEAProjectItemData">
<Data name="HEAPI_Describe">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="HEAPI_Item1DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="HEAPI_Item2">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="HEAPI_Item2Valid">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^HEDUAPI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>{HEAPI_RowId}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{HEAPI_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexHEAPCareDR">
<Global>^HEDUAPI</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>{HEAPI_RowId}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{HEAPI_Item1DR}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CARETEACH"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HEAPI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>HEAPI_RowId</SqlRowIdName>
<StreamLocation>^MHCMGNUR.DHCNurHEAProjectItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
