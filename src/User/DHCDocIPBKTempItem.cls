/// 住院证模板项目字典表，记录住院证界面字段
Class User.DHCDocIPBKTempItem Extends %Library.Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHCDocIPBKTempItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 1000;

/// 代码
Property ItemCode As %String(COLLATION = "ALPHAUP", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = ItemCode ];

/// 描述
Property ItemDesc As %String(COLLATION = "EXACT", MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ItemDesc ];

/// 指向DHCDocIPBDictory
Property DateTypeID As DHCDocIPBDictory [ SqlColumnNumber = 4, SqlFieldName = DateTypeID ];

/// 字典名称代码
Property DictionaryName As %String(COLLATION = "ALPHAUP", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DictionaryName ];

/// 有效状态
Property IsActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = IsActive ];

/// 备注
Property ResumeText As %String(COLLATION = "EXACT", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = ResumeText ];

/// SQL存储结构
Storage SQLStorage
{
<Description>
<![CDATA[SQL存储结构]]></Description>
<ExtentSize>1000</ExtentSize>
<SqlIdExpression> $i(^DHCDocIPBKTI(0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="DateTypeID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DictionaryName">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IsActive">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ItemCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ItemDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ResumeText">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCDocIPBKTI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexItemCode">
<Global>^DHCDocIPBKTI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"ItemCode"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{ItemCode}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RowID</SqlRowIdName>
<StreamLocation>^User.DHCDocIPBKTempItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
