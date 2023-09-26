/// 描述：医呼通-个人通讯录
/// 创建人：陈莹-基础数据平台
/// 创建日期：2020-12-15
/// 修改日期；2022-08-18
Class User.CTHCCSContactList Extends (%Persistent, User.Abstract) [ ClassType = persistent, ProcedureBlock, SqlTableName = CT_HCCSContactList, StorageStrategy = SQLStorage ]
{

/// 用户代码
Property HCCSCLUserCode As %String(MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = HCCSCL_UserCode ];

/// 科室代码
Property HCCSCLLocCode As %String(MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = HCCSCL_LocCode ];

/// VOIP号码
Property HCCSCLVOIPNumber As %String(MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = HCCSCL_VOIPNumber ];

/// 开始日期
Property HCCSCLDateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = HCCSCL_DateFrom ];

/// 结束日期
Property HCCSCLDateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = HCCSCL_DateTo ];

/// 用户描述
Property HCCSCLUserDesc As %String(MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 7, SqlFieldName = HCCSCL_UserDesc ];

/// 科室描述
Property HCCSCLLocDesc As %String(MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 8, SqlFieldName = HCCSCL_LocDesc ];

/// 患者标识--项目上新增
Property HCCSCLPatientFlag As %String(MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = HCCSCL_PatientFlag ];

/// 人员分类(医生D、护士N、其他O、虚拟账户V)
Property HCCSCLType As %String(MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = HCCSCL_Type ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^CT("HCCSCL",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="HCCSCL_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="HCCSCL_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="HCCSCL_LocCode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="HCCSCL_LocDesc">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="HCCSCL_PatientFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="HCCSCL_Type">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="HCCSCL_UserCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="HCCSCL_UserDesc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="HCCSCL_VOIPNumber">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>HCCSCL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"HCCSCL"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{HCCSCL_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>HCCSCL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"HCCSCL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{HCCSCL_LocCode}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{HCCSCL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>HCCSCL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"HCCSCL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"LocDesc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{HCCSCL_LocDesc}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{HCCSCL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>HCCSCL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"HCCSCL"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"User"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{HCCSCL_UserCode}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{HCCSCL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUserDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>HCCSCL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"HCCSCL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"UserDesc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{HCCSCL_UserDesc}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{HCCSCL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>HCCSCL_RowId</SqlRowIdName>
<StreamLocation>^User.CTHCCSContactListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
