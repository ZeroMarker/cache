Class User.PHACPWMarkLab Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = ML_RowID, SqlTableName = PHACPW_MarkLab, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ML_Adm_Dr 病人就诊指针
Property MLAdmDr As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = ML_Adm_Dr ];

/// ML_Date 标注日期
Property MLDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = ML_Date ];

/// ML_Time 标注时间
Property MLTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = ML_Time ];

/// ML_DR 标注标签
Property MLDR As %Library.String [ SqlColumnNumber = 5, SqlFieldName = ML_DR ];

/// ML_User_Dr 标注用户
Property MLUserDr As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = ML_User_Dr ];

/// ML_Ward_Dr 病区ID
Property MLWardDr As User.PACWard [ SqlColumnNumber = 7, SqlFieldName = ML_Ward_Dr ];

/// ML_Dept_Dr 科室ID
Property MLDeptDr As User.CTLoc [ SqlColumnNumber = 8, SqlFieldName = ML_Dept_Dr ];

/// ML_Cancel_Flag 取消标志
Property MLCancelFlag As %Library.String [ SqlColumnNumber = 9, SqlFieldName = ML_Cancel_Flag ];

/// ML_DR 标注标签
Property MLRemark As %Library.String [ SqlColumnNumber = 10, SqlFieldName = ML_Remark ];

Storage SQLStorage
{
<Data name="PHACPWMarkLabDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MLDate</Value>
</Value>
<Value name="3">
<Value>MLTime</Value>
</Value>
<Value name="4">
<Value>MLAdmDr</Value>
</Value>
<Value name="5">
<Value>MLWardDr</Value>
</Value>
<Value name="6">
<Value>MLDeptDr</Value>
</Value>
<Value name="7">
<Value>MLDR</Value>
</Value>
<Value name="8">
<Value>MLUserDr</Value>
</Value>
<Value name="9">
<Value>MLCancelFlag</Value>
</Value>
</Data>
<DataLocation>^User.PHACPWMarkLabD</DataLocation>
<DefaultData>PHACPWMarkLabDefaultData</DefaultData>
<ExtentSize>250</ExtentSize>
<IdLocation>^User.PHACPWMarkLabD</IdLocation>
<IndexLocation>^User.PHACPWMarkLabI</IndexLocation>
<SqlIdExpression>$i(^BS.PHA.CPW.MarkLab)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ML_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ML_Cancel_Flag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ML_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ML_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ML_Dept_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ML_Remark">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ML_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ML_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ML_Ward_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^BS.PHA.CPW.MarkLab</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ML_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ML_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdmDr">
<Global>^BS.PHA.CPW.MarkLabI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ML_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AdmDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ML_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ML_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^BS.PHA.CPW.MarkLabI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ML_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ML_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ML_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^BS.PHA.CPW.MarkLabI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>ML_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ML_User_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ML_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PHACPWMarkLabS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^BS.PHA.CPW.MarkLab)
	s oldI = +$g(^mdata("PHACPWMarkLab"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^BS.PHA.CPW.MarkLab = maxI
	s ^mdata("PHACPWMarkLab") = maxI
}

}
