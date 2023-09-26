/// CTOR: QP
/// DATE: 2017-05-02
/// DESC: 抗菌药物统计分析报表配置表
Class DHCAnt.QRY.Base.RAQConfig Extends %Library.Persistent [ StorageStrategy = CacheSQLStorage ]
{

/// RCG_BEType  所属类型 
Property RCGBEType As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = RCG_BEType ];

/// RCG_CFGType  配置类型
Property RCGCFGType As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = RCG_CFGType ];

/// RCG_CFGDesc 配置描述
Property RCGCFGDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = RCG_CFGDesc ];

/// RCG_CFGValue 配置数值
Property RCGCFGValue As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = RCG_CFGValue ];

/// RCG_Active 是否激活
Property RCGActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = RCG_Active ];

/// RCG_ExtendA 备用字段1
Property RCGExtendA As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = RCG_ExtendA ];

/// RCG_ExtendB 备用字段2
Property RCGExtendB As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = RCG_ExtendB ];

/// RCG_ExtendC 备用字段3
Property RCGExtendC As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = RCG_ExtendC ];

/// RCG_ExtendD 备用字段4
Property RCGExtendD As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = RCG_ExtendD ];

Storage CacheSQLStorage
{
<SqlIdExpression>$i(^DHCAntQRYBaseRAQConfigD(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RCG_Active">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RCG_BEType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RCG_CFGDesc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RCG_CFGType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RCG_CFGValue">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RCG_ExtendA">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RCG_ExtendB">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RCG_ExtendC">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RCG_ExtendD">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCAntQRYBaseRAQConfigD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RCG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{RCG_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexRCGBEType">
<Global>^DHCAntQRYBaseRAQConfigI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RCG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"RCGBEType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RCG_BEType}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"S1"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RCG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRCGBETypeCFGType">
<Global>^DHCAntQRYBaseRAQConfigI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RCG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"RCGBEType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RCG_BEType}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"RCGCFGType"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RCG_CFGType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RCG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RCG_RowId</SqlRowIdName>
<StreamLocation>^DHCAnt.QRY.Base.RAQConfigS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
