Class User.OEInsuPackOrder Extends %Persistent [ SqlTableName = OE_InsuPackOrder, StorageStrategy = SQLStorage ]
{

/// PAAdm
Property OEIPOAdmDR As PAAdm [ SqlColumnNumber = 2, SqlFieldName = OEIPO_Adm_DR ];

/// 打包名
Property OEIPOName As %String [ SqlColumnNumber = 3, SqlFieldName = OEIPO_Name ];

/// 创建人
Property OEIPOCreateUserDR As SSUser [ SqlColumnNumber = 4, SqlFieldName = OEIPO_CreateUser_DR ];

/// 创建日期
Property OEIPOCreateDate As %Date [ SqlColumnNumber = 5, SqlFieldName = OEIPO_CreateDate ];

/// 创建时间
Property OEIPOCreateTime As %Time [ SqlColumnNumber = 6, SqlFieldName = OEIPO_CreateTime ];

/// 物价码对照用户
Property OEIPOTarUserDR As SSUser [ SqlColumnNumber = 7, SqlFieldName = OEIPO_TarUser_DR ];

/// 物价码
Property OEIPOTarCode As %String [ SqlColumnNumber = 8, SqlFieldName = OEIPO_TarCode ];

/// 物价名称
Property OEIPOTarName As %String [ SqlColumnNumber = 9, SqlFieldName = OEIPO_TarName ];

/// 物价对照日期
Property OEIPOTarDate As %Date [ SqlColumnNumber = 10, SqlFieldName = OEIPO_TarDate ];

/// 物价对照时间
Property OEIPOTarTime As %Time [ SqlColumnNumber = 11, SqlFieldName = OEIPO_TarTime ];

/// 医保码指向
Property OEIPOInsuTarItemDR As INSUTarItems [ SqlColumnNumber = 12, SqlFieldName = OEIPO_InsuTarItem_DR ];

/// 医保码对照用户
Property OEIPOInsuUserDR As SSUser [ SqlColumnNumber = 13, SqlFieldName = OEIPO_InsuUser_DR ];

/// 医保码对照日期
Property OEIPOInsuDate As %Date [ SqlColumnNumber = 14, SqlFieldName = OEIPO_InsuDate ];

/// 医保码对照时间
Property OEIPOInsuTime As %Time [ SqlColumnNumber = 15, SqlFieldName = OEIPO_InsuTime ];

Storage SQLStorage
{
<SqlIdExpression>$i(^OEIPO(0))</SqlIdExpression>
<SQLMap name="AdmIndex">
<Global>^OEIPO</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEIPO_Adm_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEIPO_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="CreateDateUserIndex">
<Global>^OEIPO</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CreateDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEIPO_CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEIPO_CreateUser_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEIPO_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DataMaster">
<Data name="OEIPO_Adm_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OEIPO_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OEIPO_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OEIPO_CreateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OEIPO_InsuDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="OEIPO_InsuTarItem_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="OEIPO_InsuTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="OEIPO_InsuUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="OEIPO_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OEIPO_TarCode">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OEIPO_TarDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="OEIPO_TarName">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="OEIPO_TarTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="OEIPO_TarUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^OEIPO</Global>
<Subscript name="1">
<Expression>{OEIPO_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="InsuItemIndex">
<Global>^OEIPO</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InsuItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEIPO_InsuTarItem_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEIPO_InsuDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEIPO_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="LinkInsuDateUserIndex">
<Global>^OEIPO</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InsuDateUser"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEIPO_InsuDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEIPO_InsuUser_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEIPO_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="LinkTarDateUserIndex">
<Global>^OEIPO</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TarDateUser"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEIPO_TarDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEIPO_TarUser_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEIPO_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>OEIPO_RowID</SqlRowIdName>
<StreamLocation>^User.OEInsuPackOrderS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
