Class User.DHCBillTypeInsurEPType Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlTableName = DHC_BillTypeInsurEPType, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On (BIBillTypeParRef, BIChildsub) [ IdKey, PrimaryKey, Unique ];

Property BIBillTypeParRef As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = BI_BillType_ParRef ];

Property BIChildsub As %Float [ InitialExpression = {$i(^PAC("ADMREA",$s($d(p1):p1,1:%d(2)),"INSUR",0))}, SqlColumnNumber = 3, SqlFieldName = BI_Childsub ];

Property BIDefault As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 6, SqlFieldName = BI_Default ];

Property BIEpisodeType As %String(DISPLAYLIST = ",In Patient,Out Patient,Emergency,New Born,Health Promotion", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",I,O,E,N,H") [ SqlColumnNumber = 4, SqlFieldName = BI_EpisodeType ];

Property BIInsurEPTypeDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = BI_InsurEPType_DR ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Master">
<Data name="BI_Default">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BI_EpisodeType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BI_InsurEPType_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>BI_BillType_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>BI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ADMREA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BI_BillType_ParRef}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"INSUR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BI_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>BI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCBillTypeInsurEPTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
