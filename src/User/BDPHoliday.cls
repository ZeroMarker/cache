/// 节假日 add@20180205
/// 基础数据平台组-陈莹
/// 节假日表
/// Created @20180205
Class User.BDPHoliday Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = BDP_Holiday, StorageStrategy = SQLStorage ]
{

/// 节假日(日期,64659）  1
Property BDPHDDate As %Date [ SqlColumnNumber = 2, SqlFieldName = BDPHD_Date ];

/// 节假日描述 2
Property BDPHDDesc As %String [ SqlColumnNumber = 3, SqlFieldName = BDPHD_Desc ];

/// 节假日类型 工作日Workday,节日Holiday，假日Weekend 3
Property BDPHDType As %String [ SqlColumnNumber = 4, SqlFieldName = BDPHD_Type ];

/// 半天标识1 4
Property BDPHDHalf1 As %String [ SqlColumnNumber = 5, SqlFieldName = BDPHD_Half1 ];

/// 半天标识2 5
Property BDPHDHalf2 As %String [ SqlColumnNumber = 6, SqlFieldName = BDPHD_Half2 ];

/// 用户 6
Property BDPHDUserDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = BDPHD_User_DR ];

/// 备注 7
Property BDPHDRemark As %String [ SqlColumnNumber = 8, SqlFieldName = BDPHD_Remark ];

/// 医院 8
Property BDPHDHospitalDR As User.CTHospital [ SqlColumnNumber = 9, SqlFieldName = BDPHD_Hospital_DR ];

Index BDPHDCodeUnqIdx1 On BDPHDDate;

Storage SQLStorage
{
<SqlIdExpression>$i(^CT("BDPHD",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BDPHD_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BDPHD_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BDPHD_Half1">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BDPHD_Half2">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BDPHD_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BDPHD_Remark">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BDPHD_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BDPHD_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>BDPHD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"BDPHD"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{BDPHD_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>BDPHD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"BDPHD"</Expression>
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
<Expression>{BDPHD_Date}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{BDPHD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>BDPHD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"BDPHD"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{BDPHD_Desc}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{BDPHD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>BDPHD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BDPHD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BDPHD_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BDPHD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeDate">
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>BDPHD_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"BDPHD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"TypeDate"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BDPHD_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BDPHD_Date}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{BDPHD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>BDPHD_RowId</SqlRowIdName>
<StreamLocation>^User.BDPHolidayS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
