Class User.DHCBillPreIPAdmTransLog Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PTL_RowID, SqlTableName = DHC_BillPreIPAdmTransLog, StorageStrategy = SQLStorage ]
{

/// PTL_ADM_DR
Property PTLADMDR As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = PTL_ADM_DR ];

/// PTL_AdmType
Property PTLAdmType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PTL_AdmType ];

/// PTL_User_DR 
Property PTLUserDR As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = PTL_User_DR ];

/// PTL_Date
Property PTLDate As %Library.Date [ SqlColumnNumber = 5, SqlFieldName = PTL_Date ];

/// PTL_Time
Property PTLTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = PTL_Time ];

/// PTL_AuditUser_DR
Property PTLAuditUserDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = PTL_AuditUser_DR ];

/// PTL_AuditDate
Property PTLAuditDate As %Library.Date [ SqlColumnNumber = 8, SqlFieldName = PTL_AuditDate ];

/// PTL_AuditTime
Property PTLAuditTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = PTL_AuditTime ];

/// PTL_AuditFlag
Property PTLAuditFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ Required, SqlColumnNumber = 10, SqlFieldName = PTL_AuditFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCBillPreIPAdmTransLog)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PTL_ADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PTL_AdmType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PTL_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PTL_AuditFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PTL_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PTL_AuditUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PTL_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PTL_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PTL_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCBillPreIPAdmTransLog</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PTL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PTL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdmDR">
<Global>^DHCBillPreIPAdmTransLogi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PTL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADMDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PTL_ADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PTL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCBillPreIPAdmTransLogi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PTL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PTL_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PTL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCBillPreIPAdmTransLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
