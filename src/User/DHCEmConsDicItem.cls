Class User.DHCEmConsDicItem Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EC_RowID, SqlTableName = DHC_EmConsDicItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// EC_Code  代码
Property ECCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = EC_Code ];

/// EC_Desc  描述
Property ECDesc As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = EC_Desc ];

/// 是否可用  EC_ActiveFlag
Property ECActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = EC_ActiveFlag ];

/// 集团化医院  EC_Hosp_Dr
Property ECHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = EC_Hosp_Dr ];

/// 类型指针  EC_Type_Dr
Property ECTypeDr As User.DHCEmConsDicType [ SqlColumnNumber = 6, SqlFieldName = EC_Type_Dr ];

/// 父节点  EC_Par_Dr
Property ECParDr As User.DHCEmConsDicItem [ SqlColumnNumber = 7, SqlFieldName = EC_Par_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEMCDI)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EC_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EC_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EC_Par_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EC_Type_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEMCDI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCEMCDI</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({EC_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EC_Hosp_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCEMCDI</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({EC_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EC_Hosp_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPar">
<Global>^DHCEMCDI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IndexPar"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EC_Par_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^DHCEMCDI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EC_Type_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmConsDicItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
