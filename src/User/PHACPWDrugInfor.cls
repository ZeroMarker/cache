Class User.PHACPWDrugInfor Extends %Library.Persistent [ ClassType = persistent, Owner = {_system}, Not ProcedureBlock, SqlRowIdName = DI_RowID, SqlTableName = PHACPW_DrugInfor, StorageStrategy = SQLStorage ]
{

/// DI_FileName
Property DIFileName As %Library.String [ SqlColumnNumber = 2, SqlFieldName = DI_FileName ];

/// DI_FilePath
Property DIFilePath As %Library.String(MAXLEN = 100) [ SqlColumnNumber = 3, SqlFieldName = DI_FilePath ];

/// DI_UpPerson
Property DIUpPerson As %Library.String [ SqlColumnNumber = 4, SqlFieldName = DI_UpPerson ];

/// DI_UpDate
Property DIUpDate As %Library.Date [ SqlColumnNumber = 5, SqlFieldName = DI_UpDate ];

/// DI_UpTime
Property DIUpTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = DI_UpTime ];

/// DI_Upcontent
Property DIUpcontent As %Library.String(MAXLEN = 400) [ SqlColumnNumber = 7, SqlFieldName = DI_Upcontent ];

Storage SQLStorage
{
<Data name="PHACPWDrugInforDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DIFileName</Value>
</Value>
<Value name="3">
<Value>DIFilePath</Value>
</Value>
<Value name="4">
<Value>DIUpPerson</Value>
</Value>
<Value name="5">
<Value>DIUpDate</Value>
</Value>
<Value name="6">
<Value>DIUpTime</Value>
</Value>
<Value name="7">
<Value>DIUpcontent</Value>
</Value>
</Data>
<DataLocation>^User.PHACPWDrugInforD</DataLocation>
<DefaultData>PHACPWDrugInforDefaultData</DefaultData>
<IdLocation>^User.PHACPWDrugInforD</IdLocation>
<IndexLocation>^User.PHACPWDrugInforI</IndexLocation>
<SqlIdExpression>$i(^BS.PHA.CPW.DrugInfor)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DI_FileName">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DI_FilePath">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DI_UpDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DI_UpPerson">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DI_UpTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DI_Upcontent">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^BS.PHA.CPW.DrugInfor</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DI_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexUpDate">
<Global>^BS.PHA.CPW.DrugInforI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UpDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DI_UpDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PHACPWDrugInforS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^BS.PHA.CPW.DrugInfor)
	s oldI = +$g(^mdata("PHACPWDrugInfor"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^BS.PHA.CPW.DrugInfor = maxI
	s ^mdata("PHACPWDrugInfor") = maxI
}

}
