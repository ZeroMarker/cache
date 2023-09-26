Class User.DHCAppTestPack Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ATP_RowID, SqlTableName = DHC_AppTestPack, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCAPPTestPackItm As User.DHCAppTestPackItm [ Cardinality = children, Inverse = ATPIATPParRef ];

/// 套餐代码  ATP_Code
Property ATPCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ATP_Code ];

/// 套餐描述  ATP_Desc
Property ATPDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ATP_Desc ];

/// 集团化医院  ATP_Hosp_Dr
Property ATPHospDr As User.CTHospital [ SqlColumnNumber = 4, SqlFieldName = ATP_Hosp_Dr ];

/// 是否可用  ATP_ActiveFlag
Property ATPActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = ATP_ActiveFlag ];

/// 检查分类ID  ATP_Cat_Dr
Property ATPCatDr As User.DHCAppArcCat [ SqlColumnNumber = 6, SqlFieldName = ATP_Cat_Dr ];

/// 检测分类ID  ATP_TesCat_Dr
Property ATPTesCatDr As User.DHCAppTestCat [ SqlColumnNumber = 7, SqlFieldName = ATP_TesCat_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCAPPTP)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCAPPTP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ATP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({ATP_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ATP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCAPPTP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ATP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({ATP_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ATP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="ATP_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ATP_Cat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ATP_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ATP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ATP_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ATP_TesCat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCAPPTP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ATP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ATP_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAppTestPackS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
