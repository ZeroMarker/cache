/// PA AdmRferralLocation(1934)
Class User.PAAdmReferralLocation Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_AdmReferralLocation, StorageStrategy = SQLStorage ]
{

/// Des Ref CTLOC
Property REFLOCCTLOCDR As CTLoc [ SqlColumnNumber = 5, SqlFieldName = REFLOC_CTLOC_DR ];

/// Childsub
Property REFLOCChildsub As %Float [ InitialExpression = {$i(^PAADM($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"REFLOC",0))}, SqlColumnNumber = 2, SqlFieldName = REFLOC_Childsub ];

/// Date
Property REFLOCDate As %Date [ SqlColumnNumber = 3, SqlFieldName = REFLOC_Date ];

/// Location
Property REFLOCLocation As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = REFLOC_Location ];

/// PA_Adm Parent Reference
Relationship REFLOCParRef As PAAdm [ Cardinality = parent, Inverse = ChildPAAdmReferralLocation, Required, SqlFieldName = REFLOC_ParRef ];

/// Time
Property REFLOCTime As %Time [ SqlColumnNumber = 4, SqlFieldName = REFLOC_Time ];

/// UpdateDate
Property REFLOCUpdateDate As %Date [ SqlColumnNumber = 7, SqlFieldName = REFLOC_UpdateDate ];

/// UpdateTime
Property REFLOCUpdateTime As %Time [ SqlColumnNumber = 8, SqlFieldName = REFLOC_UpdateTime ];

/// Des Ref UpdateUser
Property REFLOCUpdateUserDR As SSUser [ SqlColumnNumber = 9, SqlFieldName = REFLOC_UpdateUser_DR ];

/// Des Ref UpdateUserHospital
Property REFLOCUpdateUserHospitalDR As CTHospital [ SqlColumnNumber = 10, SqlFieldName = REFLOC_UpdateUserHospital_DR ];

Index RowIDBasedIDKeyIndex On REFLOCChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 137;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAAdmReferralLocation).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmReferralLocation","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAAdmReferralLocation).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmReferralLocation","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAAdmReferralLocation).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmReferralLocation","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAAdmReferralLocation).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmReferralLocation","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAAdmReferralLocation).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmReferralLocation","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>137</ExtentSize>
<Property name="REFLOCCTLOCDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="REFLOCChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="REFLOCDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="REFLOCLocation">
<Selectivity>1</Selectivity>
</Property>
<Property name="REFLOCParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="REFLOCTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="REFLOCUpdateDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="REFLOCUpdateTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="REFLOCUpdateUserDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="REFLOCUpdateUserHospitalDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="REFLOC_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="REFLOC_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="REFLOC_Location">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="REFLOC_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="REFLOC_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="REFLOC_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="REFLOC_UpdateUserHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="REFLOC_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>REFLOC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"REFLOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{REFLOC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>REFLOC_RowId</SqlRowIdName>
<StreamLocation>^User.PAAdmReferralLocationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
