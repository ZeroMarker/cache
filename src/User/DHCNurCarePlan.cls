/// DHC_NurCarePlan
Class User.DHCNurCarePlan Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = NCP_RowId, SqlTableName = DHC_NurCarePlan, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On NCPChildSub [ IdKey, PrimaryKey, Unique ];

Relationship ChildDHCNurCarePlanDetail As User.DHCNurCarePlanDetail [ Cardinality = children, Inverse = NCPIParref ];

/// DHC_NurCare Parent Reference
Relationship NCPParref As User.DHCNurCare [ Cardinality = parent, Inverse = ChildDHCNurCarePlan, Required, SqlFieldName = NCP_Parref ];

/// NCP_ChildSub
Property NCPChildSub As %Library.Float [ InitialExpression = {$i(^DHCNurCare($p(%d(0),$c(1),1),"P",0))}, Required, SqlColumnNumber = 2, SqlFieldName = NCP_ChildSub ];

/// NCP_Status
Property NCPStatus As %Library.String(DISPLAYLIST = ",Active,Cancel,Finish", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",A,C,F") [ SqlColumnNumber = 3, SqlFieldName = NCP_Status ];

/// NCP_GoalType
Property NCPGoalType As %Library.String(DISPLAYLIST = ",Short,Long", MAXLEN = 5, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",S,L") [ SqlColumnNumber = 4, SqlFieldName = NCP_GoalType ];

/// NCP_StartDate
Property NCPStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = NCP_StartDate ];

/// NCP_StartTime
Property NCPStartTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = NCP_StartTime ];

/// NCP_EndDate
Property NCPEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = NCP_EndDate ];

/// NCP_EndTime
Property NCPEndTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = NCP_EndTime ];

/// NCP_GoalTemp_Dr
Property NCPGoalTempDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = NCP_GoalTemp_Dr ];

/// NCP_GoalSubject
Property NCPGoalSubject As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = NCP_GoalSubject ];

/// NCP_GoalAction
Property NCPGoalAction As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = NCP_GoalAction ];

/// NCP_GoalCriterion
Property NCPGoalCriterion As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = NCP_GoalCriterion ];

/// NCP_GoalDuration
Property NCPGoalDuration As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = NCP_GoalDuration ];

/// NCP_GoalMethod
Property NCPGoalMethod As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = NCP_GoalMethod ];

/// NCP_Note
Property NCPNote As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = NCP_Note ];

/// NCP_CreateCtcp_Dr
Property NCPCreateCtcpDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = NCP_CreateCtcp_Dr ];

/// NCP_CreateDate
Property NCPCreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = NCP_CreateDate ];

/// NCP_CreateTime
Property NCPCreateTime As %Library.Time [ SqlColumnNumber = 18, SqlFieldName = NCP_CreateTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="NCP_CreateCtcp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="NCP_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="NCP_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="NCP_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="NCP_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="NCP_GoalAction">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="NCP_GoalCriterion">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="NCP_GoalDuration">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="NCP_GoalMethod">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="NCP_GoalSubject">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="NCP_GoalTemp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="NCP_GoalType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="NCP_Note">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="NCP_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="NCP_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="NCP_Status">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCNurCare</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_NurCare.NC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>NCP_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_NurCare.NC_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"P"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{NCP_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCNurCarePlanS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
