/// 基础数据平台-临床知识库-检查结果表
Class User.DHCExamineFeild Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = Exa_RowId, SqlTableName = DHC_ExamineFeild, StorageStrategy = SQLStorage ]
{

// ^DHCEXAMINE

Property ExaCode As %String [ SqlColumnNumber = 2, SqlFieldName = Exa_Code ];

Property ExaResult As %String [ SqlColumnNumber = 3, SqlFieldName = Exa_Result ];

Property ExaLibDr As User.DHCPHLibaryLabel [ SqlColumnNumber = 4, SqlFieldName = Exa_Lib_Dr ];

Property ExaActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = Exa_ActiveFlag ];

Property ExaSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = Exa_SysFlag ];

Property ExaDataPool As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = Exa_DataPool ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCEXAMINE(0))</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCEXAMINEi</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>Exa_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({Exa_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Exa_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexResult">
<Global>^DHCEXAMINEi</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({Exa_Result})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Exa_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="Exa_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Exa_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Exa_DataPool">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="Exa_Lib_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Exa_Result">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Exa_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEXAMINE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Exa_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{Exa_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>Exa_RowId</SqlRowIdName>
<StreamLocation>^User.DHCExamineFeildS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
