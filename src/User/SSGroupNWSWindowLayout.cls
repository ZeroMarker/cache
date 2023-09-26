/// SS Group NWS WindowLayout(1359)
Class User.SSGroupNWSWindowLayout Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_GroupNWS_WindowLayout, StorageStrategy = SQLStorage ]
{

Relationship ChildSSGroupNWSWinLayoutOrdCat As SSGroupNWSWinLayoutOrdCat [ Cardinality = children, Inverse = CATParRef ];

/// Appointment Flag
Property NWSWINAppointmentFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = NWSWIN_AppointmentFlag ];

/// Childsub
Property NWSWINChildsub As %Float [ InitialExpression = {$i(^SSU("SSGRP",$p(%d(0),$c(1)),"NWSWIN",0))}, SqlColumnNumber = 2, SqlFieldName = NWSWIN_Childsub ];

/// Height
Property NWSWINHeight As %Float [ SqlColumnNumber = 7, SqlFieldName = NWSWIN_Height ];

/// Left Coord
Property NWSWINLeftCoord As %Float [ SqlColumnNumber = 4, SqlFieldName = NWSWIN_LeftCoord ];

/// Name
Property NWSWINName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ Required, SqlColumnNumber = 5, SqlFieldName = NWSWIN_Name ];

/// SS_Group Parent Reference
Relationship NWSWINParRef As SSGroup [ Cardinality = parent, Inverse = ChildSSGroupNWSWindowLayout, Required, SqlFieldName = NWSWIN_ParRef ];

/// Top Coord
Property NWSWINTopCoord As %Float [ SqlColumnNumber = 3, SqlFieldName = NWSWIN_TopCoord ];

/// Visible
Property NWSWINVisible As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = NWSWIN_Visible ];

/// Width
Property NWSWINWidth As %Float [ SqlColumnNumber = 6, SqlFieldName = NWSWIN_Width ];

Index RowIDBasedIDKeyIndex On NWSWINChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSGroupNWSWindowLayout).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupNWSWindowLayout","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSGroupNWSWindowLayout).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupNWSWindowLayout","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSGroupNWSWindowLayout).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupNWSWindowLayout","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSGroupNWSWindowLayout).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupNWSWindowLayout","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSGroupNWSWindowLayout).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupNWSWindowLayout","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="NWSWIN_AppointmentFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="NWSWIN_Height">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="NWSWIN_LeftCoord">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="NWSWIN_Name">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="NWSWIN_TopCoord">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="NWSWIN_Visible">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="NWSWIN_Width">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^SSU</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_Group.SSGRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>NWSWIN_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"NWSWIN"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{NWSWIN_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>NWSWIN_RowId</SqlRowIdName>
<StreamLocation>^User.SSGroupNWSWindowLayoutS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
