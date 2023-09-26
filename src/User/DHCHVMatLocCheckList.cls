Class User.DHCHVMatLocCheckList Extends (%Persistent, User.Abstract) [ SqlRowIdName = LC_RowId, SqlTableName = DHC_HVMat_LocCheckList, StorageStrategy = SqlStorage ]
{

/// HIS科室代码
Property LCHISLocCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = LC_HISLocCode ];

/// HIS科室名称
Property LCHISLocDesc As %String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = LC_HISLocDesc ];

/// 东华物资科室代码
Property LCCTLocCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = LC_CTLocCode ];

/// 东华物资科室名称
Property LCCTLocDesc As %String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = LC_CTLocDesc ];

/// 东华物资科室RowId
Property LCCTLOCDR As User.CTLoc [ SqlColumnNumber = 6, SqlFieldName = LC_CTLOC_DR ];

/// 东华医院对照rowid
Property LCHospCompDR As User.DHCHospComp [ SqlColumnNumber = 7, SqlFieldName = LC_HospComp_DR ];

/// 科室编号
Property LCSerialNumber As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = LC_SerialNumber ];

Storage SqlStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCHVMLL(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="LC_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="LC_CTLocCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LC_CTLocDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="LC_HISLocCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LC_HISLocDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LC_HospComp_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="LC_SerialNumber">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCHVMLL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{LC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCTLOC">
<Global>^DHCHVMLL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>LC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"CTLOC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{LC_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{LC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHisLocCode">
<Global>^DHCHVMLL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>LC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"HISLOCCODE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{LC_HISLocCode}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{LC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LC_RowId</SqlRowIdName>
<StreamLocation>^User.DHCHVMatLocCheckListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
