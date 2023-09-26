Class User.DHCEmLevFunLib Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = LFL_RowID, SqlTableName = DHC_EmLevFunLib, StorageStrategy = SQLStorage ]
{

/// 代码 LFL_Code	
Property LFLCode As %Text(MAXLEN = 30) [ SqlColumnNumber = 2, SqlFieldName = LFL_Code ];

/// 描述 LFL_Desc
Property LFLDesc As %Text(MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = LFL_Desc ];

/// 类方法 LFL_Medthod	
Property LFLMedthod As %Text(MAXLEN = 100) [ SqlColumnNumber = 4, SqlFieldName = LFL_Medthod ];

/// 返回值 LFL_RetVal	
Property LFLRetVal As %Text(MAXLEN = 30) [ SqlColumnNumber = 5, SqlFieldName = LFL_RetVal ];

/// 是否可用 LFL_ActiveFlag	
Property LFLActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = LFL_ActiveFlag ];

/// 备注 LFL_Remark	
Property LFLRemark As %Text(MAXLEN = 100) [ SqlColumnNumber = 7, SqlFieldName = LFL_Remark ];

/// 集团化医院 LFL_Hosp_Dr	
Property LFLHospDr As User.CTHospital [ SqlColumnNumber = 8, SqlFieldName = LFL_Hosp_Dr ];

/// 分类id LFL_Cat_Dr	
Property LFLCatDr As User.DHCEmLevFunCat [ SqlColumnNumber = 9, SqlFieldName = LFL_Cat_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCEMLFL)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCEMLFL</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>LFL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LFL_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LFL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="LFL_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="LFL_Cat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="LFL_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LFL_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LFL_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="LFL_Medthod">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LFL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="LFL_RetVal">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEMLFL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LFL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{LFL_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEmLevFunLibS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
