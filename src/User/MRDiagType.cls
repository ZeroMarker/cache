/// MR Diagnos Type(1083)
Class User.MRDiagType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_DiagType, StorageStrategy = SQLStorage ]
{

/// Childsub
Property TYPChildsub As %Float [ InitialExpression = {$i(^MR($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"DIA",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"TYP",0))}, SqlColumnNumber = 2, SqlFieldName = TYP_Childsub ];

/// Des Ref to MRCDiagTyp
Property TYPMRCDiagTyp As MRCDiagnosType [ SqlColumnNumber = 3, SqlFieldName = TYP_MRCDiagTyp ];

/// MR_Diagnos Parent Reference
Relationship TYPParRef As MRDiagnos [ Cardinality = parent, Inverse = ChildMRDiagType, Required, SqlFieldName = TYP_ParRef ];

Index RowIDBasedIDKeyIndex On TYPChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 138;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRDiagType).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRDiagType","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRDiagType).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRDiagType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRDiagType).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRDiagType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRDiagType).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRDiagType","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRDiagType).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRDiagType","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>138</ExtentSize>
<Property name="TYPChildsub">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="TYPMRCDiagTyp">
<Selectivity>11.1111%</Selectivity>
</Property>
<Property name="TYPParRef">
<Selectivity>0.7246%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="TYP_MRCDiagTyp">
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
<Field>TYP_Childsub</Field>
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
<Expression>"TYP"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TYP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>TYP_RowId</SqlRowIdName>
<StreamLocation>^User.MRDiagTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
