Class User.DHCEmFall Extends (%Persistent, %XML.Adaptor) [ Owner = {_SYSTEM}, SqlRowIdName = FALL_RowId, SqlTableName = DHC_EmFall, StorageStrategy = NewStorage1 ]
{

Relationship ChildDHCEMFALLITEM As User.DHCEmFallItem [ Cardinality = children, Inverse = FALLParRefDr ];

/// 项目描述 FALL_ItmDesc
Property FALLItmDesc As %Text(MAXLEN = 30) [ SqlColumnNumber = 2, SqlFieldName = FALL_ItmDesc ];

/// 项目代码 FALL_ItmCode
Property FALLItmCode As %Text(MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = FALL_ItmCode ];

/// 是否可用 FALL_ActiveFlag
Property FALLActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = FALL_ActiveFlag ];

/// 集团化医院 FALL_Hosp_Dr
Property FALLHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = FALL_Hosp_Dr ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCEMFALL)</SqlIdExpression>
<SQLMap name="IndexHos">
<Global>^DHCEMFALL</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CodeHos"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{FALL_Hosp_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{FALL_ItmCode}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{FALL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="FALL_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="FALL_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="FALL_ItmCode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="FALL_ItmDesc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEMFALL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>FALL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{FALL_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexCode">
<Global>^DHCEMFALL</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>FALL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{FALL_ItmCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{FALL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmFallS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
