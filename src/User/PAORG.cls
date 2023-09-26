/// Organization            (ORG, 5015)
Class User.PAORG Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_ORG, StorageStrategy = SQLStorage ]
{

/// Des Ref to CTADR
Property ORGAddrTypeDR As CTAddrType [ SqlColumnNumber = 3, SqlFieldName = ORG_AddrType_DR ];

/// Block
Property ORGBlk As %String(COLLATION = "AlphaUp", MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = ORG_Blk ];

/// Des Ref to CTCIT
Property ORGCityDR As CTCity [ SqlColumnNumber = 4, SqlFieldName = ORG_City_DR ];

/// Code
Property ORGCode As %String(COLLATION = "AlphaUp", MAXLEN = 8, TRUNCATE = 1) [ Required, SqlColumnNumber = 5, SqlFieldName = ORG_Code ];

/// Level
Property ORGLevel As %String(COLLATION = "AlphaUp", MAXLEN = 3, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = ORG_Level ];

/// Name
Property ORGName As %String(COLLATION = "AlphaUp", MAXLEN = 40, TRUNCATE = 1) [ Required, SqlColumnNumber = 7, SqlFieldName = ORG_Name ];

/// Street Name
Property ORGStName As list Of %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = ORG_StName, SqlListType = SUBNODE ];

/// Des Ref to CTSTT
Property ORGStateDR As CTState [ SqlColumnNumber = 8, SqlFieldName = ORG_State_DR ];

/// Office Telephone Number
Property ORGTelO As %String(COLLATION = "AlphaUp", MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = ORG_TelO ];

/// Extension No (Ext)
Property ORGTelOExt As %String(COLLATION = "AlphaUp", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = ORG_TelOExt ];

/// Unit
Property ORGUnit As %String(COLLATION = "AlphaUp", MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = ORG_Unit ];

/// Des Ref to CTZIP
Property ORGZipDR As CTZip [ SqlColumnNumber = 12, SqlFieldName = ORG_Zip_DR ];

Index ORGCodeUnqIdx1 On ORGCode [ Unique ];

Index ORGNameUnqIdx2 On ORGName [ Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAORG).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAORG","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAORG).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAORG","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAORG).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAORG","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAORG).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAORG","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAORG).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAORG","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAORG(0))</SqlIdExpression>
<SQLMap name="DataMasterMapPAORG">
<Data name="ORG_AddrType_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ORG_Blk">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ORG_City_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ORG_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ORG_Level">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ORG_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ORG_StName">
<Node>"ADD"</Node>
</Data>
<Data name="ORG_State_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ORG_TelO">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ORG_TelOExt">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ORG_Unit">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ORG_Zip_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^PAORG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ORG_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{ORG_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexORGName">
<Global>^PAORG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ORG_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ORG_Name"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({ORG_Name})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ORG_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ORG_RowID</SqlRowIdName>
<StreamLocation>^User.PAORGS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
