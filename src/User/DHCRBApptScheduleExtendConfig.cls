Class User.DHCRBApptScheduleExtendConfig Extends %Persistent [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DHC_RBApptScheduleExtendConfig, StorageStrategy = Storage ]
{

Index RowIDBasedIDKeyIndex On ASQECChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ASQECASParRef As User.DHCRBApptSchedule [ Cardinality = parent, Inverse = ChildDHCRBApptScheduleExtendConfig ];

Property ASQECChildsub As %Float [ InitialExpression = {$i(^RBAS(+$s($d(initvalue):initvalue,1:%d(0)),"AQEC",0))}, SqlColumnNumber = 2, SqlFieldName = ASQEC_Childsub ];

Property ASQECTemplateConfig As User.DHCScheduleTemplateConfig [ SqlColumnNumber = 3, SqlFieldName = ASQEC_TemplateConfig ];

Property ASQECValue As %String [ SqlColumnNumber = 4, SqlFieldName = ASQEC_Value ];

Storage Storage
{
<SQLMap name="MasterMap">
<Data name="ASQEC_TemplateConfig">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ASQEC_Value">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^RBAS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_RBApptSchedule.AS_RES_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>DHC_RBApptSchedule.AS_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L4}</Expression>
<Field>ASQEC_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_RBApptSchedule.AS_RES_ParRef}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHC_RBApptSchedule.AS_Childsub}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"AQEC"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ASQEC_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ASQ_RowId</SqlRowIdName>
<StreamLocation>^User.DHCRBApptSc5CE5S</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
