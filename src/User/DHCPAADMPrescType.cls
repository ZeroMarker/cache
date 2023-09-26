Class User.DHCPAADMPrescType Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AIL_Rowid, SqlTableName = DHC_PAADMPrescType, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// AIL_PAADMType
Property AILPAADMType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = AIL_PAADMType ];

/// AIL_BillType
Property AILBillType As User.PACAdmReason [ SqlColumnNumber = 3, SqlFieldName = AIL_BillType ];

/// AIL_PrescType
Property AILPrescType As %Library.String(COLLATION = "Exact", MAXLEN = 30, SELECTIVITY = "25.0000%", TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = AIL_PrescType ];

/// AIL_Default
Property AILDefault As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = AIL_Default ];

/// AIL_Default
Property AILHospDr As User.CTHospital [ SqlColumnNumber = 6, SqlFieldName = AIL_Hosp_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPAADMPrescType)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="AIL_BillType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AIL_Default">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AIL_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AIL_PAADMType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AIL_PrescType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCPAADMPrescType</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AIL_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{AIL_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPAADMType">
<Global>^DHCPAADMPrescType</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AIL_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PAADMType"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{AIL_PAADMType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AIL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPAADMPrescTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
