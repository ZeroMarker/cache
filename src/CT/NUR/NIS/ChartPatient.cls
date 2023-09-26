/// 患者列表配置
Class CT.NUR.NIS.ChartPatient Extends (%Persistent, User.Abstract) [ SqlTableName = ChartPatient ]
{

Relationship ChildFields As PatientFields [ Cardinality = children, Inverse = FieldsParRef ];

Relationship ChildColor As PatientColor [ Cardinality = children, Inverse = ColorParRef ];

/// 在院转科
Property IfShowTransing As %String(DISPLAYLIST = ",是,否", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 2, SqlFieldName = IfShowTransing ];

/// 显示X天内的在院转科 
Property TransDays As %String [ SqlColumnNumber = 3, SqlFieldName = TransDays ];

/// 出院
Property IfShowDischarge As %String(DISPLAYLIST = ",是,否", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = IfShowDischarge ];

/// 显示X天内的出院
Property DischargeDays As %String [ SqlColumnNumber = 5, SqlFieldName = DischargeDays ];

/// 院区
Property HospDR As User.CTHospital [ SqlColumnNumber = 6, SqlFieldName = HospDR ];

Index HOSP On HospDR;

Storage Default
{
<Data name="ChartPatientDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IfShowTransing</Value>
</Value>
<Value name="3">
<Value>TransDays</Value>
</Value>
<Value name="4">
<Value>IfShowDischarge</Value>
</Value>
<Value name="5">
<Value>DischargeDays</Value>
</Value>
<Value name="6">
<Value>HospDR</Value>
</Value>
</Data>
<DataLocation>^CT.NUR.NIS.ChartPatientD</DataLocation>
<DefaultData>ChartPatientDefaultData</DefaultData>
<IdLocation>^CT.NUR.NIS.ChartPatientD</IdLocation>
<IndexLocation>^CT.NUR.NIS.ChartPatientI</IndexLocation>
<StreamLocation>^CT.NUR.NIS.ChartPatientS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
