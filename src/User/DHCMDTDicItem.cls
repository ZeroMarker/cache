Class User.DHCMDTDicItem Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MD_RowID, SqlTableName = DHC_MDTDicItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MD_Code  代码
Property MDCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MD_Code ];

/// MD_Desc  描述
Property MDDesc As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MD_Desc ];

/// 是否可用  MD_ActiveFlag
Property MDActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = MD_ActiveFlag ];

/// 集团化医院  MD_Hosp_Dr
Property MDHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = MD_Hosp_Dr ];

/// 类型指针  MD_Type_Dr
Property MDTypeDr As User.DHCMDTDicType [ SqlColumnNumber = 6, SqlFieldName = MD_Type_Dr ];

/// 父节点ID  MD_Par_Dr
Property MDParDr As User.DHCMDTDicItem [ SqlColumnNumber = 7, SqlFieldName = MD_Par_Dr ];

/// MD_Notes[存Url]
Property MDNotes As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = MD_Notes ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMDTDI)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MD_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MD_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
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
<Piece>7</Piece>
</Data>
<Data name="MD_Par_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MD_Type_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCMDTDI</Global>
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
<Global>^DHCMDTDI</Global>
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
<Global>^DHCMDTDI</Global>
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
<SQLMap name="IndexPar">
<Global>^DHCMDTDI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Par"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MD_Par_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^DHCMDTDI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MD_Type_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMDTDicItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
