/// Hospital Logo
/// 医院logo表
/// 基础数据平台 陈莹
/// 2022-06-23
Class User.CTHospitalLogo Extends (%Persistent, User.Abstract) [ ClassType = persistent, ProcedureBlock, SqlTableName = CT_HospitalLogo, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On LOGOChildsub [ IdKey, PrimaryKey, Unique ];

/// CT_Hospital Parent Reference
Relationship LOGOParRef As CTHospital [ Cardinality = parent, Inverse = ChildCTHospitalLogo, Required, SqlFieldName = LOGO_ParRef ];

/// Childsub
Property LOGOChildsub As %Float [ InitialExpression = {$i(^CT("HOSP",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"Logo",0))}, SqlColumnNumber = 2, SqlFieldName = LOGO_Childsub ];

/// 业务代码
Property LOGOCode As %String(MAXLEN = 999999) [ SqlColumnNumber = 3, SqlFieldName = LOGO_Code ];

/// logo Url地址
Property LOGOUrl As %String(MAXLEN = 999999) [ SqlColumnNumber = 4, SqlFieldName = LOGO_Url ];

/// 备注
Property LOGORemarks As %String(MAXLEN = 999999) [ SqlColumnNumber = 5, SqlFieldName = LOGO_Remarks ];

/// logo base64编码
Property LOGOImg As %String(MAXLEN = 999999) [ SqlColumnNumber = 6, SqlFieldName = LOGO_Img ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="LOGO_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LOGO_Img">
<Node>"IMG"</Node>
</Data>
<Data name="LOGO_Remarks">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LOGO_Url">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CT_Hospital.HOSP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>LOGO_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CT_Hospital.HOSP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"LOGO"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LOGO_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLOGOCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CT_Hospital.HOSP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>LOGO_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CT_Hospital.HOSP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"LOGO"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{LOGO_Code}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{LOGO_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LOGO_RowId</SqlRowIdName>
<StreamLocation>^User.CTHospitalLogoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
