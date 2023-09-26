/// MR Window Layout(1142)
Class User.MRWindowLayout Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_WindowLayout, StorageStrategy = SQLStorage ]
{

/// Childsub
Property WINChildsub As %Float [ InitialExpression = {$i(^MR($p(%d(0),$c(1)),"WIN",0))}, SqlColumnNumber = 2, SqlFieldName = WIN_Childsub ];

/// Data
Property WINData As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = WIN_Data ];

/// Height
Property WINHeight As %Float [ SqlColumnNumber = 7, SqlFieldName = WIN_Height ];

/// Index
Property WINIndex As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = WIN_Index ];

/// Left Coord
Property WINLeftCoord As %Float [ SqlColumnNumber = 5, SqlFieldName = WIN_LeftCoord ];

/// Window Name
Property WINName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = WIN_Name ];

/// MR_Adm Parent Reference
Relationship WINParRef As MRAdm [ Cardinality = parent, Inverse = ChildMRWindowLayout, Required, SqlFieldName = WIN_ParRef ];

/// Top Coord
Property WINTopCoord As %Float [ SqlColumnNumber = 4, SqlFieldName = WIN_TopCoord ];

/// Des Ref User_DR
Property WINUserDR As SSUser [ SqlColumnNumber = 11, SqlFieldName = WIN_User_DR ];

/// Visible
Property WINVisible As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = WIN_Visible ];

/// Width
Property WINWidth As %Float [ SqlColumnNumber = 6, SqlFieldName = WIN_Width ];

Index RowIDBasedIDKeyIndex On WINChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 20;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRWindowLayout).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRWindowLayout","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRWindowLayout).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRWindowLayout","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRWindowLayout).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRWindowLayout","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRWindowLayout).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRWindowLayout","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRWindowLayout).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRWindowLayout","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>20</ExtentSize>
<Property name="WINChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="WINData">
<Selectivity>1</Selectivity>
</Property>
<Property name="WINHeight">
<Selectivity>1</Selectivity>
</Property>
<Property name="WINIndex">
<Selectivity>1</Selectivity>
</Property>
<Property name="WINLeftCoord">
<Selectivity>1</Selectivity>
</Property>
<Property name="WINName">
<Selectivity>1</Selectivity>
</Property>
<Property name="WINParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="WINTopCoord">
<Selectivity>1</Selectivity>
</Property>
<Property name="WINUserDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="WINVisible">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="WINWidth">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="WIN_Data">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="WIN_Height">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="WIN_Index">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="WIN_LeftCoord">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WIN_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WIN_TopCoord">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="WIN_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="WIN_Visible">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="WIN_Width">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>WIN_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"WIN"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WIN_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>WIN_RowId</SqlRowIdName>
<StreamLocation>^User.MRWindowLayoutS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
