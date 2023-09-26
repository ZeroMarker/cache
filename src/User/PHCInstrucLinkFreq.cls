/// 名称:用法与频次关联表
/// 编写者:基础数据平台组-陈莹
/// 编写日期: 2016-8-31
Class User.PHCInstrucLinkFreq Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ILF_RowId, SqlTableName = PHC_InstrucLinkFreq, StorageStrategy = SQLStorage ]
{

/// ^PHCINLF
Parameter EXTENTSIZE = 250;

/// 用法
Property ILFInstrucDR As User.PHCInstruc [ SqlColumnNumber = 2, SqlFieldName = ILF_Instruc_DR ];

/// 频次
Property ILFFreqDR As User.PHCFreq [ SqlColumnNumber = 3, SqlFieldName = ILF_Freq_DR ];

/// 开始日期 
Property ILFDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = ILF_DateFrom ];

/// 结束日期
Property ILFDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = ILF_DateTo ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^PHCINLF(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ILF_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ILF_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ILF_Freq_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ILF_Instruc_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PHCINLF</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ILF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{ILF_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="INDEXFreq">
<Global>^PHCINLF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ILF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"Freq"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{ILF_Freq_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{ILF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXInstruc">
<Global>^PHCINLF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ILF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"Instruc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{ILF_Instruc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ILF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXLink">
<Global>^PHCINLF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ILF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Link"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{ILF_Instruc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{ILF_Freq_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{ILF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PHCInstrucLinkFreqS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
