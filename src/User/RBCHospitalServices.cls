/// RBC Hospital Services(1642)
Class User.RBCHospitalServices Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RBC_HospitalServices, StorageStrategy = SQLStorage ]
{

Relationship ChildRBCHospitalServicesPrice As RBCHospitalServicesPrice [ Cardinality = children, Inverse = PRICEParRef ];

/// Des Ref ARCIM
Property HSERARCIMDR As ARCItmMast [ SqlColumnNumber = 2, SqlFieldName = HSER_ARCIM_DR ];

/// Des Ref ARCOS
Property HSERARCOSDR As ARCOrdSets [ SqlColumnNumber = 3, SqlFieldName = HSER_ARCOS_DR ];

/// Active
Property HSERActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = HSER_Active ];

/// Des Ref CTCP
Property HSERCTCPDR As CTCareProv [ SqlColumnNumber = 5, SqlFieldName = HSER_CTCP_DR ];

/// Des Ref CTLOC
Property HSERCTLOCDR As CTLoc [ SqlColumnNumber = 8, SqlFieldName = HSER_CTLOC_DR ];

/// Description
Property HSERDesc As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = HSER_Desc ];

/// Des Ref Equip
Property HSEREquipDR As RBCEquipment [ SqlColumnNumber = 6, SqlFieldName = HSER_Equip_DR ];

/// Minutes
Property HSERMinutes As %Float [ SqlColumnNumber = 9, SqlFieldName = HSER_Minutes ];

/// No Of Slots
Property HSERNoOfSlots As %Float [ SqlColumnNumber = 4, SqlFieldName = HSER_NoOfSlots ];

/// Des Ref ServGroup
Property HSERServGroupDR As RBCServiceGroup [ SqlColumnNumber = 10, SqlFieldName = HSER_ServGroup_DR ];

/// Des Ref RBC Services
Property HSERServicesDR As RBCServices [ SqlColumnNumber = 12, SqlFieldName = HSER_Services_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBCHospitalServices).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBCHospitalServices","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBCHospitalServices).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBCHospitalServices","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBCHospitalServices).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBCHospitalServices","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBCHospitalServices).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBCHospitalServices","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBCHospitalServices).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBCHospitalServices","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^RBC("HSER",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="HSER_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="HSER_ARCOS_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="HSER_Active">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="HSER_CTCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="HSER_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="HSER_Desc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="HSER_Equip_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="HSER_Minutes">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="HSER_NoOfSlots">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="HSER_ServGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="HSER_Services_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^RBC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>HSER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HSER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{HSER_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARCIM">
<Global>^RBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>HSER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HSER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ARCIM"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{HSER_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{HSER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexARCOS">
<Global>^RBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>HSER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HSER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ARCOS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{HSER_ARCOS_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{HSER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCTCP">
<Global>^RBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>HSER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HSER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CTCP"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{HSER_CTCP_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{HSER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCTLOC">
<Global>^RBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>HSER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HSER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CTLOC"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{HSER_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{HSER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^RBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>HSER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HSER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({HSER_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{HSER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^RBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>HSER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HSER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"EQ"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{HSER_Equip_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{HSER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGroup">
<Global>^RBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>HSER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HSER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"GRP"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{HSER_ServGroup_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{HSER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>HSER_RowId</SqlRowIdName>
<StreamLocation>^User.RBCHospitalServicesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
