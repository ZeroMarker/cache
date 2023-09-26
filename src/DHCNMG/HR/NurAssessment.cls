/// Creator:liuning
/// Descriptions:科室护士考核情况
/// Date:2019-09-05
/// 
Class DHCNMG.HR.NurAssessment Extends %Persistent
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
<Value>ElecteTheory2</Value>
</Value>
<Value name="11">
<Value>ElecteTechnica2</Value>
</Value>
<Value name="12">
<Value>ElecteTheory3</Value>
</Value>
<Value name="13">
<Value>ElecteTechnica3</Value>
</Value>
<Value name="14">
<Value>ElecteTheory4</Value>
</Value>
<Value name="15">
<Value>ElecteTechnica4</Value>
</Value>
<Value name="16">
<Value>ElecteTheory5</Value>
</Value>
<Value name="17">
<Value>ElecteTechnica5</Value>
</Value>
<Value name="18">
<Value>ElecteTheory6</Value>
</Value>
<Value name="19">
<Value>ElecteTechnica6</Value>
</Value>
<Value name="20">
<Value>ElecteTheory7</Value>
</Value>
<Value name="21">
<Value>ElecteTechnica7</Value>
</Value>
<Value name="22">
<Value>ElecteTheory8</Value>
</Value>
<Value name="23">
<Value>ElecteTechnica8</Value>
</Value>
<Value name="24">
<Value>ElecteTheory9</Value>
</Value>
<Value name="25">
<Value>ElecteTechnica9</Value>
</Value>
<Value name="26">
<Value>ElecteTheory10</Value>
</Value>
<Value name="27">
<Value>ElecteTechnica10</Value>
</Value>
<Value name="28">
<Value>ElecteTheory11</Value>
</Value>
<Value name="29">
<Value>ElecteTechnica11</Value>
</Value>
<Value name="30">
<Value>ElecteTheory12</Value>
</Value>
<Value name="31">
<Value>ElecteTechnica12</Value>
</Value>
<Value name="32">
<Value>ElecteTechnical2</Value>
</Value>
<Value name="33">
<Value>ElecteTechnical3</Value>
</Value>
<Value name="34">
<Value>ElecteTechnical14</Value>
</Value>
<Value name="35">
<Value>ElecteTechnical5</Value>
</Value>
<Value name="36">
<Value>ElecteTechnical6</Value>
</Value>
<Value name="37">
<Value>ElecteTechnical7</Value>
</Value>
<Value name="38">
<Value>ElecteTechnical8</Value>
</Value>
<Value name="39">
<Value>ElecteTechnical9</Value>
</Value>
<Value name="40">
<Value>ElecteTechnical10</Value>
</Value>
<Value name="41">
<Value>ElecteTechnical11</Value>
</Value>
<Value name="42">
<Value>ElecteTechnical12</Value>
</Value>
<Value name="43">
<Value>ElecteTechnical4</Value>
</Value>
<Value name="44">
<Value>ElecteYear</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.HR.NurAssessmentD</DataLocation>
<DefaultData>NurAssessmentDefaultData</DefaultData>
<IdLocation>^DHCNMG.HR.NurAssessmentD</IdLocation>
<IndexLocation>^DHCNMG.HR.NurAssessmentI</IndexLocation>
<StreamLocation>^DHCNMG.HR.NurAssessmentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
