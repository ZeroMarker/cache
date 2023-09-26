Class User.DHCCardStatusChange Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CSC_RowID, SqlTableName = DHC_CardStatusChange, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On CSCSub [ IdKey, PrimaryKey, Unique ];

/// DHC_CardRef Parent Reference
Relationship CSCCFParRef As User.DHCCardRef [ Cardinality = parent, Inverse = ChildDHCCardStatusChange, Required, SqlFieldName = CSC_CF_ParRef ];

/// CSC_Sub
Property CSCSub As %Library.Float [ InitialExpression = {$i(^DHCCARD("CF",$p($s($d(initvalue):initvalue,1:+%d(0)),$c(1)),"CSC",0))}, SqlColumnNumber = 2, SqlFieldName = CSC_Sub ];

/// CSC_Date
Property CSCDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = CSC_Date ];

/// CSC_Time
Property CSCTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = CSC_Time ];

///  CSC_CurStatus
Property CSCCurStatus As %Library.String(DISPLAYLIST = ",Normal,Suspend,Reclaim,Depose,Exchange,ReNew,ExchangeToDepose,SuspendToDepose,UnActivated", MAXLEN = 7, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",N,S,R,D,E,RN,ETD,STD,UA") [ SqlColumnNumber = 5, SqlFieldName = CSC_CurStatus ];

/// CSC_User_DR
Property CSCUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = CSC_User_DR ];

/// CSC_ComputerIP
Property CSCComputerIP As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = CSC_ComputerIP ];

/// CSC_Note1
Property CSCNote1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = CSC_Note1 ];

/// CSC_Note2
Property CSCNote2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = CSC_Note2 ];

/// CSC_Note3
Property CSCNote3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = CSC_Note3 ];

/// CSC_Note4
Property CSCNote4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = CSC_Note4 ];

/// CSC_Note5
Property CSCNote5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = CSC_Note5 ];

/// CSC_RLName
Property CSCRLName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = CSC_RLName ];

/// CSC_RLCredNo
Property CSCRLCredNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = CSC_RLCredNo ];

/// CSC_RLAddress
Property CSCRLAddress As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = CSC_RLAddress ];

/// CSC_RLPhoneNo
Property CSCRLPhoneNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = CSC_RLPhoneNo ];

/// CSC_RLProof
Property CSCRLProof As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = CSC_RLProof ];

/// CSC_RLRemark
Property CSCRLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = CSC_RLRemark ];

/// CSC_CredType
Property CSCCredType As User.DHCCredType [ SqlColumnNumber = 19, SqlFieldName = CSC_CredType ];

/// CSC_CredType
Property CSCHospDR As User.CTHospital [ SqlColumnNumber = 20, SqlFieldName = CSC_Hosp_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="CSC_ComputerIP">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CSC_CredType">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="CSC_CurStatus">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CSC_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CSC_Hosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="CSC_Note1">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CSC_Note2">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CSC_Note3">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CSC_Note4">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CSC_Note5">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CSC_RLAddress">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CSC_RLCredNo">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CSC_RLName">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CSC_RLPhoneNo">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CSC_RLProof">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CSC_RLRemark">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CSC_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CSC_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCCARD</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHC_CardRef.CF_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>CSC_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"CF"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{DHC_CardRef.CF_RowID}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"CSC"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CSC_Sub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCSCDate">
<Global>^DHCCARDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_CardRef.CF_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>CSC_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"CF"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"CSDate"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CSC_Date}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DHC_CardRef.CF_RowID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>"CSC"</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{CSC_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCCardStatusChangeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
