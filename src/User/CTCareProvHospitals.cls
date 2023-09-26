Class User.CTCareProvHospitals Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = CT_CareProvHospitals, StorageStrategy = SQLStorage ]
{

/// Childsub
Property HOSPChildsub As %Float [ InitialExpression = {$i(^CTPCP($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"HOSP",0))}, SqlColumnNumber = 2, SqlFieldName = HOSP_Childsub ];

/// Des Ref Hospital
Property HOSPHospitalDR As CTHospital [ SqlColumnNumber = 3, SqlFieldName = HOSP_Hospital_DR ];

Relationship HOSPParRef As CTCareProv [ Cardinality = parent, Inverse = ChildCTCareProvHospitals, Required, SqlFieldName = HOSP_ParRef ];

Index RowIDBasedIDKeyIndex On HOSPChildsub [ IdKey, PrimaryKey, Unique ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<Property name="HOSPChildsub"/>
<Property name="HOSPHospitalDR"/>
<Property name="HOSPParRef"/>
<SQLMap name="DataMaster">
<Data name="HOSP_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^CTPCP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_CareProv.CTPCP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>HOSP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_CareProv.CTPCP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HOSP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexHospital">
<Global>^CTPCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_CareProv.CTPCP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>HOSP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_CareProv.CTPCP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Hosp"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{HOSP_Hospital_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{HOSP_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>HOSP_RowId</SqlRowIdName>
<StreamLocation>^User.CTCareProvHospitalsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
