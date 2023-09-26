/// PA Adm Diet Details          (1364)
Class User.PAAdmDietDetails Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_AdmDietDetails, StorageStrategy = SQLStorage ]
{

/// Childsub
Property DIETChildsub As %Float [ InitialExpression = {$i(^PAADM($p(%d(0),$c(1)),"DIET",0))}, SqlColumnNumber = 2, SqlFieldName = DIET_Childsub ];

/// Low Cholesterol
Property DIETLowCholesterol As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = DIET_LowCholesterol ];

/// Low Potassium
Property DIETLowPotassium As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = DIET_LowPotassium ];

/// PA_Adm Parent Reference
Relationship DIETParRef As PAAdm [ Cardinality = parent, Inverse = ChildPAAdmDietDetails, Required, SqlFieldName = DIET_ParRef ];

/// Pasturize Food
Property DIETPasturizeFood As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = DIET_PasturizeFood ];

/// Des Ref Salt Content
Property DIETSaltContentDR As DTCSaltContent [ SqlColumnNumber = 7, SqlFieldName = DIET_SaltContent_DR ];

/// Sterilize Utensils
Property DIETSterilizeUtensils As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = DIET_SterilizeUtensils ];

Index RowIDBasedIDKeyIndex On DIETChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAAdmDietDetails).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmDietDetails","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAAdmDietDetails).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmDietDetails","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAAdmDietDetails).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmDietDetails","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAAdmDietDetails).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmDietDetails","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAAdmDietDetails).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmDietDetails","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DIET_LowCholesterol">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DIET_LowPotassium">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DIET_PasturizeFood">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DIET_SaltContent_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DIET_SterilizeUtensils">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DIET_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DIET"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DIET_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DIET_RowId</SqlRowIdName>
<StreamLocation>^User.PAAdmDietDetailsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
