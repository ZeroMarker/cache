/// SS New Style Menus      (1017)
Class User.SSMenu Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_Menu, StorageStrategy = SQLStorage ]
{

/// Menu Bar Routine
Property SSMNUMenuBarRoutine As %String(COLLATION = "Exact", MAXLEN = 8, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = SSMNU_MenuBarRoutine ];

/// Pop Up Menu Routine Name
Property SSMNUMenuPopUpRoutine As %String(COLLATION = "Exact", MAXLEN = 8, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = SSMNU_MenuPopUpRoutine ];

/// Menu Name
Property SSMNUName As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = SSMNU_Name ];

/// SSMNU Row ID
Property SSMNURowId As %Float [ Required, SqlFieldName = SSMNU_RowId ];

Index RowIDBasedIDKeyIndex On SSMNURowId [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSMenu).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSMenu","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSMenu).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSMenu","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSMenu).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSMenu","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSMenu).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSMenu","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSMenu).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSMenu","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="MenuMaster">
<Data name="SSMNU_MenuBarRoutine">
<Delimiter>$c(1)</Delimiter>
<Node>3</Node>
<Piece>10</Piece>
</Data>
<Data name="SSMNU_MenuPopUpRoutine">
<Delimiter>$c(1)</Delimiter>
<Node>2</Node>
<Piece>10</Piece>
</Data>
<Data name="SSMNU_Name">
<Delimiter>$c(1)</Delimiter>
<Node>1</Node>
<Piece>1</Piece>
</Data>
<Global>^mobject</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>SSMNU_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"object"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"menu"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SSMNU_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SSMNU_RowId</SqlRowIdName>
<StreamLocation>^User.SSMenuS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
