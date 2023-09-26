Class dhc.ca.cache.comm.DataStore Extends %Library.ListOfDataTypes [ ClassType = serial, ProcedureBlock ]
{

Property ColField As %String(TRUNCATE = 1);

Property ColSize As %Integer [ InitialExpression = 0 ];

Property Delimiter As %String(TRUNCATE = 1);

/// 获得列的数量
Method ColCount() As %Integer [ CodeMode = expression, ProcedureBlock = 1 ]
{
i%ColSize
}

/// 转换列名为第几列
Method FindColNumber(ColHead) As %Integer
{
		Set found=""
		f ColNumber=1:1:i%ColSize If $p(i%ColField,i%Delimiter,ColNumber)=ColHead Set found=ColNumber Quit
		q found
}

/// 获得一行数据，参数默认为0，为0的时候取出最后一行
Method GetRowData(RowNumber As %Integer = 0) As %String
{
		i RowNumber=0 s RowNumber=..RowCount()
		q:(RowNumber>..RowCount())!(RowNumber<1) 0
		q ..GetAt(RowNumber)
}

/// 修改一个数据格的数据，ColNumber默认为第一行，RowNumber默认为0
Method InsertCellData(Data, ColNumber As %Integer = 1, RowNumber As %Integer = 0) As %Status
{
		i RowNumber=0 s RowNumber=i%Size
		q:ColNumber>..ColCount() 0
		q:(RowNumber>..RowCount())!(RowNumber<1) 0
		s RowData=..GetAt(RowNumber)
		s $p(RowData,i%Delimiter,ColNumber)=Data
		q ..SetAt(RowData,RowNumber)
}

/// 插入一行数据
Method InsertRowData(RowData) As %Status
{
		s i%Size=i%Size+1
		s i%Data(i%Size)=RowData
		q 1
}

/// 获得行数
Method RowCount() As %Integer [ CodeMode = expression, ProcedureBlock = 1 ]
{
..Count()
}

/// 修改一个数据格的数据，ColNumber默认为第一列，RowNumber默认为0，即最后一行
Method SetCellData(Data, ColNumber As %Integer = 1, RowNumber As %Integer = 0) As %Status
{
		i RowNumber=0 s RowNumber=i%Size 
		q ..InsertCellData(Data,ColNumber,RowNumber)
}

/// 修改一行数据，当RowNumber=0的时候插入一行新的数据
Method SetRowData(RowData, RowNumber As %Integer = 0) As %Status
{
		q:RowNumber=0 ..InsertRowData(RowData)
		q:(RowNumber<1)!(RowNumber>..RowCount()+1) 0
		q ..SetAt(RowData,RowNumber)
}

Storage Custom
{
<Type>%Library.CompleteCustomStorage</Type>
}

}
