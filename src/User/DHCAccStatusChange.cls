Class User.DHCAccStatusChange Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AccSC_RowID, SqlTableName = DHC_AccStatusChange, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On AccSCSub [ IdKey, PrimaryKey, Unique ];

/// DHC_AccManager Parent Reference
Relationship AccSCParRef As User.DHCAccManager [ Cardinality = parent, Inverse = ChildDHCAccStatusChange, Required, SqlFieldName = AccSC_ParRef ];

/// AccSC_Sub
Property AccSCSub As %Library.Float [ InitialExpression = {$i(^DHCACD("AccM",$p($s($d(initvalue):initvalue,1:+%d(0)),$c(1)),"SC",0))}, SqlColumnNumber = 2, SqlFieldName = AccSC_Sub ];

/// AccSC_OValue
Property AccSCOValue As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = AccSC_OValue ];

/// AccSC_NValue
Property AccSCNValue As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = AccSC_NValue ];

/// AccSC_Left
Property AccSCLeft As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = AccSC_Left ];

///  AccSC_OperDate
Property AccSCOperDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = AccSC_OperDate ];

/// AccSC_OperTime
Property AccSCOperTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = AccSC_OperTime ];

/// AccSC_User_DR
Property AccSCUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = AccSC_User_DR ];

/// AccSC_Note
Property AccSCNote As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = AccSC_Note ];

/// AccSC_Note1
Property AccSCNote1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = AccSC_Note1 ];

/// AccSC_Note2
Property AccSCNote2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = AccSC_Note2 ];

/// AccSC_Note3
Property AccSCNote3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = AccSC_Note3 ];

/// AccSC_Note4
Property AccSCNote4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = AccSC_Note4 ];

/// AccSC_RLName
Property AccSCRLName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = AccSC_RLName ];

/// AccSC_RLCredNo
Property AccSCRLCredNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = AccSC_RLCredNo ];

/// AccSC_RLAddress
Property AccSCRLAddress As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = AccSC_RLAddress ];

/// AccSC_RLPhoneNo
Property AccSCRLPhoneNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = AccSC_RLPhoneNo ];

/// AccSC_RLProof
Property AccSCRLProof As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = AccSC_RLProof ];

/// AccSC_RLRemark
Property AccSCRLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = AccSC_RLRemark ];

/// AccSC_CredType
Property AccSCCredType As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = AccSC_CredType ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="AccSC_CredType">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="AccSC_Left">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AccSC_NValue">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AccSC_Note">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AccSC_Note1">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AccSC_Note2">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AccSC_Note3">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AccSC_Note4">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AccSC_OValue">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AccSC_OperDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AccSC_OperTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AccSC_RLAddress">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AccSC_RLCredNo">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AccSC_RLName">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AccSC_RLPhoneNo">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AccSC_RLProof">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="AccSC_RLRemark">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="AccSC_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCACD</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHC_AccManager.AccM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>AccSC_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"AccM"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{DHC_AccManager.AccM_RowID}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"SC"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AccSC_Sub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAccStatusChangeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
