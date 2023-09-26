/// PA Unmerge Patient(2028)
Class User.PAUnmergePatient Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_UnmergePatient, StorageStrategy = SQLStorage ]
{

/// Action
Property UNMRGAction As %String(DISPLAYLIST = ",Merge,Unmerge", MAXLEN = 7, TRUNCATE = 1, VALUELIST = ",M,U") [ SqlColumnNumber = 7, SqlFieldName = UNMRG_Action ];

/// Date
Property UNMRGDate As %Date [ SqlColumnNumber = 4, SqlFieldName = UNMRG_Date ];

/// Des Ref Hospital
Property UNMRGHospitalDR As CTHospital [ SqlColumnNumber = 10, SqlFieldName = UNMRG_Hospital_DR ];

/// Des Ref PAPMI From
Property UNMRGPAPMIFromDR As PAPatMas [ SqlColumnNumber = 2, SqlFieldName = UNMRG_PAPMI_From_DR ];

/// Des Ref PAPMI To
Property UNMRGPAPMIToDR As PAPatMas [ SqlColumnNumber = 3, SqlFieldName = UNMRG_PAPMI_To_DR ];

/// Des Ref ReasonMerge
Property UNMRGReasonMergeDR As PACReasonForUnmerging [ SqlColumnNumber = 9, SqlFieldName = UNMRG_ReasonMerge_DR ];

/// Des Ref ReasonUnmerge
Property UNMRGReasonUnmergeDR As PACReasonForUnmerging [ SqlColumnNumber = 8, SqlFieldName = UNMRG_ReasonUnmerge_DR ];

/// Time
Property UNMRGTime As %Time [ SqlColumnNumber = 5, SqlFieldName = UNMRG_Time ];

/// Des Ref User
Property UNMRGUserDR As SSUser [ SqlColumnNumber = 6, SqlFieldName = UNMRG_User_DR ];

Parameter EXTENTSIZE = 333;

Storage SQLStorage
{
<ExtentSize>333</ExtentSize>
<Property name="UNMRGAction">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="UNMRGDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="UNMRGHospitalDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="UNMRGPAPMIFromDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="UNMRGPAPMIToDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="UNMRGReasonMergeDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="UNMRGReasonUnmergeDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="UNMRGTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="UNMRGUserDR">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAUM(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="UNMRG_Action">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="UNMRG_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="UNMRG_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="UNMRG_PAPMI_From_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="UNMRG_PAPMI_To_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="UNMRG_ReasonMerge_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="UNMRG_ReasonUnmerge_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="UNMRG_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="UNMRG_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PAUM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>UNMRG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{UNMRG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPatFrom">
<Global>^PAUMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>UNMRG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAT-FROM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{UNMRG_PAPMI_From_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UNMRG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPatTo">
<Global>^PAUMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>UNMRG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAT-TO"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{UNMRG_PAPMI_To_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UNMRG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>UNMRG_RowId</SqlRowIdName>
<StreamLocation>^User.PAUnmergePatientS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
