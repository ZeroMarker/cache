Class User.DHCINReqMoveStatus Extends (%Persistent, User.Abstract) [ SqlRowIdName = M_RowId, SqlTableName = DHC_INReq_MoveStatus, StorageStrategy = SQLStorage ]
{

Property MINRQDR As User.INRequest [ Required, SqlColumnNumber = 2, SqlFieldName = M_INRQ_DR ];

Property MSeqNo As %Numeric [ SqlColumnNumber = 3, SqlComputeCode = {s {M_SeqNo} =$I(^DHCINRQMOVE(0,"SEQ",{M_INRQ_DR}) ) }, SqlComputed, SqlFieldName = M_SeqNo ];

Property MMoveStatus As %Library.String(DISPLAYLIST = ",Req Done,Audited By RecLoc,Audited By ExecuteLoc,RecLoc Audite No,ExecuteLoc Audite No,Init Refuse Req,Init Refuse ReqItm,Vendor Refuse Req,PurPlan Refuse ReqItm,Init Save,Init Done,Init Out,Init In Refused,Init In", MAXLEN = 14, TRUNCATE = 1, VALUELIST = ",RD,RA,EA,RAN,EAN,IRR,IRI,VR,PRI,IS,ID,IO,IIR,II") [ SqlColumnNumber = 4, SqlFieldName = M_MoveStatus ];

Property MSSUSRDR As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = M_SSUSR_DR ];

Property MDate As %Library.Date [ SqlColumnNumber = 6, SqlFieldName = M_Date ];

Property MTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = M_Time ];

Property MRemark As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = M_Remark ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCINRQMOVE)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="M_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="M_INRQ_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="M_MoveStatus">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="M_Remark">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="M_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="M_SeqNo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="M_Time">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCINRQMOVE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>M_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{M_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexReq">
<Global>^DHCINRQMOVE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>M_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INRQ"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{M_INRQ_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{M_SeqNo}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{M_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>M_RowId</SqlRowIdName>
<SqlRowIdProperty>M_RowId</SqlRowIdProperty>
<StreamLocation>^User.DHCINReqMoveStatusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCINRQMOVE)
	s oldI = +$g(^mdata("DHCINREQMOVESTATUS"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCINRQMOVE = maxI
	s ^mdata("DHCINREQMOVESTATUS") = maxI
}

}
