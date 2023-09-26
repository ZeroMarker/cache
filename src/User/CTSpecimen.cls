/// CT Specimen(1887)
Class User.CTSpecimen Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_Specimen, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On SPECCode [ IdKey, PrimaryKey, Unique ];

/// Code
Property SPECCode As %String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = SPEC_Code ];

/// Description
Property SPECDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = SPEC_Desc ];

/// DateFrom
Property SPECDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = SPEC_DateFrom ];

/// DateTo
Property SPECDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = SPEC_DateTo ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTSpecimen).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTSpecimen","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTSpecimen).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTSpecimen","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTSpecimen).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTSpecimen","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTSpecimen).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTSpecimen","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTSpecimen).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTSpecimen","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="SPEC_DateFrom">
<Delimiter>"\"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SPEC_DateTo">
<Delimiter>"\"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SPEC_Desc">
<Delimiter>"\"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^TTAB</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SPEC_Code</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SPEC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SPEC_Code}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SPEC_RowId</SqlRowIdName>
<StreamLocation>^User.CTSpecimenS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
