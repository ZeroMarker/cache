Class User.DHCRBResEffDateSessExtendConfig Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlTableName = DHC_RBResEffDateSessExtendConfig, StorageStrategy = Storage ]
{

Index RowIDBasedIDKeyIndex On (AQECResDR, AQECDateChildsub, AQECSessChildsub, AQECChildsub) [ IdKey, PrimaryKey, Unique ];

Property AQECChildsub As %Numeric [ InitialExpression = {$i(^RB("RES",$p($s($d(initvalue):initvalue,1:%d(0)),"||",1),"DATE",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"SESS",$p($s($d(initvalue):initvalue,1:%d(0)),"||",3),"AQEC",0))}, SqlColumnNumber = 5, SqlFieldName = AQEC_Childsub ];

Property AQECDateChildsub As %Numeric [ Required, SqlColumnNumber = 3, SqlFieldName = AQEC_DateChildsub ];

Property AQECTemplateConfig As User.DHCScheduleTemplateConfig [ SqlColumnNumber = 6, SqlFieldName = AQEC_TemplateConfig ];

Property AQECParRef As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlComputeCode = { s {AQEC_ParRef}=({AQEC_Res_DR}_"||"_{AQEC_DateChildsub}_"||"_{AQEC_SessChildsub})
}, SqlComputed, SqlFieldName = AQEC_ParRef, Transient ];

Property AQECValue As %String [ SqlColumnNumber = 7, SqlFieldName = AQEC_Value ];

Property AQECResDR As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = AQEC_Res_DR ];

Property AQECSessChildsub As %Numeric [ Required, SqlColumnNumber = 4, SqlFieldName = AQEC_SessChildsub ];

Storage Storage
{
<SQLMap name="MasterMap">
<Data name="AQEC_TemplateConfig">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AQEC_Value">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^RB</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>AQEC_Res_DR</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>AQEC_DateChildsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>AQEC_SessChildsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L8}</Expression>
<Field>AQEC_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{AQEC_Res_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AQEC_DateChildsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"SESS"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AQEC_SessChildsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>"AQEC"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{AQEC_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>AQEC_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCRBResEff6A7DS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
