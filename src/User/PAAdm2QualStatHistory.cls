/// Adm2QualificationHist(2566)
Class User.PAAdm2QualStatHistory Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_Adm2QualStatHistory, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On QUALChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_Adm2 Parent Reference
Relationship QUALParRef As PAAdm2 [ Cardinality = parent, Inverse = ChildPAAdm2QualStatHistory, Required, SqlFieldName = QUAL_ParRef ];

/// Childsub
Property QUALChildsub As %Float [ InitialExpression = {$i(^PAADM($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"QUAL",0))}, SqlColumnNumber = 2, SqlFieldName = QUAL_Childsub ];

/// Date
Property QUALDate As %Date [ SqlColumnNumber = 3, SqlFieldName = QUAL_Date ];

/// Time
Property QUALTime As %Time [ SqlColumnNumber = 4, SqlFieldName = QUAL_Time ];

/// DateUpdated
Property QUALDateUpdated As %Date [ SqlColumnNumber = 5, SqlFieldName = QUAL_DateUpdated ];

/// TimeUpdated
Property QUALTimeUpdated As %Time [ SqlColumnNumber = 6, SqlFieldName = QUAL_TimeUpdated ];

/// Des Ref UserUpdated
Property QUALUserUpdatedDR As SSUser [ SqlColumnNumber = 7, SqlFieldName = QUAL_UserUpdated_DR ];

/// Des Ref HospitalUpdated
Property QUALHospitalUpdatedDR As CTHospital [ SqlColumnNumber = 8, SqlFieldName = QUAL_HospitalUpdated_DR ];

/// Des Ref QualifStatus
Property QUALQualifStatusDR As PACQualificationStatus [ SqlColumnNumber = 9, SqlFieldName = QUAL_QualifStatus_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAAdm2QualStatHistory).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdm2QualStatHistory","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAAdm2QualStatHistory).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdm2QualStatHistory","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAAdm2QualStatHistory).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdm2QualStatHistory","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAAdm2QualStatHistory).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdm2QualStatHistory","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAAdm2QualStatHistory).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdm2QualStatHistory","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="QUAL_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="QUAL_DateUpdated">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="QUAL_HospitalUpdated_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="QUAL_QualifStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="QUAL_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="QUAL_TimeUpdated">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="QUAL_UserUpdated_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm2.PAADM2_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>QUAL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm2.PAADM2_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"QUAL"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{QUAL_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>QUAL_RowId</SqlRowIdName>
<StreamLocation>^User.PAAdm2QualStatHistoryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
