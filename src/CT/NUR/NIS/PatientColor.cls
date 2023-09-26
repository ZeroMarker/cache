/// 显示信息颜色
Class CT.NUR.NIS.PatientColor Extends %Persistent [ SqlTableName = PatientColor ]
{

/// Chart Parent Reference
Relationship ColorParRef As ChartPatient [ Cardinality = parent, Inverse = ChildColor, Required, SqlFieldName = ParRef ];

/// 项目名称
Property ItemName As %String [ Required, SqlColumnNumber = 2, SqlFieldName = ItemName ];

/// 数据源 
Property ItemSourceDR As ChartDict [ Required, SqlColumnNumber = 3, SqlFieldName = ItemSourceDR ];

/// 颜色 
Property ItemColor As %String [ SqlColumnNumber = 4, SqlFieldName = ItemColor ];

/// 适用列 
Property ApplyColDR As PatientFields [ SqlColumnNumber = 5, SqlFieldName = ApplyColDR ];

/// 是否启用
Property IfActive As %String(DISPLAYLIST = ",是,否", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = IfActive ];

Index ApplyCol On (IfActive, ColorParRef, ApplyColDR);

Storage Default
{
<Data name="PatientColorDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ItemName</Value>
</Value>
<Value name="3">
<Value>ItemSourceDR</Value>
</Value>
<Value name="4">
<Value>ItemColor</Value>
</Value>
<Value name="5">
<Value>ApplyColDR</Value>
</Value>
<Value name="6">
<Value>IfActive</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildColor")</DataLocation>
<DefaultData>PatientColorDefaultData</DefaultData>
<IdLocation>^CT.NUR.NIS.ChartPatientC("ChildColor")</IdLocation>
<IndexLocation>^CT.NUR.NIS.PatientColorI</IndexLocation>
<StreamLocation>^CT.NUR.NIS.PatientColorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
