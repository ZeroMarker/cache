Class User.DHCINReqItmMoveStatus Extends (%Persistent, User.Abstract) [ SqlRowIdName = IM_RowId, SqlTableName = DHC_INReqItm_MoveStatus, StorageStrategy = SqlStorage ]
{

Property IMINRQIDR As User.INReqItm [ Required, SqlColumnNumber = 2, SqlFieldName = IM_INRQI_DR ];

Property IMSeqNo As %Numeric [ SqlColumnNumber = 3, SqlComputeCode = {s {IM_SeqNo} =$I(^DHCINRQIMOVE(0,"SEQ",{IM_INRQI_DR}) ) }, SqlComputed, SqlFieldName = IM_SeqNo ];

Property IMMoveStatus As %Library.String(DISPLAYLIST = ",Req Done,Audited By RecLoc,Audited By ExecuteLoc,Init Done,Init Out,Init In Refused,Init In,PurPlan Done,PurPlan Audit,PurPlan Refused,IMP Done,IMP Audit,PO Done,PO Audit,PO Cancel", MAXLEN = 14, TRUNCATE = 1, VALUELIST = ",RD,RA,EA,ID,IO,IIR,II,PD,PA,PR,IMD,IMA,POD,POA,POC") [ SqlColumnNumber = 4, SqlFieldName = IM_MoveStatus ];

Property IMSSUSRDR As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = IM_SSUSR_DR ];

Property IMDate As %Library.Date [ SqlColumnNumber = 6, SqlFieldName = IM_Date ];

Property IMTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = IM_Time ];

Property IMRemark As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = IM_Remark ];

Property IMType As %String(COLLATION = "Exact", MAXLEN = 6, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = IM_Type ];

Property IMPointer As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = IM_Pointer ];

Storage SqlStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCINRQIMOVE(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="IM_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IM_INRQI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IM_MoveStatus">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IM_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IM_Remark">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IM_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IM_SeqNo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IM_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IM_Type">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCINRQIMOVE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{IM_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexINRQI">
<Global>^DHCINRQIMOVE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RQI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IM_INRQI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINRQIMoveStatus">
<Global>^DHCINRQIMOVE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INRQIMS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IM_INRQI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IM_MoveStatus}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPointerMoveStatus">
<Global>^DHCINRQIMOVE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PointerMoveStatus"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IM_Pointer}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IM_MoveStatus}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypePointer">
<Global>^DHCINRQIMOVE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypePointer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IM_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IM_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>IM_RowId</SqlRowIdName>
<StreamLocation>^User.DHCINReqItmMoveStatusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
