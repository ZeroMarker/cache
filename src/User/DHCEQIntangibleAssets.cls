Class User.DHCEQIntangibleAssets Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IA_RowID, SqlTableName = DHC_EQIntangibleAssets, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// IA_SourceType
Property IASourceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = IA_SourceType ];

/// IA_SourceID
Property IASourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = IA_SourceID ];

/// IA_TitleOfInvention 
Property IATitleOfInvention As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = IA_TitleOfInvention ];

/// IA_CertificateNo
Property IACertificateNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = IA_CertificateNo ];

/// IA_RegistrationDept
Property IARegistrationDept As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = IA_RegistrationDept ];

/// IA_RegistrationDate
Property IARegistrationDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = IA_RegistrationDate ];

/// IA_ApprovalNo
Property IAApprovalNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = IA_ApprovalNo ];

/// IA_PatentNo
Property IAPatentNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = IA_PatentNo ];

/// IA_Inventor
Property IAInventor As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = IA_Inventor ];

/// IA_AnnouncementDate
Property IAAnnouncementDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = IA_AnnouncementDate ];

/// IA_InvalidFlag
Property IAInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = IA_InvalidFlag ];

/// IA_FeatureInfo
Property IAFeatureInfo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = IA_FeatureInfo ];

/// IA_Hold1
Property IAHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = IA_Hold1 ];

/// IA_Hold2
Property IAHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = IA_Hold2 ];

/// IA_Hold3
Property IAHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = IA_Hold3 ];

/// IA_Hold4
Property IAHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = IA_Hold4 ];

/// IA_Hold5
Property IAHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = IA_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQIntangibleAssets("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="IA_AnnouncementDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="IA_ApprovalNo">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IA_CertificateNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IA_FeatureInfo">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="IA_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="IA_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="IA_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="IA_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="IA_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="IA_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="IA_Inventor">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IA_PatentNo">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IA_RegistrationDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IA_RegistrationDept">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IA_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IA_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IA_TitleOfInvention">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQIntangibleAssets</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{IA_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPatentNo">
<Global>^DHCEQIntangibleAssets</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PatentNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IA_PatentNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSource">
<Global>^DHCEQIntangibleAssets</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Source"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IA_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IA_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQIntangibleAssetsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
