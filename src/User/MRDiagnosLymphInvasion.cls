/// DiagnosLymphInvasion(2645)
Class User.MRDiagnosLymphInvasion Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_DiagnosLymphInvasion, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DLIChildsub [ IdKey, PrimaryKey, Unique ];

/// MR_Diagnos Parent Reference
Relationship DLIParRef As MRDiagnos [ Cardinality = parent, Inverse = ChildMRDiagnosLymphInvasion, Required, SqlFieldName = DLI_ParRef ];

/// Childsub
Property DLIChildsub As %Float [ InitialExpression = {$i(^MR($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"DIA",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"DLI",0))}, SqlColumnNumber = 2, SqlFieldName = DLI_Childsub ];

/// Des Ref BodySite
Property DLIBodySiteDR As OECBodySite [ SqlColumnNumber = 3, SqlFieldName = DLI_BodySite_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRDiagnosLymphInvasion).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRDiagnosLymphInvasion","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRDiagnosLymphInvasion).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRDiagnosLymphInvasion","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRDiagnosLymphInvasion).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRDiagnosLymphInvasion","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRDiagnosLymphInvasion).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRDiagnosLymphInvasion","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRDiagnosLymphInvasion).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRDiagnosLymphInvasion","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="DLI_BodySite_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MR_Diagnos.MRDIA_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>DLI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DIA"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MR_Diagnos.MRDIA_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DLI"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DLI_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DLI_RowId</SqlRowIdName>
<StreamLocation>^User.MRDiagnosLymphInvasionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
