Class User.DHCINPOItmExpdLog Extends (%Persistent, User.Abstract) [ SqlTableName = DHC_INPOItmExpdLog, StorageStrategy = SqlStorage ]
{

Property LOGINPOIDR As User.INPOItm [ SqlColumnNumber = 2, SqlFieldName = LOG_INPOI_DR ];

Property LOGType As %String(DISPLAYLIST = ",SMS,Purch PlatForm,Other", MAXLEN = 6, SELECTIVITY = "25.0000%", VALUELIST = ",S,P,O") [ SqlColumnNumber = 3, SqlFieldName = LOG_Type ];

Property LOGDate As %Date [ SqlColumnNumber = 4, SqlFieldName = LOG_Date ];

Property LOGTime As %Date [ SqlColumnNumber = 5, SqlFieldName = LOG_Time ];

Property LOGSSUSRDR As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = LOG_SSUSR_DR ];

Property LOGMSG As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = LOG_MSG ];

Storage SqlStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPoItmExpdLog(0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="LOG_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LOG_INPOI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LOG_MSG">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="LOG_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="LOG_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="LOG_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPoItmExpdLog</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LOG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{LOG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexINPOI">
<Global>^DHCPoItmExpdLog</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>LOG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INPOI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{LOG_INPOI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{LOG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LOG_RowId</SqlRowIdName>
<StreamLocation>^User.DHCINPOItmExpdLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
