/// Quote(2597)
Class User.ARQuote Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = AR_Quote, StorageStrategy = SQLStorage ]
{

Relationship ChildARQuoteItems As ARQuoteItems [ Cardinality = children, Inverse = ITMParRef ];

/// Surname
Property QTSurname As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = QT_Surname ];

/// GivenName
Property QTGivenName As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = QT_GivenName ];

/// Dob
Property QTDob As %Date [ SqlColumnNumber = 4, SqlFieldName = QT_Dob ];

/// Des Ref PAPMI
Property QTPAPMIDR As PAPatMas [ SqlColumnNumber = 5, SqlFieldName = QT_PAPMI_DR ];

/// PayorPlan
Property QTPayorPlan As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = QT_PayorPlan ];

/// Exp Adm Date
Property QTExpAdmDate As %Date [ SqlColumnNumber = 7, SqlFieldName = QT_ExpAdmDate ];

/// Exp LOS
Property QTExpLOS As %Float [ SqlColumnNumber = 8, SqlFieldName = QT_ExpLOS ];

/// Des Ref RoomType
Property QTRoomTypeDR As PACRoomType [ SqlColumnNumber = 9, SqlFieldName = QT_RoomType_DR ];

/// Des Ref Hospital
Property QTHospitalDR As CTHospital [ SqlColumnNumber = 10, SqlFieldName = QT_Hospital_DR ];

/// Date
Property QTDate As %Date [ SqlColumnNumber = 11, SqlFieldName = QT_Date ];

/// Time
Property QTTime As %Time [ SqlColumnNumber = 12, SqlFieldName = QT_Time ];

/// Des Ref User
Property QTUserDR As SSUser [ SqlColumnNumber = 13, SqlFieldName = QT_User_DR ];

/// Number
Property QTNumber As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = QT_Number ];

/// Des Ref PAADM
Property QTPAADMDR As PAAdm [ SqlColumnNumber = 15, SqlFieldName = QT_PAADM_DR ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^AR("QUOTE",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="QT_Date">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="QT_Dob">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="QT_ExpAdmDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="QT_ExpLOS">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="QT_GivenName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="QT_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="QT_Number">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="QT_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="QT_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="QT_PayorPlan">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="QT_RoomType_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="QT_Surname">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="QT_Time">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="QT_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^AR</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>QT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"QUOTE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{QT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^AR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>QT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"QUOTE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{QT_PAADM_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{QT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^AR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>QT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"QUOTE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{QT_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{QT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^AR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>QT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"QUOTE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({QT_Surname})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{QT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNumber">
<Global>^AR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>QT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"QUOTE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({QT_Number})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{QT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAPMI">
<Global>^AR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>QT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"QUOTE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"PAPMI"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{QT_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{QT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSurname">
<Global>^AR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>QT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"QUOTE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SGD"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({QT_Surname})</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({QT_GivenName})_" "</Expression>
</Subscript>
<Subscript name="6">
<Expression>+{QT_Dob}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{QT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>QT_RowId</SqlRowIdName>
<StreamLocation>^User.ARQuoteS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
