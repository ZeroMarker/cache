/// Rostering(2131)
Class User.NRRostering Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = NR_Rostering, StorageStrategy = SQLStorage ]
{

/// Des Ref CTLOC
Property NRCTLOCDR As CTLoc [ SqlColumnNumber = 2, SqlFieldName = NR_CTLOC_DR ];

/// Date
Property NRDate As %Date [ SqlColumnNumber = 4, SqlFieldName = NR_Date ];

/// Req NS
Property NRReqNS As %Float [ SqlColumnNumber = 6, SqlFieldName = NR_ReqNS ];

/// ReqPAS
Property NRReqPAS As %Float [ SqlColumnNumber = 8, SqlFieldName = NR_ReqPAS ];

/// Required Technician
Property NRReqTech As %Float [ SqlColumnNumber = 9, SqlFieldName = NR_ReqTech ];

/// RosNS
Property NRRosNS As %Float [ SqlColumnNumber = 5, SqlFieldName = NR_RosNS ];

/// Ros PAS
Property NRRosPAS As %Float [ SqlColumnNumber = 7, SqlFieldName = NR_RosPAS ];

/// Rostered Technician
Property NRRosTech As %Float [ SqlColumnNumber = 10, SqlFieldName = NR_RosTech ];

/// Des Ref Shift
Property NRShiftDR As CTWorkShif [ SqlColumnNumber = 3, SqlFieldName = NR_Shift_DR ];

Parameter EXTENTSIZE = 23;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.NRRostering).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.NRRostering","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.NRRostering).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.NRRostering","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.NRRostering).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.NRRostering","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.NRRostering).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.NRRostering","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.NRRostering).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.NRRostering","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>23</ExtentSize>
<Property name="NRCTLOCDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="NRDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="NRReqNS">
<Selectivity>1</Selectivity>
</Property>
<Property name="NRReqPAS">
<Selectivity>1</Selectivity>
</Property>
<Property name="NRReqTech">
<Selectivity>1</Selectivity>
</Property>
<Property name="NRRosNS">
<Selectivity>1</Selectivity>
</Property>
<Property name="NRRosPAS">
<Selectivity>1</Selectivity>
</Property>
<Property name="NRRosTech">
<Selectivity>1</Selectivity>
</Property>
<Property name="NRShiftDR">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^NURSE1("NR",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="NR_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="NR_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="NR_ReqNS">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="NR_ReqPAS">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="NR_ReqTech">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="NR_RosNS">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="NR_RosPAS">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="NR_RosTech">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="NR_Shift_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^NURSE1</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>NR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"NR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{NR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^NURSE1</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>NR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"NR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{NR_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{NR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^NURSE1</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>NR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"NR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{NR_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{NR_Date}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{NR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>NR_RowId</SqlRowIdName>
<StreamLocation>^User.NRRosteringS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
