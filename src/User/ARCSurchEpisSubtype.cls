/// ARC Surch Code Epis Subtype(1627)
Class User.ARCSurchEpisSubtype Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_SurchEpisSubtype, StorageStrategy = SQLStorage ]
{

/// Childsub
Property EPISChildsub As %Float [ InitialExpression = {$i(^ARC("SURC",$p(%d(0),$c(1)),"EPIS",0))}, SqlColumnNumber = 2, SqlFieldName = EPIS_Childsub ];

/// Date From
Property EPISDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = EPIS_DateFrom ];

/// Date To
Property EPISDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = EPIS_DateTo ];

/// Des Ref EpisSubtype
Property EPISEpisSubtypeDR As PACEpisodeSubType [ SqlColumnNumber = 5, SqlFieldName = EPIS_EpisSubtype_DR ];

/// Fixed Amount
Property EPISFixedAmt As %Float [ SqlColumnNumber = 6, SqlFieldName = EPIS_FixedAmt ];

/// ARC_SurchargeCode Parent Reference
Relationship EPISParRef As ARCSurchargeCode [ Cardinality = parent, Inverse = ChildARCSurchEpisSubtype, Required, SqlFieldName = EPIS_ParRef ];

/// % Charge
Property EPISPerc As %Float [ SqlColumnNumber = 7, SqlFieldName = EPIS_Perc ];

Index RowIDBasedIDKeyIndex On EPISChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCSurchEpisSubtype).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCSurchEpisSubtype","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCSurchEpisSubtype).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCSurchEpisSubtype","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCSurchEpisSubtype).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCSurchEpisSubtype","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCSurchEpisSubtype).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCSurchEpisSubtype","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCSurchEpisSubtype).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCSurchEpisSubtype","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="EPIS_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EPIS_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EPIS_EpisSubtype_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EPIS_FixedAmt">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EPIS_Perc">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_SurchargeCode.SURC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>EPIS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SURC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_SurchargeCode.SURC_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"EPIS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EPIS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEpisSubTypeDate">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_SurchargeCode.SURC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>EPIS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SURC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_SurchargeCode.SURC_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"EPIS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"EpisSubType"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{EPIS_EpisSubtype_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{EPIS_DateFrom}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{EPIS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>EPIS_RowId</SqlRowIdName>
<StreamLocation>^User.ARCSurchEpisSubtypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
