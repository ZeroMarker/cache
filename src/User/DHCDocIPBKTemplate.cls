/// 住院证模板表，记录当前有效模板
Class User.DHCDocIPBKTemplate Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHCDocIPBKTemplate, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 1000;

/// 代码
Property TempCode As %String(COLLATION = "ALPHAUP", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = TempCode ];

/// 名称
Property TempDesc As %String(COLLATION = "EXACT", MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = TempDesc ];

/// 有效状态
Property IsActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = IsActive ];

/// 备注
Property ResumeText As %String(COLLATION = "EXACT", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = ResumeText ];

/// SQL存储结构
Storage SQLStorage
{
<Description>
<![CDATA[SQL存储结构]]></Description>
<ExtentSize>1000</ExtentSize>
<SqlIdExpression>$i(^DHCDocIPBKT(0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="IsActive">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ResumeText">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TempCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TempDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCDocIPBKT</Global>
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
<SQLMap name="IndexTempCode">
<Global>^DHCDocIPBKT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TempCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TempCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RowID</SqlRowIdName>
<StreamLocation>^User.DHCDocIPBKTemplateS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
