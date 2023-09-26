/// MRC ClinicalPathways(1763)
Class User.MRCClinicalPathways Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MRC_ClinicalPathways, StorageStrategy = SQLStorage ]
{

Relationship ChildMRCClinPathwaysEpisodes As MRCClinPathwaysEpisodes [ Cardinality = children, Inverse = EPParRef ];

/// Code
Property CPWCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CPW_Code ];

/// Description
Property CPWDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CPW_Desc ];

/// Active
Property CPWActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = CPW_Active ];

/// Date From
Property CPWDateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = CPW_DateFrom ];

/// Date To
Property CPWDateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = CPW_DateTo ];

/// CPW Type DR
Property CPWCPWTypeDR As MRCClinPathType [ SqlColumnNumber = 7, SqlFieldName = CPW_CPWTypeDR ];

/// Des Ref CTLOC
Property CPWCTLOCDR As CTLoc [ SqlColumnNumber = 8, SqlFieldName = CPW_CTLOC_DR ];

/// Des Ref Hospital
Property CPWHospitalDR As CTHospital [ SqlColumnNumber = 9, SqlFieldName = CPW_Hospital_DR ];

/// StartDay
Property CPWStartDay As %Float [ SqlColumnNumber = 10, SqlFieldName = CPW_StartDay ];

/// NumberOfCycle
Property CPWNumberOfCycle As %Float [ SqlColumnNumber = 11, SqlFieldName = CPW_NumberOfCycle ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRCClinicalPathways).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCClinicalPathways","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRCClinicalPathways).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCClinicalPathways","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRCClinicalPathways).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCClinicalPathways","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRCClinicalPathways).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCClinicalPathways","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRCClinicalPathways).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCClinicalPathways","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCClinicalPathways","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>22</ExtentSize>
<Property name="CPWActive">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CPWCPWTypeDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="CPWCTLOCDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="CPWCode">
<Selectivity>5.2632%</Selectivity>
</Property>
<Property name="CPWDateFrom">
<Selectivity>11.1111%</Selectivity>
</Property>
<Property name="CPWDateTo">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="CPWDesc">
<Selectivity>5.2632%</Selectivity>
</Property>
<Property name="CPWHospitalDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="CPWNumberOfCycle">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CPWStartDay">
<Selectivity>100.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^MRC("CPW",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CPW_Active">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CPW_CPWTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CPW_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CPW_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CPW_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CPW_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CPW_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CPW_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CPW_NumberOfCycle">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CPW_StartDay">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^MRC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CPW_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CPW"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CPW_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CPW_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CPW"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CPW_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CPW_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CPW_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CPW"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CPW_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CPW_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CPW_RowId</SqlRowIdName>
<StreamLocation>^User.MRCClinicalPathwaysS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
