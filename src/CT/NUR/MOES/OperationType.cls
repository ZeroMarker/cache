/// Creator:      EH
/// CreatDate:    2021-05-06
/// Description:  操作类型表
Class CT.NUR.MOES.OperationType Extends %Persistent [ Not ProcedureBlock ]
{

/// 操作类型CODE
Property OperationCode As %String(TRUNCATE = 1);

/// 操作类型描述
Property OperationName As %String(TRUNCATE = 1);

/// Creator：      EH
/// CreatDate：    2021-05-06
/// Description:   原始数据
/// Table:		   
/// Input:   	   
/// Return:		   
/// Other:		   
ClassMethod Raw(ByRef data) As %String
{
	n (data)
	k data
	s data(1)=$lb("","Puncture","穿刺")
	s data(2)=$lb("","Change","续液")
	s data(3)=$lb("","Tour","巡视")
	s data(4)=$lb("","Extract","拔针")
	s data(5)=$lb("","Dispensing","配液")
	s data(6)=$lb("","Audit","复核")
	s data(13)=$lb("","BldReceive","输血签收")
	s data(14)=$lb("","BldCheck","输血复核")
	s data(15)=$lb("","BldStartTransfusion","输血开始")
	s data(16)=$lb("","BldTour","输血巡视")
	s data(17)=$lb("","BldEndTransfusion","输血结束")
	s data=$o(data(""),-1)
	q data
}

/// Creator：      EH
/// CreatDate：    2021-05-06
/// Description:   初始化数据
/// Table:		   
/// Input:   	   
/// Return:		   
/// Other:		   
ClassMethod Init(clear = "") As %String
{
	n (clear)
	d ..Raw(.data)
	i (clear="Y") {
		k ^CT.NUR.MOES.OperationTypeD
		m ^CT.NUR.MOES.OperationTypeD=data
	}
	q $g(data)
}

Storage Default
{
<Data name="OperationTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OperationCode</Value>
</Value>
<Value name="3">
<Value>OperationName</Value>
</Value>
</Data>
<DataLocation>^CT.NUR.MOES.OperationTypeD</DataLocation>
<DefaultData>OperationTypeDefaultData</DefaultData>
<IdLocation>^CT.NUR.MOES.OperationTypeD</IdLocation>
<IndexLocation>^CT.NUR.MOES.OperationTypeI</IndexLocation>
<StreamLocation>^CT.NUR.MOES.OperationTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
