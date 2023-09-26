Class User.DHCEQSCShareItem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SI_RowID, SqlTableName = DHC_EQSCShareItem, StorageStrategy = SQLStorage ]
{

/// 资源类型
Property SIShareType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = SI_ShareType ];

/// 代码
Property SICode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SI_Code ];

/// 描述
Property SIDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = SI_Desc ];

/// 资源项目分类
Property SIShareItemCatDR As DHCEQSCShareItemCat [ SqlColumnNumber = 5, SqlFieldName = SI_ShareItemCatDR ];

/// 院区
Property SIHospitalDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = SI_HospitalDR ];

/// 需要清洗消毒
Property SIWashFlag As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = SI_WashFlag ];

/// 需要检测
Property SIInspectFlag As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = SI_InspectFlag ];

/// 备注
Property SIRemark As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = SI_Remark ];

/// 无效标志
Property SIInvalidFlag As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = SI_InvalidFlag ];

/// hold1
Property SICHold1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = SI_Hold1 ];

/// hold2
Property SICHold2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = SI_Hold2 ];

/// hold3
Property SICHold3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = SI_Hold3 ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQSCShareItem("0"))</SqlIdExpression>
<SQLMap name="DataMap">
<Data name="SI_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SI_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SI_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SI_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SI_HospitalDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SI_InspectFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SI_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SI_ShareItemCatDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SI_ShareType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SI_WashFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCEQSCShareItem</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{SI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexShareItemCat">
<Global>^DHCEQSCShareItem</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Share"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SI_ShareType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SI_ShareItemCatDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQSCShareItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
