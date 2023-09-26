/// Unavailable(2211)
Class User.PAAdmUnavailable Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_AdmUnavailable, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On UNAVChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_Adm Parent Reference
Relationship UNAVParRef As PAAdm [ Cardinality = parent, Inverse = ChildPAAdmUnavailable, Required, SqlFieldName = UNAV_ParRef ];

/// Childsub
Property UNAVChildsub As %Float [ InitialExpression = {$i(^PAADM($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"UNAV",0))}, SqlColumnNumber = 2, SqlFieldName = UNAV_Childsub ];

/// Date From
Property UNAVDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = UNAV_DateFrom ];

/// DateTo
Property UNAVDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = UNAV_DateTo ];

/// Des Ref Reason
Property UNAVReasonDR As PACWLReasonNotAvail [ SqlColumnNumber = 5, SqlFieldName = UNAV_Reason_DR ];

/// ReasonText
Property UNAVReasonText As %String(COLLATION = "Exact", MAXLEN = 250, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = UNAV_ReasonText ];

/// UpdateDate
Property UNAVUpdateDate As %Date [ SqlColumnNumber = 7, SqlFieldName = UNAV_UpdateDate ];

/// UpdateTime
Property UNAVUpdateTime As %Time [ SqlColumnNumber = 8, SqlFieldName = UNAV_UpdateTime ];

/// Des Ref UpdateUserHospital
Property UNAVUpdateUserHospitalDR As CTHospital [ SqlColumnNumber = 9, SqlFieldName = UNAV_UpdateUserHospital_DR ];

/// Des Ref UpdateUser
Property UNAVUpdateUserDR As SSUser [ SqlColumnNumber = 10, SqlFieldName = UNAV_UpdateUser_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAAdmUnavailable).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmUnavailable","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAAdmUnavailable).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmUnavailable","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAAdmUnavailable).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmUnavailable","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAAdmUnavailable).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmUnavailable","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAAdmUnavailable).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmUnavailable","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="UNAV_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="UNAV_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="UNAV_ReasonText">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="UNAV_Reason_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="UNAV_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="UNAV_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="UNAV_UpdateUserHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="UNAV_UpdateUser_DR">
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
<Field>UNAV_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UNAV"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UNAV_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>UNAV_RowId</SqlRowIdName>
<StreamLocation>^User.PAAdmUnavailableS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
