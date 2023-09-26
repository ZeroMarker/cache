/// User PAC Logons(2789)
Class User.SSUserPACLogons Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_UserPACLogons, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PACChildsub [ IdKey, PrimaryKey, Unique ];

/// SS_User Parent Reference
Relationship PACParRef As SSUser [ Cardinality = parent, Inverse = ChildSSUserPACLogons, Required, SqlFieldName = PAC_ParRef ];

/// Childsub
Property PACChildsub As %Float [ InitialExpression = {$i(^SSU("SSUSR",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"PAC",0))}, SqlColumnNumber = 2, SqlFieldName = PAC_Childsub ];

/// PACSystem
Property PACPACSystem As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PAC_PACSystem ];

/// UserName
Property PACUserName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = PAC_UserName ];

/// Password
Property PACPassword As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PAC_Password ];

/// Last Updated Time
Property PACLastUpdatedTime As %Time [ SqlColumnNumber = 6, SqlFieldName = PAC_LastUpdatedTime ];

/// Last Updated Date
Property PACLastUpdatedDate As %Date [ SqlColumnNumber = 7, SqlFieldName = PAC_LastUpdatedDate ];

/// Last Updated User
Property PACLastUpdatedUser As SSUser [ SqlColumnNumber = 8, SqlFieldName = PAC_LastUpdatedUser ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.SSUserPACLogons).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserPACLogons","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.SSUserPACLogons).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserPACLogons","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.SSUserPACLogons).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserPACLogons","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.SSUserPACLogons).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserPACLogons","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserPACLogons","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.SSUserPACLogons).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserPACLogons","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="PAC_LastUpdatedDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PAC_LastUpdatedTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PAC_LastUpdatedUser">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PAC_PACSystem">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PAC_Password">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PAC_UserName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^SSU</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_User.SSUSR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PAC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSUSR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_User.SSUSR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"PAC"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PAC_RowId</SqlRowIdName>
<StreamLocation>^User.SSUserPACLogonsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
