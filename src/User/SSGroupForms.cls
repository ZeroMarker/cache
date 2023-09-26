/// SS Group Forms(1352)
Class User.SSGroupForms Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_GroupForms, StorageStrategy = SQLStorage ]
{

/// Childsub
Property FORMChildsub As %Float [ InitialExpression = {$i(^SSU("SSGRP",$p(%d(0),$c(1)),"FORM",0))}, SqlColumnNumber = 2, SqlFieldName = FORM_Childsub ];

/// Height
Property FORMHeight As %Float [ SqlColumnNumber = 5, SqlFieldName = FORM_Height ];

/// Left Coord
Property FORMLeftCoord As %Float [ SqlColumnNumber = 4, SqlFieldName = FORM_LeftCoord ];

/// Notes Height
Property FORMNotesHeight As %Float [ SqlColumnNumber = 10, SqlFieldName = FORM_NotesHeight ];

/// Notes Left Coord
Property FORMNotesLeftCoord As %Float [ SqlColumnNumber = 8, SqlFieldName = FORM_NotesLeftCoord ];

/// Notes Top Coord
Property FORMNotesTopCoord As %Float [ SqlColumnNumber = 7, SqlFieldName = FORM_NotesTopCoord ];

/// Notes Width
Property FORMNotesWidth As %Float [ SqlColumnNumber = 9, SqlFieldName = FORM_NotesWidth ];

/// SS_Group Parent Reference
Relationship FORMParRef As SSGroup [ Cardinality = parent, Inverse = ChildSSGroupForms, Required, SqlFieldName = FORM_ParRef ];

/// Top Coord
Property FORMTopCoord As %Float [ SqlColumnNumber = 3, SqlFieldName = FORM_TopCoord ];

/// Width
Property FORMWidth As %Float [ SqlColumnNumber = 6, SqlFieldName = FORM_Width ];

Index RowIDBasedIDKeyIndex On FORMChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 4;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSGroupForms).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupForms","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSGroupForms).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupForms","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSGroupForms).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupForms","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSGroupForms).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupForms","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSGroupForms).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupForms","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>4</ExtentSize>
<Property name="FORMChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="FORMHeight">
<Selectivity>1</Selectivity>
</Property>
<Property name="FORMLeftCoord">
<Selectivity>1</Selectivity>
</Property>
<Property name="FORMNotesHeight">
<Selectivity>1</Selectivity>
</Property>
<Property name="FORMNotesLeftCoord">
<Selectivity>1</Selectivity>
</Property>
<Property name="FORMNotesTopCoord">
<Selectivity>1</Selectivity>
</Property>
<Property name="FORMNotesWidth">
<Selectivity>1</Selectivity>
</Property>
<Property name="FORMParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="FORMTopCoord">
<Selectivity>1</Selectivity>
</Property>
<Property name="FORMWidth">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="FORM_Height">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="FORM_LeftCoord">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="FORM_NotesHeight">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="FORM_NotesLeftCoord">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="FORM_NotesTopCoord">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="FORM_NotesWidth">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="FORM_TopCoord">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FORM_Width">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^SSU</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_Group.SSGRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>FORM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"FORM"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{FORM_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>FORM_RowId</SqlRowIdName>
<StreamLocation>^User.SSGroupFormsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
