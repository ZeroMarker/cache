/// PA Adm Augmented Care(1952)
Class User.PAAdmAugmentedCare Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_AdmAugmentedCare, StorageStrategy = SQLStorage ]
{

/// Des Ref ACPDisposal
Property AUGACPDisposalDR As PACACPDisposal [ SqlColumnNumber = 13, SqlFieldName = AUG_ACPDisposal_DR ];

/// ACPEndDate
Property AUGACPEndDate As %Date [ SqlColumnNumber = 9, SqlFieldName = AUG_ACPEndDate ];

/// Des Ref ACPSource
Property AUGACPSourceDR As PACACPSource [ SqlColumnNumber = 12, SqlFieldName = AUG_ACPSource_DR ];

/// Childsub
Property AUGChildsub As %Float [ InitialExpression = {$i(^PAADM($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"AUG",0))}, SqlColumnNumber = 2, SqlFieldName = AUG_Childsub ];

/// Date
Property AUGDate As %Date [ SqlColumnNumber = 3, SqlFieldName = AUG_Date ];

/// HDCDays
Property AUGHDCDays As %Float [ SqlColumnNumber = 10, SqlFieldName = AUG_HDCDays ];

/// ICL Days
Property AUGICLDays As %Float [ SqlColumnNumber = 11, SqlFieldName = AUG_ICLDays ];

/// Max Number Of Organs
Property AUGMaxNumberOfOrgans As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = AUG_MaxNumberOfOrgans ];

/// PA_Adm Parent Reference
Relationship AUGParRef As PAAdm [ Cardinality = parent, Inverse = ChildPAAdmAugmentedCare, Required, SqlFieldName = AUG_ParRef ];

/// Planned/Unplanned
Property AUGPlannedUnplanned As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = AUG_Planned_Unplanned ];

/// Respiratory Indicator
Property AUGRespiratoryIndicator As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = AUG_RespiratoryIndicator ];

/// Time From
Property AUGTimeFrom As %Time [ SqlColumnNumber = 4, SqlFieldName = AUG_TimeFrom ];

/// Time To
Property AUGTimeTo As %Time [ SqlColumnNumber = 5, SqlFieldName = AUG_TimeTo ];

/// UpdateDate
Property AUGUpdateDate As %Date [ SqlColumnNumber = 14, SqlFieldName = AUG_UpdateDate ];

/// Update Time
Property AUGUpdateTime As %Time [ SqlColumnNumber = 15, SqlFieldName = AUG_UpdateTime ];

/// Des Ref UpdateUser
Property AUGUpdateUserDR As SSUser [ SqlColumnNumber = 16, SqlFieldName = AUG_UpdateUser_DR ];

/// Des Ref UpdateUserHospital
Property AUGUpdateUserHospitalDR As CTHospital [ SqlColumnNumber = 17, SqlFieldName = AUG_UpdateUserHospital_DR ];

Index RowIDBasedIDKeyIndex On AUGChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 15;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAAdmAugmentedCare).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmAugmentedCare","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAAdmAugmentedCare).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmAugmentedCare","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAAdmAugmentedCare).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmAugmentedCare","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAAdmAugmentedCare).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmAugmentedCare","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAAdmAugmentedCare).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmAugmentedCare","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>15</ExtentSize>
<Property name="AUGACPDisposalDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="AUGACPEndDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="AUGACPSourceDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="AUGChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="AUGDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="AUGHDCDays">
<Selectivity>1</Selectivity>
</Property>
<Property name="AUGICLDays">
<Selectivity>1</Selectivity>
</Property>
<Property name="AUGMaxNumberOfOrgans">
<Selectivity>1</Selectivity>
</Property>
<Property name="AUGParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="AUGPlannedUnplanned">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="AUGRespiratoryIndicator">
<Selectivity>1</Selectivity>
</Property>
<Property name="AUGTimeFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="AUGTimeTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="AUGUpdateDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="AUGUpdateTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="AUGUpdateUserDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="AUGUpdateUserHospitalDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="AUG_ACPDisposal_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AUG_ACPEndDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AUG_ACPSource_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AUG_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AUG_HDCDays">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AUG_ICLDays">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AUG_MaxNumberOfOrgans">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AUG_Planned_Unplanned">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AUG_RespiratoryIndicator">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AUG_TimeFrom">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AUG_TimeTo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AUG_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AUG_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AUG_UpdateUserHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AUG_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>AUG_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AUG"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AUG_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>AUG_RowId</SqlRowIdName>
<StreamLocation>^User.PAAdmAugmentedCareS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
