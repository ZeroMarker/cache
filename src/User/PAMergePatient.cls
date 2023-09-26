/// PA Merge Patient(1465)
Class User.PAMergePatient Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_MergePatient, StorageStrategy = SQLStorage ]
{

Relationship ChildPAMergePatientDetails As PAMergePatientDetails [ Cardinality = children, Inverse = DETParRef ];

/// Date
Property MRGDate As %Date [ SqlColumnNumber = 4, SqlFieldName = MRG_Date ];

/// Des Ref Hospital
Property MRGHospitalDR As CTHospital [ SqlColumnNumber = 8, SqlFieldName = MRG_Hospital_DR ];

/// Des Ref PAPMIFrom
Property MRGPAPMIFromDR As PAPatMas [ SqlColumnNumber = 2, SqlFieldName = MRG_PAPMI_From_DR ];

/// Des Ref PAPMI
Property MRGPAPMIToDR As PAPatMas [ SqlColumnNumber = 3, SqlFieldName = MRG_PAPMI_To_DR ];

/// Des Ref ReasonForMerging
Property MRGReasonForMergingDR As PACReasonForMerging [ SqlColumnNumber = 7, SqlFieldName = MRG_ReasonForMerging_DR ];

/// Time
Property MRGTime As %Time [ SqlColumnNumber = 5, SqlFieldName = MRG_Time ];

/// Des Ref User
Property MRGUserDR As SSUser [ SqlColumnNumber = 6, SqlFieldName = MRG_User_DR ];

Parameter EXTENTSIZE = 260;

Storage SQLStorage
{
<ExtentSize>260</ExtentSize>
<Property name="MRGDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="MRGHospitalDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="MRGPAPMIFromDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="MRGPAPMIToDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="MRGReasonForMergingDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="MRGTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="MRGUserDR">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAMR(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MRG_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MRG_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MRG_PAPMI_From_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MRG_PAPMI_To_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MRG_ReasonForMerging_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MRG_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MRG_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PAMR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MRG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MRG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPAPMITo">
<Global>^PAMRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>MRG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAT-TO"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MRG_PAPMI_To_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MRG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPatFrom">
<Global>^PAMRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>MRG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAT-FROM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MRG_PAPMI_From_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MRG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MRG_RowId</SqlRowIdName>
<StreamLocation>^User.PAMergePatientS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
