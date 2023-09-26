/// TextResultHistSection(2279)
Class User.OETextResultHistSection Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OE_TextResultHistSection, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On HSChildsub [ IdKey, PrimaryKey, Unique ];

/// OE_TextResultHistory Parent Reference
Relationship HSParRef As OETextResultHistory [ Cardinality = parent, Inverse = ChildOETextResultHistSection, Required, SqlFieldName = HS_ParRef ];

/// Childsub
Property HSChildsub As %Float [ InitialExpression = {$i(^OETR($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"HIS",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"HS",0))}, SqlColumnNumber = 2, SqlFieldName = HS_Childsub ];

/// Des Ref TexResSection
Property HSTexResSectionDR As OECTextResultSection [ SqlColumnNumber = 3, SqlFieldName = HS_TexResSection_DR ];

/// Text
Property HSText As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = HS_Text, SqlListType = subnode ];

/// RTFText
Property HSRTFText As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = HS_RTFText, SqlListType = subnode ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.OETextResultHistSection).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OETextResultHistSection","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.OETextResultHistSection).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OETextResultHistSection","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.OETextResultHistSection).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OETextResultHistSection","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.OETextResultHistSection).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OETextResultHistSection","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OETextResultHistSection","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.OETextResultHistSection).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OETextResultHistSection","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="HS_RTFText">
<Node>"RTF"</Node>
</Data>
<Data name="HS_TexResSection_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="HS_Text">
<Node>"REM"</Node>
</Data>
<Global>^OETR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OE_TextResult.TR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>OE_TextResultHistory.HIS_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>HS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{OE_TextResult.TR_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HIS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_TextResultHistory.HIS_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"HS"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{HS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>HS_RowId</SqlRowIdName>
<StreamLocation>^User.OETextResultHistSectionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
