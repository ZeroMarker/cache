/// Adm2 Maternity Complications(2535)
Class User.PAAdm2MaternityComplic Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_Adm2MaternityComplic, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On MATCChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_Adm2 Parent Reference
Relationship MATCParRef As PAAdm2 [ Cardinality = parent, Inverse = ChildPAAdm2MaternityComplic, Required, SqlFieldName = MATC_ParRef ];

/// Childsub
Property MATCChildsub As %Float [ InitialExpression = {$i(^PAADM($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"MATC",0))}, SqlColumnNumber = 2, SqlFieldName = MATC_Childsub ];

/// Des Ref MaternityReason
Property MATCMaternityReasonDR As PACAdmMaternityReason [ SqlColumnNumber = 3, SqlFieldName = MATC_MaternityReason_DR ];

/// Update Date
Property MATCUpdateDate As %Date [ SqlColumnNumber = 4, SqlFieldName = MATC_UpdateDate ];

/// Update Time
Property MATCUpdateTime As %Time [ SqlColumnNumber = 5, SqlFieldName = MATC_UpdateTime ];

/// Des Ref UpdateUser
Property MATCUpdateUserDR As SSUser [ SqlColumnNumber = 6, SqlFieldName = MATC_UpdateUser_DR ];

/// Des Ref UpdateHospital
Property MATCUpdateHospitalDR As CTHospital [ SqlColumnNumber = 7, SqlFieldName = MATC_UpdateHospital_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAAdm2MaternityComplic).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdm2MaternityComplic","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAAdm2MaternityComplic).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdm2MaternityComplic","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAAdm2MaternityComplic).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdm2MaternityComplic","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAAdm2MaternityComplic).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdm2MaternityComplic","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAAdm2MaternityComplic).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdm2MaternityComplic","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="MATC_MaternityReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MATC_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MATC_UpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MATC_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MATC_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm2.PAADM2_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MATC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm2.PAADM2_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MATC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MATC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>MATC_RowId</SqlRowIdName>
<StreamLocation>^User.PAAdm2MaternityComplicS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
