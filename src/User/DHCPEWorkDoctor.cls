/// Description:工作医生
/// Creator:wangguoying
Class User.DHCPEWorkDoctor Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_WorkDoctor ]
{

Parameter ClassName = "User.DHCPEWorkDoctor";

Relationship WDParRef As User.DHCPEWorkDistributeType [ Cardinality = parent, Inverse = WDTDoctor ];

/// 医生
Property WDDoctorDR As User.SSUser [ Required, SqlColumnNumber = 2, SqlFieldName = WD_Doctor_DR ];

/// 登录科室/工作量科室
Property WDLocDR As User.CTLoc [ Required, SqlColumnNumber = 3, SqlFieldName = WD_Loc_DR ];

/// 登录安全组
Property WDGroupDR As User.SSGroup [ Required, SqlColumnNumber = 4, SqlFieldName = WD_Group_DR ];

Index ParRefDocGpLocIndex On (WDParRef, WDDoctorDR, WDGroupDR, WDLocDR) [ Unique ];

Storage Default
{
<Data name="DHCPEWorkDoctorDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WDDoctorDR</Value>
</Value>
<Value name="3">
<Value>WDLocDR</Value>
</Value>
<Value name="4">
<Value>WDGroupDR</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("WDTDoctor")</DataLocation>
<DefaultData>DHCPEWorkDoctorDefaultData</DefaultData>
<IdLocation>^User.DHCPEWorkDistributeTypeC("WDTDoctor")</IdLocation>
<IndexLocation>^User.DHCPEWorkDoctorI</IndexLocation>
<StreamLocation>^User.DHCPEWorkDoctorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
