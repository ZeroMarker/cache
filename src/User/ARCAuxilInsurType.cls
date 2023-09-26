/// Auxil Insurance Type   (ARCAI,1164)
Class User.ARCAuxilInsurType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_AuxilInsurType, StorageStrategy = SQLStorage ]
{

Relationship ChildARCAuxilInsTypeContractDet As ARCAuxilInsTypeContractDetails [ Cardinality = children, Inverse = CONTRParRef ];

Relationship ChildARCAuxilInsTypeLinkPlan As ARCAuxilInsTypeLinkPlan [ Cardinality = children, Inverse = LINKParRef ];

/// Code
Property AUXITCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = AUXIT_Code ];

/// Description
Property AUXITDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = AUXIT_Desc ];

///  Des Ref to InsType
Property AUXITInsTypeDR As ARCInsuranceType [ Required, SqlColumnNumber = 4, SqlFieldName = AUXIT_InsType_DR ];

/// Date From
Property AUXITDateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = AUXIT_DateFrom ];

/// Date To
Property AUXITDateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = AUXIT_DateTo ];

/// Category
Property AUXITCategory As %String(MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",MedicAid,MediCare,Foreign,Auto,Labour") [ SqlColumnNumber = 7, SqlFieldName = AUXIT_Category ];

/// Code1
Property AUXITCode1 As %String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = AUXIT_Code1 ];

/// Code2
Property AUXITCode2 As %String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = AUXIT_Code2 ];

/// National Code
Property AUXITNationalCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = AUXIT_NationalCode ];

/// Plan Group 1
Property AUXITPlanGroup1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = AUXIT_PlanGroup1 ];

/// Plan Group 2
Property AUXITPlanGroup2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = AUXIT_PlanGroup2 ];

/// Plan Group 3
Property AUXITPlanGroup3 As %String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = AUXIT_PlanGroup3 ];

/// Plan Group 4
Property AUXITPlanGroup4 As %String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = AUXIT_PlanGroup4 ];

/// Plan Group 5
Property AUXITPlanGroup5 As %String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = AUXIT_PlanGroup5 ];

/// Plan Group 6
Property AUXITPlanGroup6 As %String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = AUXIT_PlanGroup6 ];

/// Qualification Status DR
Property AUXITQualificationStatusDR As PACQualificationStatus [ SqlColumnNumber = 17, SqlFieldName = AUXIT_QualificationStatusDR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCAuxilInsurType).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCAuxilInsurType","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCAuxilInsurType).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCAuxilInsurType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCAuxilInsurType).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCAuxilInsurType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCAuxilInsurType).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCAuxilInsurType","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCAuxilInsurType).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCAuxilInsurType","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^ARC("AUXIT",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AUXIT_Category">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AUXIT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AUXIT_Code1">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AUXIT_Code2">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AUXIT_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AUXIT_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AUXIT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AUXIT_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AUXIT_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AUXIT_PlanGroup1">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AUXIT_PlanGroup2">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AUXIT_PlanGroup3">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AUXIT_PlanGroup4">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AUXIT_PlanGroup5">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AUXIT_PlanGroup6">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AUXIT_QualificationStatusDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>AUXIT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"AUXIT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{AUXIT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAliasCode">
<Condition>1</Condition>
<ConditionFields>AUXIT_InsType_DR,AUXIT_Code,AUXIT_Desc</ConditionFields>
<Global>^ARC</Global>
<PopulationPct>50</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>AUXIT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"InsType"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AUXIT_InsType_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({AUXIT_Code})</Expression>
</Subscript>
<Subscript name="6">
<Expression>$$ALPHAUP({AUXIT_Desc})</Expression>
</Subscript>
<Subscript name="7">
<Expression>{AUXIT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAliasDesc">
<Condition>1</Condition>
<ConditionFields>AUXIT_InsType_DR,AUXIT_Desc</ConditionFields>
<Global>^ARC</Global>
<PopulationPct>50</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>AUXIT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"InsType"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AUXIT_InsType_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({AUXIT_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>$$ALPHAUP({AUXIT_Desc})</Expression>
</Subscript>
<Subscript name="7">
<Expression>{AUXIT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AUXIT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"AUXIT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({AUXIT_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AUXIT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AUXIT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"AUXIT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({AUXIT_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AUXIT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>AUXIT_RowId</SqlRowIdName>
<StreamLocation>^User.ARCAuxilInsurTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
