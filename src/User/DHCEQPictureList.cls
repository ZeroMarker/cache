Class User.DHCEQPictureList Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PL_RowID, SqlTableName = DHC_EQPictureList, StorageStrategy = SQLStorage ]
{

Property PLPictureDR As DHCEQPicture [ SqlColumnNumber = 2, SqlFieldName = PL_PictureDR ];

Property PLPicSort As %String [ SqlColumnNumber = 3, SqlFieldName = PL_PicSort ];

Property PLSuffix As %String [ SqlColumnNumber = 4, SqlFieldName = PL_Suffix ];

Property PLDefaultFlag As %String [ SqlColumnNumber = 5, SqlFieldName = PL_DefaultFlag ];

Property PLUploadUserDR As %String [ SqlColumnNumber = 6, SqlFieldName = PL_UploadUserDR ];

Property PLUploadDate As %Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = PL_UploadDate ];

Property PLUploadTime As %Time [ SqlColumnNumber = 8, SqlFieldName = PL_UploadTime ];

Property PLUpdateUserDR As %String [ SqlColumnNumber = 9, SqlFieldName = PL_UpdateUserDR ];

Property PLUpdateDate As %Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = PL_UpdateDate ];

Property PLUpdateTime As %Time [ SqlColumnNumber = 11, SqlFieldName = PL_UpdateTime ];

Property PLRemark As %String [ SqlColumnNumber = 12, SqlFieldName = PL_Remark ];

Property PLInvalidFlag As %String [ SqlColumnNumber = 13, SqlFieldName = PL_InvalidFlag ];

Property PLUpLoadFlag As %String [ SqlColumnNumber = 14, SqlFieldName = PL_UpLoadFlag ];

Property PLHold1 As %String [ SqlColumnNumber = 15, SqlFieldName = PL_Hold1 ];

Property PLHold2 As %String [ SqlColumnNumber = 16, SqlFieldName = PL_Hold2 ];

Property PLHold3 As %String [ SqlColumnNumber = 17, SqlFieldName = PL_Hold3 ];

Property PLHold4 As %String [ SqlColumnNumber = 18, SqlFieldName = PL_Hold4 ];

Property PLHold5 As %String [ SqlColumnNumber = 19, SqlFieldName = PL_Hold5 ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQPictureList("0"))</SqlIdExpression>
<SQLMap name="DATAMAster">
<Data name="PL_DefaultFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PL_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PL_PicSort">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PL_PictureDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PL_Suffix">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PL_UpLoadFlag">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PL_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PL_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PL_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PL_UploadDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PL_UploadTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PL_UploadUserDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQPictureList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>{PL_RowID}</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPicture">
<Global>^DHCEQPictureList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>{PL_RowID}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Picture"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PL_PictureDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSort">
<Global>^DHCEQPictureList</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PicSort"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PL_PictureDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PL_PicSort}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQPictureListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
