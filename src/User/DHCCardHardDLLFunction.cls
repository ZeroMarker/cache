Class User.DHCCardHardDLLFunction Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CDF_RowID, SqlTableName = DHC_CardHardDLLFunction, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On CDFSub [ IdKey, PrimaryKey, Unique ];

/// DHC_CardHardComManager Parent Reference
Relationship CDFCCMParRef As User.DHCCardHardComManager [ Cardinality = parent, Inverse = ChildDHCCardHardDLLFunction, Required, SqlFieldName = CDF_CCM_ParRef ];

/// CDF_Sub
Property CDFSub As %Library.Float [ InitialExpression = {$i(^DHCCARDHARDCOM("MANAGER",+$p($s($d(initvalue):initvalue,1:+%d(0)),$c(1)),"FUN",0))}, SqlColumnNumber = 2, SqlFieldName = CDF_Sub ];

/// CDF_DLLFunctionName
Property CDFDLLFunctionName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CDF_DLLFunctionName ];

/// CDF_DLLInPara1
Property CDFDLLInPara1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = CDF_DLLInPara1 ];

/// CDF_DLLInPara2
Property CDFDLLInPara2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CDF_DLLInPara2 ];

/// CDF_DLLInPara3
Property CDFDLLInPara3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = CDF_DLLInPara3 ];

/// CDF_DLLFunctionType
Property CDFDLLFunctionType As %Library.String(DISPLAYLIST = ",Read,Write,Print", MAXLEN = 5, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",R,W,P") [ SqlColumnNumber = 7, SqlFieldName = CDF_DLLFunctionType ];

/// CDF_Note1
Property CDFNote1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = CDF_Note1 ];

/// CDF_Note2
Property CDFNote2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = CDF_Note2 ];

/// CDF_Note3
Property CDFNote3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = CDF_Note3 ];

/// CDF_Note4
Property CDFNote4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = CDF_Note4 ];

/// CDF_Note5
Property CDFNote5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = CDF_Note5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="CDF_DLLFunctionName">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CDF_DLLFunctionType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CDF_DLLInPara1">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CDF_DLLInPara2">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CDF_DLLInPara3">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CDF_Note1">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CDF_Note2">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CDF_Note3">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CDF_Note4">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CDF_Note5">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCCARDHARDCOM</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHC_CardHardComManager.CCM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>CDF_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"MANAGER"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{DHC_CardHardComManager.CCM_RowID}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"FUN"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CDF_Sub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCCardHardDLLFunctionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
