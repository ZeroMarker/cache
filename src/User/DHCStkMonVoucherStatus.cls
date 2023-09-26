Class User.DHCStkMonVoucherStatus Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = VCH_RowId, SqlTableName = DHC_StkMon_VoucherStatus, StorageStrategy = SQLStorage ]
{

/// VCH_SM_DR
Property VCHSMDR As User.DHCStkMon [ SqlColumnNumber = 2, SqlFieldName = VCH_SM_DR ];

/// VCH_VoucherType
Property VCHVoucherType As %Library.String [ SqlColumnNumber = 3, SqlFieldName = VCH_VoucherType ];

/// VCH_SerialNo
Property VCHSerialNo As %Library.Integer [ SqlColumnNumber = 4, SqlFieldName = VCH_SerialNo ];

/// VCH_Date
Property VCHDate As %Library.Date [ InitialExpression = {+$h}, SqlColumnNumber = 5, SqlFieldName = VCH_Date ];

/// VCH_Time
Property VCHTime As %Library.Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 6, SqlFieldName = VCH_Time ];

/// VCH_SSUSR_DR
Property VCHSSUSRDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = VCH_SSUSR_DR ];

/// VCH_Status
Property VCHStatus As %Library.String(DISPLAYLIST = ",Done,Sent,Accepted,Passed,Returned", MAXLEN = 8, SELECTIVITY = "25.0000%", VALUELIST = ",D,S,A,P,R") [ SqlColumnNumber = 8, SqlFieldName = VCH_Status ];

/// VCH_Remark
Property VCHRdemark As %Library.String [ SqlColumnNumber = 9, SqlFieldName = VCH_Remark ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCSMVchStatus(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="VCH_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="VCH_Remark">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="VCH_SM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="VCH_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="VCH_SerialNo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="VCH_Status">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="VCH_Time">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="VCH_VoucherType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCSMVchStatus</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>VCH_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{VCH_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexMon">
<Global>^DHCSMVchStatus</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VCH_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"Mon"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{VCH_SM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{VCH_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCStkMonVoucherStatusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
