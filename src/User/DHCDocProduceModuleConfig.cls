Class User.DHCDocProduceModuleConfig Extends %Persistent [ StorageStrategy = DHCDocProduceModuleConfig ]
{

Index RowIDBasedIDKeyIndex On DocProduceModuleChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_DocCureApp Parent Reference
Relationship DocProduceModuleParRef As User.DHCDocProduceModule [ Cardinality = parent, Inverse = ChildDHCDocProduceModuleConfig, Required, SqlFieldName = DocProduceModuleParRef ];

Property DocProduceModuleChildSub As %Library.Float [ InitialExpression = {$i(DHCDocProduceModule($p(%d(0),$c(1)),"I",0))}, SqlColumnNumber = 2, SqlFieldName = DocProduceModuleChildSub ];

/// 代码
Property ModuleConfigCode As %Library.String [ SqlColumnNumber = 3, SqlFieldName = ModuleConfigCode ];

/// 描述
Property ModuleConfigDesc As %Library.String [ SqlColumnNumber = 4, SqlFieldName = ModuleConfigDesc ];

/// 数据类型 checkbox,combobox,
Property ModuleConfigType As %Library.String [ SqlColumnNumber = 5, SqlFieldName = ModuleConfigType ];

/// 数据内容类型 json格式，m表达式
Property ModuleConfigDataType As %Library.String [ SqlColumnNumber = 6, SqlFieldName = ModuleConfigDataType ];

/// 数据内容
Property ModuleConfigData As %Library.String(MAXLEN = 100000000) [ SqlColumnNumber = 7, SqlFieldName = ModuleConfigData ];

/// 数据说明
Property ModuleConfigRemark As %Library.String [ SqlColumnNumber = 8, SqlFieldName = ModuleConfigRemark ];

/// 数据链接
Property ModuleConfigLinkStr As %Library.String(MAXLEN = 1000000) [ SqlColumnNumber = 9, SqlFieldName = ModuleConfigLinkStr ];

Storage DHCDocProduceModuleConfig
{
<SQLMap name="DataMaster">
<Data name="ModuleConfigCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ModuleConfigData">
<Node>"Data"</Node>
</Data>
<Data name="ModuleConfigDataType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ModuleConfigDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ModuleConfigLinkStr">
<Node>"Link"</Node>
</Data>
<Data name="ModuleConfigRemark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ModuleConfigType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCDocProduceModule</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCDocProduceModule.RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DocProduceModuleChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHCDocProduceModule.RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DocProduceModuleChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>RowID</SqlRowIdName>
<StreamLocation>^User.DHCDocProdu5AAAS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
