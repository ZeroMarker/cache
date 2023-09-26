/// 名称: 药品业务表 3用药方法维护 
/// 编写者:基础数据平台组-陈莹
/// 编写日期: 2014-12-2
Class User.DHCPHDiseaseUse Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = PDI_RowId, SqlTableName = DHC_PHDiseaseUse, StorageStrategy = SQLStorage ]
{

/// PDI_RowId  ^DHCPHDISUSE
Property PDIInstDr As DHCPHInstructions [ SqlColumnNumber = 2, SqlFieldName = PDI_Inst_Dr ];

Property PDIUseDR As DHCPHExtInstruc [ SqlColumnNumber = 3, SqlFieldName = PDI_Use_DR ];

Property PDIExcludeFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PDI_ExcludeFlag ];

/// PDI_AlertMsg  2016/10/13
Property PDIAlertMsg As %String(MAXLEN = 800) [ SqlColumnNumber = 5, SqlFieldName = PDI_AlertMsg ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHDISUSE(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PDI_AlertMsg">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PDI_ExcludeFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PDI_Inst_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PDI_Use_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHDISUSE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PDI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PDI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInst">
<Global>^DHCPHDISUSE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PDI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Inst"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDI_Inst_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PDI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHDiseaseUseS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
