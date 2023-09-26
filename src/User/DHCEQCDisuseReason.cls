/// 功能：创建报废原因表
/// 创建日期：2022-08-23
/// 创建人：周尹淇
/// 字段 DR_RowID,DR_Code,DR_Desc,DR_Remark,DRInvalidFlag
Class User.DHCEQCDisuseReason Extends %Persistent [ SqlTableName = DHC_EQCDisuseReason, StorageStrategy = NewStorage1 ]
{

/// 代码 DR_Code
Property DRCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DR_Code ];

/// 描述 DR_Desc
Property DRDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DR_Desc ];

/// 备注 DR_Remark
Property DRRemark As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DR_Remark ];

/// DR_InvalidFlag 更新标记
Property DRInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = DR_InvalidFlag ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCDisuseReason",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DR_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DR_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DR_Remark">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"DHCEQCDisuseReason"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{DR_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DR_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQCDisuseReasonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
