/// RTC Med Record Volume(1451)
Class User.RTCMRecordTypeVolumes Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RTC_MRecordType_Volumes, StorageStrategy = SQLStorage ]
{

/// Des Ref CTLOC
Property VOLCTLOCDR As CTLoc [ SqlColumnNumber = 5, SqlFieldName = VOL_CTLOC_DR ];

/// Childsub
Property VOLChildsub As %Float [ InitialExpression = {$i(^RTC("TYPE",$p(%d(0),$c(1)),"VOL",0))}, SqlColumnNumber = 2, SqlFieldName = VOL_Childsub ];

/// Code
Property VOLCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = VOL_Code ];

/// Description
Property VOLDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = VOL_Desc ];

/// RTC_MRecordType Parent Reference
Relationship VOLParRef As RTCMRecordType [ Cardinality = parent, Inverse = ChildRTCMRecordTypeVolumes, Required, SqlFieldName = VOL_ParRef ];

Index RowIDBasedIDKeyIndex On VOLChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 4;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RTCMRecordTypeVolumes).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RTCMRecordTypeVolumes","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RTCMRecordTypeVolumes).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RTCMRecordTypeVolumes","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RTCMRecordTypeVolumes).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RTCMRecordTypeVolumes","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RTCMRecordTypeVolumes).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RTCMRecordTypeVolumes","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RTCMRecordTypeVolumes).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RTCMRecordTypeVolumes","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>4</ExtentSize>
<Property name="VOLCTLOCDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="VOLChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="VOLCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="VOLDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="VOLParRef">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="VOL_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="VOL_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="VOL_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^RTC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RTC_MRecordType.TYP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>VOL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TYPE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RTC_MRecordType.TYP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"VOL"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VOL_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>VOL_RowId</SqlRowIdName>
<StreamLocation>^User.RTCMRecordTypeVolumesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
