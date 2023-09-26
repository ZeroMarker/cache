/// ConsultCategFollowOrd(2731)
Class User.OECConsultCategFollowOrd Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OEC_ConsultCategFollowOrd, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On FOLChildsub [ IdKey, PrimaryKey, Unique ];

/// OEC_ConsultCateg Parent Reference
Relationship FOLParRef As OECConsultCateg [ Cardinality = parent, Inverse = ChildOECConsultCategFollowOrd, Required, SqlFieldName = FOL_ParRef ];

/// Childsub
Property FOLChildsub As %Float [ InitialExpression = {$i(^OEC("CONS",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"FOL",0))}, SqlColumnNumber = 2, SqlFieldName = FOL_Childsub ];

/// Des Ref ARCIM
Property FOLARCIMDR As ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = FOL_ARCIM_DR ];

/// Default
Property FOLDefault As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = FOL_Default ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OECConsultCategFollowOrd).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECConsultCategFollowOrd","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OECConsultCategFollowOrd).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECConsultCategFollowOrd","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OECConsultCategFollowOrd).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECConsultCategFollowOrd","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OECConsultCategFollowOrd).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECConsultCategFollowOrd","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OECConsultCategFollowOrd).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECConsultCategFollowOrd","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="FOL_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FOL_Default">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^OEC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>OEC_ConsultCateg.CONS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>FOL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{OEC_ConsultCateg.CONS_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"FOL"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{FOL_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>FOL_RowId</SqlRowIdName>
<StreamLocation>^User.OECConsultCategFollowOrdS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
