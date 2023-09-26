Class User.DHCMDTOpiTemp Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MT_RowID, SqlTableName = DHC_MDTOpiTemp, StorageStrategy = SQLStorage ]
{

/// MT_Title  模板标题
Property MTTitle As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MT_Title ];

/// MT_Text  模板内容
Property MTText As %Library.String(COLLATION = "Exact", MAXLEN = 9999, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MT_Text ];

/// MT_Type  指针类型
Property MTType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MT_Type ];

/// MT_Pointer  指针
Property MTPointer As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MT_Pointer ];

/// 集团化医院  MT_Hosp_Dr
Property MTHospDr As User.CTHospital [ SqlColumnNumber = 6, SqlFieldName = MT_Hosp_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCMDTOT)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MT_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MT_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MT_Text">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MT_Title">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MT_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCMDTOT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MT_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPointer">
<Global>^DHCMDTOT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"pointer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MT_Pointer}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMDTOpiTempS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
