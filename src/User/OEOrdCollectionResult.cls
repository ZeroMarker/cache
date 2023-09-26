/// OE Ord Collection result(1710)
Class User.OEOrdCollectionResult Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OE_OrdCollectionResult, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 6;

Index RowIDBasedIDKeyIndex On DELChildsub [ IdKey, PrimaryKey, Unique ];

/// OE_OrdItem Parent Reference
Relationship DELParRef As OEOrdItem [ Cardinality = parent, Inverse = ChildOEOrdCollectionResult, Required, SqlFieldName = DEL_ParRef ];

/// Childsub
Property DELChildsub As %Float [ InitialExpression = {$i(^OEORD($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"I",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"DEL",0))}, SqlColumnNumber = 2, SqlFieldName = DEL_Childsub ];

/// Delivered To
Property DELDeliveredTo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DEL_DeliveredTo ];

/// Des Ref Method
Property DELMethodDR As OECResDeliveryMethod [ SqlColumnNumber = 4, SqlFieldName = DEL_Method_DR ];

/// User
Property DELUser As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DEL_User ];

/// Date
Property DELDate As %Date [ SqlColumnNumber = 6, SqlFieldName = DEL_Date ];

/// Time
Property DELTime As %Time [ SqlColumnNumber = 7, SqlFieldName = DEL_Time ];

/// Des Ref CTLOC
Property DELCTLOCDR As CTLoc [ SqlColumnNumber = 8, SqlFieldName = DEL_CTLOC_DR ];

/// Des Ref LastUpdateUser
Property DELLastUpdateUserDR As SSUser [ SqlColumnNumber = 9, SqlFieldName = DEL_LastUpdateUser_DR ];

/// Des Ref LastUpdateHospital
Property DELLastUpdateHospitalDR As CTHospital [ SqlColumnNumber = 10, SqlFieldName = DEL_LastUpdateHospital_DR ];

/// LastUpdateDate
Property DELLastUpdateDate As %Date [ SqlColumnNumber = 11, SqlFieldName = DEL_LastUpdateDate ];

/// LastUpdateTime
Property DELLastUpdateTime As %Time [ SqlColumnNumber = 12, SqlFieldName = DEL_LastUpdateTime ];

/// Comments
Property DELComments As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = DEL_Comments, SqlListType = SUBNODE ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OEOrdCollectionResult).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdCollectionResult","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OEOrdCollectionResult).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdCollectionResult","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OEOrdCollectionResult).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdCollectionResult","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OEOrdCollectionResult).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdCollectionResult","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OEOrdCollectionResult).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdCollectionResult","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>6</ExtentSize>
<Property name="DELCTLOCDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="DELChildsub">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="DELComments">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="DELDate">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="DELDeliveredTo">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="DELLastUpdateDate">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="DELLastUpdateHospitalDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="DELLastUpdateTime">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="DELLastUpdateUserDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="DELMethodDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="DELParRef">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="DELTime">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="DELUser">
<Selectivity>50.0000%</Selectivity>
</Property>
<SQLMap name="Datamaster">
<Data name="DEL_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DEL_Comments">
<Node>"RMK"</Node>
</Data>
<Data name="DEL_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DEL_DeliveredTo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DEL_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DEL_LastUpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DEL_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DEL_LastUpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DEL_Method_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DEL_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DEL_User">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
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
<Field>DEL_Childsub</Field>
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
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DEL_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DEL_RowId</SqlRowIdName>
<StreamLocation>^User.OEOrdCollectionResultS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
