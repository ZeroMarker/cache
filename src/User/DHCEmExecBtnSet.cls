Class User.DHCEmExecBtnSet Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EBS_RowID, SqlTableName = DHC_EmExecBtnSet, StorageStrategy = SQLStorage ]
{

/// 执行单Code EBS_NurSheetCode
Property EBSNurSheetCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = EBS_NurSheetCode ];

/// 执行按钮描述 EBS_ShowBtn字段,配置为按钮描述，多个用逗号分隔，例：界面显示【执行】和【执行并打印】时值设置为“执行，执行并打印”
Property EBSShowBtn As %Library.String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = EBS_ShowBtn ];

/// 是否可用 Y/N
Property EBSActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = EBS_ActiveFlag ];

/// 医院 EBS_Hosp_Dr
Property EBSHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = EBS_Hosp_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCEMEBS)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EBS_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EBS_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EBS_NurSheetCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EBS_ShowBtn">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEMEBS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EBS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{EBS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCEMEBS</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EBS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IndexCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EBS_NurSheetCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EBS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>User.DHCEmExecBtnSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
