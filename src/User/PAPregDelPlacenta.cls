/// PregDelPlacenta(2233)
Class User.PAPregDelPlacenta Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_PregDelPlacenta, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PLACChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildPAPrDelPlacAnomalies As PAPrDelPlacAnomalies [ Cardinality = children, Inverse = PDPAParRef ];

/// PA_PregDelivery Parent Reference
Relationship PLACParRef As PAPregDelivery [ Cardinality = parent, Inverse = ChildPAPregDelPlacenta, Required, SqlFieldName = PLAC_ParRef ];

/// Childsub
Property PLACChildsub As %Float [ InitialExpression = {$i(^PAPRG($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"DEL",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"PLAC",0))}, SqlColumnNumber = 2, SqlFieldName = PLAC_Childsub ];

/// Placenta number
Property PLACPlacentaNo As %Float [ SqlColumnNumber = 3, SqlFieldName = PLAC_PlacentaNo ];

/// Des Ref Placenta Condition
Property PLACPlacentaCondDR As PACPlacentaCondtion [ SqlColumnNumber = 4, SqlFieldName = PLAC_PlacentaCond_DR ];

/// Membranes condition Des Ref PAC_MembCond
Property PLACMembraneCondDR As PACMembCond [ SqlColumnNumber = 5, SqlFieldName = PLAC_MembraneCond_DR ];

/// Placenta weight
Property PLACPlacentaWeight As %Float [ SqlColumnNumber = 6, SqlFieldName = PLAC_PlacentaWeight ];

/// Length of cord
Property PLACCordLength As %Float [ SqlColumnNumber = 7, SqlFieldName = PLAC_CordLength ];

/// Des ref PAC_CordInsertion
Property PLACCordInsertionDR As PACCordInsertion [ SqlColumnNumber = 8, SqlFieldName = PLAC_CordInsertion_DR ];

/// Des ref PAC_CordVessels
Property PLACCordVesselsDR As PACCordVessels [ SqlColumnNumber = 9, SqlFieldName = PLAC_CordVessels_DR ];

/// True knot
Property PLACCordTrueKnot As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = PLAC_CordTrueKnot ];

/// Calification
Property PLACCalcification As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = PLAC_Calcification ];

/// Infracts
Property PLACInfracts As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = PLAC_Infracts ];

/// Other Placenta Anomalies
Property PLACOthPlacAnom As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = PLAC_OthPlacAnom, SqlListType = SUBNODE ];

/// Delivery Date
Property PLACDelDate As %Date [ SqlColumnNumber = 20, SqlFieldName = PLAC_DelDate ];

/// Delivery Time
Property PLACDelTime As %Time [ SqlColumnNumber = 21, SqlFieldName = PLAC_DelTime ];

/// Delivery Type DR
Property PLACDelTypeDR As PACPlacDelivType [ SqlColumnNumber = 22, SqlFieldName = PLAC_DelType_DR ];

/// Last Update Date
Property PLACUpdateDate As %Date [ SqlColumnNumber = 23, SqlFieldName = PLAC_UpdateDate ];

/// Last Update Time
Property PLACUpdateTime As %Time [ SqlColumnNumber = 24, SqlFieldName = PLAC_UpdateTime ];

/// Last Update User
Property PLACUpdateUserDR As SSUser [ SqlColumnNumber = 25, SqlFieldName = PLAC_UpdateUser_DR ];

/// Last Update Hospital
Property PLACUpdateHospitalDR As CTHospital [ SqlColumnNumber = 26, SqlFieldName = PLAC_UpdateHospital_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAPregDelPlacenta).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPregDelPlacenta","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAPregDelPlacenta).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPregDelPlacenta","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAPregDelPlacenta).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPregDelPlacenta","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAPregDelPlacenta).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPregDelPlacenta","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAPregDelPlacenta).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPregDelPlacenta","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="PLAC_Calcification">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PLAC_CordInsertion_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PLAC_CordLength">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PLAC_CordTrueKnot">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PLAC_CordVessels_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PLAC_DelDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PLAC_DelTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PLAC_DelType_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PLAC_Infracts">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PLAC_MembraneCond_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PLAC_OthPlacAnom">
<Node>"OPA"</Node>
</Data>
<Data name="PLAC_PlacentaCond_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PLAC_PlacentaNo">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PLAC_PlacentaWeight">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PLAC_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PLAC_UpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PLAC_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PLAC_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Global>^PAPRG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>PLAC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PA_PregDelivery.DEL_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"PLAC"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PLAC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexMembranecondition">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>PLAC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PLAC_MembraneCond_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PLAC_MembraneCond_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_PregDelivery.DEL_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"PLAC"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PLAC_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPlacentaCondition">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>PLAC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PLAC_PlacentaCond_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PLAC_PlacentaCond_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_PregDelivery.DEL_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"PLAC"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PLAC_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPlacentano">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>PLAC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PLAC_PlacentaNo"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PLAC_PlacentaNo}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_PregDelivery.DEL_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"PLAC"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PLAC_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PLAC_RowId</SqlRowIdName>
<StreamLocation>^User.PAPregDelPlacentaS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
