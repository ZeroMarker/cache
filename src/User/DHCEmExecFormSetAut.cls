Class User.DHCEmExecFormSetAut Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = FSA_RowID, SqlTableName = DHC_EmExecFormSetAut, StorageStrategy = SQLStorage ]
{

/// 安全组指针 FSA_Group_Dr
Property FSAGroupDr As User.SSGroup [ SqlColumnNumber = 2, SqlFieldName = FSA_Group_Dr ];

/// 指针串 FSA_Poniter	
Property FSAPoniter As %String [ SqlColumnNumber = 3, SqlFieldName = FSA_Poniter ];

/// 默认执行单  FSA_DefExecForm_Dr
Property FSADefExecFormDr As User.DHCEmExecFormSet [ SqlColumnNumber = 4, SqlFieldName = FSA_DefExecForm_Dr ];

/// 医院ID  FSA_Hosp_Dr
Property FSAHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = FSA_Hosp_Dr ];

/// 科室指针 FSA_Loc_Dr
Property FSALocDr As User.SSGroup [ SqlColumnNumber = 6, SqlFieldName = FSA_Loc_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCEMEXECFORMSETAUT)</SqlIdExpression>
<SQLMap name="IndexGroup">
<Global>^DHCEMEFSAA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>FSA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IndexGroup"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{FSA_Group_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{FSA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCEMEFSAA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>FSA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IndexLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{FSA_Loc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{FSA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="FSA_DefExecForm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="FSA_Group_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FSA_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="FSA_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="FSA_Poniter">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEMEFSAA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>FSA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{FSA_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEmExecFormSetAutS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
