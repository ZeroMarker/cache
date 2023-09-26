/// PA Bed Occupancy(1748)
Class User.PABedOccupancy Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_BedOccupancy, StorageStrategy = SQLStorage ]
{

/// Des Ref BedType
Property BDBedTypeDR As PACBedType [ SqlColumnNumber = 5, SqlFieldName = BD_BedType_DR ];

/// Date
Property BDDate As %Date [ SqlColumnNumber = 2, SqlFieldName = BD_Date ];

/// Des Ref EpisSubType
Property BDEpisSubTypeDR As PACEpisodeSubType [ SqlColumnNumber = 4, SqlFieldName = BD_EpisSubType_DR ];

/// Number Of Beds
Property BDNumberOfBeds As %Float [ SqlColumnNumber = 6, SqlFieldName = BD_NumberOfBeds ];

/// Number Of Empty Beds
Property BDNumberOfEmptyBeds As %Float [ SqlColumnNumber = 7, SqlFieldName = BD_NumberOfEmptyBeds ];

/// Des Ref Ward
Property BDWardDR As PACWard [ SqlColumnNumber = 3, SqlFieldName = BD_Ward_DR ];

Parameter EXTENTSIZE = 51;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PABedOccupancy).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PABedOccupancy","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PABedOccupancy).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PABedOccupancy","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PABedOccupancy).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PABedOccupancy","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PABedOccupancy).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PABedOccupancy","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PABedOccupancy).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PABedOccupancy","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>51</ExtentSize>
<Property name="BDBedTypeDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="BDDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="BDEpisSubTypeDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="BDNumberOfBeds">
<Selectivity>1</Selectivity>
</Property>
<Property name="BDNumberOfEmptyBeds">
<Selectivity>1</Selectivity>
</Property>
<Property name="BDWardDR">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PABD(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BD_BedType_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BD_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BD_EpisSubType_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BD_NumberOfBeds">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BD_NumberOfEmptyBeds">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BD_Ward_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PABD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{BD_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^PABD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BD_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>BD_RowId</SqlRowIdName>
<StreamLocation>^User.PABedOccupancyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
