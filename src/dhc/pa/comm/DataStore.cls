Class dhc.pa.comm.DataStore Extends %Library.ListOfDataTypes [ ClassType = serial, ProcedureBlock ]
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

/// Creator：wang ying
/// CreatDate：2016-3-15
/// Description: 解析json串
/// Table：
/// Input：JSON串
/// Output：
/// Return：
/// Others：w ##class(dhc.pa.comm.DataStore).Test("{"status":"1","data":[{"DepDRGCount":"51","DepCMI":"0.80","DepName":"儿科","DepCode":"1480000"}],"errMSG":"1"}")
ClassMethod Test(parameters)
{
   

  s DataStr=##class(Nur.JSON).Decode(parameters)
  f i=1:1:DataStr.Count()
	{
		s subData=DataStr.GetAt(i)
		s ANALYSISDATE=subData.GetAt("AD_ANALYSISDATE")
		s No=subData.GetAt("No")
		s HISKey=subData.GetAt("HISKey")
		s ANALYSISCORP=subData.GetAt("AD_ANALYSISCORP")
		s ANALYSISIDEPT=subData.GetAt("AD_ANALYSISIDEPT")
		s NodeNo=subData.GetAt("NodeNo")
		s NodeName=subData.GetAt("NodeName")
		s TESTRESULT=subData.GetAt("AD_TESTRESULT")
		s LowNormal=subData.GetAt("LowNormal")
		s HighNormal=subData.GetAt("HighNormal")
		s OID=subData.GetAt("OID")
		
		w subData_"^"_ANALYSISDATE_"^"_No_"^"_HISKey_"^"_ANALYSISCORP_"^"_ANALYSISIDEPT_"^"_NodeNo_"^"_NodeName_"^"_TESTRESULT_"^"_LowNormal
		  _"^"_HighNormal_"^"_OID,!
		//此处添加调用保存信息的方法。 
	}
   
   q 0
}

Storage Custom
{
<Type>%Library.CompleteCustomStorage</Type>
}

}
