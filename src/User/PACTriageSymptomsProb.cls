/// TriageSymptomsProblems(2602)
Class User.PACTriageSymptomsProb Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_TriageSymptomsProb, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PROBChildsub [ IdKey, PrimaryKey, Unique ];

/// PAC_TriageSymptoms Parent Reference
Relationship PROBParRef As PACTriageSymptoms [ Cardinality = parent, Inverse = ChildPACTriageSymptomsProb, Required, SqlFieldName = PROB_ParRef ];

/// Childsub
Property PROBChildsub As %Float [ InitialExpression = {$i(^PAC("TRISYM",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"PROB",0))}, SqlColumnNumber = 2, SqlFieldName = PROB_Childsub ];

/// Code
Property PROBCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PROB_Code ];

/// Description
Property PROBDesc As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = PROB_Desc ];

/// Des Ref Acuity
Property PROBAcuityDR As CTAcuity [ SqlColumnNumber = 5, SqlFieldName = PROB_Acuity_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACTriageSymptomsProb).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACTriageSymptomsProb","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACTriageSymptomsProb).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACTriageSymptomsProb","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACTriageSymptomsProb).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACTriageSymptomsProb","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACTriageSymptomsProb).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACTriageSymptomsProb","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACTriageSymptomsProb).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACTriageSymptomsProb","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="PROB_Acuity_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PROB_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PROB_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_TriageSymptoms.TRISYM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PROB_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TRISYM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_TriageSymptoms.TRISYM_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"PROB"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PROB_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PROB_RowId</SqlRowIdName>
<StreamLocation>^User.PACTriageSymptomsProbS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
