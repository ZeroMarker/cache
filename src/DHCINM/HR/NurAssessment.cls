Class DHCINM.HR.NurAssessment Extends %Persistent
{

/// 护士
Property ElecteNurse As %String [ SqlColumnNumber = 2, SqlFieldName = Electe_Nurse ];

/// 评选月份
Property ElecteDate As %Date [ SqlColumnNumber = 3, SqlFieldName = Electe_Date ];

/// 所在病区
Property ElecteWard As %String [ SqlColumnNumber = 4, SqlFieldName = Electe_Ward ];

/// 创建者
Property ElecteUser As %String [ SqlColumnNumber = 5, SqlFieldName = Electe_User ];

/// 创建日期
Property RecDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$p($h,",",1)}, Required, SqlColumnNumber = 6, SqlFieldName = RecDate ];

/// 状态【未提交：N  已提交：Y】
Property ElecteStatus As %String [ SqlColumnNumber = 7, SqlFieldName = Electe_Status ];

/// 理论1
Property ElecteTheory As %String [ SqlColumnNumber = 8, SqlFieldName = Electe_Theory ];

/// 技能1
Property ElecteTechnical As %String [ SqlColumnNumber = 9, SqlFieldName = Electe_Technical ];

/// 年度
Property ElecteYear As %String [ SqlColumnNumber = 10, SqlFieldName = Electe_Year ];

Index type On ElecteDate;

Index dep On (ElecteDate, ElecteNurse, ElecteWard);

Index sum On (ElecteNurse, ElecteYear);

Storage Default
{
<Data name="NurAssessmentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ElecteNurse</Value>
</Value>
<Value name="3">
<Value>ElecteDate</Value>
</Value>
<Value name="4">
<Value>ElecteWard</Value>
</Value>
<Value name="5">
<Value>ElecteUser</Value>
</Value>
<Value name="6">
<Value>RecDate</Value>
</Value>
<Value name="7">
<Value>ElecteStatus</Value>
</Value>
<Value name="8">
<Value>ElecteTheory</Value>
</Value>
<Value name="9">
<Value>ElecteTechnical</Value>
</Value>
<Value name="10">
<Value>ElecteYear</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HR.NurAssessmentD</DataLocation>
<DefaultData>NurAssessmentDefaultData</DefaultData>
<IdLocation>^DHCINM.HR.NurAssessmentD</IdLocation>
<IndexLocation>^DHCINM.HR.NurAssessmentI</IndexLocation>
<StreamLocation>^DHCINM.HR.NurAssessmentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
