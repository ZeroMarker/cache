/// 名称:用法与用量关联表
/// 编写者:基础数据平台组-陈莹
/// 编写日期: 2016-8-31
Class User.PHCInstrucLinkDosage Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ILD_RowId, SqlTableName = PHC_InstrucLinkDosage, StorageStrategy = SQLStorage ]
{

/// ^PHCINLD
Parameter EXTENTSIZE = 250;

/// 用法
Property ILDInstrucDR As User.PHCInstruc [ SqlColumnNumber = 2, SqlFieldName = ILD_Instruc_DR ];

/// 用量
Property ILDDosageDR As User.PHCDosage [ SqlColumnNumber = 3, SqlFieldName = ILD_Dosage_DR ];

/// 开始日期
Property ILDDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = ILD_DateFrom ];

/// 结束日期
Property ILDDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = ILD_DateTo ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^PHCINLD(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ILD_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ILD_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ILD_Dosage_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ILD_Instruc_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PHCINLD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ILD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{ILD_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="INDEXDosage">
<Global>^PHCINLD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ILD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"Dosage"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{ILD_Dosage_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{ILD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXInstruc">
<Global>^PHCINLD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ILD_RowId</Field>
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
<Expression>{ILD_Instruc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ILD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXLink">
<Global>^PHCINLD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ILD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"Link"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{ILD_Instruc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{ILD_Dosage_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{ILD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ILD_RowId</SqlRowIdName>
<StreamLocation>^User.PHCInstrucLinkDosageS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
