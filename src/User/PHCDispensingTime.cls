/// PHC Dispensing Time     (PHCDT,670)
Class User.PHCDispensingTime Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = PHC_DispensingTime, StorageStrategy = SQLStorage ]
{

/// ChildSub (New Key)
Property PHCDTChildSub As %Float [ InitialExpression = {$i(^PHCFR($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"DT",0))}, Required, SqlColumnNumber = 2, SqlFieldName = PHCDT_ChildSub ];

/// PHCF Parent Reference
Relationship PHCDTPHCFRParRef As PHCFreq [ Cardinality = parent, Inverse = ChildPHCDispensingTime, Required, SqlFieldName = PHCDT_PHCFR_ParRef ];

/// 分发时间
Property PHCDTTime As %Time [ SqlColumnNumber = 3, SqlFieldName = PHCDT_Time ];

/// 分发时间描述 add 2020-11-04
Property PHCDTTimeDesc As %String(MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = PHCDT_TimeDesc ];

Index RowIDBasedIDKeyIndex On PHCDTChildSub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 78;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PHCDispensingTime).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCDispensingTime","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PHCDispensingTime).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCDispensingTime","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PHCDispensingTime).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCDispensingTime","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PHCDispensingTime).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCDispensingTime","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PHCDispensingTime).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCDispensingTime","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>78</ExtentSize>
<Property name="PHCDTChildSub">
<Selectivity>1</Selectivity>
</Property>
<Property name="PHCDTPHCFRParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="PHCDTTime">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMasterPHCDT">
<Data name="PHCDT_Time">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHCDT_TimeDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PHCFR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHC_Freq.PHCFR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHCDT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHC_Freq.PHCFR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DT"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHCDT_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHCDT_RowId</SqlRowIdName>
<StreamLocation>^User.PHCDispensingTimeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
