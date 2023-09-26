Class User.DHCEQSCShareItemCat Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SIC_RowID, SqlTableName = DHC_EQSCShareItemCat, StorageStrategy = SQLStorage ]
{

/// 资源类型
Property SICShareType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = SIC_ShareType ];

/// 代码
Property SICCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SIC_Code ];

/// 描述
Property SICDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = SIC_Desc ];

/// 父级ID
Property SICParentDR As DHCEQSCShareItemCat [ SqlColumnNumber = 5, SqlFieldName = SIC_ParentDR ];

/// 院区
Property SICHospitalDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = SIC_HospitalDR ];

/// 备注
Property SICRemark As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = SIC_Remark ];

/// 无效标志
Property SICInvalidFlag As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = SIC_InvalidFlag ];

/// hold1
Property SICHold1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = SIC_Hold1 ];

/// hold2
Property SICHold2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = SIC_Hold2 ];

/// hold3
Property SICHold3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = SIC_Hold3 ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQSCShareItemCat("0"))</SqlIdExpression>
<SQLMap name="DataMap">
<BlockCount>1</BlockCount>
<Data name="SIC_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SIC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SIC_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SIC_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SIC_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SIC_HospitalDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SIC_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SIC_ParentDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SIC_Remark">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SIC_ShareType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQSCShareItemCat</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SIC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{SIC_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSICParent">
<BlockCount>1</BlockCount>
<Global>^DHCEQSCShareItemCat</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SIC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"parent"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SIC_ShareType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SIC_ParentDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SIC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQSCShareItemCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
