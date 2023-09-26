/// SynonymText(2123)
Class User.PACSynonymText Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_SynonymText, StorageStrategy = SQLStorage ]
{

/// Childsub
Property TXTChildsub As %Float [ InitialExpression = {$i(^PAC("SYN",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"TXT",0))}, SqlColumnNumber = 2, SqlFieldName = TXT_Childsub ];

/// PAC_Synonym Parent Reference
Relationship TXTParRef As PACSynonym [ Cardinality = parent, Inverse = ChildPACSynonymText, Required, SqlFieldName = TXT_ParRef ];

/// Des Ref Sex
Property TXTSexDR As CTSex [ SqlColumnNumber = 4, SqlFieldName = TXT_Sex_DR ];

/// Text
Property TXTText As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = TXT_Text ];

Index RowIDBasedIDKeyIndex On TXTChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 4;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACSynonymText).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSynonymText","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACSynonymText).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSynonymText","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACSynonymText).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSynonymText","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACSynonymText).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSynonymText","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACSynonymText).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSynonymText","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>4</ExtentSize>
<Property name="TXTChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="TXTParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="TXTSexDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="TXTText">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="TXT_Sex_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TXT_Text">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_Synonym.SYN_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>TXT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SYN"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_Synonym.SYN_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"TXT"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TXT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexText">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_Synonym.SYN_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>TXT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SYN"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_Synonym.SYN_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"TXT"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Text"</Expression>
</Subscript>
<Subscript name="6">
<Expression>$$ALPHAUP({TXT_Text})</Expression>
</Subscript>
<Subscript name="7">
<Expression>{TXT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>TXT_RowId</SqlRowIdName>
<StreamLocation>^User.PACSynonymTextS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
