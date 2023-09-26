/// CT Window Defaults(1654)
Class User.CTWindowDefault Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_WindowDefault, StorageStrategy = SQLStorage ]
{

/// Data
Property WINDData As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = WIND_Data ];

/// Height
Property WINDHeight As %Float [ SqlColumnNumber = 6, SqlFieldName = WIND_Height ];

/// Index
Property WINDIndex As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = WIND_Index ];

/// Left Coord
Property WINDLeftCoord As %Float [ SqlColumnNumber = 4, SqlFieldName = WIND_LeftCoord ];

/// Name
Property WINDName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = WIND_Name ];

/// Top Coord
Property WINDTopCoord As %Float [ SqlColumnNumber = 3, SqlFieldName = WIND_TopCoord ];

/// Visible
Property WINDVisible As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = WIND_Visible ];

/// Width
Property WINDWidth As %Float [ SqlColumnNumber = 5, SqlFieldName = WIND_Width ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTWindowDefault).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTWindowDefault","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTWindowDefault).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTWindowDefault","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTWindowDefault).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTWindowDefault","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTWindowDefault).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTWindowDefault","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTWindowDefault).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTWindowDefault","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^CT("WIND",0))</SqlIdExpression>
<SQLMap name="Datamaster">
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
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>WIND_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WIND"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WIND_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>WIND_RowId</SqlRowIdName>
<StreamLocation>^User.CTWindowDefaultS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
