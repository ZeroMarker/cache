/// Person Organ Donor(2521)
Class User.PAPersonOrganDonor Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_PersonOrganDonor, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ORGChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_Person Parent Reference
Relationship ORGParRef As PAPerson [ Cardinality = parent, Inverse = ChildPAPersonOrganDonor, Required, SqlFieldName = ORG_ParRef ];

/// Childsub
Property ORGChildsub As %Float [ InitialExpression = {$i(^PAPER($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"ORG",0))}, SqlColumnNumber = 2, SqlFieldName = ORG_Childsub ];

/// Des Ref PAPER
Property ORGPAPERDR As PAPerson [ SqlColumnNumber = 3, SqlFieldName = ORG_PAPER_DR ];

/// Remarks
Property ORGRemarks As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = ORG_Remarks, SqlListType = SUBNODE ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAPersonOrganDonor).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonOrganDonor","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAPersonOrganDonor).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonOrganDonor","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAPersonOrganDonor).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonOrganDonor","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAPersonOrganDonor).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonOrganDonor","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAPersonOrganDonor).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonOrganDonor","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ORG_PAPER_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ORG_Remarks">
<Node>"REM"</Node>
</Data>
<Global>^PAPER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ORG_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ORG"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ORG_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ORG_RowId</SqlRowIdName>
<StreamLocation>^User.PAPersonOrganDonorS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
