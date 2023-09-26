/// VBexe Functions in Grp (SSGVF,1148)
Class User.SSGroupVBExecFunction Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_GroupVBExecFunction, StorageStrategy = SQLStorage ]
{

Relationship ChildSSGroupVBExFunctOpt As SSGroupVBExFunctOpt [ Cardinality = children, Inverse = VBOPTParRef ];

/// Display Icon for executable
Property VBEXDisplay As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = VBEX_Display ];

/// SS_Group Parent Reference
Relationship VBEXParRef As SSGroup [ Cardinality = parent, Inverse = ChildSSGroupVBExecFunction, Required, SqlFieldName = VBEX_ParRef ];

/// Read Only
Property VBEXReadOnly As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = VBEX_ReadOnly ];

/// Des Ref to SSVBF
Property VBEXSSVBFDR As SSVBExecutables [ Required, SqlColumnNumber = 2, SqlFieldName = VBEX_SSVBF_DR ];

Index RowIDBasedIDKeyIndex On VBEXSSVBFDR [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 13213;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSGroupVBExecFunction).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSGroupVBExecFunction","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSGroupVBExecFunction).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSGroupVBExecFunction","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSGroupVBExecFunction).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSGroupVBExecFunction","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSGroupVBExecFunction).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSGroupVBExecFunction","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSGroupVBExecFunction).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSGroupVBExecFunction","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>13213</ExtentSize>
<Property name="VBEXDisplay">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="VBEXParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="VBEXReadOnly">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="VBEXSSVBFDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="VBEX_Display">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="VBEX_ReadOnly">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^SSU</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_Group.SSGRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>VBEX_SSVBF_DR</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"VBEX"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VBEX_SSVBF_DR}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>VBEX_RowId</SqlRowIdName>
<StreamLocation>^User.SSGroupVBExecFunctionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
