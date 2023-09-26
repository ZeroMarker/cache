/// PAAdmEstDischargeHistory(2047)
Class User.PAAdmEstDischargeHistory Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_AdmEstDischargeHistory, StorageStrategy = SQLStorage ]
{

/// Childsub
Property ESTDISChildsub As %Float [ InitialExpression = {$i(^PAADM($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"ESTDIS",0))}, SqlColumnNumber = 2, SqlFieldName = ESTDIS_Childsub ];

/// Date Updated
Property ESTDISDateUpdated As %Date [ SqlColumnNumber = 6, SqlFieldName = ESTDIS_DateUpdated ];

/// Est Date
Property ESTDISEstDate As %Date [ SqlColumnNumber = 3, SqlFieldName = ESTDIS_EstDate ];

/// EstTime
Property ESTDISEstTime As %Time [ SqlColumnNumber = 4, SqlFieldName = ESTDIS_EstTime ];

/// Des Ref HospitalUpdated
Property ESTDISHospitalUpdatedDR As CTHospital [ SqlColumnNumber = 8, SqlFieldName = ESTDIS_HospitalUpdated_DR ];

/// PA_Adm Parent Reference
Relationship ESTDISParRef As PAAdm [ Cardinality = parent, Inverse = ChildPAAdmEstDischargeHistory, Required, SqlFieldName = ESTDIS_ParRef ];

/// Time Updated
Property ESTDISTimeUpdated As %Time [ SqlColumnNumber = 7, SqlFieldName = ESTDIS_TimeUpdated ];

/// UserUpdated
Property ESTDISUserUpdatedDR As SSUser [ SqlColumnNumber = 5, SqlFieldName = ESTDIS_UserUpdated_DR ];

Index RowIDBasedIDKeyIndex On ESTDISChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 1190;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAAdmEstDischargeHistory).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmEstDischargeHistory","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAAdmEstDischargeHistory).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmEstDischargeHistory","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAAdmEstDischargeHistory).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmEstDischargeHistory","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAAdmEstDischargeHistory).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmEstDischargeHistory","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAAdmEstDischargeHistory).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmEstDischargeHistory","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1190</ExtentSize>
<Property name="ESTDISChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="ESTDISDateUpdated">
<Selectivity>1</Selectivity>
</Property>
<Property name="ESTDISEstDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="ESTDISEstTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="ESTDISHospitalUpdatedDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="ESTDISParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="ESTDISTimeUpdated">
<Selectivity>1</Selectivity>
</Property>
<Property name="ESTDISUserUpdatedDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="ESTDIS_DateUpdated">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ESTDIS_EstDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ESTDIS_EstTime">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ESTDIS_HospitalUpdated_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ESTDIS_TimeUpdated">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ESTDIS_UserUpdated_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ESTDIS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ESTDIS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ESTDIS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ESTDIS_RowId</SqlRowIdName>
<StreamLocation>^User.PAAdmEstDischargeHistoryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
