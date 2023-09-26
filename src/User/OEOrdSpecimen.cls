/// Order Item Specimen(1313)
Class User.OEOrdSpecimen Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OE_OrdSpecimen, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On SPECChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildOEOrdSpecimenSites As OEOrdSpecimenSites [ Cardinality = children, Inverse = SITEParRef ];

/// OE_OrdItem Parent Reference
Relationship SPECParRef As OEOrdItem [ Cardinality = parent, Inverse = ChildOEOrdSpecimen, Required, SqlFieldName = SPEC_ParRef ];

/// Childsub
Property SPECChildsub As %Float [ InitialExpression = {$i(^OEORD($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"I",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"SPEC",0))}, SqlColumnNumber = 2, SqlFieldName = SPEC_Childsub ];

/// Code
Property SPECCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = SPEC_Code ];

/// Processed flag
Property SPECProcessed As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = SPEC_Processed ];

/// TubeFlag
Property SPECTubeFlag As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = SPEC_TubeFlag ];

/// Date
Property SPECDate As %Date [ SqlColumnNumber = 6, SqlFieldName = SPEC_Date ];

/// Time
Property SPECTime As %Time [ SqlColumnNumber = 7, SqlFieldName = SPEC_Time ];

/// SPEC_Ext_RowID
Property SPECExtRowID As %String(COLLATION = "Exact", MAXLEN = 99, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = SPEC_Ext_RowID ];

/// ReasonNotCollected
Property SPECReasonNotCollected As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = SPEC_ReasonNotCollected, SqlListType = SUBNODE ];

/// Update Date
Property SPECUpdateDate As %Date [ SqlColumnNumber = 10, SqlFieldName = SPEC_UpdateDate ];

/// Update Time
Property SPECUpdateTime As %Time [ SqlColumnNumber = 11, SqlFieldName = SPEC_UpdateTime ];

/// Des Ref UpdateUser
Property SPECUpdateUserDR As SSUser [ SqlColumnNumber = 12, SqlFieldName = SPEC_UpdateUser_DR ];

/// Des Ref UpdateHospital
Property SPECUpdateHospitalDR As CTHospital [ SqlColumnNumber = 13, SqlFieldName = SPEC_UpdateHospital_DR ];

/// Container
Property SPECContainer As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = SPEC_Container ];

/// Vol_Required
Property SPECVolRequired As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = SPEC_Vol_Required ];

/// Vol_Collected
Property SPECVolCollected As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = SPEC_Vol_Collected ];

/// DisplayFlag
Property SPECDisplayFlag As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = SPEC_DisplayFlag ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OEOrdSpecimen).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdSpecimen","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OEOrdSpecimen).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdSpecimen","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OEOrdSpecimen).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdSpecimen","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OEOrdSpecimen).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdSpecimen","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OEOrdSpecimen).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdSpecimen","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="SPEC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SPEC_Container">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SPEC_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SPEC_DisplayFlag">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SPEC_Ext_RowID">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SPEC_Processed">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SPEC_ReasonNotCollected">
<Node>"RNC"</Node>
</Data>
<Data name="SPEC_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SPEC_TubeFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SPEC_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SPEC_UpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SPEC_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SPEC_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SPEC_Vol_Collected">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SPEC_Vol_Required">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^OEORD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>OE_OrdItem.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>SPEC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_OrdItem.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"SPEC"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SPEC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SPEC_RowId</SqlRowIdName>
<StreamLocation>^User.OEOrdSpecimenS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
