Class User.DHCDocRegDocAppoint Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHCDoc_RegDocAppoint ]
{

/// RDAPP_RegLoc_DR 就诊科室
Property RDAPPRegLocDR As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = RDAPP_RegLoc_DR ];

/// RDAPP_AppRes_DR 预约号别-资源
Property RDAPPAppResDR As User.RBResource [ SqlColumnNumber = 3, SqlFieldName = RDAPP_AppRes_DR ];

/// RDAPP_RegLoc_DR 就诊医生
Property RDAPPRegDocDR As User.CTCareProv [ SqlColumnNumber = 4, SqlFieldName = RDAPP_RegDoc_DR ];

/// 预约数量
Property RDAPPNumber As %String [ SqlColumnNumber = 5, SqlFieldName = RDAPP_Number ];

Index RDAPPRegLocDRIndex On RDAPPRegLocDR;

Index RDAPPRegLocDocIndex On (RDAPPRegLocDR, RDAPPRegDocDR);

Index RDAPPLocResIndex On (RDAPPRegLocDR, RDAPPAppResDR);

Index RDAPPLocDocResIndex On (RDAPPRegLocDR, RDAPPRegDocDR, RDAPPAppResDR);

Storage Default
{
<Data name="DHCDocRegDocAppointDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RDAPPRegLocDR</Value>
</Value>
<Value name="3">
<Value>RDAPPAppResDR</Value>
</Value>
<Value name="4">
<Value>RDAPPRegDocDR</Value>
</Value>
<Value name="5">
<Value>RDAPPNumber</Value>
</Value>
</Data>
<DataLocation>^User.DHCDocRegDocAppointD</DataLocation>
<DefaultData>DHCDocRegDocAppointDefaultData</DefaultData>
<IdLocation>^User.DHCDocRegDocAppointD</IdLocation>
<IndexLocation>^User.DHCDocRegDocAppointI</IndexLocation>
<StreamLocation>^User.DHCDocRegDocAppointS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
