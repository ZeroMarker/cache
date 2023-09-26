/// DHC_NurCarePlanDetail
Class User.DHCNurCarePlanDetail Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = NCPI_RowId, SqlTableName = DHC_NurCarePlanDetail, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On NCPIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_NurCarePlan Parent Reference
Relationship NCPIParref As User.DHCNurCarePlan [ Cardinality = parent, Inverse = ChildDHCNurCarePlanDetail, Required, SqlFieldName = NCPI_Parref ];

/// NCPI_ChildSub
Property NCPIChildSub As %Library.Float [ InitialExpression = {$i(^DHCNurCare(+%d(0),"P",$p($p(%d(0),$c(1)),"||",2),"D",0))}, Required, SqlColumnNumber = 2, SqlFieldName = NCPI_ChildSub ];

/// NCPI_Status
Property NCPIStatus As %Library.String(DISPLAYLIST = ",Active,Cancel,Finish", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",A,C,F") [ SqlColumnNumber = 3, SqlFieldName = NCPI_Status ];

/// NCPI_Priority
Property NCPIPriority As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = NCPI_Priority ];

/// NCPI_StartDate
Property NCPIStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = NCPI_StartDate ];

/// NCPI_StartTime
Property NCPIStartTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = NCPI_StartTime ];

/// NCPI_EndDate
Property NCPIEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = NCPI_EndDate ];

/// NCPI_EndTime
Property NCPIEndTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = NCPI_EndTime ];

/// NCPI_ViewCat_Dr
Property NCPIViewCatDr As User.DHCANCViewCat [ SqlColumnNumber = 9, SqlFieldName = NCPI_ViewCat_Dr ];

/// NCPI_CommOrd_Dr
Property NCPICommOrdDr As User.DHCANCCommonOrd [ SqlColumnNumber = 10, SqlFieldName = NCPI_CommOrd_Dr ];

/// NCPI_SeqNo
Property NCPISeqNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = NCPI_SeqNo ];

/// NCPI_Note
Property NCPINote As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = NCPI_Note ];

/// NCPI_UpdateUser_Dr
Property NCPIUpdateUserDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = NCPI_UpdateUser_Dr ];

/// NCPI_UpdateDate
Property NCPIUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = NCPI_UpdateDate ];

/// NCPI_UpdateTime
Property NCPIUpdateTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = NCPI_UpdateTime ];

/// NCPI_OtherDescription
Property NCPIOtherDescription As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = NCPI_OtherDescription ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="NCPI_CommOrd_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="NCPI_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="NCPI_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="NCPI_Note">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="NCPI_OtherDescription">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="NCPI_Priority">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="NCPI_SeqNo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="NCPI_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="NCPI_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="NCPI_Status">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="NCPI_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="NCPI_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="NCPI_UpdateUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="NCPI_ViewCat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCNurCare</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_NurCare.NC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_NurCarePlan.NCP_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>NCPI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_NurCare.NC_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"P"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_NurCarePlan.NCP_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"D"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{NCPI_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCNurCare</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_NurCare.NC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHC_NurCarePlan.NCP_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>NCPI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PIStat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{NCPI_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_NurCare.NC_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_NurCarePlan.NCP_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{NCPI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCNurCarePlanDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
