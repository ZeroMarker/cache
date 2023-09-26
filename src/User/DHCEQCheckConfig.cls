Class User.DHCEQCheckConfig Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CC_RowID, SqlTableName = DHC_EQCheckConfig, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CC_ContractListDR
Property CCContractListDR As User.DHCEQContractList [ SqlColumnNumber = 2, SqlFieldName = CC_ContractListDR ];

/// CC_ConfigItemDR
Property CCConfigItemDR As User.DHCEQCConfigItem [ SqlColumnNumber = 3, SqlFieldName = CC_ConfigItemDR ];

/// CC_Value
Property CCValue As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = CC_Value ];

/// CC_Remark
Property CCRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CC_Remark ];

/// CC_Status
Property CCStatus As %Library.String(DISPLAYLIST = ",新增,修改,提交", MAXLEN = 2, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 6, SqlFieldName = CC_Status ];

/// CC_UpdateUserDR
Property CCUpdateUserDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = CC_UpdateUserDR ];

/// CC_UpdateDate
Property CCUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = CC_UpdateDate ];

/// CC_UpdateTime
Property CCUpdateTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = CC_UpdateTime ];

/// CC_CheckListDR
Property CCCheckListDR As User.DHCEQOpenCheckList [ SqlColumnNumber = 10, SqlFieldName = CC_CheckListDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCheckConfig)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CC_CheckListDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CC_ConfigItemDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CC_ContractListDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CC_Remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CC_Status">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CC_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CC_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CC_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CC_Value">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQCheckConfig</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{CC_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCheckList">
<Global>^DHCEQCheckConfig</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"CheckListDR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{CC_CheckListDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexContractList">
<Global>^DHCEQCheckConfig</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ContractListDR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{CC_ContractListDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCheckConfigS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
