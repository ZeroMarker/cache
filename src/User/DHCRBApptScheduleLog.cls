Class User.DHCRBApptScheduleLog Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = ASL_RowId, SqlRowIdPrivate, SqlTableName = DHC_RBApptScheduleLog, StorageStrategy = StorageSQL ]
{

Index RowIDBasedIDKeyIndex On ASLRowId [ IdKey, PrimaryKey, Unique ];

Property ASLASDate As %Date [ SqlColumnNumber = 3, SqlFieldName = ASL_ASDate ];

Property ASLConflictASDR As RBApptSchedule [ SqlColumnNumber = 5, SqlFieldName = ASL_ConflictAS_DR ];

Property ASLDate As %Date [ SqlColumnNumber = 6, SqlFieldName = ASL_Date ];

Property ASLRESDR As RBResource [ SqlColumnNumber = 2, SqlFieldName = ASL_RES_DR ];

Property ASLRowId As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ Required, SqlFieldName = ASL_RowId ];

Property ASLTRDR As DHCTimeRange [ SqlColumnNumber = 4, SqlFieldName = ASL_TR_DR ];

Property ASLTime As %Time [ SqlColumnNumber = 7, SqlFieldName = ASL_Time ];

Storage StorageSQL
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DateMaster">
<Data name="ASL_ASDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ASL_ConflictAS_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ASL_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ASL_Res_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ASL_TR_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ASL_Time">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCASLOG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ASL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ASL_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ASL_RowId</SqlRowIdName>
<StreamLocation>^User.DHCRBApptScheduleLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
