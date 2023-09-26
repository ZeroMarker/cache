/// Govern Subcat(2184)
Class User.CTGovernSubcat Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_GovernSubcat, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On SUBChildsub [ IdKey, PrimaryKey, Unique ];

/// CT_GovernCateg Parent Reference
Relationship SUBParRef As CTGovernCateg [ Cardinality = parent, Inverse = ChildCTGovernSubcat, Required, SqlFieldName = SUB_ParRef ];

/// Childsub
Property SUBChildsub As %Float [ InitialExpression = {$i(^CT("GOVCAT",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"SUB",0))}, SqlColumnNumber = 2, SqlFieldName = SUB_Childsub ];

/// Code
Property SUBCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = SUB_Code ];

/// Description
Property SUBDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = SUB_Desc ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTGovernSubcat).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTGovernSubcat","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTGovernSubcat).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTGovernSubcat","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTGovernSubcat).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTGovernSubcat","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTGovernSubcat).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTGovernSubcat","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTGovernSubcat).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTGovernSubcat","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="SUB_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SUB_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CT_GovernCateg.GOVCAT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>SUB_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"GOVCAT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CT_GovernCateg.GOVCAT_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SUB"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SUB_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SUB_RowId</SqlRowIdName>
<StreamLocation>^User.CTGovernSubcatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
