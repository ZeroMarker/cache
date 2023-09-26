Class User.DHCPHMonScope Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHMS_RowID, SqlTableName = DHC_PHMonScope, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHMS_Code  代码
Property PHMSCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PHMS_Code ];

/// PHMS_Desc  描述
Property PHMSDesc As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHMS_Desc ];

/// PHMS_ML_DR  监护级别
Property PHMSMLDR As User.DHCPHMonLevel [ SqlColumnNumber = 4, SqlFieldName = PHMS_ML_DR ];

/// PHMS_CTLOC_DR  科室
Property PHMSCTLOCDR As User.CTLoc [ SqlColumnNumber = 5, SqlFieldName = PHMS_CTLOC_DR ];

/// PHMS_SubClass_DR  学科分类
Property PHMSSubClassDR As User.DHCPHMonSubClass [ SqlColumnNumber = 6, SqlFieldName = PHMS_SubClass_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHMS)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHMS_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHMS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHMS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHMS_ML_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHMS_SubClass_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCPHMS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHMS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHMS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLocLevel">
<Global>^DHCPHMS</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>{PHMS_RowI}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LocLevel"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHMS_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHMS_ML_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHMS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSubClassLevel">
<Global>^DHCPHMS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>{PHMS_RowID}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SubClassLevel"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHMS_SubClass_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHMS_ML_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHMS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHMonScopeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
