Class User.DHCDocProduceModule Extends %Persistent [ SqlTableName = DHCDocProduceModule, StorageStrategy = DHCDocProduceModule ]
{

Relationship ChildDHCDocProduceModuleConfig As User.DHCDocProduceModuleConfig [ Cardinality = children, Inverse = DocProduceModuleParRef ];

/// 模块代码
Property ProduceModuleCode As %Library.String [ SqlColumnNumber = 2, SqlFieldName = ProduceModuleCode ];

/// 模块描述
Property ProduceModuleDesc As %Library.String [ SqlColumnNumber = 3, SqlFieldName = ProduceModuleDesc ];

/// 是否激活
Property Active As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = Active ];

/// 关联类型 none无关联，indepcsp独立csp，linkcsp关联csp，loc关联科室，group关联安全组，arcim关联医嘱
Property LinkType As %Library.String [ SqlColumnNumber = 5, SqlFieldName = LinkType ];

/// 关联csp
Property Linkcsp As %Library.String(COLLATION = "Exact", MAXLEN = 30000, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = Linkcsp ];

/// 产品线层级指针 
Property ProduceLink As DHCDocProduce [ SqlColumnNumber = 7, SqlFieldName = ProduceLink ];

/// 父层级指针
Property ProduceModuleLink As %Library.String [ SqlColumnNumber = 8, SqlFieldName = ProduceModuleLink ];

/// 备注说明
Property Remark As %Library.String [ SqlColumnNumber = 9, SqlFieldName = Remark ];

/// 关联csp位置，up，down，left，right
Property Linkcsplocation As %Library.String [ SqlColumnNumber = 10, SqlFieldName = Linkcsplocation ];

/// 页面数据保存方法
Property SaveMethod As %Library.String(COLLATION = "Exact", MAXLEN = 30000, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = SaveMethod ];

/// 页面数据展示
Property ShowMethod As %Library.String(COLLATION = "Exact", MAXLEN = 30000, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = ShowMethod ];

Storage DHCDocProduceModule
{
<SqlIdExpression>$i(^DHCDocProduceModule(0))</SqlIdExpression>
<SQLMap name="IndexModuleLink">
<Global>^DHCDocProduceModulei</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ModuleLink"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ProduceModuleLink}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexProduceLink">
<Global>^DHCDocProduceModulei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PorduceLink"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ProduceLink}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="Active">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LinkType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Linkcsp">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="Linkcsplocation">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ProduceLink">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ProduceModuleCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ProduceModuleDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ProduceModuleLink">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="Remark">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SaveMethod">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ShowMethod">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^DHCDocProduceModule</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>RowID</SqlRowIdName>
<StreamLocation>^User.DHCDocProduceModuleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
