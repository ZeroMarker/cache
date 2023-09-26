Class DHCWL.DM.Core.ParsedDimStruct Extends %RegisteredObject
{

Property level As %Integer;

///    32         16         8      4      2         0
///  返回主题  返回维度  方法调用   ->  访问主题  访问维度 
///     0         0         0       0      0         1      1
///     0         0         1       0      0         1      9
///     0         1         0       1      0         1     21 
///     0         1         1       1      0         1     29
///     0         0         0       0      1         0      2
///     0         0         1       0      1         0     10
///     0         1         0       1      1         0     32  
///     1         0         0       1      1         0     38
///     0         1         1       1      1         0     30
///     1         0         1       1      1         0     46
Property type As %Integer;

Property linkBase As %RegisteredObject;

Property linkBaseRowKey As %RegisteredObject;

Property visit As %RegisteredObject;

Property jdbcType As %String;

Property queryParams As %String;

Property SN As %Integer;

Property funCallStruct As ParsedFunctionCallStruct;

Property returnBase As %RegisteredObject;

Property returnBaseRowKey As %RegisteredObject;

Property next As ParsedDimStruct;

Property previous As ParsedDimStruct;

Property isVisitRelationDim As %Boolean;

Method IsVisitTheme() As %Boolean [ CodeMode = expression ]
{
( (..type=2)||(..type=10)||(..type=32)||(..type=38)||(..type=40)||(..type=46) )
}

Method IsIndirectOperation() As %Boolean [ CodeMode = expression ]
{
..next'=""
}

Method IsRelationDim() As %Boolean [ CodeMode = expression ]
{
( ..IsVisitTheme() ) && ( ..isVisitRelationDim )
}

Method IsFunctionCall() As %Boolean [ CodeMode = expression ]
{
..funCallStruct'=""
}

Method GetNext() As ParsedDimStruct [ CodeMode = expression ]
{
..next
}

Method GetPrevious() As ParsedDimStruct
{
	i ..level=1 q ""  else  q ..previous
}

Method Head() As ParsedDimStruct
{
  q:..level=1 $this
  s cur=..previous
  while(cur.level'=1){
	s cur=cur.previous
  }
  q cur
}

Method Tail() As ParsedDimStruct
{
  q:..next="" $this
  s cur=..next
  while(cur.next'=""){
    s cur=cur.next  
  }
  q cur
}

Method Close()
{
  s ..linkBase=""
  s ..linkBaseRowKey=""
  s ..visit=""
  s ..funCallStruct=""
  s ..returnBase=""
  s ..returnBaseRowKey=""
  s ..previous=""
  if (..next'=""){
    d ..next.Close()  
  }
  s ..next=""
}

}
