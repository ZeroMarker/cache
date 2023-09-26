/// ARC SurchCode InsSubType(1307)
Class User.ARCSurchInsSubType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_SurchInsSubType, StorageStrategy = SQLStorage ]
{

/// Des Ref to CTLOC
Property INSCTLOCDR As CTLoc [ SqlColumnNumber = 8, SqlFieldName = INS_CTLOC_DR ];

/// Childsub
Property INSChildsub As %Float [ InitialExpression = {$i(^ARC("SURC",$p(%d(0),$c(1)),"INS",0))}, SqlColumnNumber = 2, SqlFieldName = INS_Childsub ];

/// Date From
Property INSDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = INS_DateFrom ];

/// Date To
Property INSDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = INS_DateTo ];

/// Fixed Amt
Property INSFixedAmt As %Float [ SqlColumnNumber = 6, SqlFieldName = INS_FixedAmt ];

/// Des Ref InsSub
Property INSInsSubDR As ARCAuxilInsurType [ SqlColumnNumber = 9, SqlFieldName = INS_InsSub_DR ];

/// Description
Property INSName As %String(COLLATION = "Exact", MAXLEN = 78, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = INS_Name ];

/// ARC_SurchargeCode Parent Reference
Relationship INSParRef As ARCSurchargeCode [ Cardinality = parent, Inverse = ChildARCSurchInsSubType, Required, SqlFieldName = INS_ParRef ];

/// % Charge
Property INSPerc As %Float [ SqlColumnNumber = 5, SqlFieldName = INS_Perc ];

/// Visit Type
Property INSVisitType As %String(DISPLAYLIST = ",Normal,First Visit,Second and Other", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",N,F,S") [ SqlColumnNumber = 7, SqlFieldName = INS_VisitType ];

Index RowIDBasedIDKeyIndex On INSChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCSurchInsSubType).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCSurchInsSubType","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCSurchInsSubType).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCSurchInsSubType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCSurchInsSubType).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCSurchInsSubType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCSurchInsSubType).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCSurchInsSubType","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCSurchInsSubType).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCSurchInsSubType","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="INS_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INS_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INS_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INS_FixedAmt">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INS_InsSub_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INS_Name">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INS_Perc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INS_VisitType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_SurchargeCode.SURC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>INS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SURC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_SurchargeCode.SURC_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"INS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexVisTypeInsDate">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_SurchargeCode.SURC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L9}</Expression>
<Field>INS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SURC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_SurchargeCode.SURC_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"INS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"VisTypeInsDate"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INS_VisitType}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{INS_InsSub_DR}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{INS_DateFrom}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{INS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INS_RowId</SqlRowIdName>
<StreamLocation>^User.ARCSurchInsSubTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
