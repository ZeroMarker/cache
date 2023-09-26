Class User.DHCEQCPicSourceType Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PST_RowID, SqlTableName = DHC_EQCPicSourceType, StorageStrategy = SQLStorage ]
{

Property PSTAddDate As %Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = PST_AddDate ];

Property PSTAddTime As %Time [ SqlColumnNumber = 6, SqlFieldName = PST_AddTime ];

Property PSTAddUserDR As %String [ SqlColumnNumber = 4, SqlFieldName = PST_AddUserDR ];

Property PSTInvalidflag As %String [ SqlColumnNumber = 10, SqlFieldName = PST_Invalidflag ];

Property PSTPicTypeDR As DHCEQCPicType [ SqlColumnNumber = 3, SqlFieldName = PST_PicTypeDR ];

Property PSTSourceType As %String [ SqlColumnNumber = 2, SqlFieldName = PST_SourceType ];

Property PSTUpdateDate As %Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = PST_UpdateDate ];

Property PSTUpdateTime As %Time [ SqlColumnNumber = 9, SqlFieldName = PST_UpdateTime ];

Property PSTUpdateUserDR As %String [ SqlColumnNumber = 7, SqlFieldName = PST_UpdateUserDR ];

Property PSTPicFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = PST_PicFlag ];

Property PSTAppenFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = PST_AppenFlag ];

Property PSTMustFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = PST_MustFlag ];

/// PST_ApproveSetDR
Property PSTApproveSetDR As User.DHCEQCApproveSet [ SqlColumnNumber = 14, SqlFieldName = PST_ApproveSetDR ];

/// PST_Hold1
Property PSTHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = PST_Hold1 ];

/// PST_Hold2
Property PSTHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = PST_Hold2 ];

/// PST_Hold3
Property PSTHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = PST_Hold3 ];

/// PST_Hold4
Property PSTHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = PST_Hold4 ];

/// PST_Hold5
Property PSTHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = PST_Hold5 ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCPicSourceType",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PST_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PST_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PST_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PST_AppenFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PST_ApproveSetDR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PST_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PST_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PST_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PST_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PST_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PST_Invalidflag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PST_MustFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PST_PicFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PST_PicTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PST_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PST_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PST_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PST_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<Subscript name="1">
<Expression>"DHCEQCPicSourceType"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PST_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="SourceTypeIndex">
<Global>^DHCEQCCode</Global>
<Subscript name="1">
<Expression>"DHCEQCPicSourceType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SourceTypeIndex"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PST_SourceType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PST_PicTypeDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PST_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCPicSourceTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
