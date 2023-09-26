/// 住院证模板明细表，记录当前模板内的明细内容
Class User.DHCDocIPBKTempDtl Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHCDocIPBKTempDtl, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 1000;

/// 模板ID 指向DHCDocIPBKTemplate
Property TempID As DHCDocIPBKTemplate [ SqlColumnNumber = 2, SqlFieldName = TempID ];

/// 项目ID 指向DHCDocIPBKTempItem
Property ItemID As DHCDocIPBKTempItem [ SqlColumnNumber = 3, SqlFieldName = ItemID ];

/// 默认值 字典项目可存指针
Property DefaultValue As %String(COLLATION = "EXACT", MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = DefaultValue ];

/// 是否必需
Property IsNeed As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = IsNeed ];

/// 提示
Property ToolTip As %String(COLLATION = "EXACT", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = ToolTip ];

/// 备注
Property ResumeText As %String(COLLATION = "EXACT", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = ResumeText ];

/// SQL存储过程
Storage SQLStorage
{
<Description>
<![CDATA[SQL存储过程]]></Description>
<ExtentSize>1000</ExtentSize>
<SqlIdExpression>$i(^DHCDocIPBKTD(0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="DefaultValue">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IsNeed">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ItemID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ResumeText">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TempID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ToolTip">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCDocIPBKTD</Global>
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
<SQLMap name="IndexTempItem">
<Global>^DHCDocIPBKTD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"TempItem"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{TempID}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{ItemID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RowID</SqlRowIdName>
<StreamLocation>^User.DHCDocIPBKTempDtlS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
