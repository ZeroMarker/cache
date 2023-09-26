/// VB Menu Options        (SSVBO,1147)
Class User.SSVBMenuOptions Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_VBMenuOptions, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On SSVBOChildsub [ IdKey, PrimaryKey, Unique ];

/// SSVBE Parent Reference
Relationship SSVBOParRef As SSVBExecutables [ Cardinality = parent, Inverse = ChildSSVBMenuOptions, Required, SqlFieldName = SSVBO_ParRef ];

/// SSVBO Child subscript
Property SSVBOChildsub As %Float [ InitialExpression = {$i(^SS("SSVBE",$p(%d(0),$c(1)),"SSVBO",0))}, Required, SqlColumnNumber = 2, SqlFieldName = SSVBO_Childsub ];

/// Description of the Menu Option
Property SSVBODescription As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = SSVBO_Description ];

/// The name of the VB Menu Option
Property SSVBOMenuName As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = SSVBO_MenuName ];

/// MainForm
Property SSVBOMainForm As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = SSVBO_MainForm ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSVBMenuOptions).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSVBMenuOptions","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSVBMenuOptions).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSVBMenuOptions","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSVBMenuOptions).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSVBMenuOptions","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSVBMenuOptions).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSVBMenuOptions","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSVBMenuOptions).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSVBMenuOptions","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="SSVBOMaster">
<Data name="SSVBO_Description">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SSVBO_MainForm">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SSVBO_MenuName">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^SS</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_VBExecutables.SSVBE_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>SSVBO_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"SSVBE"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{SS_VBExecutables.SSVBE_RowID}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"SSVBO"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{SSVBO_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SSVBO_RowID</SqlRowIdName>
<StreamLocation>^User.SSVBMenuOptionsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
