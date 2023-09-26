/// Prescriptions(2599)
Class User.MRPrescriptions Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_Prescriptions, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PRESCChildsub [ IdKey, PrimaryKey, Unique ];

/// MR_Adm Parent Reference
Relationship PRESCParRef As MRAdm [ Cardinality = parent, Inverse = ChildMRPrescriptions, Required, SqlFieldName = PRESC_ParRef ];

/// Childsub
Property PRESCChildsub As %Float [ InitialExpression = {$i(^MR($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"PRESC",0))}, SqlColumnNumber = 2, SqlFieldName = PRESC_Childsub ];

/// Des Ref DrugMaster
Property PRESCDrugMasterDR As PHCDrgMast [ SqlColumnNumber = 3, SqlFieldName = PRESC_DrugMaster_DR ];

/// Description
Property PRESCDesc As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = PRESC_Desc ];

/// Comments
Property PRESCComments As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PRESC_Comments, SqlListType = SUBNODE ];

/// Des Ref Doctor
Property PRESCDoctorDR As CTCareProv [ SqlColumnNumber = 6, SqlFieldName = PRESC_Doctor_DR ];

/// Date
Property PRESCDate As %Date [ SqlColumnNumber = 7, SqlFieldName = PRESC_Date ];

/// Time
Property PRESCTime As %Time [ SqlColumnNumber = 8, SqlFieldName = PRESC_Time ];

/// Des Ref User_DR
Property PRESCUserDR As SSUser [ SqlColumnNumber = 9, SqlFieldName = PRESC_User_DR ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PRESC_Comments">
<Node>"REM"</Node>
</Data>
<Data name="PRESC_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PRESC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PRESC_Doctor_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PRESC_DrugMaster_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PRESC_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PRESC_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PRESC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PRESC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PRESC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PRESC_RowId</SqlRowIdName>
<StreamLocation>^User.MRPrescriptionsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
