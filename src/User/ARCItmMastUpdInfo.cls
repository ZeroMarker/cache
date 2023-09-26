/// /记录医嘱项的有效日期
Class User.ARCItmMastUpdInfo Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DUPDI_RowId, SqlTableName = ARC_ItmMastUpdInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Property DUPDIARCIMDR As User.ARCItmMast [ Required, SqlColumnNumber = 2, SqlFieldName = DUPDI_ARCIM_DR ];

/// 开始日期
Property DUPDIEffDate As %Date [ SqlColumnNumber = 3, SqlFieldName = DUPDI_EffDate ];

/// 结束日期
Property DUPDIEffDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = DUPDI_EffDateTo ];

/// DUPDI_UpdDate		修改日期
Property DUPDIUpdDate As %Date [ SqlColumnNumber = 5, SqlFieldName = DUPDI_UpdDate ];

/// DUPDI_UpdTime		修改时间
Property DUPDIUpdTime As %Time [ SqlColumnNumber = 6, SqlFieldName = DUPDI_UpdTime ];

/// DUPDI_UpdUser		修改人
Property DUPDIUpdUser As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = DUPDI_UpdUser ];

/// DUPDI_Hospital_DR
Property DUPDIHospitalDR As User.CTHospital [ SqlColumnNumber = 8, SqlFieldName = DUPDI_Hospital_DR ];

Property DUPDIText As %String [ SqlColumnNumber = 9, SqlFieldName = DUPDI_Text ];

Property DUPDIText1 As %String [ SqlColumnNumber = 10, SqlFieldName = DUPDI_Text1 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^ARCIMDUPDI(0))</SqlIdExpression>
<SQLMap name="ARCIMIndex">
<Global>^ARCIMDUPDI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DUPDI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"ARCIM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DUPDI_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DUPDI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DUPDIMaster">
<Data name="DUPDI_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DUPDI_EffDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DUPDI_EffDateTo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DUPDI_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DUPDI_Text">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DUPDI_Text1">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DUPDI_UpdDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DUPDI_UpdTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DUPDI_UpdUser">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^ARCIMDUPDI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DUPDI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DUPDI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DUPDI_RowId</SqlRowIdName>
<StreamLocation>^User.ARCItmMastDataUpdInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
