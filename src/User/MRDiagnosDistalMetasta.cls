/// DiagnosDistalMetastas(2646)
Class User.MRDiagnosDistalMetasta Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_DiagnosDistalMetasta, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On METChildsub [ IdKey, PrimaryKey, Unique ];

/// MR_Diagnos Parent Reference
Relationship METParRef As MRDiagnos [ Cardinality = parent, Inverse = ChildMRDiagnosDistalMetasta, Required, SqlFieldName = MET_ParRef ];

/// Childsub
Property METChildsub As %Float [ InitialExpression = {$i(^MR($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"DIA",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"MET",0))}, SqlColumnNumber = 2, SqlFieldName = MET_Childsub ];

/// Des Ref BodySite
Property METBodySiteDR As OECBodySite [ SqlColumnNumber = 3, SqlFieldName = MET_BodySite_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRDiagnosDistalMetasta).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRDiagnosDistalMetasta","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRDiagnosDistalMetasta).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRDiagnosDistalMetasta","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRDiagnosDistalMetasta).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRDiagnosDistalMetasta","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRDiagnosDistalMetasta).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRDiagnosDistalMetasta","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRDiagnosDistalMetasta).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRDiagnosDistalMetasta","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="MET_BodySite_DR">
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
<Field>MET_Childsub</Field>
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
<Expression>"MET"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MET_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>MET_RowId</SqlRowIdName>
<StreamLocation>^User.MRDiagnosDistalMetastaS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
