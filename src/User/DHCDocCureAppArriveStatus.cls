Class User.DHCDocCureAppArriveStatus Extends %Persistent [ SqlRowIdName = DCAAS_RowID, SqlTableName = DHC_DocCureAppArriveStatus, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 1000000;

Index RowIDBasedIDKeyIndex On (DCAASParRef, DCAASChildSub) [ IdKey, PrimaryKey, Unique ];

/// AS_RES_ParRef
Property DCAASParRef As User.DHCDocCureAppArrive [ Required, SqlColumnNumber = 2, SqlFieldName = DCAAS_ParRef ];

/// AS_Childsub
Property DCAASChildSub As %Float(MINVAL = 1) [ InitialExpression = {$i(^DHCDocCureAASTAT(+$s($d(initvalue):initvalue,1:%d(2))))}, Required, SqlColumnNumber = 3, SqlFieldName = DCAAS_ChildSub ];

/// QS_Date
Property DCAASDate As %Library.Date [ SqlColumnNumber = 4, SqlFieldName = DCAAS_Date ];

/// QS_Time
Property DCAASTime As %Time [ SqlColumnNumber = 5, SqlFieldName = DCAAS_Time ];

Property DCAASStatus As %Library.String(DISPLAYLIST = ",Inserted,Admitted,Cancelled", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",I,A,C") [ SqlColumnNumber = 6, SqlFieldName = DCAAS_Status ];

Property DCAASUpUserID As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = DCAAS_UpUserID ];

Storage Default
{
<Data name="DHCDocCureAppArriveStatusDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DCAASDate</Value>
</Value>
<Value name="3">
<Value>DCAASTime</Value>
</Value>
<Value name="4">
<Value>DCAASStatus</Value>
</Value>
<Value name="5">
<Value>DCAASUpUserID</Value>
</Value>
</Data>
<DataLocation>^User.DHCDocCureA369DD</DataLocation>
<DefaultData>DHCDocCureAppArriveStatusDefaultData</DefaultData>
<IdLocation>^User.DHCDocCureA369DD</IdLocation>
<IndexLocation>^User.DHCDocCureA369DI</IndexLocation>
<StreamLocation>^User.DHCDocCureA369DS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

Storage SQLStorage
{
<ExtentSize>1000000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DCAAS_ChildSub">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DCAAS_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DCAAS_Status">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DCAAS_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DCAAS_UpUserID">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCDocCureAASTAT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DCAAS_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>DCAAS_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DCAAS_ParRef}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DCAAS_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCDocCureAASTATi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DCAAS_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>DCAAS_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DCAAS_Date}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCAAS_ParRef}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCAAS_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCDocCureAASTATi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DCAAS_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>DCAAS_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"STAT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DCAAS_Status}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCAAS_ParRef}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCAAS_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDocCureAASTAT</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
