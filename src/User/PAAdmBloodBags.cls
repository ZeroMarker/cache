/// Admission Blood Bags     (BLD,1046)
Class User.PAAdmBloodBags Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_AdmBloodBags, StorageStrategy = SQLStorage ]
{

/// Childsub
Property BLDChildsub As %Float [ InitialExpression = {$i(^PAADM($p(%d(0),$c(1)),"BLD",0))}, Required, SqlColumnNumber = 2, SqlFieldName = BLD_Childsub ];

/// Date bag was given
Property BLDDate As %Date [ SqlColumnNumber = 4, SqlFieldName = BLD_Date ];

/// des ref to doctor
Property BLDDoctorDR As CTCareProv [ SqlColumnNumber = 6, SqlFieldName = BLD_Doctor_DR ];

/// Blood Bag Number
Property BLDNumber As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = BLD_Number ];

/// des ref to nurse
Property BLDNurseDR As CTCareProv [ SqlColumnNumber = 7, SqlFieldName = BLD_Nurse_DR ];

/// PA_Adm Parent Reference
Relationship BLDParRef As PAAdm [ Cardinality = parent, Inverse = ChildPAAdmBloodBags, Required, SqlFieldName = BLD_ParRef ];

/// Time bag was given
Property BLDTime As %Time [ SqlColumnNumber = 5, SqlFieldName = BLD_Time ];

Index RowIDBasedIDKeyIndex On BLDChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAAdmBloodBags).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmBloodBags","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAAdmBloodBags).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmBloodBags","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAAdmBloodBags).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmBloodBags","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAAdmBloodBags).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmBloodBags","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAAdmBloodBags).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmBloodBags","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="BLD_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BLD_Doctor_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BLD_Number">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BLD_Nurse_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BLD_Time">
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
<Field>BLD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BLD"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BLD_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>BLD_RowId</SqlRowIdName>
<StreamLocation>^User.PAAdmBloodBagsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
