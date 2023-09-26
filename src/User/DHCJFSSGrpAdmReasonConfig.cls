Class User.DHCJFSSGrpAdmReasonConfig Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = GrpRea_RowId, SqlTableName = DHC_JFSSGrpAdmReasonConfig, StorageStrategy = SQLStorage ]
{

/// GrpRea_SSGrp_Dr
Property GrpReaSSGrpDr As User.SSGroup [ SqlColumnNumber = 2, SqlFieldName = GrpRea_SSGrp_Dr ];

/// GrpRea_AdmReason_Dr
Property GrpReaAdmReasonDr As User.PACAdmReason [ SqlColumnNumber = 3, SqlFieldName = GrpRea_AdmReason_Dr ];

/// GrpRea_Default
Property GrpReaDefault As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = GrpRea_Default ];

/// GrpRea_Comment1
Property GrpReaComment1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = GrpRea_Comment1 ];

/// GrpRea_Comment2
Property GrpComment2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = GrpRea_Comment2 ];

/// GrpRea_SSGrp_Dr
Property GrpReaHospDr As User.CTHospital [ SqlColumnNumber = 7, SqlFieldName = GrpRea_Hosp_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCJFSSGRPADMREASONCONFIG)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="GrpRea_AdmReason_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="GrpRea_Comment1">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="GrpRea_Comment2">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="GrpRea_Default">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="GrpRea_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="GrpRea_SSGrp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCJFSSGRPADMREASONCONFIG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>GrpRea_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{GrpRea_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexGrp">
<Global>^DHCJFSSGRPADMREASONCONFIG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>GrpRea_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SSGrp"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{GrpRea_SSGrp_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GrpRea_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCJFSSGrpAd8FES</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
