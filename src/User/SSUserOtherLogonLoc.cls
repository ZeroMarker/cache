/// UserOtherLogonLoc(2210)
Class User.SSUserOtherLogonLoc Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = SS_UserOtherLogonLoc, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On OTHLLChildsub [ IdKey, PrimaryKey, Unique ];

/// SS_User Parent Reference
Relationship OTHLLParRef As SSUser [ Cardinality = parent, Inverse = ChildSSUserOtherLogonLoc, Required, SqlFieldName = OTHLL_ParRef ];

/// Childsub
Property OTHLLChildsub As %Float [ InitialExpression = {$i(^SSU("SSUSR",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"OTHLL",0))}, SqlColumnNumber = 2, SqlFieldName = OTHLL_Childsub ];

/// Des Ref CTLOC
Property OTHLLCTLOCDR As CTLoc [ SqlColumnNumber = 3, SqlFieldName = OTHLL_CTLOC_DR ];

/// Des Ref UserGroup
Property OTHLLUserGroupDR As SSGroup [ SqlColumnNumber = 4, SqlFieldName = OTHLL_UserGroup_DR ];

/// Des Ref to CT_Hospital
Property OTHLLHospitalDR As CTHospital [ SqlColumnNumber = 5, SqlFieldName = OTHLL_Hospital_DR ];

/// Des Ref UserGroup
Property OTHLLStartDate As %Date [ SqlColumnNumber = 6, SqlFieldName = OTHLL_StartDate ];

/// Des Ref to CT_Hospital
Property OTHLLEndDate As %Date [ SqlColumnNumber = 7, SqlFieldName = OTHLL_EndDate ];

/// 登录次数 add@20230222
Property OTHLLLogonCount As %Float [ SqlColumnNumber = 8, SqlFieldName = OTHLL_LogonCount ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSUserOtherLogonLoc).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserOtherLogonLoc","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSUserOtherLogonLoc).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserOtherLogonLoc","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSUserOtherLogonLoc).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserOtherLogonLoc","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSUserOtherLogonLoc).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserOtherLogonLoc","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSUserOtherLogonLoc).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserOtherLogonLoc","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="OTHLL_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OTHLL_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OTHLL_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OTHLL_LogonCount">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OTHLL_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OTHLL_UserGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^SSU</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_User.SSUSR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>OTHLL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSUSR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_User.SSUSR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"OTHLL"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OTHLL_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>OTHLL_RowId</SqlRowIdName>
<StreamLocation>^User.SSUserOtherLogonLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
