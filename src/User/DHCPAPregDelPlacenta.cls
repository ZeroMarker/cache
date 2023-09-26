Class User.DHCPAPregDelPlacenta Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PLAC_RowID, SqlTableName = DHC_PA_PregDelPlacenta, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On (PLACPregDr, PLACDelSub, PLACChildsub) [ IdKey, PrimaryKey, Unique ];

/// PLAC_Preg_Dr
Property PLACPregDr As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PLAC_Preg_Dr ];

/// PLAC_Del_Sub
Property PLACDelSub As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = PLAC_Del_Sub ];

/// PLAC_Childsub
Property PLACChildsub As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = PLAC_Childsub ];

/// PLAC_MembRuptureSite
Property PLACMembRuptureSite As %Library.String(DISPLAYLIST = ",Dully,Placenta,CordVessel", MAXLEN = 10, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",D,P,C") [ SqlColumnNumber = 5, SqlFieldName = PLAC_MembRuptureSite ];

/// PLAC_MachineTurn
Property PLACMachineTurn As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = PLAC_MachineTurn ];

/// PLAC_Size
Property PLACSize As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PLAC_Size ];

/// PLAC_LiquorAmout
Property PLACLiquorAmout As %Library.String(DISPLAYLIST = ",Little,Normal,Much", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",L,N,M") [ SqlColumnNumber = 8, SqlFieldName = PLAC_LiquorAmout ];

/// PLAC_LiquorAbnormal
Property PLACLiquorAbnormal As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = PLAC_LiquorAbnormal ];

/// PLAC_LiquorStatus_Dr
Property PLACLiquorStatusDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PLAC_LiquorStatus_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="PLAC_LiquorAbnormal">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>5</Piece>
</Data>
<Data name="PLAC_LiquorAmout">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>4</Piece>
</Data>
<Data name="PLAC_LiquorStatus_Dr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>6</Piece>
</Data>
<Data name="PLAC_MachineTurn">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>2</Piece>
</Data>
<Data name="PLAC_MembRuptureSite">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>1</Piece>
</Data>
<Data name="PLAC_Size">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>3</Piece>
</Data>
<Global>^PAPRG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PLAC_Preg_Dr</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PLAC_Del_Sub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>PLAC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PLAC_Preg_Dr}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PLAC_Del_Sub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"PLAC"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PLAC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPAPregDelPlacentaS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
