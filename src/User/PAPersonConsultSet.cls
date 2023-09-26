/// PersonConsultSet(2706)
Class User.PAPersonConsultSet Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_PersonConsultSet, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On CONSETChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildPAPersonConsultSetCons As PAPersonConsultSetCons [ Cardinality = children, Inverse = CONSParRef ];

/// PA_Consult Parent Reference
Relationship CONSETParRef As PAConsult [ Cardinality = parent, Inverse = ChildPAPersonConsultSet, Required, SqlFieldName = CONSET_ParRef ];

/// Childsub
Property CONSETChildsub As %Float [ InitialExpression = {$i(^PA("CONS",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"CONSET",0))}, SqlColumnNumber = 2, SqlFieldName = CONSET_Childsub ];

/// Des Ref ConsCategory
Property CONSETConsCategoryDR As OECConsultCateg [ SqlColumnNumber = 3, SqlFieldName = CONSET_ConsCategory_DR ];

/// Description
Property CONSETDesc As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = CONSET_Desc ];

/// Des Ref ConsSubCat
Property CONSETConsSubCatDR As OECConsultCategSubCat [ SqlColumnNumber = 5, SqlFieldName = CONSET_ConsSubCat_DR ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PAPersonConsultSet).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonConsultSet","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PAPersonConsultSet).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonConsultSet","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PAPersonConsultSet).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonConsultSet","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PAPersonConsultSet).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonConsultSet","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonConsultSet","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PAPersonConsultSet).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonConsultSet","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="CONSET_ConsCategory_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CONSET_ConsSubCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CONSET_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PA</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PA_Consult.CONS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>CONSET_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PA_Consult.CONS_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CONSET"</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="4">
<Expression>{CONSET_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>CONSET_RowId</SqlRowIdName>
<StreamLocation>^User.PAPersonConsultSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
