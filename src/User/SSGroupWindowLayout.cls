/// SS Group Window Layout(1347)
Class User.SSGroupWindowLayout Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_GroupWindowLayout, StorageStrategy = SQLStorage ]
{

Relationship ChildSSGroupWinLayoutOrdCat As SSGroupWinLayoutOrdCat [ Cardinality = children, Inverse = CATParRef ];

/// Appointment Flag
Property WINAppointmentFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = WIN_AppointmentFlag ];

/// Childsub
Property WINChildsub As %Float [ InitialExpression = {$i(^SSU("SSGRP",$p(%d(0),$c(1)),"WIN",0))}, SqlColumnNumber = 2, SqlFieldName = WIN_Childsub ];

/// Height
Property WINHeight As %Float [ SqlColumnNumber = 7, SqlFieldName = WIN_Height ];

/// Left Coord
Property WINLeftCoord As %Float [ SqlColumnNumber = 4, SqlFieldName = WIN_LeftCoord ];

/// Name
Property WINName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ Required, SqlColumnNumber = 5, SqlFieldName = WIN_Name ];

/// SS_Group Parent Reference
Relationship WINParRef As SSGroup [ Cardinality = parent, Inverse = ChildSSGroupWindowLayout, Required, SqlFieldName = WIN_ParRef ];

/// Top Coord
Property WINTopCoord As %Float [ SqlColumnNumber = 3, SqlFieldName = WIN_TopCoord ];

/// Visible
Property WINVisible As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = WIN_Visible ];

/// Width
Property WINWidth As %Float [ SqlColumnNumber = 6, SqlFieldName = WIN_Width ];

Index RowIDBasedIDKeyIndex On WINChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSGroupWindowLayout).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupWindowLayout","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSGroupWindowLayout).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupWindowLayout","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSGroupWindowLayout).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupWindowLayout","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSGroupWindowLayout).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupWindowLayout","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSGroupWindowLayout).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupWindowLayout","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="WIN_AppointmentFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="WIN_Height">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WIN_LeftCoord">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WIN_Name">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="WIN_TopCoord">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="WIN_Visible">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="WIN_Width">
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
<Field>WIN_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"WIN"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WIN_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>WIN_RowId</SqlRowIdName>
<StreamLocation>^User.SSGroupWindowLayoutS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
