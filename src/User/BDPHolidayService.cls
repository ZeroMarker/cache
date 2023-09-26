/// 特别节假日情况关联记录表 add@20180205
/// 基础数据平台组-陈莹
Class User.BDPHolidayService Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = BDP_HolidayService, StorageStrategy = SQLStorage ]
{

/// ^CT("BDPHS")
/// 节假日(日期,64659）  1
Property BDPHSDate As %Date [ SqlColumnNumber = 2, SqlFieldName = BDPHS_Date ];

/// 特别业务  2
Property BDPHSServiceDR As User.BDPSpecialService [ SqlColumnNumber = 3, SqlFieldName = BDPHS_Service_DR ];

/// 标识，包含Include/例外Exclude   3
Property BDPHSIEFlag As %String [ SqlColumnNumber = 4, SqlFieldName = BDPHS_IEFlag ];

/// 描述 4
Property BDPHSDesc As %String [ SqlColumnNumber = 5, SqlFieldName = BDPHS_Desc ];

/// 医院 5
Property BDPHSHospitalDR As User.CTHospital [ SqlColumnNumber = 6, SqlFieldName = BDPHS_Hospital_DR ];

/// 时段 医生排班出诊时段设置表 6 User.DHCTimeRange
Property BDPHSTimeRangeDR As %String [ SqlColumnNumber = 7, SqlFieldName = BDPHS_TimeRange_DR ];

/// 类型 Holiday,Weekend 7
Property BDPHSType As %String [ SqlColumnNumber = 8, SqlFieldName = BDPHS_Type ];

Index BDPHSCodeUnqIdx1 On (BDPHSDate, BDPHSServiceDR);

Storage SQLStorage
{
<SqlIdExpression>$i(^CT("BDPHS",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BDPHS_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BDPHS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BDPHS_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BDPHS_IEFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BDPHS_Service_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BDPHS_TimeRange_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BDPHS_Type">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>BDPHS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"BDPHS"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{BDPHS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>BDPHS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"BDPHS"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{BDPHS_Date}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{BDPHS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFlagDate">
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>BDPHS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"BDPHS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"FlagDate"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BDPHS_IEFlag}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BDPHS_Date}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{BDPHS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexService">
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>BDPHS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"BDPHS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Service"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BDPHS_Service_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BDPHS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexServiceDate">
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>BDPHS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"BDPHS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ServiceDate"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BDPHS_Service_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BDPHS_Date}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{BDPHS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>BDPHS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"BDPHS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BDPHS_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BDPHS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeDate">
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>BDPHS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"BDPHS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"TypeDate"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BDPHS_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BDPHS_Date}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{BDPHS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>BDPHS_RowId</SqlRowIdName>
<StreamLocation>^User.BDPHolidayServiceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
