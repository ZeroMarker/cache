/// DHC_DocEmReg
Class User.DHCDocEmReg Extends (%Persistent, User.Abstract) [ Not Abstract, ClientDataType = HANDLE, DdlAllowed, Inheritance = right, Not ProcedureBlock, SoapBodyUse = literal, SqlRowIdName = RowID, Not SqlRowIdPrivate, SqlTableName = DHC_DocEmReg, StorageStrategy = SQLStorage ]
{

/// Des Ref to PAPMI
Property EMPAPMIDR As User.PAPatMas [ Required, SqlColumnNumber = 2, SqlFieldName = EM_PAPMI_DR ];

/// Des Ref to PAPMI
Property EMDHCCARDDR As User.DHCCardRef [ Required, SqlColumnNumber = 3, SqlFieldName = EM_DHCCARD_DR ];

/// ER_DateCreate
Property ERDateCreate As %Library.Date(FORMAT = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = ER_DateCreate ];

/// ER_TimeCreate
Property ERTimeCreate As %Library.Time [ Required, SqlColumnNumber = 5, SqlFieldName = ER_TimeCreate ];

/// ER_EndDate
Property EREndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = ER_EndDate ];

/// ER_EndTime
Property EREndTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = ER_EndTime ];

/// Des Ref SSUSR
Property ERCreateUserDR As SSUser [ SqlColumnNumber = 8, SqlFieldName = ER_CreateUserDR ];

/// EMPreview Status
Property EMPreviewStatus As %String(DISPLAYLIST = ",Inserted,Admitted", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",I,A") [ InitialExpression = "I", Required, SqlColumnNumber = 9, SqlFieldName = EM_PreviewStatus ];

/// Des Ref SSUSR
Property EMPreviewNurseDR As SSUser [ SqlColumnNumber = 10, SqlFieldName = EM_PreviewNurse_DR ];

Property EMLastUpdateUserDR As SSUser [ SqlColumnNumber = 11, SqlFieldName = EM_LastUpdateUser_DR ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DOCEMREG(0))</SqlIdExpression>
<SQLMap name="DataMasterDOCEMREG">
<Data name="EM_DHCCARD_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EM_LastUpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="EM_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EM_PreviewNurse_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="EM_PreviewStatus">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ER_CreateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ER_DateCreate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ER_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ER_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ER_TimeCreate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DOCEMREG</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"EM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexDatCard">
<Global>^DOCEMREGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ER_DateCreate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexPAPMI">
<Global>^DOCEMREGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAPMI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EM_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexPAPMIDate">
<Global>^DOCEMREGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAPMIDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ER_DateCreate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EM_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RowID</SqlRowIdName>
<StreamLocation>^User.DHCDocEmRegS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
