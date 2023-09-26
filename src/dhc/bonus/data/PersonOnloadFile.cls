/// 单元核算类型字典
Class dhc.bonus.data.PersonOnloadFile Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = PersonOnloadFileID ]
{

Property BonusEmployeeID As dhc.bonus.data.BonusEmployee [ Required, SqlColumnNumber = 2 ];

Property OnloadFileTypeID As dhc.bonus.data.OnloadFileType [ Required, SqlColumnNumber = 3 ];

Index EmpFileIdx On (BonusEmployeeID, OnloadFileTypeID);

Storage Default
{
<Data name="PersonOnloadFileDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusEmployeeID</Value>
</Value>
<Value name="3">
<Value>OnloadFileTypeID</Value>
</Value>
</Data>
<DataLocation>^dhcbsPersonOnloadFileD</DataLocation>
<DefaultData>PersonOnloadFileDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsPersonOnloadFileD</IdLocation>
<IndexLocation>^dhcbsPersonOnloadFileI</IndexLocation>
<StreamLocation>^dhcbsPersonOnloadFileS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
