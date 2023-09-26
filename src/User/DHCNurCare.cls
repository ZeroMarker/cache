/// DHC_NurCare
Class User.DHCNurCare Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = NC_RowId, SqlTableName = DHC_NurCare, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCNurCarePlan As User.DHCNurCarePlan [ Cardinality = children, Inverse = NCPParref ];

/// NC_Adm_Dr
Property NCAdmDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = NC_Adm_Dr ];

/// NC_Specialty
Property NCSpecialty As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = NC_Specialty ];

/// NC_Assess
Property NCAssess As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = NC_Assess ];

/// NC_AssessReason
Property NCAssessReason As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = NC_AssessReason ];

/// NC_NurDiag_Dr
Property NCNurDiagDr As User.DHCNurCICD [ SqlColumnNumber = 6, SqlFieldName = NC_NurDiag_Dr ];

/// NC_Priority
Property NCPriority As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = NC_Priority ];

/// NC_StartDate
Property NCStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = NC_StartDate ];

/// NC_StartTime
Property NCStartTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = NC_StartTime ];

/// NC_EndDate
Property NCEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = NC_EndDate ];

/// NC_EndTime
Property NCEndTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = NC_EndTime ];

/// NC_CreateCtcp_Dr
Property NCCreateCtcpDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = NC_CreateCtcp_Dr ];

/// NC_CreateDate
Property NCCreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = NC_CreateDate ];

/// NC_CreateTime
Property NCCreateTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = NC_CreateTime ];

/// NC_UpdateUser_Dr
Property NCUpdateUserDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = NC_UpdateUser_Dr ];

/// NC_UpdateDate
Property NCUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = NC_UpdateDate ];

/// NC_UpdateTime
Property NCUpdateTime As %Library.Time [ SqlColumnNumber = 17, SqlFieldName = NC_UpdateTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCNurCare(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="NC_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="NC_Assess">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="NC_AssessReason">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="NC_CreateCtcp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="NC_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="NC_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="NC_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="NC_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="NC_NurDiag_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="NC_Priority">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="NC_Specialty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="NC_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="NC_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="NC_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="NC_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="NC_UpdateUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Global>^DHCNurCare</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>NC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{NC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^DHCNurCare</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>NC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{NC_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{NC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSttDate">
<Global>^DHCNurCare</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>NC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SttDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{NC_StartDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{NC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCNurCareS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
