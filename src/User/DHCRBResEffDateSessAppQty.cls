Class User.DHCRBResEffDateSessAppQty Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlTableName = DHC_RBResEffDateSessAppQty, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On (AQResDR, AQDateChildsub, AQSessChildsub, AQChildsub) [ IdKey, PrimaryKey, Unique ];

Property AQChildsub As %Numeric [ InitialExpression = {$i(^RB("RES",%d(2),"DATE",%d(3),"SESS",%d(4),"AQ",0))}, SqlColumnNumber = 5, SqlFieldName = AQ_Childsub ];

Property AQDateChildsub As %Numeric [ Required, SqlColumnNumber = 3, SqlFieldName = AQ_DateChildsub ];

Property AQMethodDR As User.RBCAppointMethod [ Required, SqlColumnNumber = 6, SqlFieldName = AQ_Method_DR ];

Property AQParRef As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlComputeCode = { s {AQ_ParRef}=({AQ_Res_DR}_"||"_{AQ_DateChildsub}_"||"_{AQ_SessChildsub})
}, SqlComputed, SqlFieldName = AQ_ParRef, Transient ];

Property AQQty As %Float [ SqlColumnNumber = 7, SqlFieldName = AQ_Qty ];

Property AQResDR As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = AQ_Res_DR ];

Property AQSessChildsub As %Numeric [ Required, SqlColumnNumber = 4, SqlFieldName = AQ_SessChildsub ];

Property AQStartNum As %Float [ SqlColumnNumber = 9, SqlFieldName = AQ_StartNum ];

Property AQMaxQty As %Float [ SqlColumnNumber = 10, SqlFieldName = AQ_MaxQty ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMap">
<Data name="AQ_MaxQty">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AQ_Method_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AQ_Qty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AQ_StartNum">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^RB</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>AQ_Res_DR</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>AQ_DateChildsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>AQ_SessChildsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L8}</Expression>
<Field>AQ_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{AQ_Res_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AQ_DateChildsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="5">
<Expression>"SESS"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AQ_SessChildsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>"AQ"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{AQ_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>AQ_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCRBResEffD919S</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
