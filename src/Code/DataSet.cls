Class Code.DataSet Extends %ListOfDataTypes [ ClassType = serial, ProcedureBlock ]
{

/// 插入一行数据
Method InsertRowData(RowData) As %Status
{
	s i%Size = i%Size+1
	s i%Data(i%Size) = RowData
	q 1
}

/// 获得行数
Method RowCount() As %Integer [ CodeMode = expression, ProcedureBlock = 1 ]
{
..Count()
}

/// 获得一行数据，参数默认为0，为0的时候取出最后一行
Method GetRowData(RowNumber As %Integer = 0) As %String
{
	i RowNumber=0 s RowNumber=..RowCount()
	q:(RowNumber>..RowCount())!(RowNumber<1) 0
	q ..GetAt(RowNumber)
}

Storage Custom
{
<Type>%Library.CompleteCustomStorage</Type>
}

}
