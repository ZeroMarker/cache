/// 患者列表配置-显示信息内容
Class CT.NUR.NIS.PatientFields Extends %Persistent [ SqlTableName = PatientFields ]
{

/// Chart Parent Reference
Relationship FieldsParRef As ChartPatient [ Cardinality = parent, Inverse = ChildFields, Required, SqlFieldName = ParRef ];

/// 列名称
Property FieldName As %String [ Required, SqlColumnNumber = 2, SqlFieldName = FieldName ];

/// 列宽
Property FieldWidth As %String [ Required, SqlColumnNumber = 3, SqlFieldName = FieldWidth ];

/// 数据源 
Property FieldSourceDR As ChartDict [ Required, SqlColumnNumber = 4, SqlFieldName = FieldSourceDR ];

/// 适用区域 
Property ApplyArea As %String [ SqlColumnNumber = 5, SqlFieldName = ApplyArea ];

/// 是否是固定列 
Property IfFixedCol As %String(DISPLAYLIST = ",是,否", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = IfFixedCol ];

/// 是否是切换排序列
Property IfSortCol As %String(DISPLAYLIST = ",是,否", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = IfSortCol ];

/// 是否启用
Property IfActive As %String(DISPLAYLIST = ",是,否", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = IfActive ];

Property Sequence As %String [ SqlColumnNumber = 9, SqlFieldName = Sequence ];

Index FieldSource On (IfActive, FieldsParRef, FieldSourceDR);

Index Sequence On (IfActive, FieldsParRef, Sequence);

Storage Default
{
<Data name="PatientFieldsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FieldName</Value>
</Value>
<Value name="3">
<Value>FieldWidth</Value>
</Value>
<Value name="4">
<Value>FieldSourceDR</Value>
</Value>
<Value name="5">
<Value>ApplyArea</Value>
</Value>
<Value name="6">
<Value>IfFixedCol</Value>
</Value>
<Value name="7">
<Value>IfSortCol</Value>
</Value>
<Value name="8">
<Value>IfActive</Value>
</Value>
<Value name="9">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildFields")</DataLocation>
<DefaultData>PatientFieldsDefaultData</DefaultData>
<IdLocation>^CT.NUR.NIS.ChartPatientC("ChildFields")</IdLocation>
<IndexLocation>^CT.NUR.NIS.PatientFieldsI</IndexLocation>
<StreamLocation>^CT.NUR.NIS.PatientFieldsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
