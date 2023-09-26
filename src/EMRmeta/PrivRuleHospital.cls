/// 名称:		EMRmeta.PrivRuleHospital
/// 描述:		权限与院区分组关联表
/// 编写者：	yejian
/// 编写日期: 	2021-7-2
/// 产品组：	电子病历产品组
Class EMRmeta.PrivRuleHospital Extends %Persistent
{

Index IdxPrivRule On (PrivRule, HospGroupID);

Index IdxHosGroup On HospGroupID;

/// 权限规则
Property PrivRule As EMRmeta.PrivRule;

/// 院区分组(SQLUser.CT_Hospital表HOSP_DefaultHospital_DR值)
Property HospGroupID As %String;

Storage Default
{
<Data name="PrivRuleHospitalDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PrivRule</Value>
</Value>
<Value name="3">
<Value>HospGroupID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.PrivRuleHospitalD</DataLocation>
<DefaultData>PrivRuleHospitalDefaultData</DefaultData>
<IdLocation>^DHCEMRM.PrivRuleHospitalD</IdLocation>
<IndexLocation>^DHCEMRM.PrivRuleHospitalI</IndexLocation>
<StreamLocation>^DHCEMRM.PrivRuleHospitalS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
