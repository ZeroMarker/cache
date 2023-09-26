/// DHCFavItems
Class User.DHCUserFavItems Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DHC_UserFavItems, StorageStrategy = SQLStorage ]
{

Property FavItemRowid As User.ARCOrdSets [ Required, SqlColumnNumber = 4, SqlFieldName = Fav_ItemRowid ];

Property FavType As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = Fav_Type ];

Property FavUserDr As SSUser [ SqlColumnNumber = 3, SqlFieldName = Fav_User_Dr ];

Property FavDepDr As CTLoc [ SqlColumnNumber = 5, SqlFieldName = Fav_Dep_Dr ];

/// 其他,可以通过控制类型来存储相应的其他的非用户和科室的关联
Property FavOther As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = Fav_Other ];

Property FavContralType As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = Fav_ContralType ];

Property FavMedUnitDr As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = Fav_MedUnit_Dr ];

Property FavHospDr As CTHospital [ SqlColumnNumber = 9, SqlFieldName = Fav_Hosp_Dr ];

Property FavCelerType As %String(DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = Fav_CelerType ];

Property FavUseHospDr As CTHospital [ SqlColumnNumber = 11, SqlFieldName = Fav_UseHosp_Dr ];

/// 开始日期
Property FavDateFrom As %Date [ SqlColumnNumber = 12, SqlFieldName = Fav_DateFrom ];

/// 截至日期
Property FavDateTo As %Date [ SqlColumnNumber = 13, SqlFieldName = Fav_DateTo ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCFavItems(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="Fav_CelerType">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="Fav_ContralType">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="Fav_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="Fav_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="Fav_Dep_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Fav_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="Fav_ItemRowid">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Fav_MedUnit_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="Fav_Other">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="Fav_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Fav_UseHosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="Fav_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCFavItems</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Fav_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{Fav_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexItemRowid">
<Global>^DHCFavItems</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Fav_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"ItemRowid"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{Fav_ItemRowid}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{Fav_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>Fav_RowId</SqlRowIdName>
<StreamLocation>^User.DHCUserFavItemsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
