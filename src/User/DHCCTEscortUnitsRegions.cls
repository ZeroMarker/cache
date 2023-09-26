/// 编写者：基础数据平台组-陈莹
/// 创建日期: 2017-12-14
/// 监区---监狱（公安医院送押单位）的子表  
/// global: ^DHCCTEU("EU",Rowid,"EUR")
Class User.DHCCTEscortUnitsRegions Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DHC_CTEscortUnitsRegions, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On EURChildsub [ IdKey, PrimaryKey, Unique ];

/// Parent Reference
Relationship EURParRef As User.DHCCTEscortUnits [ Cardinality = parent, Inverse = ChildEURegions, Required, SqlFieldName = EUR_ParRef ];

/// Childsub
Property EURChildsub As %Float [ InitialExpression = {$i(^DHCCTEU("EU",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"EUR",0))}, SqlColumnNumber = 2, SqlFieldName = EUR_Childsub ];

/// 监区代码  注意:索引里为$$UPPER 
Property EURCode As %String(COLLATION = "UPPER", MAXLEN = 100, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = EUR_Code ];

/// 监区名称 注意:索引里为$$UPPER
Property EURDesc As %String(COLLATION = "UPPER", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = EUR_Desc ];

/// 开始日期
Property EURDateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = EUR_DateFrom ];

/// 结束日期
Property EURDateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = EUR_DateTo ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="EUR_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EUR_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EUR_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EUR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCCTEU</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHC_CTEscortUnits.EU_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>EUR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EU"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHC_CTEscortUnits.EU_Rowid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"EUR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EUR_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexRegionsCode">
<Global>^DHCCTEU</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_CTEscortUnits.EU_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>EUR_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"EU"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"EURCode"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$UPPER({EUR_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_CTEscortUnits.EU_Rowid}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{EUR_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRegionsDesc">
<Global>^DHCCTEU</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_CTEscortUnits.EU_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>EUR_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"EU"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"EURDesc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$UPPER({EUR_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_CTEscortUnits.EU_Rowid}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{EUR_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>EUR_RowId</SqlRowIdName>
<StreamLocation>^User.DHCCTEscortUnitsRegionsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
