/// SS User Window Default(1456)
Class User.SSUserWindowDefault Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_UserWindowDefault, StorageStrategy = SQLStorage ]
{

/// Childsub
Property WINDChildsub As %Float [ InitialExpression = {$i(^SST("SSUSR",$p(%d(0),$c(1)),"WIND",0))}, SqlColumnNumber = 2, SqlFieldName = WIND_Childsub ];

/// Data
Property WINDData As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = WIND_Data ];

/// Height
Property WINDHeight As %Float [ SqlColumnNumber = 7, SqlFieldName = WIND_Height ];

/// Index
Property WINDIndex As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = WIND_Index ];

/// Left Coord
Property WINDLeftCoord As %Float [ SqlColumnNumber = 5, SqlFieldName = WIND_LeftCoord ];

/// Window Name
Property WINDName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = WIND_Name ];

/// SS_User Parent Reference
Relationship WINDParRef As SSUser [ Cardinality = parent, Inverse = ChildSSUserWindowDefault, Required, SqlFieldName = WIND_ParRef ];

/// Top Coord
Property WINDTopCoord As %Float [ SqlColumnNumber = 4, SqlFieldName = WIND_TopCoord ];

/// Visible
Property WINDVisible As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = WIND_Visible ];

/// Width
Property WINDWidth As %Float [ SqlColumnNumber = 6, SqlFieldName = WIND_Width ];

Index RowIDBasedIDKeyIndex On WINDChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSUserWindowDefault).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserWindowDefault","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSUserWindowDefault).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserWindowDefault","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSUserWindowDefault).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserWindowDefault","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSUserWindowDefault).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserWindowDefault","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSUserWindowDefault).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserWindowDefault","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="WIND_Data">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="WIND_Height">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="WIND_Index">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="WIND_LeftCoord">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WIND_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WIND_TopCoord">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="WIND_Visible">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="WIND_Width">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^SST</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_User.SSUSR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>WIND_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSUSR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_User.SSUSR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"WIND"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WIND_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>WIND_RowId</SqlRowIdName>
<StreamLocation>^User.SSUserWindowDefaultS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
