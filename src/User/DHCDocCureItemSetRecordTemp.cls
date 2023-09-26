Class User.DHCDocCureItemSetRecordTemp Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdPrivate, SqlTableName = DHC_DocCureItemSet_RecordTemp, StorageStrategy = StorageSQL ]
{

Index RowIDBasedIDKeyIndex On DDCRTChildSub [ IdKey, PrimaryKey, Unique ];

/// DDCRTParRef
Relationship DDCRTParRef As User.DHCDocCureItemSet [ Cardinality = parent, Inverse = ChildDHCDocCureItemSetRT, Required, SqlFieldName = DDCRT_ParRef ];

/// DDCRTChildSub
Property DDCRTChildSub As %Library.Float [ InitialExpression = {$i(^DHCDocCureItemSet(+$s($d(initvalue):initvalue,1:%d(0)),"RT",0))}, SqlColumnNumber = 2, SqlFieldName = DDCRT_ChildSub ];

/// 标题
Property DDCRTTitle As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 3, SqlFieldName = DDCRT_Title ];

/// 内容详细
Property DDCRTDetail As %Library.String(MAXLEN = 9999) [ SqlColumnNumber = 4, SqlFieldName = DDCRT_Detail ];

/// 类型
Property DDCRTType As %Library.String [ SqlColumnNumber = 5, SqlFieldName = DDCRT_Type ];

/// 治疗反应
Property DDCRTResponse As %Library.String(MAXLEN = 9999) [ SqlColumnNumber = 6, SqlFieldName = DDCRT_Response ];

/// 治疗效果
Property DDCRTEffect As %Library.String(MAXLEN = 9999) [ SqlColumnNumber = 7, SqlFieldName = DDCRT_Effect ];

/// 模板保存类型 U：用户 L：科室 C：通用(治疗项目设置，治疗记录模板维护)
Property DDCRTSaveAs As %Library.String(DISPLAYLIST = ",USER,LOC,COMMON", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",U,L,C") [ SqlColumnNumber = 8, SqlFieldName = DDCRT_SaveAs ];

/// 模板保存要素
Property DDCRTSavePointer As %Library.String [ SqlColumnNumber = 9, SqlFieldName = DDCRT_SavePointer ];

/// 模板保存用户
Property DDCRTSaveUserDr As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = DDCRT_SaveUser_Dr ];

/// 模板保存其他扩展字段 以Json字符串格式保存
Property DDCRTExpJsonStr As %Library.String(MAXLEN = 9999) [ SqlColumnNumber = 11, SqlFieldName = DDCRT_ExpJsonStr ];

/// 模板保存时用的单据模板
Property DDCRTMapID As %Library.String [ SqlColumnNumber = 12, SqlFieldName = DDCRT_MapID ];

Storage StorageSQL
{
<SQLMap name="DataMaster">
<Data name="DDCRT_Detail">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DDCRT_Effect">
<Node>"E"</Node>
</Data>
<Data name="DDCRT_ExpJsonStr">
<Node>"Exp"</Node>
</Data>
<Data name="DDCRT_MapID">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DDCRT_Response">
<Node>"R"</Node>
</Data>
<Data name="DDCRT_SaveAs">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DDCRT_SavePointer">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DDCRT_SaveUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DDCRT_Title">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DDCRT_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCDocCureItemSet</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DocCureItemSet.DDCIS_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DDCRT_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_DocCureItemSet.DDCIS_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDCRT_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^DHCDocCureItemSet</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_DocCureItemSet.DDCIS_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>DDCRT_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RTType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDCRT_SaveAs}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_DocCureItemSet.DDCIS_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"RT"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DDCRT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DDCRT_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCDocCureItemSetPlanS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
