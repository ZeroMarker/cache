Class User.DHCCHNPHFrequence Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CPF_Rowid, SqlTableName = DHC_CHNPHFrequence, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CPF_Frequence_DR
Property CPFFrequenceDR As User.PHCFreq [ SqlColumnNumber = 2, SqlFieldName = CPF_Frequence_DR ];

/// CPF_Factor
Property CPFFactor As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CPF_Factor ];

/// CPF_Default
Property CPFDefault As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = CPF_Default ];

Property CPFHospDR As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = CPF_Hosp_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCHNPHFre)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CPF_Default">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CPF_Factor">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CPF_Frequence_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CPF_Hosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCCHNPHFre</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CPF_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CPF_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCCHNPHFrequenceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
