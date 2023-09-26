Class User.DHCPrescriptType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PT_Rowid, SqlTableName = DHC_PrescriptType, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PT_Code
Property PTCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PT_Code ];

/// PT_Description
Property PTDescription As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PT_Description ];

/// PT_AllowFlag
Property PTAllowFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PT_AllowFlag ];

/// PT_WarnFlag
Property PTWarnFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PT_WarnFlag ];

/// PT_LimitSum
Property PTLimitSum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PT_LimitSum ];

/// LimitCount
Property PTLimitCount As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PT_LimitCount ];

/// LimitQty
Property PTLimitQty As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PT_LimitQty ];

/// LimitType
Property PTLimitType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PT_LimitType ];

/// PT_PatShareAllFlag
Property PTBillType As User.PACAdmReason [ SqlColumnNumber = 10, SqlFieldName = PT_BillType ];

/// PT_IsSpecDis
Property PTIsSpecDis As %Library.String(COLLATION = "Exact", MAXLEN = 30, SELECTIVITY = "33.3333%", TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PT_IsSpecDis ];

/// PT_HospDr
Property PTHospDr As User.CTHospital [ SqlColumnNumber = 12, SqlFieldName = PT_Hosp_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPrescriptType)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PT_AllowFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PT_BillType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PT_Description">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PT_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PT_IsSpecDis">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PT_LimitCount">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PT_LimitQty">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PT_LimitSum">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PT_LimitType">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PT_WarnFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPrescriptType</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PT_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPrescriptTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
