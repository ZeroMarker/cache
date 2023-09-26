/// RBC Services(1424)
Class User.RBCServices Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RBC_Services, StorageStrategy = SQLStorage ]
{

Relationship ChildRBCServicesPrice As RBCServicesPrice [ Cardinality = children, Inverse = PRICEParRef ];

Relationship ChildRBCServicesLeaflet As RBCServicesLeaflet [ Cardinality = children, Inverse = LFTParRef ];

/// Des Ref ARCIM
Property SERARCIMDR As ARCItmMast [ SqlColumnNumber = 2, SqlFieldName = SER_ARCIM_DR ];

/// Des Ref ARCOS
Property SERARCOSDR As ARCOrdSets [ SqlColumnNumber = 3, SqlFieldName = SER_ARCOS_DR ];

/// No Of Slots
Property SERNoOfSlots As %Float(MINVAL = 0) [ Required, SqlColumnNumber = 4, SqlFieldName = SER_NoOfSlots ];

/// Des Ref CTCP
Property SERCTCPDR As CTCareProv [ SqlColumnNumber = 5, SqlFieldName = SER_CTCP_DR ];

/// Des Ref Equip
Property SEREquipDR As RBCEquipment [ SqlColumnNumber = 6, SqlFieldName = SER_Equip_DR ];

/// Description
Property SERDesc As %String(COLLATION = "AlphaUp", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = SER_Desc ];

/// Des Ref CTLOC
Property SERCTLOCDR As CTLoc [ SqlColumnNumber = 8, SqlFieldName = SER_CTLOC_DR ];

/// Minutes
Property SERMinutes As %Float [ SqlColumnNumber = 9, SqlFieldName = SER_Minutes ];

/// Des Ref ServGroup
Property SERServGroupDR As RBCServiceGroup [ SqlColumnNumber = 10, SqlFieldName = SER_ServGroup_DR ];

/// Active
Property SERActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = SER_Active ];

/// Sub Category Des ref
Property SERSubCategoryDR As ARCItemCat [ SqlColumnNumber = 12, SqlFieldName = SER_SubCategoryDR ];

/// Date From
Property SERDateFrom As %Date [ SqlColumnNumber = 13, SqlFieldName = SER_DateFrom ];

/// Date To
Property SERDateTo As %Date [ SqlColumnNumber = 14, SqlFieldName = SER_DateTo ];

/// 1st Appt
Property SER1stAppt As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = SER_1stAppt ];

/// ProjectedWeeksWait
Property SERProjectedWeeksWait As %Float [ SqlColumnNumber = 16, SqlFieldName = SER_ProjectedWeeksWait ];

/// AverageWeeksPYear
Property SERAverageWeeksPYear As %Float [ SqlColumnNumber = 17, SqlFieldName = SER_AverageWeeksPYear ];

/// FirstAvailable
Property SERFirstAvailable As %String(DISPLAYLIST = ",Empty session,Next available", MAXLEN = 14, TRUNCATE = 1, VALUELIST = ",ES,NA") [ SqlColumnNumber = 18, SqlFieldName = SER_FirstAvailable ];

/// ExtraContactPatientsPerc
Property SERExtraContactPatientsPerc As %Float [ SqlColumnNumber = 19, SqlFieldName = SER_ExtraContactPatientsPerc ];

/// PFB
Property SERPFB As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = SER_PFB ];

/// CalcProjectedWait
Property SERCalcProjectedWait As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 21, SqlFieldName = SER_CalcProjectedWait ];

/// NewWays
Property SERNewWays As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 22, SqlFieldName = SER_NewWays ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBCServices).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCServices","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBCServices).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCServices","OnAfterInsert")
 
 d POFILINS^at1424
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBCServices).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCServices","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBCServices).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCServices","OnBeforeDelete")
 
 &sql(DELETE FROM RBC_Services_Price WHERE PRICE_ParRef=:%d(1))
 &sql(DELETE FROM RBC_ServicesLeaflet WHERE LFT_ParRef=:%d(1))
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCServices","OnBeforeInsert")
 
 d VALINS^at1424
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBCServices).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCServices","OnBeforeUpdate")
 
 d VALUPD^at1424
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^RBC("SER",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SER_1stAppt">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SER_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SER_ARCOS_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SER_Active">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SER_AverageWeeksPYear">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="SER_CTCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SER_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SER_CalcProjectedWait">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="SER_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SER_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SER_Desc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SER_Equip_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SER_ExtraContactPatientsPerc">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="SER_FirstAvailable">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="SER_Minutes">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SER_NewWays">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="SER_NoOfSlots">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SER_PFB">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="SER_ProjectedWeeksWait">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="SER_ServGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SER_SubCategoryDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^RBC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SER_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARCIM">
<Global>^RBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ARCIM"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SER_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexARCOS">
<Global>^RBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ARCOS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SER_ARCOS_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAlias">
<Condition>1</Condition>
<ConditionFields>SER_Desc</ConditionFields>
<Global>^ARC</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>SER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SER"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SER_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({SER_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCTCP">
<Global>^RBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CTCP"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SER_CTCP_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCTLOC">
<Global>^RBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CTLOC"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SER_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^RBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SER_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^RBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"EQ"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SER_Equip_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGroup">
<Global>^RBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"GRP"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SER_ServGroup_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSubCat">
<Global>^RBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SubCat"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SER_SubCategoryDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SER_RowId</SqlRowIdName>
<StreamLocation>^User.RBCServicesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
