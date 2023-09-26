Class User.DHCMDTGroup Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MD_RowID, SqlTableName = DHC_MDTGroup, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCMDTGROUPITM As User.DHCMDTGroupItm [ Cardinality = children, Inverse = MDParRefDr ];

/// MD_Code  代码
Property MDCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MD_Code ];

/// MD_Desc  描述
Property MDDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MD_Desc ];

/// 是否可用  MD_ActiveFlag
Property MDActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = MD_ActiveFlag ];

/// 集团化医院  MD_Hosp_Dr
Property MDHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = MD_Hosp_Dr ];

/// MD_ConsAddress  会诊地址描述
Property MDConsAddress As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = MD_ConsAddress ];

/// MD_Notes  会诊备注描述
Property MDNotes As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MD_Notes ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMDTG)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MD_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MD_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MD_ConsAddress">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MD_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MD_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MD_Notes">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCMDTG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MD_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCMDTG</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({MD_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MD_Hosp_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCMDTG</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({MD_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MD_Hosp_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMDTGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
