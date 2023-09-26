/// OE Text Result Section(1394)
Class User.OETextResultSection Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OE_TextResultSection, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On SECChildsub [ IdKey, PrimaryKey, Unique ];

/// OE_TextResult Parent Reference
Relationship SECParRef As OETextResult [ Cardinality = parent, Inverse = ChildOETextResultSection, Required, SqlFieldName = SEC_ParRef ];

/// Childsub
Property SECChildsub As %Float [ InitialExpression = {$i(^OETR($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"SEC",0))}, SqlColumnNumber = 2, SqlFieldName = SEC_Childsub ];

/// Des Ref ResultTypeSection
Property SECResultTypeSectionDR As OECTextResultSection [ SqlColumnNumber = 3, SqlFieldName = SEC_ResultTypeSection_DR ];

/// Text
Property SECText As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = SEC_Text, SqlListType = SUBNODE ];

/// RTFText
Property SECRTFText As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = SEC_RTFText, SqlListType = SUBNODE ];

Parameter EXTENTSIZE = 1000000;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OETextResultSection).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OETextResultSection","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OETextResultSection).OnTrigger($g(%d(1)))

 d Table^HL7Outbound("OETextResultSection",%d(1),"Insert")

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OETextResultSection","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OETextResultSection).OnTrigger($g(%d(1)))

 d Table^HL7Outbound("OETextResultSection",%d(1),"Update")

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OETextResultSection","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OETextResultSection).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OETextResultSection","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OETextResultSection).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OETextResultSection","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OETextResultSection","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>413</ExtentSize>
<Property name="SECChildsub">
<Selectivity>4.0000%</Selectivity>
</Property>
<Property name="SECParRef">
<Selectivity>0.3774%</Selectivity>
</Property>
<Property name="SECRTFText">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SECResultTypeSectionDR">
<Selectivity>7.6923%</Selectivity>
</Property>
<Property name="SECText">
<Selectivity>0.3571%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="SEC_RTFText">
<Node>"RTF"</Node>
</Data>
<Data name="SEC_ResultTypeSection_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SEC_Text">
<Node>"REM"</Node>
</Data>
<Global>^OETR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OE_TextResult.TR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SEC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{OE_TextResult.TR_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SEC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SEC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SEC_RowId</SqlRowIdName>
<StreamLocation>^User.OETextResultSectionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
