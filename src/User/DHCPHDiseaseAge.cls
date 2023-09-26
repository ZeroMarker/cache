/// 名称: 药品业务表 年龄限制维护 
/// 编写者:基础数据平台组-陈莹
/// 编写日期: 2014-12-3
Class User.DHCPHDiseaseAge Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = PDA_RowId, SqlTableName = DHC_PHDiseaseAge, StorageStrategy = SQLStorage ]
{

/// PDA_RowId  ^DHCPHDISAGE
Property PDAInstDr As DHCPHInstructions [ SqlColumnNumber = 2, SqlFieldName = PDA_Inst_Dr ];

Property PDAAgeDr As DHCPHPatAgeList [ SqlColumnNumber = 3, SqlFieldName = PDA_Age_Dr ];

Property PDAMinVal As %Float [ SqlColumnNumber = 4, SqlFieldName = PDA_Min_Val ];

Property PDAMaxVal As %Float [ SqlColumnNumber = 5, SqlFieldName = PDA_Max_Val ];

Property PDAUomDr As User.DHCPHExtUom [ SqlColumnNumber = 6, SqlFieldName = PDA_Uom_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHDISAGE(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PDA_Age_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PDA_Inst_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PDA_Max_Val">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PDA_Min_Val">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PDA_Uom_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCPHDISAGE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PDA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PDA_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInst">
<Global>^DHCPHDISAGE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PDA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Inst"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDA_Inst_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PDA_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHDiseaseAgeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
