Class User.DHCDocCurePartGrpSet Extends (%Persistent, User.Abstract) [ SqlTableName = DHC_DocCure_PartGrpSet ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCDocCurePartGrpLinkSet As User.DHCDocCurePartGrpLinkSet [ Cardinality = children, Inverse = CPGLSParRefDr ];

/// CPGS_Code 代码
Property CPGSCode As %String [ SqlColumnNumber = 2, SqlFieldName = CPGS_Code ];

/// CPGS_Desc 描述
Property CPGSDesc As %String [ SqlColumnNumber = 3, SqlFieldName = CPGS_Desc ];

/// CPGS_Code 代码
Property CPGSAlias As %String [ SqlColumnNumber = 4, SqlFieldName = CPGS_Alias ];

/// CPGS_DefaultFlag 默认
Property CPGSDefaultFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = CPGS_DefaultFlag ];

/// CPGS_ActiveFlag 激活
Property CPGSActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = CPGS_ActiveFlag ];

/// CPGS_Type 类型 BodyPart-部位 Acupoint-穴位
Property CPGSType As %String(DISPLAYLIST = ",BodyPart,Acupoint", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",BP,A") [ SqlColumnNumber = 7, SqlFieldName = CPGS_Type ];

/// CPGS_Authority 权限类型 Hospital-医院 Dept-科室 User-个人
Property CPGSAuthority As %String(DISPLAYLIST = ",Hospital,Dept,User", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",H,D,U") [ SqlColumnNumber = 8, SqlFieldName = CPGS_Authority ];

/// CPGS_AuthKey 权限值
Property CPGSAuthKey As %String [ SqlColumnNumber = 9, SqlFieldName = CPGS_AuthKey ];

Index CPGSTypeDescIndex On (CPGSType, CPGSDesc);

Index CPGSTypeIndex On CPGSType;

Index CPGSAuthorityIndex On CPGSAuthority;

Index CPGSAuthTypeIndex On (CPGSAuthority, CPGSType);

Index CPGSTypeAuthKeyIndex On (CPGSType, CPGSAuthority, CPGSAuthKey);

Storage Default
{
<Data name="DHCDocCurePartGrpSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CPGSCode</Value>
</Value>
<Value name="3">
<Value>CPGSDesc</Value>
</Value>
<Value name="4">
<Value>CPGSAlias</Value>
</Value>
<Value name="5">
<Value>CPGSDefaultFlag</Value>
</Value>
<Value name="6">
<Value>CPGSActiveFlag</Value>
</Value>
<Value name="7">
<Value>CPGSType</Value>
</Value>
<Value name="8">
<Value>CPGSAuthority</Value>
</Value>
<Value name="9">
<Value>CPGSAuthKey</Value>
</Value>
</Data>
<DataLocation>^User.DHCDocCurePartGrpSetD</DataLocation>
<DefaultData>DHCDocCurePartGrpSetDefaultData</DefaultData>
<ExtentSize>250</ExtentSize>
<IdLocation>^User.DHCDocCurePartGrpSetD</IdLocation>
<IndexLocation>^User.DHCDocCurePartGrpSetI</IndexLocation>
<StreamLocation>^User.DHCDocCurePartGrpSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
