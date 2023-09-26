/// Creator:gzj
/// Date:2018-11-09
/// Description:规培生管理
Class DHCNMG.HR.MgNurNormative Extends %Persistent
{

Relationship ChildSub As DHCNMG.HR.MgNurNormativeSub [ Cardinality = children, Inverse = Parref ];

/// 护士ID
Property NurseID As DHCNMG.HR.MgPersons [ SqlColumnNumber = 2, SqlFieldName = Nurse_ID ];

/// 最高学历
Property NurseHighAcade As %String [ SqlColumnNumber = 3, SqlFieldName = Nurse_HighAcade ];

/// 学位
Property NurseDegree As %String [ SqlColumnNumber = 4, SqlFieldName = Nurse_Degree ];

/// 职称
Property NurseHireDuty As %String [ SqlColumnNumber = 5, SqlFieldName = Nurse_HireDuty ];

/// 注册日期
Property NurseRegiDate As %Date [ SqlColumnNumber = 6, SqlFieldName = Nurse_RegDate ];

/// 注册地点
Property NurseRegiPlace As %String [ SqlColumnNumber = 7, SqlFieldName = Nurse_RegPlace ];

/// 家庭成员情况
Property NurseFamily As %String [ SqlColumnNumber = 8, SqlFieldName = Nurse_Family ];

/// 父亲/母亲电话
Property NurseParentPhone As %String [ SqlColumnNumber = 9, SqlFieldName = Nurse_ParentPhone ];

/// QQ号码
Property NurseQQ As %String [ SqlColumnNumber = 10, SqlFieldName = Nurse_QQ ];

/// 年份
Property NurseYear As %Integer [ SqlColumnNumber = 11, SqlFieldName = Nurse_Year ];

/// 实习医院
Property InternHospital As %String [ SqlColumnNumber = 12, SqlFieldName = Intern_Hospital ];

/// 实习医院级别
Property InernLevel As %String [ SqlColumnNumber = 13, SqlFieldName = Inern_Level ];

/// 实习医院开始日期
Property InternStDate As %Date [ SqlColumnNumber = 14, SqlFieldName = Intern_StDate ];

/// 实习医院截止日期 
Property InternEndDate As %String [ SqlColumnNumber = 15, SqlFieldName = Intern_EndDate ];

/// 实习医院所在科室
Property InternLoc As %String [ SqlColumnNumber = 16, SqlFieldName = Intern_Loc ];

/// 本市医院
Property CityHospital As %String [ SqlColumnNumber = 17, SqlFieldName = City_Hospital ];

/// 本市医院级别
Property CityLevel As %String [ SqlColumnNumber = 18, SqlFieldName = City_Level ];

/// 本市医院开始日期
Property CityStDate As %Date [ SqlColumnNumber = 19, SqlFieldName = City_StDate ];

/// 本市医院截止日期
Property CityEndDate As %Date [ SqlColumnNumber = 20, SqlFieldName = City_EndDate ];

/// 本市医院所在科室
Property CityLoc As %String [ SqlColumnNumber = 21, SqlFieldName = City_Loc ];

/// 市外医院
Property OutSideHospital As %String [ SqlColumnNumber = 22, SqlFieldName = OutSide_Hospital ];

/// 市外医院级别
Property OutSideLevel As %String [ SqlColumnNumber = 23, SqlFieldName = OutSide_Level ];

/// 市外医院开始日期
Property OutSideStDate As %Date [ SqlColumnNumber = 24, SqlFieldName = OutSide_StDate ];

/// 市外医院截止日期
Property OutSideEndDate As %Date [ SqlColumnNumber = 25, SqlFieldName = OutSide_EndDate ];

/// 市外医院所在科室
Property OutSideLoc As %String [ SqlColumnNumber = 26, SqlFieldName = OutSide_Loc ];

/// 健康状况
Property NurseHealth As %String [ SqlColumnNumber = 27, SqlFieldName = Nurse_Health ];

Index year On (NurseYear, NurseID);

/// 
/// Property
Storage Default
{
<Data name="MgNurNormativeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NurseID</Value>
</Value>
<Value name="3">
<Value>NurseHighAcade</Value>
</Value>
<Value name="4">
<Value>NurseDegree</Value>
</Value>
<Value name="5">
<Value>NurseHireDuty</Value>
</Value>
<Value name="6">
<Value>NurseRegDate</Value>
</Value>
<Value name="7">
<Value>NurseRegPlace</Value>
</Value>
<Value name="8">
<Value>NurseFamily</Value>
</Value>
<Value name="9">
<Value>NurseFamilyPhone</Value>
</Value>
<Value name="10">
<Value>NurseParentPhone</Value>
</Value>
<Value name="11">
<Value>NurseQQ</Value>
</Value>
<Value name="12">
<Value>NurseYear</Value>
</Value>
<Value name="13">
<Value>InternHospital</Value>
</Value>
<Value name="14">
<Value>InernLevel</Value>
</Value>
<Value name="15">
<Value>InternStDate</Value>
</Value>
<Value name="16">
<Value>InternEndDate</Value>
</Value>
<Value name="17">
<Value>InternLoc</Value>
</Value>
<Value name="18">
<Value>CityHospital</Value>
</Value>
<Value name="19">
<Value>CityLevel</Value>
</Value>
<Value name="20">
<Value>CityStDate</Value>
</Value>
<Value name="21">
<Value>CityEndDate</Value>
</Value>
<Value name="22">
<Value>CityLoc</Value>
</Value>
<Value name="23">
<Value>OutSideHospital</Value>
</Value>
<Value name="24">
<Value>OutSideLevel</Value>
</Value>
<Value name="25">
<Value>OutSideStDate</Value>
</Value>
<Value name="26">
<Value>OutSideEndDate</Value>
</Value>
<Value name="27">
<Value>OutSideLoc</Value>
</Value>
<Value name="28">
<Value>NurseRegiDate</Value>
</Value>
<Value name="29">
<Value>NurseRegiPlace</Value>
</Value>
<Value name="30">
<Value>NurseHealth</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.HR.MgNurNormativeD</DataLocation>
<DefaultData>MgNurNormativeDefaultData</DefaultData>
<Description>
<![CDATA[
Property]]></Description>
<IdLocation>^DHCNMG.HR.MgNurNormativeD</IdLocation>
<IndexLocation>^DHCNMG.HR.MgNurNormativeI</IndexLocation>
<StreamLocation>^DHCNMG.HR.MgNurNormativeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
