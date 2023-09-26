/// RefDoctorOrgChange(2339)
Class User.PACRefDoctorOrgChange Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_RefDoctorOrgChange, StorageStrategy = SQLStorage ]
{

/// Childsub
Property ORGCChildsub As %Float [ InitialExpression = {$i(^PAC("REFD",$p(%d(0),$c(1)),"ORGC",0))}, SqlColumnNumber = 2, SqlFieldName = ORGC_Childsub ];

/// Date Change
Property ORGCDateChange As %Date [ SqlColumnNumber = 3, SqlFieldName = ORGC_DateChange ];

/// Des Ref HCA
Property ORGCHCADR As CTHealthCareArea [ SqlColumnNumber = 4, SqlFieldName = ORGC_HCA_DR ];

/// Des Ref HCR
Property ORGCHCRDR As CTHealthCareRegion [ SqlColumnNumber = 5, SqlFieldName = ORGC_HCR_DR ];

/// PAC_RefDoctor Parent Reference
Relationship ORGCParRef As PACRefDoctor [ Cardinality = parent, Inverse = ChildPACRefDoctorOrgChange, Required, SqlFieldName = ORGC_ParRef ];

Index RowIDBasedIDKeyIndex On ORGCChildsub [ IdKey, PrimaryKey, Unique ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ORGC_DateChange">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ORGC_HCA_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ORGC_HCR_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_RefDoctor.REFD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ORGC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"REFD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_RefDoctor.REFD_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ORGC"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ORGC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ORGC_RowId</SqlRowIdName>
<StreamLocation>^User.PACRefDoctorOrgChangeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
