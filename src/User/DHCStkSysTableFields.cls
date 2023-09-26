Class User.DHCStkSysTableFields Extends (%Persistent, User.Abstract) [ SqlRowIdName = SSF_RowId, SqlTableName = DHC_StkSys_TableFields, StorageStrategy = SqlStorage ]
{

Property SSFTableName As %String [ SqlColumnNumber = 2, SqlFieldName = SSF_TableName ];

Property SSFFieldName As %String [ SqlColumnNumber = 3, SqlFieldName = SSF_FieldName ];

Property SSFColNumber As %String [ SqlColumnNumber = 4, SqlFieldName = SSF_ColNumber ];

Property SSFFieldDesc As %String [ SqlColumnNumber = 5, SqlFieldName = SSF_FieldDesc ];

Property SSFExits As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = SSF_Exits ];

Storage SqlStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$I(^DHCSSTabField(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SSF_ColNumber">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SSF_Exits">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SSF_FieldDesc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SSF_FieldName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SSF_TableName">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCSSTabField</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SSF_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{SSF_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTabField">
<Global>^DHCSSTabField</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SSF_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"TF"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{SSF_TableName}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{SSF_FieldName}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{SSF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SSF_RowId</SqlRowIdName>
<StreamLocation>^User.DHCStkSysTableFieldsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
