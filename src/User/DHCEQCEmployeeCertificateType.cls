Class User.DHCEQCEmployeeCertificateType Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_EQCEmployeeCertificateType, StorageStrategy = SQLStorage ]
{

/// ECT_EmployeeTypeDR
Property ECTEmployeeTypeDR As DHCEQCEmployeeType [ SqlColumnNumber = 2, SqlFieldName = ECT_EmployeeTypeDR ];

/// ECT_CertificateTypeDR
Property ECTCertificateTypeDR As DHCEQCCertificateType [ SqlColumnNumber = 3, SqlFieldName = ECT_CertificateTypeDR ];

/// ECT_Remark
Property ECTRemark As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = ECT_Remark ];

/// ECT_InvalidFlag
Property ECTInvalidFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = ECT_InvalidFlag ];

/// ECT_Hold1
Property ECTHold1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = ECT_Hold1 ];

/// ECT_Hold2
Property ECTHold2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = ECT_Hold2 ];

/// ECT_Hold3
Property ECTHold3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = ECT_Hold3 ];

/// ECT_Hold4
Property ECTHold4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = ECT_Hold4 ];

/// ECT_Hold5
Property ECTHold5 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = ECT_Hold5 ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCEmployeeCertificateType",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ECT_CertificateTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ECT_EmployeeTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ECT_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ECT_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ECT_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ECT_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ECT_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ECT_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ECT_Remark">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ECT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCEmployeeCertificateType"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{ECT_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquipType">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ECT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCEmployeeCertificateType"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ECT_EmployeeTypeDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{ECT_CertificateTypeDR}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ECT_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQCEmployAEDS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
