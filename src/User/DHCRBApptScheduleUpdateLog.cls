Class User.DHCRBApptScheduleUpdateLog Extends %Library.Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = ASUL_RowId, SqlTableName = DHC_RBApptScheduleUpdateLog, StorageStrategy = SQLStorage ]
{

/// ASULRBASDR 
Property ASULRBASDR As %Library.String [ SqlColumnNumber = 2, SqlFieldName = ASUL_RBAS_DR ];

/// ASULUpdateDate  修改日期
Property ASULUpdateDate As %Library.Date [ SqlColumnNumber = 3, SqlFieldName = ASUL_UpdateDate ];

/// ASULUpdateTime 修改时间
Property ASULUpdateTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = ASUL_UpdateTime ];

/// ASLUpdateUser 修改操作人
Property ASLUpdateUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = ASL_UpdateUser ];

/// ASULType 修改类型  
Property ASULType As %Library.String(DISPLAYLIST = ",Add Schudule,Stop Schudule,Replace Schudule,Update OtherInfo,Part Stop Schudule,Cancel Stop Schudule", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",A,S,R,U,PS,CS") [ SqlColumnNumber = 6, SqlFieldName = ASUL_Type ];

/// ASULNotes  修改内容
Property ASULNotes As %Library.String(MAXLEN = 5000) [ SqlColumnNumber = 7, SqlFieldName = ASUL_Notes ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCASULOG(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ASL_UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ASUL_Notes">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ASUL_RBAS_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ASUL_Type">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ASUL_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ASUL_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCASULOG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ASUL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ASUL_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexRBApptSchedule">
<Global>^DHCASULOGi</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>ASUL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"RBApptSchedule"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ASUL_RBAS_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ASUL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUpdateDate">
<Global>^DHCASULOGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>ASUL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"UpdateDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ASUL_UpdateDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ASUL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ASUL_RowId</SqlRowIdName>
<StreamLocation>^User.DHCRBApptSch9AAS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
