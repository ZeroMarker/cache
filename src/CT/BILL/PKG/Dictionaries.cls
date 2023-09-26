/// 名称:  字典表
/// 描述: 存放套餐管理字典数据
/// 编写者：田志俊
/// 编写日期:  2019-09-18
/// 产品组：计费医保组
Class CT.BILL.PKG.Dictionaries Extends %Persistent [ Owner = {_PUBLIC}, SqlRowIdName = DTR_RowId, SqlTableName = Pkg_Dictionaries, StorageStrategy = SQLStorage ]
{

/// 编码
Property DTRCode As %String [ SqlColumnNumber = 2, SqlFieldName = DTR_Code ];

/// 描述
Property DTRDesc As %String [ SqlColumnNumber = 3, SqlFieldName = DTR_Desc ];

/// 创建日期
Property DTRCreatDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = DTR_CreatDate ];

/// 创建时间	
Property DTRCreatTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = DTR_CreatTime ];

/// 修改日期
Property DTRUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = DTR_UpdateDate ];

/// 修改时间	
Property DTRUpdateTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = DTR_UpdateTime ];

/// 创建人	
Property DTRCreatUser As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = DTR_CreatUser ];

/// 修改人
Property DTRUpdateUser As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = DTR_UpdateUser ];

/// 备注
Property DTRMark As %String(MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = DTR_Mark ];

/// 医院ID
Property DTRHospital As User.CTHospital [ SqlColumnNumber = 11, SqlFieldName = DTR_Hospital ];

/// 类型
Property DTRDictType As %String [ SqlColumnNumber = 12, SqlFieldName = DTR_DictType ];

/// 有效标志  Y:有效，N：作废
Property DTRActiveStatus As %String(DISPLAYLIST = ",Y,N", VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = DTR_ActiveStatus ];

Storage SQLStorage
{
<SqlIdExpression>$i(^CT.BILL.PKG.Dictionaries)</SqlIdExpression>
<SQLMap name="IndexDictType">
<Global>^CT.BILL.PKG.Dictionaries</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DTR_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DictType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DTR_DictType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DTR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDictTypeCode">
<Global>^CT.BILL.PKG.Dictionaries</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DTR_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DictTypeCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DTR_DictType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DTR_Code}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DTR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="DTR_ActiveStatus">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DTR_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DTR_CreatDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DTR_CreatTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DTR_CreatUser">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DTR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DTR_DictType">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DTR_Hospital">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DTR_Mark">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DTR_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DTR_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DTR_UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^CT.BILL.PKG.Dictionaries</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DTR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DTR_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DTR_RowId</SqlRowIdName>
<StreamLocation>^CT.BILL.PKG.DictionariesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
