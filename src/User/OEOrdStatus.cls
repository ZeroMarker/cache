/// OE Ord Status(1605)
Class User.OEOrdStatus Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = OE_OrdStatus, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On STChildsub [ IdKey, PrimaryKey, Unique ];

/// OE_OrdItem Parent Reference
Relationship STParRef As OEOrdItem [ Cardinality = parent, Inverse = ChildOEOrdStatus, Required, SqlFieldName = ST_ParRef ];

/// Childsub
Property STChildsub As %Float [ InitialExpression = {$i(^OEORD($p(%d(0),"||"),"I",$p(%d(0),"||",2),"ST",0))}, SqlColumnNumber = 2, SqlFieldName = ST_Childsub ];

/// Date
Property STDate As %Date [ SqlColumnNumber = 3, SqlFieldName = ST_Date ];

/// Time
Property STTime As %Time [ SqlColumnNumber = 4, SqlFieldName = ST_Time ];

/// Des Ref Status
Property STStatusDR As OECOrderStatus [ SqlColumnNumber = 5, SqlFieldName = ST_Status_DR ];

/// Des Ref User
Property STUserDR As SSUser [ SqlColumnNumber = 6, SqlFieldName = ST_User_DR ];

/// Reason
Property STReason As %String(DISPLAYLIST = ",Discharge,Deceased,Leave", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",DIS,DEC,LEAVE") [ SqlColumnNumber = 7, SqlFieldName = ST_Reason ];

/// Text Status
Property STTextStatus As %String(COLLATION = "Exact", MAXLEN = 99, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = ST_TextStatus ];

/// Des Ref Status Change Reason
Property STReasonDR As OECAdminStatusChReason [ SqlColumnNumber = 9, SqlFieldName = ST_Reason_DR ];

Property STReasonComtent As %String [ SqlColumnNumber = 10, SqlFieldName = ST_ReasonComtent ];

Trigger OEOrdStatusafterinsert [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d insert^SSAUDIT(1605)
}

Trigger OEOrdStatusafterupdate [ Event = UPDATE, Order = 1, Time = AFTER ]
{
 d update^SSAUDIT(1605)
}

Trigger OEOrdStatusafterdelete [ Event = DELETE, Order = 1, Time = AFTER ]
{
 d delete^SSAUDIT(1605)
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ST_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ST_Reason">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ST_ReasonComtent">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ST_Reason_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ST_Status_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ST_TextStatus">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ST_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ST_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
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
<Field>ST_Childsub</Field>
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
<Expression>"ST"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ST_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OE_OrdItem.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>ST_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StatDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ST_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_OrdItem.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ST_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ST_RowId</SqlRowIdName>
<StreamLocation>^User.OEOrdStatusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
