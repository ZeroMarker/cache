/// 名称：确诊病症指南
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2017-4-12
Class User.DHCPHDiseaseGuide Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = PDG_RowId, SqlTableName = DHC_PHDiseaseGuide, StorageStrategy = SQLStorage ]
{

// ^DHCPHDISGU,^DHCPHDISGUi PDG_RowId

Property PDGDisDr As DHCPHDiseaseList [ SqlColumnNumber = 2, SqlFieldName = PDG_Dis_Dr ];

Property PDGLabelDr As DHCPHGuideLabel [ SqlColumnNumber = 3, SqlFieldName = PDG_Label_Dr ];

/// PDGLabelDr为症状的时候，PDGId存分类标识为症状体征的知识库关键字DHC_PHKeyWord字典rowid,
/// PDGLabelDr为检查的时候，PDGId存知识库标识为检查项目的通用名DHC_PHExtGeneric字典rowid,
/// PDGLabelDr为检验的时候，PDGId存知识库标识为检验项目的通用名DHC_PHExtGeneric字典rowid,
/// PDGLabelDr为病症的时候，PDGId存病症DHC_PHDiseaseList字典rowid,
Property PDGId As %String [ SqlColumnNumber = 4, SqlFieldName = PDG_Id ];

Property PDGText As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PDG_Text ];

Property PDGSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = PDG_SysFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHDISGU(0))</SqlIdExpression>
<SQLMap name="DisDrIndex">
<Global>^DHCPHDISGUi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PDG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Dis"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDG_Dis_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="LabelIndex">
<Global>^DHCPHDISGUi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PDG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Label"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDG_Dis_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDG_Label_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PDG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PDG_Dis_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PDG_Id">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PDG_Label_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PDG_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PDG_Text">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPHDISGU</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PDG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PDG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PDG_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHDiseaseGuideS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
