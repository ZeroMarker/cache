Class User.DHCAppItemTemp Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AIT_RowID, SqlTableName = DHC_AppItemTemp, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCAPPITEMTEMPD As User.DHCAppItemTempD [ Cardinality = children, Inverse = AITTempParRef ];

/// 代码  AIT_Code
Property AITCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = AIT_Code ];

/// 描述  AIT_Desc
Property AITDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = AIT_Desc ];

/// 是否可用  AIT_ActiveFlag
Property AITActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = AIT_ActiveFlag ];

/// 集团化医院  AIT_Hosp_Dr
Property AITHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = AIT_Hosp_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCAPITMTE)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AIT_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AIT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AIT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AIT_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCAPITMTE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AIT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{AIT_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCAPITMTE</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AIT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({AIT_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AIT_Hosp_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AIT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCAPITMTE</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AIT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({AIT_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AIT_Hosp_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AIT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAppItemTempS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
