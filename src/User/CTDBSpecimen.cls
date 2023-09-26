/// DB Specimen(2425)
Class User.CTDBSpecimen Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_DBSpecimen, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DBSPECCode [ IdKey, PrimaryKey, Unique ];

/// Code
Property DBSPECCode As %String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DBSPEC_Code ];

/// Desc
Property DBSPECDesc As %String(COLLATION = "Exact", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DBSPEC_Desc ];

/// Date From
Property DBSPECDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = DBSPEC_DateFrom ];

/// Date To
Property DBSPECDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = DBSPEC_DateTo ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTDBSpecimen).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTDBSpecimen","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTDBSpecimen).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTDBSpecimen","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTDBSpecimen).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTDBSpecimen","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTDBSpecimen).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTDBSpecimen","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTDBSpecimen).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTDBSpecimen","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DBSPEC_DateFrom">
<Delimiter>"\"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DBSPEC_DateTo">
<Delimiter>"\"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DBSPEC_Desc">
<Delimiter>"\"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^TTAB</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DBSPEC_Code</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DB-SPEC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DBSPEC_Code}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DBSPEC_RowId</SqlRowIdName>
<StreamLocation>^User.CTDBSpecimenS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
