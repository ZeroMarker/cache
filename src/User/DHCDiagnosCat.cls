Class User.DHCDiagnosCat Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlTableName = DHC_DiagnosCat, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DCRowid [ IdKey, PrimaryKey, Unique ];

Relationship ChildDHCDiagnosCatDetail As User.DHCDiagnosCatDetail [ Cardinality = children, Inverse = DCDDCParRef ];

Relationship ChildDHCDiagnosCatItem As User.DHCDiagnosCatItem [ Cardinality = children, Inverse = DCIDCParRef ];

/// DC_BillType_DR
Property DCBillTypeDR As User.PACAdmReason [ SqlColumnNumber = 4, SqlFieldName = DC_BillType_DR ];

/// DC_Code
Property DCCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DC_Code ];

/// DC_Desc
Property DCDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DC_Desc ];

/// DC_Duration_DR
Property DCDurationDR As User.PHCDuration [ SqlColumnNumber = 5, SqlFieldName = DC_Duration_DR ];

/// DC_Type
Property DCPAADMType As %Library.String(DISPLAYLIST = ",OutPatient,InPatinet,Emergency", MAXLEN = 10, SELECTIVITY = "25.0000%", VALUELIST = ",O,I,E") [ SqlColumnNumber = 3, SqlFieldName = DC_PAADMType ];

/// DHC_DiagnosCat Row ID
Property DCRowid As %Library.Numeric(SCALE = 0, SELECTIVITY = 1) [ InitialExpression = {$i(^mdata("DHCDIAGNOSCAT"))}, Required, SqlFieldName = DC_Rowid ];

/// DC_Type
Property DCType As %Library.String(DISPLAYLIST = ",Special,Cash,ChronicDis", MAXLEN = 10, SELECTIVITY = "25.0000%", VALUELIST = ",S,C,M") [ SqlColumnNumber = 6, SqlFieldName = DC_Type ];

/// DC_Hosp_DR
Property DCHospDR As User.CTHospital [ SqlColumnNumber = 8, SqlFieldName = DC_Hosp_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DC_BillType_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DC_Code">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DC_Duration_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DC_Hosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DC_PAADMType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DC_Type">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCDiagnosCat</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DC_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCDiagnosCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
