/// 公安医院送押单位（监狱） DHC_CTEscortUnits  ^DHCCTEU("EU",Rowid)
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2017-10-11
Class User.DHCCTEscortUnits Extends %Persistent [ SqlRowIdName = EU_Rowid, SqlTableName = DHC_CTEscortUnits, StorageStrategy = SQLStorage ]
{

/// 子表 监区
Relationship ChildEURegions As User.DHCCTEscortUnitsRegions [ Cardinality = children, Inverse = EURParRef ];

/// 代码
Property EUCode As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = EU_Code ];

/// 描述
Property EUDesc As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = EU_Desc ];

/// 别名
Property EUAlias As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = EU_Alias ];

/// 联系方式
Property EUContect As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = EU_Contect ];

/// 负责人(监狱长)
Property EULeader As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = EU_Leader ];

/// 开始日期
Property EUStartDate As %Date [ SqlColumnNumber = 7, SqlFieldName = EU_StartDate ];

/// 结束日期
Property EUEndDate As %Date [ SqlColumnNumber = 8, SqlFieldName = EU_EndDate ];

/// Des Ref Hospital ,所属医院
Property EUHospitalDR As CTHospital [ SqlColumnNumber = 9, SqlFieldName = EU_Hospital_DR ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCCTEU("EU",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EU_Alias">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EU_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EU_Contect">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EU_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EU_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="EU_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="EU_Leader">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EU_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCCTEU</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>EU_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"EU"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{EU_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCTEU</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EU_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"EU"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({EU_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EU_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCCTEU</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EU_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"EU"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({EU_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EU_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCCTEscortUnitsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
