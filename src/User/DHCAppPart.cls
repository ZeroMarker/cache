Class User.DHCAppPart Extends (%Persistent, %XML.Adaptor, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AP_RowId, SqlTableName = DHC_AppPart, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCAPPPARTITM As User.DHCAppPartItm [ Cardinality = children, Inverse = APIParRefDr ];

/// 代码
Property APCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = AP_Code ];

/// 描述
Property APDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = AP_Desc ];

/// 上一级的rowid
Property APParPDr As %Library.String [ SqlColumnNumber = 4, SqlFieldName = AP_LastRowid ];

/// 级别
Property APLevel As %Library.Numeric [ SqlColumnNumber = 5, SqlFieldName = AP_Level ];

/// 是否可用
Property APActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = AP_ActiveFlag ];

/// 集团化医院  AP_Hosp_Dr
Property APHospDr As User.CTHospital [ SqlColumnNumber = 7, SqlFieldName = AP_Hosp_Dr ];

/// 部位数
Property APPartNum As %Library.Numeric [ SqlColumnNumber = 8, SqlFieldName = AP_PartNum ];

/// 顺序号
Property APOrdNum As %Library.Numeric [ SqlColumnNumber = 9, SqlFieldName = AP_OrdNum ];

/// AP_Alias 别名
Property APAlias As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = AP_Alias ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCAPPART)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCAPPART</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AP_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCAPPART</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AP_Desc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexParref">
<Global>^DHCAPPART</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Parref"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AP_LastRowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="dataMaster">
<Data name="AP_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AP_Alias">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AP_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AP_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AP_LastRowid">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AP_Level">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AP_OrdNum">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AP_PartNum">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCAPPART</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{AP_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexOrdnum">
<Global>^DHCAPPART</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdNum"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AP_LastRowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AP_OrdNum}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAppPartS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
