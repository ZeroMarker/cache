/// IN Issue/Transfer Item  (INITI,373)
Class User.INIsTrfItm Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = IN_IsTrfItm, StorageStrategy = SQLStorage ]
{

/// Acknowledge Quantity
Property INITIAckQty As %Float(MAXVAL = 999999999, MINVAL = 0) [ SqlColumnNumber = 9, SqlFieldName = INITI_AckQty ];

/// Des Ref to UOM
Property INITICTUOMDR As CTUOM [ Required, SqlColumnNumber = 11, SqlComputeCode = { i {INITI_INCLB_DR}="" s {INITI_CTUOM_DR}="" q
 s {INITI_CTUOM_DR}=$$CO11^at373({INITI_INCLB_DR})
}, SqlComputed, SqlComputeOnChange = INITIINCLBDR, SqlFieldName = INITI_CTUOM_DR ];

/// INITI ChildSub (NewKey)
Property INITIChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^INIT($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"ITI",0))}, SqlColumnNumber = 4, SqlFieldName = INITI_ChildSub ];

/// Date Acknowledge
Property INITIDateAcknow As %Date [ SqlColumnNumber = 16, SqlFieldName = INITI_DateAcknow ];

/// Des Ref to INCLB
Property INITIINCLBDR As INCItmLcBt [ Required, SqlColumnNumber = 5, SqlFieldName = INITI_INCLB_DR ];

/// INIT Par Ref
Relationship INITIINITParRef As INIsTrf [ Cardinality = parent, Inverse = ChildINIsTrfItm, Required, SqlFieldName = INITI_INIT_ParRef ];

/// Des Ref to INRQI
Property INITIINRQIDR As INReqItm [ InitialExpression = {$g(INRQIrow)}, SqlColumnNumber = 3, SqlFieldName = INITI_INRQI_DR ];

/// Transfer/Issue Quantity
Property INITIQty As %Float(MAXVAL = 999999999999, MINVAL = 0) [ Required, SqlColumnNumber = 2, SqlFieldName = INITI_Qty ];

/// Scan Flag
Property INITIScanFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = INITI_ScanFlag ];

/// Time Acknowledge
Property INITITimeAcknow As %Time [ SqlColumnNumber = 17, SqlFieldName = INITI_TimeAcknow ];

/// Des Ref to CTLOC
Property INITIToLocDR As CTLoc [ SqlColumnNumber = 7, SqlFieldName = INITI_ToLoc_DR ];

/// Transfer Type
Property INITIType As %String(DISPLAYLIST = ",Issue,Transfer", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",I,T") [ Required, SqlColumnNumber = 13, SqlFieldName = INITI_Type ];

/// Transfer/Issue Unit Cost
Property INITIUCost As %Float(MAXVAL = 999999999999, MINVAL = -9999999999) [ SqlColumnNumber = 6, SqlFieldName = INITI_UCost ];

/// Des REf UserAck_DR
Property INITIUserAckDR As SSUser [ SqlColumnNumber = 15, SqlFieldName = INITI_UserAck_DR ];

Index RowIDBasedIDKeyIndex On INITIChildSub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 3;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.INIsTrfItm).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INIsTrfItm","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.INIsTrfItm).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INIsTrfItm","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.INIsTrfItm).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INIsTrfItm","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.INIsTrfItm).getOld(%d(1))
 d VALDEL^at373
 d ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INIsTrfItm","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d VALINS^at373
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.INIsTrfItm).getOld(%d(1))
 d VALUPD^at373
 d ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INIsTrfItm","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>3</ExtentSize>
<Property name="INITIAckQty">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="INITICTUOMDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INITIChildSub">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="INITIDateAcknow">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INITIINCLBDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INITIINITParRef">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="INITIINRQIDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INITIQty">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="INITIScanFlag">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INITITimeAcknow">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INITIToLocDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INITIType">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="INITIUCost">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="INITIUserAckDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<SQLMap name="DataMasterINITI">
<Data name="INITI_AckQty">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INITI_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INITI_DateAcknow">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INITI_INCLB_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INITI_INRQI_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INITI_Qty">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INITI_ScanFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INITI_TimeAcknow">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INITI_ToLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INITI_Type">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INITI_UCost">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INITI_UserAck_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^INIT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IN_IsTrf.INIT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>INITI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{IN_IsTrf.INIT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ITI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INITI_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOutsItem">
<Condition>{INITI_Qty}-{INITI_AckQty}</Condition>
<Global>^INIT</Global>
<PopulationPct>50</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IN_IsTrf.INIT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INITI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OutsINCI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>+{INITI_INCLB_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IN_IsTrf.INIT_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INITI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INITI_RowId</SqlRowIdName>
<StreamLocation>^User.INIsTrfItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
